#include "field.h"
#include "tile.h"

#include <math.h>
#include <iostream>
#include <QVariant>
#include <QDebug>

const int cFieldSize = 28 * 31;
const int cFieldRows = 31;
const int cFieldCols = 28;
const int cMapWall = 0;
const int cMapEmpty = 1;
const int cMapDot = 2;
const int cMapEnergizer = 3;
const int cMapFruit = 4;
const int cMapDotAndWall = 5;
const int cMapEnergizerAndWall = 6;
const int cMapFruitAndWall = 7;
const int cNumbOfListItems = 2;

Field::Field(QObject *parent):
    QObject(parent),
    mTilesGrid(cFieldSize)
{
    initializeTilesGrid();
}

Field::~Field()
{
    for(auto &tile : mTilesGrid)
    {
        delete tile;
    }
}

int Field::tilesNumber() const
{
    return static_cast<int>(mTilesGrid.size());
}

void Field::initializeTilesGrid()
{
    for(auto &tile : mTilesGrid)
    {
        tile = new Tile();
    }
}

bool Field::tileIsWall(int index) const
{
    return mTilesGrid[index]->isWall();
}

bool Field::tileIsEmptyPass(int index) const
{
    return TileObject::None == mTilesGrid[index]->tileObject()
            && !mTilesGrid[index]->isWall();
}

bool Field::tileHasDot(int index) const
{
    return TileObject::Dot == mTilesGrid[index]->tileObject();
}

bool Field::tileHasEnergizer(int index) const
{
    return TileObject::Energizer == mTilesGrid[index]->tileObject();
}

bool Field::tileHasFruit(int index) const
{
    return TileObject::Fruit == mTilesGrid[index]->tileObject();
}

void Field::clearObject(int index)
{
    mTilesGrid[index]->setType(TileObject::None);
}

void Field::setTileProperty(int index, TileObject tileObject, bool isWall)
{
    mTilesGrid[index]->setWall(isWall);
    mTilesGrid[index]->setType(tileObject);
}
QList<int> Field::operIndexList() const
{
    return mOperIndexList;
}

// Returns index of tile, where our Pacman stands
int Field::getIndex(int row, int col)
{
    return row * cFieldCols + col;
}

// Returns index of tile, that is next after tile's index.
// Returns negative number, if next tile doesn't exist.
int Field::getNextIndex(int index, const QString &pDirection)
{
    int rNextIndex;

    if(!pDirection.compare("right"))
    {
        rNextIndex = index + 1;
        if(rNextIndex == cFieldCols)
        {
            rNextIndex = -1;
        }
    }
    else if(!pDirection.compare("left"))
    {
        rNextIndex = index - 1;
    }
    else if(!pDirection.compare("up"))
    {
        rNextIndex = index - cFieldCols;
    }
    else if(!pDirection.compare("down"))
    {
        rNextIndex = index + cFieldCols;
        if(rNextIndex >= cFieldSize)
        {
            rNextIndex = -1;
        }
    }
    // Else always return index of tile with wall
    else
    {
        rNextIndex = 0;
    }

    return rNextIndex;
}

void Field::setTilesGrid(const QVariantList &fieldArray)
{
    for(int index = 0; index < fieldArray.size(); ++index)
    {
        switch (fieldArray[index].toInt())
        {
        case 1:
            setTileProperty(index, TileObject::None, true);
            break;
        case 2:
            setTileProperty(index, TileObject::Dot);
            break;
        case 3:
            setTileProperty(index, TileObject::Energizer);
            break;
        case 4:
            setTileProperty(index, TileObject::Fruit);
            break;
        case 0:
        default:
            setTileProperty(index, TileObject::None);
            break;
        }
    }
}

void Field::checkPacmanState(const int pPacX, const int pPacY, const QString &pDirection)
{
    int tileWidth = 16;
    int tileHeight = 16;
    int pacRow;
    int pacColumn;
    int pacIndex;
    int nextIndex;

    mOperIndexList.clear();

    if(!pDirection.compare("right"))
    {
        int lPacRow = pPacY / tileHeight;
        float lPacCol = (pPacX * 1.0) / (tileWidth * 1.0);

        pacColumn = round(lPacCol) - 1;
        if(pacColumn < 0)
        {
            pacColumn = 0;
        }

        pacRow = lPacRow;
        pacIndex = getIndex(pacRow, pacColumn);
    }
    else if(!pDirection.compare("left"))
    {
        float lPacCol = (pPacX * 1.0) / (tileWidth * 1.0);
        int lPacRow = pPacY / tileHeight;

        // Determinating of pacColumn
        if((lPacCol - (pPacX / tileWidth)) == 0.5)
        {
            pacColumn = pPacX / tileWidth;
        }
        else
        {
            pacColumn = round(lPacCol);
        }

        pacRow = lPacRow;
        pacIndex = getIndex(pacRow, pacColumn);
    }
    else if(!pDirection.compare("up"))
    {
        float lPacRow = (pPacY * 1.0) / (tileHeight * 1.0);
        int lPacCol = pPacX / tileWidth;

        // Determinating of pacRow
        if((lPacRow - (pPacY / tileHeight)) == 0.5)
        {
            pacRow = pPacY / tileHeight;
        }
        else
        {
            pacRow = round(lPacRow);
        }

        pacColumn = lPacCol;
        pacIndex = getIndex(pacRow, pacColumn);
    }
    else if(!pDirection.compare("down"))
    {
        float lPacRow = (pPacY * 1.0) / (tileHeight * 1.0);
        int lPacCol = pPacX / tileWidth;

        pacRow = round(lPacRow) - 1;
        if(pacRow < 0)
        {
            pacRow = 0;
        }

        pacColumn = lPacCol;
        pacIndex = getIndex(pacRow, pacColumn);
    }
    // If bad argument was sent
    else
    {
        mOperIndexList << cMapWall;
        mOperIndexList << pacIndex;
        return;
    }

    // Determinating nextIndex
    nextIndex = getNextIndex(pacIndex, pDirection);

    if(tileIsWall(nextIndex))
    {
        if(tileHasDot(pacIndex))
        {
            mOperIndexList << cMapDotAndWall;
            clearObject(pacIndex);
        }
        else if(tileHasEnergizer(pacIndex))
        {
            mOperIndexList << cMapEnergizerAndWall;
            clearObject(pacIndex);
        }
        else if(tileHasFruit(pacIndex))
        {
            mOperIndexList << cMapFruitAndWall;
            clearObject(pacIndex);
        }
        else
        {
            mOperIndexList << cMapWall;
        }
    }
    else if(tileHasDot(pacIndex))
    {
        mOperIndexList << cMapDot;
        clearObject(pacIndex);
    }
    else if(tileHasEnergizer(pacIndex))
    {
        mOperIndexList << cMapEnergizer;
        clearObject(pacIndex);
    }
    else if(tileHasFruit(pacIndex))
    {
        mOperIndexList << cMapFruit;
        clearObject(pacIndex);
    }
    else
    {
        mOperIndexList << cMapEmpty;
    }

    mOperIndexList << pacIndex;
}

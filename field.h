#ifndef FIELD_H
#define FIELD_H

#include <QObject>
#include <vector>

class Tile;
enum class TileObject;

class Field: public QObject
{
    Q_OBJECT
public:
    Field(QObject* parent = 0);
    ~Field();
    Q_INVOKABLE int tilesNumber() const;
    Q_INVOKABLE bool tileIsWall(int index) const;
    Q_INVOKABLE bool tileIsEmptyPass(int index) const;
    Q_INVOKABLE bool tileHasDot(int index) const;
    Q_INVOKABLE bool tileHasEnergizer(int index) const;
    Q_INVOKABLE bool tileHasFruit(int index) const;

    Q_INVOKABLE void clearObject(int index);
    Q_INVOKABLE void setTilesGrid(const QVariantList& fieldArray);
    Q_INVOKABLE void checkPacmanState(const int pPacX, const int pPacY, const QString &pDirection);
    Q_INVOKABLE int getNextIndex(int index, const QString &pDirection);

    Q_INVOKABLE QList<int> operIndexList() const;

private:
    int getIndex(int row, int col);
    void initializeTilesGrid();
    void setTileProperty(int index, TileObject tileObject, bool isWall = false);

private:
    std::vector <Tile *> mTilesGrid;
    QList<int> mOperIndexList;
};

#endif // FIELD_H

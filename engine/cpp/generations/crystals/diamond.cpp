#include "diamond.h"
#include "../builders/atom_builder.h"
#include "../finder.h"

#include <assert.h>

Diamond::Diamond(const dim3 &sizes, int defaultSurfaceHeight) :
    Crystal(sizes), _defaultSurfaceHeight(defaultSurfaceHeight)
{
}

Diamond::~Diamond()
{
    Finder::removeAll(atoms().data(), atoms().size());
}

void Diamond::buildAtoms()
{
    for (int i = 0; i < _defaultSurfaceHeight - 1; ++i)
    {
        makeLayer(i, 24);
    }
    makeLayer(_defaultSurfaceHeight - 1, 1);
}

void Diamond::bondAllAtoms()
{
    atoms().ompParallelEach([this](Atom *atom) {
        if (!atom) return;
        assert(atom->lattice());

        int z = atom->lattice()->coords().z;
        if (z > 0)
        {
            bondWithCross110(atom);
        }

    });
}

Atom *Diamond::makeAtom(uint type, const int3 &coords)
{
    AtomBuilder builder;
    Atom *atom = builder.buildCd(type, 2, this, coords);

    int z = coords.z;
    if (z > 0 && z < _defaultSurfaceHeight - 1)
    {
        atom->activate();
        atom->activate();
    } else if (z == _defaultSurfaceHeight - 1)
    {
        atom->activate();
    }

    return atom;
}

void Diamond::findAll()
{
    Finder::findAll(atoms().data(), atoms().size(), true);
}

//void Diamond::bondWithFront110(Atom *atom)
//{
//    TN neighbours = this->front_110(this->atoms(), atom);
//    bondWithNeighbours(atom, neighbours);
//}

void Diamond::bondWithCross110(Atom *atom)
{
    auto neighbours = this->cross_110(atom);
    bondWithNeighbours(atom, neighbours);
}

void Diamond::bondWithNeighbours(Atom *atom, DiamondRelations::TN &neighbours)
{
    assert(neighbours.all());
    atom->bondWith(neighbours[0]);
    atom->bondWith(neighbours[1]);
}

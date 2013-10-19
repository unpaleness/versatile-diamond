#include "dimer.h"
#include "../handbook.h"

#include <omp.h>

#include <assert.h>

void Dimer::find(BaseSpec *parent)
{
    assert(parent);

    Atom *anchor = parent->atom(0);
    assert(anchor);

    if (!anchor->is(22)) return;
    if (!anchor->prevIs(22))
    {
        assert(anchor->lattice());

        const Diamond *diamond = dynamic_cast<const Diamond *>(anchor->lattice()->crystal());
        assert(diamond);

        auto nbrs = diamond->front_100(anchor);
        if (nbrs[0] && nbrs[0]->is(22) && anchor->hasBondWith(nbrs[0]) && nbrs[0]->hasRole(3, BRIDGE))
        {
            ushort types[2] = { 22, 22 };
            Atom *atoms[2] = { anchor, nbrs[0] };
            BaseSpec *parents[2] = { parent, nbrs[0]->specByRole(3, BRIDGE) };

            auto dimer = new Dimer(DIMER, parents, atoms);
            dimer->setupAtomTypes(types);
            dimer->findChildren();

            Handbook::storeDimer(dimer);
        }
        else return;
    }
}

void Dimer::findChildren()
{

}


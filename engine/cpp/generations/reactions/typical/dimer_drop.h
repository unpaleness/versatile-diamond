#ifndef DIMER_DROP_H
#define DIMER_DROP_H

#include "../../species/specific/dimer_cri_cli.h"
#include "../mono_typical.h"

class DimerDrop : public MonoTypical<DIMER_DROP>
{
public:
    static void find(DimerCRiCLi *target);

//    using MonoTypical::MonoTypical;
    DimerDrop(SpecificSpec *target) : MonoTypical(target) {}

    double rate() const { return 5e4; }
    void doIt();

#ifdef PRINT
    std::string name() const override { return "dimer drop"; }
#endif // PRINT

private:
    void changeAtom(Atom *atom) const;
};

#endif // DIMER_DROP_H

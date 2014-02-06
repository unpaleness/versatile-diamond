#ifndef MIGRATION_DOWN_AT_DIMER_FROM_DIMER_H
#define MIGRATION_DOWN_AT_DIMER_FROM_DIMER_H

#include "../../species/specific/dimer_crs.h"
#include "../../species/specific/methyl_on_dimer_cmsu.h"
#include "../typical.h"

class MigrationDownAtDimerFromDimer : public Typical<MIGRATION_DOWN_AT_DIMER_FROM_DIMER, 2>
{
    static const char __name[];

public:
    static const double RATE;

    static void find(DimerCRs *target);
    static void find(MethylOnDimerCMsu *target);

    MigrationDownAtDimerFromDimer(SpecificSpec **targets) : Typical(targets) {}

    void doIt() override;

    double rate() const override { return RATE; }
    const char *name() const override { return __name; }
};

#endif // MIGRATION_DOWN_AT_DIMER_FROM_DIMER_H

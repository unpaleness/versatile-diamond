#ifndef NAMES_H
#define NAMES_H

#include "../tools/common.h"

enum : ushort
{
    BASE_SPECS_NUM = 4,
    SPECIFIC_SPECS_NUM = 10,

    UBIQUITOUS_REACTIONS_NUM = 4,
    TYPICAL_REACTIONS_NUM = 10,
    LATERAL_REACTIONS_NUM = 2,

//    ALL_SPECS_NUM = BASE_SPECS_NUM + SPECIFIC_SPECS_NUM,
    ALL_SPEC_REACTIONS_NUM = TYPICAL_REACTIONS_NUM + LATERAL_REACTIONS_NUM
};

enum BaseSpecNames : ushort
{
    BRIDGE,
    DIMER,
    METHYL_ON_DIMER,
    METHYL_ON_BRIDGE
};

enum SpecificSpecNames : ushort
{
    BRIDGE_CTsi = BASE_SPECS_NUM,
    BRIDGE_CRs,
    BRIDGE_CRs_CTi_CLi,
    DIMER_CRi_CLi,
    DIMER_CRs,
    METHYL_ON_DIMER_CMu,
    METHYL_ON_DIMER_CMsu,
    METHYL_ON_DIMER_CLs_CMu,
    METHYL_ON_BRIDGE_CBi_CMu,
    HIGH_BRIDGE
};

enum TypicalReactionNames : ushort
{
    DIMER_FORMATION,
    DIMER_FORMATION_NEAR_BRIDGE,
    DIMER_DROP,
    ADS_METHYL_TO_DIMER,
    METHYL_ON_DIMER_HYDROGEN_MIGRATION,
    METHYL_TO_HIGH_BRIDGE,
    HIGH_BRIDGE_STAND_TO_ONE_BRIDGE,
    DES_METHYL_FROM_BRIDGE,
    NEXT_LEVEL_BRIDGE_TO_HIGH_BRIDGE,
    HIGH_BRIDGE_STAND_TO_TWO_BRIDGES
};

enum LateralReactionNames : ushort
{
    DIMER_FORMATION_AT_END = TYPICAL_REACTIONS_NUM,
    DIMER_FORMATION_IN_MIDDLE
};

enum UbiquitousReactionNames : ushort
{
    SURFACE_ACTIVATION = ALL_SPEC_REACTIONS_NUM,
    SURFACE_DEACTIVATION,
    METHYL_ON_DIMER_ACTIVATION,
    METHYL_ON_DIMER_DEACTIVATION
};

#endif // NAMES_H

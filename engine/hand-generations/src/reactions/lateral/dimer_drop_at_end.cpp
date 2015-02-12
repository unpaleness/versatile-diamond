#include "dimer_drop_at_end.h"
#include "../../species/sidepiece/dimer.h"

const char DimerDropAtEnd::__name[] = "dimer drop at end of dimers row";

double DimerDropAtEnd::RATE()
{
    static double value = getRate("DIMER_DROP_AT_END");
    return value;
}

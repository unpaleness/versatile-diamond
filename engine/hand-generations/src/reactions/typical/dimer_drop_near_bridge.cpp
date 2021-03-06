#include "dimer_drop_near_bridge.h"

const char DimerDropNearBridge::__name[] = "dimer drop near bridge";

double DimerDropNearBridge::RATE()
{
    static double value = getRate("DIMER_DROP_NEAR_BRIDGE");
    return value;
}

void DimerDropNearBridge::find(BridgeWithDimerCDLi *target)
{
    create<DimerDropNearBridge>(target);
}

void DimerDropNearBridge::doIt()
{
    assert(target()->type() == BridgeWithDimerCDLi::ID);

    Atom *atoms[2] = { target()->atom(6), atoms[1] = target()->atom(9) };
    Atom *a = atoms[0], *b = atoms[1];

    assert(a->is(20));
    assert(b->is(32));

    a->unbondFrom(b);

    if (a->is(21)) a->changeType(2);
    else a->changeType(28);

    b->changeType(5);

    Finder::findAll(atoms, 2);
}

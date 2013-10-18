#include "generations/handbook.h"
#include "generations/crystals/diamond.h"
using namespace vd;

#include "spec/support/open_diamond.h"

#include <omp.h>
#include <iostream>
using namespace std;

int main()
{
    Diamond *diamond = new OpenDiamond(2);
//    Diamond *diamond = new Diamond(dim3(100, 100, 20), 10);
    diamond->initialize();

    cout << Handbook::specsNum() << endl;
    assert(Handbook::specsNum() == 100);

    cout << Handbook::mc().totalRate() << endl;

    Atom *a = diamond->atom(int3(2, 2, 1)), *b = diamond->atom(int3(2, 3, 1));
    ReactionActivation raa(a);
    raa.doIt();
    assert(Handbook::specsNum() == 101);

    ReactionActivation rab(b);
    rab.doIt();
    assert(Handbook::specsNum() == 102);

    a->bondWith(b);

    a->changeType(22);
    b->changeType(22);

    a->findChildren();
    b->findChildren();

    cout << Handbook::specsNum() << endl;
    assert(Handbook::specsNum() == 103);

    cout << Handbook::mc().totalRate() << endl;

    Atom *c = diamond->atom(int3(4, 2, 1));
    ReactionActivation rac(c);
    rac.doIt();
    rac.doIt();

    cout << Handbook::specsNum() << endl;
    assert(Handbook::specsNum() == 104);

    Handbook::purge();
    delete diamond;
    return 0;
}

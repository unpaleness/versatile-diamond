#include "mono_spec_reaction.h"
#include "../species/reactions_mixin.h"

#ifdef PRINT
#include <iostream>
#endif // PRINT

namespace vd
{

void MonoSpecReaction::removeFrom(ReactionsMixin *target)
{
    assert(_target == target);

    target->unbindFrom(this);
    remove();
}

#ifdef PRINT
void MonoSpecReaction::info()
{
    std::cout << "MonoSpecReaction " << name() << " [" << this << "]: ";
    target()->atom(0)->info();
    std::cout << std::endl;
}
#endif // PRINT

}

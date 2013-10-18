#ifndef REACTION_ACTIVATION_H
#define REACTION_ACTIVATION_H

#include "ubiquitous_reaction.h"

class ReactionActivation : public UbiquitousReaction
{
    static const ushort __hToActives[];
    static const ushort __hOnAtoms[];

public:
    static void find(Atom *anchor);

    using UbiquitousReaction::UbiquitousReaction;

    double rate() const { return 3600; }

protected:
    short toType(ushort type) const override;
    void action() override { target()->activate(); }
    void remove() override;
};

#endif // REACTION_ACTIVATION_H

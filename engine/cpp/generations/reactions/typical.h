#ifndef TYPICAL_H
#define TYPICAL_H

#include "../../atoms/crystal_atoms_iterator.h"
using namespace vd;

#include "../handbook.h"

template <class B, ushort RT>
class Typical : public B, public CrystalAtomsIterator
{
public:
//    using B::B;
    template <class... Args>
    Typical(Args... args) : B(args...) {}

    ushort type() const override { return RT; }

    void store() override;

protected:
    void remove() override;
};

template <class B, ushort RT>
void Typical<B, RT>::store()
{
    Handbook::mc().add(this);
}

template <class B, ushort RT>
void Typical<B, RT>::remove()
{
    Handbook::mc().remove(this);
    Handbook::scavenger().markReaction<RT>(this);
}

#endif // TYPICAL_H

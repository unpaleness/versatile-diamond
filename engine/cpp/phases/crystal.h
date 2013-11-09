#ifndef CRYSTAL_H
#define CRYSTAL_H

#include "../tools/common.h"
#include "../tools/vector3d.h"
#include "phase.h"

namespace vd
{

class Crystal : public Phase
{
    typedef vector3d<Atom *> Atoms;
    Atoms _atoms;

public:
    Crystal(const dim3 &sizes);
    ~Crystal() override;

    void initialize();

    void insert(Atom *atom, const int3 &coords);
    void erase(Atom *atom) override;

    Atom *atom(const int3 &coords) const { return _atoms[coords]; }

    uint countAtoms() const;
    const dim3 &sizes() const { return _atoms.sizes(); }

protected:
    virtual void buildAtoms() = 0;
    virtual void bondAllAtoms() = 0;
    virtual void findAll() = 0;

    virtual Atom *makeAtom(uint type, const int3 &coords) = 0;

    void makeLayer(uint z, uint type);

    const Atoms &atoms() const { return _atoms; }
    Atoms &atoms() { return _atoms; }

//    Atom *atom(const int3 &coords) { return _atoms[coords]; }
};

}

#endif // CRYSTAL_H

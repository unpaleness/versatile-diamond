#ifndef REACTION_H
#define REACTION_H

#include "../atoms/atom.h"

namespace vd
{

class Reaction
{
public:
    virtual ~Reaction() {}

    virtual ushort type() const = 0;

    virtual double rate() const = 0;
    virtual void doIt() = 0;

#ifdef PRINT
    virtual void info(std::ostream &os) = 0;
#endif // PRINT

    virtual const char *name() const = 0;

protected:
    Reaction() = default;
};

}

#endif // REACTION_H

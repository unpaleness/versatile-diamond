#ifndef LOCK_H
#define LOCK_H

#include <omp.h>

namespace vd
{

class Lockable
{
    omp_lock_t _lock;

public:
    Lockable();
    ~Lockable();

protected:
    template <class L>
    void lock(const L &lambda);
};

template <class L>
void Lockable::lock(const L &lambda)
{
    omp_set_lock(&_lock);
    lambda();
    omp_unset_lock(&_lock);
}

}

#endif // LOCK_H

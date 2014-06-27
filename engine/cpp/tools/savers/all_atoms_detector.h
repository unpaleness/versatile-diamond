#ifndef ALL_ATOMS_DETECTOR_H
#define ALL_ATOMS_DETECTOR_H

#include "../../atoms/atom.h"
#include "detector.h"

namespace vd {

class AllAtomsDetector : public Detector
{
public:
    AllAtomsDetector() = default;
    bool isBottom(const Atom *atom) const;
};

}

#endif // ALL_ATOMS_DETECTOR_H

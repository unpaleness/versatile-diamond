#ifndef MPI_CONFIG_H
#define MPI_CONFIG_H

#include "../tools/yaml_config_reader.h"

namespace vd
{

class MPIConfig
{
    static YAMLConfigReader __config;

public:
    static uint nFragments();
};

}

#endif // MPI_CONFIG_H

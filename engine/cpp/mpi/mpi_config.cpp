#include "mpi_config.h"

YAMLConfigReader MPIConfig::__config("configs/mpi.yml");

uint MPIConfig::nFragments()
{
    static uint value = __config.read<uint>("nFragments");
    return value;
}

#ifndef MPI_RUNNER_H
#define MPI_RUNNER_H

#include "../tools/init_config.h"
#include "mpi_config.h"

/*
 * MPIRunner runs as more runners as amount of pieces-fragments-threads
 * of crystal lattice we have. It recieves Handbook as normal Runner does.
 */

template <class HB>
class MPIRunner
{
public:
    MPIRunner(const InitConfig &init, const MPIConfig &mpi);
    ~MPIRunner();

private:
    InitConfig _init;
    MPIConfig _mpi;
    Runner<Handbook> **_runners; // pointers to Runners of each fragment
};

MPIRunner::MPIRunner(const InitConfig &init, const MPIConfig &mpi)
{
}

MPIRunner::~MPIRunner()
{
}

#endif // MPI_RUNNER_H

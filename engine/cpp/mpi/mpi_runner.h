#ifndef MPI_RUNNER_H
#define MPI_RUNNER_H

#include "../tools/init_config.h"
#include "mpi_config.h"
#include <mpi.h>

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

    void mpiRun();

private:
    const InitConfig &_init;
    const MPIConfig &_mpi;
    Runner<Handbook> *_runner; // runner for current thread
    int _nMPIThreads;          // total amount of mpi-proccesses
    int _mpiRank;              // id of current mpi-proccess
};

MPIRunner::MPIRunner(const InitConfig &init, const MPIConfig &mpi)
{
    _init = init;
    _mpi = mpi;
    MPI_Comm_rank(MPI_COMM_WORLD, &_mpiRank);
    MPI_Comm_size(MPI_COMM_WORLD, &_nMPIThreads);
}

MPIRunner::~MPIRunner()
{
}

void MPIRunner::mpiRun()
{
    if(_mpiRank == 0) // control proccess
    {
        // TODO: optimal splitting
    }
    else
    {
        // TODO: recieving data for optimal splitting and initializing runner
    }
}

#endif // MPI_RUNNER_H

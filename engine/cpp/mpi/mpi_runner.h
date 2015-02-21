#ifndef MPI_RUNNER_H
#define MPI_RUNNER_H

#include "run.h"
#include "init_config.h"
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
  Runner <Handbook> **_runners;

};

#endif // MPI_RUNNER_H

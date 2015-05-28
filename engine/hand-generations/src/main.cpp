#include <signal.h>
#include <tools/init_config.h>
// #include <mpi/mpi_runner.h>
#include <tools/runner.h>
#include "handbook.h" // todo: remove it from final version

using namespace vd;

void stopSignalHandler(int)
{
    Runner<Handbook>::stop();
}

int main(int argc, char *argv[])
{
    std::cout.precision(3);

    if (argc < 6 || argc > 9)
    {
        std::cerr << "Wrong number of run arguments!" << std::endl;
        std::cout << "Try: "
                  << argv[0]
                  << " run_name X Y total_time save_each_time [out_format] [detector_type] [behaviour_type]"
                  << std::endl;
        return 1;
    }

    signal(SIGINT, stopSignalHandler);
    signal(SIGTERM, stopSignalHandler);

    // initialize parallel implementation
    // MPI_Init(&argc, &argv);
    // int nMPIThreads;
    // MPI_Comm_size(MPI_COMM_WORLD, &nMPIThreads);
    // if(nMPIThreads < 3)
    // {
    //     std::cerr << "Too few threads! Program terminates." << std::endl;
    //     return 1;
    // }

    try
    {
        const InitConfig init(argc, argv);
        Runner<Handbook> runner(init);
        runner.calculate();
    }
    catch (Error error)
    {
        std::cerr << "Run error:\n  " << error.message() << std::endl;
    }

    // finalize parallel implementation
    // MPI_Finalize();

    return 0;
}

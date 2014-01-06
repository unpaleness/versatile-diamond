#include <signal.h>
#include <omp.h>
#include <iostream>
#include "mc/common_mc_data.h"
#include "generations/handbook.h"
#include "generations/phases/diamond.h"

volatile bool stopCalculating = false;
void stopSignalHandler(int)
{
#ifdef PARALLEL
#pragma omp master
#endif // PARALLEL
    stopCalculating = true;
}

#ifdef PRINT
void printSeparator()
{
    debugPrint([&](std::ostream &os) {
        os << Handbook::mc().totalRate();
    });
}
#endif // PRINT

int main()
{
    signal(SIGINT, stopSignalHandler);
    signal(SIGTERM, stopSignalHandler);

    RandomGenerator::init(); // it must be called just one time at program begin (before init CommonMCData!)

#ifdef PARALLEL
    omp_set_num_threads(THREADS_NUM);
#endif // PARALLEL

#ifdef PRINT
    debugPrint([&](std::ostream &os) {
#ifdef PARALLEL
        os << "Start as PARALLEL mode";
#else
        os << "Start as SINGLE THREAD mode";
#endif // PARALLEL
    });
#endif // PRINT

// ------------------------------------------------------------------------------------------------------------------ //

    double totalTime = 0.5;

//    Diamond *diamond = new Diamond(dim3(100, 100, 50));
    Diamond *diamond = new Diamond(dim3(20, 20, 20));
    diamond->initialize();

// ------------------------------------------------------------------------------------------------------------------ //

    std::cout << "Atoms num: " << diamond->countAtoms() << std::endl;

#ifdef PRINT
    printSeparator();
#endif // PRINT

    ullong n = 0;
    CommonMCData mcData;
    Handbook::mc().initCounter(&mcData);

#ifdef PARALLEL
#pragma omp parallel
#endif // PARALLEL
    while (!stopCalculating && Handbook::mc().totalTime() < totalTime)
    {
        Handbook::mc().doRandom(&mcData);
        if (stopCalculating) break;

#ifdef PRINT
        debugPrint([&](std::ostream &os) {
            os << n << ". " << Handbook::mc().totalRate() << "\n";
        });
#endif // PRINT

#ifdef PARALLEL
#pragma omp atomic
#endif // PARALLEL
        ++n;
    }

    std::cout << "Atoms num: " << diamond->countAtoms() << "\n"
              << "Rejected events rate: " << 100 * (1 - (double)mcData.counter()->total() / n) << " %\n"
              << std::endl;
    mcData.counter()->printStats();

    Handbook::amorph().clear(); // TODO: should not be explicitly!
    delete diamond;
    return 0;
}

# SubmitScript

## How to use SubmitScript

* Add this dir to your path

    ```bash
    export PATH="{path_to_ETK-Compile-Guides}/SubmitScript:$PATH"
    ```

* There two ways to use this script

    - specify parameters in commaned line

        * run
            ```
            SubmitJobs -n <num_jobs> -e <executable> -p <param_file> -N <nodes> -m <mpi_tasks> -o <omp_threads> -w <wall_time> -q <queue> -a <allocation> [-j <job_name>]
            ```

    - specify parameters through a SubScript

        * copy example `subscript` to your simulation directory

        * modify the parameters accordingly

        * run

            ```
            SubmitJobs -n <num_jobs> -e <executable> -p <param_file> -s <subscript> [-j <job_name>]
            ```

* Run the following for help infos

    ```
    SubmitJobs --help
    ```


## macOS (no scheduler)

* macOS is detected via `$OSTYPE` (a Mac's `$HOSTNAME` is not stable), and the job runs in the foreground with `mpirun` instead of being submitted to a scheduler

* `-m` is required (mapped to `mpirun -np`), `-n` must be `1` (no job chaining), and the scheduler-only options `-N`, `-t`, `-q`, `-a` are ignored

* copy `example/macos/subscript` next to your parameter file, then run e.g.

    ```
    SubmitJobs -n 1 -e cactus_etk -p params.par -m 4 -o 2 -s subscript
    ```

## Add configs for a new machine

* add new `elif` section in the `main` function

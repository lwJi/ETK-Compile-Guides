# SubmitScript

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

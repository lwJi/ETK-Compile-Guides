# SubmitScript

* Add this dir to your path

    ```bash
    export PATH="{path_to_ETK-Compile-Guides}/SubmitScript:$PATH"
    ```

* There two ways to use this script

    - specify parameters in commaned line

    - specify parameters through a SubScript

        * copy example `subscript` to your simulation directory

        * modify the parameters accordingly

        * run

            ```
            SubmitJobs <num_jobs> <executable> <param_file> subscript [job_name]
            ```

* Run the following for help infos

    ```
    SubmitJobs --help
    ```

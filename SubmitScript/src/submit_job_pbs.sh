#!/bin/bash

# Submit job using PBS
submit_job_pbs() {
    # Default value for last job ID if no dependency is provided
    local last_job_id=${dependent_job_id:-NoPreviousJob}

    # Loop through the number of jobs to be submitted
    for ((i = 1; i <= num_jobs; i++)); do
        # Start building the qsub command
        local submit_command="qsub -N $job_name \
                                   -o stdout.txt \
                                   -e stderr.txt"

        # Add resource-specific arguments if provided
        [[ -n "$num_omp_threads" ]] && export OMP_NUM_THREADS=$num_omp_threads

        if [[ -n "$num_nodes" && -z "$num_mpi_tasks" ]]; then
            submit_command+=" -l select=$num_nodes:ncpus=$num_mpi_tasks"
        fi

        [[ -n "$wall_time" ]] && submit_command+=" -l walltime=$wall_time"
        [[ -n "$queue_name" ]] && submit_command+=" -q $queue_name"
        [[ -n "$allocation_name" ]] && submit_command+=" -A $allocation_name"

        # Add job dependency if applicable
        [[ $last_job_id != "NoPreviousJob" ]] && submit_command+=" -W depend=afterany:$last_job_id"

        # Add the job script
        submit_command+=" $subscript"

        # Log and execute the qsub command
        echo
        echo "Executing qsub command:"
        execute_command $submit_command | tee "${job_name}.last-qsub"

        # Capture the last job ID from qsub output
        last_job_id=$(tail -n 1 "${job_name}.last-qsub" | awk '{ print $NF }')
    done
}

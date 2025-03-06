#!/bin/bash

# Function to submit jobs using Slurm
submit_job_slurm() {
    # Default value for last job ID if no dependency is provided
    local last_job_id=${dependent_job_id:-NoPreviousJob}

    # Loop through the number of jobs to be submitted
    for ((i = 1; i <= num_jobs; i++)); do
        # Start building the sbatch command
        local submit_command="sbatch -J $job_name \
                                     -o stdout.txt \
                                     -e stderr.txt"

        # Add resource-specific arguments if provided
        [[ -n "$num_omp_threads" ]] && export OMP_NUM_THREADS=$num_omp_threads
        [[ -n "$num_nodes" ]] && submit_command+=" -N $num_nodes"
        [[ -n "$num_mpi_tasks" ]] && submit_command+=" -n $num_mpi_tasks"
        [[ -n "$wall_time" ]] && submit_command+=" -t $wall_time"
        [[ -n "$queue_name" ]] && submit_command+=" -p $queue_name"
        [[ -n "$allocation_name" ]] && submit_command+=" -A $allocation_name"

        # Add job dependency if applicable
        [[ $last_job_id != "NoPreviousJob" ]] && submit_command+=" -d afterany:$last_job_id"

        # Add the job script
        submit_command+=" $subscript"

        # Log and execute the sbatch command
        echo
        echo "Executing sbatch command:"
        execute_command $submit_command | tee "${job_name}.last-sbatch"

        # Capture the last job ID from sbatch output
        last_job_id=$(tail -n 1 "${job_name}.last-sbatch" | awk '{ print $NF }')
    done
}

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

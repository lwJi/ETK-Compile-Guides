#!/bin/bash

# ----------------
# Global Functions
# ----------------

# Execute and print the command
execute_command() {
    echo "\$ $@"
    "$@"
}
export -f execute_command

# Generate a new directory name for a job
generate_new_directory_name() {
    # Base name for the new directory
    local base_name="${1}_r"

    # Check for existing directories matching the pattern
    if compgen -G "${base_name}[0-9][0-9][0-9][0-9]" > /dev/null; then
        # Find the highest-numbered directory
        local last_run=$(ls -d ${base_name}[0-9][0-9][0-9][0-9] 2>/dev/null | sort -V | tail -n 1)

        # Extract the numeric part of the last directory and increment it
        local last_index=${last_run##*${base_name}}
        local next_index=$((10#$last_index + 1))

        # Format the new index as a 4-digit number
        printf -v formatted_index "%04d" $next_index
        echo "${base_name}${formatted_index}"
    else
        # Default to the first directory if no matches
        echo "${base_name}0000"
    fi
}
export -f generate_new_directory_name

# Create a new job directory, move files inside, and launch jobs
create_and_organize_job_directory_and_launch_jobs() {
    local param_file=$1
    local job_name=$2
    local job_id=$3

    # Validate input arguments
    if [[ -z "$param_file" || -z "$job_name" || -z "$job_id" ]]; then
        echo "Error: Missing required arguments. Usage: create_and_organize_job_directory_and_launch_jobs <param_file> <job_name> <job_id>"
        exit 1
    fi

    # Generate a new directory name
    local job_output_dir=${SUBMITJOBS_JOBOUTPUTDIR}

    execute_command mkdir -p "$job_output_dir" || { echo "Error: Failed to create directory $job_output_dir"; exit 1; }
    execute_command cp "$param_file" "$job_output_dir" || { echo "Error: Failed to copy $param_file to $job_output_dir"; exit 1; }
    # execute_command mv stdout.txt "$job_output_dir" 2>/dev/null || echo "Warning: stdout.txt not found"
    # execute_command mv stderr.txt "$job_output_dir" 2>/dev/null || echo "Warning: stderr.txt not found"
    # execute_command mv "$job_name.o$job_id" "$job_output_dir" 2>/dev/null || echo "Warning: $job_name.o$job_id not found"
    # execute_command mv "$job_name.e$job_id" "$job_output_dir" 2>/dev/null || echo "Warning: $job_name.e$job_id not found"

    execute_command cd "$job_output_dir" || { echo "Error: Failed to change directory to $job_output_dir"; exit 1; }

    # Launch jobs
    echo "======================================================================"
    echo "Launch MPI code..."
    echo "----------------------------------------------------------------------"
    echo "MPIRUN = $SUBMITJOBS_MPIRUN"
    echo
    echo "Job started on $(hostname) at $(date)"
    echo "======================================================================"

    time $SUBMITJOBS_MPIRUN

    if [ $? -ne 0 ]; then
      echo "Error: MPI job failed."
      exit 1
    fi

    echo "======================================================================"
    echo "Job Ended at $(date)"
}
export -f create_and_organize_job_directory_and_launch_jobs

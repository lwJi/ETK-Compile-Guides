#!/bin/bash

# Function to echo and execute a command
run_command() {
  echo "\$ $@"
  #"$@"
}

echo "Compile-ETK (c) 2024 Liwei Ji"

# Default values for compilation
executable_name="etk"
thorn_list="thornlists/asterx.th"
config_file="${ETKGUIDE}/gcc/vista.cfg"
perform_fresh_compile=0

# Display usage instructions
display_usage() {
  echo "Usage: Compile-ETK.sh [options] [executable thorn_list config_file]"
  echo "Options:"
  echo "  -h, --help          Show this help message and exit"
  echo "  --fresh             Perform a fresh compilation"
  echo "Defaults:"
  echo "  executable          = $executable_name"
  echo "  thorn_list          = $thorn_list"
  echo "  config_file         = $config_file"
}

# Parse arguments
positional_args=() # Array to store positional arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      display_usage
      exit 0
      ;;
    --fresh)
      perform_fresh_compile=1
      shift
      ;;
    *)
      # Treat anything else as a positional argument
      positional_args+=("$1")
      shift
      ;;
  esac
done

# Assign positional arguments to variables
if [[ ${#positional_args[@]} -ge 1 ]]; then
  executable_name="${positional_args[0]}"
fi
if [[ ${#positional_args[@]} -ge 2 ]]; then
  thorn_list="${positional_args[1]}"
fi
if [[ ${#positional_args[@]} -ge 3 ]]; then
  config_file="${positional_args[2]}"
fi

# Main script logic
if [[ $perform_fresh_compile -eq 1 ]]; then
  echo "Performing a fresh compile for '$executable_name'..."
  run_command rm -rf "configs/$executable_name"
  run_command gmake "$executable_name" options="$config_file"
  run_command cp "$thorn_list" "configs/$executable_name/ThornList"
fi

echo "Compiling '$executable_name' with $config_file..."
run_command gmake -j24 "$executable_name"

echo "Compile-ETK script completed."

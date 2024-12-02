#!/bin/bash

# Function to echo and execute a command
run_command() {
  echo "\$ $@"
  "$@"
}

echo "Compile-ETK (c) 2024 Liwei Ji"

# Default values
executable_name="etk"
thorn_list="thornlists/asterx.th"
config_file="${ETKGUIDE}/gcc/vista.cfg"
perform_fresh_compile=0

# Display usage instructions
display_usage() {
  echo "Usage: compile_etk [options]"
  echo "Options:"
  echo "  -h, --help              Show this help message and exit"
  echo "  --fresh                 Perform a fresh compilation"
  echo "  -exe=<executable>       Specify the executable name (default: $executable_name)"
  echo "  -thornlist=<thorn_list> Specify the thorn list file (default: $thorn_list)"
  echo "  -config=<config_file>   Specify the configuration file (default: $config_file)"
  echo
  echo "All arguments are optional. If not specified, default values are used."
}

# Parse arguments
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
    -exe=*)
      executable_name="${1#*=}"
      shift
      ;;
    -thornlist=*)
      thorn_list="${1#*=}"
      shift
      ;;
    -config=*)
      config_file="${1#*=}"
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      display_usage
      exit 1
      ;;
  esac
done

# Main script logic
if [[ $perform_fresh_compile -eq 1 ]]; then
  echo "Performing a fresh compile for '$executable_name'..."

  # Check if config path exists
  config_path="configs/$executable_name"
  if [[ -d "$config_path" ]]; then
    echo "Removing existing directory: $config_path"
    run_command rm -rf "$config_path"
  fi

  run_command gmake "$executable_name" options="$config_file"
  run_command cp "$thorn_list" "configs/$executable_name/ThornList"
fi

echo "Compiling '$executable_name' with $config_file..."
run_command gmake -j24 "$executable_name"

echo "Compile-ETK script completed."

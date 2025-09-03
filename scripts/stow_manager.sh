#!/bin/bash

# Function to create directories
create_dirs() {
  local device=$1
  local package=$2
  for dir in $(find $device/$package/ -type d | sed "s|^$device/$package/||"); do
    echo "Creating directory (if not already present): ~/$dir"
    mkdir -p ~/$dir
  done
}

# Function to get defer files
get_defer_files() {
  local device=$1
  local package=$2
  local defer_files=""
  for file in $(find $device/$package -type f | sed "s|^$device/$package/||"); do
    defer_files+="^$file\$|"
  done
  local df=$(echo $defer_files | sed 's/|$//')
  echo "$df"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --create)
      create_flag=1
      shift
      ;;
    --update)
      update_flag=1
      shift
      ;;
    --delete)
      delete_flag=1
      shift
      ;;
    -d|--device)
      device="$2"
      shift
      shift
      ;;
    -p|--package)
      package="$2"
      shift
      shift
      ;;
    *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
done

# Check for multiple flags
if [[ "$create_flag" == "1" && "$update_flag" == "1" ]] || [[ "$create_flag" == "1" && "$delete_flag" == "1" ]] || [[ "$update_flag" == "1" && "$delete_flag" == "1" ]]; then
  echo "Error: Only one flag can be used per execution. Use --create, --update, or --delete."
  exit 1
fi

if [[ -z "$create_flag" && -z "$update_flag" && -z "$delete_flag" ]]; then
  echo "Running as --create"
  create_flag=1
fi

# Execute the appropriate action based on the flag
if (( $create_flag )); then
  create_dirs $device $package
  stow -d $device -t ~/ $package
  df=$(get_defer_files $device $package)
  stow --defer="$df" $package
fi

if (( $update_flag )); then
  df=$(get_defer_files $device $package)
  stow -d $device -t ~/ $package
  stow --defer="$df" $package
fi

if (( $delete_flag )); then
  stow -D -d $device -t ~/ $package
  df=$(get_defer_files $device $package)
  stow -D --defer="$df" $package
fi

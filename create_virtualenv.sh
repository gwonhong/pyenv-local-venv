#!/bin/bash

set -e

# Function to create a virtual environment
create_virtualenv() {
  local py_version=$1
  local venv_path=$2

  # Construct the path to the Python interpreter
  local python_interpreter
  python_interpreter="$(pyenv root)/versions/$py_version/bin/python"

  # Try venv first
  echo "Trying venv..."
  set +e
  "$python_interpreter" -m venv "$venv_path"
  local venv_status=$?
  set -e

  # venv module is not available
  if [ $venv_status -ne 0 ]; then
    echo "Trying virtualenv..."

    # Check if virtualenv is installed
    if ! "$python_interpreter" -m virtualenv --version; then
      read -p "Do you want to install virtualenv? (y/N) " user_input
      if [[ ! $user_input =~ ^[Yy]$ ]]; then
        echo "aborting..."
        exit 0
      else
        "$python_interpreter" -m pip install --user virtualenv
      fi
    fi

    # Create the virtual environment using virtualenv
    "$python_interpreter" -m virtualenv "$venv_path"
  fi

  echo "Created virtual environment at $venv_path with ($py_version)."
}

# Main script
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 [python_version] <venv_path>"
  exit 1
fi

if [ $# -eq 1 ]; then
  python_version=$(pyenv version-name)
  venv_path=$1
else
  python_version=$(pyenv latest $1)
  venv_path=$2
fi

create_virtualenv "$python_version" "$venv_path"

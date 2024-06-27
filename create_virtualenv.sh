#!/bin/bash

set -e

# Function to create a virtual environment
create_virtualenv() {
  local py_version=$1
  local venv_path=$2

  # Construct the path to the Python interpreter
  local python_interpreter
  python_interpreter="$(pyenv root)/versions/$py_version/bin/python"

  local used_module
  # Try venv first
  set +e
  "$python_interpreter" -m venv "$venv_path" 2>/dev/null
  if [ $? -ne 0 ]; then
    set -e
    # venv module is not available
    echo "venv unavailable. Trying virtualenv."

    # Ensure virtualenv is installed
    "$python_interpreter" -m pip install --user virtualenv

    # Create the virtual environment using virtualenv
    "$python_interpreter" -m virtualenv "$venv_path"
    used_module="virtualenv package"
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

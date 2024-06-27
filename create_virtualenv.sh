#!/bin/bash

# Function to find matching Python version
resolve_python_version() {
  local py_version=$1
  local latest_version
  
  # check available versions from pyenv install --list and pick the latest version
  latest_version=$(pyenv install --list | grep -E "^\s*$py_version" | tail -1 | tr -d ' ')
  if [ -z "$latest_version" ]; then
    echo "Error: Could not find any version for $py_version."
    exit 1
  fi

  echo "$latest_version"
}

# Function to create a virtual environment
create_virtualenv() {
  local py_version=$1
  local venv_path=$2

  # Get the pyenv root directory
  local pyenv_root
  pyenv_root=$(pyenv root)

  # Construct the path to the Python interpreter
  local python_interpreter
  python_interpreter="$pyenv_root/versions/$py_version/bin/python"

  # Check if the specified Python version is installed
  if [ ! -f "$python_interpreter" ]; then
    echo "Error: Python $py_version is not installed."
    echo "Please install it using 'pyenv install $py_version' and try again."
    exit 1
  fi

  local used_module
  # Check if the venv module is available
  if "$python_interpreter" -m venv "$venv_path" 2>/dev/null; then
    # venv module is available
    used_module="venv module"
  else
    # venv module is not available
    echo "venv module is not available. Falling back to virtualenv."

    # Ensure virtualenv is installed
    "$python_interpreter" -m pip install --user virtualenv

    # Create the virtual environment using virtualenv
    "$python_interpreter" -m virtualenv "$venv_path"
    used_module="virtualenv package"
  fi

  echo "Created at $venv_path with ($py_version) using ($used_module)."
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
  python_version=$(resolve_python_version $1)
  venv_path=$2
fi

create_virtualenv "$python_version" "$venv_path"
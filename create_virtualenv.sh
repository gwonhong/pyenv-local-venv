#!/bin/bash

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

  # Check if the venv module is available
  if "$python_interpreter" -m venv "$venv_path" 2>/dev/null; then
    echo "Virtual environment created at $venv_path using venv module."
  else
    echo "venv module is not available. Falling back to virtualenv."

    # Ensure virtualenv is installed
    "$python_interpreter" -m pip install --user virtualenv

    # Create the virtual environment using virtualenv
    "$python_interpreter" -m virtualenv "$venv_path"
    echo "Virtual environment created at $venv_path using virtualenv package."
  fi
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
  python_version=$1
  venv_path=$2
fi

create_virtualenv "$python_version" "$venv_path"
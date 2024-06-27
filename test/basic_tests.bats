#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup() {
    # Set up any necessary environment or variables
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # Change to the directory where the script is located
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/../src:$PATH"
}

teardown() {
    # Clean up any test artifacts
    rm -rf test_venv
}

#!/usr/bin/env bats

@test "show error when main script is not found" {
    run -1 create_venv.sh
}

# @test "show usage when no arguments are given" {
#     run ! create_venv.sh
#     [ "$output" = "Usage: $0 [python_version] <venv_path>" ]
# }

@test "create virtual environment using current pyenv version with only target directory given" {
    current_version=$(pyenv version-name)
    run -0 bash -c 'echo y | create_venv.sh test_venv'
    [ -d "test_venv" ]

    # Check if the created virtual environment uses the current pyenv version
    test_version=$(test_venv/bin/python --version 2>&1 | awk '{print $2}')
    [[ "$test_version" == "$current_version"* ]]
}

@test "overwrite existing virtual environment directory" {
    run -0 bash -c 'echo y | create_venv.sh test_venv'
    [ -d "test_venv" ]

    run -0 bash -c 'echo y | create_venv.sh test_venv'
    [ -d "test_venv" ]
}

@test "cancel overwrite existing virtual environment directory" {
    run -0 bash -c 'echo y | create_venv.sh test_venv'
    [ -d "test_venv" ]

    run ! bash -c 'echo n | create_venv.sh test_venv'
    [ -d "test_venv" ]
}

@test "fail when invalid python version is specified" {
    run ! create_venv.sh 2.9.9 test_venv
    [ "$output" = "pyenv: no installed versions match the prefix \`2.9.9'" ]
}
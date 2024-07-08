# pyenv-local-venv

`pyenv-local-venv` is a [pyenv](https://github.com/pyenv/pyenv) plugin that simply creates Python venv at current(or specific) directory. So you must install `pyenv` in advance to use this plugin.

If you need to manage your virtual environments more systematically, checkout [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv). I created this plugin because I needed a simpler solution for my use case after trying that plugin.

## Summary

- You can create a Python virtual environment of specific version at current directory by `pyenv local-venv 3.12.1 .venv`
- No other features like auto-activation. I depend on VSCode's virtual environment detection feature for auto-activation.

## Installation

### Installing as a pyenv plugin

This will install the latest development version of pyenv-local-venv into the $(pyenv root)/plugins/pyenv-local-venv directory.

From inside that directory you can:

- (WIP)Check out a specific release tag.
- Get the latest development release by running `git pull` to download the latest changes.

Important note: If you installed pyenv into a non-standard directory, make sure that you clone this repo into the 'plugins' directory of wherever you installed into.

Run the following script:

```bash
git clone https://github.com/gwonhong/pyenv-local-venv.git $(pyenv root)/plugins/pyenv-local-venv
```

### Installing with Homebrew (for macOS users)

WIP

## Usage

To create a new local venv for the Python version used with pyenv, run `pyenv local-venv`, specifying the Python version you want and the virtualenv directory. For exmaple,

```bash
pyenv local-venv 3.12.1 .venv
```

will create a new venv based on Python 3.12.1 under `./.venv`.

### Create venv from current version

If there is only one argument given to `pyenv local-venv`, the virtualenv will be created with the given directory based on the current pyenv Python version.

```bash
$ pyenv version
2.7.18 (set by /Users/gwonhong/.pyenv/version)
$ pyenv local-venv .venv
```

## venv and virtualenv

There is a [venv](https://docs.python.org/3/library/venv.html) module available for CPython 3.3 and newer. It provides an executable module `venv` which is the successor of `virtualenv` and distributed by default.

`pyenv-local-venv` uses `python -m venv` if it is available and if not, uses the `virtualenv`. Also if `virtualenv` package is not installed when needed, `pyenv-local-venv` asks you to install it or not.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

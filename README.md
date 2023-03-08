# Testing with Python: WSU Python Working Group - 8 March 2023

## TL;DR

```bash
make init
pdm run jupyter notebook Presentation/8_March_2023-Presentation.md
pdm run pytest
pdm run nox
```

## Prerequisites

To fully execute all of the examples here, you should have the following installed on
your computer:

0. [Git][] (or [mercurial][], see below) in some form so you can clone this repository.

1. Python versions 3.9. 3.10, and 3.11.

   E.g. I do this with [Macports][]:

   ```bash
   port install python3.9 python3.10 python3.11
   ```
   
   You might also use your OS package manager, [conda][] ([miniconda][]), [PyEnv][] etc.
   If you only have one version, that will be fine, but you won't be able to run tests
   with [nox][] against multiple versions of python.

2. You should install [pdm][], which you can also do with your favorite package manage.

   E.g. I do this on my systems a system level with [pipx][], which allows me to keep my base
   python installation as clean as possible.  Thus, I first do something like `python3
   -m pip install pipx`, `conda install pipx`, or similar, but then everything else is
   installed using [pipx][]:
   
   ```bash
   pipx install pdm
   ```

3. I will assume you have [make][] so you can do things cleanly, but all it does is call
   [pdm][] appropriately.

## Install

Once you clone the repo, you should be able to run 

```bash
make init
```

<details><summary>Output:</summary>

```bash
$ make init
CONDA_PREFIX= PDM_VENV_IN_PROJECT=1 PDM_USE_VENV=1 PDM_VENV_BACKEND=virtualenv PDM_IGNORE_SAVED_PYTHON=1 pdm venv create --force 3.11
Virtualenv .../pwg-testing/.venv is created successfully
CONDA_PREFIX= PDM_VENV_IN_PROJECT=1 PDM_USE_VENV=1 PDM_VENV_BACKEND=virtualenv PDM_IGNORE_SAVED_PYTHON=1 pdm use -i .venv
Using Python interpreter: .../pwg-testing/.venv/bin/python3 (3.11)
CONDA_PREFIX= PDM_VENV_IN_PROJECT=1 PDM_USE_VENV=1 PDM_VENV_BACKEND=virtualenv PDM_IGNORE_SAVED_PYTHON=1 pdm update
Virtualenv .../pwg-testing/.venv is reused.
🔒 Lock successful
Changes are written to pdm.lock.
Synchronizing working set with lock file: 7 to add, 0 to update, 0 to remove

  ✔ Install iniconfig 2.0.0 successful
  ✔ Install pluggy 1.0.0 successful
  ✔ Install pytest-cov 4.0.0 successful
  ✔ Install packaging 23.0 successful
  ✔ Install attrs 22.2.0 successful
  ✔ Install coverage 7.2.1 successful
  ✔ Install pytest 7.2.2 successful

🎉 All complete!

CONDA_PREFIX= PDM_VENV_IN_PROJECT=1 PDM_USE_VENV=1 PDM_VENV_BACKEND=virtualenv PDM_IGNORE_SAVED_PYTHON=1 pdm install -G :all
Virtualenv .../pwg-testing/.venv is reused.
Synchronizing working set with lock file: 121 to add, 0 to update, 0 to remove

  ✔ Install setuptools 67.4.0 successful
  ✔ Install appnope 0.1.3 successful
  ✔ Install asttokens 2.2.1 successful
  ✔ Install backcall 0.2.0 successful
  ✔ Install argcomplete 2.0.0 successful
  ✔ Install argon2-cffi 21.3.0 successful
  ✔ Install argon2-cffi-bindings 21.2.0 successful
  ✔ Install arrow 1.2.3 successful
  ✔ Install colorlog 6.7.0 successful
  ✔ Install anyio 3.6.2 successful
  ✔ Install beautifulsoup4 4.11.2 successful
  ✔ Install comm 0.1.2 successful
  ✔ Install click 8.1.3 successful
  ✔ Install cffi 1.15.1 successful
  ✔ Install cycler 0.11.0 successful
  ✔ Install decorator 5.1.1 successful
  ✔ Install defusedxml 0.7.1 successful
  ✔ Install executing 1.2.0 successful
  ✔ Install bleach 6.0.0 successful
  ✔ Install contourpy 1.0.7 successful
  ✔ Install fastjsonschema 2.16.3 successful
  ✔ Install filelock 3.9.0 successful
  ✔ Install fqdn 1.5.1 successful
  ✔ Install distlib 0.3.6 successful
  ✔ Install idna 3.4 successful
  ✔ Install flake8 6.0.0 successful
  ✔ Install ipython-genutils 0.2.0 successful
  ✔ Install isoduration 20.11.0 successful
  ✔ Install ipykernel 6.21.2 successful
  ✔ Install ipywidgets 8.0.4 successful
  ✔ Install jsonpointer 2.3 successful
  ✔ Install jinja2 3.1.2 successful
  ✔ Install jupyter 1.0.0 successful
  ✔ Install black 23.1.0 successful
  ✔ Install jsonschema 4.17.3 successful
  ✔ Install jupyter-console 6.6.2 successful
  ✔ Install jupyter-client 8.0.3 successful
  ✔ Install jupyter-events 0.6.3 successful
  ✔ Install jupyter-contrib-core 0.4.2 successful
  ✔ Install jupyter-core 5.2.0 successful
  ✔ Install jupyter-highlight-selected-word 0.2.0 successful
  ✔ Install jupyter-server-terminals 0.4.4 successful
  ✔ Install fonttools 4.39.0 successful
  ✔ Install ipython 8.11.0 successful
  ✔ Install jupyterlab-pygments 0.2.2 successful
  ✔ Install jupyter-nbextensions-configurator 0.6.1 successful
  ✔ Install kiwisolver 1.4.4 successful
  ✔ Install jupytext 1.14.5 successful
  ✔ Install jupyter-server 2.3.0 successful
  ✔ Install jupyterlab-widgets 3.0.5 successful
  ✔ Install markupsafe 2.1.2 successful
  ✔ Install matplotlib-inline 0.1.6 successful
  ✔ Install markdown-it-py 2.2.0 successful
  ✔ Install line-profiler 4.0.3 successful
  ✔ Install mccabe 0.7.0 successful
  ✔ Install mdurl 0.1.2 successful
  ✔ Install mdit-py-plugins 0.3.5 successful
  ✔ Install mistune 2.0.5 successful
  ✔ Install mypy-extensions 1.0.0 successful
  ✔ Install nbclient 0.7.2 successful
  ✔ Install debugpy 1.6.6 successful
  ✔ Install nest-asyncio 1.5.6 successful
  ✔ Install nbformat 5.7.3 successful
  ✔ Install nbconvert 7.2.9 successful
  ✔ Install notebook-shim 0.2.2 successful
  ✔ Install nox 2022.11.21 successful
  ✔ Install pandocfilters 1.5.0 successful
  ✔ Install parso 0.8.3 successful
  ✔ Install pathspec 0.11.0 successful
  ✔ Install notebook 6.5.3 successful
  ✔ Install pexpect 4.8.0 successful
  ✔ Install pickleshare 0.7.5 successful
  ✔ Install pipx 1.1.0 successful
  ✔ Install platformdirs 3.1.0 successful
  ✔ Install prometheus-client 0.16.0 successful
  ✔ Install pillow 9.4.0 successful
  ✔ Install prompt-toolkit 3.0.38 successful
  ✔ Install matplotlib 3.7.1 successful
  ✔ Install ptyprocess 0.7.0 successful
  ✔ Install pure-eval 0.2.2 successful
  ✔ Install psutil 5.9.4 successful
  ✔ Install pycodestyle 2.10.0 successful
  ✔ Install pycparser 2.21 successful
  ✔ Install pyflakes 3.0.1 successful
  ✔ Install pyparsing 3.0.9 successful
  ✔ Install pyrsistent 0.19.3 successful
  ✔ Install pytest-flake8 1.1.1 successful
  ✔ Install python-json-logger 2.0.7 successful
  ✔ Install python-dateutil 2.8.2 successful
  ✔ Install pyyaml 6.0 successful
  ✔ Install qtconsole 5.4.0 successful
  ✔ Install pygments 2.14.0 successful
  ✔ Install rfc3339-validator 0.1.4 successful
  ✔ Install jedi 0.18.2 successful
  ✔ Install qtpy 2.3.0 successful
  ✔ Install pyzmq 25.0.0 successful
  ✔ Install rfc3986-validator 0.1.1 successful
  ✔ Install send2trash 1.8.0 successful
  ✔ Install six 1.16.0 successful
  ✔ Install sniffio 1.3.0 successful
  ✔ Install soupsieve 2.4 successful
  ✔ Install snakeviz 2.1.1 successful
  ✔ Install stack-data 0.6.2 successful
  ✔ Install terminado 0.17.1 successful
  ✔ Install tinycss2 1.2.1 successful
  ✔ Install toml 0.10.2 successful
  ✔ Install lxml 4.9.2 successful
  ✔ Install uri-template 1.2.0 successful
  ✔ Install traitlets 5.9.0 successful
  ✔ Install userpath 1.8.0 successful
  ✔ Install wcwidth 0.2.6 successful
  ✔ Install webcolors 1.12 successful
  ✔ Install webencodings 0.5.1 successful
  ✔ Install tornado 6.2 successful
  ✔ Install websocket-client 1.5.1 successful
  ✔ Install widgetsnbextension 4.0.5 successful
  ✔ Install rise 5.7.1 successful
  ✔ Install virtualenv 20.20.0 successful
  ✔ Install numpy 1.24.2 successful
  ✔ Install nbclassic 0.4.8 successful
  ✔ Install jupyter-contrib-nbextensions 0.7.0 successful

🎉 All complete!

CONDA_PREFIX= PDM_VENV_IN_PROJECT=1 PDM_USE_VENV=1 PDM_VENV_BACKEND=virtualenv PDM_IGNORE_SAVED_PYTHON=1 pdm run python3 -m ipykernel install --user --name "pwg-testing" --display-name "Python 3 (pwg-testing)"
Virtualenv .../pwg-testing/.venv is reused.
0.00s - Debugger warning: It seems that frozen modules are being used, which may
0.00s - make the debugger miss breakpoints. Please pass -Xfrozen_modules=off
0.00s - to python to disable frozen modules.
0.00s - Note: Debugging will proceed. Set PYDEVD_DISABLE_FILE_VALIDATION=1 to disable this validation.
Installed kernelspec pwg-testing in .../Library/Jupyter/kernels/pwg-testing
```

</details>

This essentially runs the following commands: *(Note: the plethora of environmental
variables are to ensure reproducible behaviour as discussed here: [Controlling PDM: Reproducibility vs. Convenience. #1758](https://github.com/pdm-project/pdm/discussions/1758).)*

```bash
# See the discussion here for why these environmental variables are needed
# https://github.com/pdm-project/pdm/discussions/1758
CONDA_PREFIX=
PDM_VENV_IN_PROJECT=1 
PDM_USE_VENV=1 
PDM_VENV_BACKEND=virtualenv 
PDM_IGNORE_SAVED_PYTHON=1 

pdm venv create --force 3.11 # Create the virtual environment
pdm use -i .venv             # Tell pdm to use it!
pdm update                   # Check dependencies and update pdm.lock
pdm install -G :all          # Install everything (all groups)

# The following installs a Jupyter kernel for use in the notebooks.
# This is not needed if you run jupyter notebook with pdm.
pdm run python3 -m ipykernel \
    install --user           \
    --name "pwg-testing"     \
    --display-name "Python 3 (pwg-testing)"
```

This should create a virtual environment in `.venv` and install all the tools you need.
Now you can:

* Run the Presentation notebook:

    ```bash
    pdm run jupyter notebook Presentation/8_March_2023-Presentation.md
    ```

* Run the tests:

    ```bash
    pdm run pytest
    ```

* Run the tests using [nox][] over multiple versions of python:

    ```bash
    pdm run nox
    ```

# Deploying on [GitHub][] and [GitLab][]

## Continuous Integration (CI)

https://docs.gitlab.com/ee/ci/examples/#cicd-templates

A challenge with CI is installing the versions of python needed.  Here are several options:

### [Nox][] with [Conda][]

Here we use [conda][] in the `noxfile.py`: this will install the versions of python
needed on the fly.  This is one of the simplest approaches, but has the disadvantage
that either all versions pass, or all versions fail.

```yaml
#.gitlab-ci-yml

image: continuumio/miniconda3:latest

before_script:
  - pip install pipx
  
test:
  script:
    - pipx run nox -s test_conda
```

You can instead use [parallel:matrix][], but you must specify the versions of python you
want to test against here.  This is a bit redundant.

```yaml
#.gitlab-ci-yml

image: continuumio/miniconda3:latest

before_script:
  - pip install pipx
  
test:
  parallel:
    matrix:
      - PYTHON: ["3.9", "3.10", "3.11"]
  script:
    - pipx run nox -s test_conda --python $PYTHON
```


## Mercurial

I prefer to use [mercurial][], so to push to [GitHub][] and [GitLab][], I use
[hg-git][].  There are a couple of things to do:

0. Make sure you have [mercurial][] installed with the [evolve][] and [hg-git][]
   extensions.  I use [pipx][] for this at the system level, but you could include this
   in your project:
   
   ```bash
   pipx install mercurial
   pipx inject mercurial evolve hg-git
   ```
   
1. Add a bookmark with the default branch (now called `main`):

    ```bash
    hg bookmark -r default main
    ```

2. Create your projects on [GitLab][] and [GitHub][] and add tokens etc. so you can push
   and pull.  Optionally, setup repository
   mirroring so you only have to push to one.
   
   * Make sure you create a blank project!  No Readme file etc.

3. Add these to `.hg/hgrc`:

    ```
    [paths]
    gitlab = git+ssh://git@gitlab.com:wsu-courses/pwg/2023-testing-with-python.git
    github = git+ssh://git@github.com/schacon/some-repo.git
    ```

4. Push!

    ```bash
    hg push gitlab -r .
    hg push github -r .
    ```


[conda]: https://docs.conda.io/en/latest/
[miniconda]: https://docs.conda.io/en/latest/miniconda.html
[pdm]: https://pdm.fming.dev/latest/
[nox]: https://nox.thea.codes/en/stable/
[git]: https://git-scm.com/
[mercurial]: https://www.mercurial-scm.org/
[GitLab]: https://gitlab.com/
[GitHub]: https://github.com/
[hg-git]: https://hg-git.github.io/
[evolve]: https://www.mercurial-scm.org/doc/evolution/
[pipx]: https://pypa.github.io/pipx/
[make]: https://www.gnu.org/software/make/
[parallel:matrix]: https://docs.gitlab.com/ee/ci/yaml/#parallelmatrix

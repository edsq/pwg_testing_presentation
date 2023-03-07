# Modelled after
# https://github.com/simoninireland/introduction-to-epidemics/blob/master/Makefile
SHELL = /bin/bash

GET_RESOURCES = git clone git@gitlab.com:wsu-courses/iscimath-583-learning-from-images-and-signals_resources.git _ext/Resources

PYTHON_VER ?= 3.11
PRE ?= PDM_USE_VENV=1 PDM_VENV_BACKEND=virtualenv PDM_IGNORE_SAVED_PYTHON=1
PDM ?= pdm
RUN ?= $(PDM) run
JUPYTEXT ?= $(RUN) jupytext
KERNEL ?= pwg-testing

# ------- Top-level targets  -------
# Default prints a help message
help:
	@make usage

usage:
	@echo "$$HELP_MESSAGE"

init: .venv/bin/python$(PYTHON_VER)
	$(PRE) $(PDM) update
	$(PRE) $(PDM) install -G :all
ifdef KERNEL
	$(PRE) $(RUN) python3 -m ipykernel install --user --name "$(KERNEL)" --display-name "Python 3 ($(KERNEL))"
endif

.venv/bin/python$(PYTHON_VER):
	$(PRE) $(PDM) venv create --force $(PYTHON_VER)

# Jupytext
sync:
	$(PRE) find . -name ".ipynb_checkpoints" -prune -o \
	              -name "_ext" -prune -o \
	              -name "envs" -prune -o \
	              -name "*.ipynb" -o -name "*.md" \
	              -exec $(JUPYTEXT) --sync {} + 2> >(grep -v "is not a paired notebook" 1>&2)
# See https://stackoverflow.com/a/15936384/1088938 for details

clean:
	-find . -name "__pycache__" -exec $(RM) -r {} +
	-find . -name ".ipynb_checkpoints" -exec $(RM) -r {} +
	-$(RM) -r _htmlcov .coverage .pytest_cache


realclean:
ifdef KERNEL
	-$(PRE) $(RUN) jupyter kernelspec uninstall -f "$(KERNEL)"
endif
	-$(RM) -r __pypackage__ .venv


test:
	nox

.PHONY: help usage init sync clean realclean test

# ----- Usage -----
define HELP_MESSAGE

This Makefile provides several tools to help initialize the project.

Variables:
   ACTIVATE: (= "$(ACTIVATE)")
                     Command to activate a conda environment as `$$(ACTIVATE) <env name>`
                     Defaults to `conda activate`.
   PDM: (= "$(PDM)")
                     Command to run `pdm`.
   PYTHON_VER: (= "$(PYTHON_VER)")
                     Version of python to use in the virtual environment.
   PRE: (= "$(PRE)")
                     Can be used to set environmental variables before commands.
   KERNEL: (= "$(KERNEL)")
                     Name of IPython kernel to install.  Kernel not installed if empty.

Initialization:
   make init         Initialize the environment and kernel.

Testing:
   make test         Runs the general tests.

Maintenance:
   make clean        Call conda clean --all: saves disk space.
   make reallyclean  delete the environments and kernel as well.

endef
export HELP_MESSAGE

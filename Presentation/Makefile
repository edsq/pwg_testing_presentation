clean:
	-find . -name "__pycache__" -exec $(RM) -r {} +
	-find . -name ".ipynb_checkpoints" -exec $(RM) -r {} +
	-$(RM) -r coverage.xml htmlcov .coverage .pytest_cache .ipynb_checkpoints

realclean: clean
	-$(RM) -r .nox *.py *.toml *.txt

.PHONY: clean realclean

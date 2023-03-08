clean:
	-find . -name "__pycache__" -exec $(RM) -r {} +
	-find . -name ".ipynb_checkpoints" -exec $(RM) -r {} +
	-$(RM) -r coverage.xml htmlcov .coverage .pytest_cache

realclean: clean
	-$(RM) *.py pyproject.toml 1000.txt

.PHONY: clean realclean

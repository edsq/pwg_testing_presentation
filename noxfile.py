import nox

args = dict(python=["3.9", "3.10", "3.11"], reuse_venv=True)

# By default, we only execute the normal tests because we assume this is being run by
# pdm.  The other tests can be run, e.g., with `nox -s test_conda`.  We use this for CI
# to install the python interpreters.

nox.options.sessions = ["test"]

@nox.session(venv_backend="venv", **args)
def test(session):
    session.run("pytest")


@nox.session(venv_backend="conda", **args)
def test_conda(session):
    session.install(".[test]")
    session.run("pytest")
    

import nox

args = dict(python=["3.9", "3.10", "3.11"], reuse_venv=True)

@nox.session(venv_backend="venv", **args)
def test(session):
    session.run("pytest", external=True)  # pytest is installed externally

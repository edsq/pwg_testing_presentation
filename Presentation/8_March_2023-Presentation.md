---
jupytext:
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.14.5
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

```{code-cell} ipython3
try:
    import pytest
except ImportError:
    import sys
    !{sys.executable} -m pip install --user pytest
```

```{code-cell} ipython3
!make realclean
```

+++ {"slideshow": {"slide_type": "slide"}}

# Testing with Python

## Michael McNeil Forbes

* [CoCalc Project][]
* [GitLab Repo][]

Talk for the WSU Python Working Group: 8 March 2023

[CoCalc Project]: <https://cocalc.com/projects/a78a9e19-3b39-4a08-8899-00387af13a09/files/PWG_Talks/Testing/8_March_2023.slides>
[GitLab Repo]: <>

+++ {"slideshow": {"slide_type": "slide"}}

# Outline

* Why Test?
* What makes a good test?
* Writting tests: Unit tests and Doctests
* Running tests: PyTest
* Coverage Testing
* Nox: (Multiple targets)
* Continuous Integration (CI)

+++ {"slideshow": {"slide_type": "slide"}}

# Why Test?

* To make sure things work **correctly**
* Python has no compiler checks
* Working examples for other users/developers
* Fixedpoints when optimizing

+++ {"slideshow": {"slide_type": "notes"}}

Can your users trust that your code works?  Good tests provide some assurance.  Note: **user**=**you in the future**.

Python has many benefits as an interpreted language, but one loses the help of the compiler checking for simple mistakes (types, syntax errors, etc.).  Consider the following code that saves your results after running a 2-day simulation:

```python
import numpy as np

def save(A):
    """Return"""
    printt("Saving results...")
    np.save("A.npy", A)
    print("Saving results. Done!")
```

+++ {"slideshow": {"slide_type": "slide"}}

# Problem: Computing Primes

A common strategy is the [Sieve of Eratosthenes][].

[Sieve of Eratosthenes]: <https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes>

```{code-cell} ipython3
def get_primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(2, N))
    for p0 in primes:  # Is this okay?  Discuss!
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            if p in primes:
                primes.remove(p)
            p += p0
    return primes
```

```{code-cell} ipython3
get_primes1(40)
```

+++ {"slideshow": {"slide_type": "slide"}}

# Doctests

**Don't Program in Jupyter!**

```{code-cell} ipython3
---
slideshow:
  slide_type: '-'
---
%%writefile primes.py
"""Library to compute prime numbers.
"""

__all__ = ["get_primes1"]


def get_primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(2, N))
    for p0 in primes:  # Is this okay?  Discuss!
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            if p in primes:
                primes.remove(p)
            p += p0
    return primes
```

```{code-cell} ipython3
---
slideshow:
  slide_type: subslide
---
import sys
!{sys.executable} -m doctest -v primes.py
```

+++ {"slideshow": {"slide_type": "slide"}}

# Unit Tests (with PyTest)

```{code-cell} ipython3
%%writefile test_primes.py
"""Unit tests for primes.py"""
import numpy as np

import primes


def test_primes():
    # Load the first 1000 primes
    primes1000 = np.loadtxt(
        "1000.txt", skiprows=4, dtype="int", comments="end."
    ).ravel()
    assert np.allclose(primes1000, primes.get_primes1(primes1000.max()))
```

```{code-cell} ipython3
---
slideshow:
  slide_type: '-'
---
!wget -N https://primes.utm.edu/lists/small/1000.txt
!ls
```

```{code-cell} ipython3
---
slideshow:
  slide_type: subslide
---
import sys
!pytest test_primes.py
```

```{code-cell} ipython3
---
slideshow:
  slide_type: skip
---
!head 1000.txt
!tail 1000.txt
```

```{code-cell} ipython3
---
slideshow:
  slide_type: skip
---
import numpy as np
primes1000 = np.loadtxt('1000.txt', skiprows=4, dtype='int', comments='end.').ravel()
assert np.allclose([p for p in primes1000 if p < 1000], get_primes1(1000))
```

+++ {"slideshow": {"slide_type": "slide"}}

# PyTest

+++ {"slideshow": {"slide_type": "slide"}}

# Optimization

> "premature optimization is the root of all evil."
> -- <cite>Donald Knuth<sup>[1][]</sup></cite>

[1]: <http://web.archive.org/web/20220408200749/https://shreevatsa.wordpress.com/2008/05/16/premature-optimization-is-the-root-of-all-evil/>

```{code-cell} ipython3
%time get_primes1(10);
%time get_primes1(100);
%time get_primes1(1000);
%time get_primes1(10000);
#%time get_primes1(100000);
```

```{code-cell} ipython3
%matplotlib inline
import timeit
import numpy as np, matplotlib.pyplot as plt


def time(N, f=get_primes1):
    ts = np.array(timeit.repeat("f(N)", number=1, globals=dict(N=N, f=f)))
    return ts.mean(), ts.std()


Ns = 2 ** np.arange(3, 14)
ts, dts = np.array(list(map(time, Ns))).T

fig, ax = plt.subplots()
ax.errorbar(Ns, ts, yerr=dts, fmt="o-", label="get_prime1")
ax.loglog(Ns, (Ns / Ns[-1]) ** 2 * ts[-1], '--', label="$t\propto N^2$")
ax.legend()
ax.set(xlabel="N", ylabel="time (s)")
```

```{code-cell} ipython3
---
slideshow:
  slide_type: slide
---
%%writefile primes.py
"""Library to compute prime numbers.
"""

__all__ = ['get_primes1', 'get_iters1']

def get_primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(2, N))
    for p0 in primes:  # Is this okay?  Discuss!
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            if p in primes:
                primes.remove(p)
            p += p0
    return primes


def get_iters1(N):
    """Like get_prime1, but return the number of iterations.

    >>> get_iters1(40)
    32
    """
    iter = 0
    primes = list(range(2, N))
    for p0 in primes:
        p = p0**2
        while p < N:
            iter += 1
            if p in primes:
                primes.remove(p)
            p += p0
    return iter
```

```{code-cell} ipython3
!{sys.executable} -m doctest -v primes.py
```

```{code-cell} ipython3
from importlib import reload
import primes; reload(primes)
Ns = 2 ** np.arange(3, 15)
steps = list(map(primes.get_iters1, Ns))


def f(N):
    return N * np.log(np.log(N))


label = r"N\log \log N"
fig, ax = plt.subplots()
ax.loglog(Ns, steps, "o-", label="prime1")
ax.loglog(Ns, f(Ns) / f(Ns[-1]) * steps[-1], label=rf"steps $\propto {label}$")
ax.legend()
ax.set(xlabel="N", ylabel="steps")
```

```{code-cell} ipython3
---
slideshow:
  slide_type: slide
---
%load_ext line_profiler
%lprun -f get_primes1 get_primes1(40000)
```

```{code-cell} ipython3
---
slideshow:
  slide_type: slide
---
def get_primes2(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> primes2(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(N))
    primes[1] = 0
    for p0 in primes[2:]:
        if not p0:
            continue
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            primes[p] = 0  # Direct access into a list should be fast.
            p += p0
    
    return [p for p in primes if p]
```

```{code-cell} ipython3
%timeit get_primes1(10000)
%timeit get_primes2(10000)
```

```{code-cell} ipython3
Ns = 2 ** np.arange(3, 20)
ts, dts = np.transpose([time(_N, f=get_primes2) for _N in Ns])

def f(N):
    return N * np.log(np.log(N))

fig, ax = plt.subplots()
ax.errorbar(Ns, ts, yerr=dts, fmt="o-", label="get_prime2")
ax.loglog(Ns, f(Ns) / f(Ns[-1]) * ts[-1], label=rf"time $\propto {label}$")
ax.legend()
ax.set(xlabel="N", ylabel="time (s)")
```

```{code-cell} ipython3
---
slideshow:
  slide_type: slide
---
%%writefile primes.py
"""Library to compute prime numbers.
"""

__all__ = ['get_primes1', 'get_iters1', 'get_primes2']

def get_primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(2, N))
    for p0 in primes:  # Is this okay?  Discuss!
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            if p in primes:
                primes.remove(p)
            p += p0
    return primes


def get_iters1(N):
    """Like prime1, but return the number of iterations.

    >>> get_iters1(40)
    32
    """
    iter = 0
    primes = list(range(2, N))
    for p0 in primes:
        p = p0**2
        while p < N:
            iter += 1
            if p in primes:
                primes.remove(p)
            p += p0
    return iter


def get_primes2(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(N))
    primes[1] = 0
    for p0 in primes[2:]:
        if not p0:
            continue
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            primes[p] = 0  # Direct access into a list should be fast.
            p += p0
    
    return [p for p in primes if p]
```

+++ {"slideshow": {"slide_type": "slide"}}

## [Parameterized Fixtures](https://docs.pytest.org/en/latest/how-to/fixtures.html#parametrizing-fixtures)

```{code-cell} ipython3
---
slideshow:
  slide_type: '-'
---
%%writefile test_primes.py
"""Unit tests for primes.py"""
import numpy as np

import pytest
import primes


get_primess = [primes.get_primes1, primes.get_primes2]
get_primess = [getattr(primes, _f) for _f in primes.__all__ if _f.startswith('get_primes')]
@pytest.fixture(params=get_primess)
def get_primes(request):
    yield request.param


def test_primes(get_primes):
    # Load the first 1000 primes
    primes1000 = np.loadtxt(
        "1000.txt", skiprows=4, dtype="int", comments="end."
    ).ravel()
    assert np.allclose(primes1000, primes.get_primes1(primes1000.max() + 1))
```

```{code-cell} ipython3
---
slideshow:
  slide_type: subslide
---
!pytest
```

+++ {"slideshow": {"slide_type": "slide"}}

# [Configure PyTest](https://docs.pytest.org/en/latest/reference/customize.html)

* `pytest.ini` or `.pytest.ini`
* `pyproject.toml`

+++ {"slideshow": {"slide_type": "slide"}}

# [Coverage Testing](https://github.com/nedbat/coveragepy)

Make sure you actually test your code!  (Also [Flake8](https://github.com/pycqa/flake8)
for linting/code quality.)

Configure in:

* `.coveragerc`
* `.flake8`
* `pyproject.toml`

```{code-cell} ipython3
try:
    import pytest_cov, pytest_flake8
except ImportError:
    import sys
    !{sys.executable} -m pip install --user pytest_cov pytest_flake8
```

```{code-cell} ipython3
%%writefile pyproject.toml
[tool.pytest.ini_options]
testpaths = [
    ".",
]
markers = [
    # mark test as slow.
    "slow",
]
addopts = [
    "-m not slow",
    "--doctest-modules",
    "--cov",
    "--cov-report=html",
    "--cov-fail-under=85",
    "--no-cov-on-fail",
    #"-x",
    #"--pdb",
]

doctest_optionflags = [
    "ELLIPSIS",
    "NORMALIZE_WHITESPACE"
    ]

[tool.coverage.run]
```

```{code-cell} ipython3
!pytest
```

```{code-cell} ipython3
!open htmlcov/index.html
```

[htmlcov/index.html](https://htmlcov/index.html)

+++ {"slideshow": {"slide_type": "slide"}}

## Oops!

```{code-cell} ipython3
---
slideshow:
  slide_type: '-'
---
%%writefile test_primes.py
"""Unit tests for primes.py"""
import numpy as np

import pytest
import primes


get_primess = [primes.get_primes1, primes.get_primes2]
get_primess = [getattr(primes, _f) for _f in primes.__all__ if _f.startswith('get_primes')]
@pytest.fixture(params=get_primess)
def get_primes(request):
    yield request.param


def test_primes(get_primes):
    # Load the first 1000 primes
    primes1000 = np.loadtxt(
        "1000.txt", skiprows=4, dtype="int", comments="end."
    ).ravel()
    assert np.allclose(primes1000, get_primes(primes1000.max() + 1))
```

```{code-cell} ipython3
%%writefile primes.py
"""Library to compute prime numbers.
"""

__all__ = ['get_primes1', 'get_iters1', 'get_primes2']

def get_primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(2, N))
    for p0 in primes:  # Is this okay?  Discuss!
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            if p in primes:
                primes.remove(p)
            p += p0
    return primes


def get_iters1(N):
    """Like prime1, but return the number of iterations.

    >>> get_iters1(40)
    32
    """
    iter = 0
    primes = list(range(2, N))
    for p0 in primes:
        p = p0**2
        while p < N:
            iter += 1
            if p in primes:
                primes.remove(p)
            p += p0
    return iter


def get_primes2(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes2(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(N))
    primes[1] = 0
    for p0 in primes[2:]:
        if not p0:
            continue
        p = p0**2
        while p < N:
            primes[p] = 0  # Direct access into a list should be fast.
            p += p0
    
    return [p for p in primes if p]
```

```{code-cell} ipython3
---
slideshow:
  slide_type: subslide
---
!pytest
```

```{code-cell} ipython3
!open htmlcov/index.html
```

+++ {"slideshow": {"slide_type": "slide"}}

# Another Improvement

```{code-cell} ipython3
def get_primes3(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes3(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(N))
    primes[1] = 0
    # for p0 in primes[2:]:
    # This iterator does not get our updates.
    for n in range(2, len(primes)):
        p0 = primes[n]
        if not p0:
            continue
        # Can directly compute the ps
        for p in range(p0**2, N, p0):
            primes[p] = 0
    
    return [p for p in primes if p]
```

```{code-cell} ipython3
%timeit get_primes2(1000)
%timeit get_primes3(1000)
```

```{code-cell} ipython3
%load_ext line_profiler
%lprun -f get_primes3 get_primes3(40000)
```

```{code-cell} ipython3
Ns = 2 ** np.arange(3, 20)
t2s, dt2s = np.transpose([time(_N, f=get_primes2) for _N in Ns])
t3s, dt3s = np.transpose([time(_N, f=get_primes3) for _N in Ns])

def f(N):
    return N * np.log(np.log(N))

fig, ax = plt.subplots()
ax.errorbar(Ns, t2s, yerr=dt2s, fmt="o-", label="get_prime2")
ax.errorbar(Ns, t3s, yerr=dt3s, fmt="x-", label="get_prime3")
ax.loglog(Ns, f(Ns) / f(Ns[-1]) * t3s[-1], '--', label=rf"time $\propto {label}$")
ax.legend()
ax.set(xlabel="N", ylabel="time (s)")
```

```{code-cell} ipython3
---
slideshow:
  slide_type: subslide
---
%%writefile primes.py
"""Library to compute prime numbers.
"""

__all__ = ["get_primes1", "get_iters1", "get_primes2", "get_primes3"]


def get_primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(2, N))
    for p0 in primes:  # Is this okay?  Discuss!
        p = p0**2  # Optimization: does this work?  Why?
        while p < N:
            if p in primes:
                primes.remove(p)
            p += p0
    return primes


def get_iters1(N):
    """Like prime1, but return the number of iterations.

    >>> get_iters1(40)
    32
    """
    iter = 0
    primes = list(range(2, N))
    for p0 in primes:
        p = p0**2
        while p < N:
            iter += 1
            if p in primes:
                primes.remove(p)
            p += p0
    return iter


def get_primes2(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes2(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(N))
    primes[1] = 0
    for p0 in primes[2:]:
        if not p0:
            continue
        p = p0**2
        while p < N:
            primes[p] = 0  # Direct access into a list should be fast.
            p += p0

    return [p for p in primes if p]


def get_primes3(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> get_primes3(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(N))
    primes[1] = 0
    # for p0 in primes[2:]:
    # This iterator does not get our updates.
    for n in range(2, len(primes)):
        p0 = primes[n]
        if not p0:
            continue
        # Can directly compute the ps
        for p in range(p0**2, N, p0):
            primes[p] = 0
    
    return [p for p in primes if p]
```

# Nox

[Nox][] (like [tox][]) allows testing against multiple versions of python.

[Nox]: https://nox.thea.codes/en/stable/
[tox]: https://tox.wiki/en/latest/

```{code-cell} ipython3
try:
    import nox
except ImportError:
    import sys
    !{sys.executable} -m pip install --user --upgrade nox
```

```{code-cell} ipython3
%%writefile noxfile.py
import nox

args = dict(python=["3.9", "3.10", "3.11"], reuse_venv=True)

@nox.session(venv_backend="venv", **args)
def test(session):
    session.run("pytest", external=True)  # pytest is installed externally
```

```{code-cell} ipython3
!nox
```

+++ {"slideshow": {"slide_type": "slide"}}

# Continuous Integration (CI)

+++ {"slideshow": {"slide_type": "subslide"}}

# A better approach?

* O'Neill, Melissa *The Genuine Sieve of Eratosthenes.* Journal of Functional Programming, 19(1), 95-106 (2009), [doi:10.1017/S0956796808007004][O'Neill:2009].

[O'Neill:2009]: <https://doi.org/10.1017/S0956796808007004>

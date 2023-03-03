---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.14.4
kernelspec:
  display_name: Python 3 (Ubuntu Linux)
  language: python
  name: python3-ubuntu
  resource_dir: /usr/local/share/jupyter/kernels/python3-ubuntu
---

```{code-cell} ipython3
import sys
!{sys.executable} -m pip install --user pytest
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
def primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> primes1(40)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
    """
    primes = list(range(2, N))
    for p0 in primes:   # Is this okay?  Discuss!
        p = p0**2       # Optimization: does this work?  Why?
        while p < N:
            if p in primes:
                primes.remove(p)
            p += p0
    return primes
```

```{code-cell} ipython3
primes1(40)
```

+++ {"slideshow": {"slide_type": "slide"}}

# Doctests

**Don't Program in Jupyter!**

```{code-cell} ipython3
%%writefile primes.py
"""Library to compute prime numbers.
"""

__all__ = ['primes1']


def primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> primes1(40)
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
    primes1000 = np.loadtxt('1000.txt',
                            skiprows=4,
                            dtype='int',
                            comments='end.').ravel()
    assert np.allclose(primes1000, primes.primes1(primes1000.max()))
```

```{code-cell} ipython3
import sys
!pytest test_primes.py
```

```{code-cell} ipython3
---
slideshow:
  slide_type: subslide
---
!wget -N https://primes.utm.edu/lists/small/1000.txt
!ls
```

```{code-cell} ipython3
!head 1000.txt
!tail 1000.txt
```

```{code-cell} ipython3
import numpy as np
primes1000 = np.loadtxt('1000.txt', skiprows=4, dtype='int', comments='end.').ravel()
assert np.allclose([p for p in primes1000 if p < 1000], primes1(1000))
```

+++ {"slideshow": {"slide_type": "slide"}}

# PyTest

+++ {"slideshow": {"slide_type": "slide"}}

# Optimization

> "premature optimization is the root of all evil."
> -- <cite>Donald Knuth<sup>[1][]</sup></cite>

[1]: <http://web.archive.org/web/20220408200749/https://shreevatsa.wordpress.com/2008/05/16/premature-optimization-is-the-root-of-all-evil/>

```{code-cell} ipython3
%time primes1(10);
%time primes1(100);
%time primes1(1000);
%time primes1(10000);
%time primes1(100000);
```

```{code-cell} ipython3
timeit.number('primes1(100)', number=1, globals=locals())
```

```{code-cell} ipython3
%matplotlib inline
import timeit
import numpy as np, matplotlib.pyplot as plt

def time(N, f=primes1):
    ts = np.array(timeit.repeat('f(N)', number=1, globals=dict(N=N, f=f)))
    return ts.mean(), ts.std()

Ns = 2**np.arange(3, 14)
ts, dts = np.array(list(map(time, Ns))).T

fig, ax = plt.subplots()
ax.errorbar(Ns, ts, yerr=dts, fmt='o-', label='prime1')
ax.loglog(Ns, (Ns/Ns[-1])**2*ts[-1], label="$t\propto N^2$")
ax.legend()
ax.set(xlabel="N", ylabel="time (s)");
```

```{code-cell} ipython3
---
slideshow:
  slide_type: slide
---
%%writefile primes.py
"""Library to compute prime numbers.
"""

__all__ = ['primes1', 'primes2']


def primes1(N):
    """Return all the primes below N using the sieve of Eratosthenes.

    >>> primes1(40)
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


def iters1(N):
    """Like prime1, but return the number of iterations.

    >>> iters1(40)
    32
    """
    iter = 0
    primes = list(range(2, N))
    for p0 in primes:  # Is this okay?  Discuss!
        p = p0**2  # Optimization: does this work?  Why?
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
Ns = 2**np.arange(3, 16)
steps = list(map(primes.iters1, Ns))

def f(N):
    return N*np.log(np.log(N))
label = r"N\log \log N"
fig, ax = plt.subplots()
ax.loglog(Ns, steps, 'o-', label='prime1')
ax.loglog(Ns, f(Ns)/f(Ns[-1])*steps[-1], label=fr"steps $\propto {label}$")
ax.legend()
ax.set(xlabel="N", ylabel="steps");
```

+++ {"slideshow": {"slide_type": "subslide"}}

# A better approach?

```haskell
primes = sieve [2..]
sieve (p : xs) = p : sieve [x | x <− xs, x ‘mod‘ p > 0]
```
* O'Neill, Melissa *The Genuine Sieve of Eratosthenes.* Journal of Functional Programming, 19(1), 95-106 (2009), [doi:10.1017/S0956796808007004][O'Neill:2009].

[O'Neill:2009]: <https://doi.org/10.1017/S0956796808007004>

```{code-cell} ipython3
import time
import numpy as np

def compute_primes(N):
    """Return a list of N prime numbers using the sieve of Eratosthenes.

    >>> compute_primes(10)
    [2, 3, 5, 7, 11, 13, 17, 19, 27]
    """
    primes = [2]
    

def save(A):
    """Save the results A to the file A.npy."""
    primt("Saving results...")
    np.save("A.npy", A)
    print("Saving results. Done!")
```

+++ {"slideshow": {"slide_type": "subslide"}}

# Why Test?
## To make sure things work **correctly**

Can users (i.e. you in a few years) thing

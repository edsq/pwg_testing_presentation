"""Library for finding prime numbers."""

__version__ = "0.1.0"

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
        if not p0:  # pragma: no cover
            continue
        p = p0**2  # Optimization: does this work?  Why?
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

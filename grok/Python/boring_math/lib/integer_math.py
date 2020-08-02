"""Library of functions of an integer pure math nature.

Note: Type checking the responsibility of the calling function.
"""

__author__ = "Geoffrey Scheller"

import sys
from func_tools import take

__all__ = ['gcd', 'lcm', 'primes',
           'pythag3',
           'ackermann',
           'fibonacci', 'fibonacci_list', 'fibonacci_tuple',
           'fibonacci_mult', 'fibonacci_mult_list', 'fibonacci_mult_tuple']

## Number Theory mathematical Functions.

def gcd(fst, snd):
    """Uses Euclidean algorithm to compute the gcd of two integers.

    Takes two integers, returns gcd >= 0.

    Note: gcd(0,0) returns 0 but in this case the gcd does not exist.
    """

    while snd > 0:
        fst, snd = snd, fst % snd

    return fst


def lcm(fst, snd):
    """Finds the least common multiple of two integers.
       Takes two integers, returns lcm >=0.
    """

    common = gcd(fst, snd)
    fst //= common
    snd //= common

    return abs(fst*snd*common)


def _prime_list(start, end_before):
    """Return an list of primes where start <= prime < end_before

    Uses the Sieve of Eratosthenes algorithm

    Usage: primes = prime_list(start=2, m=100)
    """

    if start >= end_before or end_before < 3:
        return []
    if start < 2:
        start = 2

    sieve = [x for x in range(3, end_before, 2) if x % 3 != 0]
    stop = int(end_before**(0.5)) + 1
    front = -1
    for prime in sieve:
        front += 1
        if prime > stop:
            break
        for pot_prime in sieve[-1:front:-1]:
            if pot_prime % prime == 0:
                sieve.remove(pot_prime)

    if start <= 3 < end_before:  # We missed [2, 3] but
        sieve.insert(0, 3)       # saved about 60% for
    if start <= 2 < end_before:  # the initial storage
        sieve.insert(0, 2)       # space.

    # return sieve after trimming unwanted values
    return [x for x in sieve if x >= start]


def primes(start=2, end_before=100):
    """Return an iterator for values generated by
    the prime_list function for start <= prime < end_before
    """

    return iter(_prime_list(start, end_before))


## Pythagorean Triples related mathematical functions.

def pythag3(a_max=3, all_max=None):
    """This iterator finds all primative pythagorean triples
    up to a given level.  A Pythagorean triple are three
    integers (a,b,c) such that a^2 + b^2 = c^2 where
    x,y,z > 0 and gcd(a,b,c) = 1

    If called with one argument, generates all triples with
    a <= a_max

    If called with two arguments generate all triples with
    a <= a_max and a,b,c <= all_max
    """

    # Limit values to those where geometry based
    # optimization assumptions hold.
    if a_max < 3:
        a_max = 2

    # Calculate limits for given values of a_max & all_max
    if all_max is None:
        # Tor a given value of a, no more
        # triples beyond this value of b
        b_max = lambda a: (a**2 - 1)//2
    else:
        if all_max < 5:
            all_max = 4
        # Cap triples to those with sides no bigger than all_max
        if all_max < a_max + 2:
            a_max = all_max - 2
        b_max = lambda a: min((a**2 - 1)//2, int((all_max**2 - a**2)**0.5))
    c_max = int((a_max**2 + b_max(a_max)**2)**(0.5))

    # Hypothrnuse perfect square lookup dictionary
    # Note: hypotenuse always odd for Pythagorean triples
    squares = {h*h:h for h in range(5, c_max + 1, 2)}

    # Calculate Pythagorean triples
    for side_a in range(3, a_max + 1):
        for side_b in range(side_a + 1, b_max(side_a) + 1):
            csq = side_a**2 + side_b**2
            if csq in squares:
                if gcd(side_a, side_b) == 1:
                    yield (side_a, side_b, squares[csq])


# Computable but not primitive recursive functions

def ackermann(m_arg=0, n_arg=0):
    """Ackermann function is defined recursively by:

    ackermann(0,n) = n+1
    ackermann(m,0) = ackermann(m-1,1)
    ackermann(m,n) = ackermann(m-1, ackermann(m, n-1)) for n,m > 0
    """

    # Model a function stack with a list, then
    # evaluate innermost ackermann function first.
    acker = [m_arg, n_arg]

    while len(acker) > 1:
        m_arg, n_arg = acker[-2:]
        if m_arg < 1:
            acker[-1] = acker.pop() + 1
        elif n_arg < 1:
            acker[-2] = acker[-2] - 1
            acker[-1] = 1
        else:
            acker[-2] = m_arg - 1
            acker[-1] = m_arg
            acker.append(n_arg-1)

    return acker[0]


## Fibonacci related mathematical functions.

def _fibonacci(fib0, fib1):
    """Returns an iterator to a Fibonacci sequence whose
    first two terms are fib0 and fib1.
    """

    while True:
        yield fib0
        fib0, fib1 = fib1, fib0+fib1


def fibonacci(fib0=0, fib1=1, count=None):
    """Returns an iterator to a Fibonacci sequence whose
    first two terms are fib0 and fib1.  The iterator ends
    after count times.

    Please note: fib0 and fib1 can be any objects where
    the "+" operator has been defined.
    """

    if count is None:
        return _fibonacci(fib0, fib1)
    return take(count, _fibonacci(fib0, fib1))


def fibonacci_list(fib0=0, fib1=1, count=10):
    """Returns an list with a fibonacci sequence"""

    return list(fibonacci(fib0, fib1, count))


def fibonacci_tuple(fib0=0, fib1=1, count=10):
    """Returns a tuple with a fibonacci sequence"""

    return tuple(fibonacci_list(fib0, fib1, count))


def _fibonacci_mult(fib0, fib1):
    """Returns an iterator to a Fibonacci sequence
    whose first two terms are fib0 and fib1.
    """

    while True:
        yield fib0
        fib0, fib1 = fib1, fib0*fib1


def fibonacci_mult(fib0=0, fib1=1, count=None):
    """Returns an iterator to a Fibonacci sequence using * instead of +"""

    if count is None:
        return _fibonacci_mult(fib0, fib1)
    return take(count, _fibonacci_mult(fib0, fib1))


def fibonacci_mult_list(fib0=2, fib1=3, count=10):
    """Returns an list with a fibonacci sequence using * instead of +."""

    return list(fibonacci_mult(fib0, fib1, count))


def fibonacci_mult_tuple(fib0=2, fib1=3, count=10):
    """Returns a tuple with a fibonacci sequence using * instead of +."""

    return tuple(fibonacci_mult_list(fib0, fib1, count))


if __name__ == '__main__':
    sys.exit(0)

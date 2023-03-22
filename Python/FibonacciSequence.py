# Create a Python generator that yields the Fibonacci sequence.

# The Fibonacci sequence is a sequence of numbers whose first and second elements are 1.
# To generate further elements of the sequence we take the sum of the previous two elements.
# For example the first 6 Fibonacci numbers are 0, 1, 1, 2, 3, 5.
#
# Write a generator that returns the Fibonacci sequence up to a certain number of elements.
#
# For example:
#
# ```python
# >>> list(fibonacci_generator(6))
# [0, 1, 1, 2, 3, 5]

from typing import Generator


def fibonacci_generator(n: int) -> Generator[int, None, None]:
    """
    This function generates fibonacci numbers.
    Parameters
    ----------
    n : int
    Quantity of fibonacci numbers to generate.
    Returns
    -------
    Each iteration of the generator function returns next fibonacci number
    """
    a, b = 0, 1
    count = 0
    while count < n:
        yield a
        a, b = b, a + b
        count += 1

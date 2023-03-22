# Write a custom function pow_func(x), which should take as an argument the number n and build function
# that can be used like:
# ```
# >>> pow3_func = pow_func(n=3)
# >>> pow3_func(x=2)
# 8
# >>> pow3_func(x=3)
# 27
# >>> pow2_func = pow_func(n=2)
# >>> pow2_func(x=2)
# 4
# >>> pow2_func(x=3)
# 9
# ```
# In case of successful calculations, the function should return result of calculations.
# Otherwise, the corresponding error message should be displayed and None should be returned.
# Check the function by calling it with arguments 5 and '5'.
# To solve the problem, use the try/except/else statement in the function body.

def pow_func(n: int) -> Callable[[int], int]:
    """
    This function should return function, that can do calculation like this:
    ```
    >>> pow3_func = pow_func(n=3)
    >>> pow3_func(2)
    8
    >>> pow3_func(3)
    27
    >>> pow2_func = pow_func(n=2)
    >>> pow2_func(2)
    4
    >>> pow2_func(3)
    9

    ```
    Parameters
    ----------
    n : int
        The power to which the created function will raise the number.

    Returns
    -------
    A function that raises a number to a certain power.
    """
    def power(x: int) -> int:
        """
        This function raises a number to a certain power.
        The power raised number is given during the creation of this function.

        Parameters
        ----------
        x : int
            The number to be raised to a certain power.
        Returns
        -------
        num : int
            The number raised to the power of the function number.
        """
        try:
            num = x ** n
        except TypeError as e:
            print(e)
            print("Please input numbers.")
            return None
        except Exception as e:
            print(e)
            print("Unexpected exception occurred.")
        else:
            return num
    return power

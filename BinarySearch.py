# This task requires writing code for a quick search in a sorted sequence,
# which can take the Card, Page and int class as an argument.
# The code should be able to find an index to an element in the sequence,
# if the element is not present in the sequence, then it should return None as the result.
# The code should be efficient and should be able to carry out the search quickly.
from enum import Enum
from typing import List, TypeVar, Optional, Callable


class SuitEnum(Enum):
    hearts = 1
    tiles = 2
    clovers = 3
    pikes = 4

    def __lt__(self, other):
        if isinstance(other, SuitEnum):
            return self.value < other.value
        return False

    def __eq__(self, other):
        if isinstance(other, SuitEnum):
            return self.value == other.value
        return False


class RanksEnum(Enum):
    two = 2
    three = 3
    four = 4
    five = 5
    six = 6
    seven = 7
    eight = 8
    nine = 9
    ten = 10
    jack = 11
    queen = 12
    king = 13
    ace = 14

    def __lt__(self, other):
        if isinstance(other, RanksEnum):
            return self.value < other.value
        return False

    def __eq__(self, other):
        if isinstance(other, RanksEnum):
            return self.value == other.value
        return False


# Card instance is equal to another card instance
# if the rank and suit are equal to the rank and suit of the another page instance
class Card:
    def __init__(self, suit: SuitEnum, rank: RanksEnum):
        self.suit = suit
        self.rank = rank

    def __str__(self):
        return f'<Card rank={self.rank}, suit={self.suit}>'

    def __eq__(self, other):
        if isinstance(other, Card):
            return self.suit == other.suit and self.rank == other.rank
        return False

    def __lt__(self, other):
        if isinstance(other, Card):
            if self.suit < other.suit:
                return True
            elif self.suit == other.suit and self.rank < other.rank:
                return True
            else:
                return False
        return False

    __repr__ = __str__


# Page instance is equal to another page instance
# if the page_number is equal to the page_number of the another page instance
class Page:
    def __init__(self, page_number):
        self.page_number = page_number

    def __str__(self):
        return f'<Page #{self.page_number}>'

    def __eq__(self, other):
        if isinstance(other, Page):
            return self.page_number == other.page_number
        return False

    def __lt__(self, other):
        if isinstance(other, Page):
            return self.page_number < other.page_number
        return False

    __repr__ = __str__


T = TypeVar('T')


def fast_search(list_of_numbers: List[T], x: T) -> Optional[T]:
    """
    This function takes in a list of numbers in some order and a number x as input
    and finds the index of x in the list.
    If x is not present in the list, it returns None.

    Parameters
    ----------
    list_of_numbers : list
        List of numbers in ascending order
    x : int
        The number to be searched for

    Returns
    -------
    index : int
        The index of x in the list, None if x is not present
    """
    return binary_search(list_of_numbers, 0, len(list_of_numbers) - 1, x)


def binary_search(array, low, high, value):
    """
    This function takes a list of sortable values 'a' of type T and a target value of the same type 'x'.
    It uses a binary search algorithm to find the position of the value in the list.
    If the value 'x' is not present in the list, it returns None.
    Parameters
    ---------
    array : list
        List of numbers in ascending order.
    low : int
        The lowest position where the search will be done.
    high : int
        The highest position where the search will be done.
    value : T
        The desired value we will be looking for.
        Has to have "less than" and "equals" functions implemented.
    Returns
    -------
    mid : T
        Returns the type that was requested (T),
        or None if the element does not exist in the list.
    """
    while high >= low:
        mid = (high + low) // 2
        if array[mid] == value:
            return mid
        if array[mid] < value:
            low = mid + 1
        else:
            high = mid - 1
    return None

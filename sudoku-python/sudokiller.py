#!/usr/bin/env python

"""
Sudokiller 0.1.0 - Python Sudoku solver (Daniele Mazzocchio - 04/08/2005)

Fill the 'table' list with the Sudoku table, replacing the empty cells with
zeroes, and run this script.
"""

import sys, curses


################################################################################
# Sudoku Table                                                                 #
################################################################################

table = [[0, 6, 0, 1, 0, 4, 0, 5, 0],
         [0, 0, 8, 3, 0, 5, 6, 0, 0],
         [2, 0, 0, 0, 0, 0, 0, 0, 1],
         [8, 0, 0, 4, 0, 7, 0, 0, 6],
         [0, 0, 6, 0, 0, 0, 3, 0, 0],
         [7, 0, 0, 9, 0, 1, 0, 0, 4],
         [5, 0, 0, 0, 0, 0, 0, 0, 2],
         [0, 0, 7, 2, 0, 6, 9, 0, 0],
         [0, 4, 0, 5, 0, 8, 0, 7, 0]]


################################################################################
# Constants                                                                    #
################################################################################

__version__ = "0.1.0"
__author__  = "Daniele Mazzocchio"

SIZE  = len(table)      # Size of the table
BOX_W = 3               # Width of the inner boxes
BOX_H = 3               # Height of the inner boxes
EMPTY = 0               # Empty cells marker

MIN_SCR_W = 31          # Minimum screen width
MIN_SCR_H = 21          # Minimum screen height


################################################################################
# Main Class                                                                   #
################################################################################

class SudoKiller:
    """Sudoku solver class"""

    def __init__(self, table):
        """Initialize the Sudoku table"""
        self.table = table

    def display_table(self):
        """Display the current status of the table. Should be overridden by subclasses"""
        pass

    def _check(self, num, row, col):
        """Check if num can fit in the table at (row, col)"""
        # Find the 3x3 box this cell belongs to
        r, c =  row - row % BOX_H, col - col % BOX_W
        box = [x[i] for x in self.table[r:r+BOX_H] for i in range(c, c+BOX_W)]

        return not (num in (self.table[row] + [x[col] for x in self.table] + box))

    def guess(self, position=0):
        """Recursively guess each number by trial and error. The 'position'
           argument identifies the position (in the range 0->80), inside the
           table, of the number to guess"""
        row, col = position / SIZE, position % SIZE

        try:
            if self.table[row][col]: return self.guess(position + 1)
        except IndexError:
            return True
        else:
            for i in range(1, SIZE + 1):
                if self._check(i, row, col):
                    self.table[row][col] = i
                    self.display_table(i, row, col)

                    if not self.guess(position + 1):
                        self.table[row][col] = EMPTY
                        self.display_table(EMPTY, row, col)
                    else:
                        return True

            self.table[row][col] = EMPTY
            self.display_table(EMPTY, row, col)
            return False


class CursesSudoKiller(SudoKiller):
    """Sudoku solver class with curses support"""

    def __init__(self, table):
        """Initialize the Sudoku table"""
        SudoKiller.__init__(self, table)

    def kill(self, window):
        """Sudokiller in action"""
        self._init_screen(window)

        self.guess()

        exit_msg = " Hit any Key to exit... "
        window.addstr(MIN_SCR_H-1, (self._screen_w-len(exit_msg))/2, exit_msg)
        window.refresh()
        window.getch()

    def _init_screen(self, window):
        """Initialize the screen with borders and title"""
        self._screen_h, self._screen_w = window.getmaxyx()
        if (self._screen_h < MIN_SCR_H) or (self._screen_w < MIN_SCR_W):
            sys.exit("Sorry, the screen must be at least %dx%d!" % (MIN_SCR_W, MIN_SCR_H))

        self._board = window.subwin(MIN_SCR_H, MIN_SCR_W, 0, (self._screen_w-MIN_SCR_W)/2)
        self._board.border()
        title = " Sudokiller " + __version__
        window.addstr(0, (self._screen_w-len(title))/2, title)
        window.refresh()
        self.display_table()

    def display_table(self, num=None, row=None, col=None):
        """Update a single table item or display the whole table"""
        try:
            self._board.addch((row+1)*2, (col+1)*3, str(num))
        except:
            for y, nums in enumerate(self.table):
                for x, num in enumerate(nums):
                    self._board.addch((y+1)*2, (x+1)*3, str(num))
        self._board.refresh()


if __name__ == "__main__":
    curses.wrapper(CursesSudoKiller(table).kill)

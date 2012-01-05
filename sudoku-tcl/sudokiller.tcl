#!/bin/sh
# \
exec wish8.4 "$0" -- ${1+"$@"}

################################################################################
#                                                                              #
# SudoKiller.tcl - Tcl/Tk SuDoku solver                                        #
#                                                                              #
# Name:        sudokiller.tcl                                                  #
# Version:     1.0                                                             #
# Created:     31 Mar 2006                                                     #
# Last update: 31 Mar 2006                                                     #
# Author:      Daniele Mazzocchio                                              #
#                                                                              #
# Fill the board with the puzzle you want to solve and click "Kill!" to get    #
# the solution.                                                                #
#                                                                              #
# Download sources                                                             #
#                                                                              #
################################################################################

################################################################################
# Constants definition                                                         #
################################################################################
set VERSION     "1.0"

set BOARD_SIZE  9                                   ;# Size of the SuDoku board
set BOX_SIZE    [expr int(sqrt($BOARD_SIZE))]       ;# Size of the inner boxes
set EMPTY       ""                                  ;# Empty cell marker

set W_WIDTH     235                                 ;# Window width
set W_HEIGHT    240                                 ;# Window height
set PAD         5                                   ;# Internal border width


################################################################################
# Draw the window                                                              #
################################################################################
wm title . "SudoKiller $VERSION"
wm geometry . ${W_WIDTH}x${W_HEIGHT}

frame .top -borderwidth $PAD
frame .bottom -borderwidth $PAD
pack .top .bottom -side top -fill x

# Draw the SuDoku board
for {set row 0} {$row < $BOARD_SIZE} {incr row} {
    for {set col 0} {$col < $BOARD_SIZE} {incr col} {
        entry .top.e$row$col -bg white -width 1 -textvar board($row$col) \
              -validate key -vcmd {expr {[string is digit %P] &&
                                         [string length %P] <= 1}}
        grid .top.e$row$col -row $row -column $col -sticky news -ipadx $PAD
    }
}

# Draw the buttons to start solving the puzzle and to reset the board
button .bottom.kill -text "Kill!" -command guess
button .bottom.reset -text "Reset" -command reset
pack .bottom.kill .bottom.reset -side left -expand true -fill x


################################################################################
# Procedures                                                                   #
################################################################################
proc check {num row col} {
    # Check if num is, according to SuDoku rules, a legal candidate
    # for the given cell
    global BOARD_SIZE BOX_SIZE board

    set r [expr ($row / $BOX_SIZE) * $BOX_SIZE]
    set c [expr ($col / $BOX_SIZE) * $BOX_SIZE]

     for {set i 0} {$i < $BOARD_SIZE} {incr i} {
         if {$num == $board($row$i) ||
             $num == $board($i$col) ||
             $num == $board([expr $r + $i % $BOX_SIZE][expr $c + $i / $BOX_SIZE])} {
             return false
         }
    }
    return true
}

proc guess {{index 0}} {
    # Recursively test all candidate numbers for a given cell until
    # the board is complete
    global BOARD_SIZE EMPTY board

    set row [expr $index / $BOARD_SIZE]
    set col [expr $index % $BOARD_SIZE]

    if {$row >= $BOARD_SIZE} { return true }

    if {$board($row$col) != $EMPTY} { return [guess [expr $index + 1]] }

    for {set i 1} {$i <= $BOARD_SIZE} {incr i} {
        if {[check $i $row $col]} {
            set board($row$col) $i
            if {[guess [expr $index + 1]]} { return true }
        }
    }
    set board($row$col) $EMPTY
    return false
}

proc reset {} {
    # Reset the SuDoku board
    global BOARD_SIZE EMPTY board

    for {set row 0} {$row < $BOARD_SIZE} {incr row} {
        for {set col 0} {$col < $BOARD_SIZE} {incr col} {
            set board($row$col) $EMPTY
        }
    }
}

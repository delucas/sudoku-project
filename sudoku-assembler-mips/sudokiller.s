#### sudokiller.s ##############################################################
#                                                                              #
# Sudoku game solver in MIPS assembly                                          #
#                                                                              #
# Version      : 1.0                                                           #
# Created date : 18/05/2006                                                    #
# Last update  : 19/05/2006                                                    #
# Author       : Daniele Mazzocchio                                            #
#                                                                              #
# Replace the 'board' table with the puzzle you want to be solved, filling     #
# the empty cells with zeroes. Then run this program using the spim simulator  #
# with the command:                                                            #
#                                                                              #
#   spim ./sudokiller.s                                                        #
#                                                                              #
# Download sources                                                             #
################################################################################

            .data
.align      4

# This is the game board. Fill it with the puzzle you want to solve
board:      .byte     0, 6, 0, 1, 0, 4, 0, 5, 0
            .byte     0, 0, 8, 3, 0, 5, 6, 0, 0
            .byte     2, 0, 0, 0, 0, 0, 0, 0, 1
            .byte     8, 0, 0, 4, 0, 7, 0, 0, 6
            .byte     0, 0, 6, 0, 0, 0, 3, 0, 0
            .byte     7, 0, 0, 9, 0, 1, 0, 0, 4
            .byte     5, 0, 0, 0, 0, 0, 0, 0, 2
            .byte     0, 0, 7, 2, 0, 6, 9, 0, 0
            .byte     0, 4, 0, 5, 0, 8, 0, 7, 0

# Strings to display the solution (or an error)
new_row:    .ascii    " |\n"
h_sep:      .asciiz   " +---+---+---+---+---+---+---+---+---+\n"
v_sep:      .asciiz   " | "
err_msg:    .asciiz   "Sorry, solution not found...\n"


            .text
.align      4
.globl      main

################################################################################
# main -- Call the guess() function and print the resulting board or an error  #
#         message.                                                             #
#                                                                              #
# Last update:                                                                 #
#   18/05/2006                                                                 #
# Arguments:                                                                   #
#   None                                                                       #
# Registers used:                                                              #
#   $s0 - Store the return code                                                #
################################################################################
main:
    move    $a0, $zero            # Offset of first cell to guess
    jal     guess                 # Start brute-forcing the solution
    move    $s0, $v0              # Save guess() return code
    bnez    $s0, print_err        # Check if guess() return code != 0
    jal     print_board           # Print the solution (if any)
    j       exit                  # Exit with guess() return code

print_err:
    la      $a0, err_msg          # Load the address of the error message in $a0
    li      $v0, 4                # load print_string syscall number in $v0
    syscall                       # Execute the syscall

exit:
    move    $a0, $s0              # Store return code in $a0
    li      $v0, 17               # load exit2 syscall number in $v0
    syscall                       # Execute the syscall

################################################################################
# guess -- Test all candidate numbers for the current cell until the board is  #
#          complete                                                            #
#                                                                              #
# Last update:                                                                 #
#   19/05/2006                                                                 #
# Arguments:                                                                   #
#   $a0 - Offset of the cell to guess                                          #
# Registers used:                                                              #
#   $s0 - Offset of the cell to guess (saves $a0)                              #
#   $s1 - Cell's row index                                                     #
#   $s2 - Cell's column index                                                  #
#   $s3 - Currently tested number                                              #
################################################################################
guess:
    # Set up the stack frame
    sub     $sp, $sp, 20          # Make room on the stack to save registers
    sw      $ra, 16($sp)          # Save the return address
    sw      $s3, 12($sp)          # Save the $s3 register
    sw      $s2, 8($sp)           # Save the $s2 register
    sw      $s1, 4($sp)           # Save the $s1 register
    sw      $s0, 0($sp)           # Save the $s0 register

    move    $s0, $a0              # Save the argument in $s0
    beq     $s0, 81, guess_ret_ok # Check if offset's outside the board's bounds

    # Get current cell's row and column indexes
    li      $s3, 9                # Store the board size in $s3
    div     $s0, $s3              # Divide the cell's offset by the board size
    mflo    $s1                   # $s1 = cell's row index
    mfhi    $s2                   # $s2 = cell's column index

    # Check if the current cell is empty
    lb      $t0, board + 0($s0)   # Load current cell's value in $t0
    beqz    $t0, guess_loop       # If the cell is empty, start guessing
    addi    $a0, $s0, 1           # Otherwise, increment the offset
    jal     guess                 #   and go on to the next cell
    j       guess_ret             # Return the value returned by guess()

guess_loop:
    # Check if the value in $s3 is a legal candidate for this cell
    move    $a0, $s3              # Pass the number to check as the 1st arg
    move    $a1, $s1              # Pass the row index as 2nd arg
    move    $a2, $s2              # Pass the column index as 3rd arg
    jal     check                 # Call the check() function
    bnez    $v0, guess_chk_failed # Examine check() return value
    sb      $s3, board + 0($s0)   # If OK, assign number to cell
    # Go on to the next cell
    addi    $a0, $s0, 1           # Increment the offset
    jal     guess                 # Recursively call the guess() function()
    beqz    $v0, guess_ret        # Return if guess() succeeded

guess_chk_failed:
    sub     $s3, 1                # Decrement the number to test
    bnez    $s3, guess_loop       #   and test it
    sb      $zero, board + 0($s0) # If no number worked, empty the cell
    li      $v0, 1                # Return code is 1 (failure)
    j       guess_ret             # Jump to return instructions

guess_ret_ok:
    move    $v0, $zero            # Return code is 0 (success)

guess_ret:
    # Destroy the stack frame
    lw      $s0, 0($sp)           # Restore the $s0 register
    lw      $s1, 4($sp)           # Restore the $s1 register
    lw      $s2, 8($sp)           # Restore the $s2 register
    lw      $s3, 12($sp)          # Restore the $s3 register
    lw      $ra, 16($sp)          # Restore the return address
    addi    $sp, $sp, 20          # Clean up the stack
    jr      $ra                   # Return

################################################################################
# check -- Check if a number is, according to Sudoku rules, a legal candidate  #
#          for the given cell                                                  #
#                                                                              #
# Last update:                                                                 #
#   19/05/2006                                                                 #
# Arguments:                                                                   #
#   $a0 - Number to check                                                      #
#   $a1 - Cell's row index                                                     #
#   $a2 - Cell's column index                                                  #
# Registers used:                                                              #
#   None                                                                       #
################################################################################
check:
    # Row check
    li      $t0, 9                # Set counter
    mul     $t1, $a1, $t0         # Offset of the first cell in the row
check_row:
    lb      $t2, board + 0($t1)   # Value in the current cell
    beq     $a0, $t2, check_ret_fail  # Number already present in row
    addi    $t1, $t1, 1           # Increment the pointer to the current cell
    sub     $t0, $t0, 1           # Decrement the counter
    bnez    $t0, check_row        # Check the next cell in the row

    # Column check
    move    $t1, $a2              # Offset of the first cell in the column
check_col:
    lb      $t2, board + 0($t1)   # Value of the current cell
    beq     $a0, $t2, check_ret_fail  # Number already present in column
    addi    $t1, $t1, 9           # Increment the pointer to the current cell
    ble     $t1, 81, check_col    # Check the next cell in the column

    # 3x3-Box check
    div     $t0, $a1, 3           # $t0 = row / 3
    mul     $t0, $t0, 27          # Offset of the row
    div     $t1, $a2, 3           # $t1 = col / 3
    mul     $t1, $t1, 3           # Offset of the column
    add     $t1, $t0, $t1         # Offset of the first cell in the box

    li      $t0, 3                # Set up the row counter
    li      $t3, 3                # Set up the column counter
check_box:
    lb      $t2, board + 0($t1)   # Value of the current cell
    beq     $a0, $t2, check_ret_fail  # Number already present in column
    sub     $t3, $t3, 1           # Decrement the column counter
    beqz    $t3, end_box_row      # Check if end of current box row is reached
    addi    $t1, $t1, 1           # Increment the pointer to the current cell
    j       check_box             # Check the next cell in the row
end_box_row:
    addi    $t1, $t1, 7           # Increment the pointer to the current cell
    li      $t3, 3                # Reset the column counter
    sub     $t0, $t0, 1           # Decrement the row counter
    bnez    $t0, check_box        # Check if end of box is reached

    move    $v0, $zero            # Return code is 0 (success)
    j       check_ret             # Jump to the return instructions

check_ret_fail:
    li      $v0, 1                # Return code is 1 (failure)

check_ret:
    jr      $ra                   # Return

################################################################################
# print_board -- Print the Sudoku board                                        #
#                                                                              #
# Last update:                                                                 #
#   18/05/2006                                                                 #
# Arguments:                                                                   #
#   None                                                                       #
# Registers used:                                                              #
#   $s0 - address of the cell to print                                         #
#   $s1 - row counter                                                          #
#   $s2 - column counter                                                       #
################################################################################
print_board:
    # Set up the stack frame
    sub     $sp, $sp, 16          # Make room on the stack to save registers
    sw      $ra, 12($sp)          # Save the return address
    sw      $s2, 8($sp)           # Save the $s2 register
    sw      $s1, 4($sp)           # Save the $s1 register
    sw      $s0, 0($sp)           # Save the $s0 register

    # Initialize registers
    la      $s0, board            # $s0 points to the cell to print
    move    $s1, $zero            # $s1 keeps track of the current row
    move    $s2, $zero            # $s2 keeps track of the current column

    # Print top border
    la      $a0, h_sep            # Load the address of the string to print
    li      $v0, 4                # Load print_string syscall number in $v0
    syscall                       # Execute the syscall

print_cell:
    # Print the cell's vertical border
    la      $a0, v_sep            # Load the address of the string to print
    li      $v0, 4                # Load print_string syscall number in $v0
    syscall                       # Execute the syscall

    # Print the number in the current cell
    lb      $a0, ($s0)            # Load the address of the number to print
    li      $v0, 1                # Load print_int syscall number in $v0
    syscall                       # Execute the syscall

    addi    $s0, $s0, 1           # Point to the next board cell
    addi    $s2, $s2, 1           # Increment the column counter

    blt     $s2, 9, print_cell    # Iterate the loop until the row is completed

    # Row completed: print the rightmost border and a new separator
    la      $a0, new_row          # Load the address of the string to print
    li      $v0, 4                # Load print_string syscall number in $v0
    syscall                       # Execute the syscall

    move    $s2, $zero            # Reset the column counter
    addi    $s1, $s1, 1           # Increment the row counter

    # Print the next row
    blt     $s1,9, print_cell     # Restart the loop until the table is cmplete

    # Destroy the stack frame
    lw      $s0, 0($sp)           # Restore the $s0 register
    lw      $s1, 4($sp)           # Restore the $s1 register
    lw      $s2, 8($sp)           # Restore the $s2 register
    lw      $ra, 12($sp)          # Restore the return address
    addi    $sp, $sp, 16          # Clean up the stack
    jr      $ra                   # Return


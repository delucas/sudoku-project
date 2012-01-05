;;;; sudokiller.asm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                            ;;
;; Sudoku game solver                                                         ;;
;;                                                                            ;;
;; Version      : 1.0                                                         ;;
;; Created date : 05/09/2005                                                  ;;
;; Last update  : 06/09/2005                                                  ;;
;; Author       : Daniele Mazzocchio                                          ;;
;;                                                                            ;;
;; Replace the 'board' table with the puzzle you want to be solved, filling   ;;
;; the empty cells with zeroes. Then compile and run this program using the   ;;
;; commands:                                                                  ;;
;;                                                                            ;;
;;   nasm -f elf sudokiller.asm                                               ;;
;;   gcc -o sudokiller sudokiller.o                                           ;;
;;   ./sudokiller                                                             ;;
;;                                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[section .data]
align 4

; This is the game board. Fill it with the puzzle you want to solve
board       db    0, 6, 0, 1, 0, 4, 0, 5, 0
            db    0, 0, 8, 3, 0, 5, 6, 0, 0
            db    2, 0, 0, 0, 0, 0, 0, 0, 1
            db    8, 0, 0, 4, 0, 7, 0, 0, 6
            db    0, 0, 6, 0, 0, 0, 3, 0, 0
            db    7, 0, 0, 9, 0, 1, 0, 0, 4
            db    5, 0, 0, 0, 0, 0, 0, 0, 2
            db    0, 0, 7, 2, 0, 6, 9, 0, 0
            db    0, 4, 0, 5, 0, 8, 0, 7, 0

; printf format strings
separator   db    "+---+---+---+---+---+---+---+---+---+", 0Ah, 0
board_row   db    "| %d | %d | %d | %d | %d | %d | %d | %d | %d |", 0Ah, 0


[section .text]
align 4

extern printf, exit
global main

; Single-line macros -----------------------------------------------------------
%define  SIZE      9                 ; Width of the Sudoku board
%define  BOX_W     3                 ; Width of the inner boxes
%define  BOX_H     3                 ; Height of the inner boxes
%define  EMPTY     0                 ; Empty cells marker
%define  RET_OK    0                 ; Return code upon success
%define  RET_FAIL  1                 ; Return code upon failure

; Macros -----------------------------------------------------------------------
%macro  print_separator      0       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push   dword separator           ;
    call   printf                    ; Print a separator between board lines
    add    esp, 4                    ;
%endmacro                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%macro  setup_stack_frame    0       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push   ebp                       ;
    mov    ebp, esp                  ; Set up the stack frame according to the
    push   ebx                       ;   C calling convention, preserving the
    push   esi                       ;   ebp, ebx, esi and edi registers.
    push   edi                       ;
%endmacro                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%macro  destroy_stack_frame  0       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    pop    edi                       ;
    pop    esi                       ; Destroy the stack frame restoring the
    pop    ebx                       ;   edi, esi, ebx and ebp registers to
    mov    esp, ebp                  ;   their original values.
    pop    ebp                       ;
%endmacro                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;-------------------------------------------------------------------------------
; main - Call the guess() function and print the resulting board. If no solution
;        exists, the board will be printed as it is (with zeroes)
;
; Last update : 06/09/2005
; Args        : None
; Action      : Call guess(), print the board and exit cleanly.
;-------------------------------------------------------------------------------
main:
    setup_stack_frame                ; Set up stack frame

    push   dword 0                   ; Offset of first cell to guess
    call   guess                     ; Start brute forcing the solution
    add    esp, 4                    ; Clean up the stack
    mov    ebx, eax                  ; Save return code

    call   print_board               ; Print resulting board

    push   ebx                       ; Exit with guess() return code
    call   exit                      ; Exit cleanly
    add    esp, 4                    ; Clean up the stack

    destroy_stack_frame              ; Destroy stack frame
    ret                              ; Return

;-------------------------------------------------------------------------------
; guess - Test all candidate numbers for the current cell until the board is
;         complete
;
; Last update : 06/09/2005
; Args        : offset (at [ebp + 8]) - Offset of the cell to guess
; Action      : Loop on numbers from 9 to 1 to find candidates for the current
;               cell. If none is found, return RET_FAIL. Otherwise go on to the
;               next cell.
;-------------------------------------------------------------------------------
guess:
    setup_stack_frame                ; Set up stack frame

    mov    esi, [ebp + 8]            ; Store offset in esi
    cmp    esi, SIZE * SIZE          ; Is offset outside the board bounds?
    je     .return_ok                ;   If it is, return RET_OK

    xor    edx, edx                  ; Clean edx
    mov    eax, esi                  ; eax = offset
    mov    ecx, SIZE                 ; Set divisor to find cell's column
    div    cx                        ; edx = column index of cell
    mov    ebx, eax                  ; ebx = row index of cell

    cmp    byte [board + esi], EMPTY ; Check if cell is empty
    je     .loop                     ;   If it is, jump to the loop
    inc    esi                       ;   Otherwise increment offset
    push   esi                       ;   push it on the stack
    call   guess                     ;   and go on to the next cell
    add    esp, 4                    ; Clean up the stack
    jmp    .return                   ; Return the value returned by guess()

    .loop:
        push   edx                   ; Push cell column index
        push   ebx                   ; Push cell row index
        push   ecx                   ; Push number to check
        call   check                 ; Check if number is a legal candidate
        pop    ecx                   ; Restore ecx (number to check)
        pop    ebx                   ; Restore ebx (row index)
        pop    edx                   ; Restore edx (column index)

        cmp    eax, RET_OK           ; Examine check() return value
        jne    .next                 ;   If RET_FAIL, try next number
        mov    byte [board + esi], cl ;  If RET_OK, assign number to cell

        push   ecx                   ; Save ecx
        push   edx                   ; Save edx
        inc    esi                   ; Increment offset of number to guess
        push   esi                   ; Push guess() argument
        call   guess                 ; Call guess() on next cell
        add    esp, 4                ; Clean up the stack
        pop    edx                   ; Restore edx
        pop    ecx                   ; Restore ecx

        cmp    eax, RET_OK           ; Examine guess() return value
        je     .return               ;   If RET_OK, return RET_OK
        dec    esi                   ;   If RET_FAIL, restore esi to current offset
        .next:
            loop   .loop             ; Loop on every number form 9 to 1

        mov    byte [board + esi], EMPTY ; If no number worked, empty the cell

    mov    eax, RET_FAIL             ; Set return value to RET_FAIL
    jmp    .return                   ; Jump to Return instructions

    .return_ok:
        xor    eax, eax              ; Set return value to RET_OK

    .return:
        destroy_stack_frame          ; Destroy the stack frame
        ret                          ; Return

;-------------------------------------------------------------------------------
; check - Check if a number is, according to Sudoku rules, a legal candidate for
;         the given cell
;
; Last update : 06/09/2005
; Args        : num (at [ebp + 8])  - Number to check
;               row (at [ebp + 12]) - Cell's row index
;               col (at [ebp + 16]) - Cell's column index
; Action      : Return RET_FAIL if the number already appears in the row, column
;               or 3x3 box the cell belongs to. Otherwise return RET_OK.
;-------------------------------------------------------------------------------
check:
    setup_stack_frame                ; Set up stack frame

    mov    ebx, [ebp + 8]            ; Store number in ebx
    cld                              ; Clear DF

;;; Row check - Point to the beginning of the row ([board] + row * SIZE) and
;;; parse it looking for the number we're checking
    mov    esi, board                ; Load board address in esi
    mov    eax, [ebp + 0Ch]          ; Load row in eax
    mov    ecx, SIZE                 ; Set column counter
    mul    cl                        ; eax = row offset from board
    add    esi, eax                  ; esi = address of row's first cell
    .row_check:
        lodsb                        ; eax = number in current cell
        cmp    al, bl                ; Does the cell contain our number?
        je     .return_fail          ;   If it does, return RET_FAIL
        loop   .row_check            ;   Otherwise, go on to the next cell

;;; Column check - Point to the beginning of the column ([board] + col) and
;;; parse it looking for the number we're checking
    mov    esi, board                ; Store board address in esi
    mov    eax, [ebp + 010h]         ; Load col in eax
    add    esi, eax                  ; esi = Column offset from board
    mov    ecx, SIZE                 ; Set row counter
    .col_check:
        cmp    byte [esi], bl        ; Does the cell contain our number?
        je     .return_fail          ;   If it does, return RET_FAIL
        add    esi, SIZE             ;   Otherwise, point to the next cell
        loop   .col_check            ;   and loop on each column cell

;;; Box check - Point to the top-left corner of the box the cell belongs to
;;; ([board] + (col - (col % BOX_H)) + ((row - (row % BOX_W)) * SIZE)) and
;;; parse it looking for the number we're checking
    mov    esi, board                ; Store board address in esi
    mov    edx, eax                  ; edx = col
    mov    ecx, BOX_H                ; Set divisor
    div    cl                        ; ah = col % BOX_H
    sub    dl, ah                    ; dl = (col - (col % 3))
    add    esi, edx                  ; esi = [board] + (col - (col % 3))

    mov    eax, [ebp + 0Ch]          ; eax = row
    mov    edx, eax                  ; edx = row
    div    cl                        ; ah = row % BOX_W
    sub    dl, ah                    ; dl = (row - (row % 3))

    mov    eax, SIZE                 ; Set multiplicator
    mul    dl                        ; eax = ((row - (row % 3)) * 9)
    add    esi, eax                  ; esi = address of box's top-left corner
    .box_check:
        mov    edx, ecx              ; Save row counter
        mov    ecx, BOX_W            ; Set column counter
        .box_row_check:
            lodsb                    ; eax = number in current cell
            cmp    al, bl            ; Does the cell contain our number?
            je     .return_fail      ;   If it does, return RET_FAIL
            loop   .box_row_check    ;   Otherwise go on to the next row cell
        add    esi, SIZE - BOX_W     ; Point to the beginning of next row
        mov    ecx, edx              ; Restore row counter
        loop   .box_check            ; Loop on each box row

    xor    eax, eax                  ; eax = RET_OK (0)
    jmp    .return                   ; Number is a legal candidate for this cell

    .return_fail:
        mov    eax, RET_FAIL         ; Store return value in eax

    .return:
        destroy_stack_frame          ; Destroy stack frame
        ret                          ; Return


;-------------------------------------------------------------------------------
; print_board - Print the Sudoku board
;
; Last update : 06/09/2005
; Args        : None
; Action      : Read board rows pushing each number on the stack and print them.
;               Rows are read from right to left to push printf arguments in
;               reverse order
;-------------------------------------------------------------------------------
print_board:
    setup_stack_frame                ; Set up stack frame

    print_separator                  ; Print top border

    mov    esi, board + (SIZE - 1)   ; Point to the end of the first row
    mov    ecx, SIZE                 ; Set rows counter
    .loop:
        std                          ; Set DF to load data in reverse order
        mov    ebx, ecx              ; Save the outer loop counter
        mov    ecx, SIZE             ; Set the columns counter
        .inloop:
            lodsb                    ; Store cell content in eax
            push   eax               ;   and push it on the stack for printf
            loop   .inloop           ; Loop on each row cell

        push   board_row             ; Push format string
        call   printf                ; Print row
        add    esp, 028h             ; Clean stack

        print_separator              ; Print separator between rows

        add    esi, SIZE * 2         ; Point to the end of the next row
        mov    ecx, ebx              ; Restore the outer loop counter
        loop   .loop                 ; Loop on each row

    destroy_stack_frame              ; Destroy stack frame
    ret                              ; Return

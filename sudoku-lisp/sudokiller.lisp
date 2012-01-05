;;; Sudokiller.lisp -- A Lisp sudoku solver

;; Name: sudokiller.lisp
;; Version: 1.0
;; Created: 29 Sep 2005
;; Last Update: 30 Sep 2005
;; Author: Daniele Mazzocchio

;;; Commentary:

;; Fill the 'board' array with the SuDoku table, replacing the empty cells
;; with zeroes, and run this script.
;;
;; Download sources

;;; Code:

;; This is the game board. Fill it with the puzzle you want to solve
(defvar board #2a((0 6 0 1 0 4 0 5 0)
                  (0 0 8 3 0 5 6 0 0)
                  (2 0 0 0 0 0 0 0 1)
                  (8 0 0 4 0 7 0 0 6)
                  (0 0 6 0 0 0 3 0 0)
                  (7 0 0 9 0 1 0 0 4)
                  (5 0 0 0 0 0 0 0 2)
                  (0 0 7 2 0 6 9 0 0)
                  (0 4 0 5 0 8 0 7 0)))

(defconstant board-size 9   "Width and Height of the SuDoku board")
(defconstant box-size   3   "Width and height of the 3x3 box")
(defconstant empty      0   "Empty cell marker")

(defun guess (index)
  "Test all candidate numbers for current cell until board is complete"
  (let ((row (truncate (/ index board-size)))
        (col (mod index board-size)))
    (if (not (array-in-bounds-p board row col))
        t
        (if (/= (aref board row col) empty)
            (guess (1+ index))
            ;; Test all numbers from 1 to 9
            (loop for i from 1 to board-size
              do (and (check i row col)
                      (progn
                        (setf (aref board row col) i)
                        (and (guess (1+ index)) (return t))))
              finally (progn
                        (setf (aref board row col) empty)
                        (return nil)))))))

(defun check (num row col)
  "Check if a number is, according to the Sudoku rules, a legal candidate for
   the cell identified by its row and column indexes"
  ;; Get the top left corner indexes of the cell's 3x3 box
  (let ((r (* (truncate (/ row box-size)) box-size))
        (c (* (truncate (/ col box-size)) box-size)))
    (dotimes (i board-size t)
      (and (or (= num (aref board row i))                  ; Row check
               (= num (aref board i col))                  ; Column check
               (= num (aref board (+ r (mod i box-size))   ; Box check
                                  (+ c (truncate (/ i box-size))))))
           (return nil)))))

(defun print-board ()
  "Print the resulting board"
  (dotimes (r board-size)
    (format t "~%+---+---+---+---+---+---+---+---+---+~%|")
    (dotimes (c board-size)
      (format t " ~A |" (aref board r c))))
  (format t "~%+---+---+---+---+---+---+---+---+---+~%~%"))


(and (or (guess 0) (format t "Sorry, solution not found..."))
     (print-board))


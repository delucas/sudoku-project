package main

import "fmt"

var board = []int{0, 0, 0, 0, 7, 0, 9, 4, 0,
	0, 0, 0, 0, 9, 0, 0, 0, 5,
	3, 0, 0, 0, 0, 5, 0, 7, 0,
	0, 0, 7, 4, 0, 0, 1, 0, 0,
	4, 6, 3, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 7, 0, 8, 0,
	8, 0, 0, 0, 0, 0, 0, 0, 0,
	7, 0, 0, 0, 0, 0, 0, 2, 8,
	0, 5, 0, 2, 6, 0, 0, 0, 0}

func displayBoard() {
	fmt.Println("-------------------------")

	for i := 0; i < 9; i++ {
		for j := 0; j < 9; j++ {
			if j%3 == 0 {
				fmt.Printf("| %d ", board[i*9+j])
			} else {
				fmt.Printf("%d ", board[i*9+j])
			}

		}
		fmt.Println("|")
		if (i+1)%3 == 0 {
			fmt.Println("-------------------------")
		}
	}
}

func check(cell, num int) bool {
	row := 9 * (cell / 9)
	col := cell % 9
	blockRow := (row / 27) * 27
	blockCol := (col / 3) * 3

	for i := 0; i < 9; i++ {
		if board[row+i] == num {
			return false
		}
	}

	for i := 0; i < 9; i++ {
		if board[col+(i*9)] == num {
			return false
		}
	}

	for i := 0; i < 3; i++ {
		if board[blockRow+blockCol+i] == num {
			return false
		}
	}

	for i := 0; i < 3; i++ {
		if board[(blockRow+9)+blockCol+i] == num {
			return false
		}
	}

	for i := 0; i < 3; i++ {
		if board[(blockRow+18)+blockCol+i] == num {
			return false
		}
	}

	return true
}

func guess(cell int) bool {
	if cell >= 81 {
		return true
	}

	if board[cell] != 0 {
		return guess(cell + 1)
	}

	for num := 1; num < 10; num++ {
		if check(cell, num) {
			board[cell] = num
			if guess(cell + 1) {
				return true
			}
		}
	}

	board[cell] = 0
	return false
}

func main() {
	fmt.Println("Unsolved puzzle")
	displayBoard()
	guess(0)
	fmt.Printf("\n=========================\n\n")
	fmt.Println("Solved puzzle")
	displayBoard()
	return
}

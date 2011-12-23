package ar.delucas.sudoku;

import java.util.Arrays;

import ar.delucas.sudoku.exceptions.CellOutOfRangeException;
import ar.delucas.sudoku.exceptions.MalformedSudokuException;

public class Sudoku {

	private Cell[][] board = new Cell[9][9];

	public Sudoku(String stringBoard) {

		if (stringBoard.length() != 81) {
			throw new MalformedSudokuException();
		}
		if (!validBoardDigits(stringBoard)) {
			throw new MalformedSudokuException();
		}

		parseBoard(stringBoard);

	}

	public boolean solve() {
		return solve(0, 0);
	}

	private boolean solve(int i, int j) {
		if (i == 9) {
			i = 0;
			if (++j == 9) {
				return true;
			}
		}
		if (this.board[i][j].value() != 0) {
			return solve(i + 1, j);
		}

		for (int val = 1; val <= 9; val++) { // mejorar
			if (legal(i, j, val)) {
				this.board[i][j].value(val);
				if (solve(i + 1, j)) {
					return true;
				}
			}
		}
		this.board[i][j].value(0);
		return false;
	}

	private boolean legal(int row, int column, int value) {
		for (int tempRow = 0; tempRow < 9; tempRow++) {
			if (this.board[tempRow][column].value() == value) {
				return false;
			}
		}

		for (int tempColumn = 0; tempColumn < 9; tempColumn++) {
			if (this.board[row][tempColumn].value() == value) {
				return false;
			}
		}

		int tempRow = (row / 3) * 3;
		int tempCol = (column / 3) * 3;

		for (int offsetRow = 0; offsetRow < 3; offsetRow++) {
			for (int offsetCol = 0; offsetCol < 3; offsetCol++) {
				if (this.board[tempRow + offsetRow][tempCol + offsetCol]
						.value() == value) {
					return false;
				}
			}
		}

		return true;

	}

	public Cell get(int i, int j) {
		if (!(i >= 1 && i <= 9) || !(j >= 1 && j <= 9)) {
			throw new CellOutOfRangeException();
		}
		return board[i - 1][j - 1];
	}

	public boolean isSolved() {
		return checkRows() && checkColumns() && checkBoxes();
	}

	public String toString() {
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				buffer.append(this.board[i][j].value());
				if (j % 3 == 2) {
					buffer.append(" ");
				}
			}
			buffer.append("\n");
			if (i % 3 == 2) {
				buffer.append("\n");
			}
		}
		return buffer.toString();
	}

	private boolean checkRows() {
		boolean check = true;
		for (int i = 0; i < 9 && check; i++) {
			boolean[] values = new boolean[9];
			for (int j = 0; j < 9 && check; j++) {
				if (board[i][j].value() != 0) {
					values[board[i][j].value() - 1] = true;
				} else {
					check = false;
				}
			}
			for (int j = 0; j < values.length; j++) {
				check = check && values[j];
			}
		}
		return check;
	}

	private boolean checkColumns() {
		boolean check = true;
		for (int i = 0; i < 9 && check; i++) {
			boolean[] values = new boolean[9];
			for (int j = 0; j < 9 && check; j++) {
				if (board[i][j].value() != 0) {
					values[board[j][i].value() - 1] = true;
				} else {
					check = false;
				}
			}
			for (int j = 0; j < values.length; j++) {
				check = check && values[j];
			}
		}
		return check;
	}

	private boolean checkBoxes() {
		boolean check = true;

		for (int i = 0; i < 9 && check; i += 3) {
			for (int j = 0; j < 9 && check; j += 3) {
				boolean[] values = new boolean[9];
				for (int offsetRow = 0; offsetRow < 3; offsetRow++) {
					for (int offsetCol = 0; offsetCol < 3; offsetCol++) {
						if (this.board[i + offsetRow][j + offsetCol].value() != 0) {
							values[this.board[i + offsetRow][j + offsetCol]
									.value() - 1] = true;
						} else {
							check = false;
						}
					}
				}
				for (int k = 0; k < values.length; k++) {
					check = check && values[k];
				}
			}
		}
		return check;
	}

	private void parseBoard(String stringBoard) {
		for (int i = 0; i < stringBoard.length(); i++) {
			int value = Character.digit(stringBoard.charAt(i), 10);
			board[i / 9][i % 9] = new Cell(value);
		}
	}

	private boolean validBoardDigits(String baseBoard) {
		String validDigits = "0123456789";

		boolean isValid = true;
		for (int i = 0; i < baseBoard.length() && isValid; i++) {
			if (!validDigits.contains(charAt(baseBoard, i))) {
				isValid = false;
			}
		}
		return isValid;
	}

	private String charAt(String baseBoard, int i) {
		return new Character(baseBoard.charAt(i)).toString();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(board);
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Sudoku other = (Sudoku) obj;
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				if (!this.board[i][j].equals(other.board[i][j])) {
					return false;
				}
			}
		}
		return true;
	}
}

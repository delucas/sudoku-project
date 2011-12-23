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
		if (!validDigits(stringBoard)) {
			throw new MalformedSudokuException();
		}

		parseBoard(stringBoard);

	}

	public boolean solve() {
		boolean solved = false;

		// TODO
		
		return solved;
	}

	public boolean isSolved(){
		return checkRows() && checkColumns() && checkBoxes();
	}
	
	private boolean checkRows() {
		boolean check = true;
		for (int i = 0; i < 9 && check; i++) {
			boolean[] values = new boolean[9];
			for (int j = 0; j < 9 && check; j++) {
				values[board[i][j].value()-1] = true;
			}
			for (int j = 0; j < values.length; j++){
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
				values[board[j][i].value()-1] = true;
			}
			for (int j = 0; j < values.length; j++){
				check = check && values[j];
			}
		}
		return check;
	}
	
	private boolean checkBoxes() {
		boolean check = true;
		
		for (int i = 0; i < 9 && check; i+=3){
			for (int j = 0; j < 9 && check; j+=3){
				boolean[] values = new boolean[9];
				for(int offsetRow = 0; offsetRow < 3; offsetRow++) {
					for (int offsetCol = 0; offsetCol < 3; offsetCol++) {
						values[this.board[i+offsetRow][j+offsetCol].value()-1] = true;
					}
				}
				for (int k = 0; k < values.length; k++){
					check = check && values[k];
				}
			}
		}
		return check;
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

	private void parseBoard(String stringBoard) {
		for (int i = 0; i < stringBoard.length(); i++) {
			int value = Character.digit(stringBoard.charAt(i), 10);
			board[row(i)][col(i)] = new Cell(value);
		}
	}

	private int row(int i) {
		return i / 9;
	}

	private int col(int i) {
		return i % 9;
	}

	private boolean validDigits(String baseBoard) {
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

	public Cell get(int i, int j) {
		if (!(i >= 1 && i <= 9) || !(j >= 1 && j <= 9)) {
			throw new CellOutOfRangeException();
		}
		return board[i - 1][j - 1];
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
			for(int j = 0; j < 9; j++) {
				if (!this.board[i][j].equals(other.board[i][j])){
					return false;
				}
			}
		}
		return true;
	}
}

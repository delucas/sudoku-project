package ar.delucas.sudoku;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import ar.delucas.sudoku.exceptions.MalformedSudokuException;

public class Sudoku {

	private static final int TOTAL_CELLS = 81;

	private Cell[][] board = new Cell[9][9];

	private Map<Integer, Region> rows = new HashMap<Integer, Region>();
	private Map<Integer, Region> columns = new HashMap<Integer, Region>();
	private Map<Integer, Region> boxes = new HashMap<Integer, Region>();

	public Sudoku(String stringBoard) {

		if (stringBoard.length() != TOTAL_CELLS) {
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
		if (this.board[i][j].hasValue()) {
			return solve(i + 1, j);
		}

		for (int val : this.board[i][j].getPossibleValues()) {
			this.board[i][j].value(val);
			if (solve(i + 1, j)) {
				return true;
			}
		}
		this.board[i][j].removeValue();
		return false;
	}

	public boolean isSolved() {
		return isSolved(this.rows) && isSolved(this.columns)
				&& isSolved(this.boxes);
	}

	public boolean isSolved(Map<Integer, Region> map) {
		boolean result = true;
		for (Integer key : map.keySet()) {
			result = result && map.get(key).isSolved();
		}
		return result;
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

			this.addToBoard(i / 9, i % 9, value);
		}
	}

	private void addToBoard(int row, int column, int value) {
		Cell cell = new Cell(value);

		Region rowRegion = this.rows.get(row + 1);
		if (rowRegion == null) {
			rowRegion = new Region();
			this.rows.put(row + 1, rowRegion);
		}
		cell.setRow(rowRegion);
		rowRegion.add(cell);

		Region columnRegion = this.columns.get(column + 1);
		if (columnRegion == null) {
			columnRegion = new Region();
			this.columns.put(column + 1, columnRegion);
		}
		cell.setColumn(columnRegion);
		columnRegion.add(cell);

		Integer box = calculateBox(row, column);
		Region boxRegion = this.boxes.get(box);
		if (boxRegion == null) {
			boxRegion = new Region();
			this.boxes.put(box, boxRegion);
		}
		cell.setBox(boxRegion);
		boxRegion.add(cell);

		this.board[row][column] = cell;
	}

	private Integer calculateBox(int row, int column) {
		int base = 0;
		switch (row) {
		case 0:
		case 1:
		case 2:
			base = 0;
			break;
		case 3:
		case 4:
		case 5:
			base = 1;
			break;

		case 6:
		case 7:
		case 8:
			base = 2;
			break;

		}

		int offset = 1;
		switch (column) {
		case 0:
		case 1:
		case 2:
			offset = 1;
			break;
		case 3:
		case 4:
		case 5:
			offset = 2;
			break;

		case 6:
		case 7:
		case 8:
			offset = 3;
			break;

		}
		return base * 3 + offset;
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

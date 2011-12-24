package ar.delucas.sudoku;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import ar.delucas.sudoku.exceptions.MalformedSudokuException;

/**
 * Representa un tablero de Sudoku, y brinda la posibilidad de resolverlo.
 * 
 * @author Lucas Videla
 *
 */
public class Sudoku {

	private static final int TOTAL_CELLS = 81;

	private Cell[][] board = new Cell[9][9];

	private Map<Integer, Region> rows = new HashMap<Integer, Region>();
	private Map<Integer, Region> columns = new HashMap<Integer, Region>();
	private Map<Integer, Region> boxes = new HashMap<Integer, Region>();

	/**
	 * Construye el tablero basándose en un string suministrado
	 * <pre>String board = "00123456879..."</pre>
	 * El tablero debe contener 81 caracteres, y estar conformado
	 * exclusivamente por números.
	 * <ul>
	 *  <li><b>0</b> representa una celda vacía</li>
	 *  <li><b>1..9</b> representa una celda tomada</li>
	 * </ul>
	 * 
	 * @param stringBoard el tablero a informar
	 * @throws MalformedSudokuException si no se suministra un tablero válido.
	 */
	public Sudoku(String stringBoard) {

		if (stringBoard.length() != TOTAL_CELLS) {
			throw new MalformedSudokuException();
		}
		if (!validBoardDigits(stringBoard)) {
			throw new MalformedSudokuException();
		}

		parseBoard(stringBoard);
	}

	/**
	 * Intenta resolver el Sudoku.
	 * @return <b>true</b> si pudo resolverlo
	 */
	public boolean solve() {
		return solve(0, 0);
	}

	/**
	 * Credito por la base del algoritmo de backtracking:
	 * <pre>http://www.colloquial.com/games/sudoku/java_sudoku.html</pre> 
	 */
	private boolean solve(int row, int col) {
		if (row == 9) {
			row = 0;
			if (++col == 9) {
				return true;
			}
		}
		if (this.board[row][col].hasValue()) {
			return solve(row + 1, col);
		}

		for (int val : this.board[row][col].getPossibleValues()) {
			this.board[row][col].value(val);
			if (solve(row + 1, col)) {
				return true;
			}
		}
		this.board[row][col].removeValue();
		return false;
	}

	public boolean isSolved() {
		return isSolved(this.rows) && isSolved(this.columns)
				&& isSolved(this.boxes);
	}

	private boolean isSolved(Map<Integer, Region> map) {
		boolean result = true;
		for (Integer key : map.keySet()) {
			result = result && map.get(key).isSolved();
		}
		return result;
	}

	private void parseBoard(String stringBoard) {
		for (int i = 0; i < stringBoard.length(); i++) {
			int value = Character.digit(stringBoard.charAt(i), 10);

			this.addToBoard(i / 9, i % 9, value);
		}
	}

	private void addToBoard(int row, int column, int value) {
		Cell cell = new Cell(value);

		cell.setRow(attachToRegion(cell, this.rows, row + 1));

		cell.setColumn(attachToRegion(cell, this.columns, column + 1));
		
		Integer box = calculateBox(row, column);
		cell.setBox(attachToRegion(cell, this.boxes, box));
		
		this.board[row][column] = cell;
	}

	private Region attachToRegion(Cell cell, Map<Integer, Region> regionMap, Integer index) {
		Region region = regionMap.get(index);
		
		if (region == null) {
			region = new Region();
			regionMap.put(index, region);
		}
		region.add(cell);
		
		return region;
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
		for (int index = 0; isValid && index < baseBoard.length(); index++) {
			if (!validDigits.contains(charAt(baseBoard, index))) {
				isValid = false;
			}
		}
		return isValid;
	}

	private String charAt(String baseBoard, int i) {
		return new Character(baseBoard.charAt(i)).toString();
	}

	@Override
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

package ar.delucas.sudoku;

import org.junit.Test;

import ar.delucas.sudoku.exceptions.MalformedSudokuException;

public class SudokuCreationTest {

	@Test(expected = MalformedSudokuException.class)
	public void testMalformedSudokuBadCharacters() {
		StringBuffer malformedBoard = new StringBuffer();
		for (int i = 0; i < 81; i++) {
			if (i != 50) {
				malformedBoard.append("0");
			} else {
				malformedBoard.append("t");
			}
		}
		new Sudoku(malformedBoard.toString());
	}
	
	@Test(expected = MalformedSudokuException.class)
	public void testMalformedSudokuLessCells() {
		StringBuffer malformedBoard = new StringBuffer();
		for (int i = 0; i < 80; i++) {
			malformedBoard.append("0");
		}
		new Sudoku(malformedBoard.toString());
	}

	@Test(expected = MalformedSudokuException.class)
	public void testMalformedSudokuMoreCells() {
		StringBuffer malformedBoard = new StringBuffer();
		for (int i = 0; i < 82; i++) {
			malformedBoard.append("0");
		}
		new Sudoku(malformedBoard.toString());
	}

	@Test
	public void testCorrectSudoku() {
		StringBuffer board = new StringBuffer();
		for (int i = 0; i < 81; i++) {
			board.append("0");
		}
		new Sudoku(board.toString());
	}

}

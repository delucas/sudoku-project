package ar.delucas.sudoku;

import org.junit.Assert;
import org.junit.Test;

import ar.delucas.sudoku.exceptions.CellOutOfRangeException;

public class SudokuAccessTest {

	@Test
	public void testSudokuEachCell() {
		StringBuffer board = new StringBuffer();
		for (int i = 0; i < 81; i++) {
			board.append(i%9 + 1);
		}
		Sudoku s = new Sudoku(board.toString());
		
		for (int i = 1; i <= 9; i++){
			for (int j = 1; j <= 9; j++){
				Assert.assertEquals(j,s.get(i,j).value());
			}
		}
		
	}
	
	@Test
	public void testGetCell(){
		StringBuffer board = new StringBuffer();
		for (int i = 0; i < 81; i++) {
			board.append(i%9 + 1);
		}
		Sudoku s = new Sudoku(board.toString());
		
		@SuppressWarnings("unused")
		Cell c = s.get(1,1);
		
	}
	
	@Test(expected=CellOutOfRangeException.class)
	public void testGetOutOfRangeCell(){
		StringBuffer board = new StringBuffer();
		for (int i = 0; i < 81; i++) {
			board.append(i%9 + 1);
		}
		Sudoku s = new Sudoku(board.toString());
		
		@SuppressWarnings("unused")
		Cell c = s.get(0,0);
	}

}

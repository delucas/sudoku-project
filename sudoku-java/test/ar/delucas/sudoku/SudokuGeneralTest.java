package ar.delucas.sudoku;

import org.junit.Assert;
import org.junit.Test;

public class SudokuGeneralTest {

	@Test
	public void testSudokuEquals(){
		String board = "534678912672195348198342567859761423426853791713924856961537284287419635345286179";

		Sudoku s1 = new Sudoku(board);
		Sudoku s2 = new Sudoku(board);
		
		Assert.assertEquals(s1,s2);
	}
	
	@Test
	public void testSudokuNotEquals(){
		String board1 = "534678912672195348198342567859761423426853791713924856961537284287419635345286179";
		String board2 = "534678912672195348198342568759761423426853791713924856961537284287419635345286179";

		Sudoku s1 = new Sudoku(board1);
		Sudoku s2 = new Sudoku(board2);
		
		Assert.assertFalse(s1.equals(s2));
	}
	
}

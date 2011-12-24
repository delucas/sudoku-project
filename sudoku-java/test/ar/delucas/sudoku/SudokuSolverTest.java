package ar.delucas.sudoku;

import org.junit.Assert;
import org.junit.Test;

public class SudokuSolverTest {

	@Test
	public void testSudokuSolved(){
		String board = "534678912672195348198342567859761423426853791713924856961537284287419635345286179";
		Sudoku s = new Sudoku(board);
		
		Assert.assertTrue(s.isSolved());
		
	}
	
	@Test
	public void testSudokuSolves(){
		String board = "534678912672190348198342567809761423426853791713924856961537280287419635345286179";
		Sudoku s = new Sudoku(board);
		
		Assert.assertFalse(s.isSolved());
		
		Assert.assertTrue(s.solve());
		
		Assert.assertTrue(s.isSolved());
		
		
	}
	
	@Test
	public void testSudokuNotCorrectlySolved(){
		String board = "534678912672195348198342567859761423426853791713924856961537284278419635345286179";
		Sudoku s = new Sudoku(board);

		Assert.assertFalse(s.isSolved());
	}

}

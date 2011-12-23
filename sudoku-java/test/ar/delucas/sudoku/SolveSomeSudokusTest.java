package ar.delucas.sudoku;

import org.junit.Assert;
import org.junit.Test;

public class SolveSomeSudokusTest {

	
	@Test
	public void testEulerGrid1(){
		String board = "003020600900305001001806400008102900700000008006708200002609500800203009005010300";
		Sudoku s = new Sudoku(board);
		
		Assert.assertFalse(s.isSolved());
		Assert.assertTrue(s.solve());
		Assert.assertTrue(s.isSolved());
	}
	
	@Test
	public void testEulerGrid2(){
		String board = "200080300060070084030500209000105408000000000402706000301007040720040060004010003";
		Sudoku s = new Sudoku(board);
		
		Assert.assertFalse(s.isSolved());
		Assert.assertTrue(s.solve());
		Assert.assertTrue(s.isSolved());
	}
	
	@Test
	public void testEulerGrid3(){
		String board = "000000907000420180000705026100904000050000040000507009920108000034059000507000000";
		Sudoku s = new Sudoku(board);
		
		Assert.assertFalse(s.isSolved());
		Assert.assertTrue(s.solve());
		Assert.assertTrue(s.isSolved());
	}

	
	
}

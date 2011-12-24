package ar.delucas.sudoku;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class Region {

	private List<Cell> cells = new LinkedList<Cell>();

	public void add(Cell cell) {
		this.cells.add(cell);
		
	}
	
	public Set<Integer> getPossibleValues(){
		Set<Integer> possibleValues = new TreeSet<Integer>(Arrays.asList(new Integer[]{1,2,3,4,5,6,7,8,9}));
		
		for (Cell aCell : cells) {
			possibleValues.remove(aCell.value());
		}
		
		return possibleValues;
	}

	public boolean isSolved() {
		boolean check = true;
		boolean[] values = new boolean[9];
		for (Cell aCell : this.cells) {
			if (aCell.value() != 0) {
				values[aCell.value() - 1] = true;
			} else {
				check = false;
			}
		}
		for (int index = 0; index < values.length && check; index++) {
			check  = check && values[index];
		}
		return check;
	}

}

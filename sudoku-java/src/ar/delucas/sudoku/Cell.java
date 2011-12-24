package ar.delucas.sudoku;

import java.util.Set;

public class Cell {

	private int value;
	private Region boxRegion;
	private Region columnRegion;
	private Region rowRegion;
	
	public Cell(int value) {
		this.value = value;
	}
	
	public boolean legal(int val) {
		return getPossibleValues().contains(val);		
	}

	public Set<Integer> getPossibleValues() {
		Set<Integer> possibleValues = this.rowRegion.getPossibleValues();
		possibleValues.retainAll(columnRegion.getPossibleValues());
		possibleValues.retainAll(boxRegion.getPossibleValues());
		
		return possibleValues;
	}
	
	public void setRow(Region rowRegion) {
		this.rowRegion = rowRegion;
	}

	public void setColumn(Region columnRegion) {
		this.columnRegion = columnRegion;
	}

	public void setBox(Region boxRegion) {
		this.boxRegion = boxRegion;
	}

	public boolean hasValue() {
		return this.value != 0;
	}
	
	public void removeValue() {
		this.value = 0;
	}
	
	public int value() {
		return value;
	}

	public void value(int value) {
		this.value = value;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + value;
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
		Cell other = (Cell) obj;
		if (value != other.value)
			return false;
		return true;
	}
	
}

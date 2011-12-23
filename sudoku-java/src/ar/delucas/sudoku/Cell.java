package ar.delucas.sudoku;

public class Cell {

	private int value;

	public Cell(int value) {
		this.value = value;
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

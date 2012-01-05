/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
 
/* Created by Anjuta version 1.2.3 */
/* Written by David Stevenson ( david at avoncliff dot com ) March 2006 */
/* Based on Daniele Mazzocchio's sudokiller.asm */
/* Compile with "gcc -o sudokiller sudokiller.c" */

#include <stdio.h>

#define TRUE 1
#define FALSE 0

/* put your puzzle here  */
int board[81] = {0,0,0,0,7,0,9,4,0,
                 0,0,0,0,9,0,0,0,5,
                 3,0,0,0,0,5,0,7,0,
                 0,0,7,4,0,0,1,0,0,
                 4,6,3,0,0,0,0,0,0,
                 0,0,0,0,0,7,0,8,0,
                 8,0,0,0,0,0,0,0,0,
                 7,0,0,0,0,0,0,2,8,
                 0,5,0,2,6,0,0,0,0}; 

void display_board(void)
{
	int i, j;
	for(i=0; i<9; i++)
	{
		for(j=0; j<9; j++) putchar(0x30 + board[i*9+j]);
		putchar(10); putchar(13);
	}
}

int check(int cell, int num)
{
	int i, row, col;
	int block_row, block_col;
	row = 9 * (cell/9);
	col = cell%9;
	block_row = (row/27)*27;
	block_col = (col/3)*3;

	for(i=0; i<9; i++) if (board[row+i]==num) return FALSE;
	for(i=0; i<9; i++) if (board[col+(i*9)]==num) return FALSE;
	for(i=0; i<3; i++) if (board[block_row+block_col+i]==num) return FALSE;
	for(i=0; i<3; i++) if (board[(block_row+9)+block_col+i]==num) return FALSE;
	for(i=0; i<3; i++) if (board[(block_row+18)+block_col+i]==num) return FALSE;
	return TRUE;
}

int guess(int cell)
{
	int num;
	if (cell >= 81) return TRUE;
	if (board[cell]) return guess(cell+1);
	for (num=1; num<10; num++)
	{
		if (check(cell, num))
		{
			board[cell] = num;
			if (guess(cell+1)) return TRUE;
		}
	}
	board[cell] = 0;
	return FALSE;
}

int main(void)
{
	guess(0);
	display_board();
	return(0);
}


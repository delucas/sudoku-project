( *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  at your option any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 * )
( written by David Stevenson March 2006 david at avoncliff dot com )
( Based on Daniele Mazzocchio's sudokiller.asm )
( for gforth - although should work in others. Note rdrop may need to be r>drop )
." Sudoka in Forth "

create board ( enter your own board here )
2 c, 0 c, 0 c, 6 c, 7 c, 0 c, 0 c, 0 c, 0 c, 
0 c, 0 c, 6 c, 0 c, 0 c, 0 c, 2 c, 0 c, 1 c, 
4 c, 0 c, 0 c, 0 c, 0 c, 0 c, 8 c, 0 c, 0 c, 
5 c, 0 c, 0 c, 0 c, 0 c, 9 c, 3 c, 0 c, 0 c, 
0 c, 3 c, 0 c, 0 c, 0 c, 0 c, 0 c, 5 c, 0 c, 
0 c, 0 c, 2 c, 8 c, 0 c, 0 c, 0 c, 0 c, 7 c, 
0 c, 0 c, 1 c, 0 c, 0 c, 0 c, 0 c, 0 c, 4 c, 
7 c, 0 c, 8 c, 0 c, 0 c, 0 c, 6 c, 0 c, 0 c, 
0 c, 0 c, 0 c, 0 c, 5 c, 3 c, 0 c, 0 c, 8 c, 

( display board )
: print_val ( addr -- )	
		c@ dup 0= if ." - " drop else . then ;
: print_line ( addr -- )
		9 0 do dup i + print_val loop cr drop ;
: print_board ( -- )
		cr 9 0 do board 9 i * + print_line loop ;
		
( now solve it )
: check_row ( addr num -- f) ( 0 = num found )
	swap 9 0 do 2dup i + c@ = if unloop 2drop 0 exit then loop 2drop 1 ;
: check_col ( addr num -- f)
	swap 9 0 do 2dup 9 i * + c@ = if unloop 2drop 0 exit then loop 2drop 1 ;
: check_box ( addr num -- f )
	swap 3 0 do 2dup i + c@ = if unloop 2drop 0 exit then loop
	    12 9 do 2dup i + c@ = if unloop 2drop 0 exit then loop
	   21 18 do 2dup i + c@ = if unloop 2drop 0 exit then loop 2drop 1 ;
: box_calc ( cell -- box )
	27 /mod 27 * swap 9 mod 3 / 3 * + ;
: check_cell ( cell num -- f )
	>r dup 9 / 9 * board + r@ check_row 0= if rdrop drop 0 exit then 
		dup 9 mod board + r@ check_col 0= if rdrop drop 0 exit then
		box_calc board + r@ check_box 0= if rdrop 0 exit then rdrop 1 ;
: guess ( cell -- f ) recursive
	dup 81 = if drop  1 exit then
	dup board + c@ if 1 + guess exit then
	10 1 do 
		dup i check_cell if 
			dup board + i swap c!
			dup 1+ guess if drop 1 unloop exit then 
			then 
	loop board + 0 swap c! 0 ;
: sudokiller 0 guess if print_board else ." No solution found " then ;
sudokiller


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
( version 4 - reads from file 16x16 puzzle )
16 constant width
256 constant size
255 constant empty

variable board size allot
board size empty fill

( read file into buffer )
variable buff 1000 allot
s" sud_puzzle1" r/o open-file throw Value fh
buff 1000 fh read-file throw drop	
fh close-file throw 

( parse buffer and put values in array )		
: test-char ( c -- f )
	dup 44 < swap
	    70 > or ;  
variable pos-buf 0 pos-buf !
: get-next-val 	( -- n )
	begin buff pos-buf @ + c@
	dup test-char while ( false will exit with -- n )
	drop pos-buf 1 swap +! repeat ;
: load_square ( addr -- )
	get-next-val dup 47 > 
	if	48 - dup 9 > if 7 - then swap c!	
	else drop drop 
	then ;			
: load_line ( addr -- )
	width 0 do dup  i +  load_square pos-buf 1 swap +! loop drop ;
: load_board ( -- )
	width 0 do board width i * + load_line loop ;

( display board )
: print_val ( addr -- )	
		c@ dup empty = if ." - " drop else hex . decimal then ;
: print_line ( addr -- )
		width 0 do dup i + print_val loop cr drop ;
: print_board ( -- )
		cr width 0 do board width i * + print_line loop ;
		
( now solve it )
: check_row ( addr num -- f) ( 0 = num found )
	swap width 0 do 2dup i + c@ = if unloop 2drop 0 exit then loop 2drop 1 ;
: check_col ( addr num -- f)
	swap width 0 do 2dup width i * + c@ = if unloop 2drop 0 exit then loop 2drop 1 ;
: check_box ( addr num -- f )
	swap 4 0 do 2dup i + c@ = if unloop 2drop 0 exit then loop
	    20 16 do 2dup i + c@ = if unloop 2drop 0 exit then loop
	    36 32 do 2dup i + c@ = if unloop 2drop 0 exit then loop
	    52 48 do 2dup i + c@ = if unloop 2drop 0 exit then loop 2drop 1 ;
: box_calc ( cell -- box )
	64 /mod 64 * swap 16 mod 4 / 4 * + ;
: check_cell ( cell num -- f )
	>r dup width / width * board + r@ check_row 0= if rdrop drop 0 exit then 
		dup width mod board + r@ check_col 0= if rdrop drop 0 exit then
		box_calc board + r@ check_box 0= if rdrop 0 exit then rdrop 1 ;
: guess ( cell -- f ) recursive
	dup size = if drop  1 exit then
	dup board + c@ 255 <> if 1 + guess exit then
	16 0 do 
		dup i check_cell if 
			dup board + i swap c!
			dup 1+ guess if drop 1 unloop exit then 
			then 
	loop board + empty swap c! 0 ;
: sudo4 load_board 0 guess if print_board else ." No solution found " then ;

sudo4


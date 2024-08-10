| pow. is not working!!
^r3/win/console.r3

:log2fix | x -- log
	0? ( ; )
	0 swap | y x
	( $10000 <? 1 << swap $10000 - swap )
	( $20000 >=? 1 >> swap $10000 + swap )
	$8000 ( 1? swap | y z b
		dup 16 >> *	| y b z
		$20000 >=? ( 1 >> rot pick2 + rot rot )
		swap 1 >> ) 2drop ;

:lnfix |#INV_LOG2_10_Q1DOT31 $268826a1
	log2fix $268826a1 31 *>> ;
	
:log10fix |#INV_LOG2_E_Q1DOT31  $58b90bfc
	log2fix $58b90bfc 31 *>> ;

:baselog | x y -- a
	log2fix swap log2fix /. ;

	
::pow1. | base exp -- r
	swap log2fix *. exp. ;	
::pow2.
	swap lnfix *. exp. ;
	
:bln
	ln. swap ln. /. ;
	
	
|Math.pow(7, 2); // 49
|Math.pow(7, 3); // 343
|Math.pow(2, 10); // 1024
|// exponentes fraccionales
|Math.pow(4, 0.5); // 2 (raíz cuadrada de 4)
|Math.pow(8, 1 / 3); // 2 (raíz cúbica de 8)
|Math.pow(2, 0.5); // 1.412135623730951 (raíz cuadrada de 2)
|Math.pow(2, 1 / 3); // 1.2599210498948732 (raíz cúbica de 2)	

|function getBaseLog(x, y) { return Math.log(y) / Math.log(x); }
|// 2 x 2 x 2 = 8
|console.log(getBaseLog(2, 8));
|// Expected output: 3
|// 5 x 5 x 5 x 5 = 625
|console.log(getBaseLog(5, 625));
|// Expected output: 4


: .cls
	.cr
	2.0 8.0 baselog "%f == 3 new" .println
	2.0 8.0 bln "%f == 3" .println
	
	5.0 625.0 baselog "%f == 4 new" .println
	5.0 625.0 bln "%f == 4" .println
	.cr
	-1.0 exp. "%f == 0.36" .println
	0 exp.  "%f == 1" .println
	1.0 exp. "%f == 2.71" .println
	.cr
	7.0 2.0 pow. "%f == 49" .println
	7.0 2.0 pow1. "%f == 49" .println
	7.0 2.0 pow2. "%f == 49" .println	
	.cr
	7 2 pow "%d == 49 (int)" .println
	.cr
	2.0 10.0 pow. "%f == 1024" .println
	2.0 10.0 pow1. "%f == 1024" .println
	2.0 10.0 pow2. "%f == 1024" .println
	.cr
	4.0 0.5 pow. "%f == 2" .println
	4.0 0.5 pow1. "%f == 2" .println
	4.0 0.5 pow2. "%f == 2" .println
	.cr
	2.0 0.5 pow. "%f == 1.412135" .println
	2.0 0.5 pow1. "%f == 1.412135" .println
	2.0 0.5 pow2. "%f == 1.412135" .println
	.cr
	3.4 log2fix "%f" .println
	3.4 ln. "%f" .println
	.cr
	.input
	;
	
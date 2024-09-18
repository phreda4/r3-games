| teniente zabala
| PHREDA 2024
|-------------------------
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/util/hash2d.r3
^r3/win/sdl2gfx.r3

#sprites
#ifondo

#fx 0 0
#obj 0 0

#btnpad
#xvp #yvp

| x y ang/z anim ss vx vy ar io
| 1 2 3   4    5  6  7  8  9
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.a 3 ncell+ ;
:.ani 4 ncell+ ;
:.ss 5 ncell+ ;
:.vx 6 ncell+ ;
:.vy 7 ncell+ ;
:.end 8 ncell+ ;
:.io 9 ncell+ ;

:drawspr | arr -- arr
	dup 8 + >a
	a@+ int. xvp -
	a@+ int. yvp - 
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	;

|------------------- fx
:fxobj | adr --
	dup .ani @ anim>n 
	over .end @ 
	=? ( 2drop 0 ; ) drop 
	drawspr
	|..... add velocity to position
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	drop
	;

:+fxobj | last ss anim zoom ang x y --
	'fxobj 'fx p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	a!				| last
	;
	
|------------------- obj
:sobj
	|dup .ani @ anim>n 
	|over .end @ =? ( 2drop 0 ; ) drop 
	drawspr
	|..... add velocity to position
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	
	dup .x @ int. xvp - -10 <? ( 2drop 0 ; ) sw 10 + >? ( 2drop 0 ; ) drop
	dup .y @ int. yvp - -10 <? ( 2drop 0 ; ) sh 10 + >? ( 2drop 0 ; ) drop
	drop
	;
	
:+obj | last anim zoom ang x y --
	'sobj 'obj p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ sprites a!+			| anim sheet
	swap a!+ a!+ 	| vx vy
	a!
	;

:+enemigo
	;

|-------------- mapa estatico
#listaobs ( 13 14 15 16 ) 

:staticobj
	drawspr drop ;

:+estatico | o x y --
	a[
	'staticobj 'obj p!+ >a
	swap a!+ a!+	| x y 
	2.0 a!+	| ang zoom
	1- 'listaobs + c@
	0 $ff ICS>anim
	a!+ sprites a!+			| anim sheet
	]a
	;
	
|------------- mapa
#basex 320
#basey 340

#obstaculos
1 -100 50 
1 100 50
2 -80 100
2 80 100
3 -80 300
3 80 300
4 -80 500
4 80 500
0


:resetene
	'obstaculos >a
	( a@+ 1?
		basex a@+ + fix. 
		basey a@+ - fix. +estatico
		) drop 
	;
	
	
#btna
#xj #yj
#dx #dy #ang

:dirdis
	0 'dx ! 0 'dy ! 0 'ang !
	btna
	$1 and? ( 8.0 'dx ! 0.25 'ang +! )
	$2 and? ( -8.0 'dx ! -0.25 'ang +! )
	$4 and? (  8.0 'dy ! )
	$8 and? ( -8.0 'dy ! )
	drop
	
	;
	
:+disparo
	btnpad $10 and? ( drop ; ) drop
	dirdis	
	0
	dx dy
	12 0 $ff ICS>anim
	1.0 ang
	xj yj
	+obj
	;
	
|----------------------------- jugador
|  x y anim 
:setvp
	xj int. basex - 'xvp !
	yj int. basey - 'yvp !
	;


:anim!
	a> .ani dup @ $ffffffff and rot or swap ! ;
	
:jugador
	drawspr	
	>a
	btnpad $f and 
	$1 and? ( 1.0 a> .x +! 8 2 $ff ICS>anim anim! )
	$2 and? ( -1.0 a> .x +! 10 2 $ff ICS>anim anim! )
	$4 and? ( 1.0 a> .y +! 4 2 $ff ICS>anim anim! )
	$8 and? ( -1.0 a> .y +! 6 2 $ff ICS>anim anim! )
	1? ( dup 'btna ! )
	drop
	a> .x @ 'xj !
	a> .y @ 'yj !
	setvp
	;	

:+jugador | x y --
	'jugador 'obj p!+ >a
	swap a!+ a!+
	2.0 a!+ 
	6 1 $ff ICS>anim a!+ 
	sprites a!+
	;	
	
|------------------- juego
:dfondo
|	0 sdlcls
	0 0 640 480 ifondo SDLImages
	;
	
:juego
	timer.
	dfondo
	2 'obj p.sort
	'obj p.draw

	sdlredraw
	sdlkey
	>esc< =? ( exit )
	<up> =? ( btnpad $8 or 'btnpad ! )
	<dn> =? ( btnpad $4 or 'btnpad ! )
	<le> =? ( btnpad $2 or 'btnpad ! )
	<ri> =? ( btnpad $1 or 'btnpad ! )
	>up< =? ( btnpad $8 nand 'btnpad ! )
	>dn< =? ( btnpad $4 nand 'btnpad ! )
	>le< =? ( btnpad $2 nand 'btnpad ! )
	>ri< =? ( btnpad $1 nand 'btnpad ! )	
	<z> =? ( +disparo btnpad $10 or 'btnpad ! )
	>z< =? ( btnpad $10 nand 'btnpad ! )
	<f1> =? (
		0
		|	1.0 randmax 0.5 - 
		|	1.0 randmax 0.5 - 
		0 0 
			16 randmax 0 $ff ICS>anim
			2.0 0
			540.0 randmax 50.0 +
			380.0 randmax 50.0 + +obj )
	drop
	;

	
:reset
	'obj p.clear
	basex fix. basey fix. +jugador
	0 0 'yvp ! 'xvp ! 
	resetene
	;
	
|-------------------
: |<<< BOOT <<<
	"Teniente Zabala" 640 480 SDLinit
	bfont1
	"r3\iti2024\tzabala\fondo.png" loadimg 'ifondo !
	32 32 "r3\iti2024\tzabala\sprites.png" ssload 'sprites !
	100 'obj p.ini
	reset
	'juego SDLshow
	SDLquit 
	;

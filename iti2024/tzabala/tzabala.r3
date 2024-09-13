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
	a@+ int. a@+ int. | x y
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
	
	dup .x @ int. -10 <? ( 2drop 0 ; ) sw 10 + >? ( 2drop 0 ; ) drop
	dup .y @ int. -10 <? ( 2drop 0 ; ) sh 10 + >? ( 2drop 0 ; ) drop
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
			1.0 randmax 0.5 - 
			1.0 randmax 0.5 - 
			16 randmax 0 $ff ICS>anim
			2.0 0
			540.0 randmax 50.0 +
			380.0 randmax 50.0 + +obj )
	drop
	;

:reset
	'obj p.clear
	320.0 440.0 +jugador
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

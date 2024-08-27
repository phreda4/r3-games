| vaca libertad
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
	drawspr
	>a
	|..... add velocity to position
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	;
	
:+obj | last ss anim zoom ang x y --
	'sobj 'obj p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ a!+			| anim sheet
	swap a!+ a!+ 	| vx vy
	0 a!				| last
	;

:+cosechadora
	2.0 0.0
	sprites
	4 2 $ff ICS>anim
	1.0
	0
	10.0 
	400.0 randmax 10.0 +
	+obj ;
|----------------------------- jugador
|  x y anim 
:jugador
	drawspr	
	>a
	btnpad $f and 
	$1 and? ( 1.0 a> .x +! )
	$2 and? ( -1.0 a> .x +! )
	$4 and? ( 1.0 a> .y +! )
	$8 and? ( -1.0 a> .y +! )
	drop
	;	

:+jugador | 'per x y --
	'jugador 'obj p!+ >a
	swap a!+ a!+
	1.0 a!+ 
	0 a!+ 
	sprites a!
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
	<up> =? ( btnpad %1000 or 'btnpad ! )
	<dn> =? ( btnpad %100 or 'btnpad ! )
	<le> =? ( btnpad %10 or 'btnpad ! )
	<ri> =? ( btnpad %1 or 'btnpad ! )
	>up< =? ( btnpad %1000 nand 'btnpad ! )
	>dn< =? ( btnpad %100 nand 'btnpad ! )
	>le< =? ( btnpad %10 nand 'btnpad ! )
	>ri< =? ( btnpad %1 nand 'btnpad ! )	
	
	<f1> =? (
			+cosechadora )
	drop
	;

:reset
	'obj p.clear
	320.0 440.0 +jugador
	;
|-------------------
: |<<< BOOT <<<
	"La vaca libertad" 640 480 SDLinit
	bfont1
	"r3\iti2024\vaca\fondo.png" loadimg 'ifondo !
	64 64 "r3\iti2024\vaca\sprites.png" ssload 'sprites !
	100 'obj p.ini
	reset
	'juego SDLshow
	SDLquit 
	;

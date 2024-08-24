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
	drop
	;
	
:+obj | last ss anim zoom ang x y --
	'sobj 'obj p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	a!				| last
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
	<f1> =? (
			33
			sprites
			5 randmax 0 $ff ICS>anim
			2.0 0
			540.0 randmax 50.0 +
			380.0 randmax 50.0 + +obj )
	drop
	;

:reset
	;
|-------------------
: |<<< BOOT <<<
	"Teniente Zabala" 640 480 SDLinit
	bfont1
	"r3\iti2024\vaca\fondo.png" loadimg 'ifondo !
	64 64 "r3\iti2024\vaca\sprites.png" ssload 'sprites !
	100 'obj p.ini
	reset
	'juego SDLshow
	SDLquit 
	;

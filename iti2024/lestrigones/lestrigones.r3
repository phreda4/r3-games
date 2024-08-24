| lestrigones
| PHREDA 2024
|-------------------------
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/util/hash2d.r3
^r3/win/sdl2gfx.r3

#sprfondo
#fx 0 0
#obj 0 0

| x y ang anim ss vx vy ar io
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
	
:dfondo
	320 140 msec 7 >> 7 mod sprfondo ssprite
	;
	
:juego
	timer.
	0 sdlcls
	dfondo
	sdlredraw
	sdlkey
	>esc< =? ( exit )
	drop
	;

:reset
	;
|-------------------
: |<<< BOOT <<<
	"lestrigones" 640 480 SDLinit
	bfont1
	640 200 "r3\iti2024\lestrigones\fondo.png" ssload 'sprfondo !
	reset
	'juego SDLshow
	SDLquit 
	;

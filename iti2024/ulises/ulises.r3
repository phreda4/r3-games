 | test plataform game
| PHREDA 2024
|
^r3/lib/gui.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/win/sdl2gfx.r3

#sprfondo
#sprites

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
	
#mapw 32 
#maph 8
#mapsx 16
#mapsy 200
	
#map1 
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 1
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1
1 0 0 0 0 0 2 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
1 0 0 0 0 0 2 0 2 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
1 0 0 0 0 0 1 0 2 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1

#map 'map1

:t2m | x y -- t
	mapsy - 5 >> swap
	mapsx - 5 >> swap
	mapw * + 2 << map + ;

:gettile | x y -- t
	t2m @ ;

:tile | y x t -- y x
	0? ( drop ; )
	over 5 << mapsx +
	pick3 5 << mapsy +
	rot 1- $3 and 
	sprites ssprite
	;

:drawmap
	map >b
	0 ( 8 <?
		0 ( 19 <?
			b@+ tile 
			1+ ) drop
		mapw 19 - 3 << b+
		1+ ) drop ;

|--------- PLAYER
#ddx
#dx #dy
#xp #yp

:roof? | -- techo?
	xp 16 >> yp 16 >> 17 - gettile ;

:floor? | -- piso?
	xp 16 >> yp 16 >> 17 + gettile ;

:wall? | dx -- wall?
	xp 16 >> + yp 16 >> 10 + gettile ;

#cae
:jump
	floor? 0? ( drop
		1 'cae ! 0.8 'dy +!
		roof? 1? ( dy -? ( 0 'dy ! ) drop ) drop
		; ) drop
	cae 1? ( 
		0 'cae ! 0 'dy !
		yp $fff00000 and 8.0 + 'yp !  | 
		) drop
	sdlkey
	<up> =? ( -10.0 'dy ! )
	drop
	
	;

	
:goleft
	$10 wall? 0? ( drop ; ) drop
	xp $fff00000 and 'xp !
	drop 0 ;

:gorigth
	-$8 wall? 0? ( drop ; ) drop
	xp $fff00000 and 'xp !
	drop 0 ;

:player
    dx ddx 0? ( swap 0.8 *. )
	+ 3.0 min -3.0 max
	+? ( goleft )
	-? ( gorigth )
	'dx !
	jump
	dx 'xp +!
	dy 'yp +!
	;

:drawplayer
	player
	xp 16 >> yp 16 >> 16 -
	2 sprites ssprite
	;

:resetplayer
	0 'ddx !
	0 'dx ! 0 'dy !
	64.0 'xp !
	210.0 'yp !
	;
	
:dfondo
	0 0 sprfondo sdlimage
	;
	
|---------- 
:juego
	timer.
	0 sdlcls
	dfondo
	0 0 bat
	yp xp "%f %f" bprint bcr
	dy dx "%f %f" bprint
	drawmap
	drawplayer
	
	sdlredraw
	sdlkey
	>esc< =? ( exit )
	<le> =? ( -0.25 'ddx ! )
	<ri> =? ( 0.25 'ddx ! )
	>le< =? ( 0 'ddx ! )
	>ri< =? ( 0 'ddx ! )
	drop
	;

:reset
	resetplayer
	;
	
|-------------------
: |<<< BOOT <<<
	"Ulises pierde" 640 480 SDLinit
	bfont1
	"r3\iti2024\ulises\fondo.png" loadimg 'sprfondo !
	32 32 "r3\iti2024\ulises\sprites.png" ssload 'sprites !
	reset
	'juego SDLshow
	SDLquit 
	;
 | test plataform game
| PHREDA 2024
|
^r3/lib/gui.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/lib/sdl2gfx.r3

|#sprfondo
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

#map1 (
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 3 0 0 3 0 0 3 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 3 0 3 0 0 0 0 0 0 0 0 0 3 0 0 3 3 0 3 3 0 0 0 0 0 0 0 0 0 0
0 2 2 2 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 0 2 2 2 2 2 2
0 2 2 2 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 0 2 2 2 2 2 2 
0 2 2 2 2 2 2 2 2 2 2 0 2 2 2 2 2 2 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
)
	
#mapw 55 
#maph 14

#mapsx 16
#mapsy 48

#mapvx 0
#mapvy 0
#mapvw 22
#mapvh 14

#map 'map1

:t2m | vx vy -- t
	mapsy - 5 >> swap
	mapsx - 5 >> swap
:]t2m | x y -- t
	mapw * + map + ;

:gettile | x y -- t
	t2m c@ ;

:drawtile | y x t -- y x
	0? ( drop ; )
	over 5 << mapsx +
	pick3 5 << mapsy +
	rot 1- $7 and 
	sprites ssprite
	;

:drawmap
	0 ( mapvh <?
		0 ( mapvw <?
			dup mapvx + mapw clamp0max
			pick2 mapvy + maph clamp0max
			]t2m c@ drawtile
			1+ ) drop
		1+ ) drop ;

|--------- PLAYER
#xvp 0
#ddx
#dx #dy
#xp #yp

:roof? | -- techo?
	xp 16 >> yp 16 >> 17 - gettile ;

:floor? | -- piso?
	xp 16 >> 10 + yp 16 >> 16 + gettile 
	xp 16 >>  yp 16 >> 16 + gettile
	or
	;

:wall? | dx -- wall?
	xp 16 >> + yp 16 >> 8 + gettile ;

#cae
:jump
	floor? 0? ( drop
		1 'cae ! 0.8 'dy +!
		|roof? 1? ( dy -? ( 0 'dy ! ) drop ) drop
		; ) drop
	cae 1? ( 
		0 'cae ! 0 'dy !
		yp $fff00000 and 'yp !  | 
		) drop
	sdlkey
	<esp> =? ( -14.0 'dy ! )
	drop
	
	;

	
:go>>
	32 wall? 0? ( drop ; ) drop
	xp $fff00000 and 'xp !
	drop 0 ;

:go<<
	-8 wall? 0? ( drop ; ) drop
	xp $fff00000 and 'xp !
	drop 0 ;

:player
    dx ddx 0? ( swap 0.8 *. )
	+ 3.0 min -3.0 max
	+? ( go>> ) -? ( go<< )
	'dx !
	jump
	dx 'xp +!
	dy 'yp +!
	;

:drawplayer
	player
	xp 16 >> xvp -
	yp 16 >> 16 -
	2.0 10 sprites sspritez
	
	xp 16 >> xvp - 
	640 128 - >? ( 2 'xvp +! )
	128 <? ( -2 'xvp +! )
	drop
	
	xvp 5 >> 'mapvx !
	xvp $1f and neg 'mapsx !
	;

:resetplayer
	0 'ddx !
	0 'dx ! 0 'dy !
	64.0 'xp !
	210.0 'yp !
	0 'xvp !
	;
	
:dfondo
|	0 0 sprfondo sdlimage
	;
	
|---------
:debmouse
	0 0 bat
	yp xp "x:%f y:%f" bprint2 bcr
|	dy dx "%f %f" bprint
	;
	
	
|---------- 
:juego
	timer.
	$5a5a5a sdlcls
	
	dfondo
	drawmap
	drawplayer
	
	debmouse
	
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
|	"r3\iti2024\ulises\fondo.png" loadimg 'sprfondo !
	32 32 "r3\iti2024\ulises\sprites.png" ssload 'sprites !
	reset
	'juego SDLshow
	SDLquit 
	;
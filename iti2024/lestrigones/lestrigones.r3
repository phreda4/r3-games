| juego nticx 2024
| lestrigones
| PHREDA 2024
|
^r3/lib/gui.r3
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/lib/sdl2gfx.r3

#sprfondo
#sprites

#fx 0 0
#obj 0 0

:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.z 3 ncell+ ;
:.t 4 ncell+ ;
:.vx 5 ncell+ ;
:.vy 6 ncell+ ;

:drawspr | arr -- arr
	dup 8 + >a
	a@+ int. a@+ int. | x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	;

|------------- NOTAS
:coso | adr --
	>a
	a> .x @ int. -180 <? ( drop 0 ; ) drop
	a> .vx @ a> .x +! a> .vy @ a> .y +!
	8 a+
	a@+ int. a@+ int. a@+ a@ sprites sspritez
	;
	
:+coso | --
	'coso 'obj p!+ >a
	800.0 a!+ 				| x
	220.0 randmax 220.0 + a!+ 		| y
	1.0 a!+ 	| zoom
	2 randmax a!+ 			| nube
	0.5 randmax 0.8 + neg a!+	| vx
	0.01 randmax 0.005 -  a!	| vy
	;
|--------- PLAYER
#dx #dy #js #jvs
#xp #yp
#ja

:drawplayer
	xp int.
	yp js + int.
	2.0 
	ja timer+ dup 'ja ! anim>n 	
	sprites sspritez
	
|	dx 'xp +!
	dy 'yp +!
	
	js 0? ( drop ; ) drop
	jvs 'js +!
	0.5 'jvs +!
	js +? ( drop 0 'js ! ; ) drop
	;

:resetplayer
	128.0 'xp ! 290.0 'yp !
	0 'dx ! 0 'dy ! 0 'js !
	2 0 0 ICS>anim 'ja !
	;
	
#xfondo
:dfondo
	$206cd2 sdlcolor
	0 0 640 100 sdlfrect
	
	xfondo int. 140 msec 8 >> 7 mod sprfondo ssprite
	xfondo int. 640 + 140 msec 8 >> 7 mod sprfondo ssprite
	
	xfondo dx -
	-320.0 <? ( 640.0 + )
	320.0 >? ( 640.0 - )
	'xfondo !
	
	$A3672E sdlcolor
	0 240 640 240 sdlfrect
	;
|---------- 
:juego
	timer.
	0 sdlcls
	dfondo
	0 0 bat
	yp xp "%f %f" bprint bcr
	dy dx "%f %f" bprint
	
	'obj p.draw
	drawplayer
	
	sdlredraw
	sdlkey
	>esc< =? ( exit )
	<le> =? ( -0.8 'dx ! )	>le< =? ( 0 'dx ! )
	<ri> =? ( 0.8 'dx ! )	>ri< =? ( 0 'dx ! )
	<up> =? ( -0.8 'dy ! )	>up< =? ( 0 'dy ! )
	<dn> =? ( 0.8 'dy ! )	>dn< =? ( 0 'dy ! )
	<esp> =? ( -10.0 'jvs ! jvs 'js +! )
	<f1> =? ( +coso )
	drop
	;

:reset
	resetplayer
	'obj p.clear
	;
	
|-------------------
: |<<< BOOT <<<
	"lestrigones" 640 480 SDLinit
	bfont1
	640 200 "r3\iti2024\lestrigones\fondo.png" ssload 'sprfondo !
	32 32 "r3\iti2024\lestrigones\sprites.png" ssload 'sprites !
	reset
	100 'obj p.ini
	'juego SDLshow
	SDLquit 
	;
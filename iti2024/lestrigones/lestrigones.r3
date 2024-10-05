| juego nticx 2024
| lestrigones
| PHREDA 2024
|
^r3/lib/gui.r3
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/lib/sdl2gfx.r3

#imgfondo
#sprites

#fx 0 0
#obj 0 0

|--------- PLAYER
#vvx
#dx #dy #js #jvs
#xp #yp
#ja

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

:cosa
	>a
	a> .x @ vvx - int. 
	a> .y @ int.
	a> .z @ 
	sprites ssprite
	;
	
:+cosa | ndib x y --
	'cosa 'obj p!+ >a
	swap a!+ a!+
	a!+ 
	;


:drawplayer
	xp int.
	yp js + int.
	2.0 
	ja timer+ dup 'ja ! anim>n 	
	sprites sspritez
	
	|dx 'xp +!
	dx 'vvx +!
	dy 'yp +!
	
	js 0? ( drop ; ) drop
	jvs 'js +!
	0.5 'jvs +!
	js +? ( drop 0 'js ! ; ) drop
	;

:resetplayer

	128.0 'xp ! 340.0 'yp !
	0 'dx ! 0 'dy ! 0 'js !
	2 0 0 ICS>anim 'ja !
	;
	
:dfondo
	0 0 imgfondo sdlimage	
	;
|---------- 
:juego
	timer.
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
	drop
	;

:reset
	resetplayer
	'obj p.clear
	50 ( 1? 1-
		3 randmax
		2000.0 randmax 400.0 +
		100.0 randmax 350.0 +
		+cosa
		) drop
	;
	
|-------------------
: |<<< BOOT <<<
	"lestrigones" 640 480 SDLinit
	bfont1
	"r3\iti2024\lestrigones\fondo.png" loadimg 'imgfondo !
	32 32 "r3\iti2024\lestrigones\sprites.png" ssload 'sprites !
	500 'obj p.ini
	reset	
	'juego SDLshow
	SDLquit 
	;
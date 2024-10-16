| Edipo
| IDFS 4to Soc
| PHREDA 2024
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3
^r3/lib/rand.r3

#spr

#imgfondo
#sprimg
#enemigos 0 0


:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.a 3 ncell+ ;
:.t 4 ncell+ ;
:.vx 5 ncell+ ;
:.vy 6 ncell+ ;

|----------------------------------
#jx 60.0 #jy 242.0
#jvx 0 #jvy 0
#js 0 #jvs 0
#ja

:enemigo | adr --
	>a
	a> .vx @ a> .x +! 
	a> .vy @ a> .y +!

	a> .x @ int. 660 >? ( drop 0 ; ) -100 <? ( drop 0 ; ) 
	a> .y @ int.
	2.0
	a> .a dup @ timer+ dup rot ! anim>n	
	sprimg
	sspritez
	;
	
:+ene | x y --
	'enemigo 'enemigos p!+ >a
	swap a!+ a!+
	a!+ a!+
	swap a!+ a!+
	;

:eneder
	-1.5 0.0 
	0
	11 3 $7f ICS>anim
	650.0 242.0
	+ene	
	;

:eneizq
	1.5 0.0 
	0
	8 3 $7f ICS>anim
	-50.0 242.0
	+ene	
	;
	
|----------------------------------	
:jugador
	jx int.
	jy js + int. 
	2.0 
	ja timer+ dup 'ja ! anim>n	
	sprimg sspritez
	
	jvx 'jx +!
	jvy 'jy +!
	js 0? ( drop ; ) drop
	jvs 'js +!
	0.5 'jvs +!
	js +? ( drop 0 'js ! ; ) drop
	;
	
|----------------------------------
#xv 0
#yv -460

:fondo
	xv yv 2560 960 imgfondo SDLImages
	;

:frente
	;
	
:anim!	ja $ffffffff and or 'ja ! ;
:aniqle	0 0 $7f ICS>anim anim! ;
:anirle	0 4 $7f ICS>anim anim! ;
:aniqri	4 0 $7f ICS>anim anim! ;
:anirri	4 4 $7f ICS>anim anim! ;	
	
|----------------------------------
:juego
	timer.
	
	fondo
	jugador
	'enemigos p.draw
	frente
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	| ---- player control	
|	<up> =? ( btnpad %1000 or 'btnpad ! )
|	<dn> =? ( btnpad %100 or 'btnpad ! )
	<le> =? ( -1.6 'jvx ! anirle ) >le< =? ( 0 'jvx ! aniqle ) 
	<ri> =? ( 1.6 'jvx ! anirri ) >ri< =? ( 0 'jvx ! aniqri ) 
	<esp> =? ( -12.0 'jvs ! jvs 'js +! )
	|<z> =? ( )
	
	<f1> =? ( eneder ) 
	<f2> =? ( eneizq ) 
	drop ;
	
:jugar
	'enemigos p.clear
	-30 'xv ! -460 'yv !
	60.0 'jx ! 242.0 'jy !
	0 'jvx ! 0 'jvy !
	0 'js ! 0 'jvs !
	0 'ja !
	'juego SDLshow
	;
	
:main
	"Edipo" 640 480 SDLinit
	pcfont
	32 50 "r3/iti2024/edipo/jugador.png" ssload 'sprimg !
	"r3/iti2024/edipo/orilla.png" loadimg 'imgfondo !
	50 'enemigos p.ini
	timer<
	jugar
	SDLquit 
	;


: main ;
| Edipo
| IDFS 4to Soc
| PHREDA 2024
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3
^r3/lib/rand.r3

#spr

#imgfondo
#sprimg


:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.z 3 ncell+ ;
:.t 4 ncell+ ;
:.vx 5 ncell+ ;
:.vy 6 ncell+ ;


	
|----------------------------------
#jx 60.0 #jy 242.0
#jvx 0 #jvy 0
#js 0 #jvs 0
#ja

:jugador
	jx int.
	jy js + int. 
	2.0 0 sprimg sspritez
	
	jvx 'jx +!
	jvy 'jy +!
	js 0? ( drop ; ) drop
	jvs 'js +!
	0.5 'jvs +!
	js +? ( drop 0 'js ! ; ) drop
	;
	
|----------------------------------
#xv
#yv -460
:fondo
	xv yv 1280 960 imgfondo SDLImages
	;

:frente
	;
	
|----------------------------------
:juego
	timer.
	
	fondo
	jugador
	frente
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	| ---- player control	
|	<up> =? ( btnpad %1000 or 'btnpad ! )
|	<dn> =? ( btnpad %100 or 'btnpad ! )
	<le> =? ( -1.6 'jvx ! ) >le< =? ( 0 'jvx ! ) 
	<ri> =? ( 1.6 'jvx ! ) >ri< =? ( 0 'jvx ! ) 
	<esp> =? ( -12.0 'jvs ! jvs 'js +! )

	drop ;
	
:main
	"Edipo" 640 480 SDLinit
	pcfont
	32 50 "r3/iti2024/edipo/jugador.png" ssload 'sprimg !
	"r3/iti2024/edipo/orilla.png" loadimg 'imgfondo !
	timer<
	'juego SDLshow
	SDLquit 
	;


: main ;
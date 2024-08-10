| Ulises vs Las sirenas
| IDFS 4to Soc
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3

#spr
#imgmar
#imgnave
#imgvela
#imgnube
#imgisla

#notas 0 0
#fx 0 0 

|----------------------------------
#jx 60.0 #jy 300.0
#jvx 0 #jvy 0
#js 0 #jvs 0
#ja

:jugador
	jx int. jy js + int. 2.0 ja spr sspritez
	
	jvx 'jx +!
	jvy 'jy +!
	js 0? ( drop ; ) drop
	jvs 'js +!
	0.7 'jvs +!
	js +? ( drop 0 'js ! ; ) drop
	;
	
|----------------------------------
:fondo
	$93E2F7 SDLcls
	0 0 640 480 imgmar SDLImages
	0 0 640 480 imgnube SDLImages
	0 0 640 480 imgisla SDLImages
	0 0 640 480 imgnave SDLImages
	0 0 640 480 imgvela SDLImages
	;

|----------------------------------
:juego
	timer.
	fondo
	jugador
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	| ---- player control	
|	<up> =? ( btnpad %1000 or 'btnpad ! )
|	<dn> =? ( btnpad %100 or 'btnpad ! )
	<le> =? ( -1.4 'jvx ! ) >le< =? ( 0 'jvx ! ) 
	<ri> =? ( 1.4 'jvx ! ) >ri< =? ( 0 'jvx ! ) 
	<esp> =? ( -14.0 'jvs ! jvs 'js +! )
	
	drop ;
	
:main
	"Ulises Contra Las Sirenas" 640 480 SDLinit
	pcfont
	
	32 32 "r3/iti2024/uvlas/sprites.png" ssload 'spr !
	"r3/iti2024/uvlas/mar.png" loadimg 'imgmar !
	"r3/iti2024/uvlas/nube.png" loadimg 'imgnube !	
	"r3/iti2024/uvlas/isla.png" loadimg 'imgisla !
	"r3/iti2024/uvlas/nave.png" loadimg 'imgnave !
	"r3/iti2024/uvlas/vela.png" loadimg 'imgvela !

	100 'notas p.ini
	100 'fx p.ini
	
	timer<
	'juego SDLshow
	SDLquit 
	;


: main ;
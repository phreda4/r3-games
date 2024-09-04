| Ulises vs Las sirenas
| IDFS 4to Soc
| PHREDA 2024
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3
^r3/lib/rand.r3

#spr

#imgmar
#imgnave
#imgisla

#sprvela
#sprnube
#sprnotas
#sprbarra

#lnubes 0 0 
#lnotas 0 0
#lfx 0 0 

:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.z 3 ncell+ ;
:.t 4 ncell+ ;
:.vx 5 ncell+ ;
:.vy 6 ncell+ ;

|------------- NUBES
:nube | adr --
	>a
	a> .x @ int. -180 <? ( drop 0 ; ) drop
	a> .vx @ a> .x +! a> .vy @ a> .y +!
	8 a+
	a@+ int. a@+ int. a@+ a@ sprnube sspritez
	;
	
:+nube | --
	'nube 'lnubes p!+ >a
	800.0 a!+ 				| x
	240.0 randmax dup a!+ 		| y
	240.0 - neg 300.0 /. 0.05 +
	|0.7 randmax 0.1 + 
	a!+ 	| zoom
	1 randmax a!+ 			| nube
	0.3 randmax 0.6 + neg a!+	| vx
	0.01 randmax 0.005 -  a!	| vy
	;
	
:nubes
	100 randmax 0? ( +nube ) drop ;
	
|------------- NOTAS
:nota | adr --
	>a
	a> .x @ int. -180 <? ( drop 0 ; ) drop
	a> .vx @ a> .x +! a> .vy @ a> .y +!
	8 a+
	a@+ int. a@+ int. a@+ a@ sprnotas sspritez
	;
	
:+nota | --
	'nota 'lnotas p!+ >a
	800.0 a!+ 				| x
	240.0 randmax 120.0 + a!+ 		| y
	2.0 a!+ 	| zoom
	9 randmax a!+ 			| nube
	0.5 randmax 0.8 + neg a!+	| vx
	0.01 randmax 0.005 -  a!	| vy
	;
	
:notas
	50 randmax 0? ( +nota ) drop ;
	
|----------------------------------
#xbarco #ybarco
#jx 60.0 #jy 320.0
#jvx 0 #jvy 0
#js 0 #jvs 0
#ja

:jugador
	jx int. xbarco + 200 + 
	jy js + int. ybarco +
	2.0 ja spr sspritez
	
	jvx 'jx +!
	jvy 'jy +!
	js 0? ( drop ; ) drop
	jvs 'js +!
	0.5 'jvs +!
	js +? ( drop 0 'js ! ; ) drop
	;
	
|----------------------------------
:fondo
	$93E2F7 SDLcls
	'lnubes p.draw
	0 0 640 480 imgmar SDLImages
	0 0 640 480 imgisla SDLImages
	msec dup 4 << sin 30 *. 200 - swap 3 << sin 10 *. 10 +
	2dup 'ybarco ! 'xbarco !
	640 480 imgnave SDLImages
	xbarco 368 + ybarco 130 + msec 7 >> $3 and sprvela ssprite
	'lnotas p.draw
	;

:frente
	100 20 4.0 2 sprbarra sspritez
	;
|----------------------------------
:juego
	timer.
	nubes
	notas
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
	
	<f1> =? ( +nota )
	drop ;
	
:main
	"Ulises Contra Las Sirenas" 640 480 SDLinit
	pcfont
	
	32 32 "r3/iti2024/uvlas/sprites.png" ssload 'spr !
	
	"r3/iti2024/uvlas/mar.png" loadimg 'imgmar !
	"r3/iti2024/uvlas/isla.png" loadimg 'imgisla !
	"r3/iti2024/uvlas/nave.png" loadimg 'imgnave !
	
	353 127 "r3/iti2024/uvlas/nube.png" ssload 'sprnube !
	275 240 "r3/iti2024/uvlas/vela.png" ssload 'sprvela !
	32 32 "r3/iti2024/uvlas/notas.png" ssload 'sprnotas !
	32 32 "r3/iti2024/uvlas/barra.png" ssload 'sprbarra !

	80 'lnubes p.ini
	100 'lnotas p.ini
	100 'lfx p.ini
	
	
	timer<
	'juego SDLshow
	SDLquit 
	;


: main ;
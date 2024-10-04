| Ulises vs Las sirenas
| IDFS 4to Soc
| PHREDA 2024
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2mixer.r3
^r3/lib/gui.r3
^r3/lib/rand.r3

^r3/util/pcfont.r3
^r3/util/arr16.r3

#spr

#imglogo
#imgmar
#imgnave
#imgisla

#sprvela
#sprnube
#sprnotas
#sprbarra
#sprboton
#sprend

#lnubes 0 0 
#lnotas 0 0
#lfx 0 0 

#xbarco #ybarco
#jx 60.0 #jy 320.0
#jvx 0 #jvy 0
#js 0 #jvs 0
#ja
#vida
#estado 
#contacto
#ijx #ijy

|------ sounido
#sndlist * 160

:playsnd | n --
	3 << 'sndlist + @ SNDplay ;

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
	
:fillnubes
	0 ( 1024 <?
		nubes
		'lnubes p.draw
		1+ ) drop ;
	
|------------- NOTAS
:nota | adr --
	>a
	a> .x @ int. -180 <? ( drop 0 ; ) drop
	a> .vx @ a> .x +! a> .vy @ a> .y +!
	a> .x @ int.
	a> .y @ int.
	over ijx - over ijy - 
	distfast 20 <? ( 1 'contacto ! ) drop
	a> .z @
	a> .t @ 
	sprnotas sspritez	
	;
	
:+nota | --
	'nota 'lnotas p!+ >a
	800.0 a!+ 				| x
	4 randmax 60.0 * 160.0 + a!+ 		| y
	2.0 a!+ 	| zoom
	9 randmax a!+ 			| nube
	0.5 randmax 0.8 + neg a!+	| vx
	0.01 randmax 0.005 -  a!	| vy
	;
	
:notas
	50 randmax 0? ( +nota ) drop ;
	
|----------------------------------

:anim!
	ja $ffffffff and or 'ja ! ;
	
:anim
	contacto 1? ( drop 26 7 $ff ICS>anim anim! ; ) drop
	js 1? ( drop 5 8 $3f ICS>anim anim! ; ) drop
	jvx 0? ( drop 0 0 $7f ICS>anim anim! ; ) drop
	0 4 $7f ICS>anim anim!
	;

| 13 12 | cayendo
	
:cayendo	
	1.0 'jx +!
	0.1 'jvs +!
	jvs 'jy +!
	jy 600.0 >? ( 2 'estado ! exit ) drop
	;
:cae
	13 12 $3f ICS>anim anim!
	1 'estado !
	;
:tocando
	1 'vida +!
	1 playsnd
	vida 96 >? ( 1 'estado ! ) drop
	;
	
:jugador
	jx int. xbarco + 200 + dup 'ijx !
	jy js + int. ybarco + dup 'ijy !
	2.0 
	ja timer+ dup 'ja ! anim>n
	spr sspritez
	contacto 1? ( tocando ) drop
	estado 1? ( drop cayendo ; ) drop
	jvx 'jx +!
	jvy 'jy +!
	anim
	js 0? ( drop 
		jx int. xbarco + 100 >? ( cae ) drop
		; ) drop
	jvs 'js +!
	0.25 'jvs +!
	js +? ( drop 0 'js ! ; ) drop
	;
	
|----------------------------------
:fondo
	$93E2F7 SDLcls
	'lnubes p.draw nubes 
	0 0 640 480 imgmar SDLImages
	0 0 640 480 imgisla SDLImages
	550 290 2.0 40 spr sspritez	| sirena
	msec dup 4 << sin 30 *. 200 - swap 3 << sin 10 *. 10 +
	2dup 'ybarco ! 'xbarco !
	640 480 imgnave SDLImages
	xbarco 368 + ybarco 130 + msec 7 >> $3 and sprvela ssprite
	;

:frente
	100 20 4.0 vida 4 >> sprbarra sspritez
	;
	
|-----------------
:juego
	timer. notas
	
	fondo
	0 'contacto !
	'lnotas p.draw
	jugador
	frente

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	| ---- player control	
	<le> =? ( -1.6 'jvx ! ) >le< =? ( 0 'jvx ! ) 
	<ri> =? ( 1.6 'jvx ! ) >ri< =? ( 0 'jvx ! ) 
	<esp> =? ( -6.0 'jvs ! jvs 'js +! )
	
	<f1> =? ( +nota )
	drop ;

:jugar
	0 playsnd 
	timer<
	'lnotas p.clear
	'lfx p.clear
	60.0 'jx ! 320.0 'jy !
	0 'jvx ! 0 'jvy !
	0 'js ! 0 'jvs !
	0 'vida !
	0 0 $7f ICS>anim 'ja !
	0 'estado !
	'juego SDLshow
	;
	
|-----------------
:fondo
	$93E2F7 SDLcls
	'lnubes p.draw nubes
	0 0 640 480 imgmar SDLImages
	;

:btnimg | x y n --
	pick2 64 - pick2 32 - 128 64 guiBox
	2.0 swap '1+ guiI sprboton sspritez
	onClick ;
	
|-----------------
#letras ( 1 2 3 -1 4 5 0 4 ) 
#xcartel

:letra | n -- n
	7 over - 
	dup 120 * xcartel +
	msec 4 << pick2 0.2 * + sincos drop 40 * int. 200 +
	rot 'letras + c@ 
	-? ( 3drop ; )
	sprend
	ssprite
	;
	
:finj
	gui
	fondo
	8 ( 1? 1- letra ) drop
	'exit 320 450 2 btnimg
	xcartel 
	2 - -960 <? ( 800 nip ) 
	'xcartel !
	SDLredraw
	SDLkey
	>esc< =? ( exit ) 
	drop
	;
	
:finjuego
	2 playsnd 
	800 'xcartel !
	'finj sdlshow
	;
	
|-----------------
:inicio
	gui
	fondo
	0 
	msec 3 << sincos drop 30 * int. 40 + 
	imglogo sdlimage
	'jugar 320 340 0 btnimg
	'exit 320 400 2 btnimg
	
	SDLredraw
	SDLkey
	<f1> =? ( finjuego )
	<esp> =? ( jugar finjuego )
	>esc< =? ( exit ) 
	drop
	;
	
#sndfiles 
"click.wav"
"danio.wav"
"muerte.wav"
0

:loadsnd
	44100 $8010 1 1024 Mix_OpenAudio
	'sndlist >a
	'sndfiles
	( dup c@ 1? drop
		dup "r3/iti2024/uvlas/%s" sprint mix_loadWAV a!+
		>>0 ) drop ;
		
:main
	"Ulises Contra Las Sirenas" 640 480 SDLinit
	pcfont
	
	32 32 "r3/iti2024/uvlas/sprites.png" ssload 'spr !
	
	"r3/iti2024/uvlas/logo.png" loadimg 'imglogo !
	"r3/iti2024/uvlas/mar.png" loadimg 'imgmar !
	"r3/iti2024/uvlas/isla.png" loadimg 'imgisla !
	"r3/iti2024/uvlas/nave.png" loadimg 'imgnave !
	
	353 127 "r3/iti2024/uvlas/nube.png" ssload 'sprnube !
	275 240 "r3/iti2024/uvlas/vela.png" ssload 'sprvela !
	32 32 "r3/iti2024/uvlas/notas.png" ssload 'sprnotas !
	32 32 "r3/iti2024/uvlas/barra.png" ssload 'sprbarra !
	64 32 "r3/iti2024/uvlas/boton.png" ssload 'sprboton !
	200 200 "r3/iti2024/uvlas/you died.png" ssload 'sprend !
	
	
	loadsnd
	
	80 'lnubes p.ini
	100 'lnotas p.ini
	100 'lfx p.ini
	fillnubes
	
	timer<
	'inicio SDLshow
	|jugar	
	SDLquit 
	;


: main ;
| Picoteo
| PHREDA 2024
|------------------
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3
^r3/lib/rand.r3
^r3/util/varanim.r3
^r3/util/sdlgui.r3


|------ sound
#sndfiles "inicio" "click"
|"808_2" "808_3" "808_4" "808_5" "808_6" "808_7" "808_C" "808_K" "808_O" "808_S" "808_R" 
0
#sndlist * 160

:loadsnd
	'sndlist >a
	'sndfiles
	( dup c@ 1? drop
		dup "r3/iti2024/picoteo/%s.mp3" sprint mix_loadWAV a!+
		>>0 ) drop ;

:playsnd | n --
	3 << 'sndlist + @ SNDplay ;

|------- graficos

#imgfondo

| 1 2 3 4   
| x y s l

:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.z 3 ncell+ ;	| zoom
:.s 4 ncell+ ;	| n sprite
:.l 5 ncell+ ;	| lugar

#sprgame
#sprfx
#sprplayer

#maizs 0 0 
#fx 0 0

|------- FX
:fxgr
	>a
	a> .s @ 0? ( ; ) drop
	-1 a> .s +! 
	a> .x @ int.
	a> .y @ int. | x y
	2.0
	a> .z dup @ timer+ dup rot ! anim>n
	sprfx
	sspritez
	;
	
:+fx | time ani x y --
	'fxgr 'fx p!+ >a
	swap a!+ a!+
	a!+ a!+
	;

|--------------------------
#jugador 0 0 0 0 0 0 0 0
#puntaje 0 0 0 0 0 0 0 0
#patas 0 0 0 0 0 0 0 0

:son 
|	0 playsnd 
|"tic" .println
	;

:toco
	over 8 + @ 3 << 'puntaje + 1 swap +!
	over @ .z 0 swap !	| zoom =0
	drop
|	11 playsnd
	|"pico" .println
	;
	
:llego |9 playsnd 
|	5 playsnd
	dup 8 + @ 3 << 'jugador + @
	1? ( toco ; ) drop ;


:maizmovy | y x adr --
	'son 1.0 +vexe
	'son 2.0 +vexe
	pick3 a> 8 - 'llego 3.0 +vvvexe
	dup 310.0 130.0 0 3.0 0.0 +vanim
	dup 400.0 
	20.0 randmax 10.0 - +
	310.0 0 0.5 3.0 +vanim	
	drop
	;
	
:maizmovx | y x adr --
	dup pick2 50.0 - pick3 20  0.5 0.0 +vanim	
	dup pick2 pick3 50.0 - 19 0.5 0.5 +vanim	
	dup pick2 50.0 - pick3 20 0.5 1.0 +vanim	
	dup pick2 pick3 50.0 - 19 0.5 1.5 +vanim	
	dup pick2 50.0 - pick3 20 0.5 2.0 +vanim	
	dup pick2 pick3 50.0 - 19 0.5 2.5 +vanim	
	dup pick2 80.0 - 
	20.0 randmax 10.0 - +
	pick3 20 0.5 3.0 +vanim	
	drop
	;

:maiz
	dup 8 + >a 
	a@+ int. a@+ int.  | x y
	a> 6 <<
	a@+ | 0.3 zoom
	a@+ sprgame sspriterz | x y ang zoom img --
	drop
	;

:+maiz | n x y --
	'maiz 'maizs p!+ >a
	swap | y x
	a> maizmovx
	a> 8 + maizmovy
	a!+ a!+
	0.3 a!+
	2 randmax 3 + a!+ 
	a! | valor
	;
	
|------- game
#pulso 1.0 
#largo 500 | miliseconds

#thit
#dif

#tiempo

#estado
#ritmo

|------- timeline

#nivel0 " o o o      "
#nivel1 " abdh abcdefghijklmno "

#nivs 'nivel0 'nivel1 0
#niv 0

#finsec
#ltime
#ntime

:trestart
	-1 'ltime ! 0 'ntime !
	0 'finsec !
	'fx p.clear
	'maizs p.clear
	timer<
	vareset	
	;
	
#nivel 'nivel0

:tclock
	tiempo timer+ 
	largo <? ( 'tiempo ! ; )
	largo - 'tiempo ! 
	tiempo 'thit ! 
	1 'ntime +! 
	;
	
:getframe
	tclock
	ntime ltime =? ( drop ; ) 
	dup 'ltime ! nivel + c@
	0? ( drop 1 'finsec ! ; )
	1 and? ( 0 100.0 130.0 +maiz )
	2 and? ( 1 300.0 130.0 +maiz )
	4 and? ( 2 500.0 130.0 +maiz )
	8 and? ( 3 700.0 130.0 +maiz )	
	drop
	;
	
|------------- jugadores
:golpe | time player --
	3 << 'jugador +
	dup @ 1? ( 3drop ; ) drop
	! ;
	
:player	| player --
	500 80 pick2 150 * + 
	pick2 3 << 'jugador + @ 
	1? ( drop 1 )
	sprplayer ssprite	
	
	3 << 'jugador +
	dup @ 0? ( 2drop ; ) 
	timer- -? ( 0 nip ) swap !
	;

|---------------------------------------------
:semillero | x --
	dup 80 2.0 0 sprgame sspritez
	dup 200 2.0 1 sprgame sspritez
	dup 292 2.0 2 sprgame sspritez
	drop
	;

:fondo
	$0 SDLcls
	16 ( 800 <?
		16 ( 600 <?
			2dup |2 randmax 
			2dup xor $1 and
			sprfx ssprite
			32 + 
			) drop
		32 + 
		) drop 
		
	100 semillero
	300 semillero
	500 semillero
	700 semillero
	;
	
:gallina | n x --
	dup 550 2.0 
	pick4 3 << 'patas + @ 3 and 9 +
	sprgame sspritez	| patas

	dup 428 2.0
	8 sprgame sspritez
	
	340 2.0 
	pick3 3 << 'jugador + @ 
	1? ( pick4 3 << 'jugador + -1 swap +! drop 1 ) 
	5 + sprgame sspritez	| cabeza
	
	0 ttcolor
	dup 200 * 80 + 46
	ttat
	dup 3 << 'puntaje + @ "%d" 
	ttprint
	
	drop
	;
	
:gallinas	
	0 100 gallina 1 300 gallina 2 500 gallina 3 700 gallina
	20 randmax 1? ( drop ; ) drop
	4 randmax 3 << 'patas + 1 swap +!
	;
	
:pico | n -- 
	dup
	3 << 'jugador + 
	dup @ 1? ( 3drop ; ) drop
	20 swap ! | loop correct
|	10 playsnd
	
	15
	2 5 $ff ICS>anim
	rot 200.0 * 100.0 + | x 
	290.0 | y
	+fx | time ani x y --
	;
	
:feed
	50 randmax 1? ( drop ; ) drop
	4 randmax dup 	| lugar
	200.0 * 100.0 + | x
	130.0 +maiz
	;
	
:game
	Immgui
	timer. vupdate
	fondo
	
	'maizs p.draw
	gallinas
	getframe	
	'fx p.draw
	|feed
	finsec 1? ( exit ) drop

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<a> =? ( 0 pico )
	<s> =? ( 1 pico )
	<d> =? ( 2 pico )
	<f> =? ( 3 pico )
	
	<f1> =? ( 0 100.0 130.0 +maiz )
	<f2> =? ( 1 300.0 130.0 +maiz )
	<f3> =? ( 2 500.0 130.0 +maiz )
	<f4> =? ( 3 700.0 130.0 +maiz )
	
	<f5> =? ( 
		50
	7 4 $ff ICS>anim
	|a> .l @ 200.0 * 100.0 + | x 
	300.0
	350.0 | y
	+fx | time ani x y --

		) | time ani x y --
	drop ;
	
:sini
	fondo
	gallinas
	sdlredraw
	vupdate
	;
	
:sfin
	Immgui
	fondo
	gallinas
	0 180 immat
	800 immwidth
	$ff00ff 'immcolortex !
	"PICOTEO" immlabelc immdn
	immdn
	"FIN DE JUEGO" immlabelc immdn
	sdlredraw
	vupdate
	;
		
:jugar
	'maizs p.clear
	'fx p.clear
	trestart
	vareset	
	0 playsnd 
	'exit 3.0 +vexe
	'sini sdlshow
	'game SDLshow
	
	vareset	
	0 playsnd 
	'exit 3.0 +vexe
	'sfin sdlshow
	;
	
:inicio
	Immgui
	0 sdlcls
	|0 0 800 600 imginicio SDLImages
	
	0 80 immat
	800 immwidth
	$ff00ff 'immcolortex !
	"PICOTEO" immlabelc immdn
	immdn
	
	400 immwidth
	200 350 immat
	
	$ffffff 'immcolortex !
	$7f00 'immcolorbtn !
	'jugar "JUGAR" immbtn immdn
	$7f0000 'immcolorbtn !
	'exit "SALIR" immbtn
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	
	drop ;
	
:main
	"Picoteo" 800 600 SDLinit
	44100 $8010 1 1024 Mix_OpenAudio
	loadsnd

	|sdlfull
	pcfont
	
	64 64 "r3/iti2024/picoteo/dibujos.png" ssload 'sprgame !
	32 32 "r3/iti2024/picoteo/fx.png" ssload 'sprfx !
	"r3/iti2024/picoteo/ZOMBIE.TTF" 
	70 ttf_OpenFont immSDL
	
	1000 'maizs p.ini
	200 'fx p.ini
	1000 vaini	| hasta 50 eventos
	
	vareset	
	'maizs p.clear
	
	timer<
	
	'inicio SDLshow
	|jugar
	
	SDLquit 
	;


: main ;
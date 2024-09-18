| Rythm game
| PHREDA 2024
|------------------
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3
^r3/lib/rand.r3
^r3/util/varanim.r3

|------ sound
#sndfiles 
"808_2.mp3"
"808_3.mp3"
"808_4.mp3"
"808_5.mp3"
"808_6.mp3"
"808_7.mp3"
"808_C.mp3"
"808_K.mp3"
"808_O.mp3"
"808_S.mp3"
"808_R.mp3"
0
#sndlist * 160

:loadsnd
	'sndlist >a
	'sndfiles
	( dup c@ 1? drop
		dup "media/snd/808/%s" sprint mix_loadWAV a!+
		>>0 ) drop ;

:playsnd | n --
	drop ;
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

#jugador 0 0 0 0 0 0 0 0
#puntaje 0 0 0 0 0 0 0 0

:son 
	0 playsnd 
|"tic" .println
	;

:toco
	over 8 + @ 3 << 'puntaje + 1 swap +!
	over @ .z 0 swap !	| zoom =0
	drop
	11 playsnd
	|"pico" .println
	;
	
:llego |9 playsnd 
	5 playsnd
	dup 8 + @ 3 << 'jugador + @
	1? ( toco ; ) drop
	;


:maizmovy | y x adr --
	'son 1.0 +vexe
	'son 2.0 +vexe
	pick3 a> 8 - 'llego 3.0 15 + | precision/2
	+vvvexe
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
	10 a!+ 
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

#time1 $1 $2 $4 $5 $1 $8 $1 $7 $3 $2 $1 $4 $5 $f -1
|#time1 1 2 1 2 1 2 1 2 1 2 -1

#ltime
#ntime

:trestart
	-1 'ltime ! 
	0 'ntime !
	;
	
:showtime
	ntime ltime =? ( drop ; ) 
	dup 'ltime !
	3 << 'time1 + @
	-? ( drop 0 'ntime ! ; )
|	1 and? ( 0.0 120.0 +cuca )
|	2 and? ( 0.0 270.0 +cuca )
|	4 and? ( 0.0 420.0 +cuca )
|	8 and? ( 0.0 570.0 +cuca )
	drop
	;

	
:tclock
	tiempo timer+ 
	largo <? ( 'tiempo ! ; )
	largo - 'tiempo ! 
	tiempo 'thit ! 
	1 'ntime +! 
	;

:bt
	estado 0? ( drop ; ) drop
	$ff0000 
	tiempo 100 >? ( swap $ff or swap ) drop
	sdlcolor
	400 40 48 40 SDLFrect
	;
	
:rt
	tiempo 100 >? ( drop ; ) drop
	$ff sdlcolor
	0 0 20 20 SDLFrect
	;

:paso
	$ff00 sdlcolor
	tiempo 2 >> 50 + 40 20 20 SDLFrect
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
		16 ( 500 <?
			2dup 2 randmax sprfx ssprite
			32 + 
			) drop
		32 + 
		) drop 
		
	100 semillero
	300 semillero
	500 semillero
	700 semillero
	;
	
:gallina
	dup 456 2.0 
	msec 7 >> 3 and 6 + 
	sprgame sspritez
	350 2.0 
	
	pick3 3 << 'jugador + @ 
	1? ( pick4 3 << 'jugador + -1 swap +! drop 1 ) 
	
	3 + sprgame sspritez
	
	dup 200 * 90 + 8 pcat
	dup 3 << 'puntaje + @ "%d" pcprint2
	
	drop
	;
	
:gallinas	
	0 100 gallina
	1 300 gallina
	2 500 gallina
	3 700 gallina
	;
	
:pico | n -- 
	3 << 'jugador + 
	dup @ 1? ( 2drop ; ) drop
	30 swap ! | precision
	10 playsnd
	;
	
:feed
	50 randmax 1? ( drop ; ) drop
	4 randmax dup 	| lugar
	200.0 * 100.0 + | x
	130.0 +maiz
	;
	
:game
	timer. vupdate
	fondo
	
	'maizs p.draw
	gallinas
	feed

	
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
	
	drop ;

:main
	"Picoteo" 800 500 SDLinit
	44100 $8010 1 1024 Mix_OpenAudio
	loadsnd

	|sdlfull
	pcfont
	
	64 64 "r3/iti2024/picoteo/dibujos.png" ssload 'sprgame !
	32 32 "r3/iti2024/picoteo/fx.png" ssload 'sprfx !

	1000 'maizs p.ini
	500 'fx p.ini
	500 vaini

	'maizs p.clear
	
	timer<
	'game SDLshow
	SDLquit 
	;


: main ;
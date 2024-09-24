| Rythm game
| PHREDA 2024
|------------------
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2mixer.r3
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
	3 << 'sndlist + @ SNDplay ;

|------- graficos
#imgfondo
#sprgame
#sprplayer

#cucas 0 0 
#fx 0 0

#tic 		500 | miliseconds
#tiempo		0	| tiempo ahora

#jugador 0 0 0 0 0 0 0 0
#puntaje 0 0 0 0 0 0 0 0

| x y anim
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.a 3 ncell+ ;

:cuca
	dup 8 + >a 
	a@+ int. a@+ int.  | x y
	0.25 1.0
	a@ timer+ dup a!+ 
	anim>N sprgame sspriterz | x y zoom img --
	drop	
	;

:toco
	over 8 + @ 3 << 'puntaje + 1 swap +!
	|over @ .z 0 swap !	| zoom =0
	drop
	"toco" .println
	;
	
:momento |9 playsnd 
	dup 8 + @ 3 << 'jugador + @
	1? ( toco ; ) drop
	;
	
:cucamovy | y x adr --
	dup pick3 50.0 - pick4 20 0.5 0.0 +vanim	
	dup pick3 pick4 50.0 - 19 0.5 0.5 +vanim	
	dup pick3 50.0 - pick4 20 0.5 1.0 +vanim	
	dup pick3 pick4 50.0 - 19 0.5 1.5 +vanim	
	dup pick3 50.0 - pick4 20 0.5 2.0 +vanim	
	dup pick3 pick4 50.0 - 19 0.5 2.5 +vanim	

|	dup 400.0 
|	20.0 randmax 10.0 - +
|	310.0 0 0.5 3.0 +vanim	
	
	drop ;

:cucamovx | y x adr --
	dup 220.0 -20.0 0 0.95 0.0 +vanim
	dup 460.0 220.0 0 0.95 1.05 +vanim
	dup 700.0 460.0 0 0.95 2.05 +vanim
	
	dup 1000.0 700.0 21 0.25 3.1 +vanim
|	dup 20.0 randmax 10.0 - +
|	800.0 20.0 randmax 10.0 - +
|	700.0 21 0.25 3.0 +vanim
	
	pick3 a> 8 - 'momento 3.0 +vvvexe
|	dup pick2 80.0 - 
|	20.0 randmax 10.0 - +
|	pick3 20 0.5 3.0 +vanim	

	drop ;
	

:+cuca | n x y --
	'cuca 'cucas p!+ >a
	swap 
	a> cucamovx
	a> 8 + cucamovy
	a!+ a!+
	0 4 $3f ICS>anim a!+ 
	a!+
	;
	
|------- game


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
	dup 'ltime ! 3 << 'time1 + @
	-? ( drop ; ) |0 'ntime ! ; )
	1 and? ( 0 0.0 120.0 +cuca )
	2 and? ( 1 0.0 270.0 +cuca )
	4 and? ( 2 0.0 420.0 +cuca )
	8 and? ( 3 0.0 570.0 +cuca )
	drop
	;
	
:tclock
	timer.
	tiempo timer+ 
	tic <? ( 'tiempo ! ; )
	tic - 'tiempo ! 
	1 'ntime +! 
	;

:showtic
	$ff00 sdlcolor
	tiempo 2 >> 50 + 40 20 20 SDLFrect
	tiempo 100 >? ( drop ; ) drop
	$ff sdlcolor
	0 0 20 20 SDLFrect
	;

|------------- jugadores
:hip | n -- 
	3 << 'jugador + 
	dup @ 1? ( 2drop ; ) drop
	20 swap ! | tiempo 
	;	
	
	
:player | player --

	740 				| x
	70 pick2 140 * +	| y
	
	pick2 3 << 'jugador + @ 
	1? ( pick3 3 << 'jugador + -1 swap +! drop 1 
		swap 40 + swap ) 
	pick3 2* +
	sprplayer 
	ssprite
	
	900 over 150 * 80 + pcat
	dup 3 << 'puntaje + @ "%d" pcprint2
	
	drop
	;

:debug
	$ffffff pccolor
	0 0 pcat
	ntime "ntime:%d" pcprint pccr
	ntime 3 << 'time1 + @ "actual:%h" pcprint pccr
	'jugador
	@+ "%h " pcprint
	@+ "%h " pcprint
	@+ "%h " pcprint
	@+ "%h " pcprint
	drop
	;
	
|------ JUEGO
:game
	vupdate
	$0 SDLcls
	0 0 800 600 imgfondo SDLImages
	|immgui 	
	
	|debug
	tclock
	|showtic
	'cucas p.draw
	'fx p.draw
	0 player 1 player 2 player 3 player
	
	showtime
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	
	<a> =? ( 0 hip )
	<s> =? ( 1 hip )
	<d> =? ( 2 hip )
	<f> =? ( 3 hip )
	
	drop ;
	
:reset
	timer<
	;
		
:main
	"Ritmo!!" 800 600 SDLinit
	44100 $8010 1 1024 Mix_OpenAudio
	
	|sdlfull
	pcfont
	loadsnd
	
	64 64 "r3/iti2024/rg/cuca.png" ssload 'sprgame !
	128 140 "r3/iti2024/rg/chanclas.png" ssload 'sprplayer !
	"r3/iti2024/rg/cocina.jpeg" loadimg 'imgfondo !
	100 'cucas p.ini
	100 'fx p.ini
	1000 vaini
	vareset
	
	reset
	'game SDLshow
	SDLquit 
	;

: main ;
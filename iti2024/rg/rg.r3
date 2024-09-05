| Rythm game
| PHREDA 2024
|------------------
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3
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


| 1 2  3   4   5   6   7 8  9  10 11    
| x y 

:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.s 4 ncell+ ;


:cuca
	dup 8 + >a 
	a@+ int. a@+ int.  | x y
	|over 8 << 
	0.25
	1.0
	a@ timer+ dup a!+ 
	anim>N sprgame sspriterz | x y zoom img --
	
	2.0 over .x +!
	dup .x @ 1024.0 >? ( 2drop 0 ; ) drop
	|dup .x @ 1000.0 >? ( drop .s @ playsnd 0 ; ) drop
	drop	
	;
	
:+cuca | x y --
	'cuca 'cucas p!+ >a
	swap a!+ a!+
	0 4 $3f ICS>anim a!+ 
	;
	
|------- game
#tic 		500 | miliseconds
#tiempo		0	| tiempo ahora

#jugador 0 0 0 0 0 0 0 0
#jugadoe 0 0 0 0 0 0 0 0

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
	-? ( drop 0 'ntime ! ; )
	1 and? ( 0.0 120.0 +cuca )
	2 and? ( 0.0 270.0 +cuca )
	4 and? ( 0.0 420.0 +cuca )
	8 and? ( 0.0 570.0 +cuca )
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
:hip | player --
	3 <<
	dup 'jugadoe + @ 1? ( 2drop ; ) drop
	dup 8 $f0 ICS>anim
	over 'jugador + ! 
	1 swap 'jugadoe + !
	;
	
:stopp | player --
	3 <<
	dup 0 0 ICS>anim 
	over 'jugador + ! 
	0 swap 'jugadoe + !
	;
	
:player | player --
	950 				| x
	80 pick2 150 * +	| y
	pick2 3 << 'jugador + 
	dup @ timer+ dup rot ! anim>n
	dup $7 and 7 =? ( pick4 stopp ) drop
	sprplayer 
	ssprite
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
	0 0 1024 600 imgfondo SDLImages
	|immgui 	
	
	debug
	tclock
	showtic
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
	|<f1> =? ( )

	drop ;
	
:reset
	timer<
	0 stopp 1 stopp 2 stopp 3 stopp
	;
		
:main
	"Ritmo!!" 1024 600 SDLinit
	44100 $8010 1 1024 Mix_OpenAudio
	
	|sdlfull
	pcfont
	loadsnd
	
	64 64 "r3/iti2024/rg/cuca.png" ssload 'sprgame !
	150 250 "r3/iti2024/rg/chancla.png" ssload 'sprplayer !
	"r3/iti2024/rg/cocina.png" loadimg 'imgfondo !
	100 'cucas p.ini
	100 'fx p.ini
	50 vaini
	vareset
	
	reset
	'game SDLshow
	SDLquit 
	;

: main ;
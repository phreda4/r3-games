| Malevolo cucarachon
| PHREDA 2024
|------------------
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2mixer.r3
^r3/util/pcfont.r3
^r3/util/arr16.r3
^r3/lib/rand.r3
^r3/util/varanim.r3
^r3/util/sdlgui.r3
^r3/util/sort.r3

|------ sound
#sndfiles "inicio" "fin" "chancletazo" "saltocuca" "smashcuca" 0
#sndlist * 160
#musfin

:loadsnd
	'sndlist >a
	'sndfiles
	( dup c@ 1? drop
		dup "r3/iti2024/mc/%s.mp3" sprint mix_loadWAV a!+
		>>0 ) drop ;

:playsnd | n --
	3 << 'sndlist + @ SNDplay ;

|------- graficos
#imgfondo
#imginicio
#imgpodio
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
:.s 4 ncell+ ;	| n sprite
:.l 5 ncell+ ;	| lugar

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
	over @ .a 4 13 $ff ICS>anim swap !	| zoom =0
	drop
	4 playsnd
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
	drop ;

:cucamovx | y x adr --
	dup 220.0 -20.0 0 0.95 0.0 +vanim
	dup 460.0 220.0 0 0.95 1.05 +vanim
	dup 700.0 460.0 0 0.95 2.05 +vanim
	dup 1000.0 700.0 21 0.25 3.1 +vanim
	
	[ 3 playsnd ; ] 
	dup 1.0 +vexe
	dup 2.0 +vexe
	3.0 +vexe
	
	pick3 a> 8 - 'momento 3.0 +vvvexe
	drop ;
	

:+cuca | n x y --
	'cuca 'cucas p!+ >a
	swap 
	a> cucamovx
	a> 8 + cucamovy
	a!+ a!+
	0 4 $3f ICS>anim a!+ 
	0.1 a!+
	a!+
	;
	
|------- timeline
#nivel0 " abdh  clcl  ejej  o o oo clejclej oooo        "
#nivel1 " abdh abcdefghijklmno "

#nivs 'nivel0 'nivel1 0
#niv 0

#finsec
#ltime
#ntime

:trestart
	'fx p.clear
	'cucas p.clear
	-1 'ltime ! 0 'ntime !
	0 'finsec !
	timer<
	vareset
	0 'tiempo !
	;

#nivel 'nivel0

:tclock
	timer.
	tiempo timer+ 
	tic <? ( 'tiempo ! ; )
	tic - 'tiempo ! 
	1 'ntime +! 
	;

:getframe
	tclock
	ntime ltime =? ( drop ; ) 
	dup 'ltime ! nivel + c@
	0? ( drop 1 'finsec ! ; )
	1 and? ( 0 0.0 120.0 +cuca )
	2 and? ( 1 0.0 270.0 +cuca )
	4 and? ( 2 0.0 420.0 +cuca )
	8 and? ( 3 0.0 570.0 +cuca )
	drop
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
	2 playsnd
	20 swap ! | tiempo 
	;	
	
	
:player | player --
	740 				| x
	70 pick2 150 * +	| y
	
	pick2 3 << 'jugador + @ 
	1? ( pick3 3 << 'jugador + -1 swap +! drop 1 
		swap 40 + swap ) 
	pick3 2* +
	sprplayer 
	ssprite
	
	$ffffff ttcolor
	40 over 150 * 40 + ttat
	dup 3 << 'puntaje + @ "%d" ttprint
	
	drop
	;

|------ JUEGO
:juego
	vupdate
|	$0 SDLcls
	0 0 800 600 imgfondo SDLImages

	'cucas p.draw

	0 player 1 player 2 player 3 player	
	'fx p.draw
	
	getframe
	
	finsec 1? ( exit ) drop
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	
	<up> =? ( 0 hip )
	<dn> =? ( 1 hip )
	<ri> =? ( 2 hip )
	<le> =? ( 3 hip )
	
	drop ;
	
#xt 200  #yt 200
#title
	
:sini
	vupdate
|	0 sdlcls
	0 0 800 600 imgfondo SDLImages
	0 player 1 player 2 player 3 player	
	$ffffff ttcolor	xt yt ttat title ttprint
	sdlredraw
	sdlkey
	>esc< =? ( exit )
	drop
	;


#podio 0 0 0 0 0 0 0 0

:spodio	
	Immgui
	vupdate
	0 0 800 600 imgpodio SDLImages
	
	180 510 0.11 'podio 40 + @ 9 + sprplayer sspriter
	426 360 0.11 'podio 8 + @ 9 + sprplayer sspriter
	686 450 0.11 'podio 24 + @ 9 + sprplayer sspriter

	$0 ttcolor	
	150 350 ttat "3" ttprint
	400 200 ttat "1" ttprint
	660 290 ttat "2" ttprint
	
	400 immwidth
	200 20 immat
	$ffffff 'immcolortex !
	$7f0000 'immcolorbtn !
	'exit "Continuar" immbtn
	
	sdlredraw
	sdlkey
	>esc< =? ( exit )
	<up> =? ( exit )
	<dn> =? ( exit )
	<ri> =? ( exit )
	<le> =? ( exit )
	drop
	;

:hacepodio	
	musfin 1 mix_playmusic
	'podio >a
	'puntaje >b
	0 ( 4 <? 
		b@+ neg a!+	| valor
		dup a!+ 
		1+ ) drop
	4 'podio shellsort	
	'spodio sdlshow
	Mix_HaltMusic
	;


:jugar
	0 'niv !
	'puntaje >a 8 ( 1? 1- 0 a!+ ) drop

	'nivs niv 3 << + @ 'nivel !

	trestart
	0 playsnd 
	
	-60 'yt !
	'yt 280 -60 8 1.0 0.5 +vanim	
	'yt 660 280 7 1.0 2.5 +vanim	
	"PREPARADOS" 'title !
	'exit 4.0 +vexe	
	'sini sdlshow
	
	trestart	
	'juego SDLshow
	
	1 playsnd 
	'yt 280 -60 8 1.0 0.0 +vanim	
	'yt 660 280 7 1.0 2.0 +vanim	
	"FIN DE JUEGO" 'title !
	'exit 3.0 +vexe	
	'sini sdlshow
	
	hacepodio
	
	;
	
#fullscr

:toglefs
	fullscr 1 xor 'fullscr !
	SDL_windows fullscr $1 and SDL_SetWindowFullscreen 
	;
	
:inicio
	Immgui
	0 0 800 600 imginicio SDLImages

	$ffffff 'immcolortex !	
	$0 'immcolorbtn !
	200 immwidth
	
	320 364 immat
	'jugar "JUGAR" immebtn immdn
	320 464 immat
	'exit "SALIR" immebtn
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	<up> =? ( jugar )
	<f> =? ( toglefs )	
	drop ;
	
:main
	"MC" 800 600 SDLinit
	SDLrenderer 800 600 SDL_RenderSetLogicalSize | fullscreen
	44100 $8010 1 1024 Mix_OpenAudio
	
	|sdlfull
	pcfont
	loadsnd
	"r3/iti2024/mc/musicafin.mp3" mix_loadmus 'musfin	!	
	
	64 64 "r3/iti2024/mc/cuca.png" ssload 'sprgame !
	128 140 "r3/iti2024/mc/chanclas.png" ssload 'sprplayer !
	"r3/iti2024/mc/inicio.jpeg" loadimg 'imginicio !
	"r3/iti2024/mc/cocina.png" loadimg 'imgfondo !
	"r3/iti2024/mc/podio.png" loadimg 'imgpodio !

	|"r3/iti2024/mc/zombieguts.ttf"
	"r3/iti2024/mc/BICHOCHOS_TYPE.ttf" 
	60 ttf_OpenFont immSDL
	100 'cucas p.ini
	100 'fx p.ini
	1000 vaini
	vareset

	'inicio SDLshow
	|jugar
	
	SDLquit 
	;

: main ;
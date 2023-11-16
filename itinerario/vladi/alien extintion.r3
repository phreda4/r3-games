^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/arr16.r3
^r3/win/sdl2mixer.r3
^r3/util/sdlgui.r3
^r3/util/boxtext.r3
^r3/util/sort.r3

#font

#tsnave	| dibujo
#aninave 0	| frame maximo
#xp 400.0 #yp 560.0		| posicion
#xv #yv		| velocidad

#fx 0 0
#disparos 0 0 
#enemis 0 0

#dispaparo
#exploplo
#menumusica
#musicafondo

#puntos 0
#tiempo 0

#puntosm 0
#tiempom 0

#puntajevx * 160 | 10 * 2
#puntajetxt * 1024

#line * 33
:eline
	'line 32 32 cfill 0 'line 32 + c! ;
:,line | str nro --
	'line + swap ( c@+ 1? rot c!+ swap ) 3drop ;
:,line< | str nro --
	swap count rot swap - ,line ;
:buildhs
	11 'puntajevx shellsort
	mark
	'puntajetxt 'here !
	'puntajevx >a
	eline
	0 ( 5 <? 1 +
		dup "%d. " sprint 0 ,line
		a@+ neg "%d" sprint 10 ,line< 
		a@+ dup $ff and swap 8 >> swap "%d:%d" sprint 25 ,line< 
		'line ,s ,cr eline 
		) drop
	,eol
	empty ;

:objsprite | adr -- adr
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ nanim 			| n
	a@+ sspriterz
	dup 40 + @ over +!
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	;
		
#fondo
#fondo2
:explosion
	objsprite	
	24 + @ nanim 36 =? ( drop 0 ; )
	drop
	;

:+explo	| y x --
	'explosion 'fx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+	| ang zoom
	6 16 22 vci>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!	
	exploplo SNDplay	| vrz
	;

:exploplayer
	objsprite
	24 + @ nanim 19 =? ( drop 0 exit ; )
	drop
	;

#muerte 
:+explon | --
	1 'muerte !
	'exploplayer 'fx p!+ >a 
	xp a!+ yp a!+	| x y 
	2.0 a!+	| ang zoom
	6 20 4 vci>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!		
	exploplo SNDplay | vrz
	;

#hit
:choque  | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	dup 'enemis p.del
|	pick4 pick4 +fx
	50 'puntos +!
|	puntajevx puntos max 'puntajevx !
|	1 playsnd
	0 'hit !
	pick4 pick4 +explo
	;

|disparo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:bala | v -- 
	objsprite
	
	1 'hit !
	dup @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	'choque 'enemis p.mapv | 'vector list --	
	2drop
	hit 0? ( nip ; ) drop
	drop
	;

#timedisparo

:+disparo
	timedisparo +? ( drop ; ) drop
	30 'timedisparo !
	'bala 'disparos p!+ >a 
	xp a!+ 560.0 a!+	| x y 
	0.75 a!+	| ang zoom
	7 2 37 vci>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	0 a!+ -3.0 a!+ 	| vx vy
	0.1 32 << a!			| vrz
	dispaparo SNDplay
	;

	
:alien | v -- 
	objsprite	
	|..... remove when outside screen
	dup @+ dup -17.0 817.0 between -? ( 4drop 0 ;  ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	30.0 <? ( +explon ) drop
	drop
	;

:+marciano
	'alien 'enemis p!+ >a 
	|800.0 randmax 
	600.0 randmax 100.0 + a!+ -100.0 a!+ |alien  x y 
	1.0 a!+	| ang zoom
	7 2 20 vci>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	2.0 randmax 1.0 - 
	a!+ 1.0 a!+ 	| vx vy
	0 a!		
	;

:jugador
	SDLkey
	>esc< =? ( exit )
	<le> =? ( -3.0 'xv ! )
	>le< =? ( 0 'xv ! )
	<ri> =? ( 3.0 'xv ! )
	>ri< =? ( 0 'xv ! )	
	<esp> =? ( +disparo )
	drop 

	muerte 1? ( drop ; ) drop
	xp int. yp int. 
	2.0 
	aninave timer+ dup 'aninave ! nanim
	tsnave sspritez	

	xv 'xp +!
	yv 'yp +!
	;
	
:horda
	60 randmax 1? ( drop ; ) drop
	+marciano
	;
	
:puntaje	
	mark
	puntos "%d" ,print ,cr
	tiempo 1000 / 60 /mod swap "%d:%d" ,print
	,eol
	empty 

	$01 here
	20 5 760 100 xywh64 
	$2000000ffffff font
	textboxo | $vh str box color font --

	mark
	puntosm "%d" ,print ,cr
	tiempom dup $ff and swap 8 >> swap "%d:%d" ,print
	,eol
	empty 

	$21 here
	20 5 760 100 xywh64 
	$2000000ffffff font
	textboxo | $vh str box color font --
	;
	
:juego
	0 0 fondo SDLImage 
	timer.
	deltatime 'tiempo +!
	
	-1 'timedisparo +! 
	'disparos p.draw
	jugador	
	'enemis p.draw	
	'fx p.draw
	puntaje

	SDLredraw
	horda
	;

:reset
	'disparos p.clear
	'enemis p.clear
	'fx p.clear
	400.0 'xp !
	560.0 'yp !
	8 4 0 vci>anim 'aninave !
	0 'muerte !
	0 'puntos !
	0 'tiempo !
	;

:jugando
	reset 
	'puntajevx @+ neg 'puntosm ! @ 'tiempom !
	
	musicafondo -1 mix_playmusic
	'juego Sdlshow
	menumusica -1 mix_playmusic
	
	tiempo 1000 / 60 /mod 8 << or 
	puntos neg
	'puntajevx 9 4 << + !+ !
	buildhs
	;

:menu
	0 0 fondo2 SDLImage
	immgui
	0 50 immat
	800 immwidth
	$FF6A00 'immcolortex !
	"Aliens Extintion" immlabelc
	300 150 immat
	200 immwidth
	$ffffff 'immcolortex !
	'jugando "Jugar" immbtn
	immdn
	'exit "Salir" immbtn
	
	$00 'puntajetxt 
	200 260 600 300 xywh64 
	$2000000ffffff
	font
	textboxo | $vh str box color font --

	timer.
	400 500 5.0 
	aninave timer+ dup 'aninave ! nanim
	tsnave sspritez	
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugando )
	drop
	;
	
:loadhs
	'puntajevx "r3/itinerario/vladi/puntaje.mem" load drop
	buildhs ;
	
:savehs
	'puntajevx 160 "r3/itinerario/vladi/puntaje.mem" save ;
		
:main
	"r3sdl" 800 600 SDLinit
	32 32 "r3/itinerario/vladi/nave y alien.png" ssload 'tsnave !
	"r3/itinerario/vladi/fondo.png" loadimg 'fondo !
	"r3/itinerario/vladi/FONDO DE LOS TITULOS GAMMA.png" loadimg 'fondo2 !
	"r3/itinerario/vladi/Minecraft.ttf" 30 TTF_OpenFont dup 'font ! immSDL 
	|sndinit
	"r3/itinerario/vladi/laser-gun.mp3" mix_loadWAV 'dispaparo !
	"r3/itinerario/vladi/explosion.mp3" mix_loadWAV	'exploplo !
	"r3/itinerario/vladi/Nogkii - Wii Menu.mp3" mix_loadmus 'menumusica !
	"r3/itinerario/vladi/Sonic the Werehog Monster.mp3" mix_loadmus 'musicafondo !
	200 'disparos p.ini
	100 'enemis p.ini
	200 'fx p.ini 
	8 4 0 vci>anim 'aninave !
|	menumusica -1 mix_playmusic
	timer<
	loadhs
	'menu SDLshow
	savehs
	SDLquit ;	
: main ;
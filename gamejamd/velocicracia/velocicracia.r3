| Velocicacia
| Democracia Gamejam 2023
| EESN 1 - San Cayetano
| PHREDA
|-----
^r3/lib/rand.r3
^r3/lib/color.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/arr16.r3
^r3/util/varanim.r3
^r3/util/boxtext.r3
^r3/util/sdlgui.r3

#font

#sprmesa
#sprbarra
#sprvida
#sprlogo
#sprmafalda
#sprpatoru
#sprmatias
#sprhijitus
#sprboletas

#sprfx

#imgfinal 0 0 0
#imgfinalb
#imgcreditos

#sndvoto
#sndok
#snderror
#sndboton

#listfx 0 0 | fx
#listbol 0 0

#colores $E51B20 $347BBE $F3D611 $684495
#tiempoclick
#colorclick
#msclick 3000

#puntos 
#vidas

|-------- sprite list
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.r 3 ncell+ ; 
:.a 4 ncell+ ; 
:.ss 5 ncell+ ;
:.vx 6 ncell+ ;
:.vy 7 ncell+ ;

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rota zoom				
	a@ timer+ dup a!+ 	| anima
	anim>N a@+ sspriterz
	dup .vx @ over .x +!	| vx
	dup .vy @ over .y +!	| vy
	;
	
:.xd 8 ncell+ ;	
:.yd 9 ncell+ ;

:.xt@ 10 ncell+ @ $ffffffff and ; | easex (8) easey (8)  timemax (32) 
:.easex@ 10 ncell+ @ 32 >> $ff and ; 
:.easey@ 10 ncell+ @ 40 >> $ff and ; 

:llegosobre
	colorclick =? ( drop 1 'puntos +! sndok SNDplay ; ) drop
	snderror SNDplay
	-1 'vidas +! 
	vidas 0? ( exit ) drop
	;

:objspritemove
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rota zoom				
	a@ timer+ dup a!+ 	| anima
	anim>N a@+ sspriterz
	
	dup .a @ $ffffffffff and | timenow
	1.0 pick2 .xt@ */
	1.0 >? ( drop .a @ 52 >> llegosobre 0 ; )
	over .vx @ 				| adr time x
	over pick3 .easex@ ease | adr time x timen 
	pick3 .xd @ pick2 - *. + pick2 .x ! | adr time
	over .easey@ ease		| adr timen
	over .vy @ 							| adr timen y
	pick2 .yd @ over - rot *. + over .y !	| adr y
	drop
	;

|--------------- fx	
:ofx
	objsprite
	dup .x @ -400.0 <? ( 1400.0 pick2 .x ! ) drop
	dup .y @ 350.0 - abs 150.0 >? ( over .vy dup @ neg swap ! ) drop | 200..500
	drop
	;

:+fx	| vx vy n x y --
	'ofx 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+ 		| rota|zoom
	52 << a!+ sprfx a!+ | n spritesheet
	swap a!+ a!+ ;  | vx vy
	
|------------
:+boleta | easex easey et x2 y2 x1 y1 n --
	'objspritemove 'listbol p!+ >a 
	pick2 a!+ over a!+ 1.0 a!+ 52 << a!+ sprboletas a!+
	swap a!+ a!+ swap a!+ a!+
	1000 *. $ffffffff and 
	rot 32 << or swap 40 << or
	a!+
	;	
	
|-------------- Juego
:vidascora	
	0 ( 3 <?
		dup 68 * 380 + 520 
		pick2 vidas - 63 >> $1 and
		sprvida ssprite
		1 + ) drop ;
	
:newcolor
	4 randmax 'colorclick !
	-50 'msclick +!
	msclick 'tiempoclick !
	;

:xygui
	xr2 xr1 + 1 >> 16 << 
	yr2 yr1 + 1 >> 16 << ;
	
:clickc | color --
	>a 2 2 0.5 840.0 320.0 xygui a> +boleta	
	sndvoto SNDplay ;

:barratiempo
	'colores colorclick ncell+ @ SDLColor
	317 42 
	390 tiempoclick msclick */
	32 SDLFRect
	317 34 sprbarra SDLImage
	tiempoclick timer- 'tiempoclick !
	tiempoclick 0 <? ( newcolor ) drop
	;

#ojos
	
:jueces	
	200 280 ojos 9 >> $1 and
	sprmafalda ssprite
	400 250 ojos 10 >> $1 and
	sprpatoru ssprite
	570 280 ojos 11 >> $1 and
	sprmatias ssprite
	740 280 ojos 12 >> $1 and
	sprhijitus ssprite
	20 randmax 0? ( rand 'ojos ! ) drop
	;

	
:juego
	vupdate timer.
	$ffffff SDLcls
	jueces
	0 0 sprmesa SDLImage
	barratiempo
	vidascora
	
	immgui	
	90 80 immbox
	200 360 immat [ 0 clickc ; ] immzone 	|plxywh SDLRect 
	380 360 immat [ 1 clickc ; ] immzone 	|plxywh SDLRect 
	560 360 immat [ 2 clickc ; ] immzone 	|plxywh SDLRect 
	690 360 immat [ 3 clickc ; ] immzone 	|plxywh SDLRect 
	
	80 100 immbox
	$0 'immcolortex !
	820 55 immat
	puntos "%d" immlabelC 

	'listbol p.draw
	'listfx p.draw
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
	drop ;

|-------------------------------
::immbtn | 'click "" -- ; reecode button
	plxywh guiBox
	immcolorbtn SDLColor plxywh SDLFRect
|	plxywh sprbarra SDLimages immcolorbtn 'immcolortex !
	3 3 immat+ [ 3 3 immat+ ; ] guiI 
	immlabelc
	[ sndboton SNDplay 400 SDL_delay dup ex ; ] onClick drop ;
	
:finjuego
	$ffffff SDLcls
	Immgui timer.
	0 0 imgfinalb SDLImage
	400 immwidth
	
	$0 'immcolortex !
	1024 immwidth
	0 150 immat
	"Fin de Juego" immlabelc
	immdn immdn
	puntos "%d Puntos" immlabelc
	
	$674494 'immcolorbtn !
	$ffffff 'immcolortex !
	260 immwidth
	382 500 immat
	'exit "Continuar..." immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop
	;

:jugar 
	'listfx p.clear
	'listbol p.clear
	0 'puntos !
	3 'vidas !
	3000 'msclick !
	newcolor
	'juego SDLShow 
	;

|-------------------------------------
#pantfinal 0
#xp

:sespera
	vupdate
	$ffffff sdlcls
	immgui
	xp 0 pantfinal SDLImage
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop ;
	
:findejuego	
	'imgfinal
	0 ( 3 <? swap
		@+ 'pantfinal !
		vareset 
		'xp 0 -1024 23 1.0 0.0 +vanim 
		'xp 1024 0 22 1.0 3.0 +vanim 
		'exit 4.0 +vexe
		'sespera SDLshow
		vareset
		swap 1 + ) 2drop 
	'finjuego SDLshow 
	;

|-------------------------------------
#yc 600

:screditos
	immgui
	$ffffff sdlcls
	244 yc imgcreditos SDLImage	
	
	yc 1 - 
	-2323 <? ( 600 nip ) 
	'yc !
	
	0 0 imgfinalb SDLImage
	260 immwidth
	$674494 'immcolorbtn !
	760 50 immat
	'exit "CONTINUAR..." immbtn	
	SDLredraw	
	SDLkey
	>esc< =? ( vareset exit )
	drop ;
	
|-------------------------------------
#textoinicio
"Vota por el color en la barra de tiempo.
Si votás el equivocado pierdes una vida."
#xlogo 228
#ylogo 10

:menuani
	vareset
	'ylogo 10 -10 29 1.0 0.0 +vanim 
	'ylogo -10 10 28 1.0 3.0 +vanim 
	'xlogo 228 -700 23 1.0 0.0 +vanim 
	'xlogo 1100 228 22 1.0 3.0 +vanim 
	'menuani 4.0 +vexe
	;

:creditos	
	600 'yc !
	'screditos SDLShow
	menuani
	;
	
:menuj
	jugar
	findejuego
	menuani
	;	
	
:menu
	vupdate
	$ffffff sdlcls
	immgui
	xlogo ylogo sprlogo SDLImage
	
	$ffffff 'immcolortex !
	220 60 immbox
	$674494 'immcolorbtn !
	140 500 immat 'creditos "CREDITOS" immbtn
	$347BBD 'immcolorbtn !
	380 500 immat 'menuj "JUGAR" immbtn
	$E61B1F 'immcolorbtn !
	620 500 immat 'exit "SALIR" immbtn

	$11 'textoinicio
	200 150 624 400 xywh64 
	0 font textbox | $vh str box color font --
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<esp> =? ( menuj )
	drop
	;
	
|-------------------------------------
:main
	"velocicracia" 1024 600 SDLinit

	"r3/gamejamd/velocicracia/logo.png" loadimg 'sprlogo !
	"r3/gamejamd/velocicracia/juego.png" loadimg 'sprmesa !
	"r3/gamejamd/velocicracia/barratiempo.png" loadimg 'sprbarra !
	58 58 "r3/gamejamd/velocicracia/vida.png" ssload 'sprvida !
	196 170 "r3/gamejamd/velocicracia/mafalda.png" ssload 'sprmafalda !
	179 375 "r3/gamejamd/velocicracia/Patoruzito.png" ssload 'sprpatoru !
	163 199 "r3/gamejamd/velocicracia/matias.png" ssload 'sprmatias !
	150 249 "r3/gamejamd/velocicracia/Hijitus.png" ssload 'sprhijitus !
	74 106  "r3/gamejamd/velocicracia/boletas.png" ssload 'sprboletas !

	'imgfinal >a
	"r3/gamejamd/velocicracia/final1.png" loadimg a!+
	"r3/gamejamd/velocicracia/final2.png" loadimg a!+
	"r3/gamejamd/velocicracia/final3.png" loadimg a!
	
	"r3/gamejamd/velocicracia/final.png" loadimg 'imgfinalb !
	"r3/gamejamd/velocicracia/creditos.png" loadimg 'imgcreditos !	
	
	"r3/gamejamd/velocicracia/voto.mp3" mix_loadWAV 'sndvoto !
	"r3/gamejamd/velocicracia/ok.mp3" mix_loadWAV 'sndok !
	"r3/gamejamd/velocicracia/error.mp3" mix_loadWAV 'snderror !
	"r3/gamejamd/velocicracia/boton.mp3" mix_loadWAV 'sndboton !
	
	"r3/gamejamd/velocicracia/quino.otf" 46 TTF_OpenFont 'font ! 
	font immSDL 
	timer<
	$ff vaini
	100 'listfx p.ini
	200 'listbol p.ini
	menuani
	'menu SDLShow
	SDLquit ;	
	
: main ;

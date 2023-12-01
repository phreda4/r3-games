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
#sprmafalda
#sprpatoru
#sprmatias
#sprhijitus
#sprboletas
#sprfx

#sndnaipe

#listfx 0 0 | fx
#listbol 0 0

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
	nanim a@+ sspriterz
	dup .vx @ over .x +!	| vx
	dup .vy @ over .y +!	| vy
	;
	
:.xd 8 ncell+ ;	
:.yd 9 ncell+ ;

:.xt@ 10 ncell+ @ $ffffffff and ; | easex (8) easey (8)  timemax (32) 
:.easex@ 10 ncell+ @ 32 >> $ff and ; 
:.easey@ 10 ncell+ @ 40 >> $ff and ; 

:objspritemove
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rota zoom				
	a@ timer+ dup a!+ 	| anima
	nanim a@+ sspriterz
	
	dup .a @ $ffffffffff and | timenow
	1.0 pick2 .xt@ */
	1.0 >? ( 2drop 0 ; )
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
	swap a!+ a!+
	swap a!+ a!+
	1000 *. $ffffffff and 
	rot 32 << or swap 40 << or
	a!+
	;	
	
|-------------- Juego
#colores $ff $ff00 $ff0000 $ff00ff
#tiempoclick
#colorclick

#puntos 
#vidas
	
:newcolor
	4 randmax 'colorclick !
	3000 'tiempoclick !
	;

:xygui
	xr2 xr1 + 1 >> 16 << 
	yr2 yr1 + 1 >> 16 << ;
	
:clickc | color --
	2 2 1.0 800.0 200.0 xygui colorclick +boleta 
	colorclick <>? ( drop -1 'vidas ! ; ) drop
	newcolor
	1 'puntos +!
	;

#ojos
	
:jueces	
	200 230
	ojos 9 >> $1 and
	sprmafalda ssprite
	
	400 200
	ojos 10 >> $1 and
	sprpatoru ssprite
	
	570 230
	ojos 11 >> $1 and
	sprmatias ssprite
	
	740 230
	ojos 12 >> $1 and
	sprhijitus ssprite
	20 randmax 0? ( rand 'ojos ! ) drop
	;
	
:juego
	vupdate timer.
	deltatime neg 'tiempoclick +!
	$78ADE8 SDLcls
	
	jueces
	0 180 sprmesa SDLImage
	
	immgui	

	100 90 immbox
	150 300 immat [ 0 clickc ; ] immzone 
	$ff SDLColor plxywh SDLFRect 
	330 300 immat [ 1 clickc ; ] immzone 
	$ff00 SDLColor plxywh SDLFRect 
	510 300 immat [ 2 clickc ; ] immzone 
	$ff0000 SDLColor plxywh SDLFRect 
	690 300 immat [ 3 clickc ; ] immzone 
	$ff00ff SDLColor plxywh SDLFRect 
	
	'colores colorclick ncell+ @ SDLColor
	412 20 200 100 SDLFRect
	
	200 50 immbox
	412 120 immat
	puntos "%d" sprint immlabelC
	412 160 immat
	tiempoclick "%d" sprint immlabelC
	
	tiempoclick 0 <? ( newcolor ) drop
	
	'listbol p.draw
	'listfx p.draw
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
	<f1> =? ( newcolor )
	<f2> =? ( 9 11 2.0 800.0 400.0 100.0 100.0 0 +boleta )
	|:+boleta2 | ex ey et x2 y2 x1 y1 n --
	drop ;

:reset
	'listfx p.clear
	'listbol p.clear
	0 'puntos !
	5 'vidas !
	newcolor
	;

:finjuego
	$0 SDLcls
	Immgui timer.
|	'estrellas p.draw

	0 50 immat
	800 immwidth
	"Fin de Juego" immlabelc
	immdn immdn
	
	puntos "%d Puntos" sprint immlabelc

	200 500 immat
	400 immwidth
	$7f 'immcolorbtn !
	'exit "Continuar" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop
	;

:jugar 
	reset
	'juego SDLShow ;

|-------------------------------------
:menu
	|0 0 fondo2 SDLImage
	$ffffff sdlcls
	immgui
	
	1024 immwidth
	$0 'immcolortex !
	0 50 immat "Velocicracia" immlabelc
	
	$ffffff 'immcolortex !
	200 immwidth
	$7f00 'immcolorbtn !
	300 200 immat 'jugar "JUGAR" immbtn
	
	$7f0000 'immcolorbtn !
	500 200 immat 'exit "SALIR" immbtn
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	drop
	;
	
	
|-------------------------------------
:main
	"velocicracia" 1024 600 SDLinit

	"r3/gamejamd/velocicracia/mesa.png" loadimg 'sprmesa !
	196 170 "r3/gamejamd/velocicracia/mafalda.png" ssload 'sprmafalda !
	179 375 "r3/gamejamd/velocicracia/Patoruzito.png" ssload 'sprpatoru !
	163 199 "r3/gamejamd/velocicracia/matias.png" ssload 'sprmatias !
	150 249 "r3/gamejamd/velocicracia/Hijitus.png" ssload 'sprhijitus !

	90 140  "r3/gamejamd/velocicracia/boletas.png" ssload 'sprboletas !
	
	"r3/gamejamd/velocicracia/sonido naipes.mp3" mix_loadWAV 'sndnaipe !
	
	"r3/gamejamd/velocicracia/quino.otf" 50 TTF_OpenFont 'font ! 
	font immSDL 
	timer<
	$7f vaini
	100 'listfx p.ini
	100 'listbol p.ini
	
|	jugar
	'menu SDLShow

	SDLquit ;	
	
: main ;

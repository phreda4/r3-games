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
#sprfinal
#sprfinalm
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
#colores $E51B20 $347BBE $F3D611 $684495
#tiempoclick
#colorclick
#msclick 3000

#puntos 
#vidas

:vidascora	
	0 ( 3 <?
		dup 68 * 380 + 520 
		pick2 vidas - 63 >> $1 and
		sprvida ssprite
		1 + ) drop ;
	
:newcolor
	4 randmax 'colorclick !
	msclick 'tiempoclick !
	;

:xygui
	xr2 xr1 + 1 >> 16 << 
	yr2 yr1 + 1 >> 16 << ;
	
:clickc | color --
	dup >a
	2 2 0.5 800.0 200.0 xygui a> +boleta 
	colorclick =? ( drop 1 'puntos +! ; ) drop
	-1 'vidas +! 
	vidas 0? ( exit ) drop
	;

:barratiempo
	'colores colorclick ncell+ @ SDLColor
	317 42 
	390 tiempoclick msclick */
	32 SDLFRect
	317 34 sprbarra SDLImage
	deltatime neg 'tiempoclick +!
	tiempoclick 0 <? ( newcolor ) drop
	;

#ojos
	
:jueces	
	200 280
	ojos 9 >> $1 and
	sprmafalda ssprite
	
	400 250
	ojos 10 >> $1 and
	sprpatoru ssprite
	
	570 280
	ojos 11 >> $1 and
	sprmatias ssprite
	
	740 280
	ojos 12 >> $1 and
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
	200 360 immat [ 0 clickc ; ] immzone 
	|$ff SDLColor plxywh SDLRect 
	380 360 immat [ 1 clickc ; ] immzone 
	|$ff00 SDLColor plxywh SDLRect 
	560 360 immat [ 2 clickc ; ] immzone 
	|$ff0000 SDLColor plxywh SDLRect 
	690 360 immat [ 3 clickc ; ] immzone 
	|$ff00ff SDLColor plxywh SDLRect 
	
	80 100 immbox
	$0 'immcolortex !
	815 60 immat
	puntos "%d" immlabelC 
|	immdn vidas "%d" immlabelC immdn

	'listbol p.draw
	'listfx p.draw
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
|	<f1> =? ( newcolor )
	drop ;

:finjuego
	$0 SDLcls
	Immgui timer.
|	'estrellas p.draw

	0 50 immat
	800 immwidth
	"Fin de Juego" immlabelc
	immdn immdn
	
	puntos "%d Puntos" immlabelc

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
	'listfx p.clear
	'listbol p.clear
	0 'puntos !
	3 'vidas !
	newcolor
	'juego SDLShow 
	;

|-------------------------------------
#txt1 "PERDISTE ¿ NO VOTASTE BIEN ?..."
#txt2 "¡NO TENGO PORQUE OBEDECER A NADIE, YO SOY UN SER LIBRE!"
#txt3 "POR SUERTE EN LA VIDA REAL NADIE TE APURA, NADIE TE OBLIGA. UNO ELIGE A QUIEN VOTAR."
#ntxt 'txt1 'txt2 'txt3
#srctxt>
#txt * 256
#txt> 'txt

:>title
	srctxt> c@+ swap 'srctxt> !
	0? ( drop vareset 'exit 1.0 +vexe ; )
	txt> c!+ 0 over c! 'txt> !
	;
	
:>>title
	srctxt> txt> strcpy
	vareset 'exit 0.3 +vexe ;
	
:nextcar
	vareset
	'>title 0.0 +vexe
	'nextcar 0.002 +vexe
	;

:findj
	vupdate
	$ffffff sdlcls
	immgui
	0 0 sprfinal SDLImage

	$11 puntos "Puntaje: %d" sprint
	100 30 824 100 xywh64 
	0 font textbox | $vh str box color font --	
	
	$01 'txt
	100 30 824 400 xywh64 
	0 font textbox | $vh str box color font --	
	
	700 400
	pick3
	sprfinalm ssprite
	
	SDLredraw
	SDLkey
	>esc< =? ( >>title )
|	<f1> =? ( >title )
	drop
	;

:blink
	msec $100 and? ( drop $ffffff ; ) drop 0 ;
	
:espera
	immgui
	320 immwidth
	$7f00 'immcolorbtn !
	
	blink 'immcolortex !
	330 540 immat 'exit "CONTINUAR" immbtn
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop ;
	
:findejuego	
	0 ( 3 <?
		'ntxt over ncell+ @ 'srctxt> !
		'txt 'txt> ! 0 'txt c!
		nextcar
		'findj SDLshow
		1 + ) drop 
	'espera SDLShow
	;

|-------------------------------------
#texto 
"VELOCICRACIA" 
""
"Gamejam Democracia 2023"
"EEMN 1 - San cayetano"
"Ininerario formativo en informatica"
""
"Integrantes:"
"a"
"b"
"b"

#clinea 9
#hlinea 7
#nlinea	
#ys 0
#yh 100

:linestr | nro -- ""
	-? ( drop "" ; )
	clinea >=? ( drop "" ; )
	'texto swap n>>0 ;

:printline | ynow nro str -- ynow nro

|... center 1024,yh
	ttsize | w h 
	yh swap - 1 >> pick4 + swap
	1024 swap - 1 >> swap ttat
	
	tt. ;
	
:animc
	vareset
	'ys yh neg 0 0 2.0 0 +vanim
	[ nlinea 1 + clinea >=? ( hlinea neg nip ) 'nlinea ! animc ; ] 2.0 +vexe
	0 'ys ! 
	;
	
:drawlines
	ys 0 ( hlinea <? 
		nlinea over + linestr printline
		1 + swap yh + swap ) 2drop ;
	
:screditos
	vupdate
	$ffffff sdlcls
	$0 ttcolor
	drawlines
	
	0 0 sprfinal SDLImage
	
	

	
	SDLredraw	
	SDLkey
	>esc< =? ( exit )
	drop ;
	
:creditos	
	animc
	hlinea neg 'nlinea !
	'screditos SDLShow
	;
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
	
|	1024 immwidth
|	$0 'immcolortex !
|	0 50 immat "Click'o Cracia" immlabelc
	
	$ffffff 'immcolortex !
	220 immwidth
	$7f7f00 'immcolorbtn !
	140 540 immat 'creditos "CREDITOS" immbtn
	
	$7f00 'immcolorbtn !
	380 540 immat 'menuj "JUGAR" immbtn
	
	$7f0000 'immcolorbtn !
	620 540 immat 'exit "SALIR" immbtn

	$11 'textoinicio
	50 150 924 400 xywh64 
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
	90 140  "r3/gamejamd/velocicracia/boletas.png" ssload 'sprboletas !

	"r3/gamejamd/velocicracia/final.png" loadimg 'sprfinal !
	260 280 "r3/gamejamd/velocicracia/mafaldafin.png" ssload 'sprfinalm !
	
	"r3/gamejamd/velocicracia/sonido naipes.mp3" mix_loadWAV 'sndnaipe !
	
	"r3/gamejamd/velocicracia/quino.otf" 50 TTF_OpenFont 'font ! 
	font immSDL 
	timer<
	$ff vaini
	100 'listfx p.ini
	200 'listbol p.ini
	
||	jugar
	menuani
	'menu SDLShow
|	findejuego
	
	SDLquit ;	
	
: main ;

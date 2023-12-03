| Fraudecracia
| Democracia Gamejam 2023
| EESN 1 - San Cayetano
| PHREDA
|-----
^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/util/arr16.r3
^r3/util/sdlgui.r3
^r3/util/varanim.r3

#font

#imgfondo
#imgmesa
#imgmanos
#imgurna
#imgsaco
#imgtacho
#imgburtext

#sprsupervisor
#sprboletas

#places 0 0

#mipartido 0
#pideboleta 0

| x y rz n ss vx vy vr
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.rz 3 ncell+ ;
:.n 4 ncell+ ;
:.ss 5 ncell+ ;
:.vx 6 ncell+ ;
:.vy 7 ncell+ ;
|:.vr 8 ncell+ ;

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@+ a@+ sspriterz
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	|dup .vr @ over .rz +!
	;
	
:guiRectS | adr -- adr
	dup .x @ int. 25 -
	over .y @ int. 40 - | x y
	over 50 + over 80 +
	guiRect
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
	
	dup .n @ $ffffffffff and | timenow
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

	
|------------
:+boletam | easex easey et x2 y2 x1 y1 n --
	'objspritemove 'places p!+ >a 
	pick2 a!+ over a!+ 1.0 a!+ 52 << a!+ sprboletas a!+
	swap a!+ a!+
	swap a!+ a!+
	1000 *. $ffffffff and 
	rot 32 << or swap 40 << or
	a!+
	;	
	
|--------------------	
:xygui
	xr2 xr1 + 1 >> 16 << 
	yr2 yr1 + 1 >> 16 << ;
	
:abasura
	a@ 4 =? ( drop ; ) >a
	27 27 1.0 100.0 490.0 xygui a> +boletam | easex easey et x2 y2 x1 y1 n --
	;
	
:clickenplace
	clkbtn 4 =? ( drop abasura ; ) drop
	a@ 4 =? ( mipartido nip ) >a
	27 27 1.0 800.0 200.0 xygui a> +boletam | easex easey et x2 y2 x1 y1 n --
	;
	
:place
	$ff00ff sdlcolor
	dup 8 + >a
	a@+ a@+ a@+ a@+ 
	2over 2over SDLRect
	guiBox
	'clickenplace onClick
	drop
	;
	
:+place | n w h x y --
	'place 'places p!+ >a 
	swap a!+ a!+	| x y 
	swap a!+ a!+	| w h
	a!+	| tipo
	;
	
|--------------------
#supere 0
:super
	700 140 supere sprsupervisor ssprite 
	300 0 imgburtext SDLImage
	450 130 pideboleta sprboletas ssprite
	70 randmax 1? ( drop ; ) drop
	supere 1 xor 'supere !
	;

:pantalla
	super
	0 0 imgmesa SDLImage
	800 160 imgurna SDLImage
	640 450 imgsaco SDLImage
	90 390 imgtacho SDLImage
	;
	
|--------------------	
:resetjuego
	'places p.clear
	0 120 160 90 280 +place
	1 120 160 240 280 +place
	2 120 160 410 280 +place
	3 120 160 590 280 +place
	
	4 200 200 640 450 +place
	;

:manocursor
	sdlx 10 - sdly 10 - imgmanos SDLimage
	;
	
:juego
	vupdate timer.
	immgui 
|	0 0 imgfondo SDLImage 	
	$666666 sdlcls
	pantalla
	'places p.drawo
	manocursor
	
|	$ffffff ttcolor 20 10 ttat 
|	sdlb "%h" ttprint
	
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
	drop ;

|--------------------	
:finjuego
	$0 SDLcls
	Immgui timer.

	800 immwidth
	112 50 immat
	"Fin de Juego" immlabelc
	immdn immdn
	
|	puntos "%d Puntos" immlabelc

	400 immwidth
	312 500 immat
	$7f 'immcolorbtn !
	'exit "Continuar" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop
	;

:jugar
	resetjuego
	'juego SDLshow
	'finjuego SDLShow
	;
	
|----------------------------------------
#txtpartido
"Juntos por el mambo"
"La esclavitud avanza"
"Frente al caño"
"Union ezquimal"

#cursor

:menu
	0 sdlcls
	immgui
	
	1024 immwidth
	$ffffff 'immcolortex !
	0 50 immat "Fraudecracia" immlabelc
	immdn immdn
	'txtpartido mipartido n>>0 immlabelc

	$ffffff sdlcolor
	msec 4 >> $f and 'cursor !
	mipartido 150 * 230 + cursor - 310 cursor - 
	130 cursor 1 << + 150 cursor 1 << + SDLRect
	
	130 150 immbox
	0 ( 4 <?
		150 over * 295 + 385 
		pick2 sprboletas ssprite
		150 over * 230 + 310 immat
		[ dup 'mipartido ! ; ] immzone
		1 + ) drop
		
	
	200 60 immbox
	$7f00 'immcolorbtn !
	200 500 immat 'jugar "JUGAR" immbtn
	
	$7f0000 'immcolorbtn !
	640 500 immat 'exit "SALIR" immbtn
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	drop
	;
	
|------------ INICIO ----------------	
:	
	"Fraudecracia" 1024 600 SDLinit
	"r3/gamejamd/fraudecracia/fondo.png" loadimg 'imgfondo !
	"r3/gamejamd/fraudecracia/mesa.png" loadimg 'imgmesa !
	"r3/gamejamd/fraudecracia/urna.png" loadimg 'imgurna !
	"r3/gamejamd/fraudecracia/saco.png" loadimg 'imgsaco !
	"r3/gamejamd/fraudecracia/tacho.png" loadimg 'imgtacho !
	"r3/gamejamd/fraudecracia/cursor.png" loadimg 'imgmanos !
	"r3/gamejamd/fraudecracia/burtext.png" loadimg 'imgburtext !
	90 140 "r3/gamejamd/fraudecracia/boletas.png" ssload 'sprboletas !
	289 300 "r3/gamejamd/fraudecracia/supervisor.png" ssload 'sprsupervisor !	
	
	"media/ttf/Roboto-Medium.ttf" 40 TTF_OpenFont 'font ! 
	font immSDL
	$ff vaini
	vareset timer<
	40 'places p.ini

	'menu SDLshow
|	jugar
	SDLquit 
	;

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

#fondo
#mesa

#supervisor
#boletas
#manos
#urna
#saco
#tacho

#places 0 0

#mipartido 0

| x y rz n ss vx vy vr
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.rz 3 ncell+ ;
:.n 4 ncell+ ;
:.ss 5 ncell+ ;
:.vx 6 ncell+ ;
:.vy 7 ncell+ ;
:.vr 8 ncell+ ;

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@+ a@+ sspriterz
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	dup .vr @ over .rz +!
	;
	
:guiRectS | adr -- adr
	dup .x @ int. 25 -
	over .y @ int. 40 - | x y
	over 50 + over 80 +
	guiRect
	;
	
|--------------------	
#xu 800 #yu 200 | urna

:boleta
	objsprite
	xu over .x @ int. - 13 << over .x +!
	yu over .y @ int. - 13 << over .y +!
	
	dup .x @ int. xu - dup *
	over .y @ int. yu - dup * +
	0? ( nip ; ) 
	2drop
	;

#xb 100 #yb 490 | basura

:boletab
	objsprite
	xb over .x @ int. - 13 << over .x +!
	yb over .y @ int. - 13 << over .y +!
	
	dup .x @ int. xb - dup *
	over .y @ int. yb - dup * +
	0? ( nip ; ) 
	2drop
	;
	
:+boleta | n x y 'accion --
	'places p!+ >a
	swap a!+ a!+ 1.0 a!+ a!+ boletas a!+
	;
	
|--------------------	
:xygui
	xr2 xr1 + 1 >> 16 << 
	yr2 yr1 + 1 >> 16 << ;
	
:abasura
	a@ 4 =? ( drop ; ) 
	xygui 'boletab +boleta ;
	
:clickenplace
	clkbtn 4 =? ( drop abasura ; ) drop
	a@ 4 =? ( mipartido nip ) 
	xygui 'boleta +boleta ;
	
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
	700 140 supere supervisor ssprite 
	70 randmax 1? ( drop ; ) drop
	supere 1 xor 'supere !
	;

:pantalla
	super
	0 100 mesa SDLImage
	800 160 urna SDLImage
	640 450 saco SDLImage
	
	90 390 tacho SDLImage
	;
	
|--------------------	
:resetjuego
	'places p.clear
	0 90 150 151 250 +place
	1 90 150 281 250 +place
	2 90 150 412 250 +place
	3 90 150 548 250 +place
	
	4 200 200 640 450 +place
	
	;

:manocursor
	sdlx sdly
	sdlb 1? ( 1 nip )
	manos ssprite
	;
	
:game
	vupdate
	immgui 
|	0 0 fondo SDLImage 	
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

|------------ INICIO ----------------	
:	
	"Fraudecracia" 1024 600 SDLinit
	"r3/gamejamd/fraudecracia/fondo.png" loadimg 'fondo !
	"r3/gamejamd/fraudecracia/mesa.png" loadimg 'mesa !
	"r3/gamejamd/fraudecracia/urna.png" loadimg 'urna !
	"r3/gamejamd/fraudecracia/saco.png" loadimg 'saco !
	"r3/gamejamd/fraudecracia/tacho.png" loadimg 'tacho !
	90 140 "r3/gamejamd/fraudecracia/boletas.png" ssload 'boletas !
	120 120 "r3/gamejamd/fraudecracia/manos.png" ssload 'manos !
	289 300 "r3/gamejamd/fraudecracia/supervisor.png" ssload 'supervisor !	
	
	"media/ttf/Roboto-Medium.ttf" 40 TTF_OpenFont 'font ! 
	font immSDL
	$ff vaini
	vareset
	40 'places p.ini
	resetjuego
	'game SDLshow
	SDLquit 
	;

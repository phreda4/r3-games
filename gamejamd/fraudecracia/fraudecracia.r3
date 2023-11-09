| Cards
| PHREDA 2023
^r3/win/sdl2gfx.r3
^r3/util/arr16.r3
^r3/lib/gui.r3
^r3/lib/rand.r3

#fondo
#sprites
#places 0 0

#mipartido 0

:objsprite | adr -- adr
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@+ a@+ sspriterz
	dup 40 + @ over +!
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	;

	
:guiRectS | adr -- adr
	dup @+ int. 25 -
	swap @ int. 40 - | x y
	over 50 + over 80 +
	guiRect
	;
	
	
#accion	
#xa #ya

:mvcard | adr -- adr 
	sdlx xa - 16 << over +! 
	sdly ya - 16 << over 8 + +! 
:setcard	
	sdlx 'xa ! sdly 'ya ! ;
	
:dncard	
	dup @+ int. swap @ int. | x y
	over 170 - abs over 590 - abs distfast 80 <? ( [ 0 rot rot ; ] 'accion ! ) drop
	swap 800 - abs swap 160 - abs distfast 70 <? ( [ 0 rot rot ; ] 'accion ! ) drop
	;
	
:carta
	0 'accion !
	objsprite
	guiRectS
	|'setcard 'mvcard onDnMoveA
	'setcard 'mvcard 'dncard onMapA
	accion 1? ( dup ex ) drop
	drop
	;

:+card	| n y x --
	'carta 'places p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+			| zoom|ang 
	a!+				| n
	sprites a!+ 	| sprite
	;

|--------------------	
:nuevatarjeta
	a@ 4 =? ( mipartido nip )
	xr2 xr1 + 1 >> 16 << 
	yr2 yr1 + 1 >> 16 << +card
	;
	
:place
	$ff00ff sdlcolor
	dup >a
	a@+ a@+ a@+ a@+ 
|	2over 2over SDLRect
	guiBox
	'nuevatarjeta onClick
	drop
	;
	
:+place | n w h x y --
	'place 'places p!+ >a 
	swap a!+ a!+	| x y 
	swap a!+ a!+	| w h
	a!+
	;
	
|--------------------	
:resetjuego
	'places p.clear
	0 80 110 151 188 +place
	1 80 110 281 188 +place
	2 80 110 412 188 +place
	3 80 110 548 188 +place
	
	4 220 120 700 470 +place
	
	;
	
:game
	gui
	0 0 fondo SDLImage 	
	|$66 sdlcls
	'places p.draw
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
	drop ;
	
:	
	"Fraudecracia" 1024 600 SDLinit
	"r3/gamejamd/fraudecracia/fondo.png" loadimg 'fondo !
	94 143 "r3/gamejamd/fraudecracia/boletas.png" ssload 'sprites !
	40 'places p.ini
	resetjuego
	'game SDLshow
	SDLquit 
	;

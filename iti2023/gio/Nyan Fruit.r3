| Animation example
^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/arr16.r3
^r3/win/sdl2mixer.r3
^r3/util/sdlgui.r3

#arcoiris 0 0 
#frutas 0 0
#estrellas 0 0

#sndcomiento
#sndnocome
#sndburbuja
#musmenu
#musjuego

#tsguy	| dibujo
#xp 300.0 #yp 400.0		| posicion
|#xv #yv		| velocidad
#animacion
#comiendo

#puntos 0
#vidas 0

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n			| n
	a@+ sspriterz
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	dup 64 + @ over 24 + +!
	;

:objframe | adr -- frame
	32 + @ anim>n ;
	
:gatovuela
	6 6 $3f ICS>anim | init cnt scale -- val
	'animacion !	;
	
:gatocome
	comiendo 1? ( drop ; ) drop
	60 'comiendo !
	12 7 $3f ICS>anim | init cnt scale -- val
	'animacion ! ; | 7

:gatonocome
	comiendo 1? ( drop ; ) drop	
	60 'comiendo !
	19 2 $3f ICS>anim | init cnt scale -- val
	'animacion ! ; | 7
	
|--------------- ARCOIRIS	
|disparo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:estela | v -- 
	objsprite
	|..... remove when outside screen
	dup 8 + @+ dup -17.0 827.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	2drop
	drop
	;

#colorestela 0
#alterna 
:+estela
	'estela 'arcoiris p!+ >a 
	260.0 a!+ yp 10.0 + alterna + a!+	| x y 
	1.0 a!+	| ang zoom
	colorestela 0 $3f ICS>anim | init cnt scale -- val
	a!+	tsguy a!+			| anim sheet
	-2.0 a!+ 0.0 a!+ 	| vx vy
	0 a!			| vrz
	alterna 0? ( drop 4.0 'alterna ! ; ) drop
	0 'alterna !
	;
	
#ce
:+est
	1 'ce +!
	ce 7 <? ( drop ; ) drop
	0 'ce !
	+estela ;


#listframe ( 1 0 0 5 2 3 4 )

:nocomefruta
	gatonocome
	sndnocome sndplay	
	-1 'vidas +!
	vidas 0? ( exit ) drop
	;
	
:comefruta | adr -- 0
	objframe
	21 - 'listframe + c@
	colorestela 0? ( drop dup )
	<>? ( drop nocomefruta 0 ; ) drop
	gatocome 1 'puntos +!
	sndcomiento sndplay
	( 6 randmax colorestela =? drop )
	'colorestela !
	0
	;
	
|--------------- FRUTAS
:fruta | v -- 
	objsprite
	|..... remove when outside screen
	dup 8 + @+ dup -17.0 827.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	45.0 <? ( drop comefruta ; ) 2drop ;

:+fruta | fruta y --
	'fruta 'frutas p!+ >a 
	810.0 a!+
	a!+	| x y 
	1.0 a!+	| ang zoom
	0 $3f ICS>anim | init cnt scale -- val	
	a!+	tsguy a!+			| anim sheet
	1.0 randmax neg 1.5 - a!+
	0
	a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!			| vrz
	sndburbuja sndplay
	;

	
:+frutarand
	'fruta 'frutas p!+ >a 
	810.0 a!+
	500.0 randmax 100.0 +
	a!+	| x y 
	1.0 a!+	| ang zoom
	8 randmax 21 + | 16
	0 0 ICS>anim | init cnt scale -- val
	a!+	tsguy a!+			| anim sheet
	1.0 randmax neg 1.5 - a!+
	2.0 randmax 1.0 - a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!			| vrz
	;
	
:+fru
	100 randmax 
	0? ( +frutarand )
	drop
	;
	
|-------------------------- estrellas
:estrella | v -- 
	objsprite
	dup 8 + @ -30.0 <? ( drop 830.0 swap 8 + ! ; ) 
	2drop ; 
	
:+estrella 
	'estrella 'estrellas p!+ >a
	860.0 randmax 30.0 - a!+
	600.0 randmax a!+
	1.0 a!+
	29 3 $3f ICS>anim | init cnt scale -- val
	rand $fffffffff and or
	a!+
	tsguy a!+
	0.5 randmax 1.0 - a!+
	0 a!+ 
	0 a!+ ;

:planeta | v -- 
	objsprite
	dup 8 + @ -300.0 <? ( drop 1100.0 swap 8 + ! ; ) 2drop 
|	8 + dup @ 
|	-60.0 <? ( drop 660.0 swap ! ; ) 
|	660 >? ( drop -60.0 swap ! ; ) 
|	2drop
	; 
	
:+planeta | n --
	'planeta 'estrellas p!+ >a
	1400.0 randmax 300.0 - a!+
	600.0 randmax a!+
	1.0 a!+
	0 $3f ICS>anim | init cnt scale -- val 
	rand $fffffffff and or
	a!+
	tsguy a!+
	0.5 randmax 0.8 - a!+
	0.25 randmax 0.125 - a!+ 
	0 a!+ ;
	
|--------------- JUEGO	
:jugador

	xp int. yp int. 2.0 
	animacion timer+ dup 'animacion ! anim>n 
	tsguy sspritez	
|	xv 'xp +! yv 'yp +!
	msec 4 << sin 250 * 300.0 + 'yp !

	comiendo 0? ( drop ; ) 
	1 -
	0? ( gatovuela )
	'comiendo !
	;

:puntaje
	$000000 ttcolor 14 14 ttat vidas "%d vidas" ttprint
	$FFFFFF ttcolor 10 10 ttat vidas "%d vidas" ttprint

	$000000 ttcolor 514 14 ttat puntos "%d puntos" ttprint
	$FFFFFF ttcolor 510 10 ttat puntos "%d puntos" ttprint
	;
	
:canios	
	740 100 2.0 42 tsguy sspritez | naranja
	740 200 2.0 39 tsguy sspritez | rojo
	740 300 2.0 40 tsguy sspritez | amarillo
	740 400 2.0 41 tsguy sspritez | violeta
	740 500 2.0 43 tsguy sspritez | verde
	;
	
:juego
	$252850 SDLcls
	timer.
	'estrellas p.draw
	'arcoiris p.draw	
	jugador
	'frutas p.draw
	
	canios
	puntaje
	SDLredraw

	+est
|	+fru
		
	SDLkey
	>esc< =? ( exit )
	<a> =? ( 21 100.0 +fruta ) 
	<s> =? ( 25 200.0 +fruta ) 
	<d>  =? ( 26 300.0 +fruta ) 
	<f> =? ( 27 400.0 +fruta ) 
	<g> =? ( 24 500.0 +fruta ) 
	
|	<1> =? ( 0 'colorestela ! )
|	<2> =? ( 1 'colorestela ! )
|	<3> =? ( 2 'colorestela ! )
|	<4> =? ( 3 'colorestela ! )
|	<5> =? ( 4 'colorestela ! )
|	<6> =? ( 5 'colorestela ! )
	
	drop 
	;
	

:juegoreset
	'arcoiris p.clear
	'frutas p.clear
	timer<
	6 3 $3f ICS>anim | init cnt scale -- val
	'animacion !
	0 'puntos !
	7 'vidas !
	0 'colorestela !
	;

:finjuego
	$252850 SDLcls
	Immgui timer.
	'estrellas p.draw

	0 50 immat
	800 immwidth
	"Nyan Fruit" immlabelc
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
	juegoreset
	|Mix_HaltMusic
|	32 Mix_VolumeMusic 	
|	musjuego -1 mix_playmusic
	
	'juego SDLshow
|	Mix_HaltMusic
|	128 Mix_VolumeMusic 
|	musmenu -1 mix_playmusic 
	'finjuego SDLShow
	;

:resetmenu
	100 ( 1? +estrella 1 - ) drop
	5 ( 1? dup 32 + +planeta 1 - ) drop	
	;

:menu
	$252850 SDLcls
	Immgui
	timer.
	'estrellas p.draw

	0 100 immat
	800 immwidth
	"Nyan Fruit" immlabelc

	200 300 immat
	400 immwidth
	$7f00 'immcolorbtn !
	'jugar "jugar" immbtn
	immdn
	$7f0000 'immcolorbtn !
	'exit "salir" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	drop
	;

	
:main
	"r3sdl" 800 600 SDLinit
	|sdlfull
	64 64 "r3/iti2023/gio/gato.png" ssload 'tsguy !
	"r3/iti2023/gio/Starborn.ttf" 38 ttf_OpenFont immsdL
	"r3/iti2023/gio/comiendo.mp3" mix_loadwav 'sndcomiento !
	"r3/iti2023/gio/nocome.mp3" mix_loadwav 'sndnocome !
	"r3/iti2023/gio/burbuja.mp3" mix_loadwav 'sndburbuja !
	"r3/iti2023/gio/Gatito kawaii.mp3" mix_loadmus 'musmenu !
	"r3/iti2023/gio/Nyan Cat.mp3" mix_loadmus 'musjuego !
	50 'arcoiris p.ini
	200 'frutas p.ini
	120 'estrellas p.ini
|	musmenu -1 mix_playmusic
	resetmenu
	'menu SDLshow
	SDLquit ;	
	
: main ;
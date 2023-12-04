| Openheimer democracy
| Democracia Gamejam 2023
| EESN 1 - San Cayetano
| PHREDA
|-----^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/varanim.r3
^r3/util/boxtext.r3
^r3/lib/color.r3
^r3/util/sdlgui.r3

#font

#spravion
#sprbomba
#sprnubes		
#sprhumo		
#sprexplo
#sprcasa 0 0 0 0

#sndbomba
#sndgente
#sndexplo
#sndvictoria

#x #y 
#maxbombas 20
#puntos
#bombas

#listbom 0 0	| lista de disparos
#listedi 0 0	| lista de edificios
#listfx 0 0 	| fx

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
	a@+ dup 32 >> swap $ffffffff and 	| rota zoom
	a@ timer+ dup a!+ 	| anima
	nanim a@+ sspriterz
	dup .vx @ over .x +!	| vx
	dup .vy @ over .y +!	| vy
	;

|--------------- fx	
:nube
	objsprite
	dup .x @ -400.0 <? ( 1400.0 pick2 .x ! ) drop
	dup .y @ 200.0 - abs 200.0 >? ( over .vy dup @ neg swap ! ) drop | 200..500
	drop
	;

:+nube	| vx vy n z x y --
	'nube 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	a!+ 
	52 << a!+ sprnubes a!+
	swap a!+ a!+ ;

:cielo
	50 ( 1? 1 -
		0.5 randmax 0.6 -
		0.1 randmax 0.05 -
		|2 randmax 
		0
		0.5 randmax 0.6 + 
		1800.0 randmax 400.0 -
		400.0 randmax 
		+nube
		) drop ;		
	
|----------------------	
:humo
	objsprite
	dup .x @ -100.0 <? ( 2drop 0 ; ) drop
	-0.01 over .vx +!
	0.001 32 << over .r +!
	drop
	;
	
:+humo | x y --
	'humo 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 randmax a!+ 0 a!+ sprhumo a!+
	-1.0 a!+ 
	-0.9 a!+ ;

:ohumo
	dup .vx @ over .x +!	| vx
	dup .x @ -100.0 <? ( 2drop 0 ; ) drop
	10 randmax 0? ( over .x @ pick2 .y @ +humo ) drop
	drop
	;
	
:+ohumo | x y --
	'ohumo 'listfx p!+ >a 
	swap a!+ 10.0 + a!+	| x y 
	1.0 a!+ 0 a!+ sprhumo a!+
	-1.0 a!+ 
	0 a!+ ;
	
|----------------------
:edi | a -- a
	objsprite
	dup .x @ -100.0 <? ( 2drop 0 ; ) drop
	drop ;
	
:+edificio | vx vy n z x y --
	'edi 'listedi p!+ >a 
	swap a!+ a!+	| x y 
	a!+ 52 << a!+ 	| w h
	4 randmax 3 << 'sprcasa + @
	a!+
	swap a!+ a!+ ;	| vx vy

#distedi
:edificios
	1 'distedi +!
	distedi 50 <? ( drop ; ) drop
	50 randmax 1? ( drop ; ) drop
	0 'distedi !
	-1.0 0 
	0 
	0.4 randmax 0.6 + | zoom
	1200.0 
	20.0 randmax 560.0 +
	+edificio
	;
	
|-------------- Explosion		
:nuke
	objsprite
	dup .a @ canim 25 =? ( 2drop 0 ; )
	2drop
	;
	
:+explo | x y --
	'nuke 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+ 
	6 26 0 vci>anim a!+ sprexplo a!+
	-1.0 a!+ -0.1 a!+
	|sndexplo SNDPlay
	;
		

|-------------- Disparo	
#hit?
:hit | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 
	60.0 >? ( drop ; )	drop	| lejos
	dup .a dup
	@ 52 >> $1 and? ( 2drop ; )  | ya roto
	1 + 52 << swap !			| cambia dibujo
	1 'puntos +!
	1 'hit? !
	dup .x @ over .y @ +ohumo
|	10 randmax 1? ( drop ; ) drop
|	sndgente SNDplay | grito de gente
	;
	
:bomba | v -- 
	objsprite
	0.02 over .vy +!		| gravedad
	0.001 32 << over .r +!		| rotacion
	20 randmax 0? ( over .a dup @ $10000000000000 xor swap ! ) drop
	dup .x @ over .y @ 700.0 >? ( 100.0 - +explo drop 0 ; ) 
	0 'hit? !
	'hit 'listedi p.mapv		| choco con edificio
	hit? 1? ( drop +explo drop 0 ; ) drop
	2drop
	drop
	;

#disparodelay

:+disparo
	disparodelay -? ( drop ; ) drop
	-200 'disparodelay ! |200 ms delay
	bombas 0? ( drop ; ) drop
	'bomba 'listbom p!+ >a 
	x 30.0 + a!+ y 40.0 + a!+	| x y 
	1.0 a!+ 0 a!+
	sprbomba a!+			|
	0 a!+ 0.02 a!+ 	| vx vy
	sndbomba SNDplay
	-1 'bombas +!
	;

:randwind
	vareset
	'x 400.0 randmax 300.0 + x 9 2.0 0.0 +vanim
	'y 200.0 randmax 50.0 + y 9 2.0 0.0 +vanim
	'randwind 2.0 +vexe ;
	
:startwind
	vareset
	'x 550.0 -500.0 3 3.0 0.0 +vanim 
	'y 220.0 -100.0 3 3.0 0.0 +vanim 
	'randwind 3.0 +vexe ;

:endwind
	vareset
	'x 1250.0 x 3 3.0 1.0 +vanim 
	'y -100.0 y 3 3.0 1.0 +vanim 
	'exit 5.0 +vexe ;

|-------------- Jugador
#findejuego
#xant
#xprom
#ojos 0

:angulo
	x xant =? ( drop ; ) 
	xant - xprom + 1 >> 'xprom ! x 'xant ! ;

:jugador
	x int. y int. xprom 8 >> ojos spravion sspriter
	x int. y int. xprom 8 >> 3 randmax 2 + spravion sspriter
	angulo
	findejuego 1? ( drop ; ) drop
	bombas 0? ( 1 'findejuego ! endwind ) drop 
	40 randmax 0? ( ojos 1 xor 'ojos ! ) drop
	;
	
:hud
	$ffffff ttcolor 
	20 10 ttat bombas "%d" ttprint
	920 10 ttat puntos "%d" ttprint
	;
	
|-------------- Juego
:juego
	immgui 
	timer. vupdate
	deltatime 'disparodelay +!
	$59BEE6 SDLcls
	'listedi p.drawo
	'listfx p.draw
	'listbom p.draw	
	jugador	
	edificios
	hud
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
	<esp> =? ( +disparo )
	drop ;


:finjuego
	$59BEE6 SDLcls
	Immgui timer.
	'listedi p.drawo
	'listfx p.draw
	
	800 immwidth
	112 50 immat
	"Fin de Juego" immlabelc
	immdn immdn
	puntos 100 maxbombas */ "%d%% de Democracia" immlabelc

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
	'listbom p.clear
	'listedi p.clear
	0 'puntos ! 
	maxbombas 'bombas !
	0 'findejuego !
	startwind |	randwind
	timer<
	'juego SDLShow 
	'finjuego SDLShow
	;

|-------------------------------------
:menu
	vupdate 
	$59BEE6 SDLcls
	immgui
	
	'listfx p.draw
	
	824 immwidth
	100 120 immat
	"Oppenheimer Democracy" immlabelc

	340 immwidth
	100 460 immat
	$7f00 'immcolorbtn !
	'jugar "Jugar" immbtn
	1024 440 - 460 immat
	$7f0000 'immcolorbtn !
	'exit "Salir" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	drop
	;
	
|-------------------------------------
#texto>
#texto 
"The world need" 
"more democracy"
" "
"don't worry"
"we have democracy for all"
" "
|"Oppenheimer Democracy"
0

:nextt texto> >>0 'texto> ! ;

#colm
#t	
:lines | texto --
	dup 'texto> !
	$ff 'colm !
	vareset
	1.0 't !
	l0count 
	0 ( over <? 
		'colm 0 $ff 5 1.0 t +vanim
		'colm $ff 0 5 1.0 t 2.0 + +vanim
		'nextt t 3.0 + +vexe
		3.0 't +!
		1 + ) 2drop 
	'exit t 1.0 + +vexe 		
	;

:titlestart
	vupdate
	$0 SDLcls
	
	$11 texto>
	300 100 424 400 xywh64 
	$ffffff $0 colm colmix
	font 
	textbox | $vh str box color font --

	SDLredraw	
	SDLkey
	>esc< =? ( exit )
	drop ;

|-------------------------------------
:main
	"od" 1024 600 SDLinit
	
	128 128 "r3/gamejamd/od/explosion.png" ssload 'sprexplo !
	50 20 "r3/gamejamd/od/bomba.png" ssload 'sprbomba !
	208 143 "r3/gamejamd/od/avion.png" ssload 'spravion !
	
	|247 184 "r3/gamejamd/od/nube.png" ssload 'sprnubes !
	71 48 "r3/gamejamd/od/nube1.png" ssload 'sprnubes !
	50 50 "r3/gamejamd/od/humo.png" 
	ssload 'sprhumo !

	'sprcasa 
	145 160 "r3/gamejamd/od/casa1.png" ssload swap !+
	110 126 "r3/gamejamd/od/casa2.png" ssload swap !+
	121 104 "r3/gamejamd/od/casa3.png" ssload swap !+
	204 137 "r3/gamejamd/od/casa4.png" ssload swap !
	
	"media/ttf/roboto-medium.ttf" 48 TTF_OpenFont 'font ! 
	font immSDL
	"r3/gamejamd/od/silbido.mp3" mix_loadWAV 'sndbomba !
	"r3/gamejamd/od/gente.mp3" mix_loadWAV 'sndgente !
	"r3/gamejamd/od/explosion.mp3" mix_loadWAV 'sndexplo !
	"r3/gamejamd/od/victoria.mp3" mix_loadWAV 'sndvictoria !
	$7f vaini
	100 'listbom p.ini
	100 'listedi p.ini
	500 'listfx p.ini
	timer<
	
	'texto lines
	'titlestart SDLshow
	'listfx p.clear
	cielo
	'menu SDLShow
	
	SDLquit ;	
	
: main ;

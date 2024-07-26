| Openheimer democracy
| Democracia Gamejam 2023
| EESN 1 - San Cayetano
| PHREDA
|-----
^r3/win/sdl2gfx.r3
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

#sndboton
#sndbomba
#sndexplo
#sndvictoria

|#musmenu
|#musjuego

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
	anim>N a@+ sspriterz
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
		0
		0.5 randmax 0.3 + 
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
	dup .a @ anim>c 25 =? ( 2drop 0 ; )
	2drop
	;
	
:+explo | x y --
	'nuke 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+ 
	0 26 $3f ICS>anim | init cnt scale -- val
	a!+ sprexplo a!+
	-1.0 a!+ -0.1 a!+
	sndexplo SNDPlay
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
	$0 ttcolor 
	24 14 ttat bombas "%d" ttprint
	924 14 ttat puntos "%d" ttprint
	$ffffff ttcolor 
	20 10 ttat bombas "%d" ttprint
	920 10 ttat puntos "%d" ttprint
	;
	
|-------------- Juego
:juego
	immgui 
	timer. vupdate
	disparodelay timer+ 'disparodelay !
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

|-------------- Pantallas
::immbtn | 'click "" -- ; reecode button
	plxywh guiBox
	immcolorbtn SDLColor plxywh SDLFRect
	[ 3 3 immat+ ; ] guiI 
	immlabelc
	[ sndboton SNDplay 400 SDL_delay dup ex ; ] onClick drop ;	

:finjuego
	$59BEE6 SDLcls
	Immgui timer.
	'listedi p.drawo
	'listfx p.draw
	
	800 immwidth
	$0 'immcolortex !	
	116 54 immat "Fin de Juego" immlabelc
	$ffffff 'immcolortex !	
	112 50 immat "Fin de Juego" immlabelc

	$0 'immcolortex !	
	116 234 immat
	puntos 100 maxbombas */ "    %d%% de Democracia" immlabelc
	$ffffff 'immcolortex !	
	112 230 immat
	puntos 100 maxbombas */ "    %d%% de Democracia" immlabelc

	400 immwidth
	312 450 immat
	$7f 'immcolorbtn !
	'exit "Continuar" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop
	;
	
:jugar 
|	Mix_HaltMusic
|	musjuego -1 mix_playmusic
	
	'listbom p.clear
	'listedi p.clear
	0 'puntos ! 
	maxbombas 'bombas !
	0 'findejuego !
	startwind |	randwind
	timer<
	'juego SDLShow 
|	Mix_HaltMusic
	sndvictoria SNDplay
	'finjuego SDLShow
|	musmenu -1 mix_playmusic
	;

|-------------------------------------
#texto 
"Oppenheimer Democracy" 
""
"Equipo de desarrollo"
""
"Bianca Cipollone"
"Brian Saenz Valiente"
"Braian Canal"
"Camila Pellegrini"
"Diogo Peñalba"
"Efrain Pardo"
"Enzo Piacquadio"
"Lucía Campos Hojsgaard"
"Felix Klink"
"Matias Keergaard"
"Naiara Baptista"
"Pierina Santillan"
""
"Profesores"
"Maria Clara Sorensen"
"Pablo Hugo Reda"
""
"Curso 3er Año"
"Itinirario formativo de"
"asistencia en informatica"
""
"EESN 1"
"San Cayetano"
"Buenos Aires"
""
"Democracia Gamejam"
""
"2023"

#clinea 32
#hlinea 10
#nlinea	
#ys 0
#yh 70

:linestr | nro -- ""
	-? ( drop "" ; )
	clinea >=? ( drop "" ; )
	'texto swap n>>0 ;

:printline | ynow nro str -- ynow nro
	ttsize | w h  |... center 1024,yh
	yh swap - 1 >> pick4 + swap
	1024 swap - 1 >> swap ttat
	tt. ;
	
:animc
	vareset
	'ys yh neg 0 0 0.5 0 +vanim
	[ nlinea 1 + clinea >=? ( hlinea neg 1 + nip ) 'nlinea ! animc ; ] 0.5 +vexe
	0 'ys ! 
	;
	
:drawlines
	ys 0 ( hlinea <? 
		nlinea over + linestr printline
		1 + swap yh + swap ) 2drop ;
	
:screditos
	vupdate
	immgui
	$0 sdlcls
	$ffffff ttcolor
	drawlines
	280 immwidth
	$7f0000 'immcolorbtn !
	720 50 immat 'exit "CONTINUAR..." immbtn	
	SDLredraw	
	SDLkey
	>esc< =? ( exit )
	drop ;
	
:creditos	
	animc
	hlinea neg 1 + 'nlinea !
	'screditos SDLShow
	;	
	
|-------------------------------------
:menu
	vupdate 
	$59BEE6 SDLcls
	immgui
	
	'listfx p.draw
	
	824 immwidth
	$0 'immcolortex !
	104 114 immat "OPPENHEIMER DEMOCRACY" immlabelc
	$ffffff 'immcolortex !
	100 110 immat "OPPENHEIMER DEMOCRACY" immlabelc

	$0 'immcolortex !
	104 254 immat "ESPACIO para MAS Democracia" immlabelc
	$ffffff 'immcolortex !
	100 250 immat "ESPACIO para MAS Democracia" immlabelc


	$ffffff 'immcolortex !
	240 immwidth
	$7f7f00 'immcolorbtn !
	120 450 immat 'creditos "CREDITOS" immbtn
	
	$7f00 'immcolorbtn !
	380 450 immat 'jugar "JUGAR" immbtn
	
	$7f0000 'immcolorbtn !
	640 450 immat 'exit "SALIR" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	drop
	;
	
|-------------------------------------
#texto>
#texto 
"THE WORLD NEED" 
"MORE DEMOCRACY"
" "
"DON'T WORRY"
"WE HAVE DEMOCRACY FOR ALL"
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
	>esc< =? ( vareset exit )
	drop ;

|-------------------------------------
:main
	"od" 1024 600 SDLinit
	
	128 128 "r3/gamejamd/od/explosion.png" ssload 'sprexplo !
	50 20 "r3/gamejamd/od/bomba.png" ssload 'sprbomba !
	208 143 "r3/gamejamd/od/avion.png" ssload 'spravion !
	
	247 184 "r3/gamejamd/od/nube.png" ssload 'sprnubes !
	|71 48 "r3/gamejamd/od/nube1.png" ssload 'sprnubes !
	50 50 "r3/gamejamd/od/humo.png" 
	ssload 'sprhumo !

	'sprcasa 
	145 160 "r3/gamejamd/od/casa1.png" ssload swap !+
	110 126 "r3/gamejamd/od/casa2.png" ssload swap !+
	121 104 "r3/gamejamd/od/casa3.png" ssload swap !+
	204 137 "r3/gamejamd/od/casa4.png" ssload swap !
	
	
	"r3/gamejamd/od/Capsmall.ttf" 46 TTF_OpenFont 'font ! 
	font immSDL
	"r3/gamejamd/od/silbido.mp3" mix_loadWAV 'sndbomba !
	"r3/gamejamd/od/explosion.mp3" mix_loadWAV 'sndexplo !
	"r3/gamejamd/od/boton.mp3" mix_loadWAV 'sndboton !
	"r3/gamejamd/od/victoria.mp3" mix_loadWAV 'sndvictoria !

|	"r3/gamejamd/od/tema1.mp3" mix_loadmus 'musmenu !
|	"r3/gamejamd/od/tema2.mp3" mix_loadmus 'musjuego !
	
	$7f vaini
	100 'listbom p.ini
	100 'listedi p.ini
	500 'listfx p.ini
	timer<
	
	'texto lines
	'titlestart SDLshow
	'listfx p.clear
	cielo
|	50 Mix_VolumeMusic drop
|	musmenu -1 mix_playmusic
	'menu SDLShow
	
	SDLquit ;	
	
: main ;

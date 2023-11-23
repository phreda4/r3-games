^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/lib/rand.r3
^r3/util/bfont.r3
^r3/util/arr16.r3
^r3/util/varanim.r3
^r3/util/boxtext.r3
^r3/lib/color.r3

#font
#nubes		| hoja de sprites
#explo		| hoja de sprites
#spredif	| hoja de sprites

#spravion
#sprbomba

#x 500.0 #y 100.0
#vx #vy	| viewport
#puntos

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
	52 << a!+ nubes a!+
	swap a!+ a!+ ;

:cielo
	30 ( 1? 1 -
		0.5 randmax 0.6 -
		0.1 randmax 0.05 -
		2 randmax 
		1.0 randmax 0.4 + 
		1800.0 randmax 400.0 -
		400.0 randmax 
		+nube
		) drop ;		
		
|----------------------
:edi | a -- a
	objsprite
	dup .x -100.0 <? ( 2drop 0 ; ) drop
	drop ;
	
:+edificio | vx vy n z x y --
	'edi 'listedi p!+ >a 
	swap a!+ a!+	| x y 
	a!+ 52 << a!+ 	| w h
	spredif a!+
	swap a!+ a!+ ;	| vx vy

:edificios
	50 randmax 1? ( drop ; ) drop
	-1.0 0 
	0 
	0.8 randmax 0.6 + | zoom
	1100.0 
	50.0 randmax 560.0 +
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
	6 26 0 vci>anim a!+ explo a!+
	-1.0 a!+ -0.1 a!+
	;
		
|-------------- Jugador
:jugador
	x int. y int. 0 spravion SDLspriteR ;

|-------------- Disparo	
#hit?
:hit | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 
	20.0 >? ( drop ; )	drop	| lejos
	dup .a dup
	@ 52 >> $1 and? ( 2drop ; )  | ya roto
	1 + 52 << swap !			| cambia dibujo
	1 'puntos +!
|	1 playsnd
	1 'hit? !
	;
	
:bomba | v -- 
	objsprite
	0.02 over .vy +!		| gravedad
	0.001 32 << over .r +!		| rotacion
	dup .x @ over .y @ 700.0 >? ( 100.0 - +explo drop 0 ; ) 
	0 'hit? !
	'hit 'listedi p.mapv		| choco con edificio
	hit? 1? ( drop 20.0 - +explo drop 0 ; ) drop
	2drop
	drop
	;

#disparodelay

:+disparo
	disparodelay -? ( drop ; ) drop
	-200 'disparodelay ! |200 ms delay
	'bomba 'listbom p!+ >a 
	x 30.0 + a!+ y 60.0 + a!+	| x y 
	1.0 a!+ 0 a!+
	sprbomba a!+			|
	0 a!+ 0 a!+ 	| vx vy
	;

:randwind
	vareset
	'x 400.0 randmax 300.0 + x 3 2.0 0.0 +vanim
	'y 200.0 randmax 50.0 + y 3 2.0 0.0 +vanim
	'randwind 2.0 +vexe
	;
	
|-------------- Juego
:juego
	timer. vupdate
	deltatime 'disparodelay +!
	|$78ADE8 SDLcls
	0 sdlcls	
	'listedi p.draw
	'listfx p.draw
	'listbom p.draw	
	jugador	
	edificios
	SDLredraw

	SDLkey 
	>esc< =? ( exit )
	<esp> =? ( +disparo )
	drop ;

:jugar 
	'listbom p.clear
	'listfx p.clear
	500.0 'x ! 100.0 'y !
	cielo
	
	randwind
	'juego SDLShow ;

|-------------------------------------
#texto>
#texto 
"The world need" 
"more democracy"
" "
"don't worry"
"we have democracy for all"
" "
"Oppenheimer Democracy"
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
	
	128 128 "r3/gamejamd/od/explosion.png" ssload 'explo !
	51 10 "r3/gamejamd/od/bomba.png" ssload 'sprbomba !
	"r3/gamejamd/od/b52.png" loadimg 'spravion !
	143 88 "r3/gamejamd/od/nubes.png" ssload 'nubes !
	50 100 "r3/gamejamd/od/edificios.png" ssload 'spredif !
	"media/ttf/roboto-medium.ttf" 48 TTF_OpenFont 'font ! 
	$7f vaini
	200 'listbom p.ini
	100 'listedi p.ini
	200 'listfx p.ini
	timer<
	
	'texto lines
|	'titlestart SDLshow
	
	jugar
	SDLquit ;	
	
: main ;

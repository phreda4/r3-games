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

#spravion
#sprbomba

#x 500.0 #y 100.0

#vx #vy	| viewport

#listshoot 0 0 | lista de disparos
#listfx 0 0 | fx
#listfx2 0 0 | fx

:objsprite | adr -- adr
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ 				| zoom
	a@ timer+ dup a!+ 	| anima
	nanim a@+ sspritez
	dup 40 + @ over +!		| vx
	dup 48 + @ over 8 + +!	| vy
	;

|--------------- fx	
:.vx 24 + ;
:.vy 32 + ;

:nube
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ 				| n
	nubes ssprite
	dup .vx @ over +!		| vx
	dup .vy @ over 8 + +!	| vy
	
	dup @ -400.0 <? ( 1400.0 pick2 ! ) drop
	dup 8 + @ 350.0 - abs 150.0 >? ( over .vy dup @ neg swap ! ) drop | 200..500
	drop
	;

:+nube	| vx vy n x y --
	'nube 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	a!+ swap a!+ a!+ ;

:+nube2	| vx vy n x y --
	'nube 'listfx2 p!+ >a 
	swap a!+ a!+	| x y 
	a!+ swap a!+ a!+ ;

:cielo
	40 ( 1? 1 -
		0.5 randmax 0.7 -
		0.1 randmax 0.05 -
		25 randmax 
		1800.0 randmax 400.0 -
		300.0 randmax 200.0 + | 200..500
		+nube
		) drop 
	20 ( 1? 1 -
		0.5 randmax 0.7 -
		0.1 randmax 0.05 -
		25 randmax 
		1800.0 randmax 400.0 -
		300.0 randmax 200.0 +
		+nube2
		) drop ;		

		
:nuke
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ int.			| n
	explo ssprite
	0.05 over 16 + +!
	dup 16 + @ int. 4 =? ( 2drop 0 ; )
	2drop
	;
	
:+explo | x y --
	'nuke 'listfx p!+ >a 
	swap a!+ 150.0 - a!+	| x y 
	0 a!
	;

		
|-------------- Jugador
:jugador
	x int. y int. 0 1.0 spravion SDLspriteRZ  ;

|-------------- Disparo	
:bomba | v -- 
	dup >a
	a@+ int. 
	a@+ int.	| x y
	a@+ a@+				| zoom
	sprbomba SDLspriteRZ 
	dup 40 + @ over +!		| vx
	dup 48 + @ over 8 + +!	| vy
	0.02 over 48 + +!		| gravedad
	0.001 over 16 + +!		| rotacion
	
	dup 8 + @ 700.0 >? ( drop @+ swap @ +explo 0 ; ) 
	2drop
	;

:+disparo
	'bomba 'listshoot p!+ >a 
	x 30.0 + a!+ y 60.0 + a!+	| x y 
	0 a!+ 1.0 a!+	| rotacion zoom
	0 a!+			|
	0 a!+ 0.0 a!+ 	| vx vy
	;

:randwind
	vareset
	'x 400.0 randmax 300.0 + x 3 2.0 0.0 +vanim
	'y 200.0 randmax 50.0 + y 3 2.0 0.0 +vanim
	'randwind 2.0 +vexe
	;
	
|-------------- Juego
:juego
	vupdate
	$f0f3f SDLcls
	timer.
	'listfx p.draw
	'listshoot p.draw	
	jugador	
	'listfx2 p.draw
	SDLredraw

	SDLkey 
	>esc< =? ( exit )
	<esp> =? ( +disparo )
	drop ;

:jugar 
	'listshoot p.clear
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

:l0count | list -- cnt
	0 ( swap dup c@ 1? drop >>0 swap 1+ ) 2drop ;
	
#colm
#t	
:lines | texto --
	dup 'texto> !
	$ff 'colm !
	vareset
	1.0 't !
	l0count dup "%d" .println
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
	384 237 "r3/gamejamd/od/nubes.png" ssload 'nubes !	
	384 360 "r3/gamejamd/od/explo.png" ssload 'explo !
	"r3/gamejamd/od/b52.png" loadimg 'spravion !
	"r3/gamejamd/od/bomba.png" loadimg 'sprbomba !
	"media/ttf/roboto-medium.ttf" 48 TTF_OpenFont 'font ! 
	$7f vaini
	200 'listshoot p.ini
	100 'listfx p.ini
	100 'listfx2 p.ini
	timer<
	
	'texto lines
	'titlestart SDLshow
	
	jugar
	SDLquit ;	
	
: main ;

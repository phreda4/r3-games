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
	a@+ 				| rota
	a@ timer+ dup a!+ 	| anima
	nanim a@+ sspriter
	dup .vx @ over .x +!	| vx
	dup .vy @ over .y +!	| vy
	;

|--------------- fx	
:nube
	objsprite
	dup .x @ -400.0 <? ( 1400.0 pick2 .x ! ) drop
	dup .y @ 350.0 - abs 150.0 >? ( over .vy dup @ neg swap ! ) drop | 200..500
	drop
	;

:+nube	| vx vy n x y --
	'nube 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	0.0 a!+ 52 << a!+ nubes a!+
	swap a!+ a!+ ;

:+nube2	| vx vy n x y --
	'nube 'listfx2 p!+ >a 
	swap a!+ a!+	| x y 
	0.0 a!+ 52 << a!+ nubes a!+
	swap a!+ a!+ ;

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

|-------------- Explosion		
:nuke
	objsprite
	0.05 over .a +!
	dup .a @ int. 4 =? ( 2drop 0 ; )
	2drop
	;
	
:+explo | x y --
	'nuke 'listfx p!+ >a 
	swap a!+ 150.0 - a!+	| x y 
	0 a!+ 0 a!+ explo a!+
	0 a!+ 0 a!+
	;
		
|-------------- Jugador
:jugador
	x int. y int. 0 spravion SDLspriteR ;

|-------------- Disparo	
:bomba | v -- 
	objsprite
	0.02 over .vy +!		| gravedad
	0.001 over .r +!		| rotacion
	dup .y @ 700.0 >? ( drop .x @+ swap @ +explo 0 ; ) 
	2drop
	;

:+disparo
	'bomba 'listshoot p!+ >a 
	x 30.0 + a!+ y 60.0 + a!+	| x y 
	0 a!+ 0 a!+	sprbomba a!+			|
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
	51 10 "r3/gamejamd/od/bomba.png" ssload 'sprbomba !
	"r3/gamejamd/od/b52.png" loadimg 'spravion !
	
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

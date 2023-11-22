^r3/lib/rand.r3
^r3/lib/color.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/bfont.r3
^r3/util/arr16.r3
^r3/util/varanim.r3
^r3/util/boxtext.r3
^r3/util/sdlgui.r3

#font
#sprfx
#listfx 0 0 | fx

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
	nanim a@+ sspriter
	dup .vx @ over .x +!	| vx
	dup .vy @ over .y +!	| vy
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

:fillscr
	40 ( 1? 1 -
		0.5 randmax 0.7 -
		0.1 randmax 0.05 -
		25 randmax 
		1800.0 randmax 400.0 -
		300.0 randmax 200.0 + | 200..500
		+fx
		) drop ;
	
		
|-------------- Juego
#colores $ff $ff00 $ff0000 $ff00ff
#tiempoclick
#colorclick
#puntos 
	
:newcolor
	4 randmax 'colorclick !
	3000 'tiempoclick !
	;

:clickc | color
	colorclick <>? ( drop ; ) drop
	newcolor
	1 'puntos +!
	;
	
:juego
	vupdate timer.
	deltatime neg 'tiempoclick +!
	$78ADE8 SDLcls
	immgui	

	196 immwidth
	102 300 immat $ff 'immcolorbtn !
	[ 0 clickc ; ] "click1" immbtn 
	302 300 immat $ff00 'immcolorbtn !
	[ 1 clickc ; ] "click2" immbtn
	502 300 immat $ff0000 'immcolorbtn !
	[ 2 clickc ; ] "click3" immbtn
	702 300 immat $ff00ff 'immcolorbtn !
	[ 3 clickc ; ] "click4" immbtn
	
	
	'colores colorclick ncell+ @ SDLColor
	412 50 200 100 SDLFRect
	
	462 160 immat
	100 50 immbox
	puntos "%d" sprint immlabel
	
	'listfx p.draw
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
	<f1> =? ( newcolor )
	drop ;

:reset
	'listfx p.clear
	0 'puntos !
	newcolor
	;

:jugar 
	reset
	'juego SDLShow ;

|-------------------------------------
|-------------------------------------
:main
	"velocicracia" 1024 600 SDLinit
	
	"media/ttf/roboto-medium.ttf" 48 TTF_OpenFont 'font ! 
	font immSDL 
	timer<
	$7f vaini
	100 'listfx p.ini

	jugar
	SDLquit ;	
	
: main ;

^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/arr16.r3
^r3/win/sdl2mixer.r3
^r3/util/sdlgui.r3

#tsnave	| dibujo
#tsexplo
#tsflores

#aninave 0	| frame maximo
#xp 400.0 #yp 560.0		| posicion
#xv #yv		| velocidad

#fx 0 0
#disparos 0 0 
#enemis 0 0

#dispaparo
#exploplo
#menumusica
#musicafondo

#puntos 0
#puntajevx 0

|disparo
| x y ang anim ss vx vy ar
| 1 2 3   4    5  6  7  8
:.x		1 ncell+ ;
:.y		2 ncell+ ;
:.a		3 ncell+ ;
|:.xy@	1 ncell+ @+ swap @ ;
:.anim	4 ncell+ ;
:.vx	6 ncell+ ;
:.vy	7 ncell+ ;
:.va	8 ncell+ ;

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ nanim 			| n
	a@+ sspriterz
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	dup .va @ over .a +!
	;
		
#fondo
#fondo2
:explosion
	objsprite	
	.anim @ canim 5 =? ( drop 0 ; )
	drop
	;

:+explo	| y x --
	'explosion 'fx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+	| ang zoom
	6 6 6 vci>anim | vel cnt ini 
	a!+	tsexplo a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!	
	|exploplo SNDplay	| vrz
	;

|------------------------------
:exploplayer
	objsprite
	.anim @ canim 5 =? ( drop 0 exit ; )
	drop
	;

#muerte 
:+explon | --
	1 'muerte !
	'exploplayer 'fx p!+ >a 
	xp a!+ yp a!+	| x y 
	2.0 a!+	| ang zoom
	6 6 0 vci>anim | vel cnt ini 
	a!+	tsexplo a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!		
|	exploplo SNDplay | vrz
	;

#colornave
#hit
:choque  | x y i n p -- x y i n p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	
	dup .anim @ 52 >> 2 >> 1 -
	colornave <>? ( drop ; ) 
	drop
	
	dup 'enemis p.del
|	pick4 pick4 +fx
	5 'puntos +!
	puntajevx puntos max 'puntajevx !
|	1 playsnd
	0 'hit !
	pick4 pick4 +explo
	;

	
:bala | v -- 
	objsprite
	dup .anim @ 52 >> 1 >> 'colornave !
	1 'hit !
	dup 8 + @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	'choque 'enemis p.mapv | 'vector list --	
	2drop
	hit 0? ( nip ; ) drop
	drop
	;

#delayd

:+disparo | n --
	delayd -? ( 2drop ; ) drop
	-10 'delayd !
	'bala 'disparos p!+ >a 
	xp a!+ 560.0 a!+	| x y 
	1.0 a!+	| ang zoom
	0 0 rot 1 << vci>anim | vel cnt ini 
	a!+	tsflores a!+			| anim sheet
	0 a!+ -3.0 a!+ 	| vx vy
	0.1 32 << a!			| vrz
|	dispaparo SNDplay
	;

	
:alien | v -- 
	objsprite	
	|..... remove when outside screen
	dup 8 + @+ dup -17.0 817.0 between -? ( 4drop 0 ;  ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	30.0 <? ( +explon ) drop
	drop
	;

:+marciano
	'alien 'enemis p!+ >a 
	600.0 randmax 100.0 + a!+ -100.0 a!+ |alien  x y 
	2.0 a!+	| ang zoom
	8 4 | vel cnt ini 
	3 randmax 1 + 2 << 
	vci>anim a!+
	tsnave a!+			| anim sheet
	2.0 randmax 1.0 - a!+ 
	1.0 1.0 randmax + a!+ 	| vx vy
	0 a!		
	;

:jugador
	SDLkey
	>esc< =? ( exit )
	<le> =? ( -3.0 'xv ! )
	>le< =? ( 0 'xv ! )
	<ri> =? ( 3.0 'xv ! )
	>ri< =? ( 0 'xv ! )	
	<a> =? ( 0 +disparo )
	<s> =? ( 1 +disparo )
	<d> =? ( 2 +disparo )	
	drop 
	muerte 1? ( drop ; ) drop
	xp int. yp int. 0.5 2.0 
	aninave timer+ dup 'aninave ! nanim
	tsnave sspriterz	
	xv 'xp +!
	yv 'yp +!
	1 'delayd +!
	;
	
:horda
	40 randmax 1? ( drop ; ) drop
	+marciano
	;
	
:juego
	0 0 fondo SDLImage 
	timer.
	'disparos p.draw
	jugador	
	'enemis p.draw	
	'fx p.draw
	SDLredraw
	horda
	;

:reset
	'disparos p.clear
	'enemis p.clear
	'fx p.clear
	400.0 'xp !
	560.0 'yp !
	8 4 0 vci>anim 'aninave !
	0 'muerte !
	0 'puntos !
	;

:jugando
	reset 
	'juego Sdlshow
	;
	
:menu
	0 SDLcls
	immgui
	0 150 immat
	800 immwidth
	$FF6A00 'immcolortex !
	"Flores" immlabelc
	300 350 immat
	200 immwidth
	$ffffff 'immcolortex !
	'jugando "Jugar" immbtn
	immdn
	'exit "Salir" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugando )
	drop
	;

:main
	"r3sdl" 800 600 SDLinit
	"r3/iti2023/enzo/fondo.png" loadimg 'fondo !
	32 32 "r3/iti2023/enzo/aviones.png" ssload 'tsnave !
	64 64 "r3/iti2023/enzo/explo.png" ssload 'tsexplo !
	41 41 "r3/iti2023/enzo/flores.png" ssload 'tsflores !
	"r3/iti2023/enzo/godofwar.ttf" 50 TTF_OpenFont immSDL 	
	200 'disparos p.ini
	100 'enemis p.ini
	200 'fx p.ini 
	8 0 0 vci>anim 'aninave !
	timer<
	'menu SDLshow
	SDLquit ;	
	
: main ;
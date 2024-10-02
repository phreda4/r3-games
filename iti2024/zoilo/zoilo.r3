| pampa zoilo
| PHREDA 2024
|------------------
^r3/lib/console.r3
^r3/lib/sdl2gfx.r3
^r3/util/sdlgui.r3
^r3/util/arr16.r3
^r3/lib/rand.r3
^r3/util/hash2d.r3

^r3/util/bmap.r3

|----
#spranimal
#sprplayer
#sprcosas

|----
#mapa1

#obj 0 0
#disp 0 0
#fx 0 0

#btnpad		| boton
#dirp		| direccion

#xp #yp 		| player
#xvp #yvp		| viewport
#xvpd #yvpd	| viewport dest

#escopeta 1
#balas 5
#llaves 0
#celu 0
#vidas 3

|person array
| x y ang anim ss vx vy ar
| 1 2 3   4    5  6  7  8
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.a 3 ncell+ ;
:.ani 4 ncell+ ;
:.ss 5 ncell+ ;
:.vx 6 ncell+ ;
:.vy 7 ncell+ ;
:.va 8 ncell+ ;

:anim!
	a> .ani dup @ $ffffffff and rot or swap ! ;
	
#fullscr
	
:toglefs
	fullscr 1 xor 'fullscr !
	SDL_windows fullscr $1 and SDL_SetWindowFullscreen 
	;
	
|---------------------
#velz
:anizombie | vx -- nani
	dup abs 11 >> $fff and 'velz !
	-? ( a> .a @ 2 +  2 velz ICS>anim ; ) 
	a> .a @ 2 velz ICS>anim ; 

:vagazombie
	100 randmax 1? ( drop ; ) drop
	0.4 randmax 0.2 -
	anizombie anim!
	a> .vx ! 
	0.4 randmax 0.2 -
	a> .vy ! ;

:zdir
	xp a> .x @ - 	
	yp a> .y @ - 
	atan2 sincos 
	0.3 randmax 1.0 +
	rot over *. -rot *.
	a> .vy ! 
	anizombie anim!
	a> .vx ! ;
		
:iazombie
	xp a> .x @ - yp a> .y @  -	
	distfast
	200.0 >? ( drop vagazombie ; ) drop | lejos.. vagar
	100 randmax 1? ( zdir ) drop | cerca del player.. seguir
	;

:obstaculo
	a> .x @ a> .vx @ +
	a> .y @ a> .vy @ +
	xyinmap@
	$1000000000000 nand? ( drop ; ) drop 
	| pared 
	0.0 a> .vx ! 0.0 a> .vy ! | detener
	;
	
:zombie
	>a
	a> 'obj p.nro  $4000 or | enemigo
	16 a> .x @ int. a> .y @ int. h2d+!	
	
	iazombie
	
	obstaculo
	
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	
	a> .ani dup @ timer+ dup rot ! anim>n 			| n
	$30000 or
	a> .x @ int. xvp - 
	a> .y @ int. yvp -
	+sprite | a x y --
	;	
	

:+zombie | a x y --
	'zombie 'obj p!+ >a
	swap a!+ a!+
	a!+ 
	0 a!+ 
	0 a!+ 0 a!+ 0 a!+
	;

|----------------
:animal
	>a
	
	a> 'obj p.nro  $4000 or | enemigo
	16 a> .x @ int. a> .y @ int.
	h2d+!	
	
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	a> .ani dup @ timer+ dup rot ! anim>n 			| n
	$10000 or
	a> .x @ int. xvp - 
	a> .y @ int. yvp -
	+sprite | a x y --
	;	
	
:+animal | vx vy A x y  --
	'animal 'obj p!+ >a
	swap a!+ a!+
	0 a!+ 
	a!+ 
	0 a!+
	swap a!+ a!+
	;

:diranimal | -- vx
	0.8 randmax 0.5 +
	rand $10000 and? ( drop neg ; ) drop ;

:anianimal |	vx --nani
	-? ( 0 6 rot neg 9 >> $fff and ICS>anim ; ) 
	6 6 rot 9 >> $fff and ICS>anim ;
	
:posanimal | vx -- x
	-? ( drop xp 600.0 + ; ) drop xp 600.0 - ;
	
:randanimal
	diranimal		| vx
	0.2 randmax		| vy
	over anianimal 
	pick2 posanimal
	600.0 randmax 300.0 - yp +
	+animal	
	;
	
|----------------------------
:cosa
	>a

	a> 'obj p.nro  $2000 or | objeto
	8
	a> .x @ int. a> .y @ int.
	h2d+!	
	
	a> .a @ $20000 or
	a> .x @ int. xvp -
	a> .y @ int. yvp -
	+sprite	| a x y
	;	

:+cosa | ndib x y --
	'cosa 'obj p!+ >a
	swap a!+ a!+
	a!+ 
	;	

|----------------------------
#dx #dy	

:dirdis
	dirp
	0 'dx ! 0 'dy !
	$1 and? ( 8.0 'dx ! )	
	$2 and? ( -8.0 'dx ! )
	$4 and? ( 8.0 'dy !  )
	$8 and? ( -8.0 'dy ! )
	drop
	;

:disparo
	$ffffff sdlcolor
	>a
	a> .x @ int. xvp - 0 <? ( drop 0 ; ) sw >? ( drop 0 ; )
	a> .y @ int. yvp - 0 <? ( 2drop 0 ; ) sh >? ( 2drop 0 ; )
	3 3 sdlfrect 
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!

	a> 'disp p.nro $1000 or | disparo
	4 a> .x @ int. a> .y @ int. h2d+!	
	
	;	

	
:+disparo | --
	'disparo 'disp p!+ >a
	xp a!+ yp 38.0 - a!+
	3 3 << a+
	dirdis 
	dx a!+ dy a!+
	;	

:cuchillo
	$ffffff sdlcolor
	>a
	a> .a @ 0? ( ; ) dup 
	a> .x @ xvp - 
	a> .y @ yvp - 
	sdlfellipse 
	-1 a> .a +!
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	;
	
:+cuchillo
	dirdis 
	'cuchillo 'disp p!+ 8 - >a
	xp dx + int. a> .x !
	yp 38.0 - dy + int. a> .y !
	dx int. 2 >> a> .vx !
	dy int. 2 >> a> .vy !
	10 a> .a !
	;	
		
:accion
	btnpad $10 and? ( drop ; ) drop
	escopeta 0? ( drop +cuchillo ; ) drop
	balas 0? ( 'escopeta ! ; ) drop
	+disparo 
	-1 'balas +!
	;
	
|------ PLAYER
:viewpostmove
	xvpd xvp - 5 >> 'xvp +!
	yvpd yvp - 5 >> 'yvp +!
	;
	
:viewportx | x -- x
	dup sw 1 >> - 'xvpd ! ;
	
:viewporty | y -- y
	dup sh 1 >> - 'yvpd ! ;	

:xymove | dx dy --
	a> .x @ pick2 + 
	a> .y @ pick2 + |16 >> 32 + | piso
	xyinmap@
	$1000000000000 and? ( 3drop ; ) 
	drop
	a> .y +!
	a> .x +!
	;


	
#dirq ( 0 6 14 0 0 0 0 0 10 0 0 0 0 0 0 0 )
	
:diranim | btn -- btn
	0 'dx ! 0 'dy !
	$1 and? ( 2.0 'dx ! )	
	$2 and? ( -2.0 'dx ! )
	$4 and? ( 2.0 'dy !  )
	$8 and? ( -2.0 'dy ! )
	dirp =? ( drop ; ) 
	|0? ( 0 0 0 ICS>anim anim! drop ; )
	0? ( drop dirp 'dirq + c@ 0 0 ICS>anim anim! ; ) 
	$1 =? ( 6 4 $ff ICS>anim anim! ) | ri
	$2 =? ( 14 4 $ff ICS>anim anim! ) | le
	$4 =? ( 0 6 $ff ICS>anim anim! ) |dn 
	$8 =? ( 10 4 $ff ICS>anim anim! ) |up
	'dirp !
	;

|  x y anim 
:player	
	>a
	btnpad $f and diranim 	
	dx dy xymove
	
	0 16 a> .x @ int. a> .y @ int. 16 - h2d+! | jugador
	
	a> .ani dup @ timer+ dup rot ! anim>n 			| n
	a> .x @ dup 'xp ! int. 
	a> .y @ dup 'yp ! int. 
	xytrigger
	swap viewportx xvp -
	swap viewporty yvp -
	+sprite | a x y --
	
	;	

:+jugador | 'per x y --
	'player 'obj p!+ >a
	swap a!+ a!+
	0 a!+ 
	a!+ 
	;	

|--------- dibujo de sprite en bmap
:jplayer
	swap 32 - swap sprplayer ssprite ; | x y n ssprite

:janimal
	$ffff and spranimal ssprite ;

:jcosa
	$ffff and sprcosas ssprite ;
	
:jzombie
	$ffff and 1.5 swap sprcosas sspritez ;

	
#listdsp 'jplayer 'janimal 'jcosa 'jzombie | otro

:bsprdrawsimple
	dup 16 >> $3 and | $x0000 
	3 << 'listdsp + @ ex ;
	
|----------------------------------	
:hud
	64 24 2.0 escopeta 1 xor sprcosas sspritez
	0 ( llaves <?
		dup 32 * 128 + 24 2.0 5 sprcosas sspritez
		1+ ) drop
		
	$ffffff bcolor
	0 32 bat
	vidas "Vidas: %d " bprint2
	escopeta 1? ( balas "balas %d " bprint2 ) drop	
	
	bcr bcr	
|	dirp "%h " bprint 
|	btnpad "%h " bprint 
|	'disp p.cnt "%d" bprint
|	H2d.list "%d %h" bprint
	;
	
|------------ colision
:hitobj | nro --
	'obj p.adr
	dup .a @ 
	|0 =? ( ) | escopeta
	3 =? ( 5 'balas +! ) | balas 
	4 =? ( 1 'celu +! ) | celu
	5 =? ( 1 'llaves +! ) | llaves
	drop
	'obj p.del
	;
	
:hitplayer
	$1000 and? ( drop ; ) | disparo
	$2000 and? ( $fff and hitobj ; ) |objeto
	$4000 and? ( drop -1 'vidas +! ; ) | enemigo	
	drop |??
	;

:2sort | a b -- a b
	over <? ( ; ) swap ; 
	
:obj2del
	2sort 
	'obj p.del
	'obj p.del
	;
	
:hitdisp	
	swap |$fff and 'obj p.adr 'obj p.del | borra bala
	$4000 and? ( 
		$fff and 'obj p.adr 'obj p.del  | borra enemigo
		$fff and 'disp p.adr 'disp p.del  | borra bala
		; ) | borra enemigo
	2drop
	;
	
	
:hitobj | obj1 obj2 --
	2sort
	0? ( drop hitplayer ; ) 
	$1000 and? ( hitdisp ; ) | disparo
	
	|2drop |
	" %h %h " bprint
	
	;
	
:colisiones	
	H2d.list 
	( 1? swap
		d@+ dup 16 >> $ffff and swap $ffff and 
		hitobj
		swap 1- ) 2drop ;
	
|----- JUGAR
:jugar
	timer.
	0 SDLcls
	immgui		| ini IMMGUI	

	H2d.clear
	
	inisprite
	'obj p.draw
	xvp yvp drawmaps
	viewpostmove
	'disp p.draw
	'fx p.draw		

	hud
|	0 0 zoom	

	|--- colisiones
	colisiones
	SDLredraw
	
	SDLkey 
	>esc< =? ( exit )
	<up> =? ( btnpad $8 or 'btnpad ! )
	<dn> =? ( btnpad $4 or 'btnpad ! )
	<le> =? ( btnpad $2 or 'btnpad ! )
	<ri> =? ( btnpad $1 or 'btnpad ! )
	>up< =? ( btnpad $8 nand 'btnpad ! )
	>dn< =? ( btnpad $4 nand 'btnpad ! )
	>le< =? ( btnpad $2 nand 'btnpad ! )
	>ri< =? ( btnpad $1 nand 'btnpad ! )	
	<z> =? ( accion btnpad $10 or 'btnpad ! )
	>z< =? ( btnpad $10 nand 'btnpad ! )
	<f1> =? ( randanimal )
	<f2> =? ( 5 'balas ! )
	<f3> =? ( escopeta 1 xor 'escopeta ! )
|	<f> =? ( toglefs ) | fullscreen
	drop 
	;
	
:reset
	'obj p.clear
	'disp p.clear
	'fx p.clear
	1 'dirp !
	5 'balas !
	0 'llaves !
	0 'celu !
	3 'vidas !
	timer<
	;

:randcosa	
	 3 randmax 3 + 	
	( 	1200.0 randmax 32.0 + 16.0 32 * +
		600.0 randmax 64.0 + 10.0  32 * +
		2dup xyinmap@ $1000000000000 and? 
		3drop ) drop
	+cosa
	;
:randzombie
	2 randmax 2 << 6 +
	(
		2400.0 randmax 200.0 +
		1200.0 randmax 300.0 +
		2dup xyinmap@ $1000000000000 and? 
		3drop ) drop		
	+zombie ;
	
:juego
	inisprite
	reset
	0 600.0 360.0 +jugador | 0 es jugador
	
	6 0 $ff ICS>anim 900.0 500.0 +zombie
	8 0 $ff ICS>anim 600.0 700.0 +zombie
	
	40 ( 1? 1- randzombie ) drop
	20 ( 1? 1 - randcosa ) drop
	'jugar SDLshow
	;	

:main
	"r3sdl" 1024 600 SDLinit
	SDLrenderer 1024 600 SDL_RenderSetLogicalSize | fullscreen
	
	"media/ttf/Roboto-Medium.ttf" 12 TTF_OpenFont immSDL
	"r3/iti2024/zoilo/mapa.bmap" loadmap 'mapa1 !
	bfont1
	64 64 "r3/iti2024/zoilo/caballo.png" ssload 'spranimal !
	64 64 "r3/iti2024/zoilo/jugador.png" ssload 'sprplayer !
	32 32 "r3/iti2024/zoilo/cosas.png" ssload 'sprcosas !
	'bsprdrawsimple 'bsprdraw !
	
	500 'obj p.ini
	100 'disp p.ini
	100 'fx p.ini
	1000 H2d.ini 
	$fff 'here +! | lista de contactos
	
	juego
	SDLquit
	;
	
: main ;
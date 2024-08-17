| pampa zoilo
| PHREDA 2024
|------------------
^r3/win/console.r3
^r3/win/sdl2gfx.r3
^r3/util/sdlgui.r3
^r3/util/arr16.r3
^r3/lib/rand.r3

^r3/util/bmap.r3

|----
##sprperro
##sprplayer

|----
#mapa1
#btnpad
#obj 0 0

#xp #yp 		| player
#xvp #yvp		| viewport
#xvpd #yvpd	| viewport dest

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

#fullscr
	
:toglefs
	fullscr 1 xor 'fullscr !
	SDL_windows fullscr $1 and SDL_SetWindowFullscreen 
	;
	
|---------------------
:perro
	>a
	
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	
	a> .ani dup @ timer+ dup rot ! anim>n 			| n
	$10000 or
	a> .x @ int. xvp - 
	a> .y @ int. yvp -
	+sprite | a x y --
	;	

:+perro | vx vy A x y  --
	'perro 'obj p!+ >a
	swap a!+ a!+
	0 a!+ 
	a!+ 
	0 a!+
	swap a!+ a!+
	;

:dirperro | -- vx
	0.8 randmax 0.5 +
	rand $10000 and? ( drop neg ; ) drop ;

:aniperro |	vx --nani
	-? ( 8 7 rot neg 9 >> $fff and ICS>anim ; ) 
	0 7 rot 9 >> $fff and ICS>anim ;
	
:posperro | vx -- x
	-? ( drop xp 600.0 + ; ) drop xp 600.0 - ;
	
:randperro
	dirperro		| vx
	0.2 randmax		| vy
	over aniperro 
	pick2 posperro
	600.0 randmax 300.0 - yp +
	+perro
	
	;
	
|-----------------------------------
:cosa
	8 + >a
	a> 2 3 << + @
	a@+ int. xvp -
	a@+ int. yvp -
	+sprite	| a x y
	;	

:+cosa | ndib x y --
	'cosa 'obj p!+ >a
	swap a!+ a!+
	a!+ 
	;	
	
|------ PLAYER

|---------------------
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

#btnpadp

:setanim
	a> .ani dup @ $ffffffff and rot or swap ! ;

|  x y anim 
:player	
	>a
	btnpad
	%1000 and? ( 0 -2.0 xymove )
	%100 and? ( 0 2.0 xymove  )
	%10 and? ( 12 12 $3f ICS>anim setanim -2.0 0.0 xymove )
	%1 and? ( 0 12 $3f ICS>anim setanim 2.0 0.0 xymove )
	0? ( 0 0 0 ICS>anim setanim )
	drop
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

:jperro
	$ffff and sprperro ssprite ;
	
#listdsp 'jplayer 'jperro	

:bsprdrawsimple
	dup 16 >> $1 and | $10000 
	3 << 'listdsp + @ ex ;
	
|----------------------------------	
|----- JUGAR
:jugar
	timer.
	0 SDLcls
	immgui		| ini IMMGUI	

	inisprite
	'obj p.draw
	
	xvp yvp drawmaps
	viewpostmove
	
	SDLredraw
	
	SDLkey 
	>esc< =? ( exit )
	<up> =? ( btnpad %1000 or 'btnpad ! )
	<dn> =? ( btnpad %100 or 'btnpad ! )
	<le> =? ( btnpad %10 or 'btnpad ! )
	<ri> =? ( btnpad %1 or 'btnpad ! )
	>up< =? ( btnpad %1000 nand 'btnpad ! )
	>dn< =? ( btnpad %100 nand 'btnpad ! )
	>le< =? ( btnpad %10 nand 'btnpad ! )
	>ri< =? ( btnpad %1 nand 'btnpad ! )	
	
	<f1> =? ( randperro )
	<f> =? ( toglefs ) | fullscreen
	drop 
	;
	
:reset
	'obj p.clear
	;

:randcosa	
	48
	( 	2800.0 randmax 32.0 + 
		1200.0 randmax 64.0 +
		2dup xyinmap@ $1000000000000 and? 
		3drop ) drop
	+cosa
	;
	
:juego
	inisprite
	reset
	0 130.0 300.0 +jugador | 0 es jugador
|	10 ( 1? 1 - randcosa ) drop
	'jugar SDLshow
	;	

:main
	"r3sdl" 1024 600 SDLinit
	SDLrenderer 1024 600 SDL_RenderSetLogicalSize | fullscreen
	
	"media/ttf/Roboto-Medium.ttf" 12 TTF_OpenFont immSDL
	"r3/iti2024/zoilo/mapa.bmap" loadmap 'mapa1 !
	
	64 64 "r3/iti2024/zoilo/perro.png" ssload 'sprperro !
	128 128 "r3/iti2024/zoilo/jugador.png" ssload 'sprplayer !
	'bsprdrawsimple 'bsprdraw !
	
	1000 'obj p.ini
	juego
	SDLquit
	;
	
: main ;
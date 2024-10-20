| LABERINTO
| PHREDA 2024
^r3/lib/sdl2gfx.r3
^r3/lib/rand.r3
^r3/lib/vec2.r3
^r3/util/arr16.r3
^r3/util/hash2d.r3
^r3/util/pcfont.r3

#worldMap (
  1 2 2 3 3 4 5 4 5 5 3 3 6 6 2 2 7 7 7 3 3 3
  1 0 0 0 0 0 1 0 0 0 0 0 0 0 2 0 0 0 0 0 0 3
  2 0 0 6 0 0 1 0 0 0 0 0 0 0 2 0 0 0 0 0 0 6
  2 0 0 6 0 0 1 0 0 4 4 4 0 0 2 1 1 1 1 0 0 6
  1 0 0 6 0 0 1 0 0 0 0 5 0 0 0 0 0 0 5 0 0 6
  1 0 0 6 0 0 1 0 0 0 0 5 0 0 0 0 0 0 5 0 0 6
  2 0 0 7 7 7 7 7 7 7 7 7 0 0 4 0 0 5 5 0 0 7
  2 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 7
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 3
  0 0 0 6 7 7 6 6 6 7 7 6 6 6 5 0 0 3 3 3 3 3
  1 0 0 6 0 0 0 0 0 1 0 0 4 0 0 0 0 1 0 0 0 3
  1 0 0 6 0 0 0 0 0 1 0 0 4 0 0 0 0 2 0 0 0 3
  5 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  5 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  5 2 2 2 0 0 3 5 5 5 5 1 0 0 6 6 6 0 0 6 6 1
  4 0 0 0 0 0 6 0 2 2 0 1 0 0 2 0 0 0 0 0 0 1
  4 0 0 0 0 0 6 0 0 0 0 1 0 0 2 0 0 0 0 0 0 2
  5 0 0 1 1 1 4 0 0 0 0 2 2 2 2 0 0 3 3 0 0 2
  4 0 0 0 0 0 0 0 0 6 0 0 0 0 0 0 0 3 3 0 0 3
  4 0 0 0 0 0 0 0 6 6 0 0 0 0 0 0 0 3 3 0 0 3
  5 5 5 5 5 4 4 4 6 6 5 5 5 5 4 4 5 5 5 3 3 3
)

#colores 0 $ff0000 $ff00 $ff $ffff00 $ffff $ff00ff $ffffffff $888888

#posX #posY
#angP
#dirX #dirY
#planeX #planeY
#mm 2
|-------------- sprites
#sprimg
#spr 0 0


|-------------- raycasting

#texs
#ntex
#rayDirX #rayDirY
#sideDistX #sideDistY
#deltaDistX #deltaDistY
#perpWallDist
#stepX #stepY
#side

#yhorizon

:calcDistX
	rayDirX sign 16 << 'stepX !
	-? ( drop posX $ffff and deltaDistX *. 'sideDistX ! ; ) drop
	1.0 posX $ffff and - deltaDistX *. 'sideDistX ! ;

:calcDistY
	rayDirY sign 16 << 'stepY !
	-? ( drop posY $ffff and deltaDistY *. 'sideDistY ! ; ) drop
	1.0 posY $ffff and - deltaDistY *. 'sideDistY ! ;

:mapadr | mx my -- adr
	16 >> 22 * swap 16 >> +
	'worldMap + ;

:maphit | mx my -- hit
	mapadr c@ ;

:step | mx my -- mx' my'
	sideDistX sideDistY <? ( drop
		deltaDistX 'sideDistX +!
		swap stepX + swap 0 'side ! ;
		) drop
	deltaDistY 'sideDistY +!
	stepY + 1 'side ! ;

:dda | -- mapx mapy
	posX $ffff nand posY $ffff nand
	( 2dup maphit 0?
		drop step )
	$3 and 'ntex !
	; 

:perpWall | mapx mapy --
    side 0? ( 2drop posX - 1.0 stepX - 2/ + rayDirX 0? ( 1.0 + ) /. ; ) drop nip
	posY - 1.0 stepY - 2/ + rayDirY 0? ( 1.0 + ) /.
	;

:deltaX
	rayDirY 0? ( ; ) drop
	rayDirX 0? ( drop 1.0 ; )
	1.0 swap /. abs ;

:deltaY
	rayDirX 0? ( ; ) drop
	rayDirY 0? ( drop 1.0 ; )
	1.0 swap /. abs ;

:calcWallX
	side 0? ( drop rayDirY perpWallDist *. posY + ; ) drop
	rayDirX perpWallDist *. posX +
	;

#altura
#lines * 6400 | 800 * 8
#nlineas * 6400

:line! | n altura tile x --
	;
	
:drawwithsprites
	;
	
#srcrec [ 0 0 1 64 ]
#desrec [ 0 0 1 600 ]

:face
	side 1? ( drop $7f ; ) drop 
	$ff ;
	
:shadowface
	texs face dup dup SDL_SetTextureColorMod ;
	
:drawline | x -- x
	dup 17 << sw / 1.0 -
	dup
	planeX *. dirX + 'rayDirX !
	planeY *. dirY + 'rayDirY !
	deltaX 'deltaDistX !
	deltaY 'deltaDistY !
	calcDistX
	calcDistY
	dda | mapx mapy
	perpWall 'perpWallDist !
	sh 16 << perpWallDist 0? ( 1 + ) / 'altura !

	'desrec >a 
	dup da!+
	yhorizon altura 2/ - da!+ 
	4 a+ 
	altura da!
	
	ntex 6 << calcWallX 10 >> $3f and + 'srcrec d! | xs
	
	shadowface
	SDLrenderer texs 'srcrec 'desrec SDL_RenderCopy
	;

 :render
	$5a5a5a sdlcolor
	0 yhorizon 800 sh yhorizon - sdlfrect
	0 ( sw <? 
		drawline
		1+ ) drop ;

|---------- struct sprite
| 1 2  3    4   5   6  7  8  9
| x y ang zoom img rad vx vy va
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.a 3 ncell+ ;
:.zoom 4 ncell+ ;
:.image 5 ncell+ ;
:.radio 6 ncell+ ;
:.vx 7 ncell+ ;
:.vy 8 ncell+ ;
:.va 9 ncell+ ;

#v2dx 0 
#v2dy 0

#sprx
#spry
#invdet
#trax 
#traY
#sprSX
#sprH

:drawsprite | x y
	posy - 'spry !
	posx - 'sprx !
	1.0 planeX dirY *. dirX planeY *. - 0? ( 1+ ) /. 'invdet !
	dirY sprX *. dirX sprY *. - invdet *. 'trax !
	planeY neg sprX *. planeX sprY *. + invdet *. 'tray !
	trax tray 0? ( 1+ ) /. 1.0 + sw 2/ * 16 >> 
	|? ( drop ; ) 
	'sprSX !
	sh 15 << traY 0? ( 1+ ) /. 4 >> | 32pix H 
	-? ( drop ; ) | offscreen
	'sprH !
	
	sprSX yhorizon sprH 0 sprimg sspritez
	;
	
:persona
	$ff00 sdlcolor
	
	dup .x @ over .y @ drawsprite
	>a
	mm 
	1 and? ( |--- mapa
		a> .x @ 13 >> 1 -
		a> .y @ 13 >> 1 -
		3 3 sdlrect
		) 
	2 and? ( |--- radar
		'v2dx a> .x v2=
		'v2dx 'posx v2- | v2s=vper	
		'v2dx angP neg 0.25 + v2rot
	
		v2dx 12 >> 400 + 1 -
		v2dy 12 >> 100 + 1 -
		3 3 sdlrect
		) 
	drop	
	;
	
:+persona | x y --
	'persona 'spr p!+ >a
	swap a!+ a!+
	;
	
:objetos
	'spr p.draw
	;
	
|----------- mini mapa
:drawcell | map y x --
	rot c@+ 3 << 'colores + @ sdlcolor
	-rot over 3 << over 3 << swap
	8 8 sdlFRect
	;

:drawmap
	'worldMap
	0 ( 24 <?
		0 ( 24 <?
			drawcell
			1+ ) drop
		1+ ) 2drop
	$ffffff sdlcolor
	posX 13 >> posY 13 >>
	over dirX 13 >> + over dirY 13 >> + 2over sdlline
	2dup swap planeX 13 >> + swap planeY 13 >> + sdlline
	;

:drawradar
	$232323 sdlcolor
	300 0 200 200 sdlfrect
	$ffffff sdlcolor
	399 99 2 2 sdlfrect
	300 200 400 100 sdlline
	400 100 500 200 sdlline
	;
|---------------------------------
:mover | speed --
	dirX over 2 << *. posX + posy maphit 0? ( over dirX *. 'posX +! ) drop
	posX over 2 << dirY *. posY + maphit 0? ( over dirY *. 'posY +! ) drop
	drop
	;

:rota
	angP + dup 'angP !
	1.0 polar | bangle largo -- dx dy
	2dup 'dirY ! 'dirX !
	0.66 *. 'planeX !
	neg 0.66 *. 'planeY !
	;

#vrot
#vmov

:game
	$0 SDLcls
	render
	mm 
	1 and? ( drawmap ) 
	2 and? ( drawradar ) 
	drop
	objetos

|	$ffffff pccolor
|	0 0 pcat "<f1> mapa" pcprint
|	posx posy "%f %f " print dirX dirY "%f %f " print cr
|	xypen texs sprite

	SDLredraw
	SDLkey
	<f1> =? ( mm 1 xor 'mm ! )
	<f2> =? ( mm 2 xor 'mm ! )

	<le> =? ( -0.01 'vrot ! )
	<ri> =? ( 0.01 'vrot ! )
	>le< =? ( 0 'vrot ! ) >ri< =? ( 0 'vrot ! )
	<up> =? ( 0.1 'vmov ! )
	<dn> =? ( -0.1 'vmov ! )
	>up< =? ( 0 'vmov ! ) >dn< =? ( 0 'vmov ! )
	
	<w> =? ( -4 'yhorizon +! )
	<s> =? ( 4 'yhorizon +! )
	
	>esc< =? ( exit )
	drop

	vrot 1? ( dup rota ) drop
	vmov 1? ( dup mover ) drop
	;

:main
	"Laberinto" 800 600 SDLinit
	pcfont
	"r3/iti2024/laberinto/texturas.png" loadimg 'texs ! | 64x64x8
	32 32 "r3/iti2024/laberinto/teseo.png" ssload 'sprimg !			|
	500 'spr p.ini
	100 H2d.ini 
	
	sh 2/ 'yhorizon !
	5.5 'posX ! 5.5 'posY ! 0 rota
	4.0 3.0 +persona
	6.0 8.0 +persona
	5.5 5.0 +persona
	4.0 5.5 +persona

	'game SDLshow 
	SDLquit ;

: main ;
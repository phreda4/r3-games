| contrareloj
| 2025

^r3/lib/sdl2gfx.r3
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/varanim.r3
^r3/util/txfont.r3
^r3/util/vscreen.r3
^./mapacr.r3

#font24
#filepath "r3/2025/contrar/"
:infile 'filepath "%s%s" sprint ;

#fondo
#xfondo

#imgspr

#arrobj 0 0

|------------------------------
#control	

#xvp #yvp	| viewport
#avp		| rotacion viewport

#px #py | positionX, positionY - where the car is
#vx #vy | velocityX, velocityY - speed on each axis
#drag   | drag - how fast the car slows down
#angle  | angle - the rotation of the car
#av     | angularVelocity - speed the car is spinning
#ad     | angularDrag - how fast the car stops spinning
#power  | power - how fast car can accelerate


	
:resetcar
	7 256.0 * 'px ! 
	5 256.0 * 128.0 + 'py !
    0.0 'vx ! 0.0 'vy !
    0.9 'drag !
    0.0 'angle !
    0.0 'av !
    0.95 'ad !
    2.0 'power !
	;
	
|------------------------------
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.ani 3 ncell+ ;
:.rot 4 ncell+ ;
:.vel 5 ncell+ ;

:objs
	>a
	
	a> .rot @ sincos
	a> .vel @ *. a> .x +!
	a> .vel @ *. a> .y +!
	
	a> .x @ int. xvp - 
	a> .y @ int. yvp - 
	a> .rot @ 0.25 + 2.0
	a> .ani dup @ deltatime + dup rot ! anim>n
	imgspr sspriterz | a x y --	
	;
	
:+obj | vel rot anim x y --
	'objs 'arrobj p!+ >a
	swap a!+ a!+
	a!+ | anim
	a!+ | rotacion
	a!+ | velocidad
	;
	
|----- jugador
:simulate 
	px vx + 'px !
	py vy + 'py !
	vx drag *. 'vx !
	vy drag *. 'vy !
	angle av + 'angle !
	av ad *. 'av !
	power 0? ( dup 'av ! ) drop
	;
	  
#maxpower 3.0
#minpower -2.0

:accel
	power 0.2 + maxpower min 'power ! ;

:deaccel | --
	power 0.2 - minpower max 'power ! ;

:turn | ang --
	power 3 >> *. 0.004 min -0.004 max 'av +! ;

:choque
|	px py ]mapf c@ $30 - 
0
	2 >? ( power -1.1 *. 'power ! )
	drop ;
	
:jugador
	control
	%1 and? ( accel )  
	%10 and? ( deaccel ) 
	%100 and? ( 0.001 turn ) 
	%1000 and? ( -0.001 turn )
	drop
	power 0.99 *. 'power ! 
	angle dup 
	cos power *. 'vx ! 
	sin power *. 'vy ! 
	simulate

|	choque
	
	px int. xvp -
	py int. yvp -
	angle 0.25 + 1.0 
	28 imgspr
	sspriteRZ | x y ang img --
	;


:hud
	4 0 txat
	py px "%f %f" sprint txwrite
	4 24 txat
|	px py ]mapf c@ $30 - "%h" sprint txwrite
	
|	sdlx wmap 2/ - fix. 
|	sdly hmap 2/ - fix. 
|	2dup "(%f %f)" sprint txwrite
|	]mapf c@ $30 - 
|	"%d" sprint txwrite
	;
	
|------------------- juego
:camarafondo
	px int. 512 2/ - 'xvp !
	py int. 300 2/ - 'yvp !

	9 9
	xvp 6 >> yvp 6 >>
	xvp $3f and neg 
	yvp $3f and neg	
	$3f $3f
	'mapa tiledraws ;	
	
|-------------
:juego
	vini
	$444444 sdlcls
	camarafondo
	
	'arrobj p.draw
	jugador

	hud
		
	vredraw
	sdlkey
	>esc< =? ( exit )
	<ri> =? ( control %100 or 'control ! )
	<le> =? ( control %1000 or 'control ! )
	<up> =? ( control %1 or 'control ! )
	<dn> =? ( control %10 or 'control ! )
	>ri< =? ( control %100 nand 'control ! )
	>le< =? ( control %1000 nand 'control ! )
	>up< =? ( control %1 nand 'control ! )
	>dn< =? ( control %10 nand 'control ! )
	
	<f1> =? (
		1.0 randmax
		1.0 randmax
		27 1 $3f ICS>anim
		1024.0 randmax 512.0 - px + 
		1024.0 randmax 512.0 - py +
		+obj
	)
	drop
	;

: | ::::::::::::::::::::::::::::::::::::::::::
"contrareloj" 1024 600 sdlinitR
512 300 vscreen
makemap
32 32 "sprite.png" infile ssload 'imgspr !
"media/ttf/Roboto-bold.ttf" 24 txload 'font24 !
font24 txfont

64 vaini
100 'arrobj p.ini
resetcar
'juego sdlshow
vfree
;
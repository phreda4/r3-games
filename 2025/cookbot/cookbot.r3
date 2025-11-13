| jrobot
| 2025

^r3/lib/sdl2gfx.r3

^r3/lib/rand.r3
^r3/util/vscreen.r3
^r3/util/arr16.r3
^r3/util/varanim.r3
^r3/util/txfont.r3

#font24
#filepath "r3/2025/cookbot/"
:infile 'filepath "%s%s" sprint ;

#imgfondo
#imgbarrac
#imgbarram

#sprjugador
#sprpersona

#objs 0 0

#jugx 200.0 #velx 0.0 #accx 0.0
#jugy 300.0 #vely 0.0 #accy 0.0
#juga 0

:jugador
	jugx int. jugy int. 4.0 juga sprjugador sspritez

	velx accx +
	1.2 min -1.2 max
	dup 0.9 *. 'velx !
	'jugx +!

	vely accy +
	1.2 min -1.2 max
	dup 0.9 *. 'vely !
	'jugy +!
	;

|------------------------------
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.ani 3 ncell+ ;
:.vx 4 ncell+ ;
:.vy 5 ncell+ ;

:obj
	>a
	a> .x @ int. 
	a> .y @ int.
	4.0
	a> .ani dup @ deltatime + dup rot ! anim>n
	sprpersona sspritez | a x y --
	;
	
:+obj | anim x y --
	'obj 'objs p!+ >a
	swap a!+ a!+
	a!+ | anim
|	swap a!+ a!+
	;
|-------------

	
:juego
	vini
	$0 sdlcls
	
	512 300 imgfondo sprite
	
	'objs p.draw
	jugador

	390 300 imgbarrac sprite
	800 116 imgbarram sprite
	800 394 imgbarram sprite
	
	vredraw
	sdlkey
	>esc< =? ( exit )
	<ri> =? ( 0.2 'accx ! 2 'juga ! ) >ri< =? ( 0 'accx ! )
	<le> =? ( -0.2 'accx ! 3 'juga !  ) >le< =? ( 0 'accx ! )
	<up> =? ( -0.2 'accy ! 1 'juga ! ) >up< =? ( 0 'accy ! )
	<dn> =? ( 0.2 'accy ! 0 'juga ! ) >dn< =? ( 0 'accy ! )
	
	<f1> =? (
		36 randmax 0 $7f ICS>anim
	|	4096.0 randmax 2048.0 -
		1024.0 randmax 
|		1024.0 randmax 512.0 -
		600.0 randmax 
		+obj
	)
	
	drop
	;

:
"cookbot" 1024 600 sdlinitr
1024 600 vscreen
"fondo.png" infile loadimg 'imgfondo !
"barrac.png" infile loadimg 'imgbarrac !
"barram.png" infile loadimg 'imgbarram !
64 64 "robot.png" infile ssload 'sprjugador !
32 32 "personas.png" infile ssload 'sprpersona !
"media/ttf/Roboto-bold.ttf" 24 txload 'font24 !
font24 txfont

64 vaini
100 'objs p.ini
'juego sdlshow
vfree
sdl_quit
;
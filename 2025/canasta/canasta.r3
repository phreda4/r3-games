| froger
| PHREDA 2025
|-------------------------
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/util/hash2d.r3
^r3/lib/sdl2gfx.r3
^r3/util/vscreen.r3

#filepath "r3/2025/canasta/"
:infile 'filepath "%s%s" sprint ;

#sprites
#ifondo

#fx 0 0
#obj 0 0
#xj #yj #ja
#btnpad
#vidas 3
#libres 0

| x y ang/z anim ss vx vy ar io
| 1 2 3   4    5  6  7  8  9
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.a 3 ncell+ ;
:.ani 4 ncell+ ;
:.ss 5 ncell+ ;
:.vx 6 ncell+ ;
:.vy 7 ncell+ ;
:.end 8 ncell+ ;
:.io 9 ncell+ ;

:drawspr | arr -- arr
	dup 8 + >a
	a@+ int. a@+ int. | x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	;
	
|------------------- fx
:fxobj | adr --
	drawspr
	|..... add velocity to position
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	dup .x @ -64.0 <? ( 2drop 0 ; ) drop
	drop
	;

:+fxobj | last ss anim zoom ang x y --
	'fxobj 'fx p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ a!+			| anim sheet
	swap a!+ a!+ 	| vx vy
	;
	
|------------------- obj
#choco

:sobj
	drawspr
	>a
	a> .vx @ a> .x +! a> .vy @ a> .y +!
	a> .x @ 
	-64.0 <? ( drop 0 ; ) 750.0 >? ( drop 0 ; ) 
	xj - abs 32.0 >? ( drop ; ) drop
	a> .y @ yj - abs 32.0 >? ( drop ; ) drop
	a> .vx @ 'choco ! | guarda direccion para tirar la vaca
	;
	
:+obj | vx vy ss anim zoom ang x y --
	'sobj 'obj p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ a!+			| anim sheet
	swap a!+ a!+ 	| vx vy
	0 a!				| last
	;

:+fruta
	0 
	3.0 randmax 2.0 +
	sprites
	7 randmax 1+ 	
	1 $ff ICS>anim 
	3.0 1.0 randmax
	600.0 randmax 100.0 +
	-32.0
	+obj ;
	
|----------------------------- jugador
|  x y anim 
#anim
#panim

:jugador
	drawspr	
	dup 'ja ! >a
	btnpad $f and 
	$1 and? ( 4.0 a> .x +! )
	$2 and? ( -4.0 a> .x +! )
	$4 and? ( 1.0 a> .y +! )
	$8 and? ( -1.0 a> .y +! )
	drop
	a> .x @ 'xj !
	a> .y @ 'yj !
	yj 64.0 <? ( drop 0 ; ) drop
	anim
	panim =? ( drop ; ) 
	dup 'panim !
	a> .ani !
	;	

:+jugador | 'per x y --
	'jugador 'obj p!+ >a
	swap a!+ a!+
	4.0 a!+ 
	0 a!+ 
	sprites a!
	;	

:nuevavaca
	1 'libres +!

	-3.0 0
	sprites 
	2 2 $ff ICS>anim
	1.0 0 xj yj 
	+fxobj | last ss anim zoom ang x y --
	
	320.0 440.0 +jugador ;
	
:perdiovaca
	-1 'vidas +!
	ja 'obj p.del
	
	choco 2* -1.9
	sprites 
	2 2 $ff ICS>anim
	1.0 0 xj yj 
	+fxobj | last ss anim zoom ang x y --
	
	440.0 'yj !
	320.0 440.0 +jugador 
	;
	
|------------------- juego

:hud
	0 0 bat vidas " %d" bprint2 bcr bcr
	600 0 bat libres "%d" bprint2 bcr bcr
	|yj xj "%f %f" bprint
	;
	
:juego
	vini
	0 sdlcls
	400 300 6.0 ifondo spritez
	timer.
	'obj p.draw
	'fx p.draw
	
	|sdlredraw
	vredraw
	sdlkey
	>esc< =? ( exit )
	<up> =? ( btnpad %1000 or 'btnpad ! )
	<dn> =? ( btnpad %100 or 'btnpad ! )
	<le> =? ( btnpad %10 or 'btnpad ! )
	<ri> =? ( btnpad %1 or 'btnpad ! )
	>up< =? ( btnpad %1000 nand 'btnpad ! )
	>dn< =? ( btnpad %100 nand 'btnpad ! )
	>le< =? ( btnpad %10 nand 'btnpad ! )
	>ri< =? ( btnpad %1 nand 'btnpad ! )
	
	<f1> =? ( +fruta )
	drop
	;

:reset
	'obj p.clear
	400.0 400.0 +jugador
	;
	
|-------------------
: |<<< BOOT <<<
	"canasta" 800 600 SDLinitR
	800 600 vscreen
	bfont1
	"fondo.png" infile loadimg 'ifondo !
	32 32 "canasta.png" infile ssload 'sprites !
	100 'obj p.ini
	100 'fx p.ini
	
	reset
	'juego SDLshow
	SDLquit 
	;

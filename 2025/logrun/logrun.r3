| logrun
| PHREDA 2025
|-------------------------
^r3/lib/sdl2gfx.r3
^r3/util/vscreen.r3
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/hash2d.r3
^r3/util/txfont.r3

#filepath "r3/2025/logrun/"
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
	xj - abs 32.0 >? ( drop ; ) drop
	
	a> .y @ 
	-64.0 <? ( drop 0 ; ) 750.0 >? ( drop 0 ; ) 
	yj - abs 32.0 >? ( drop ; ) drop
	
	a> .vx @ 'choco ! | guarda direccion para tirar la vaca
	;
	
:+obj | last ss anim zoom ang x y --
	'sobj 'obj p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ a!+			| anim sheet
	swap a!+ a!+ 	| vx vy
	0 a!				| last
	;

:+tabla
	0.0 -1.0
	sprites
	4 2 $ff ICS>anim
	2.0 0
	530.0 randmax 80.0 +
	510.0 
	+obj ;
	;
	
:+obstaculo
	2 randmax 0? ( drop +tabla ; ) drop
	0.0 1.0
	sprites
	6 2 $ff ICS>anim
	2.0 0
	
	330.0 randmax 80.0 +
	-30.0 
	+obj ;
	
	
|----------------------------- jugador
|  x y anim 
#anim
#panim

:jugador
	drawspr	
	dup 'ja ! >a
	btnpad $f and 
	$1 and? ( 1.0 a> .x +! )
	$2 and? ( -1.0 a> .x +! )
	$4 and? ( 1.0 a> .y +! )
	$8 and? ( -1.0 a> .y +! )
	drop
	a> .x @ 'xj !
	a> .y @ 'yj !
	xj 640.0 >? ( drop 0 ; ) drop
	anim
	panim =? ( drop ; ) 
	dup 'panim !
	a> .ani !
	;	

:+jugador | 'per x y --
	'jugador 'obj p!+ >a
	swap a!+ a!+
	1.0 a!+ 
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
	
	10.0 320.0 +jugador ;
	
:perdiovaca
	-1 'vidas +!
	ja 'obj p.del
	
	choco 2* -1.9
	sprites 
	2 2 $ff ICS>anim
	1.0 0 xj yj 
	+fxobj | last ss anim zoom ang x y --
	
	10.0 'xj !
	10.0 320.0 +jugador 
	;
	
|------------------- juego
:dfondo
	0 sdlcls
	|0 0 640 480 ifondo SDLImages
	;
	
:horda
	80 randmax 1? ( drop ; ) drop
	+obstaculo ;
	
:hud
	0 0 txat vidas " %d" txprint
	600 0 txat libres "%d" txprint
	|yj xj " %f %f" txprint
	;
	
:juego
	vini
	timer.
	dfondo
	0 'choco !
	2 'obj p.sort
	'obj p.draw
	'fx p.draw
	hud
	
	xj 640.0 >? ( nuevavaca ) drop
	choco 1? ( perdiovaca ) drop
	
	vredraw
	sdlkey
	>esc< =? ( exit )
	<up> =? ( btnpad %1000 or 'btnpad ! 2 2 $ff ICS>anim 'anim ! )
	<dn> =? ( btnpad %100 or 'btnpad ! 0 2 $ff ICS>anim 'anim ! )
	<le> =? ( btnpad %10 or 'btnpad ! 2 2 $ff ICS>anim 'anim ! )
	<ri> =? ( btnpad %1 or 'btnpad ! 0 2 $ff ICS>anim 'anim ! )
	>up< =? ( btnpad %1000 nand 'btnpad ! 2 0 $ff ICS>anim 'anim ! )
	>dn< =? ( btnpad %100 nand 'btnpad ! 0 0 $ff ICS>anim 'anim ! )
	>le< =? ( btnpad %10 nand 'btnpad ! 2 0 $ff ICS>anim 'anim ! )
	>ri< =? ( btnpad %1 nand 'btnpad ! 0 0 $ff ICS>anim 'anim ! )
	drop
	horda
	;

:reset
	'obj p.clear
	20.0 240.0 +jugador
	;
|-------------------
: |<<< BOOT <<<
	"LogRun" 640 480 SDLinitr
	640 480 vscreen
	
	"media/ttf/roboto-bold.ttf" 24 txload txfont
	
	"fondo.png" infile loadimg 'ifondo !
	32 32 "logrun.png" infile ssload 'sprites !
	100 'obj p.ini
	100 'fx p.ini
	
	reset
	'juego SDLshow
	vfree
	SDLquit 
	;

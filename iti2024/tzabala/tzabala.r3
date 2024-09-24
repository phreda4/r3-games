| teniente zabala
| PHREDA 2024
|-------------------------
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/bfont.r3
^r3/util/hash2d.r3
^r3/lib/sdl2gfx.r3

#sprites
#ifondo

#fx 0 0
#obj 0 0

#btnpad
#xvp #yvp

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
	a@+ int. xvp -
	a@+ int. yvp - 
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	;

|------------------- fx
:fxobj | adr --
	dup .ani @ anim>n 
	over .end @ 
	=? ( 2drop 0 ; ) drop 
	drawspr
	|..... add velocity to position
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	drop
	;

:+fxobj | last ss anim zoom ang x y --
	'fxobj 'fx p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	a!				| last
	;
	

|------------------- enemigos
:enemigo
	drawspr 
	
	dup 'obj p.nro $4000 or | enemigo
	14
	pick2 .x @ int. 
	pick3 .y @ int. h2d+!	
	
	drop ;
	
:+enemigo | a x y --
	'enemigo 'obj p!+ >a
	swap a!+ a!+
	1.0 a!+ | ang zoom
	
	17 3 $3f ICS>anim | 0 4
	a!+
	sprites a!+
	0 a!+ 0 a!+
	a!+ | tipo
	;

|-------------- mapa estatico
#listaobs ( 13 14 15 16 ) 

:staticobj
	drawspr 
	
	dup 'obj p.nro $2000 or | pared
	14 
	pick2 .x @ int. 
	pick3 .y @ int. h2d+!	
	
	drop ;

:+estatico | o x y --
	a[
	'staticobj 'obj p!+ >a
	swap a!+ a!+	| x y 
	2.0 a!+	| ang zoom
	1- 'listaobs + c@
	0 $ff ICS>anim
	a!+ sprites a!+			| anim sheet
	]a
	;
	
	
#btna
#xj #yj #aj
#dx #dy #ang

|------------------- disparo
:odisparo
	|dup .ani @ anim>n 
	|over .end @ =? ( 2drop 0 ; ) drop 
	drawspr
	|..... add velocity to position
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	
	dup .x @ int. xvp - -10 <? ( 2drop 0 ; ) sw 10 + >? ( 2drop 0 ; ) drop
	dup .y @ int. yvp - -10 <? ( 2drop 0 ; ) sh 10 + >? ( 2drop 0 ; ) drop
	
	dup 'obj p.nro $1000 or | disparo
	8 
	pick2 .x @ int. 
	pick3 .y @ int. 10 + h2d+!	
	drop
	
	;
	
:+odisparo | last anim zoom ang x y --
	'odisparo 'obj p!+ >a
	swap a!+ a!+	| x y 
	32 << or a!+	| ang zoom
	a!+ sprites a!+			| anim sheet
	swap a!+ a!+ 	| vx vy
	a!
	;

:dirdis
	0 'dx ! 0 'dy ! 0 'ang !
	btna
	$1 and? ( 8.0 'dx ! 0.25 'ang +! )
	$2 and? ( -8.0 'dx ! -0.25 'ang +! )
	$4 and? (  8.0 'dy ! )
	$8 and? ( -8.0 'dy ! )
	drop
	;

	
:+disparo
	btnpad $10 and? ( drop ; ) drop
	dirdis	
	0
	dx dy
	12 0 $ff ICS>anim
	1.0 ang
	xj yj
	+odisparo 
	;
	
|----------------------------- jugador
#basex 320
#basey 340

|  x y anim 
:setvp
	xj int. basex - 'xvp !
	yj int. basey - 'yvp !
	;
	
:anim!
	a> .ani dup @ $ffffffff and rot or swap ! ;
	
:jugador
	drawspr	
	>a 
	a> 'aj ! a> .x @ 'xj ! a> .y @ 'yj !
	
	btnpad $f and 
	$1 and? ( 1.0 a> .x +! 8 2 $ff ICS>anim anim! )
	$2 and? ( -1.0 a> .x +! 10 2 $ff ICS>anim anim! )
	$4 and? ( 1.0 a> .y +! 4 2 $ff ICS>anim anim! )
	$8 and? ( -1.0 a> .y +! 6 2 $ff ICS>anim anim! )
	1? ( dup 'btna ! )
	drop
	0 16 a> .x @ int. a> .y @ int. 10 + h2d+! | jugador
	
	setvp
	;	

:+jugador | x y --
	'jugador 'obj p!+ >a
	swap a!+ a!+
	2.0 a!+ 
	6 1 $ff ICS>anim a!+ 
	sprites a!+
	;	
	
|------------ colision
:hitobj | nro --
	'obj p.adr
	dup .a @ 
	|0 =? ( ) | escopeta
|	3 =? ( 5 'balas +! ) | balas 
|	4 =? ( 1 'celu +! ) | celu
|	5 =? ( 1 'llaves +! ) | llaves
	drop
	'obj p.del
	;
:noavanza
	xj aj .x ! yj aj .y ! ;
	
:hitplayer
	$1000 and? ( drop ; ) | disparo
	$2000 and? ( drop noavanza ; ) | pared
|	$4000 and? ( drop -1 'vidas +! ; ) | enemigo	
	drop |??
	;
		
:hitdisp
	$fff and 'obj p.adr 'obj p.del | borra bala
	$2000 and? ( drop ; )
	$4000 and? ( $fff and 'obj p.adr 'obj p.del ; ) | borra enemigo
	drop
	;
	
:2sort | a b -- a b
	over <? ( ; ) swap ; 
	
:hitobj | obj1 obj2 --
	2sort
	0? ( drop hitplayer ; ) 
	$1000 and? ( hitdisp ; )
	2drop |	" %h %h " bprint
	;
	
:colisiones	
	H2d.list 
	( 1? swap
		d@+ dup 16 >> $ffff and swap $ffff and 
		hitobj
		swap 1- ) 2drop ;
		
|------------------- juego
:dfondo
	$C9BE6F sdlcls
|	0 0 640 480 ifondo SDLImages
	;
	
:juego
	timer.
	
	H2d.clear
	
	dfondo
	2 'obj p.sort
	'obj p.draw

	colisiones
	
	sdlredraw
	sdlkey
	>esc< =? ( exit )
	<up> =? ( btnpad $8 or 'btnpad ! )
	<dn> =? ( btnpad $4 or 'btnpad ! )
	<le> =? ( btnpad $2 or 'btnpad ! )
	<ri> =? ( btnpad $1 or 'btnpad ! )
	>up< =? ( btnpad $8 nand 'btnpad ! )
	>dn< =? ( btnpad $4 nand 'btnpad ! )
	>le< =? ( btnpad $2 nand 'btnpad ! )
	>ri< =? ( btnpad $1 nand 'btnpad ! )	
	<z> =? ( +disparo btnpad $10 or 'btnpad ! )
	>z< =? ( btnpad $10 nand 'btnpad ! )
	<f1> =? (
			0
			|16 randmax 0 $ff ICS>anim
			540.0 randmax 50.0 +
			380.0 randmax 50.0 + +enemigo )
	drop
	;
	
|------------- mapa
| x y
#obstaculos
1 -100 50 
1 100 50
2 -80 100
2 80 100
3 -80 300
3 80 300
4 -80 500
4 80 500
0

:objmapa
	'obstaculos >a
	( a@+ 1?
		basex a@+ + fix. 
		basey a@+ - fix. +estatico
		) drop  ;

	
:reset
	'obj p.clear
	basex fix. basey fix. +jugador
	0 0 'yvp ! 'xvp ! 
	objmapa
	;
	
|-------------------
: |<<< BOOT <<<
	"Teniente Zabala" 640 480 SDLinit
	bfont1
	"r3\iti2024\tzabala\fondo.png" loadimg 'ifondo !
	32 32 "r3\iti2024\tzabala\sprites.png" ssload 'sprites !
	100 'obj p.ini
	500 H2d.ini 
	$fff 'here +! | lista de contactos
	reset
	'juego SDLshow
	SDLquit 
	;

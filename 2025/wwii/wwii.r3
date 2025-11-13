| teniente zabala
| PHREDA 2024
|-------------------------
^r3/lib/rand.r3
^r3/util/arr16.r3
^r3/util/hash2d.r3
^r3/lib/sdl2gfx.r3
^r3/util/vscreen.r3
^./mapawwii.r3

#sprjug
#sprobj
#sprfx

#fx 0 0
#obj 0 0

#btnpad
#xvp #yvp

#basex 1000.0
#basey 20600.0

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
:.z	10 ncell+ ;
:.vz 11 ncell+ ;

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

:+explo | x y --
	'fxobj 'fx p!+ >a
	swap a!+ a!+
	2.0 a!+
	0 12 $7f ICS>anim a!+ | 0 4
	sprfx a!+
	0 a!+ -1.0 a!+
	11 a!
	;
	
|------------------- enemigos
:enemigo
	drawspr 
	
	dup 'obj p.nro $4000 or | enemigo
	14
	pick2 .x @ int. 
	pick3 .y @ int. h2d+!	

	dup .vx @ over .x +!
	dup .vy @ over .y +!
	
	drop ;
	
:+enemigo | a x y --
	'enemigo 'obj p!+ >a
	swap a!+ a!+
	2.0 a!+ | ang zoom
	
	8 2 $3f ICS>anim | 0 4
	a!+
	sprjug a!+
	2.0 randmax 1.0 - a!+ 
	2.0 randmax 1.0 - a!+
	a!+ | tipo
	;

#btna
#xj #yj #aj
#dx #dy #ang

:drawgrana | arr -- arr
	dup 8 + >a
	a@+ int. xvp -
	a@+ int. yvp - 
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	pick4 .z @ 8 >> +
	|a@ timer+ dup a!+ anim>n 			| n
	a@+ $1 and 12 +
	a@+ sspriterz
	
	dup 8 + >a
	a@+ int. xvp -
	a@+ int. yvp - 
	pick2 .z @ int. -
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	;

|------------------- disparo
:odisparo
	|dup .ani @ anim>n 
	|over .end @ =? ( 2drop 0 ; ) drop 
	drawgrana
	|..... add velocity to position
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	dup .vz @ over .z +!
	-0.06 over .vz +!
	dup .z @ -? ( drop dup .x @ swap .y @ +explo 0 ; ) drop
	
	|dup .x @ int. xvp - -10 <? ( 2drop 0 ; ) sw 10 + >? ( 2drop 0 ; ) drop
	|dup .y @ int. yvp - -10 <? ( 2drop 0 ; ) sh 10 + >? ( 2drop 0 ; ) drop
	
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
	a!+ sprfx a!+	| anim sheet
	swap a!+ a!+ 	| vx vy
	a!+ 0 a!+
	0 a!+ | z
	3.0 2.0 randmax +
	a!	| vz
	;

:dirdis
	0 'dx ! -1.0 'dy ! 0 'ang !
	btna
	$1 and? ( 1.0 'dx ! 0.25 'ang +! )
	$2 and? ( -1.0 'dx ! -0.25 'ang +! )
	$4 and? (  1.0 'dy ! )
	$8 and? ( -1.0 'dy ! )
	drop
	;

	
:+disparo
	btnpad $10 and? ( drop ; ) drop
	dirdis	
	0
	dx 2* dy 2*
	11 1 $ff ICS>anim
	1.0 ang
	xj yj 20.0 -
	+odisparo 
	;
	
|----------------------------- jugador

|  x y anim 
	
:anim!
	a> .ani dup @ $ffffffff and rot or swap ! ;
	
:jugador
	drawspr	
	>a 
	a> 'aj ! a> .x @ 'xj ! a> .y @ 'yj !
	
	btnpad $f and 
	$1 and? ( 1.8 a> .x +! 	4 2 $ff ICS>anim anim! )
	$2 and? ( -1.8 a> .x +!	6 2 $ff ICS>anim anim! )
	$4 and? ( 1.8 a> .y +! 	2 2 $ff ICS>anim anim! )
	$8 and? ( -1.8 a> .y +!	0 2 $ff ICS>anim anim! )
	1? ( dup 'btna ! )
	drop
	0 16 a> .x @ int. a> .y @ int. 10 + h2d+! | jugador
	;	

:+jugador | x y --
	'jugador 'obj p!+ >a
	swap a!+ a!+
	2.0 a!+ 
	6 1 $ff ICS>anim a!+ 
	sprjug a!+
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
	xj int. sw 2/ - 'xvp !
	yj int. sh 2/ - 'yvp !
	
	18 11
	xvp 6 >> yvp 6 >>
	xvp $3f and neg 
	yvp $3f and neg	
	$3f $3f
	'mapa tiledraws ;
	
:juego
	vini
	timer.
	
	H2d.clear
	
	dfondo
	2 'obj p.sort
	'obj p.draw
	'fx p.draw
	colisiones
	
	vredraw
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
			|540.0 randmax 50.0 +
			|380.0 randmax 50.0 + 
			xj yj +enemigo )
	<f2> =? ( xj yj +explo )
	drop
	;
	

	
:reset
	'obj p.clear
	basex basey +jugador
	|0 0 'yvp ! 'xvp ! 
	|objmapa
	;
	
|-------------------
#filepath "r3/2025/wwii/"
:infile 'filepath "%s%s" sprint ;

: |<<< BOOT <<<
	"wwii" 1024 600 SDLinitr
	1024 600 vscreen
	makemap
	38 38 "sprites.png" infile ssload 'sprjug !
	80 64 "obj.png" infile ssload 'sprobj !
	32 32 "fx.png" infile ssload 'sprfx !
	
	1000 'obj p.ini
	100 'fx p.ini	
	500 H2d.ini 
	$fff 'here +! | lista de contactos
	reset
	'juego SDLshow
	vfree
	SDLquit 
	;

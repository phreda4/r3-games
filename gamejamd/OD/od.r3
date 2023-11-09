^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/lib/rand.r3
^r3/util/bfont.r3
^r3/util/arr16.r3
				
#sprites		| hoja de sprites

#spravion
#sprbomba

#puntos 0
#vidas 3

#x 500.0 #y 100.0
#xv 0 #yv 0

#listalien 0 0 | lista de aliens
#listshoot 0 0 | lista de disparos
#listfx 0 0 | fx

:objsprite | adr -- adr
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ 				| zoom
	a@ timer+ dup a!+ 	| anima
	nanim a@+ sspritez
	dup 40 + @ over +!		| vx
	dup 48 + @ over 8 + +!	| vy
	;

|--------------- fx	
:explosion
	objsprite	
	24 + @ nanim 10 =? ( drop 0 ; )
	drop
	;

:+explo	| y x --
	'explosion 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	2.0 a!+			| zoom
	7 5 6 vci>anim | vel cnt ini 
	a!+	sprites a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy	
	;

|--------------- Jugador
:jugador
	x int. y int. 0 1.0 spravion SDLspriteRZ 
	xv 'x +! yv 'y +! 
	;

:pierdevida
	-1 'vidas +!
	vidas 0? ( exit ) drop
|	320.0 'x ! 380.0 'y !
	;
	
|-------------- Disparo	
#hit
:choque?  | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	dup 'listalien p.del
	1 'puntos +!
	0 'hit !
	pick4 pick4 +explo
	;
	
:bala | v -- 

	dup >a
	a@+ int. a@+ int.	| x y
	a@+ a@+				| zoom
	sprbomba SDLspriteRZ 
	dup 40 + @ over +!		| vx
	dup 48 + @ over 8 + +!	| vy
	0.02 over 48 + +!
	0.001 over 16 + +!

	1 'hit !
	dup @ |-20.0 <? ( 2drop 0 ; ) 660.0 >? ( 2drop 0 ; ) ; fuera de pantalla
	over 8 + @ 800.0 >? ( 3drop 0 ; ) |500.0 >? ( 3drop 0 ; ) ; fuera de pantalla
|	'choque? 'listalien p.mapv | 'vector list --	
	2drop
	hit 0? ( nip ; ) drop
	drop
	;

:+disparo
	'bala 'listshoot p!+ >a 
	x 30.0 + a!+ y 60.0 + a!+	| x y 
	0 a!+ 1.0 a!+	| zoom
	0 a!+
	0 a!+ 0.0 a!+ 	| vx vy
	;
	
|-------------- Alien	
:alien | v -- 
	objsprite	
	
	dup @ x - 
	over 8 + @ 
	500.0 >? ( 3drop 0 ; ) | llego abajo?
	y - distfast
|	30.0 <? ( pierdevida ) 
	drop
	drop
	;

:+alien
	'alien 'listalien p!+ >a 
	500.0 randmax 70.0 + a!+ 
	-16.0 a!+
	2.0 a!+	| zoom
	7 4 2 vci>anim | vel cnt ini 
	a!+	sprites a!+			| anim sheet
	2.0 randmax 1.0 - 
	a!+ 2.0 a!+ 	| vx vy
	;

:horda
	50 randmax 1? ( drop ; ) drop
	+alien
	;
|------------- fondo de estrellas
#buffer * 1024			| lugar para guardar las coordenadas
#buffer> 'buffer

:+estrella | x y –
	buffer> w!+ w!+ 'buffer> ! ;

:.estrellas
	$ffffff sdlColor
	'buffer ( buffer> <?
		w@+ swap
		over 1 + sh >? ( 0 nip ) 
		over 2 - w!
		w@+ rot
		SDLPoint ) drop ;

:llenaestrellas
	256 ( 1? 1 -
		sw randmax sh randmax +estrella
		) drop ;

|-------------- Juego
:juego
	$f SDLcls
	timer.
|	.estrellas 
	'listalien p.draw
	'listshoot p.draw
	'listfx p.draw
	jugador	
|	horda
	
	10 8 bat puntos "puntos:%d" sprint bprint
	10 24 bat vidas "vidas:%d" sprint bprint
	SDLredraw

	SDLkey 
	>esc< =? ( exit )
	<le> =? ( -1.0 'xv ! ) >le< =? ( 0 'xv ! )
	<ri> =? ( 1.0 'xv ! ) >ri< =? ( 0 'xv ! )
	<up> =? ( -1.0 'yv ! ) >up< =? ( 0 'yv ! )
	<dn> =? ( 1.0 'yv ! ) >dn< =? ( 0 'yv ! )

	<esp> =? ( +disparo )
	drop ;

:jugar 
	'listalien p.clear
	'listshoot p.clear
	'listfx p.clear
	0 'puntos ! 3 'vidas !
	500.0 'x ! 100.0 'y !
	'juego SDLShow ;
	

:main
	"od" 1024 600 SDLinit
	bfont1 
	16 16 "media/img/manual.png" ssload 'sprites !	
	"r3/gamejamd/od/b52.png" loadimg 'spravion !
	"r3/gamejamd/od/bomba.png" loadimg 'sprbomba !

	llenaestrellas
	200 'listalien p.ini
	200 'listshoot p.ini
	200 'listfx p.ini
	timer<
	jugar
	SDLquit ;	
	
: main ;

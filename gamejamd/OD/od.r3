^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/lib/rand.r3
^r3/util/bfont.r3
^r3/util/arr16.r3
				
#nubes		| hoja de sprites
#explo		| hoja de sprites

#spravion
#sprbomba

#x 500.0 #y 100.0
#xv 0 #yv 0

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
:nube
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ 				| n
	nubes ssprite
	dup 24 + @ over +!		| vx
	dup 32 + @ over 8 + +!	| vy
	
	dup @ -400.0 <? ( 1400.0 pick2 ! ) drop
	drop
	;

:+nube	| vx vy n x y --
	'nube 'listfx p!+ >a 
	swap a!+ a!+	| x y 
	a!+ 
	swap a!+ a!+
	;

:cielo
	50 ( 1? 1 -
		0.5 randmax 0.7 -
		0.1 randmax 0.05 -
		25 randmax 
		1800.0 randmax 400.0 -
		600.0 randmax 
		+nube
		) drop ;
		
:nuke
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ int.			| n
	explo ssprite
	0.05 over 16 + +!
	dup 16 + @ int. 4 =? ( 2drop 0 ; )
	2drop
	;
	
:+explo | x y --
	'nuke 'listfx p!+ >a 
	swap a!+ 150.0 - a!+	| x y 
	0 a!
	;

		
|--------------- Jugador
:jugador
	x int. y int. 0 1.0 spravion SDLspriteRZ 
	xv 'x +! yv 'y +! 
	;

|-------------- Disparo	
:bomba | v -- 
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ a@+				| zoom
	sprbomba SDLspriteRZ 
	dup 40 + @ over +!		| vx
	dup 48 + @ over 8 + +!	| vy
	0.02 over 48 + +!		| gravedad
	0.001 over 16 + +!		| rotacion
	
	dup 8 + @ 700.0 >? ( drop @+ swap @ +explo 0 ; ) 
	2drop
	;

:+disparo
	'bomba 'listshoot p!+ >a 
	x 30.0 + a!+ y 60.0 + a!+	| x y 
	0 a!+ 1.0 a!+	| rotacion zoom
	0 a!+			|
	0 a!+ 0.0 a!+ 	| vx vy
	;
	
|-------------- Juego
:juego
	$f0f3f SDLcls
	timer.
	'listfx p.draw
	'listshoot p.draw	
	jugador	
	SDLredraw

	SDLkey 
	>esc< =? ( exit )
	<le> =? ( -0.5 'xv ! ) >le< =? ( 0 'xv ! )
	<ri> =? ( 0.5 'xv ! ) >ri< =? ( 0 'xv ! )
	<up> =? ( -0.5 'yv ! ) >up< =? ( 0 'yv ! )
	<dn> =? ( 0.5 'yv ! ) >dn< =? ( 0 'yv ! )

	<esp> =? ( +disparo )
	drop ;

:jugar 
	'listshoot p.clear
	'listfx p.clear
	500.0 'x ! 100.0 'y !
	cielo
	'juego SDLShow ;

:main
	"od" 1024 600 SDLinit
	384 237 "r3/gamejamd/od/nubes.png" ssload 'nubes !	
	384 360 "r3/gamejamd/od/explo.png" ssload 'explo !
	"r3/gamejamd/od/b52.png" loadimg 'spravion !
	"r3/gamejamd/od/bomba.png" loadimg 'sprbomba !

	200 'listshoot p.ini
	200 'listfx p.ini
	timer<
	jugar
	SDLquit ;	
	
: main ;

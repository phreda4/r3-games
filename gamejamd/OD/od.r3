^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/lib/rand.r3
^r3/util/bfont.r3
^r3/util/arr16.r3
				
#sprites		| hoja de sprites

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

|-------------- Disparo	
:bala | v -- 
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ a@+				| zoom
	sprbomba SDLspriteRZ 
	dup 40 + @ over +!		| vx
	dup 48 + @ over 8 + +!	| vy
	0.02 over 48 + +!
	0.001 over 16 + +!
	drop
	;

:+disparo
	'bala 'listshoot p!+ >a 
	x 30.0 + a!+ y 60.0 + a!+	| x y 
	0 a!+ 1.0 a!+	| zoom
	0 a!+
	0 a!+ 0.0 a!+ 	| vx vy
	;
	
|-------------- Juego
:juego
	$f0f3f SDLcls
	timer.
	'listshoot p.draw
	'listfx p.draw
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
	'juego SDLShow ;

:main
	"od" 1024 600 SDLinit
|	16 16 "media/img/manual.png" ssload 'sprites !	
	"r3/gamejamd/od/b52.png" loadimg 'spravion !
	"r3/gamejamd/od/bomba.png" loadimg 'sprbomba !

	200 'listshoot p.ini
	200 'listfx p.ini
	timer<
	jugar
	SDLquit ;	
	
: main ;

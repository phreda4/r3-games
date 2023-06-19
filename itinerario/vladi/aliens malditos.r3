^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/arr16.r3

#tsnave	| dibujo
#aninave 0	| frame maximo
#xp 400.0 #yp 560.0		| posicion
#xv #yv		| velocidad

#fx 0 0
#disparos 0 0 
#enemis 0 0

|.... time control
#prevt
#dtime

:timeI msec 'prevt ! 0 'dtime ! ;
:time. msec dup prevt - 'dtime ! 'prevt ! ;
:time+ dtime + $ffffff7fffffffff and  ;

| anima
| $fff ( 4k sprites) $ff (256 movs) $f (vel) ffffffffff (time)

:nanim | nanim -- n
	dup |$ffffffffff and 
	over 40 >> $f and 48 + << 1 >>>
	over 44 >> $ff and 63 *>>
	swap 52 >>> + | ini
	;
	
:vni>anim | vel cnt ini -- nanim 
	$fff and 52 << swap
	$ff and 44 << or swap
	$f and 40 << or 
	;

:objsprite | adr -- adr
	dup >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ time+ dup a!+ nanim 			| n
	a@+ sspriterz
	dup 40 + @ over +!
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	;
		
#fondo

:explosion
	objsprite	
	24 + @ nanim 36 =? ( drop 0 ; )
	drop
	;

:+explo	| y x --
	'explosion 'fx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+	| ang zoom
	6 16 22 vni>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!			| vrz
	;

:exploplayer
	objsprite
	24 + @ nanim 20 =? ( drop 0 exit ; )
	drop
	;

#muerte 
:+explon | --
	1 'muerte !
	'exploplayer 'fx p!+ >a 
	xp a!+ yp a!+	| x y 
	2.0 a!+	| ang zoom
	6 20 4 vni>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!			| vrz
	;

#hit
:choque  | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	dup 'enemis p.del
|	pick4 pick4 +fx
|	1 'puntos +!
|	1 playsnd
	0 'hit !
	pick4 pick4 +explo
	;

|disparo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:bala | v -- 
	objsprite
	
	1 'hit !
	dup @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	'choque 'enemis p.mapv | 'vector list --	
	2drop
	hit 0? ( nip ; ) drop
	drop
	;

:+disparo
	'bala 'disparos p!+ >a 
	xp a!+ 560.0 a!+	| x y 
	0.75 a!+	| ang zoom
	7 2 37 vni>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	0 a!+ -3.0 a!+ 	| vx vy
	0.1 32 << a!			| vrz
	;

	
:alien | v -- 
	objsprite	
	|..... remove when outside screen
	dup @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	30.0 <? ( +explon ) drop
	drop
	;

:+marciano
	'alien 'enemis p!+ >a 
	|800.0 randmax 
	600.0 randmax 100.0 + a!+ -100.0 a!+ |alien  x y 
	1.0 a!+	| ang zoom
	7 2 20 vni>anim | vel cnt ini 
	a!+	tsnave a!+			| anim sheet
	2.0 randmax 1.0 - 
	a!+ 3.0 a!+ 	| vx vy
	0 a!		
	;

:jugador
	SDLkey
	>esc< =? ( exit )
	<le> =? ( -3.0 'xv ! )
	>le< =? ( 0 'xv ! )
	<ri> =? ( 3.0 'xv ! )
	>ri< =? ( 0 'xv ! )	
	<esp> =? ( +disparo )
	drop 

	muerte 1? ( drop ; ) drop
	xp int. yp int. 
	2.0 
	aninave time+ dup 'aninave ! nanim
	tsnave sspritez	

	xv 'xp +!
	yv 'yp +!

	;
	
:horda
	50 randmax 1? ( drop ; ) drop
	+marciano
	;
	
:demo
	0 0 fondo SDLImage 
	time.
	'disparos p.draw
	jugador	
	'enemis p.draw	
	'fx p.draw
	
	SDLredraw
	horda
	;
	
:main
	"r3sdl" 800 600 SDLinit
	32 32 "r3/itinerario/vladi/nave y alien.png" ssload 'tsnave !
	"r3/itinerario/vladi/fondo.png" loadimg 'fondo !
	200 'disparos p.ini
	100 'enemis p.ini
	200 'fx p.ini 
	8 4 0 vni>anim 'aninave !
	timeI
	'demo SDLshow
	SDLquit ;	
: main ;
| Animation example
^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/arr16.r3

#fondo
#npc 0 0
#disparos 0 0

#sprjuego	| dibujo
#xp 400.0 #yp 95.0		| posicion
#xv #yv		| velocidad
#anima 0	| frame maximo

|.... time control
#prevt
#dtime

:timeI msec 'prevt ! 0 'dtime ! ;
:time. msec dup prevt - 'dtime ! 'prevt ! ;
:time+ dtime + $ffffff7fffffffff and  ;

| anima
| $fff ( 4k sprites) $ff (256 movs) $f (vel) ffffffffff (time)

:nanim | nanim -- n
	dup $ffffffffff and 
	over 40 >> $f and 48 + << 1 >>>
	over 44 >> $ff and 63 *>>
	swap 52 >>> + | ini
	;
	
:vni>anim | vel cnt ini -- nanim 
	$fff and 52 << swap
	$ff and 44 << or swap
	$f and 40 << or 
	;

| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56

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

#hit
:choque  | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	dup 'npc p.del
|	pick4 pick4 +fx
|	1 'puntos +!
|	1 playsnd
	0 'hit !
	;

|disparo
	
:vomito | v -- 
	objsprite
	1 'hit !
	dup @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 410.0 between -? ( 4drop 0 ; ) drop
	'choque 'npc p.mapv | 'vector list --	
	2drop
	hit 0? ( nip ; ) drop
	drop
	;

:+disparo
	'vomito 'disparos p!+ >a 
	xp a!+ yp 32.0 + a!+	| x y 
	2.0 a!+	| ang zoom
	4 8 40 vni>anim | vel cnt ini 
	a!+	sprjuego a!+			| anim sheet
	0 a!+ 2.0 a!+ 	| vx vy
	0 a!			| vrz
	;

:victima | v -- 
	objsprite	
|	1 'hit !
	dup @+ dup -35.0 835.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
|	'choque 'npc p.mapv | 'vector list --	
	2drop
|	hit 0? ( nip ; ) drop
	drop
	;

:+npcl
	832.0 a!+ 
	350.0 60.0 randmax + a!+	| x y 
	2.5 a!+	| ang zoom
	7 4
	4 randmax 3 << 12 +
	vni>anim | vel cnt ini 
	a!+	sprjuego a!+			| anim sheet
	-0.7 0.2 randmax - a!+ 0.0 a!+ 	| vx vy
	0 a!			| vrz
	;

:+npc
	'victima 'npc p!+ >a 
	rand $1000 and? ( drop +npcl ; ) drop
	-32.0 a!+ 
	350.0 60.0 randmax + a!+	| x y 
	2.5 a!+	| ang zoom
	7 4
	4 randmax 3 << 8 +
	vni>anim | vel cnt ini 
	a!+	sprjuego a!+			| anim sheet
	0.7 0.2 randmax + a!+ 0.0 a!+ 	| vx vy
	0 a!			| vrz
	;
	
:horda
	40 randmax 1? ( drop ; ) drop
	+npc
	;
	
#disp 0	
:normal
	8 2 0 vni>anim 'anima !	;	
:lanza
	disp 1? ( drop ; ) drop
	1 'disp !
	7 6 2 vni>anim 'anima !	;
:lanzav
	0 'disp !
	+disparo
	8 2 0 vni>anim 'anima !	;

		
:jugador
	xp int. yp int. 3.0 
	anima time+ dup 'anima ! nanim
	sprjuego sspritez	

	anima nanim 7 =? ( lanzav ) drop
	
	xv 'xp +!
	yv 'yp +!

	SDLkey
	>esc< =? ( exit )
	
	<a> =? ( -1.5 'xv ! )
	>a< =? ( 0 'xv ! )
	
	<d> =? ( 1.5 'xv ! )
	>d< =? ( 0 'xv ! )	
	
	<esp> =? ( lanza )
	drop ;


:demo
	0 0 fondo SDLImage 
	time.
	jugador
	'npc p.draw	
	2 'npc p.sort
	'disparos p.draw	
	horda
	SDLredraw
	;
	
:main
	"r3sdl" 800 600 SDLinit
	32 32 "r3/itinerario/sssanti/hojajuego.png" ssload 'sprjuego !
	"r3/itinerario/sssanti/fondo.png" loadimg 'fondo !
	100 'disparos p.ini
	100 'npc p.ini
	normal
	timeI

	'demo SDLshow
	SDLquit ;	
	
: main ;
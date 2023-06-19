| Nave vs. Pulpo
^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/arr16.r3

#fondo
#tsguy	| dibujo
#xp 100.0 #yp 460.0		| posicion
#xv #yv		| velocidad

#enemigos 0 0 
#disparos 0 0 
#fx 0 0

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
	
	
#hit
:choque  | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	dup 'enemigos p.del
|	pick4 pick4 +fx
|	1 'puntos +!
|	1 playsnd
	0 'hit !
	;
 
 |disparo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:bala | v -- 
	objsprite	
	|..... remove when outside screen
	1 'hit !
	dup @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -20.0 616.0 between -? ( 4drop 0 ; ) drop
	'choque 'enemigos p.mapv | 'vector list --	
	2drop
	hit 0? ( nip ; ) drop
	drop
	;

:+disparo
	'bala 'disparos p!+ >a 
	xp a!+ yp 16.0 - a!+	| x y 
	6.0 a!+	| ang zoom
	7 0 30 vni>anim | vel cnt ini 
	a!+	tsguy a!+			| anim sheet
	0 a!+ -5.0 a!+ 	| vx vy
	0.0 32 << a!			| vrz
	;
 
 
:explosion
	objsprite
	24 + @ nanim 37 =? ( drop 0 ; )
	drop
	;

:+explo	| y x --
	'explosion 'fx p!+ >a 
	swap a!+ a!+	| x y 
	3.0 a!+	| ang zoom
	6 45 31 vni>anim | vel cnt ini 
	a!+	tsguy a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!			| vrz
	;

:exploplayer
	objsprite
	24 + @ nanim 23 =? ( drop 0 exit ; )
	drop
	;

#muerte 
:+explon | --
	1 'muerte !
	'exploplayer 'fx p!+ >a 
	xp a!+ yp a!+	| x y 
	2.0 a!+	| ang zoom
	6 22 1 vni>anim | vel cnt ini 
	a!+	tsguy a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!			| vrz
	;
	

 
|Pulpo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:pulpo | v -- 
	objsprite	
	|..... remove when outside screen
	dup @+ dup -30.0 830.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -20.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	30.0 <? ( exit ) drop
	
	90 randmax 0? ( over 40 + dup @ neg swap ! ) drop
	drop
	;

:+pulpo
	'pulpo 'enemigos p!+ >a 
	700.0 randmax 50.0 + a!+ -10.0 a!+	| x y 
	3.0 a!+	| ang zoom
	7 2 24 vni>anim | vel cnt ini 
	a!+	tsguy a!+			| anim sheet
	6.0 randmax 1.0 - a!+	| vx
	1.0 randmax 0.8 + a!+ 	| vy
	0.000 32 << a!			| vrz
	;
	
:horda
	20 randmax 1? ( drop ; ) drop
	+pulpo
	;

:teclado
	SDLkey
	>esc< =? ( exit )
	<a> =? ( -2.0 'xv ! )	>a< =? ( 0 'xv ! )
	<d> =? ( 2.0 'xv ! )	>d< =? ( 0 'xv ! )
    <LE> =? ( -2.0 'xv ! )	>LE< =? ( 0 'xv ! )
	<RI> =? ( 2.0 'xv ! )	>RI< =? ( 0 'xv ! )
	<UP> =? ( -2.0 'yv ! )	>UP< =? ( 0 'yv ! )
	<DN> =? ( 2.0 'yv ! )	>DN< =? ( 0 'yv ! )
	<w> =? ( -2.0 'yv ! )	>w< =? ( 0 'yv ! )
	<s> =? ( 2.0 'yv ! )	>s< =? ( 0 'yv ! )
	<esp> =? ( +disparo )
	drop ;
	
:demo
|	0 SDLcls
	0 0 fondo SDLImage 

	time.
	'enemigos p.draw
	'disparos p.draw
	'fx p.draw
	xp int. yp int. 3.0 0 tsguy sspritez	
	
	SDLredraw
	
	xv 'xp +!
	yv 'yp +!
	
	teclado
	horda
	;
	
:main
	"r3sdl" 800 600 SDLinit
	32 32 "r3/itinerario/lauti/completojuego.png" ssload 'tsguy !
	"r3/itinerario/lauti/fondo.png" loadimg 'fondo !
	200 'fx p.ini 
	100 'enemigos p.ini
	100 'disparos p.ini
	timeI
	'demo SDLshow
	SDLquit ;	
	
: main ;
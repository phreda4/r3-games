| Animation example
^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/arr16.r3

#fondo1
#fondo2
#fondo3

#arcoiris 0 0 
#frutas 0 0

#tsguy	| dibujo
#xp 400.0 #yp 400.0		| posicion
#xv #yv		| velocidad
#animacion

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
	
|--------------- ARCOIRIS	
|disparo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:estela | v -- 
	objsprite
	|..... remove when outside screen
	dup @+ dup -17.0 827.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	2drop
	drop
	;

#alterna 
:+estela
	'estela 'arcoiris p!+ >a 
	360.0 a!+ yp 10.0 + alterna + a!+	| x y 
	1.0 a!+	| ang zoom
	0 0 0 vni>anim | vel cnt ini 
	a!+	tsguy a!+			| anim sheet
	-2.0 a!+ 0.0 a!+ 	| vx vy
	0 a!			| vrz
	alterna 0? ( drop 5.0 'alterna ! ; ) drop
	0 'alterna !
	;
	
#ce
:+est
	1 'ce +!
	ce 5 <? ( drop ; ) drop
	0 'ce !
	+estela ;

|--------------- FRUTAS
:fruta | v -- 
	objsprite
	|..... remove when outside screen
	dup @+ dup -17.0 827.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	50.0 <? ( 2drop 0 ; ) drop
	drop
	;

:+fruta
	'fruta 'frutas p!+ >a 
	810.0 a!+
	500.0 randmax 100.0 +
	a!+	| x y 
	1.0 a!+	| ang zoom
	0 0 
	8 randmax 9 +
	vni>anim | vel cnt ini 
	a!+	tsguy a!+			| anim sheet
	-1.0 a!+
	2.0 randmax 1.0 - a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!			| vrz
	;
	
#cf
:+fru
	1 'cf +!
	cf 40 <? ( drop ; ) drop
	0 'cf !
	+fruta ;
	
#f1 
|#f2 #f3
:fondo	
	f1 int. dup 0 fondo1 SDLImage 800 + 0 fondo1 SDLImage 
|	f2 int. dup 0 fondo2 SDLImage 800 + 0 fondo2 SDLImage
|	f3 int. dup 0 fondo3 SDLImage 800 + 0 fondo3 SDLImage
	-0.8 'f1 +!
|	-0.8 'f2 +!
|	-1.2 'f3 +!
	f1 -800.0 <? ( 800.0 'f1 +! ) drop	
|	f2 -800.0 <? ( 800.0 'f2 +! ) drop
|	f3 -800.0 <? ( 800.0 'f3 +! ) drop
	;
	
|--------------- JUEGO	
:jugador
	xp int. yp int. 2.0 
	animacion time+ dup 'animacion ! nanim 
	tsguy sspritez	
	SDLkey
	>esc< =? ( exit )
	<w> =? ( -2.0 'yv ! )
	>w< =? ( 0 'yv ! )
	<s> =? ( 2.0 'yv ! )
	>s< =? ( 0 'yv ! )	
	drop 
	xv 'xp +!
	yv 'yp +!
	;

:demo
	$000065 SDLcls
	fondo
	time.
	'arcoiris p.draw	
	'frutas p.draw
	jugador
	SDLredraw

	+est
	+fru
	;
	
:main
	"r3sdl" 800 600 SDLinit
	64 64 "r3/itinerario/gio/gato.png" ssload 'tsguy !
	"r3/itinerario/gio/fondo1.png" loadimg 'fondo1 !
|	"r3/itinerario/gio/fondo2.png" loadimg 'fondo2 !
|	"r3/itinerario/gio/fondo3.png" loadimg 'fondo3 !
	50 'arcoiris p.ini
	200 'frutas p.ini
	timeI
	7 3 1 vni>anim 'animacion !
	'demo SDLshow
	SDLquit ;	
	
: main ;
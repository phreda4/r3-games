| Nave vs. Pulpo
^r3/lib/rand.r3
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2image.r3
^r3/util/arr16.r3
^r3/lib/sdl2mixer.r3 
^r3/util/sdlgui.r3

#fondo
#tsguy	| dibujo
#xp 100.0 #yp 460.0		| posicion
#xv #yv		| velocidad
#puntos
#enemigos 0 0 
#disparos 0 0 
#fx 0 0
#musicafomdo
#musicamenu
#sfxdis
#sfxexp

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n			| n
	a@+ sspriterz
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	dup 64 + @ over 24 + +!
	;

:explosion
	objsprite	
	32 + @ anim>n 45 =? ( drop 0 ; )
	drop
	;

:+explo	| y x --
	'explosion 'fx p!+ >a 
	swap a!+ a!+	| x y 
	3.0 a!+	| ang zoom
	31 16 $3f ICS>anim | init cnt scale -- val
	a!+ tsguy a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!	
	sfxexp SNDplay	| vrz
	;

#hit
:choque  | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	dup 'enemigos p.del
	pick4 pick4 +explo
	5 'puntos +!
	0 'hit !
	;
 
 |disparo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:bala | v -- 
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	
	|..... remove when outside screen
	1 'hit !
	dup 8 + @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -20.0 616.0 between -? ( 4drop 0 ; ) drop
	'choque 'enemigos p.mapv | 'vector list --	
	2drop
	hit 0? ( nip ; ) drop
	
	|..... add velocity to position
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	dup 64 + @ over 24 + +!
	drop
	;

:+disparo
	'bala 'disparos p!+ >a 
	xp a!+ yp 16.0 - a!+	| x y 
	6.0 a!+	| ang zoom
	30 0 $3f ICS>anim | init cnt scale -- val
	a!+	tsguy a!+			| anim sheet
	0 a!+ -5.0 a!+ 	| vx vy
	0.0 32 << a!			| vrz
	sfxdis SNDplay	| vrz
	;
 
 
:explosion
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n	| n
	37 =? ( 4drop 2drop 0 ; )
	a@+ sspriterz
	
	|..... add velocity to position
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	dup 64 + @ over 24 + +!
	drop
	;

:+explo	| y x --
	'explosion 'fx p!+ >a 
	swap a!+ a!+	| x y 
	3.0 a!+	| ang zoom
	31 45 $3f ICS>anim | init cnt scale -- val
	a!+	tsguy a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!			| vrz
	;

:exploplayer
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n	| n
	23 =? ( 4drop 2drop 0 exit ; )
	a@+ sspriterz
	
	|..... add velocity to position
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	dup 64 + @ over 24 + +!
	drop
	;

#muerte 
:+explon | --
	1 'muerte !
	'exploplayer 'fx p!+ >a 
	xp a!+ yp a!+	| x y 
	2.0 a!+	| ang zoom
	1 22 $3f ICS>anim | init cnt scale -- val
	a!+	tsguy a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!			| vrz
	;
	

 
|Pulpo
| x y ang anim ss vx vy ar
| 0 8 16  24   32 40 48 56
	
:pulpo | v -- 
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	
	|..... remove when outside screen
	dup 8 + @+ dup -30.0 830.0 between -? ( 4drop 0 ; ) drop
	swap @ dup -20.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	30.0 <? ( exit ) drop
    
	
	90 randmax 0? ( over 48 + dup @ neg swap ! ) drop
	
	|..... add velocity to position
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	dup 64 + @ over 24 + +!
	drop
	;

:+pulpo
	'pulpo 'enemigos p!+ >a 
	700.0 randmax 50.0 + a!+ -10.0 a!+	| x y 
	3.0 a!+	| ang zoom
	24 2 $3f ICS>anim | init cnt scale -- val
	a!+	tsguy a!+			| anim sheet
	6.0 randmax 1.0 - a!+	| vx
	1.0 randmax 2.0 + a!+ 	| vy
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

	timer.
	'enemigos p.draw
	'disparos p.draw
	'fx p.draw
	xp int. yp int. 3.0 0 tsguy sspritez	
	
	$00 ttcolor
	14 14 ttat
	puntos "%d0" ttprint
	$ffff ttcolor
	10 10 ttat
	puntos "%d0" ttprint

	SDLredraw
	
	xv 'xp +!
	yv 'yp +!
	
	teclado
	horda
	;

:reset
	'disparos p.clear
	'enemigos p.clear
	'fx p.clear
	100.0 'xp !
	460.0 'yp !
	0 'muerte !
	0 'puntos !
	; 
 
:jugar
	reset 
	musicafomdo -1 mix_playmusic
	'demo SDLshow
	musicamenu -1 mix_playmusic
	;

:menu
	$ff0000 SDLcls
	immgui
	
	0 100 immat
	800 immwidth
	"navevspulpo" immlabelc

	200 300 immat
	400 immwidth
	'exit "salir" immbtn
	immdn
	'jugar "juego" immbtn

	SDLredraw
	sdlkey 
	>esc< =? ( exit )
	>f1< =? ( jugar )
	drop
	;
 
:main
	"r3sdl" 800 600 SDLinit
	32 32 "r3/iti2023/lauti/completojuego.png" ssload 'tsguy !
	"r3/iti2023/lauti/fondo.png" loadimg 'fondo !
	"r3/iti2023/lauti/destrucion.mp3" mix_loadmus 'musicafomdo !
	"r3/iti2023/lauti/musicmenu.mp3" mix_loadmus 'musicamenu !
	"r3/iti2023/lauti/letrasfuturistas.ttf" 30 TTF_OpenFont immsdl
	"r3/iti2023/lauti/disparo.mp3" mix_loadwav 'sfxdis !
	"r3/iti2023/lauti/desintegración.mp3" mix_loadwav 'sfxexp !
	100 'fx p.ini 
	100 'enemigos p.ini
	100 'disparos p.ini
	musicamenu -1 mix_playmusic
	timer<
	'menu SDLshow
	SDLquit ;	
	
: main ;
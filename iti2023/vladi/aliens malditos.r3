^r3/lib/rand.r3
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2image.r3
^r3/util/arr16.r3
^r3/lib/sdl2mixer.r3
^r3/util/sdlgui.r3

#tsnave	| dibujo
#aninave 0	| frame maximo
#xp 400.0 #yp 560.0		| posicion
#xv #yv		| velocidad

#fx 0 0
#disparos 0 0 
#enemis 0 0

#dispaparo
#exploplo
#menumusica
#musicafondo
#puntos 0
#puntajevx 0

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ timer+ dup a!+ anim>n 			| n
	a@+ sspriterz
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	dup 64 + @ over 24 + +!
	;
		
#fondo
#fondo2
:explosion
	objsprite	
	32 + @ anim>n 36 =? ( drop 0 ; )
	drop
	;

:+explo	| y x --
	'explosion 'fx p!+ >a 
	swap a!+ a!+	| x y 
	1.0 a!+	| ang zoom
	22 16 $3f ICS>anim | init cnt scale -- val
	a!+	tsnave a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0.01 randmax 0.005 - 32 << a!	
	exploplo SNDplay	| vrz
	;

:exploplayer
	objsprite
	32 + @ anim>n 19 =? ( drop 0 exit ; )
	drop
	;

#muerte 
:+explon | --
	1 'muerte !
	'exploplayer 'fx p!+ >a 
	xp a!+ yp a!+	| x y 
	2.0 a!+	| ang zoom
	4 20 $3f ICS>anim | init cnt scale -- val
	a!+	tsnave a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!		
	exploplo SNDplay | vrz
	;

#hit
:choque  | x y i n p -- x y p
	dup 8 + >a 
	pick4 a@+ -	pick4 a@+ -
	distfast 20.0 >? ( drop ; )	drop
	dup 'enemis p.del
	5 'puntos +!
	puntajevx puntos max 'puntajevx !
	0 'hit !
	pick4 pick4 +explo
	;

|disparo
| x y ang anim ss vx vy ar
| 1 2 3    4   5  6  7  8
	
:bala | v -- 
	objsprite
	
	1 'hit !
	dup 8 + @+ dup -17.0 817.0 between -? ( 4drop 0 ; ) drop
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
	37 2 $3f ICS>anim | init cnt scale -- val
	a!+	tsnave a!+			| anim sheet
	0 a!+ -3.0 a!+ 	| vx vy
	0.1 32 << a!			| vrz
	dispaparo SNDplay
	;
	
:alien | v -- 
	objsprite	
	|..... remove when outside screen
	dup 8 + @+ dup -17.0 817.0 between -? ( 4drop 0 ;  ) drop
	swap @ dup -200.0 616.0 between -? ( 4drop 0 ; ) drop
	yp - swap xp - distfast
	30.0 <? ( +explon ) drop
	drop
	;

:+marciano
	'alien 'enemis p!+ >a 
	600.0 randmax 100.0 + a!+ -100.0 a!+ |alien  x y 
	1.0 a!+	| ang zoom
	20 2 $3f ICS>anim | init cnt scale -- val
	a!+	tsnave a!+			| anim sheet
	2.0 randmax 1.0 - 
	a!+ 6.0 a!+ 	| vx vy
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
	aninave timer+ dup 'aninave ! anim>n
	tsnave sspritez	

	xv 'xp +!
	yv 'yp +!
	;
	
:horda
	10 randmax 1? ( drop ; ) drop
	+marciano
	;
	
:demo
	0 0 fondo SDLImage 
	timer.
	'disparos p.draw
	jugador	
	'enemis p.draw	
	'fx p.draw
	$00 ttcolor 14 14 ttat puntos "%d0" ttprint
	$FF6A00 ttcolor 10 10 ttat puntos "%d0" ttprint
	$00 ttcolor 614 14 ttat puntajevx "%d0" ttprint
	$FF6A00 ttcolor 610 10 ttat puntajevx "%d0" ttprint
	SDLredraw
	horda
	;

:reset
	'disparos p.clear
	'enemis p.clear
	'fx p.clear
	400.0 'xp !
	560.0 'yp !
	0 4 $3f ICS>anim | init cnt scale -- val
	'aninave !
	0 'muerte !
	0 'puntos !
	;
	
:jugando
	reset 
	musicafondo -1 mix_playmusic
	'demo Sdlshow
	menumusica -1 mix_playmusic
	;
	
:menu
	0 0 fondo2 SDLImage
	immgui
	0 150 immat
	800 immwidth
	$FF6A00 'immcolortex !
	"Aliens Malditos" immlabelc
	300 350 immat
	200 immwidth
	$ffffff 'immcolortex !
	'jugando "Jugar" immbtn
	immdn
	'exit "Salir" immbtn
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( reset 'demo SDLshow )
	drop
	;
	
:main
	"r3sdl" 800 600 SDLinit
	32 32 "r3/iti2023/vladi/nave y alien.png" ssload 'tsnave !
	"r3/iti2023/vladi/fondo.png" loadimg 'fondo !
	"r3/iti2023/vladi/fondo2.png" loadimg 'fondo2 !
	"r3/iti2023/vladi/Minecraft.ttf" 30 TTF_OpenFont immSDL 
	"r3/iti2023/vladi/laser-gun.mp3" mix_loadWAV 'dispaparo !
	"r3/iti2023/vladi/explosion.mp3" mix_loadWAV	'exploplo !
	"r3/iti2023/vladi/Nogkii - Wii Menu.mp3" mix_loadmus 'menumusica !
	"r3/iti2023/vladi/Sonic the Werehog Monster.mp3" mix_loadmus 'musicafondo !
	200 'disparos p.ini
	100 'enemis p.ini
	200 'fx p.ini 
	0 4 $3f ICS>anim | init cnt scale -- val
	'aninave !
	menumusica -1 mix_playmusic
	timer<
	'menu SDLshow
	SDLquit ;	
	
: main ;
| Fraudecracia
| Democracia Gamejam 2023
| EESN 1 - San Cayetano
| PHREDA
|-----
^r3/lib/rand.r3
^r3/win/sdl2gfx.r3
^r3/win/sdl2mixer.r3
^r3/util/arr16.r3
^r3/util/sdlgui.r3
^r3/util/varanim.r3
^r3/util/boxtext.r3

#font
#font1

#imgfondo
#imgmesa
#imgmesaf
#imgmanos
#imgurna
#imgburbu
#imgexcla
#imgmouse

#sprsupervisor
#sprboletas

#sndvoto
#sndbasura

#places 0 0

#cntvotos
#cntvotosa

#mipartido 0
#pideboleta 0
#distrae 0
#atencion 100
#confianza 0
#puntos 0
#tirados 0

| x y rz n ss vx vy vr
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.rz 3 ncell+ ;
:.n 4 ncell+ ;
:.ss 5 ncell+ ;
:.vx 6 ncell+ ;
:.vy 7 ncell+ ;
|:.vr 8 ncell+ ;

:objsprite | adr -- adr
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@+ a@+ sspriterz
	dup .vx @ over .x +!
	dup .vy @ over .y +!
	|dup .vr @ over .rz +!
	;
	
:guiRectS | adr -- adr
	dup .x @ int. 25 -
	over .y @ int. 40 - | x y
	over 50 + over 80 +
	guiRect
	;

:.xd 8 ncell+ ;	
:.yd 9 ncell+ ;

:.xt@ 10 ncell+ @ $ffffffff and ; | easex (8) easey (8)  timemax (32) 
:.easex@ 10 ncell+ @ 32 >> $ff and ; 
:.easey@ 10 ncell+ @ 40 >> $ff and ; 

:objspritemove
	dup 8 + >a
	a@+ int. a@+ int.	| x y
	a@+ dup 32 >> swap $ffffffff and | rota zoom				
	a@ timer+ dup a!+ 	| anima
	nanim a@+ sspriterz
	
	dup .n @ $ffffffffff and | timenow
	1.0 pick2 .xt@ */
	1.0 >? ( 2drop 0 ; )
	over .vx @ 				| adr time x
	over pick3 .easex@ ease | adr time x timen 
	pick3 .xd @ pick2 - *. + pick2 .x ! | adr time
	over .easey@ ease		| adr timen
	over .vy @ 							| adr timen y
	pick2 .yd @ over - rot *. + over .y !	| adr y
	drop
	;	

	
|------------
:+boletam | easex easey et x2 y2 x1 y1 n --
	'objspritemove 'places p!+ >a 
	pick2 a!+ over a!+ 1.0 a!+ 52 << a!+ sprboletas a!+
	swap a!+ a!+
	swap a!+ a!+
	1000 *. $ffffffff and 
	rot 32 << or swap 40 << or
	a!+
	;	
	
|--------------------
#zexcla	0.0
#zbur 1.0

:superdis
	1600 1000 randmax + 'atencion ! | tiempo entre distracciones
	'zbur 0.0 1.0 16 0.5 0.0 +vanim
	'zexcla 1.0 0.0 23 0.5 0.0 +vanim
	'zexcla 0.0 1.0 22 0.5 1.0 +vanim
	[ 1 'distrae ! ; ] 1.5 +vexe
	'zexcla 1.0 0.0 23 0.5 5.0 +vanim
	'zexcla 0.0 1.0 22 0.5 6.0 +vanim
	[ 0 'distrae ! ; ] 6.5 +vexe
	'zbur 1.0 0.0 17 0.5 6.5 +vanim
	;


:otrovoto
	1 'cntvotosa +!
	cntvotosa cntvotos =? ( drop exit ; ) drop
	'zbur 0.0 1.0 16 0.3 0.0 +vanim
	[ 4 randmax 'pideboleta ! ; ] 0.4 +vexe
	'zbur 1.0 0.0 17 0.5 0.5 +vanim
	;

:restavida
	distrae 1? ( drop ; ) drop
	-1 'confianza +! 
	confianza 0? ( exit ) drop
	;
	
:testvoto | voto -- voto
	pideboleta =? ( otrovoto ; )
	restavida ;
	
:xygui
	xr2 xr1 + 1 >> 16 << 
	yr2 yr1 + 1 >> 16 << ;
	
:abasura
	a@ 4 =? ( drop ; ) >a
	27 27 0.5 230.0 590.0 xygui a> +boletam | easex easey et x2 y2 x1 y1 n --
	sndbasura SNDplay 
	1 'tirados +!
	restavida ;
	
:demochi
	distrae 1? ( 1 'puntos +! ) drop
	27 27 0.5 860.0 280.0 xygui mipartido +boletam | easex easey et x2 y2 x1 y1 n --
	sndvoto SNDplay 
	restavida ;
	
:clickenplace
	clkbtn 4 =? ( drop abasura ; ) drop
	a@ 4 =? ( drop demochi ; ) 
	testvoto
	>a
	27 27 0.5 860.0 280.0 xygui a> +boletam | easex easey et x2 y2 x1 y1 n --
	sndvoto SNDplay 
	;
	
:place
	$ff00ff sdlcolor
	dup 8 + >a
	a@+ a@+ a@+ a@+ 
|	2over 2over SDLRect | debug
	guiBox
	'clickenplace onClick
	drop
	;
	
:+place | n w h x y --
	'place 'places p!+ >a 
	swap a!+ a!+	| x y 
	swap a!+ a!+	| w h
	a!+	| tipo
	;
	
|--------------------

:super
	600 140 distrae sprsupervisor ssprite 
	400 120 0.0 zbur 0 imgburbu sspriterz
	376 120 -0.1 zbur pideboleta sprboletas sspriterz
	710 110 0.1 zexcla 0 imgexcla sspriterz
	;
		
:manocursor	
	sdlx 10 - sdly 10 - imgmanos SDLimage
	;

:pantalla
	super
	0 0 imgmesa SDLImage
	'places p.drawo
	0 0 imgmesaf SDLImage
	
	0 ( confianza <?
		dup 50 * 10 + 10 imgurna SDLImage
		1 + ) drop
	manocursor 
	atencion 1? ( -1 'atencion +! drop ; ) drop
	50 randmax 1? ( drop ; ) drop | distraccion
	superdis
	;
	
|--------------------	
:resetjuego
	'places p.clear
	0 120 160 90 280 +place
	1 120 160 240 280 +place
	2 120 160 410 280 +place
	3 120 160 590 280 +place
	
	4 200 200 550 500 +place
	20 'cntvotos !
	0 'cntvotosa !
	4 'confianza !
	0 'puntos !
	0 'tirados !
	0 'pideboleta !
	0 'distrae !
	100 'atencion !
	;


:juego
	vupdate timer. immgui 
	$666666 sdlcls
|	0 0 imgfondo SDLImage 	

	pantalla
	
	$ffffff ttcolor 
	20 80 ttat puntos "puntos:%d" ttprint
|	20 40 ttat confianza "confianza:%d" ttprint
|	20 70 ttat cntvotosa "votos:%d" ttprint
|	20 100 ttat distrae "distrae:%d" ttprint
	SDLredraw
	SDLkey 
	>esc< =? ( exit )
	<f1> =? ( superdis )
	drop ;

|--------------------	
:finjuego
	$0 SDLcls
	Immgui timer.

	800 immwidth
	112 50 immat
	"Fin de Juego" immlabelc
	immdn immdn
	
	puntos "%d Puntos" immlabelc
	tirados puntos - 1? ( 
		immdn 
		"Descubrieron el fraude !!" immlabelc immdn
		tirados "quitaste %d" immlabelc
		) drop

	400 immwidth
	312 500 immat
	$7f 'immcolorbtn !
	'exit "Continuar" immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop
	;

:jugar
	resetjuego
	'juego SDLshow
	'finjuego SDLShow
	;
	
|-------------------------------------
#texto 
"Fraudecracia" 
""
"Equipo de desarrollo"
""
"Bianca Cipollone"
"Brian Saenz Valiente"
"Braian Canal"
"Camila Pellegrini"
"Diogo Peñalba"
"Efrain Pardo"
"Enzo Piacquadio"
"Lucía Campos Hojsgaard"
"Felix Klink"
"Matias Keergaard"
"Naiara Baptista"
"Pierina Santillan"
""
"Profesores"
"Maria Clara Sorensen"
"Pablo Hugo Reda"
""
"Curso 3er Año"
"Itinirario formativo de"
"asistencia en informatica"
""
"EESN 1"
"San Cayetano"
"Buenos Aires"
""
"Democracia Gamejam"
""
"2023"

#clinea 32
#hlinea 10
#nlinea	
#ys 0
#yh 70

:linestr | nro -- ""
	-? ( drop "" ; )
	clinea >=? ( drop "" ; )
	'texto swap n>>0 ;

:printline | ynow nro str -- ynow nro
	ttsize | w h |... center 1024,yh
	yh swap - 1 >> pick4 + swap
	1024 swap - 1 >> swap ttat
	tt. ;
	
:animc
	vareset
	'ys yh neg 0 0 0.5 0 +vanim
	[ nlinea 1 + clinea >=? ( hlinea neg 1 + nip ) 'nlinea ! animc ; ] 0.5 +vexe
	0 'ys ! 
	;
	
:drawlines
	ys 0 ( hlinea <? 
		nlinea over + linestr printline
		1 + swap yh + swap ) 2drop ;
	
:screditos
	vupdate
	immgui	
	$0 sdlcls
	$ffffff ttcolor
	drawlines
	280 immwidth
	$7f0000 'immcolorbtn !
	720 50 immat 'exit "CONTINUAR..." immbtn		
	SDLredraw	
	SDLkey
	>esc< =? ( exit )
	drop ;
	
:creditos	
	animc
	hlinea neg 1 + 'nlinea !
	'screditos SDLShow
	;
	
|----------------------------------------	
#info "En un paÃ­s con un sistema democratico nuevo y disfuncional
Desarrollamos un plan maestro: El FRAUDE ELECTORAL.
El plan es simple: Nos ofreceremos como presidentes de mesa, y cuando llegue la hora de la contabilizaciÃ³n: pondremos manos a la obra. 
Cumpliremos lo que nos demandarÃ¡ el supervisor, y cuando este distraido 

          tiraremos a la basura la boleta 


          y sacaremos una nuestra de la mochila. 


Todo para que el nÃºmero de boletas coincida con el padrÃ³n electoral y no nos descubran."

:inst	
	vupdate
	$ffffff sdlcls
	immgui

	$00 'info
	100 50 824 500 xywh64 
	$0 font1 textbox | $vh str box color font --

	100 200 imgmouse SDLImage 	
	
	260 immwidth
	300 50 immbox
	$7f0000 'immcolorbtn !
	700 520 immat 'exit "CONTINUAR..." immbtn

	SDLredraw
	SDLkey
	>esc< =? ( exit )
	drop
	;
	
:instrucciones	
	'inst SDLShow
	;
	
|----------------------------------------
#txtpartido
"Juntos por el mambo"
"La esclavitud avanza"
"Union ezquimal"
"Frente al caño"

#cursor

:menu
	0 sdlcls
	immgui
	
	1024 immwidth
	$ffffff 'immcolortex !
	0 50 immat "Fraudecracia" immlabelc
	
	0 220 immat 
	'txtpartido mipartido n>>0 immlabelc

	$ffffff sdlcolor
	msec 5 >> $f and 'cursor !
	mipartido 150 * 230 + cursor - 310 cursor - 
	130 cursor 1 << + 150 cursor 1 << + SDLRect
	
	130 150 immbox
	0 ( 4 <?
		150 over * 295 + 385 
		pick2 sprboletas ssprite
		150 over * 230 + 310 immat
		[ dup 'mipartido ! ; ] immzone
		1 + ) drop
		
	
	340 50 immbox

	$7f00 'immcolorbtn !
	340 120 immat 'instrucciones "INSTRUCCIONES" immbtn

	200 60 immbox

	$7f7f00 'immcolorbtn !
	140 500 immat 'creditos "CREDITOS" immbtn

	$7f00 'immcolorbtn !
	400 500 immat 'jugar "JUGAR" immbtn
	
	$7f0000 'immcolorbtn !
	660 500 immat 'exit "SALIR" immbtn
	
	SDLredraw
	SDLkey
	>esc< =? ( exit )
	<f1> =? ( jugar )
	drop
	;
	
|------------ INICIO ----------------	
:	
	"Fraudecracia" 1024 600 SDLinit
	"r3/gamejamd/fraudecracia/fondo.png" loadimg 'imgfondo !
	"r3/gamejamd/fraudecracia/mesa.png" loadimg 'imgmesa !
	"r3/gamejamd/fraudecracia/mesaf.png" loadimg 'imgmesaf !
	"r3/gamejamd/fraudecracia/urna.png" loadimg 'imgurna !
	"r3/gamejamd/fraudecracia/cursor.png" loadimg 'imgmanos !

	"r3/gamejamd/fraudecracia/mouse.png" loadimg 'imgmouse !
	
	90 140 "r3/gamejamd/fraudecracia/boletas.png" ssload 'sprboletas !
	
	267 300 "r3/gamejamd/fraudecracia/supervisor.png" ssload 'sprsupervisor !	
	273 204 "r3/gamejamd/fraudecracia/burbuja.png" ssload 'imgburbu !
	130 200 "r3/gamejamd/fraudecracia/exclama.png" ssload 'imgexcla !

	"r3/gamejamd/fraudecracia/voto.mp3" mix_loadWAV 'sndvoto !
	"r3/gamejamd/fraudecracia/basura.mp3" mix_loadWAV 'sndbasura !
	
	
	"r3/gamejamd/fraudecracia/Roboto-Medium.ttf" 40 TTF_OpenFont 'font ! 
	"r3/gamejamd/fraudecracia/Roboto-Medium.ttf" 24 TTF_OpenFont 'font1 !
	
	font immSDL
	$ff vaini
	vareset timer<
	40 'places p.ini

	'menu SDLshow
|	jugar
	SDLquit 
	;

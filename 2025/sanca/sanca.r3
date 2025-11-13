| sanca
| 2025
^r3/lib/sdl2gfx.r3
^r3/lib/sdl2mixer.r3
^r3/util/vscreen.r3
^r3/lib/rand.r3

^r3/util/ui.r3
^r3/util/arr16.r3
^r3/util/varanim.r3
^r3/util/txfont.r3

|#filepath "r3/2025/sanca/data/"
#filepath "data/"

:infile 'filepath "%s%s" sprint ;

|------ sound
#sndfiles "explosion.mp3" "buuuuu.mp3" "jump.mp3" "laserShoot.mp3" "synth.mp3" 0
#sndlist * 160

:loadsnd
	'sndlist >a
	'sndfiles
	( dup c@ 1? drop
		dup infile mix_loadWAV a!+
		>>0 ) drop ;

:playsnd | n --
	3 << 'sndlist + @ SNDplay ;

|--------
#font1

#logosg
#fondo1
#fondo2
#xfondo

#dibjug
#dibobj
#dibfan
#dibper
#dibnube
#dibrosario

#fxnubes 0 0
#objetos 0 0
#fx 0 0 
#lpan 0 0 

#jugx 0.0 #velx 0.0 #accx 0.0
#jugy 0.0 #vely 0.0 #accy 0.0
#jugd 1

#xvp #yvp #svp
#energia
#senergia

#jestado
#vidas
#milagros
#metros

#volmus 0.3
#volsfx 0.3

#musini
#musjue
#musopc
#musfin
	
:camara
	jugx int. 0.3 %w - 'xvp ! 260 'yvp ! ;

#juga	
#estado |0-camina 1-agachado

:camina
	0 'estado !
	1 'jugd ! 
	0.15 'accx !
	8 8 $40 ICS>anim 'juga ! ; 

:jder
	accx 1? ( drop ; ) drop
	1 'jugd ! 
	0.15 'accx !
	8 8 $40 ICS>anim 'juga ! ; 

:jizq
	accx 1? ( drop ; ) drop
	-1 'jugd ! 
	-0.15 'accx ! 
	0 8 $40 ICS>anim 'juga ! ; 
	
:jders	
	accx 0.15 <>? ( drop ; ) drop
	0 'accx !
	8 1 1 ICS>anim 'juga ! ;

:jizqs	
	accx -0.15 <>? ( drop ; ) drop
	0 'accx !
	0 1 1 ICS>anim 'juga ! ;	

:jugador
	jugx int. xvp -
	jugy int. |yvp -
	2.5 juga anim>n
	dibjug sspritez

	velx accx +
	6.0 min -6.0 max 0.85 *.
	dup 'velx !
	dup neg 'xfondo +!
	dup 0.007 *. 'metros +!
	'jugx +!

	vely 'jugy +!
	0.2 'vely +!
	jugy 490.0 >? ( 490.0 'jugy ! 0 'vely ! ) drop
	camara
	deltatime 'juga +!
	;

:saltar 
	480.0 jugy =? ( -12.0 'vely ! ) drop ;
	
:agacharse
	estado 1? ( drop ; ) drop
	0 'accx !
	21 1 1 ICS>anim 'juga !
	1 'estado !
	'camina 1.0 +vexe
	;
	
|------------------------------
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.ani 3 ncell+ ;
:.vx 4 ncell+ ;
:.vy 5 ncell+ ;
:.xlim 6 ncell+ ;
:.ss 7 ncell+ ;

:objs
	>a
	a> .x @ int. xvp - 
	a> .y @ int. |yvp - 
	2.0
	|a> .ani dup @ deltatime + dup rot ! anim>n
	a> .ani deltatime over +! @ anim>n
	a> .ss @ sspritez | a x y --
	;	
	
:+obj | ss anim x y --
	'objs 'objetos p!+ >a
	swap a!+ a!+ a!+ 
	0 a!+ 0 a!+
	0 a!+
	a!
	;

#xh #yh
:hitobj | x y --
	ab[
	'yh ! 'xh ! 
	[ 
		dup .y @ yh - abs 100.0 >? ( drop ; ) drop
		dup .x @ xh - abs 32.0 >? ( drop ; ) drop 
		|0 
		$1 52 << |1 $70 ICS>ani
		over .ani +!
|		-2.0 over .vy !
		4 playsnd
		1 'milagros +!
		;
	] 'objetos p.mapv | 'vector list --
	]ba
	;
	
|---------- pan
:explopan
	>a
	a> .x @ int. xvp - 
	a> .y @ int. |yvp - 
	2.0
	a> .ani deltatime over +! @ anim>n
	8 =? ( 4drop 0 ; )
	dibobj sspritez | a x y --
	-2.0 a> .y +!
	;
	
:+explopan
	'explopan 'lpan p!+ >a
	swap a!+ a!+ 
	a!+	
	0 playsnd ;
	
:pan
	>a
	a> .x @ int. xvp - 
	a> .y @ int. |yvp - 
	a> .ani @ 2.0 8 dibobj sspriterz | a x y --
	
	a> .vx @ 8 >> a> .ani +!
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	0.1 a> .vy +!
	a> .y @ 530.0 >? ( drop 
		a> .x @ a> .y @ hitobj
		0 9 $70 ICS>anim | init cnt scale -- val
		a> .x @ a> .y @ 20.0 - +explopan
		0 ; ) drop
	;
	
:+pan | vx vy a x y --
	'pan 'lpan p!+ >a
	swap a!+ a!+ 
	a!+
	swap a!+ a!+ 
	2 playsnd ;

:panapress
	jugd 2/ not 1 and 2* 16 + 1 $80 ICS>anim 'juga ! 
	1 'senergia !
	0 'velx ! 0 'accx ! ;
	
:panarelea
	jugd 2/ not 1 and 2* 16 + 2 $80 ICS>anim 'juga ! 
|	jugd 2/ not 1 and 2* 16 + 2 $80 ICS>anim 'juga ! 
	jugd 3.0 * energia 0.01 * + | vx
	energia -0.08 * 			| vx
	0 jugx 16.0 + jugy 16.0 - +pan 
	0 'energia ! 0 'senergia !
	[ jugd 2/ not 1 and 8 * 0 $40 ICS>anim 'juga ! ; ] 0.1 +vexe
	'camina 0.2 +vexe ;
	
|---------- nube
:nube 
	>a
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	a> .x @ int. xvp - 
	2048 >? ( drop 0 ; )
	-2048 <? ( jugx 1200.0 + a> .x ! )
	a> .y @ int. |yvp - 
	a> .xlim @
	a> .ani @
	dibnube sspritez | a x y --
	;
	
:+nub | z vx vy s x y --
	'nube 'fxnubes p!+ >a
	swap a!+ a!+ a!+ 
	swap a!+ a!+
	a! ;
	
	
:+nubei
	400.0 randmax dup >r |y
	400.0 swap - 60 / 1.0 + | z
	0.4 randmax 0.2 + neg |vx
	0.0 |vy
	4 randmax |s
	4096.0 randmax 2048.0 - jugx +	| x 
	r> |y
	+nub ;
	
|---------- fantasma
:gani | vx vy -- vx vy ani
	over 63 >> $1 and 1 xor 
	4 *	4				| ini cnt
	pick3 abs $40 *.	| scale
	ICS>anim | init cnt scale -- val
	;
	
:lreb
	a> .vy dup @ neg swap ! ;

:lreby
	a> .vx dup @ neg swap ! 
	a> .vx @ a> .vy @
	|a> .ani @ anim>n 4 / $1 and | inv ani
	gani a> .ani !
	2drop
	|1.0 randmax 0.5 + *. a> .vx ! | cambia velocidad?
	;
	
:dirmen
	a> .x @ jugx - int.
	a> .xlim @ neg <? ( lreby ) 
	2drop ;
	
:dirmas
	a> .x @ jugx - int.
	a> .xlim @ >? ( lreby )
	2drop ;
	
:gia
	a> .y @ 100.0 <? ( lreb ) 400.0 >? ( lreb ) drop
	a> .vx @ -? ( dirmen ; ) dirmas ;
	
#effhit 0	

:hitjug
	a> .x @ jugx - abs 64.0 >? ( drop ; ) drop
	a> .y @ jugy - abs 128.0 >? ( drop ; ) drop
	effhit -? ( drop ; ) drop
	estado 1? ( drop ; ) drop
	-30 'effhit !
	1 playsnd
	-1 'vidas +!
	vidas -? ( 2 'jestado ! exit ) drop
	;
	
:gosth	
	>a
	gia
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	hitjug
	
	a> .x @ int. xvp - 
	a> .y @ int. |yvp - 
	1.5
	|a> .ani dup @ deltatime + dup rot ! anim>n
	a> .ani deltatime over +! @ anim>n
	dibfan sspritez | a x y --
	;
	
:+gosth | vx vy anim x y --
	'gosth 'objetos p!+ >a
	swap a!+ a!+ a!+ 
	swap a!+ a!+
	200 randmax 100 - 700 + a! | XLIM
	;

:rgosth
	10 randmax 1? ( drop ; ) drop
	
	1.9 randmax 0.9 + $1000 and? ( neg )
	0.6 randmax 0.4 + $1000 and? ( neg ) 
	gani
		
	jugx velx +
	600.0 pick4 +? ( swap neg swap ) drop +  | posx de velocidad
	200.0 +
	300.0 				| posy
	+gosth ;
	

|-------------
:drawfondo	
	xfondo int. 4660 - yvp 2.0 fondo1 spritez 
	xfondo int. 3900 + yvp 2.0 fondo2 spritez ;

|----- HUD	
:resetjuego
	'fxnubes p.clear
	'objetos p.clear
	'fx p.clear
	'lpan p.clear
	50 ( 1? 1- +nubei ) drop
	8600.0 'xfondo !
	0 'jugx ! 0 'velx ! 0 'accx !
	490.0 'jugy ! 0 'vely ! 0 'accy !
	1 'jugd !
	0 'xvp ! 260 'yvp ! 0 'svp !	
	6 'vidas ! 
	0 'milagros !
	0 'metros !
	;

:hud
	0.5 %w 64 4.0 vidas dibrosario sspritez

	metros int. "%d metros" sprint
	26 18 txat $ffffff txrgb dup txwrite
	24 16 txat 0 txrgb txwrite
	
	milagros "%d milagros" sprint
	1002 18 txat $ffffff txrgb dup txemitr
	1000 16 txat 0 txrgb txemitr
	
|	0 txrgb
|	24 16 txat jugx "jugx:%f " txprint
|	xvp "xvp:%d " txprint
|	energia "fx:%d " txprint
	;

:rfiel
	10 randmax 1? ( drop ; ) drop
	dibper
	3 randmax 2* 1 0 ICS>anim	| persona
	jugx 800.0 +
	30.0 randmax 20.0 - 484.0 +
	+obj
	;
	
:desarrollo
	jugx
	15900.0 >? ( 1 'jestado ! exit )
	100.0 mod
	98.0 >? ( rfiel )
	99.0 >? ( rgosth )
	drop
	;
	
:deltaenergia
	senergia 0? ( drop ; ) 
	energia +
	100 min 20 max
	'energia ! 
	$0 sdlcolor 259 559 82 12 sdlfRect
	$FFE300 sdlcolor 260 560 energia 20 - 10 sdlFRect
	;
	
:juego
	vini
	vupdate
	$449FEA sdlcls
	'fxnubes p.draw
	drawfondo
	'objetos p.draw
	1 'effhit +!
	'lpan p.draw
	jugador
	'fx p.draw
	deltaenergia
	hud
	
	vredraw	
	desarrollo
	
	sdlkey
	>esc< =? ( exit )
	
|	<ri> =? ( -100.0 dup 'xfondo +! 'jugx +! )	
|	<ri> =? ( jder ) >ri< =? ( jders )
|	<le> =? ( jizq ) >le< =? ( jizqs )
|	<up> =? ( saltar )

	<dn> =? ( agacharse )
	
	<esp> =? ( panapress )
	>esp< =? ( panarelea ) 
	
	<f1> =? ( rgosth )
	<f2> =? ( rfiel )
	drop
	;

#xlogo #ylogo
#cartel * 16

:drawlogo
	xlogo ylogo 3.0 logosg spritez 
	$ffffff txrgb
	'cartel txw 
	xlogo swap 2/ - ylogo txh 2/ + 8 +
	txat
	txprint	;
	
:logoin
	0.5 %w 'xlogo !
	'ylogo
	0.25 %h dup neg
	21
	0.8 0 +vanim ;
	
:logoout
	0.5 %w 'xlogo !
	'ylogo
	0.25 %h dup neg swap
	21
	0.8 0 +vanim ;
	
	
:juegoinis
	vini
	vupdate
	$449FEA sdlcls
	'fxnubes p.draw
	drawfondo
	jugx int. xvp -
	jugy int. |yvp -
	2.5 juga anim>n
	dibjug sspritez
	deltatime 'juga +!
	drawlogo
	vredraw	
	sdlkey
	>esc< =? ( exit )
	drop
	;

:juegoini
	resetjuego jders	
	'xvp
	jugx int. 0.3 %w - -40  
	0 3.9 0.0 +vanim | 'var fin ini ease dur. start --
	'exit 4.0 +vexe
	"" 'cartel strcpy 
	[ "3" 'cartel strcpy ; ] 1.0 +vexe
	[ "2" 'cartel strcpy ; ] 2.0 +vexe
	[ "1" 'cartel strcpy ; ] 3.0 +vexe
	'logoout 3.2 +vexe
	logoin
	'juegoinis sdlshow
	logoout
	;

#msggano
"San Cayetano
Logro recorrer toda la ciudad"

#msgperdio
"San Cayetano
No logro recorrer toda la ciudad"

#mensaje 'msgperdio

:showfin
	vini
	vupdate
	$449FEA sdlcls
	$ffffff txrgb
	'fxnubes p.draw
	drawlogo

	$11 txalign	
	$0 txrgb
	0.8 %w 0.5 %h 0.1 %w 2 + 0.25 %h 2 +
	mensaje txText

	$ffffff txrgb
	0.8 %w 0.5 %h 0.1 %w 0.25 %h 
	mensaje txText	

	metros int. "%d metros" sprint
	0.2 %w 0.65 %h txat $ffffff txrgb dup txwrite
	0.2 %w 2 - 0.65 %h 2 - txat 0 txrgb txwrite
	
	milagros "%d milagros" sprint
	0.2 %w 0.75 %h txat $ffffff txrgb dup txwrite
	0.2 %w 2 - 0.75 %h 2 - txat 0 txrgb txwrite
	
	vredraw
	sdlkey
	>esc< =? ( exit )
	drop ;
	
:jgano
	logoin
	'logoout 7.0 +vexe
	'exit 8.0 +vexe
	'msggano 'mensaje !
	'showfin sdlshow
	;
	
:jperdio
	logoin
	'logoout 7.0 +vexe
	'exit 8.0 +vexe
	'msgperdio 'mensaje !
	'showfin sdlshow
	;
	
:jugar
	juegoini jder
	musjue 2 Mix_Playmusic
	0 'jestado !
	'juego sdlshow
	Mix_HaltMusic
	"Fin" 'cartel strcpy
	logoout
	jestado 
	1 =? ( jgano )
	2 =? ( jperdio )
	drop
	logoin
	"Game" 'cartel strcpy
	;
	
|----------------------------------
:changescr	
	;
	
#volmusa
#volsfxa

:opcion
	vini
	vupdate
	$449FEA sdlcls
	'fxnubes p.draw
	uiStart
	3 4 uiPad
	0.2 %w 0.5 %h 0.6 %w 0.4 %h uiWin!
	2 5 uiGridA uiv
	0 0 uiGAt
	"Musica" uiLabelC
	"SFX" uiLabelC
	1 0 uiGAt
	stlink
	0 1.0 'volmus uiProgressf
	0 1.0 'volsfx uiProgressf
	"" uiLabel
	stDang
	'exit "ESC - Salir" uiRBtn
	uiEnd
	drawlogo
	vredraw
	sdlkey
	>esc< =? ( exit )
	drop
	volmus volmusa <>? ( dup 'volmusa ! dup 128 1.0 */ Mix_VolumeMusic ) drop
	volsfx volsfxa <>? ( dup 'volsfxa ! dup 128 1.0 */ Mix_MasterVolume ) drop
	;

:opciones
	volmus 'volmusa !
	volsfx 'volsfxa !
	volmus 128 1.0 */ Mix_VolumeMusic
	volsfx 128 1.0 */ Mix_MasterVolume
|	musjue 
	"Opciones" 'cartel strcpy
	musini 1 Mix_Playmusic
	'opcion sdlshow 
	Mix_HaltMusic
	"Game" 'cartel strcpy
	;

|----------------------------------	
:inicio
	vini
	vupdate
	$449FEA sdlcls
	$ffffff txrgb
	'fxnubes p.draw
	
	uiStart
	3 4 uiPad
	0.2 %w 0.5 %h 0.6 %w 0.4 %h uiWin!
	1 5 uiGridA uiv
	stlink
	'jugar "Jugar" uiRBtn
	'opciones "Opciones" uiRBtn
|	'opciones "Creditos" uiRBtn
	"" uiLabel
	stDang
	'exit "ESC - Salir" uiRBtn
	uiEnd

	drawlogo
	
	vredraw
	sdlkey
	<dn> =? ( jugar )
	<esp> =? ( jugar )
	<f1> =? ( jugar )
	<f2> =? ( opciones )
	>esc< =? ( exit )
	drop
	;



: | :::::::::::::::::::::::::::::::::::::::
"SanCa Game" 1024 600 sdlinitr
1024 600 vscreen

"fondo1.png" infile loadimg 'fondo1 !
"fondo2.png" infile loadimg 'fondo2 !
"Logosg.png" infile loadimg 'logosg !
40 80 "sancamina.png" infile ssload 'dibjug !
42 16 "nube.png" infile ssload 'dibnube !
48 48 "sanca.png" infile ssload 'dibobj !
62 62 "fantasma.png" infile ssload 'dibfan !
40 60 "personas.png" infile ssload 'dibper !
32 32 "rosario.png" infile ssload 'dibrosario !
"Pixelify.ttf" infile 40 txload 'font1 !
font1 txfont

loadsnd

"minicio1.mp3" infile mix_loadmus 'musini !
"menjuego.mp3" infile mix_loadmus 'musjue !
"minicio2.mp3" infile mix_loadmus 'musopc !
"menjuego.mp3" infile mix_loadmus 'musfin !

64 vaini
200 'fxnubes p.ini
100 'objetos p.ini
100 'lpan p.ini
200 'fx p.ini

volmus 128 1.0 */ Mix_VolumeMusic
volsfx 128 1.0 */ Mix_MasterVolume

resetjuego
jder
logoin 
"Game" 'cartel strcpy
'inicio sdlshow

|'juego sdlshow
|jgano
|jperdio

vfree
;
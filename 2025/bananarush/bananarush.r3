| ITI 2025
| banana rush
|

^r3/lib/sdl2gfx.r3
^r3/lib/sdl2mixer.r3
^r3/util/vscreen.r3

^r3/lib/rand.r3

^r3/util/ui.r3
^r3/util/arr16.r3
^r3/util/varanim.r3

#filepath "r3/2025/bananarush/data/"
|#filepath "data/"

:infile 'filepath "%s%s" sprint ;

|------ sound
#sndfiles "click.mp3" "jump.mp3" "hit.mp3" "banana.mp3" "lorog.mp3" "trueno.mp3"
"mono1.mp3" "mono2.mp3" "mono3.mp3" "mono4.mp3" "mono5.mp3"  0
#sndlist * 160

#musini
#musjue
#musopc
#musfin

#volmus 0.0
#volsfx 0.2

:loadsnd
	'sndlist >a
	'sndfiles
	( dup c@ 1? drop
		dup infile mix_loadWAV a!+
		>>0 ) drop ;

:playsnd | n --
	3 << 'sndlist + @ SNDplay ;
	
:sndmonoqueja
	6 4 randmax + playsnd ;
:sndmonofeliz
	10 playsnd ;
	
|------------------------------	
#font

#dibujos
#dibaguila
#dibjefe
#dibrayos
#dibtronco
#fondos 

#logo
#logopos

#fondox 0 0 0 0 0
#fondov -0.1 -0.4 -0.6 -0.9 -1.0

#obj 0 0
#dis 0 0
#fx 0 0

#xjug 400.0 #xvel 0.0 #xacc 0.0
#yjug 500.0 #yvel 0.0 

#xjugv 500

#estado
#lugar 0
#vidas 5

#tbana 1
#xbana 400.0 #xvbana 0.0 
#ybana 300.0 #yvbana 0.0
#rbana 0.0 #xabana 

#jefevidas

:plano | vel --
	b@ + 
	-1024.0 <? ( 2048.0 + ) 
	1024.0 >? ( 2048.0 - )
	b!
	b@ int. 300 4.0 pick3 fondos sspritez
	b@+ 2048.0 + int. 300 4.0 pick3 fondos sspritez 
	;
	
:planos	
	'fondov >a
	'fondox >b
	xvel 
	0 ( 5 <?
		over a@+ *. plano
		1+ ) 2drop 	;
	
|--- objs
:.x 1 ncell+ ;
:.y 2 ncell+ ;
:.ani 3 ncell+ ;
:.vx 4 ncell+ ;
:.vy 5 ncell+ ;
:.xlim 6 ncell+ ;

|---------------
:efx
	>a
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	-1 a> .xlim +!
	a> .xlim @ -? ( drop 0 ; ) drop
	
	a> .x @ xjug - int. 
	a> .y @ int. 
	3.0
	a> .ani dup @ deltatime + dup rot ! anim>n
	dibujos sspritez | a x y --
	;

:+fx | liv vx vy ani x y --
	'efx 'fx p!+ >a
	swap a!+ a!+ 
	a!+
	swap a!+ a!+
	a!
	;
	
:tronco
	>a
	a> .x @ xjug - int. 
	a> .y @ int. 
	a> .vx @
	3.0	
	a> .ani @ 
	dibtronco sspriterz | a x y --
	;
	
:+tronco | r s x y 
	'tronco 'fx p!+ >a
	swap a!+ a!+
	a!+ a!
	;

:troncoizq
	190.0 ( 530.0 <?
		0.02 randmax 0.01 -
		4 randmax
		380.0 30.0 randmax +
		pick3 +tronco
		26.0 + ) drop ;
	
:troncoder
	190.0 ( 530.0 <?
		0.02 randmax 0.01 -
		4 randmax
		1700.0 30.0 randmax +
		pick3 +tronco
		26.0 + ) drop ;
		
:resetjuego
	400.0 'xjug ! 0.0 'xvel ! 0.0 'xacc !
	500.0 'yjug ! 0.0 'yvel !
	0 'lugar !
	5 'vidas !
	1 'tbana !
	3 'jefevidas !
	'obj p.clear
	'dis p.clear
	'fx p.clear
	troncoizq
	;
	
|------------- LORO	
:dloro
	>a
	a> .vy @ a> .y +!
	a> .y @ int. 700 >? ( drop 0 ; ) drop
	0.1 a> .vy +!
	
	a> .x @ xjug - int. 
	a> .y @ int. 
	msec 5 <<
	4.0
	a> .ani @ anim>n
	dibujos sspriterz | a x y --
	;
	
:+deadloro | a x y --
	4 playsnd
	'dloro 'fx p!+ >a
	swap a!+ a!+ 
	a!+ 0 a!+ 0 a!+ ;
	
|---------------
:hitjug
	a> .x @ xjug - int. xjugv - abs 
	32 >? ( drop ; ) drop
	a> .y @ yjug - int. abs 
	32 >? ( drop ; ) drop
	-1.8 yvel 2/ + a> .vy !
	1.4 randmax 0.7 - a> .vx +!
	yjug 38.0 - a> .y !
	|**********
	30
	0.0 -1.0
	33 1 1 ICS>anim | init cnt scale -- val
	a> .x @ a> .y @
	+fx
	2 playsnd
	-1 'vidas +!	
	sndmonoqueja
	;
	
:nuez
	>a
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	0.02 a> .vy +!
	
	a> .y @ 580.0 >? ( drop 0 ; ) drop
	
	hitjug
	
	a> .x @ xjug - int. 
	a> .y @ int. 
	3.0
	a> .ani dup @ deltatime + dup rot ! anim>n
	dibujos sspritez | a x y --
	;
	
:+nuez | vx vy anim x y --
	'nuez 'dis p!+ >a
	swap a!+ a!+
	a!+ | anim
	swap a!+ a!+
	;
	
	
:lani | vx vy a -- vx vy ani
	>r
	over 63 >> $1 and 1 xor 
	4 * 9 + r> 8 * +	| init
	4					| cnt
	pick3 abs $40 *.	| scale
	ICS>anim | init cnt scale -- val
	;
	
:lshoot
	a> .x @ xjug - int. xjugv - abs 
	100 >? ( drop ; ) drop	| cerca del jugador
	80 randmax 1? ( drop ; ) drop | 1/70 prob
	a> .vx @ 2.0 randmax 1.0 - + 0
	36 2 randmax + 1 0 ICS>anim
	a> .x @ a> .y @
	+nuez
	;
	
:lreb
	a> .vy dup @ neg swap ! ;

:lreby
	a> .vx dup @ neg swap ! 
	a> .vx @ a> .vy @
	a> .ani @ anim>n 9 - 8 / $3 and | inv ani
	lani a> .ani !
	2drop
	|1.0 randmax 0.5 + *. a> .vx ! | cambia velocidad?
	;
	
:dirmen
	a> .x @ xjug - int. xjugv -
	a> .xlim @ neg <? ( lreby ) 
	2drop ;
	
:dirmas
	a> .x @ xjug - int. xjugv -
	a> .xlim @ >? ( lreby )
	2drop ;
	
:lia
	a> .y @ 100.0 <? ( lreb ) 400.0 >? ( lreb ) drop
	a> .vx @ -? ( dirmen ; ) dirmas ;
	
:lhit
	a> .x @ xbana xjugv fix. + - int. abs
	32 >? ( drop 1 ; ) drop
	a> .y @ ybana - int. abs
	32 >? ( drop 1 ; ) drop
	0 ;
	
:loro
	>a
	lia

	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	
	lhit 0? ( a> .ani @ a> .x @ a> .y @ +deadloro ; ) drop
	
	a> .x @ xjug - int. 
	a> .y @ int. 
	4.0
	a> .ani dup @ deltatime + dup rot ! anim>n
	dibujos sspritez | a x y --
	
	lshoot
	;
	
:+loro | vx vy anim x y --
	'loro 'obj p!+ >a
	swap a!+ a!+
	a!+ | anim
	swap a!+ a!+
	200 randmax 100 - 500 + a! | XLIM
	;
	
:randloro
	1.9 randmax 0.9 + $1000 and? ( neg )
	0.6 randmax 0.2 + $1000 and? ( neg ) 
	3 randmax lani
		
	xjug xjugv fix. +
	520.0 pick4 +? ( swap neg swap ) drop +  | posx de velocidad
		
	300.0 				| posy
	+loro 
	;

|---------------------------- AGUILA
#aguila?	
#hitaguila

:aani | vx vy -- vx vy ani
	over 63 >> $1 and 4 * | ini
	4					| cnt
	pick3 abs $20 *.	| scale
	ICS>anim | init cnt scale -- val
	;

:lrebya
	a> .vx dup @ neg swap ! 
	a> .vx @ a> .vy @ aani a> .ani !
	2drop
	0.1 a> .vy +! | acerca
	;
	
:dirmena
	a> .x @ xjug - int. xjugv -
	a> .xlim @ neg <? ( lrebya ) 
	2drop ;
	
:dirmasa
	a> .x @ xjug - int. xjugv -
	a> .xlim @ >? ( lrebya )
	2drop ;

:aataca
	| aguila agarra
	-1 'vidas ! 
	sndmonoqueja
	;
	
:aia
	a> .y @ 100.0 <? ( lreb ) 400.0 >? ( aataca ) drop
	a> .vx @ -? ( dirmena ; ) dirmasa ;
	
:aguila
	>a
	aia | agila ia
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	a> .x @ xjug - int. 
	a> .y @ int. 
	4.0
	a> .ani dup @ deltatime + dup rot ! anim>n
	dibaguila sspritez
	;
	
:+aguila | vx vy anim x y --
	'aguila 'obj p!+ >a
	swap a!+ a!+
	a!+ | anim
	swap a!+ a!+
	500 a! | XLIM
	;
		
:randaguila
	2.0 randmax 2.0 + $1000 and? ( neg ) 
	0.2 randmax 0.1 + $1000 and? ( neg ) 
	aani
	xjug xjugv fix. +
	520.0 pick4 +? ( swap neg swap ) drop +  | posx de velocidad
	100.0 				| posy
	+aguila
	;
	
:activaguila
	aguila? 1? ( drop ; ) drop
	1 'aguila? !
	3 'hitaguila !
	randaguila
	;
	
|---- banana
:btiene
	xjug 
	26.0 xvel sign nip * +
	'xbana !
	yjug msec 6 << sin 2 * + 'ybana !
	;
	
:bpiso
	540.0 'ybana !
	xbana xjug - abs 
	ybana yjug - abs 
	max
	40.0 <? ( 1 'tbana ! ) drop
	;
	
:bmove
	tbana 1? ( drop btiene ; ) drop
	ybana 540.0 >=? ( drop bpiso ; ) 
	yvbana + 'ybana !
	0.07 'yvbana +!
	xvbana 0.03 *. 'rbana +!
	xvbana 'xbana +!
	xabana 'xvbana +!
	xbana 
	-? ( 0 'xbana ! xvbana neg 'xvbana ! ) 
	estado 0? ( 2drop ; ) drop
	1120.0 >? ( 1120.0 'xbana ! xvbana neg 'xvbana ! ) 
	drop
	;
	
:banana
	bmove
	xbana xjug - int. xjugv +
	ybana int. 
	rbana
	4.0 |tbana 1? ( 2drop 1.8 dup ) drop
	35 dibujos sspriterz | a x y --
	;

:shoot
	tbana 0? ( drop ; ) drop
	xjug 'xbana !
	yjug 'ybana !
	-6.5 'yvbana !
	xvel 2.6 *. dup 'xvbana !
	neg 0.004 *. 'xabana !
	0 'tbana !
	3 playsnd
	;
	
|--- jugador
:animj
	xvel 0? ( drop 1 ; ) 
	+? ( drop msec 8 >> $1 and 2 + ; )
	drop msec 8 >> $1 and ;
	
:jugador
	xjugv
	yjug int. 4.0 
	animj
	dibujos sspritez

	xacc xvel + 2.1 min -2.1 max 'xvel !
	xvel 'xjug +!
	xvel 0.95 *. 'xvel !
	
	xjug -? ( drop 0 'xjug ! 0 'xacc ! 3.0 'xvel ! -5.0 'yvel ! ; ) drop
	
	yvel 'yjug +!
	0.3 'yvel +!
	yjug 508.0 >? ( 508.0 'yjug ! 0 'yvel ! ) drop
	;
	
:panel
	|.... logo
	490 40 0.3 logo spritez
	|.... vidas
	0 ( 5 <?
		dup 48 * 80 + 40 3.0 
		38 pick4 vidas >=? ( drop 1+ dup ) drop
		dibujos sspritez
		1+ ) drop

	estado 1? ( drop ; ) drop
	|.... barra
	$ffea00 sdlcolor 
	696 30
	xjug int. xjugv - clamp0 5 >>
	25 sdlfrect
	$0 sdlcolor 
	696 30 240 25 sdlrect
	697 31 238 23 sdlrect
	;

#amm | anima muerte mono
:mmono
	vini
	vupdate
	$40C87C sdlcls
	planos
	'dis p.draw	
	'obj p.draw
	banana
	
	xjugv 
	yjug int. 4.0 
	amm deltatime + dup 'amm ! anim>n
	dibujos sspritez
	
	'fx p.draw		
	panel
	vredraw
	
	sdlkey
	>esc< =? ( exit )
	drop
	;

:muertemono
	vareset
	'exit 2.0 +vexe
	'yjug 470.0 yjug 1 0.5 0.0 +vanim
	'yjug 630.0 470.0 1 1.0 0.5 +vanim
	
	4 3 $4f ICS>anim | init cnt scale -- val
	'amm !
	'mmono sdlshow
	;
	
|------- juego	
:fogr
	7 randmax 1? ( drop ; ) drop
	30
	0.2 0.0
	40 5 $7f ICS>anim | init cnt scale -- val
	xjug xjugv fix. + yjug 4.0 + 5.0 randmax +
	+fx
	;

:fogl
	7 randmax 1? ( drop ; ) drop
	30
	-0.2 0.0
	45 5 $7f ICS>anim | init cnt scale -- val
	xjug xjugv fix. + yjug 4.0 + 5.0 randmax +
	+fx
	;

:debug
	8 50 txat
	xjug "%f " txprint
	xjug 8192.0 swap - 22 >> "%d" txprint
	;
	
:mecanica
|	debug
	xjug  
|	-? ( activaguila )
	
	8192.0 over - 20 >> 300 clamp0max randmax 0? ( randloro ) drop
	8192.0 >? ( 2 'estado ! exit )
	drop
	vidas 0 >=? ( drop ; ) drop
	|muertemono exit
	1 'estado ! exit	
	;

:juego
	vini
	vupdate
	$40C87C sdlcls

	planos
	'dis p.draw	
	'obj p.draw
	banana
	jugador
	'fx p.draw		
	panel
	mecanica
	vredraw

	sdlkey
	>esc< =? ( exit )
	<esp> =? ( shoot )	
	<up> =? ( 508.0 yjug =? ( -10.0 'yvel ! 1 playsnd ) drop )
	<ri> =? ( 0.1 'xacc ! fogr ) >ri< =? ( 0.0 'xacc ! )
	<le> =? ( -0.1 'xacc ! fogl ) >le< =? ( 0.0 'xacc ! )
	
	<f1> =? ( randloro )
|	<f2> =? ( 1 'estado ! exit )
|	<f3> =? ( 2 'estado ! exit )
	drop ;
	
|-----------------------------
#xjefe 30.0 

:hitjug
	a> .x @ xjug - int. xjugv - abs 
	64 >? ( drop ; ) drop
	-1 'vidas +!
	sndmonoqueja
	;
	
|---- jefe	
:rayo
	>a
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	a> .x @ xjug - int. 
	a> .y @ int. 
	2.6
	a> .ani dup @ deltatime + dup rot ! anim>n
	11 =? ( 4drop 0 
		hitjug
		; )
	dibrayos sspritez
	;

:+rayo | vx vy anim x y --
	'rayo 'obj p!+ >a
	swap a!+ a!+
	a!+ | anim
	swap a!+ a! ;

:setrayo
	0 0 0 12 $80 ICS>anim 
	a> .x @ ||xjug xjugv fix. + 128.0 randmax + 64.0 -
	280.0 +rayo ;
	
:cruz
	>a
	a> .vx @ a> .x +!
	a> .vy @ a> .y +!
	a> .x @ xjug - int. 
	a> .y @ int. 
	1.6
	a> .ani dup @ deltatime + dup rot ! anim>n
	4 =? ( 4drop 0 
		setrayo
		5 playsnd
		; )
	dibrayos sspritez
	;
	
:+cruz | vx vy anim x y --
	'cruz 'obj p!+ >a
	swap a!+ a!+
	a!+ | anim
	swap a!+ a! ;

:setcruz2
	0 0 0 12 $20 ICS>anim 
	xjug xjugv fix. + 128.0 randmax + 64.0 -
	200.0 +cruz 	
	;

:jhit
	1050.0 xbana - int. abs
	32 >? ( drop 0 ; ) drop
	500.0 ybana - int. abs
	32 >? ( drop 0 ; ) drop
	1 ;
	
:jefe
	1600.0 xjug - int. 
	460 3.0 msec 11 >> $1 and dibjefe sspritez
	jhit 0? ( drop ; ) drop
	-1 'jefevidas +!
	exit
	;
	
:juegofinal
	vini
	vupdate
	$40C87C sdlcls

	planos
	'dis p.draw	
	
	banana
	jugador
	'obj p.draw
	'fx p.draw		
	jefe
	panel
	100 randmax 0? ( setcruz2 ) drop
	mecanica
	vredraw

	sdlkey
	>esc< =? ( exit )
	<esp> =? ( shoot )	
	<up> =? ( 508.0 yjug =? ( -10.0 'yvel ! 1 playsnd ) drop )
	<ri> =? ( 0.1 'xacc ! fogr ) >ri< =? ( 0.0 'xacc ! )
	<le> =? ( -0.1 'xacc ! fogl ) >le< =? ( 0.0 'xacc ! )
|	<f1> =? ( randloro )
|	<f2> =? ( setrayo )
|	<f3> =? ( setcruz2 )
|	<f2> =? ( 1 'estado ! exit )
|	<f3> =? ( 2 'estado ! exit )
	drop
	;

:flash
	vupdate
	0 sdlcls
	sw 2/ sh 2/ 4.0 msec 4 >> 11 mod dibrayos sspritez
	sdlredraw ;
	
:secuencia
	resetjuego
	musjue 1 Mix_PlayMusic
	sndmonofeliz
	randloro
	'juego sdlshow
	Mix_HaltMusic	
	0.1 'xvel !
	estado
	0? ( drop ; ) 
	1 =? ( drop muertemono ; )
	drop
|	0 'estado !
	resetjuego
	troncoder
|	musjue 1 Mix_PlayMusic
	
	5 playsnd
	'exit 1.0 +vexe
	'flash sdlshow
	sndmonofeliz
	'juegofinal sdlshow
|	Mix_HaltMusic	
	0.1 'xvel !
	estado
	0? ( drop ; ) 
	1 =? ( drop muertemono ; )
	drop
	|---- ganador
	2 'estado !
	;

#msggano
"Fin de Juego

Ganaste la Partida"

#msgperdio	
"Fin de Juego

No venciste al Jefe final"
	
#mensaje 'msgperdio

:showfin
	vini
	vupdate
	$40C87C sdlcls
	planos

	0.5 %w 0.2 %h 1.0 logo spritez		
	
	$11 txalign	
	$0 txrgb
	0.8 %w 0.5 %h 0.1 %w 2 + 0.3 %h 2 +
	mensaje txText

	$ffffff txrgb
	0.8 %w 0.5 %h 0.1 %w 0.3 %h 
	mensaje txText
	
	vredraw
	sdlkey
	>esc< =? ( exit )
	drop ;
	;
	

:jugar
	0 'estado !
	secuencia
	estado
	1 =? ( 'msgperdio 'mensaje ! ) | fin juego
	2 =? ( 'msggano 'mensaje ! ) | juego ganado
	drop
	'exit 8.0 +vexe	
	'showfin sdlshow
	;
	
|----------------------------------
#volmusa
#volsfxa

:opcion
	vini
	vupdate
	$40C87C sdlcls
	planos
	uiStart
	3 4 uiPad
	0.2 %w 0.5 %h 0.6 %w 0.4 %h uiWin!
	
	2 5 uiGridA uiv
	0 0 uiGAt
	"Musica" uiLabelC
	"SFX" uiLabelC
|	"Pantalla" uiLabelC
	1 0 uiGAt
	stlink
	0 1.0 'volmus uiProgressf
	0 1.0 'volsfx uiProgressf
	"" uiLabel
	stDang
	'exit "ESC - Salir" uiRBtn

	uiEnd
	0.5 %w 0.2 %h 1.0 logo spritez		
	|sdlredraw
	vredraw
	sdlkey
	>esc< =? ( exit )
	drop
	volmus volmusa <>? ( dup 'volmusa ! dup 128 1.0 */ Mix_VolumeMusic ) drop
	volsfx volsfxa <>? ( dup 'volsfxa ! dup 128 1.0 */ Mix_MasterVolume 2 playsnd ) drop
	;

:opciones
	volmus 'volmusa !
	volsfx 'volsfxa !
	volmus 128 1.0 */ Mix_VolumeMusic
	volsfx 128 1.0 */ Mix_MasterVolume
	musopc 1 Mix_Playmusic	
	'opcion sdlshow 
	Mix_HaltMusic
	;
	
|----------------------------------	
:logoin
	'logopos	
	0.49 %w 0.2 %h 0 0.5 xyrz64
	0.49 %w -0.2 %h -1.0 0.5 xyrz64
	24 1.0 0.0 +vboxanim 
	
	'logopos	
	0.49 %w 1.4 %h 1.0 1.2 xyrz64	
	0.49 %w 0.2 %h 0 0.5 xyrz64
	24 3.0 2.0 +vboxanim 

	'logoin 5.0 +vexe
	;	

:stJu $ffFBE800ffCAB900 'cifil ! ;	| Jugar
:stOp $ff40C87Cff288153 'cifil ! ;	| Opciones
:stCr $ff734300ff402000 'cifil ! ;	| Creditos
	
:inicio
	vini
	vupdate
	$40C87C sdlcls
	planos
	uiStart
	3 4 uiPad
	0.3 %w 0.5 %h 0.4 %w 0.4 %h uiWin!
	1 5 uiGridA uiv
	stJu
	'jugar "Jugar" uiRBtn
	stOp
	'opciones "Opciones" uiRBtn
	stCr
|	'opciones "Creditos" uiRBtn
	"" uiLabel
	stDang
	'exit "ESC - Salir" uiRBtn
	uiEnd
	
	logopos 64xyrz logo spriteRZ
	
	vredraw
	sdlkey
	<esp> =? ( jugar )
	<f1> =? ( jugar )
	<f2> =? ( opciones )
	>esc< =? ( exit )
	drop
	;

|----------------------------------
:
"bananarush" 1024 600 sdlinitr
1024 600 vscreen
16 16 "bananarush.png" infile ssload 'dibujos !
64 32 "aguila.png" infile ssload 'dibaguila !
70 70 "jefe.png" infile ssload 'dibjefe !
512 150 "fondo.png" infile ssload 'fondos !
60 214 "rayos.png" infile ssload 'dibrayos !
70 25 "tronco.png" infile ssload 'dibtronco !
"logo.png" infile loadimg 'logo !

"bananarush.mp3" infile mix_loadmus 'musini !
"bananarush.mp3" infile mix_loadmus 'musjue !
"bananarush.mp3" infile mix_loadmus 'musopc !
"bananarush.mp3" infile mix_loadmus 'musfin !

"PressStart2P-Regular.ttf" infile 24 txload 'font !
font txfont
0 'cifoc !
64 vaini

50 'obj p.ini
50 'dis p.ini
50 'fx p.ini

loadsnd
0.1 'xvel !
logoin

'inicio sdlshow

|'juego sdlshow
|'showfin sdlshow
vfree
;
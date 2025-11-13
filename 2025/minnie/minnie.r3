| Perro Minnie y Daise
| ITI 2025
|
^r3/lib/sdl2gfx.r3
^r3/util/varanim.r3

#fondo
#dibujos
#dibgato

#xf1 500.0
#xf2 500.0
#xf3 500.0
#xf4 500.0

#xjug 400.0 #xvjug 
#yjug 500.0 #yvjug
#ajug

#xgat 700.0 #ygat 480.0 #agat


:diblayer | y nro x --
	int. 
	dup pick3 8.0 pick4 fondo sspritez
	dup 1024 + pick3 8.0 pick4 fondo sspritez
	dup 1024 - pick3 8.0 pick4 fondo sspritez
	3drop ;
	
:velayer | vv 'var vel -- vv
	pick2 *. | vv 'var vel
	over +!
	dup @
	-1024.0 <? ( 1024.0 pick2 +! )
	1024.0 >? ( -1024.0 pick2 +! )
	2drop ;
	
:fondopant
	$666666 sdlcls
	250 0 xf1 diblayer
	160 1 xf2 diblayer
	340 2 xf3 diblayer
	340 3 xf4 diblayer
	xvjug
	'xf1 -0.3 velayer
	'xf2 -0.4 velayer
	'xf3 -0.8 velayer
	'xf4 -1.0 velayer
	neg 'xgat +!

	;
|----------------

:gato
	xgat int. ygat int. 2.0 
	deltatime 'agat +! agat anim>n
	dibgato sspritez
	;
	
|----------------
:jugador
	xjug int. yjug int. 5.0 
	deltatime 'ajug +! ajug anim>n
	dibujos sspritez
	;
	
:jder
	xvjug 0.9 =? ( drop ; ) drop
	0.9 'xvjug ! 2 3 $7f ICS>anim 'ajug ! ;

:jders
	xvjug 0.9 <>? ( drop ; ) drop
	0 'xvjug ! 0 1 1 ICS>anim 'ajug ! ;

:jizq
	xvjug -0.9 =? ( drop ; ) drop
	-0.9 'xvjug ! 7 3 $7f ICS>anim 'ajug ! ;

:jizqs
	xvjug -0.9 <>? ( drop ; ) drop
	0 'xvjug ! 5 1 1 ICS>anim 'ajug ! ;
	
:perrodir
	ajug 52 >>> 5 <? ( 0 nip ; ) 5 nip ;
	
	
	
:ladra	
	0 'xvjug ! 
	perrodir 2 $7f ICS>anim 'ajug ! ;
	
:juego
	vupdate
	fondopant	
	gato
	jugador
	
	sdlredraw
	sdlkey
	>esc< =? ( exit )
	<le> =? ( jizq ) >le< =? ( jizqs )
	<ri> =? ( jder ) >ri< =? ( jders ) 
	<esp> =? ( ladra )
	drop
	;

|-----------------------------------
#filepath "r3/2025/minnie/"
:infile 'filepath "%s%s" sprint ;

:
"minnie" 1024 600 sdlinit
128 64 "fondo.png" infile ssload 'fondo !
50 32 "sprites.png" infile ssload 'dibujos !
64 64 "gato.png" infile ssload 'dibgato !
64 vaini
0 4 $3f ICS>anim 'agat !
'juego sdlshow
;
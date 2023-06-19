^r3/win/sdl2gfx.r3
^r3/win/sdl2image.r3
^r3/util/tilesheet.r3
^r3/util/arr16.r3


#fondoa	| arco

#sprpelota
#sprmessi
#sprdibu
#sprarq

#obj 0 0

#playerpad

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

| x y ang anim ss vx vy ar  z 	vz
| 0 8 16  24   32 40 48 56  64  72

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

|--------------------------------------
:rebote | obj -- obj
	dup 64 + @ over 72 + @ +
	0? ( drop ; ) 
	-? ( drop
		0 over 64 + !
		dup 72 + @ -0.8 *. over 72 + ! 
		; )
	over 64 + !
	-0.3 over 72 + +!
	;
	
:pelota
	dup >a
	a@+ int. a@+ int. 40 +	| x y
	pick2 64 + @ int. -
	a@+ dup 32 >> swap $ffffffff and | rot zoom
	a@ time+ dup a!+ nanim 			| n
	a@+ sspriterz
	dup 40 + @ over +!
	dup 48 + @ over 8 + +!
	dup 56 + @ over 16 + +!
	rebote	
	playerpad $10 and? ( 6.0 pick2 72 + ! ) drop
	drop ;
	
:+pelota
	'pelota 'obj p!+ >a 
	400.0 a!+ 
	300.0 a!+	| x y 
	1.0 a!+				| ang zoom
	7 0 0 vni>anim | vel cnt ini 
	a!+	sprpelota a!+	| anim sheet
	0 a!+ 0 a!+ 0 a!+	| vx vy vrz
	0 a!+ 0 a! 			| z vz
	;

|--------------------------------------
#npcpad

:npc
	objsprite
	drop ;
	
:+npc
	'npc 'obj p!+ >a 
	200.0 a!+ 
	400.0 a!+	| x y 
	2.0 a!+	| ang zoom
	7 0 0 vni>anim | vel cnt ini 
	a!+ sprarq a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!			| vrz
	;

|--------------------------------------


:vel 
	$1 and? ( -1.0 nip ; ) 
	$2 and? ( 1.0 nip ; )
	;
	
:jugador
	objsprite
	playerpad vel over 40 + ! 
	playerpad 2 >> vel over 48 + ! 
	drop ;
	
:+jugador
	'jugador 'obj p!+ >a 
	400.0 a!+ 
	400.0 a!+	| x y 
	2.0 a!+	| ang zoom
	7 0 0 vni>anim | vel cnt ini 
	a!+	sprmessi a!+			| anim sheet
	0 a!+ 0 a!+ 	| vx vy
	0 a!			| vrz
	;
	
:juego
	time.

|	0 SDLcls
	0 0 fondoa SDLImage
	'obj p.draw	
	2 'obj p.sort	
	SDLredraw
	
	SDLkey
	>esc< =? ( exit )
	<le> =? ( playerpad $01 or 'playerpad ! )	>le< =? ( playerpad $fe and 'playerpad ! )
	<ri> =? ( playerpad $02 or 'playerpad ! )	>ri< =? ( playerpad $fd and 'playerpad ! )	
	<up> =? ( playerpad $04 or 'playerpad ! )	>up< =? ( playerpad $fb and 'playerpad ! )
	<dn> =? ( playerpad $08 or 'playerpad ! )	>dn< =? ( playerpad $f7 and 'playerpad ! )
	<esp> =? ( playerpad $10 or 'playerpad ! )	>esp< =? ( playerpad $ef and 'playerpad ! )
	drop 	
	;
	
:main
	"r3sdl" 800 600 SDLinit
	
	"r3/itinerario/penal/arco.png" loadimg 'fondoa !
	64 64 "r3/itinerario/penal/messi.png" ssload 'sprmessi !
	64 64 "r3/itinerario/penal/dibu.png" ssload 'sprdibu !
	64 64 "r3/itinerario/penal/arquero.png" ssload 'sprarq !
	64 64 "r3/itinerario/penal/pelota.png" ssload 'sprpelota !

	timeI
	10 'obj p.ini	
	+jugador
	+pelota
	+npc	
	'juego SDLshow
	SDLquit ;	
	
: main ;
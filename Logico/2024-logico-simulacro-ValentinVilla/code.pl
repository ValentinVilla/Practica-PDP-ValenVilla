%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    STEAM SUMMER SALE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% - juego(Precio, Nombre).
juego(2000, mortalKombat).
juego(25000, callOfDuty).
juego(5500, counterStrike).
juego(5000, gta).
juego(2700, pubg).
juego(7000, minecraft).
juego(100, candyCrush).
juego(10, encontraPalabra).

% - accion(Juego).
accion(mortalKombat).                       
accion(callOfDuty).                         
accion(counterStrike).                     

% - rol(Juego, CantidadUsuarios).
rol(gta , 2300000).
rol(pubg,  860000).
rol(minecraft, 999888).

% - puzzle(Juego, CantidadNiveles, Dificultad).
puzzle(candyCrush, 1000, facil).
puzzle(encontraPalabra, 50, dificil).

% - descuento(Juego, Descuento).
descuento(mortalKombat, 95).
descuento(pubg, 50).

% - esDe(Juego, Genero).
esDe(mortalKombat, accion).
esDe(callOfDuty, accion).
esDe(counterStrike, accion).
esDe(gta, rol).
esDe(pubg, rol).
esDe(minecraft, rol).
esDe(candyCrush, puzzle).
esDe(encontraPalabra, puzzle).

%%%%%
%(1)%
%%%%%

esJuego(Juego):-
    juego(_,Juego).

cuantoSale(Juego, Precio):-
    esJuego(Juego),
    not(descuento(Juego, Descuento)),
    juego(Precio, Juego).

cuantoSale(Juego, Precio):-
    esJuego(Juego),
    descuento(Juego, Descuento),
    precioConDescuento(Juego, Descuento, Precio).

precioConDescuento(Juego, Descuento, Precio):-
    juego(PrecioOriginal, Juego),
    descuento(Juego, Descuento),
    Precio is PrecioOriginal - ((PrecioOriginal * Descuento)/ 100).

%%%%%
%(2)%
%%%%%

tieneBuenDescuento(Juego):-
    esJuego(Juego),
    descuento(Juego, Descuento),
    Descuento >= 50.

%%%%%
%(3)%
%%%%%

esPopular(minecraft).
esPopular(counterStrike).

esPopular(Juego):-
    esJuego(Juego),
    accion(Juego).

esPopular(Juego):-
    esJuego(Juego),
    rol(Juego, CantidadUsuarios),
    CantidadUsuarios > 1000000.

esPopular(Juego):-
    esJuego(Juego),
    puzzle(Juego, _ , facil).
     
esPopular(Juego):-
    esJuego(Juego),
    puzzle(Juego, 25, _).

%%%%%
%(4)%
%%%%%

% - juegosQuePosee(Nombre, JuegoQuePosee).
juegosQuePosee(valenVilla, counterStrike).
juegosQuePosee(valenVilla, mortalKombat).
juegosQuePosee(valenVilla, candyCrush).
juegosQuePosee(valenVilla, callOfDuty).

juegosQuePosee(juan, callOfDuty).
juegosQuePosee(juan, mortalKombat).

% - juegosParaAdquirir(Nombre, regalo(Juego,Persona)).
juegosParaAdquirir(valenVilla, regalo(mortalKombat, juan)).
juegosParaAdquirir(valenVilla, regalo(pubg, juan)).

juegosParaAdquirir(juan, regalo(minecraft, valenVilla)).
juegosParaAdquirir(juan, regalo(encontraPalabra, valenVilla)).

% - juegosParaAdquirir(Nombre, personnal(Juego)).
juegosParaAdquirir(valenVilla, personal(pubg)).


unUsuario(Usuario):-
    juegosQuePosee(Usuario, _).
unUsuario(Usuario):-
    juegosParaAdquirir(Usuario,_).

usuarioRegalador(Usuario):-
    juegosParaAdquirir(Usuario, regalo(_,_)).

% - Funcion Principal
adictoALosDescuentos(Usuario):-
    unUsuario(Usuario),
    forall(juegoAAdquirir(Usuario, Juego), tieneBuenDescuento(Juego)).

juegoAAdquirir(Usuario, Juego):-
    juegosParaAdquirir(Usuario, regalo(Juego, _)).

juegoAAdquirir(Usuario, Juego):-
    juegosParaAdquirir(Usuario, personal(Juego)).
    
%%%%%
%(5)%
%%%%%

unGenero(Genero):-
    esDe(_,Genero).

esFanatico(Usuario, Genero):-
    unGenero(Genero),
    juegosQuePosee(Usuario, Juego1),
    juegosQuePosee(Usuario, Juego2),
    Juego1 \= Juego2,
    sonDelMismoGenero(Juego1, Juego2, Genero).

sonDelMismoGenero(Juego1, Juego2, Genero):-
    esDe(Juego1, Genero),
    esDe(Juego2, Genero).

%%%%%
%(6)%
%%%%%

esMonotematico(Usuario, Genero):-
    unUsuario(Usuario),
    unGenero(Genero),
    forall(juegosQuePosee(Usuario, Juego), esDe(Juego, Genero)).

%%%%%
%(7)%
%%%%%

buenosAmigos(Usuario1, Usuario2):-
    juegosParaAdquirir(Usuario1, regalo(Juego1, Usuario2)),
    juegosParaAdquirir(Usuario2, regalo(Juego2, Usuario1)),
    esPopular(Juego1),
    esPopular(Juego2).

%%%%%
%(8)%
%%%%%

cuantoGastara(Usuario, Total):-
    unUsuario(Usuario),
    findall(Precio, precioDeJuego(Usuario, Precio), PrecioJuegosTotales),
    sumlist(PrecioJuegosTotales, Total).

precioDeJuego(Usuario, Precio):-
    juegosQuePosee(Usuario, Juego),
    cuantoSale(Juego, Precio).

precioDeJuego(Usuario, Precio):-
    juegosParaAdquirir(Usuario, JuegoFunctor),
    nombreJuegoFunctor(Juego, JuegoFunctor),
    cuantoSale(Juego, Precio).

nombreJuegoFunctor(Juego, regalo(Juego,_)).
nombreJuegoFunctor(Juego, personal(Juego)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

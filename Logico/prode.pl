%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          PRODE         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  https://www.utnianos.com.ar/foro/attachment.php?aid=22492


%resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais).
resultado(paises_bajos, 3, estados_unidos, 1). % Paises bajos 3 - 1 Estados unidos
resultado(australia, 1, argentina, 2). % Australia 1 - 2 Argentina
resultado(polonia, 3, francia, 1).
resultado(inglaterra, 3, senegal, 0).

% pronostico(Nombre, Resultado).
pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).
%pronostico(gus, gano(estados_unidos, paises_bajos, 1, 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1, 0)).

esPais(argentina).
esPais(paises_bajos).
esPais(australia).
esPais(polonia).
esPais(inglaterra).
esPais(japon).
esPais(croacia).
esPais(senegal).
esPais(estados_unidos).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 1 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% A )

resultadoSimetrico(Pais1, Goles1, Pais2, Goles2) :- 
    resultado(Pais1, Goles1, Pais2, Goles2).
    
resultadoSimetrico(Pais1, Goles1, Pais2, Goles2) :- 
    resultado(Pais2, Goles2, Pais1, Goles1).

jugaron(Pais1, Pais2, DiferenciaGoles):-
    resultadoSimetrico(Pais1, Goles1, Pais2, Goles2),
    DiferenciaGolesSinModulo is Goles1 - Goles2,
    DiferenciaGoles is abs(DiferenciaGolesSinModulo).

% B )

% leGano(Ganador, Perdedor).
leGano(Pais1, Pais2):-
    resultadoSimetrico(Pais1, Goles1, Pais2, Goles2),
    Goles1 > Goles2. 

%leGano(PaisGanador, PaisPerdedor) :-
%    jugaron(PaisGanador, PaisPerdedor, DiferenciaGol),
%    DiferenciaGol > 0.



%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 2 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% puntosPronostico(Pronostico, Puntos)
puntosPronostico(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 200):-
    leGano(PaisGanador, PaisPerdedor),
    resultadoSimetrico(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor ).

puntosPronostico(empataron(Pais1, Pais2, Goles1), 200):-
    partidoEmpatado(Pais1, Pais2),
    resultadoSimetrico(Pais1, Goles1, _, _).

%%

puntosPronostico(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 100):-
    leGano(PaisGanador, PaisPerdedor),
    resultadoSimetrico(PaisGanador, Goles1, PaisPerdedor, Goles2 ),
    Goles1 \= GolesGanador,
    Goles2 \= GolesPerdedor.

puntosPronostico(empataron(Pais1, Pais2, Goles1), 100):-
    partidoEmpatado(Pais1, Pais2),
    resultadoSimetrico(Pais1, Goles, _, _),
    Goles \= Goles1.

%%
puntosPronostico(gano(PaisGanador, PaisPerdedor,_ , _ ), 0):-
    leGano(PaisPerdedor, PaisGanador).


puntosPronostico(empataron(Pais1, Pais2, _), 0):-
    resultadoSimetrico(Pais1, _ , Pais2, _ ),
    not(partidoEmpatado(Pais1, Pais2)).


partidoEmpatado(Pais1, Pais2):-
    jugaron(Pais1, Pais2, 0).


%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 3 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

%  pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
%  pronostico(juan, gano(argentina, australia, 3, 0)).
%  pronostico(juan, empataron(inglaterra, senegal, 0)).

invicto(Persona):-
    pronostico(Persona, _),
    forall((pronostico(Persona, Pronostico), hayResultadoParaPartido(Pronostico)),
           sacoAlMenos100Punto(Pronostico)).
    
hayResultadoParaPartido(gano(PaisGanador, PaisPerdedor, _, _)) :-
    jugaron(PaisGanador, PaisPerdedor, _).

hayResultadoParaPartido(empataron(UnPais, OtroPais, _)) :-
    jugaron(UnPais, OtroPais, _).

sacoAlMenos100Punto(Pronostico) :-
    puntosPronostico(Pronostico, Puntos),
    Puntos >= 100.
 

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 4 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

puntaje(Jugador, Puntaje):-
    pronostico(Jugador, _),
    findall(Punto, (pronostico(Jugador, Pronostico),puntosPronostico(Pronostico, Punto)), ListaPuntos),
    sumlist(ListaPuntos, Puntaje).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 5 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% favorito(Pais)
    % Un pais es favorito si:
        % - Todos los pronósticos que se hicieron sobre ese pais lo ponen como ganador
        % - O si todos los partidos que jugo los gano por goleada (por diferencia de 3 goles).

favorito(Pais) :-
    estaEnElPronostico(Pais, _),
    forall(estaEnElPronostico(Pais, Pronostico), loDaComoGanador(Pais, Pronostico)).

favorito(Pais) :-
    resultadoSimetrico(Pais, _, _, _),
    forall(jugaron(Pais, _, DiferenciaGol), DiferenciaGol >= 3).

% loDaComoGanador(Pais, Pronostico)
loDaComoGanador(Pais, gano(Pais, _, _, _)).

% estaEnElPronostico(Pais, Pronostico)
estaEnElPronostico(Pais, gano(Pais, OtroPais, Goles1, Goles2)) :-
    pronostico(_, gano(Pais, OtroPais, Goles1, Goles2)).
estaEnElPronostico(Pais, gano(OtroPais, Pais, Goles1, Goles2)) :-
    pronostico(_, gano(OtroPais, Pais, Goles1, Goles2)).
estaEnElPronostico(Pais, empataron(Pais, OtroPais, Goles)) :-
    pronostico(_, empataron(Pais, OtroPais, Goles)).
estaEnElPronostico(Pais, empataron(OtroPais, Pais, Goles)) :-
    pronostico(_, empataron(OtroPais, Pais, Goles)).


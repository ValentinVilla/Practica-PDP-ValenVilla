%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         TURF         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://docs.google.com/document/d/10595YW29D7NgmpuvEWpEBjrwcHhszKeU89CkRSlgqEI/edit#heading=h.skc2yqf727q1

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 1 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% - jockey(Nombre, Altura, Peso, StudQueRepresenta).

jockey(valdivieso, 155, 52, elTute).
jockey(leguisamo, 161, 49, elCharabon).
jockey(lezcano, 149, 50, lasHormigas).
jockey(baratucci, 153, 55, elCharabon).
jockey(falero, 157, 52, elTute).

% - caballo(NombreDekCaballo).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

% - prefiereJockey(Caballo, Jockey).

prefiereJockey(botafogo, baratucci).

prefiereJockey(botafogo, Jockey):-
    pesoJockey(Jockey, Peso),
    Peso < 52.

prefiereJockey(oldMan, Jockey):-
    esJockey(Jockey),
    atom_length(Jockey, CantidadDeLetras),
    CantidadDeLetras > 7.

prefiereJockey(energica, Jockey):-
    esJockey(Jockey),
    not(prefiereJockey(botafogo, Jockey)).

prefiereJockey(matBoy, Jockey):-
    alturaJockey(Jockey, Altura),
    Altura > 170.

% Aca puedo no hace falta poner que yatasto prefiere "nadie" ya que por principio de universo cerrado
% lo q no esta definidio es falso.

%% Predicados Auxiliares %%

pesoJockey(Jockey, Peso):-
    jockey(Jockey, _, Peso, _).

esJockey(Jockey):-
    jockey(Jockey, _, _, _).

alturaJockey(Jockey, Altura):-
    jockey(Jockey,Altura,_,_).

% - gano(Caballo, premio)

gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).

gano(oldMan, granPremioRepublica).
gano(oldMan, campeonatoPalermoDeOro).

gano(matBoy, granPremioCriadores).

% Aca puedo no poner a yatasto y a energica ya que por principio de universo cerrado, lo q no esta definidio es falso.

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 2 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

prefiereMasDeUnJockey(Caballo):-
    prefiereJockey(Caballo, Jockey1),
    prefiereJockey(Caballo, Jockey2),
    Jockey1 \= Jockey2.

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 3 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

noPrefiereNingunJockey(Caballo):-
    caballo(Caballo),
    not(prefiereJockey(Caballo,_)).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 4 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

jockeyPiolin(Jockey):-
    esJockey(Jockey),
    forall( ganoPremioImportante(Caballo) ,  prefiereJockey(Caballo,Jockey)).

ganoPremioImportante(Caballo):-
    gano(Caballo, granPremioNacional).
ganoPremioImportante(Caballo):-
    gano(Caballo, granPremioRepublica).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 5 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% - apuesta(Tipo(CaballosAApostar))

apuesta(ganadorPorUnCaballo(Caballo)).
apuesta(segundoPorUnCaballo(Caballo)).
apuesta(exacta(Caballo1, Caballo2)).
apuesta(imperfecta(Caballo1, Caballo2)).

% - apuestaGanadora(Apuesta, Resultado).        
%  Resultado es una lista de caballos donde el primero es el gandor el segundo el segundo y asi ...

apuestaGanadora(ganadorPorUnCaballo(Caballo), Resultado) :-
  caballoSalePrimero(Caballo, Resultado).

apuestaGanadora(segundoPorUnCaballo(Caballo), Resultado) :-
  caballoSalePrimeroOSegundo(Caballo, Resultado).

apuestaGanadora(exacta(Caballo1, Caballo2), Resultado) :-
  caballoSalePrimero(Caballo1, Resultado),
  caballoSaleSegundo(Caballo2, Resultado).

apuestaGanadora(imperfecta(Caballo1, Caballo2), Resultado) :-
  caballoSalePrimeroOSegundo(Caballo1, Resultado),
  caballoSalePrimeroOSegundo(Caballo2, Resultado).

caballoSalePrimero(Caballo, Resultado):-
    nth1(1,Resultado,Caballo).

caballoSaleSegundo(Caballo, Resultado):-
    nth1(2,Resultado,Caballo).

caballoSalePrimeroOSegundo(Caballo, Resultado):-
    caballoSalePrimero(Caballo, Resultado).

caballoSalePrimeroOSegundo(Caballo, Resultado):-
    caballoSaleSegundo(Caballo, Resultado).
%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 6 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

crin(botafogo, tordo).
crin(oldMan, alazan).
crin(energica, ratonero).
crin(matBoy, palomino).
crin(yatasto, pinto).

color(tordo, negro).
color(alazan, marron).
color(ratonero, gris).
color(ratonero, negro).
color(palomino, marron).
color(palomino, blanco).
color(pinto, blanco).
color(pinto, marron).

comprar(Color, Caballos):-
  findall(Caballo, (crin(Caballo, Crin), color(Crin, Color)), CaballosPosibles),
  combinar(CaballosPosibles, Caballos),
  Caballos \= [].

combinar([], []).

combinar([Caballo|CaballosPosibles], [Caballo|Caballos]):-
    combinar(CaballosPosibles, Caballos).

combinar([_|CaballosPosibles], Caballos):-
    combinar(CaballosPosibles, Caballos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
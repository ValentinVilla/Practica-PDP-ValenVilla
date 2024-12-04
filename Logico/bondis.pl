%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         ¡Pensando en el Bondi!        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://docs.google.com/document/d/1xFUxx_4XGdg9TXltWtxY-3zL2E6xEKuEccQDLtEui3c/edit?tab=t.0

%recorrido(Linea, Zona, CalleAtraviesa)
% RECORRIDOS DE GBA
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247,gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).

% RECORRIDOS DE CABA
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).

%%%%%%%%%%%%%%%
%%%%Punto 1%%%%
%%%%%%%%%%%%%%%
puedeCombinarse(Linea1, Linea2):-
    recorrido(Linea1, Zona, Calle),
    recorrido(Linea2, Zona, Calle),
    Linea1 \= Linea2.

%%%%%%%%%%%%%%%
%%%%Punto 2%%%%
%%%%%%%%%%%%%%%
jurisdiccion(Linea, nacional):-
    cruzaGralPaz(Linea).

cruzaGralPaz(Linea):-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_), _).

jurisdiccion(Linea, provincial(Provincia)):-
    recorrdido(Linea, Zona, _),
    perteneceA(Zona, Provincia)
    not(cruzaGralPaz(Linea)).

perteneceA(caba, caba).
perteneceA(gba(_), buenosAires).

%%%%%%%%%%%%%%%
%%%%Punto 3%%%%
%%%%%%%%%%%%%%%

cuantasLineasPasan(Calle, Zona, Cantidad):-
    recorrido(_, Zona, Calle),
    findall(Calle, recorrdido(_, Zona, Calle), Calles),
    length(Calle, Cantidad).
    
calleMasTransitada(Calle, Zona):-
    cuantasLineasPasan(Calle, Zona, Cantidad),
    forall((recorrido(_, Zona, OtraCalle), Calle \= OtraCalle) , (cuantasLineasPasan(OtraCalle, Zona, CantidadMenor), Cantidad > CantidadMenor)).

%%%%%%%%%%%%%%%
%%%%Punto 4%%%%
%%%%%%%%%%%%%%%

calleTrasbordo(Calle, Zona):-
    recorrido(_, Zona, Calle),
    forall((recorrdido(Linea,Zona, OtraCalle), Calle \= OtraCalle), jurisdiccion(Linea, nacional)),
    cuantasLineasPasan(Calle, Zona, CantidadLineasCalleTrasbordo),
    CantidadLineasCalleTrasbordo >= 3.

%%%%%%%%%%%%%%%
%%%%Punto 5%%%%
%%%%%%%%%%%%%%%
persona(pepito).
persona(juanita).
persona(tito).
persona(marta).


beneficiario(pepito, personalParticular(gba(oeste))).
beneficiario(juanita, estudiantil).
beneficiario(marta, jubilado).
beneficiario(marta, personalParticular(caba)).
beneficiario(marta, personalParticular(gba(sur))).

beneficio(estudiantil, _ , 50).

beneficio(jubilado, Linea , Costo ):-
    valorBoleto(Linea, Valor),
    Costo is Valor // 2.

beneficio(personalParticular(Zona), Linea, 0):-
    recorrido(Linea, Zona, _).

plus(Linea, 50):-
    pasaPorDistintasZonas(Linea).

plus(Linea, 0):-
    not(pasaPorDistintasZonas(Linea)).

pasaPorDistintasZonas(Linea):-
    recorrido(Linea, Zona1, _),
    recorrido(Linea, Zona2, _),
    Zona1 \= Zona2.

valorBoleto(Linea, 500):-
    jurisdiccion(Linea, nacional).

valorBoleto(Linea, 350):-
    jurisdiccion(Linea, provincial(caba)).

valorBoleto(Linea, Costo):-
    jurisdiccion(Linea, provincial(buenosAires)),
    cantidadCallesRecorrido(Linea, Cantidad),
    plus(Linea, Plus),
    Costo is Cantidad * 25 + Plus.

cantidadCallesRecorrido(Linea, Cantidad):-
    findall(Calle, recorrido(Linea, _, Calle), Calles),
    length(Calles, Cantidad).


posiblesBeneficios(Persona, Linea, ValorConBeneficio):-
    beneficiario(Persona, Beneficio),
    beneficio(Beneficio, Linea, ValorConBeneficio).


viajarCuesta(Persona, Linea, MontoFinal):-
    beneficiario(Persona, _ ),
    recorrdido(Linea,_,_),
    posiblesBeneficios(Persona, Linea, MontoFinal),
    forall((posiblesBeneficios(Persona,Linea, OtroValorBeneficiado), OtroValorBeneficiado \= MontoFinal) , 
            MontoFinal < OtroValorBeneficiado)

viajarCuesta(Persona, Linea, ValorNormal):-
   persona(Persona),
   not(beneficiario(Persona, _)),
   valorBoleto(Linea, ValorNormal).
   


%  Si quisiéramos agregar otro beneficio, sea cual sea, seria fácil de implementar gracias al polimorfismo, debido a 
%  que sólo deberíamos agregarlo junto con sus condiciones en el predicado beneficio/1, lo cual no nos genera mucha 
%  dificultad, por lo tanto, el agregado de estos no nos cambiaria la solución.


















% Modelo los hechos
% Padres: 
padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).

% Madres:
madreDe(edwina, abbie).
madreDe(mona, homero).
madreDe(gaby, herbert).
madreDe(jacqueline, marge).
madreDe(jacqueline, patty).
madreDe(jacqueline, selma).
madreDe(marge, bart).
madreDe(marge, hugo).
madreDe(marge, lisa).
madreDe(marge, maggie).
madreDe(selma, ling).

% Casados (Segun los Hijos)
casados(homero, marge).
casados(marge, homero).

casados(abe, mona).
casados(mona, abe).

casados(clancy, jacqueline).
casados(jacqueline, clancy).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  PUNTO 1  %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (A) tieneHijo/1: se cumple para una persona si tiene al menos un hijo o una hija.
tieneHijo(Personaje):-
    padreDe(Personaje, _).

tieneHijo(Personaje):-
    madreDe(Personaje, _).

% (B) hermanos/2: se cumple cuando estos dos personajes comparten madre y padre.
hermanos(Personaje1, Personaje2):-
    padreDe(Padre, Personaje1),
    padreDe(Padre, Personaje2),
    madreDe(Madre, Personaje1),
    madreDe(Madre, Personaje2),
    Personaje1 \= Personaje2.

% (C) medioHermanos/2: se cumple cuando estos dos personajes comparten solo un padre o una madre.
medioHermanos(Personaje1, Personaje2):-
    padreDe(Padre, Personaje1),
    padreDe(Padre, Personaje2),
    madreDe(Madre1, Personaje1),
    madreDe(Madre2, Personaje2),
    Madre1 \= Madre2,
    Personaje1 \= Personaje2.

medioHermanos(Personaje1, Personaje2):-
    padreDe(Padre1, Personaje1),
    padreDe(Padre2, Personaje2),
    madreDe(Madre, Personaje1),
    madreDe(Madre, Personaje2),
    Padre1 \= Padre2,
    Personaje1 \= Personaje2.

% (D) tioDe/2: se cumple para dos personajes si uno es hermano de la madre o del padre del otro.
tioDe(Tio, Sobrino):-
    hermanos(Tio, Padre),
    padreDe(Padre, Sobrino).

tioDe(Tio, Sobrino):-
    hermanos(Tio, Madre),
    madreDe(Madre, Sobrino).

% (E) abueloMultiple/1: se cumple cuando alguien es abuelo de al menos dos nietos
abueloMultiple(Abuelo):-
    padreDe(Abuelo, Padre),
    padreDe(Padre, Nieto1),
    padreDe(Padre, Nieto2),
    Nieto1 \= Nieto2.

% (F) cuniados/2: se cumple para dos personajes si uno está casado con un hermano o hermana del otro.
cuniados(Personaje1, Personaje2):-
    casados(Personaje1, Pareja),
    hermanos(Pareja, Personaje2).

cuniados(Personaje1, Personaje2):-
    casados(Personaje2, Pareja),
    hermanos(Pareja, Personaje1).

% (G) suegros/2: se cumple para dos personajes si uno está casado con un hijo o hija del otro.
suegros(Suegro, Yerno):-
    padreDe(Suegro, Pareja),
    casados(Yerno, Pareja).

suegros(Suegra, Yerno):-
    madreDe(Suegra, Pareja),
    casados(Yerno, Pareja).

% (H) consuegros/2: se cumple para dos personajes si uno está casado con un hermano o hermana del otro.

consuegros(Consuegro1, Consuegro2):-
    padreDe(Consuegro1, Hijo),
    casados(Hijo, Pareja),
    padreDe(Consuegro2, Pareja).

consuegros(Consuegra1, Consuegra2):-
    madreDe(Consuegra1, Hijo),
    casados(Hijo, Pareja),
    madreDe(Consuegra2, Pareja).

% (I) yernos/nueras/2: se cumple cuando una persona es yerno o nuera de otra.
yernos(Persona, Yerno):-
    padreDe(Persona, HijoHija),
    casados(Yerno, HijoHija).

nueras(Persona, Nuera):-
    padreDe(Persona, HijoHija),
    casados(Nuera, HijoHija).

% (J) primos/2: se cumple cuando dos personas son primos.
primos(Primo1, Primo2):-
    padreDe(Padre1, Primo1),
    padreDe(Padre2, Primo2),
    hermanos(Padre1, Padre2),
    Primo1 \= Primo2.

primos(Primo1, Primo2):-
    madreDe(Madre1, Primo1),
    madreDe(Madre2, Primo2),
    hermanos(Madre1, Madre2),
    Primo1 \= Primo2.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  PUNTO 2  %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  hacer descendiente/2: Relaciona a dos personajes, en donde uno desciende del otro
%  a través de una cantidad no predeterminada de generaciones. Por ejemplo, bart es 
%  descendiente de homero, de abe y también de sven simpson.

descendiente(Ascendente, Descendiente):-
    padreDe(Ascendente, Descendiente).

descendiente(Ascendente, Descendiente):-
    madreDe(Ascendente, Descendiente).

descendiente(Ascendente, Descendiente):-
    padreDe(Ascendente, Hijo),
    descendiente(Hijo, Descendiente).

descendiente(Ascendente, Descendiente):-
    madreDe(Ascendente, Hijo),
    descendiente(Hijo, Descendiente).

/*
El predicado descendiente/2 usa recursión para verificar si alguien desciende 
de otro a través de múltiples generaciones.
*/




































































































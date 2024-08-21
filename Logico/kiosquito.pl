%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         KIOSQUITO         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://docs.google.com/document/d/1RNgFMlSqOKiwe9SEi1U2cQjCmdFfWNflqycSfp7Qa-w/edit#heading=h.8z5fk89ui0rg

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 1 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% dodain atiende lunes, miércoles y viernes de 9 a 15.
kiosquero(dodain, 9, 15, lunes).
kiosquero(dodain, 9, 15, miercoles).
kiosquero(dodain, 9, 15, viernes).

% lucas atiende los martes de 10 a 20
kiosquero(lucas, 10, 20, martes).

% juanC atiende los sábados y domingos de 18 a 22.
kiosquero(juanC, 18, 22, sabados).
kiosquero(juanC, 18, 22, domingos).

% juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
kiosquero(juanFdS, 10, 20, jueves).
kiosquero(juanFdS, 12, 20, viernes).

% leoC atiende los lunes y los miércoles de 14 a 18.
kiosquero(leoC, 14, 18, lunes).
kiosquero(leoC, 14, 18, miercoles).

% martu atiende los miércoles de 23 a 24.
kiosquero(martu, 23, 24, miercoles).

% Definir la relación para asociar cada persona con el rango horario que cumple, e incorporar las siguientes cláusulas:
% - vale atiende los mismos días y horarios que dodain y juanC.
kiosquero(vale, HorarioInicio, HorarioFinal, Dia):-
    kiosquero(dodain, HorarioInicio, HorarioFinal, Dia).

kiosquero(vale, HorarioInicio, HorarioFinal, Dia):-
    kiosquero(juanC, HorarioInicio, HorarioFinal, Dia).


%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 2 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

atiende(Persona, Dia , HoraPuntual):-
    kiosquero(Persona, HorarioInicio, HorarioFinal, Dia),
    between(HorarioInicio, HorarioFinal, HoraPuntual).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 3 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

foreverAlone(Persona, Dia, HorarioPuntual):-
    atiende(Persona, Dia, HoraPuntual),
    not(atiende(Persona2, Dia, HorarioPuntual) , Persona \= Persona2).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 4 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

kiosquerosDelDia(Dia, Personas):-
    findall(Persona, distinct(Persona, atiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).

combinar([],[]).

combinar([Persona|PersonasPosibles], [Persona|Personas]):-
    combinar(PersonasPosibles, Personas).

combinar([_|PersonasPosibles], Personas):-
    combinar(PersonasPosibles, Personas).


% - Conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 5 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% - ventas(nombre, fecha(Dia, Mes), [objeto(caracteristicas)...]).

ventas(dodain, fecha(10, 8), [golosinas(1200) , cigarros([jockey]) , golosinas(50)]).
ventas(dodain, fecha(12, 8), [bebidas(8, alcoholicas) , bebidas(1, noAlcoholicas) , golosinas(10)]).

ventas(martu, fecha(10, 8), [golosinas(1000) , cigarros([chesterfield, colorado, parisiennes])]).

ventas(lucas, fecha(11, 8), [golosinas(600)]).
ventas(lucas, fecha(18, 8), [bebidas(2, noAlcoholicas) , cigarros([derby])]).


vendedorSuertudo(Kiosquero):-
    unKiosquero(Kiosquero),
    forall(ventas(Kiosquero, _, [Venta|_]), ventaImportante(Venta)).
 
unKiosquero(Kiosquero):-
    kiosquero(Kiosquero, _, _, _).

ventaImportante(golosinas(Precio)):-
    Precio > 100.

ventaImportante(cigarros(Marcas)):-
    length(Marcas, Cantidad),
    Cantidad > 2.

ventaImportante(bebidas(_, alcoholicas)).

ventaImportante(bebidas(Cantidad, noAlcoholicas)):-
    Cantidad > 5.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



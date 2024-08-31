%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          HOGWARTS          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://docs.google.com/document/u/1/d/e/2PACX-1vR9SBhz2J3lmqcMXOBs1BzSt7N1YWPoIuubAmQxPIOcnbn5Ow9REYt4NXQzOwXXiUaEQ4hfHNEt3_C7/pub

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PARTE I %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% - mago(Nombre, Sangre, Caracteristicas).

mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(draco, pura, [inteligencia, orgullo]).
mago(hermione, impura, [inteligencia, orgullo, responsabilidad]).

% - odiaria(Nombre, Casa).

odiaria(harry, slytherin).
odiaria(draco, hufflepuff).

% - unaCasa(Casa).

unaCasa(slytherin).
unaCasa(hufflepuff).
unaCasa(gryffindor).
unaCasa(ravenclaw).

% 1)

permiteEntrar(Mago, slytherin):-
    mago(Mago, Sangre, _),
    Sangre \= impura.

permiteEntrar(Mago, Casa):-
    unaCasa(Casa),
    mago(Mago,_,_),
    Casa \= slytherin.

% 2)

caracteristicaCasa(slytherin, orgullo).
caracteristicaCasa(slytherin, inteligencia).

caracteristicaCasa(gryffindor, coraje).

caracteristicaCasa(ravenclaw, inteligencia).
caracteristicaCasa(ravenclaw, responsabilidad).

caracteristicaCasa(hufflepuff, amistad).


caracterApropiado(Mago, Casa):-
    mago(Mago,_,Caracteristicas),
    unaCasa(Casa),
    forall(caracteristicaCasa(Casa, Caracteristica) , tieneCaracteristica(Mago, Caracteristica)).

tieneCaracteristica(Mago, Caracteristica):-
    mago(Mago,_,Caracteristicas),
    member(Caracteristica, Caracteristicas).

% 3)

puedeQuedarSeleccionado(hermione, gryffindor).

puedeQuedarSeleccionado(Mago, Casa):-
    caracterApropiado(Mago, Casa),
    permiteEntrar(Mago, Casa),
    noOdiaria(Mago, Casa).

noOdiaria(Mago, Casa):-
    mago(Mago,_,_),
    unaCasa(Casa),
    not(odiaria(Mago, Casa)).

% 4)

cadenaDeAmistades(Magos):-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).

todosAmistosos(Magos):-
    forall(member(Mago, Magos), esAmistoso(Mago)).

esAmistoso(Mago):-
    tieneCaracteristica(Mago, amistad).

cadenaDeCasas([Mago1 , Mago2 | MagosSiguientes]):-
    puedeQuedarSeleccionado(Mago1 , Casa),
    puedeQuedarSeleccionado(Mago2 , Casa),
    cadenaDeCasas([Mago2 | MagosSiguientes]).
cadenaDeCasas([_]).
cadenaDeCasas([]).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PARTE II %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% - accion(MAgo, Accion, tipo(Puntaje a subir o bajar)).

accion(harry, anduvoFueraDeCama, mala(50)).
accion(harry, fueAlBosque, mala(50)).
accion(harry, fueAlTercerPiso, mala(75)).
accion(harry, ganarVoldemort, buena(60)).

accion(hermione, fueAlTercerPiso, mala(75)).
accion(hermione, fueALaBiblioteca, mala(10)).
accion(hermione, salvarAmigos, buena(50)).

accion(draco, fueALaMazmorra).
%accion(draco, salvarAmigos, buena(50)).

accion(ron, ganoAjedrez, buena(50)).

accion(hermione, salvarAmigos, buena(50)).

% Ahora sabemos que ...
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% 1) 

hizoAccionNormal(Mago):-
    accion(Mago, _).
    
hizoAccionQueInfluye(Mago):-
    accion(Mago, _,_).

esBuenAlumno(Mago):-
    hizoAccionQueInfluye(Mago),
    forall(accion(Mago, Accion, _), noSonMalas(Accion)).

esBuenAlumno(Mago):-
    hizoAccionNormal(Mago).

noSonMalas(Accion):-
    accion(_, Accion, buena(_)).

% 2)

accionRecurrente(Accion):-
    accion(Mago1, Accion, _),
    accion(Mago2, Accion, _),
    Mago1 \= Mago2.

accionRecurrente(Accion):-
    accion(Mago1, Accion),
    accion(Mago2, Accion),
    Mago1 \= Mago2.

% 3)

puntajeTotal(Casa, Puntaje):-
    unaCasa(Casa),
    findall(Punto, puntajeDeCasa(Casa, Punto), PuntosTotales),
    sumlist(PuntosTotales, Puntaje).

puntajeDeCasa(Casa, Punto):-
    esDe(Mago, Casa),
    puntosMago(Mago, Punto).

puntosMago(Mago, Punto):-
    accion(Mago, _, buena(Punto)).

puntosMago(Mago, Punto):-
    accion(Mago, _, mala(PuntoMalos)),
    Punto is PuntoMalos * -1.

% 4) 

casaGanadora(Casa):-
    unaCasa(Casa),
    puntajeTotal(Casa, Puntaje),
    forall((unaCasa(OtraCasa), puntajeTotal(OtraCasa, PuntajeOtraCasa)) , Puntaje >= PuntajeOtraCasa ).

% 5)

% - respondePregunta(Mago, PreguntaRespondida, Dificultad, ProfesorQueLaHace).
respondePregunta(hermione, dondeSeEncuentraUnBezoar, 20, profeSnape).
respondePregunta(hermione, comoLevitarPluma, 25, profeFlitwick).

puntosMago(Mago, Punto):-
    respondePregunta(Mago, _,Punto,_). % debido a que Puntos son lo mismo q la dificultad.

puntosMago(Mago, Punto):-
    respondePregunta(Mago, _,Dificultad, profeSnape),
    Punto is (Dificultad/2).

% Modifico puntosMago ya que con esta funcioin, valga la redundancia consigo los puntos de los magos,
% utilizada para saber los puntos de cada casa entonces agregando estos predicados ya adapto el codigo para 
% agregar los untos de las preguntas.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

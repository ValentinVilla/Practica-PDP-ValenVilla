%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          POKEMON          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://docs.google.com/document/d/1_B3EWYrNSmxOmfMxH8Gtpi3ViG5lWfQgwSq_dSWxTOk/edit

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 1 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

%  POKEMONES
%  pokemon(Nombre, Tipo).

pokemon(pikachu, electrico).
pokemon(charizard, fuego).
pokemon(venusaur, plantta).
pokemon(snorlax, normal).
pokemon(blastoise, agua).
pokemon(totodile, agua).
pokemon(rayquaza, dragon).
pokemon(rayquaza, volador).
pokemon(arceus, desconocido).

%  ENTRENADORES
%  entrenador(Nombre, Pokemon).

entrenador(ash, pikachu).
entrenador(ash, charizard).

entrenador(brock, snorlax).

entrenador(misty, blastoise).
entrenador(misty, venusaur).
entrenador(misty, arceus).

% Consultas

%consulta 1
esDeTipoMultiple(Pokemon):-
    pokemon(Pokemon, Tipo1),
    pokemon(Pokemon, Tipo2),
    Tipo1 \= Tipo2.

%consulta 2
esLegendario(Pokemon):-
    esDeTipoMultiple(Pokemon),
    ningunEntrenadorLoTiene(Pokemon).

ningunEntrenadorLoTiene(Pokemon).
    pokemon(Pokemon, _),
    not(entrenador(_, Pokemon)).
    
%consulta 3
esMisterioso(Pokemon):-
    pokemon(Pokemon, Tipo),
    not((pokemon(Otro, Tipo), Otro \= Pokemon)).

esMisterioso(Pokemon):-
    ningunEntrenadorLoTiene(Pokemon).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 2 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% movimiento(pokemon, movimiento, tipo(caractterios)).

movimiento(pikachu, mordedura, fisico(95)).
movimiento(pikachu, impactrueno, especial(40, electrico)).

movimiento(charizard, garraDragon, especial(100, dragon)).
movimiento(charizard, mordedura, fisico(95)).

movimiento(blastoise, proteccion, defensivo(10)). % Reduce daño en 10%
movimiento(blastoise, placaje, fisico(50)).

movimiento(arceus, impactrueno, especial(40, electrico)).
movimiento(arceus, garraDragon, especial(100, dragon)).
movimiento(arceus, proteccion, defensivo(10)). % Reduce daño en 10%
movimiento(arceus, placaje, fisico(50)).
movimiento(arceus, alivio, defensivo(100)).    % Reduce daño en 100%

% Consultas

%danioDeMovimiento(Movimiento, Daño).
danioDeMovimiento(fisico(Potencia), Potencia).

danioDeMovimiento(defensivo(_), 0).

danioDeMovimiento(especial(Potencia, Tipo), Danio):-
    multiplicarPorTipo(Tipo, Multiplicador),
    Danio is Potencia * Multiplicador.

multiplicarPorTipo(Tipo, 1.5):-
    tipoBasico(Tipo).

multiplicarPorTipo(dragon, 3).

multiplicarPorTipo(Tipo, 1):-
    not(tipoBasico(Tipo)),
    Tipo \= dragon.

tipoBasico(fuego).
tipoBasico(agua).
tipoBasico(planta).
tipoBasico(normal).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 3 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%

capacidadOfensiva(Pokemon, Capacidad):-
    pokemon(Pokemon, _),
    findall(Danio, danioDeAtaqueDePokemon(Pokemon, Danio), Danios),
    sumlist(Danios, Capacidad).

danioDeAtaqueDePokemon(Pokemon, Danio):-
    movimiento(Pokemon, _, Tipo),
    danioDeMovimiento(Tipo, Danio).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO 4 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
entrenadorEsPicante(Entrenador):-
    entrenador(Entrenador, _),
    forall(pokemon(Pokemones, Entrenador), pokemonPicante(Pokemones)).

pokemonPicante(Pokemon):-
    capacidadOfensiva(Pokemon, Capacidad),
    Capacidad > 200.

pokemonPicante(Pokemon):-
    esMisterioso(Pokemon).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



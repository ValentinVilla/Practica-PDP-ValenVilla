
% Parcial Logico "El Amor esta en el aire"

% - persona(Nombre, Edad, Genero, pretendiente(Genero, EdadMin, EdadMax)).

persona(valentin, 20, masculino, pretendiente(femenino, 18, 50)).
persona(jose, 40, masculino, pretendiente(femenino, 35, 50)).
persona(antonella, 18, femenino, pretendiente(masculino, 18, 19)).
persona(martin, 24, masculino, pretendiente(masculino, 24, 30)).
persona(maria, 30, femenino, pretendiente(femenino, 20, 28)).
persona(josefina, 17, femenino, pretendiente(femenino, 20, 28)).

% - gusto(Persona, [Gustos], [Disgustos]).

gusto(valentin, [peloLargo, rubia, alta, tatuaje, copada] , [peloCorto, colorada, baja, sinTatuaje, malvada]).

gusto(jose, [], [tatuaje, rubia]).

gusto(josefina, [baja, colorada, tatuaje, copada, peloLargo] , [peloCorto, alta, sinTatuaje, malvada, rubia]).

gusto(maria, [alta, morocha], [baja, tatuaje]).

%%%%
esPersona(valentin).
esPersona(jose).
esPersona(antonella).
esPersona(maria).
esPersona(martin).
esPersona(josefina).

perfilIncompleto(Persona):-
    esPersona(Persona),
    not(persona(Persona,_,_,_)),
    not(gusto(Persona,_,_)).

perfilIncompleto(Persona):-
    gusto(Persona, _, _),
    cantidadGustosMayorA5(Persona),
    cantidadDisgustosMayorA5(Persona).

perfilIncompleto(Persona):-
    persona(Persona, Edad,_,_),
    Edad < 18.

cantidadGustosMayorA5(Persona):-                                
    gustosDePersona(Persona, Gustos),
    cantidadMayorA5(Gustos).

cantidadDisgustosMayorA5(Persona):-
    disgustosDePersona(Persona, Disgustos),
    cantidadMayorA5(Disgustos).

cantidadMayorA5(ListaDeGusto):-
    length(ListaDeGusto, Cantidad),
    Cantidad >= 5.

%%%%

almaLibre(Persona):- 
    esPersona(Persona),
    not(perfilIncompleto(Persona)),
    findall(Genero, persona(_, _, Genero, _), Generos),
    list_to_set(Generos, GenerosUnicos),    
    forall(member(Genero, GenerosUnicos), 
           persona(Persona, _, _, pretendiente(Genero, _, _))).
 
 % Si me fijaba solo con el member si era femenino o masculino 
 % 1° era polemico 2°en caso de agrandar la base de conocimientos y agregar otros generos distintos me condicionaba.

almaLibre(Persona):-
    persona(Persona,_,_,pretendiente(_,EdadMin, EdadMax)),
    EdadMin - EdadMax < (-30).

%%%%

quiereHerencia(Persona):-
    persona(Persona,Edad,_,pretendiente(_,EdadMin, EdadMax)),
    EdadMin > Edad + 30.

%%%%

indeseable(Persona):-
    esPersona(Persona),
    not(esPretendiente(Persona, _)).

esPretendiente(Persona, OtraPersona):-
    persona(Persona, Edad, Genero, _),
    persona(OtraPersona,_,_,pretendiente(Genero, EdadMin, EdadMax)),
    edadEntre(Edad, EdadMin, EdadMax),
    tienenGustoComun(Persona, OtraPersona).

edadEntre(Edad, EdadMin, EdadMax):-
    Edad >= EdadMin,
    Edad =< EdadMax.

tienenGustoComun(Persona, OtraPersona):-
    gustosDePersona(Persona, Gustos),
    gustosDePersona(OtraPersona, OtrosGustos),
    member(Gusto, Gustos),
    member(Gusto, OtrosGustos).
    
gustosDePersona(Persona, Gustos):-
    gusto(Persona, Gustos, _).

disgustosDePersona(Persona, Disgustos):-
    gusto(Persona, _, Disgustos).

%%%%

hayMatch(Persona1, Persona2):-
    esPersona(Persona1),
    esPersona(Persona2),
    esPretendiente(Persona1, Persona2),      
    esPretendiente(Persona2, Persona1).

%%%%

trianguloAmoroso(Persona):- 
    esPersona(Persona),
    esPersona(Persona2),
    esPersona(Persona3),
    sonPersonasDistintas(Persona, Persona2, Persona3),
    esPretendiente(Persona, Persona2),
    esPretendiente(Persona2, Persona3),
    esPretendiente(Persona3, Persona),

    nohayMatch(Persona, Persona2),   % si no hay match quiere decir que persona2 NO es pretendiente de persona y asi, osea no es "ida y vuelta"
    nohayMatch(Persona2, Persona3),
    nohayMatch(Persona3, Persona1).

sonPersonasDistintas(Persona, Persona2, Persona3):-
    Persona \= Persona2,
    Persona3 \= Persona2,
    Persona \= Persona3.

nohayMatch(Persona, OtraPersona):-
    not(hayMatch(Persona, OtraPersona)).

%%%%%

unoParaElOtro(Persona1, Persona2):-
    esPersona(Persona1),
    esPersona(Persona2),
    hayMatch(Persona1, Persona2),
    gustosYDisgustosDe(Persona1, Gustos1, Disgustos1),
    gustosYDisgustosDe(Persona2, Gustos2, Disgustos2),
    gustoNoEsDisgusto(Gustos1, Disgustos2),
    gustoNoEsDisgusto(Gustos2, Disgustos1).

gustosYDisgustosDe(Persona, Gustos, Disgustos):-
    gustosDePersona(Persona, Gustos),
    disgustosDePersona(Persona, Disgustos).

gustoNoEsDisgusto(Gustos, Disgustos):-
    forall(member(Gusto, Gustos), not(member(Gusto, Disgustos))).

%%%%%

% - indiceDeAmor(Persona, OtraPersona, IndiceDeAmor).

indiceDeAmor(valentin, maria, 4).
indiceDeAmor(valentin, maria, 3).
indiceDeAmor(valentin, maria, 5).

indiceDeAmor(maria, valentin, 0).
indiceDeAmor(maria, valentin, 2).
indiceDeAmor(maria, valentin, 1).

indiceDeAmor(jose, maria, 10).

%

desbalance(Persona1, Persona2):-
    esPersona(Persona1),
    esPersona(Persona2),
    promedioDeMensajesEnviados(Persona1, Persona2, PromedioPersona1),
    promedioDeMensajesEnviados(Persona2, Persona1, PromedioPersona2),
    promediosDisparejos(PromedioPersona1, PromedioPersona2).

promedioDeMensajesEnviados(Persona1, Persona2, Promedio) :-
    findall(ValorIndice, indiceDeAmor(Persona1, Persona2, ValorIndice), ValoresIndice),
    length(ValoresIndice, Cantidad),
    Cantidad > 0, 
    sumlist(ValoresIndice, Suma),
        Promedio is Suma / Cantidad.
    
promediosDisparejos(Promedio1, Promedio2):-
    Promedio1 >= (2 * Promedio2).
promediosDisparejos(Promedio1, Promedio2):-
    Promedio2 >= (2 * Promedio1).

%%%%%

esGhosteado(Persona1, Persona2):-
    personaLeMandoMensaje(Persona1, Persona2),
    not(personaLeMandoMensaje(Persona2, Persona1)).

personaLeMandoMensaje(Persona1, Persona2):-
    esPersona(Persona1),
    esPersona(Persona2),
    indiceDeAmor(Persona1, Persona2, _).

%%%%%%%%%%%%%%%%%%%%%%%%%%
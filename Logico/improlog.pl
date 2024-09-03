%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          IMPROLOG         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://docs.google.com/document/d/1AEdxVwUDr4GmWDbE71ZGlCzviGNc5R8yDMrPC0zmzM4/edit#heading=h.w8j2lwo1zs68
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
%integrante(sophieTrio, valen, pandereta).      (Para Probar Punto 1)

integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).

nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO I %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

tieneUnaBuenaBase(Grupo):-
    tieneInstrumentoDeTipo(Grupo, ritmico),
    tieneInstrumentoDeTipo(Grupo, armonico).

tieneInstrumentoDeTipo(Grupo, TipoInstrumento):-
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, TipoInstrumento).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO II %%%%%%
%%%%%%%%%%%%%%%%%%%%%%

seDestaca(Integrante, Grupo):-
    integrante(Grupo, Integrante, Instrumento),
    nivelQueTiene(Integrante, Instrumento, NivelIntegrante),
    forall((nivelIntegranteDeGrupo(OtroIntegrante , Grupo, OtroNivel), OtroIntegrante \= Integrante) , NivelIntegrante >= OtroNivel + 2).

nivelIntegranteDeGrupo(Integrante , Grupo, Nivel):-
    integrante(Grupo, Integrante, Instrumento),
    nivelQueTiene(Integrante, Instrumento, Nivel).

%%%%%%%%%%%%%%%%%%%%%%
%%%%% PUNTO III %%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% - grupo(Grupo, TipoDeGrupo).

grupo(vientosDelEste, bigBand).

grupo(sophieTrio, formacionParticular([contrabajo, guitarra, violin])).

grupo(jazzmin, formacionParticular([bateria, bajo, trompeta, piano, guitarra])).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO IV %%%%%%
%%%%%%%%%%%%%%%%%%%%%%

hayCupo(Instrumento, Grupo):-
    grupo(Grupo, bigBand),
    esDeViento(Instrumento).

hayCupo(Instrumento, Grupo):-
    grupo(Grupo, TipoGrupo),
    nadieToca(Instrumento, Grupo),
    sirveParaElTipo(Instrumento, TipoGrupo).

nadieToca(Instrumento, Grupo):-
    instrumento(Instrumento, _),
    not(integrante(Grupo, _, Instrumento)).

sirveParaElTipo(Instrumento, formacionParticular(InstrumentosBuscados)):-
    member(Instrumento, InstrumentosBuscados).

sirveParaElTipo(Instrumento, bigBand):-
    esDeViento(Instrumento).

sirveParaElTipo(bateria, bigBand).
sirveParaElTipo(bajo, bigBand).
sirveParaElTipo(piano, bigBand).

esDeViento(Instrumento):-
    instrumento(Instrumento, melodico(viento)).
%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO V %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

puedeIncorporarse(Integrante, Grupo, Instrumento):-
    hayCupo(Instrumento, Grupo),
    nivelQueTiene(Integrante,Instrumento,Nivel),
    not(integrante(Grupo, Integrante, _)),
    grupo(Grupo, TipoDeGrupo),
    nivelMinimo(TipoDeGrupo, NivelEsperado),
    Nivel >= NivelEsperado.

nivelMinimo(bigBand, 1).
nivelMinimo(formacion(Instrumentos), NivelMinimo):-
    length(Instrumentos, CantidadInstrumentos),
    NivelMinimo is 7 - CantidadInstrumentos.

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO VI %%%%%%
%%%%%%%%%%%%%%%%%%%%%%

seQuedoEnBanda(Integrante):-
    esIntegrante(Integrante),
    not(integrante(_, Persona, _)),
    not(puedeIncorporarse(_, Persona, _)).

esIntegrante(Integrante):-
    nivelQueTiene(Persona, _,_).

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PUNTO VII %%%%%
%%%%%%%%%%%%%%%%%%%%%%























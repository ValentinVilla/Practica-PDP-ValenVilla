import Text.Show.Functions
import Data.List(genericLength)

--                              MUNDIAL 2014
-- https://docs.google.com/document/d/1UQzCyCj5krcwh7wPqRpoHXTOFl3IvbT8JdpLW0nzJYA/edit

-- Datos Principales

data Jugador = Jugador {
    nombre           :: String,
    edad             :: Int,
    promedioDeGol    :: Float,
    habilidad        :: Int,
    valorDeCansancio :: Float
} deriving (Show)

data Equipo = Equipo {
    nombreEquipo :: String,
    grupo        :: Char,
    jugadores    :: [Jugador]
} deriving (Show)

martin   = Jugador "Martin" 26 0.0 50 35.0
juan     = Jugador "Juancho" 30 0.2 50 40.0
maxi     = Jugador "Maxi Lopez" 27 0.4 68 30.0

jonathan = Jugador "Chueco" 20 1.5 80 99.0
lean     = Jugador "Hacha" 23 0.01 50 35.0
brian    = Jugador "Panadero" 21 5 80 15.0

garcia   = Jugador "Sargento" 30 1 80 13.0
messi    = Jugador "Pulga" 26 10 99 43.0
aguero   = Jugador "Aguero" 24 5 90 5.0

equipo1       = Equipo "Lo Que Vale Es El Intento" 'F' [martin, juan, maxi]
losDeSiempre  = Equipo "Los De Siempre" 'F' [jonathan, lean, brian]
restoDelMundo = Equipo "Resto del Mundo" 'A' [garcia, messi, aguero]

type Condicion a = (a -> a -> Bool) 

quickSort :: Condicion a -> [a] -> [a]
quickSort _ [] = [] 
quickSort criterio (x:xs) = (quickSort criterio . filter (not . criterio x)) xs ++ [x] ++ (quickSort criterio . filter (criterio x)) xs


--------------------------
----------PUNTO 1---------
--------------------------
--funcione principal
sonFigura :: Equipo -> [Jugador]
sonFigura unEquipo = filter (esFigura) . jugadores $ unEquipo

--funciones auxiliares
esFigura :: Jugador -> Bool
esFigura unJugador = habilidadMayor 75 unJugador && promedioDeGolMayor 0.0 unJugador

habilidadMayor :: Int -> Jugador -> Bool
habilidadMayor numero unJugador = (>numero) . habilidad $ unJugador

promedioDeGolMayor :: Float -> Jugador -> Bool
promedioDeGolMayor numero unJugador = (>numero) . promedioDeGol $ unJugador

--------------------------
----------PUNTO 2---------
--------------------------
jugadoresFaranduleros = ["Maxi Lopez", "Icardi", "Aguero", "Caniggia", "Demichelis"]
--funcion principal
tieneFarandulero :: Equipo -> Bool
tieneFarandulero unEquipo = sonElementosDeLista . map (nombre) . jugadores $ unEquipo

--funciones auxiliares
sonElementosDeLista :: [String] -> Bool
sonElementosDeLista nombres = any (esFarandulero) nombres

esFarandulero :: String -> Bool
esFarandulero nombre = flip elem jugadoresFaranduleros $ nombre

--------------------------
----------PUNTO 3---------
--------------------------
--funcion principal
figuritaDificil :: [Equipo] -> Char -> [Jugador]
figuritaDificil listaDeEquipos unGrupo = filter esFiguritaDificil (jugadoresEquiposDelGrupo listaDeEquipos unGrupo)

--funciones auxiliares
jugadoresEquiposDelGrupo :: [Equipo] -> Char -> [Jugador]
jugadoresEquiposDelGrupo listaDeEquipos unGrupo = concatMap jugadores (equiposDeGrupo unGrupo listaDeEquipos)

equiposDeGrupo :: Char -> [Equipo] -> [Equipo]
equiposDeGrupo unGrupo listaDeEquipos = filter (grupoIgual unGrupo) listaDeEquipos

grupoIgual :: Char -> Equipo -> Bool
grupoIgual unGrupo unEquipo = (==unGrupo) . grupo $ unEquipo 

esFiguritaDificil :: Jugador -> Bool
esFiguritaDificil unJugador = esFigura unJugador && esJoven unJugador && not (esFarandulero (nombre unJugador))

esJoven :: Jugador -> Bool
esJoven unJugador = edad unJugador < 27 

--------------------------
----------PUNTO 4---------
--------------------------
--funcion principal
jugarPartido :: Equipo -> Equipo
jugarPartido unEquipo = unEquipo { jugadores = map modificarCansancio (jugadores unEquipo) }

--funciones Auxiliares
modificarCansancio :: Jugador -> Jugador
modificarCansancio unJugador
    | esFiguritaDificil unJugador = cambiarCansancio 50.0 unJugador
    | esJoven unJugador           = cambiarCansancio (calcularValor (*) 1.1 unJugador) unJugador
    | esFigura unJugador          = cambiarCansancio (calcularValor (+) 20.0 unJugador) unJugador
    | otherwise                   = cambiarCansancio (calcularValor (*) 2 unJugador) unJugador

cambiarCansancio :: Float -> Jugador -> Jugador
cambiarCansancio nuevoCansancio unJugador = unJugador { valorDeCansancio = nuevoCansancio }

type Operacion = Float -> Float -> Float
calcularValor :: Operacion -> Float -> Jugador -> Float
calcularValor operacion numero unJugador = valorDeCansancio unJugador `operacion` numero

--------------------------
----------PUNTO 5---------
--------------------------
--funcion principal
ganadorDelPartido :: Equipo -> Equipo -> Equipo
ganadorDelPartido equipo1 equipo2 
    | promedioDeGolEquipo (jugadoresMenosCansados equipo1) > promedioDeGolEquipo (jugadoresMenosCansados equipo2) = jugarPartido equipo1
    | otherwise = jugarPartido equipo2
    where 
        equipo1 = jugarPartido equipo1
        equipo2 = jugarPartido equipo2

--funciones auxiliares
-- ¿Qué hace quickSort?
-- ghci>   quickSort (>) [3,1,5,2,4]
-- ghci>   [5,4,3,2,1]
jugadoresMenosCansados :: Equipo -> [Jugador]
jugadoresMenosCansados unEquipo = take 11 . quickSort (criterioCansancio) . jugadores $ unEquipo

criterioCansancio :: Jugador -> Jugador -> Bool
criterioCansancio jugador1 jugador2 = valorDeCansancio jugador1 < valorDeCansancio jugador2

promedioDeGolEquipo :: [Jugador] -> Float
promedioDeGolEquipo jugadores = (/2) . sum . map (promedioDeGol) $ jugadores

--------------------------
----------PUNTO 6---------
--------------------------
--Resolucion 1
--Usando Recursividad
campeonDelTorneo :: [Equipo] -> Equipo
campeonDelTorneo [unEquipo] = unEquipo
campeonDelTorneo (equipo1 : equipo2 : equipos) = campeonDelTorneo ( ganadorDelPartido (jugarPartido equipo1) (jugarPartido equipo2) : equipos )   

--Resolucion 2
--Usando FOLDL
campeonDelTorneo' :: [Equipo] -> Equipo
campeonDelTorneo' (equipo : equipos) = foldl (ganadorDelPartido) (jugarPartido equipo) (map jugarPartido equipos)

--------------------------
----------PUNTO 7---------
--------------------------
elGroso :: [Equipo] -> String
elGroso listaDeEquipos = nombre . head . filter esFigura . jugadores . campeonDelTorneo $ listaDeEquipos

--------------------------
----------TEORICO---------
--------------------------
-- 1) ¿Dónde usaron funciones de orden superior? ¿Por qué? ¿Crearon alguna función de orden superior?
-- 2) ¿Qué pasaría si un equipo tuviera una lista infinita de jugadores? 

-- 1) Se utilizo en la funcion quickSort, ya que se le pasa una funcion de orden superior como parametro, 
-- para poder ordenar la lista de jugadores. Si cree la funcion calcularValor, que recibe una funcion del tipo 
-- Operacion como parametro, para poder realizar operaciones matematicas con los valores de cansancio de los jugadores.

-- 2) Si un equipo tuviera una lista infinita de jugadores, aunque la evaluación perezosa en Haskell permitiria trabajar con 
-- listas infinitas siempre que las funciones se implementen de manera que no intenten evaluar toda la lista de una vez.
-- En el caso de utilizar, las funciones que usan filter, map, quickSort estas se usan durante toda la lista generando listas
-- infinitas, por lo que no terminarian de ejecutarse.
-- en jugadorEquiposDelGrupo, se utiliza take 11 que si no se ejecutase el quicksort antes, si podria ejecutarse sin problemas.

listaInfinita :: Equipo
listaInfinita = Equipo "Equipo Infinito" 'A' ( jonathan : lean : martin :martin : jonathan : garcia : messi: aguero : jonathan: messi : messi : repeat messi)

-- ganadorDelPartido losDeSiempre listaInfinita  --> No termina
-- jugadoresEquiposDelGrupo listaInfinita --> No Termina
-- campeonDelTorneo [listaInfinita, equipo1] --> No termina
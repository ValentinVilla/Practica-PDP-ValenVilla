import Text.Show.Functions
import Data.List(genericLength)

--                              MUNDIAL 2014


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

equipo1       = ("Lo Que Vale Es El Intento", 'F', [martin, juan, maxi])
losDeSiempre  = ( "Los De Siempre", 'F', [jonathan, lean, brian])
restoDelMundo = ("Resto del Mundo", 'A', [garcia, messi, aguero])

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





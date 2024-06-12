import Text.Show.Functions
import Data.List(genericLength)

--                              MINIGOLFITO
-- https://docs.google.com/document/d/1LeWBI6pg_7uNFN_yzS2DVuVHvD0M6PTlG1yK0lCvQVE/edit#heading=h.wn9wma8e1ale

-- Datos Principales
data Jugador = Jugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = Jugador "Bart" "Homero" (Habilidad 25 60)
todd = Jugador "Todd" "Ned" (Habilidad 15 80)
rafa = Jugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = Tiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int
between n m x = elem x [n .. m]
--1)--------------------------------------------------------------------------------------------------------------------
--a)
type Palo = Habilidad -> Tiro

putter :: Palo
putter unaHabilidad = Tiro {
    velocidad = 10, 
    precision = calcularPrecision (*) unaHabilidad 2, 
    altura = 0
}

madera :: Palo
madera unaHabilidad = Tiro {
    velocidad = 100,
    precision = calcularPrecision (div) unaHabilidad 2, 
    altura = 5 
}

hierro :: Int -> Palo
hierro n unaHabilidad = Tiro{
    velocidad = fuerzaJugador unaHabilidad * n,
    precision = calcularPrecision (div) unaHabilidad n,
    altura = calcularAltura n
}

type Funcion = Int -> Int -> Int
calcularPrecision :: Funcion -> Habilidad -> Int -> Int
calcularPrecision f unaHabilidad unNumero = f (precisionJugador unaHabilidad) unNumero

calcularAltura :: Int -> Int
calcularAltura n
    | n <= 3 = 0
    | otherwise = n - 3

--b)
palos :: [Palo]
palos = [putter, madera] ++ map hierro [1..10]

--2)--------------------------------------------------------------------------------------------------------------------
golpe :: Jugador -> Palo -> Tiro 
golpe unJugador unPalo = unPalo . habilidad $ unJugador

--3)--------------------------------------------------------------------------------------------------------------------}
--type Obstaculo = Tiro -> Tiro
data Obstaculo = Obstaculo {
    superaObstaculo :: (Tiro -> Bool),
    efectoObstaculo :: (Tiro -> Tiro)
}
--a)
--funcion principal 
tunelConRampita :: Obstaculo
tunelConRampita = Obstaculo superaTunelConRampita efectoTunelConRampita

--funciones auxiliares  
intentarSuperarObstaculo :: Obstaculo -> Tiro -> Tiro
intentarSuperarObstaculo unObstaculo unTiro
    |superaObstaculo unObstaculo unTiro = efectoObstaculo unObstaculo unTiro
    |otherwise                           = tiroDetenido

tiroDetenido :: Tiro
tiroDetenido = Tiro 0 0 0

superaTunelConRampita :: Tiro -> Bool
superaTunelConRampita unTiro = precision unTiro > 90 && vaAlRasDelSuelo unTiro

vaAlRasDelSuelo :: Tiro -> Bool
vaAlRasDelSuelo unTiro = altura unTiro == 0

efectoTunelConRampita :: Tiro -> Tiro
efectoTunelConRampita unTiro = unTiro { velocidad = velocidad unTiro * 2 , precision = 100 , altura = 0}

--b)
--funcion principal
laguna :: Int -> Obstaculo
laguna largoLaguna = Obstaculo superaLaguna (efectoLaguna largoLaguna)

--funciones auxiliares
superaLaguna :: Tiro -> Bool
superaLaguna unTiro = velocidad unTiro > 80 && between 1 5 (altura unTiro)

efectoLaguna :: Int -> Tiro -> Tiro
efectoLaguna largoLaguna unTiro = unTiro { altura = altura unTiro `div` largoLaguna}

--c)
--funcion principal
hoyo :: Obstaculo 
hoyo = Obstaculo superaHoyo efectoHoyo

superaHoyo :: Tiro -> Bool
superaHoyo unTiro = between 5 20 (velocidad unTiro) && precision unTiro > 9 && vaAlRasDelSuelo unTiro

efectoHoyo :: Tiro -> Tiro
efectoHoyo _ = tiroDetenido
 
--4)--------------------------------------------------------------------------------------------------------------------
--a)
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles unJugador unObstaculo = filter (leSirveParaSuperar unJugador unObstaculo) palos

leSirveParaSuperar :: Jugador -> Obstaculo -> Palo -> Bool
leSirveParaSuperar unJugador unObstaculo unPalo = superaObstaculo unObstaculo . golpe unJugador $ unPalo

--b)
cuantosObstaculosConsecutivosSupera :: Tiro -> [Obstaculo] -> Int
cuantosObstaculosConsecutivosSupera unTiro [] = 0
cuantosObstaculosConsecutivosSupera unTiro (obstaculo : obstaculos)
    |superaObstaculo obstaculo unTiro 
        = 1 + cuantosObstaculosConsecutivosSupera (efectoObstaculo obstaculo unTiro) obstaculos
    |otherwise = 0

--c)

--Nos dan esta funciones
maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord x => (t -> x) -> (t -> t -> t)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b


paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil unJugador obstaculos 
    = maximoSegun (flip cuantosObstaculosConsecutivosSupera obstaculos . golpe unJugador) palos


--5)--------------------------------------------------------------------------------------------------------------------
{-Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó 
cada niño al finalizar el torneo, se pide retornar la lista de padres que pierden la apuesta 
por ser el “padre del niño que no ganó”. Se dice que un niño ganó el torneo si tiene más 
puntos que los otros niños.
-}
jugadorDeTorneo = fst
puntosGanados   = snd

pierdenLaApuesta :: [(Jugador, Puntos)] -> [String]
pierdenLaApuesta puntosDelTorneo 
    = (map (padre . jugadorDeTorneo) . filter (not . gano puntosDelTorneo)) puntosDelTorneo

gano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano puntosDelTorneo puntosDeUnJugador 
    = (all ((<puntosGanados puntosDeUnJugador) . puntosGanados ) . filter (/= puntosDeUnJugador)) puntosDelTorneo


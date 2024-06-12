import Text.Show.Functions
import Data.List(genericLength)

--                              STAR WARS
--https://docs.google.com/document/d/1rbOy1rIFmBxMRhTOWvI-u097l9KatHRbqt5KBXvVSfI/edit

-- Datos Principales

data Nave = Nave {
    nombre      :: String,
    durabilidad :: Int,
    escudo      :: Int,
    ataque      :: Int,
    poder       :: Poder
} deriving (Show)

type Poder  = Nave -> Nave

--Defino naves
tieFighter :: Nave
tieFighter = Nave "TIE Fighter" 200 100 50 movimientoTurbo 

xWing :: Nave
xWing = Nave "X Wing" 300 150 100 reparacionDeEmergencia

naveDeDarthVader :: Nave
naveDeDarthVader = Nave "Nave de Darth Vader" 500 300 200  movimientoSuperTurbo

millenniumFalcon :: Nave
millenniumFalcon = Nave "Millennium Falcon" 1000 500 50 reparacionPro

--funciones para configurar naves
cambiarAtaque :: Int -> Nave -> Nave
cambiarAtaque nuevoAtaque unaNave = unaNave { ataque = ataque unaNave + nuevoAtaque}

cambiarDurabilidad :: Int -> Nave -> Nave
cambiarDurabilidad nuevaDurabilidad unaNave = unaNave { durabilidad = nuevaDurabilidad }

cambiarEscudo :: Int -> Nave -> Nave
cambiarEscudo nuevoEscudo unaNave = unaNave { escudo = nuevoEscudo }

--Poderes De Las Naves
movimientoTurbo :: Nave -> Nave
movimientoTurbo unaNave = cambiarAtaque (incrementarAtaque 25 unaNave) unaNave

reparacionDeEmergencia :: Nave -> Nave
reparacionDeEmergencia unaNave = cambiarDurabilidad (incrementarDurabilidad 50 unaNave) . cambiarAtaque (decrementarAtaque 30 unaNave) $ unaNave

movimientoSuperTurbo :: Nave -> Nave
movimientoSuperTurbo unaNave = cambiarAtaque (incrementarAtaque 75 unaNave) . cambiarDurabilidad (decrementarDurabilidad 45 unaNave) $ unaNave

reparacionPro :: Nave -> Nave
reparacionPro unaNave = cambiarEscudo (incrementarEscudo 100 unaNave) . reparacionDeEmergencia $ unaNave

--Logica de los poderes
incrementarAtaque :: Int -> Nave -> Int
incrementarAtaque incremento unaNave = ataque unaNave + incremento

incrementarDurabilidad :: Int -> Nave -> Int
incrementarDurabilidad incremento unaNave = durabilidad unaNave + incremento

incrementarEscudo :: Int -> Nave -> Int
incrementarEscudo incremento unaNave = escudo unaNave + incremento

decrementarAtaque :: Int -> Nave -> Int
decrementarAtaque decremento unaNave = ataque unaNave - decremento

decrementarDurabilidad :: Int -> Nave -> Int
decrementarDurabilidad decremento unaNave = durabilidad unaNave - decremento

decrementarEscudo :: Int -> Nave -> Int
decrementarEscudo decremento unaNave = escudo unaNave - decremento

--------------------------
----------PUNTO 1---------
--------------------------
anubisShip :: Nave
anubisShip = Nave "La Maleducada de Anubis" 1000 200 3000 combinetaCelestial

combinetaCelestial :: Nave -> Nave
combinetaCelestial unaNave = movimientoSuperTurbo . reparacionPro . reparacionDeEmergencia $ unaNave

--------------------------
----------PUNTO 2---------
--------------------------
--funcion principal
durabilidadTotalFlota :: [Nave] -> Int
durabilidadTotalFlota flota = sumaDeLasDurabilidades flota

--funciones auxiliares
sumaDeLasDurabilidades :: [Nave] -> Int
sumaDeLasDurabilidades flota = sum . listaDeDurabilidades $ flota

listaDeDurabilidades :: [Nave] -> [Int]
listaDeDurabilidades flota = map (durabilidad) flota

--------------------------
----------PUNTO 3---------
--------------------------
--funcion principal
atacarNave :: Nave -> Nave -> Nave
atacarNave naveAtacante naveAtacada 
    |ataqueSuperior naveAtacantePRO naveAtacadaPRO = cambiarDurabilidad ( max 0 . decrementarEscudo (ataque naveAtacantePRO) $ naveAtacadaPRO ) naveAtacadaPRO
    |otherwise                                     = naveAtacadaPRO
        where
        naveAtacantePRO = (poder naveAtacante) naveAtacante
        naveAtacadaPRO  = (poder naveAtacada) naveAtacada

--funciones auxiliares
ataqueSuperior :: Nave -> Nave -> Bool
ataqueSuperior nave1 nave2 = ataque nave1 > escudo nave2

--------------------------
----------PUNTO 4---------
--------------------------
--funcion principal
naveFueraDeCombate :: Nave -> Bool
naveFueraDeCombate unaNave = durabilidad unaNave == 0

--------------------------
----------PUNTO 5---------
--------------------------
--funcion principal
type Estrategia = Nave -> Bool

flotaLuegoDeMisionSorpresa :: Nave -> [Nave] -> Estrategia -> [Nave]
flotaLuegoDeMisionSorpresa naveAtacante flota estrategia = map (atacarNave naveAtacante) . filter (estrategia) $ flota

--estrategias
navesDebiles :: Estrategia
navesDebiles unaNave = escudo unaNave < 200

navesConPeligrosidad :: Int -> Estrategia
navesConPeligrosidad valor unaNave = ataque unaNave > valor

navesQueQuedarianFueraDeCombate :: [Nave] -> Estrategia
navesQueQuedarianFueraDeCombate flota unaNave = any (naveFueraDeCombate) . map (atacarNave unaNave) $ flota 

navesDuras :: Estrategia
navesDuras unaNave = escudo unaNave > 912

--------------------------
----------PUNTO 6---------
--------------------------
--funciones principales
--a)
mejorEstrategia :: Estrategia -> Estrategia -> Nave -> [Nave] -> Estrategia
mejorEstrategia estrategia1 estrategia2 naveAtacante flota 
    |estrategia1Mejor estrategia1 estrategia2 naveAtacante flota = estrategia1
    |otherwise                                                   = estrategia2

--b)
misionConMejorEstrategia :: Estrategia -> Estrategia -> Nave -> [Nave] -> [Nave]
misionConMejorEstrategia estrategia1 estrategia2 naveAtacante flota =
    flotaLuegoDeMisionSorpresa naveAtacante flota (mejorEstrategia estrategia1 estrategia2 naveAtacante flota)


--funciones auxiliares

estrategia1Mejor :: Estrategia -> Estrategia -> Nave -> [Nave] -> Bool
estrategia1Mejor estrategia1 estrategia2 naveAtacante flota
 = durabilidadTotalFlota (flotaLuegoDeMisionSorpresa naveAtacante flota estrategia1) <  durabilidadTotalFlota (flotaLuegoDeMisionSorpresa naveAtacante flota estrategia2)

--------------------------
----------PUNTO 7---------
--------------------------
flotaInfinita :: [Nave]
flotaInfinita = tieFighter : millenniumFalcon : naveDeDarthVader : repeat anubisShip

{-
¿Es posible determinar su durabilidad total?
No, no es posible ya que no se puede calcular la durabilidad total de una flota infinita.
es decir no se puede calcular la suma de las durabilidades de una flota infinita.

¿Qué se obtiene como respuesta cuando se lleva adelante una misión sobre ella?
Se obtiene una lista infinita de naves, ya que la flota es infinita y la lista de naves que se obtiene es infinita.
debido a que mediante la funcion flotaLuegoDeMisionSorpresa se obtiene una lista de naves que se obtiene al atacar a 
cada nave de la flota infinita. entonces se genera una lista infinita de naves.
-}

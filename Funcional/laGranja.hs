import Text.Show.Functions
import Data.List(genericLength)

--                              LA GRANJA
--https://docs.google.com/document/d/1fYZ6Zy7oaorLEv5XqIa8ktnmVlxkp9bpicXhORgm9m8/edit#heading=h.gcspwnupgahw

-- Datos Principales

data Animal = Animal {
    nombre         :: String,
    tipoAnimal     :: String,
    peso           :: Int,
    edad           :: Int,
    estaEnfermo    :: Bool,
    visitasMedicas :: [(Int, Int)] -- ( DiasDeRecuperacion , CostoDeAtencion )
} deriving (Show, Eq)

diasDeRecuperacion :: Animal -> [Int]
diasDeRecuperacion unAnimal = map fst (visitasMedicas unAnimal)

costosDeAtencion :: Animal -> [Int]
costosDeAtencion unAnimal = map snd (visitasMedicas unAnimal)

--1)--------------------------------------------------------------------------------------------------------------------
--a) 
--funcion principal
laPasoMal :: Animal -> Bool
laPasoMal unAnimal = superaDiasDeRecuperacion 30 unAnimal

--funcion auxiliar
superaDiasDeRecuperacion :: Int -> Animal -> Bool
superaDiasDeRecuperacion maximoDiasRecuperacion unAnimal = any (>maximoDiasRecuperacion) (diasDeRecuperacion unAnimal) 

--b)
--funcion principal (Solo composicion y aplicacion Parcial, no hacer recursividad u otras funciones)
nombreFalopa :: Animal -> Bool
nombreFalopa unAnimal = (=='i') . last . nombre $ unAnimal

--2)--------------------------------------------------------------------------------------------------------------------
type Actividades = Animal -> Animal

--a)
--funcion principal
darDeComer :: Int -> Actividades
darDeComer kilosDeComida unAnimal
    |kilosDeComida >= 10 = cambiarPeso ((+5) . peso $ unAnimal) unAnimal
    |otherwise           = cambiarPeso (incrementaMitad kilosDeComida unAnimal) unAnimal

--funciones auxiliares
incrementaMitad :: Int -> Animal -> Int
incrementaMitad kilosDeComida unAnimal = (+peso unAnimal) . (div kilosDeComida) $ 2

cambiarPeso :: Int -> Animal -> Animal
cambiarPeso nuevoPeso unAnimal = unAnimal { peso = nuevoPeso }

--b)
--funcion principal
revisacionAnimal :: Int -> Int -> Actividades
revisacionAnimal dias costo unAnimal
    |estaEnfermo unAnimal = cambiarVisitas (registrarVisitaMedica dias costo unAnimal) . cambiarPeso (incrementaMitad 2 unAnimal) $ unAnimal
    |otherwise            = unAnimal

--funciones auxiliares
registrarVisitaMedica :: Int -> Int -> Animal -> [(Int,Int)]
registrarVisitaMedica diasDeRecuperacion costosDeAtencion unAnimal 
    = (diasDeRecuperacion,costosDeAtencion) : visitasMedicas unAnimal

cambiarVisitas :: [(Int,Int)] -> Animal -> Animal
cambiarVisitas nuevasVisitas unAnimal = unAnimal { visitasMedicas = nuevasVisitas }

--c)
--funcion principal
festejoCumple :: Actividades
festejoCumple unAnimal = cambiarPeso (peso unAnimal - 1) . sumarAnio $ unAnimal

--funcion auxiliar
sumarAnio :: Animal -> Animal
sumarAnio unAnimal = unAnimal {edad = edad unAnimal + 1}

--d)
--funcion principal
chequeoPeso :: Int -> Actividades
chequeoPeso pesoMinimo unAnimal
    |pesoSupera pesoMinimo unAnimal = unAnimal
    |otherwise                      = unAnimal {estaEnfermo = True}

pesoSupera :: Int -> Animal -> Bool
pesoSupera pesoMinimo unAnimal = peso unAnimal > pesoMinimo

--3)--------------------------------------------------------------------------------------------------------------------
modelarProceso :: [Actividades] -> Animal -> Animal
modelarProceso listaDeActividades unAnimal = foldl (flip ($)) unAnimal listaDeActividades

--sea
procesoA :: [Actividades]
procesoA = [darDeComer 12, festejoCumple, chequeoPeso 200, revisacionAnimal 3 1500]

dorothy :: Animal
dorothy = Animal "dorothy" "vaca" 690 18 False []

michi :: Animal
michi = Animal "michi" "gato" 5 12 False []

-- probamos en consola lo siguiente

-- ghci> modelarProceso procesoA dorothy
-- ghci> Animal {nombre = "dorothy", tipoAnimal = "vaca", peso = 694, edad = 19, estaEnfermo = False, visitasMedicas = []}

-- ghci> modelarProceso procesoA michi
-- ghci> Animal {nombre = "michi", tipoAnimal = "gato", peso = 10, edad = 13, estaEnfermo = True, visitasMedicas = [(3,1500)]}

--4)--------------------------------------------------------------------------------------------------------------------
mejoraAnimal :: [Actividades] -> Animal -> Bool
mejoraAnimal           [ ]                 _    = True
mejoraAnimal           [_]                 _    = True
mejoraAnimal (ac1 : ac2 : actividades) unAnimal 
  = peso (ac1 unAnimal) <= peso (ac2 (ac1 unAnimal)) &&  (peso (ac2 (ac1 unAnimal)) - peso (ac1 unAnimal) <= 3) && mejoraAnimal (ac2 : actividades) unAnimal

-- primero se fija q el peso al aplicar la actividad 1 al animal sea menor
-- que el peso al aplicar la actividad 2 al animal con la actividad 1 aplicada

-- luego se fija q no suba mas de 3 kilos entre actividad y actividad
-- esto lo hace restando el peso de la actividad 1 al peso de la actividad 2

-- por ultimo se fija si se cumple esto mismo con el resto de las actividades

--5)--------------------------------------------------------------------------------------------------------------------
--a)
primerosTresFalopa :: [Animal] -> [Animal]
primerosTresFalopa listaDeAnimales = take 3 . filter nombreFalopa $ listaDeAnimales

--b)
--  Gracias a la Lazy Evaluation en Haskell, cuando utilizamos primerosTresFalopa
--  sobre una lista infinita, Haskell solo evaluará los elementos necesarios para encontrar los 
--  tres primeros animales que cumplen con la condición de tener un nombre falopa. Esto permite 
--  trabajar con listas infinitas de manera eficiente y obtener un valor computable.

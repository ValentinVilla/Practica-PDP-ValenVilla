-- Escribí tu código acá

--1)---------------------------------------------------------------------------------------------------------------
data Auto = Auto {
    marca           :: String,
    modelo          :: String,
    desgaste        :: (Chasis,Ruedas),
    velocidadMax    :: Float,
    tiempoDeCarrera :: Float
} deriving (Show, Eq)

type Chasis = Float
type Ruedas = Float

--a)
autoFerrari :: Auto
autoFerrari = Auto {
    marca           = "ferrari",
    modelo          = "F50",
    desgaste        = (0.0 , 0.0),
    velocidadMax    = 65.0,
    tiempoDeCarrera = 0.0
}

autoLamborghini :: Auto
autoLamborghini = Auto {
    marca           = "lamborghini",
    modelo          = "diablo",
    desgaste        = (7.0 , 4.0),
    velocidadMax    = 73.0,
    tiempoDeCarrera = 0.0
}

autoFiat :: Auto
autoFiat = Auto {
    marca           = "fiat",
    modelo          = "600",
    desgaste        = (33.0 , 27.0),
    velocidadMax    = 44.0,
    tiempoDeCarrera = 0.0
}
desgasteRuedasInicial :: Auto -> Ruedas
desgasteRuedasInicial unAuto = (snd . desgaste) unAuto

desgasteChasisInicial :: Auto -> Chasis
desgasteChasisInicial unAuto = (fst . desgaste) unAuto

--2)---------------------------------------------------------------------------------------------------------------
--a)
--funcion principal
estaEnBuenEstado :: Auto -> Bool
estaEnBuenEstado unAuto = calcularDesgaste (<) (40.0) (60.0) unAuto

--funciones auxiliares
type Condicion = Float -> Float -> Bool

calcularDesgaste :: Condicion -> Chasis -> Ruedas -> Auto -> Bool
calcularDesgaste condicion desgasteChasis desgasteRuedas unAuto = (desgasteChasisCondicion condicion desgasteChasis unAuto) && (desgasteRuedasCondicion condicion desgasteRuedas unAuto)

desgasteChasisCondicion :: Condicion -> Chasis -> Auto -> Bool
desgasteChasisCondicion condicion desgasteChasis unAuto = fst (desgaste unAuto) `condicion` desgasteChasis

desgasteRuedasCondicion :: Condicion -> Ruedas -> Auto -> Bool
desgasteRuedasCondicion condicion desgasteRuedas unAuto = snd (desgaste unAuto) `condicion` desgasteRuedas

--b)
autoNoDaMas :: Auto -> Bool
autoNoDaMas unAuto = calcularDesgaste (>) (80.0) (80.0) unAuto

--3)---------------------------------------------------------------------------------------------------------------
--funcion principal
repararAuto :: Auto -> Auto
repararAuto unAuto = cambiarDesgasteChasis (restarPorcentaje 85.0 unAuto) . cambiarDesgasteRuedas (0.0) $ unAuto

--funciones auxiliares
cambiarDesgasteChasis :: Float -> Auto -> Auto
cambiarDesgasteChasis nuevoChasis unAuto = unAuto { desgaste = ( nuevoChasis ,  desgasteRuedasInicial unAuto) }

cambiarDesgasteRuedas :: Float -> Auto -> Auto
cambiarDesgasteRuedas nuevasRuedas unAuto = unAuto { desgaste = ( desgasteChasisInicial unAuto , nuevasRuedas ) }

restarPorcentaje :: Float -> Auto -> Float
restarPorcentaje unPorcentaje unAuto = (/100). (*unPorcentaje) . fst . desgaste $ unAuto

--4)---------------------------------------------------------------------------------------------------------------
--a)
type Curva = Float -> Float -> Tramo

--funcion principal
hacerCurva :: Curva
hacerCurva unAngulo unaLongitud unAuto = cambiarDesgasteRuedas (sumarDesgasteRueda unAngulo unaLongitud unAuto) . cambiarTiempoDeCarrera (sumarTiempo unaLongitud unAuto) $ unAuto 

--funciones auxiliares
sumarDesgasteRueda :: Float -> Float -> Auto -> Float
sumarDesgasteRueda unAngulo unaLongitud unAuto = (+desgasteRuedasInicial unAuto) . (/unAngulo) . (*3) $ unaLongitud

cambiarTiempoDeCarrera :: Float -> Auto -> Auto
cambiarTiempoDeCarrera nuevoTiempo unAuto = unAuto { tiempoDeCarrera = nuevoTiempo }

sumarTiempo :: Float -> Auto -> Float
sumarTiempo unaLongitud unAuto = (+tiempoDeCarrera unAuto) . (unaLongitud /) . (/2) . velocidadMax $ unAuto

--i)
curvaPeligrosa :: Tramo
curvaPeligrosa unAuto = hacerCurva 60.0 300.0 unAuto

--ii)
curvaTranca :: Tramo
curvaTranca unAuto = hacerCurva 110.0 550.0 unAuto

--b)
type Tramo = Auto -> Auto

--funcion principal
tramoRecto :: Float -> Tramo
tramoRecto longitudDelTramo unAuto = cambiarDesgasteChasis(restarUnaCentecima longitudDelTramo unAuto) . cambiarTiempoDeCarrera(longitudDelTramo / velocidadMax unAuto) $ unAuto

--funcion auxiliar
restarUnaCentecima :: Float -> Auto -> Float
restarUnaCentecima longitudDelTramo unAuto = desgasteChasisInicial unAuto - (longitudDelTramo / 100)

--i)
tramoRectoClassic :: Tramo 
tramoRectoClassic unAuto = tramoRecto 750.0 unAuto

--ii)
tramito :: Tramo
tramito unAuto = tramoRecto 280.0 unAuto


--c)
--funcion principal
tramoBoxes :: Float -> Tramo
tramoBoxes longitudBoxes unAuto
    |estaEnBuenEstado unAuto = tramoRecto longitudBoxes unAuto
    |otherwise               = repararAuto . cambiarTiempoDeCarrera (sumarSegundosAlTiempoDelTramo 10.0 longitudBoxes unAuto) $ unAuto

--funciones auxiliares
sumarSegundosAlTiempoDelTramo :: Float -> Float -> Auto -> Float
sumarSegundosAlTiempoDelTramo segundos longitudDelTramo unAuto = (+segundos) . tiempoDeCarrera $ autoQueRecorreElTramo longitudDelTramo unAuto
--                                                               tiempoDeCarrera (tramoRecto longitudBoxes unAuto) + segundos

autoQueRecorreElTramo :: Float -> Auto -> Auto
autoQueRecorreElTramo longitudDelTramo unAuto = tramoRecto longitudDelTramo unAuto

--d) 
estaMojado :: Float -> Tramo
estaMojado longitudDelTramo unAuto = cambiarTiempoDeCarrera (tiempoDeCarrera (autoQueRecorreElTramo longitudDelTramo unAuto) / 2) unAuto

--e)
--funcion principal
tramoConRipio :: Float -> Tramo
tramoConRipio longitudDelTramo unAuto = elDobleDeEfecto longitudDelTramo unAuto

--funciones auxiliares
elDobleDeEfecto :: Float -> Tramo
elDobleDeEfecto longitudDelTramo unAuto = cambiarDesgasteChasis(dobleDesgasteChasis longitudDelTramo unAuto ).cambiarTiempoDeCarrera(dobleTiempo longitudDelTramo unAuto) $ unAuto

dobleDesgasteChasis :: Float -> Auto -> Float
dobleDesgasteChasis longitudDelTramo unAuto = (*2) . desgasteChasisInicial $ autoQueRecorreElTramo longitudDelTramo unAuto

dobleTiempo :: Float -> Auto -> Float
dobleTiempo longitudDelTramo unAuto = (*2) . tiempoDeCarrera $ autoQueRecorreElTramo longitudDelTramo unAuto

--f)
tramoConObstruccion :: Float -> Tramo
tramoConObstruccion longitudDelTramo unAuto = cambiarDesgasteRuedas (calcularDesgastePorTramo longitudDelTramo unAuto) unAuto

calcularDesgastePorTramo :: Float -> Auto -> Float
calcularDesgastePorTramo longitudDelTramo unAuto = (+desgasteRuedasInicial unAuto) . (*2) $ longitudDelTramo


--5)---------------------------------------------------------------------------------------------------------------
pasarPorTramo :: Float -> Tramo
pasarPorTramo longitudDelTramo unAuto 
    |autoNoDaMas unAuto = tramoRecto longitudDelTramo unAuto
    |otherwise          = unAuto

--6)---------------------------------------------------------------------------------------------------------------
--a)
type Pista = [Tramo]

superPista :: Pista                                                           
superPista = [tramoRectoClassic, curvaTranca, tramito . estaMojado (280.0), tramito, tramoConObstruccion (2.0) . hacerCurva (80.0) (400) , hacerCurva (115.0) (650.0), tramoRecto (970.0), curvaPeligrosa, tramito . tramoConRipio (280.0), tramoBoxes (800.0)]

--b)
--funcion principal
peganLaVuelta :: Pista -> [Auto] -> [Auto]
peganLaVuelta unaPista listaDeAutos = map (pasarPorPista unaPista) . filter (not . autoNoDaMas) $ listaDeAutos
--                                                                  Filtra los autos que aún pueden correr por eso not
--funcion Auxiliar
pasarPorPista :: Pista -> Auto -> Auto
pasarPorPista unaPista unAuto = foldl (flip ($)) unAuto unaPista

--7)---------------------------------------------------------------------------------------------------------------
--a)
data Carrera = Carrera {
    pista   :: Pista,
    vueltas :: Int
}

--b)
tourDeBuenosAires :: Carrera
tourDeBuenosAires = Carrera {
    pista   = superPista,
    vueltas = 20
}

--c)
--c)
--funcion principal
jugarCarrera :: Carrera -> [Auto] -> [[Auto]]
jugarCarrera carrera listaDeAutos = simulacionDeVueltas (vueltas carrera) (pista carrera) listaDeAutos

--funciones auxiliares 
simulacionDeVueltas :: Int -> Pista -> [Auto] -> [[Auto]]
simulacionDeVueltas 0 _ autos = [autos]
simulacionDeVueltas n pista autos = autosParciales : simulacionDeVueltas (n-1) pista autosRestantes
  where
    autosParciales = peganLaVuelta pista autos
    autosRestantes = filter (not . autoNoDaMas) autosParciales

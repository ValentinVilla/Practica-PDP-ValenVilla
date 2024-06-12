import Text.Show.Functions
import Data.List(genericLength)

--                              VACACIONES


--1)--------------------------------------------------------------------------------------------------------------------
data Turista = Turista{
    cansancio :: Int,
    stress    :: Int,
    viajaSolo :: Bool,
    idiomas   :: [String]
} deriving (Show)

ana :: Turista
ana = Turista{
    cansancio = 0,
    stress    = 21,
    viajaSolo = False,
    idiomas   = ["español"]
}

beto :: Turista
beto = Turista{
    cansancio = 15,
    stress    = 15,
    viajaSolo = True,
    idiomas   = ["aleman"]
} 

cathi :: Turista
cathi = Turista{
    cansancio = 15,
    stress    = 15,
    viajaSolo = True,
    idiomas   = ["aleman", "catalan"]
}

--2)--------------------------------------------------------------------------------------------------------------------
type Excursion = Turista -> Turista

cambiarCansancio :: Int -> Turista -> Turista
cambiarCansancio nuevoCansancio unTurista = unTurista { cansancio = nuevoCansancio }

cambiarStress :: Int -> Turista -> Turista
cambiarStress nuevoStress unTurista = unTurista { stress = nuevoStress }

agregarIdioma :: String -> Turista -> Turista
agregarIdioma unIdioma unTurista = unTurista{ idiomas = unIdioma : idiomas unTurista }


irALaPlaya :: Excursion
irALaPlaya unTurista
    | viajaSolo unTurista = cambiarCansancio (cansancio unTurista - 5) unTurista
    | otherwise           = cambiarStress (stress unTurista - 1) unTurista

apreciarPaisaje :: String -> Excursion
apreciarPaisaje unPaisaje unTurista = cambiarStress (stress unTurista - length unPaisaje) unTurista

aprenderIdioma :: String -> Excursion
aprenderIdioma unIdioma unTurista = acompaniado . agregarIdioma unIdioma $ unTurista

acompaniado turista = turista { viajaSolo = False }

caminarXMinutos :: Int -> Excursion
caminarXMinutos minutos unTurista =
    cambiarStress (intensidad minutos) . cambiarCansancio (intensidad minutos) $ unTurista

intensidad :: Int -> Int
intensidad minutos = minutos `div` 4

data Marea = Fuerte | Tranquila | Moderada deriving (Show, Eq)

paseoEnBarco :: Marea -> Excursion
paseoEnBarco unaMarea unTurista
    | unaMarea == Fuerte    = cambiarStress (stress unTurista + 6) . cambiarCansancio (cansancio unTurista + 10) $ unTurista
    | unaMarea == Tranquila = caminarXMinutos 10 . apreciarPaisaje "mar" . aprenderIdioma "aleman" $ unTurista
    | otherwise             = unTurista


--a)
hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion unaExcursion unTurista = cambiarStress(calcularPorcentaje 10 (unaExcursion unTurista)) (unaExcursion unTurista)

calcularPorcentaje :: Int -> Turista -> Int
calcularPorcentaje porcentaje unTurista = (`div`100) . (*porcentaje) . stress $ unTurista

--b)
--dada la funcion
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

type Indice = (Turista -> Int)

deltaExcursionSegun :: Indice -> Turista -> Excursion -> Int
deltaExcursionSegun f unTurista unaExcursion = deltaSegun f (hacerExcursion unaExcursion unTurista) unTurista

--c)
unaExcursionEsEducativa :: Excursion -> Turista -> Bool
unaExcursionEsEducativa unaExcursion unTurista = deltaExcursionSegun (length.idiomas) unTurista unaExcursion > 0

excursionesDesestresantes :: Turista -> [Excursion] -> [Excursion]
excursionesDesestresantes turista listaExcursiones = filter (esDesestrazante turista) listaExcursiones

unaEscursionEsDesestresante :: Excursion -> Turista -> Bool
unaEscursionEsDesestresante unaExcursion unTurista = deltaExcursionSegun stress unTurista unaExcursion <= -3

--3)--------------------------------------------------------------------------------------------------------------------
type Tour = [Excursion]

completo :: Tour
completo = [caminarXMinutos 20, apreciarPaisaje "cascada",caminarXMinutos 40, irALaPlaya, aprenderIdioma "melmacquiano"]

ladoB :: Excursion -> Tour
ladoB excursionElegida = [paseoEnBarco Tranquila, excursionElegida, caminarXMinutos 120]

islaVecina :: Marea -> Tour
islaVecina unaMarea = [paseoEnBarco unaMarea, hacerExcursionSegunMarea unaMarea, paseoEnBarco unaMarea]

hacerExcursionSegunMarea :: Marea -> Excursion
hacerExcursionSegunMarea Fuerte = apreciarPaisaje "lago"
hacerExcursionSegunMarea _ = irALaPlaya

--a)
realizarTour :: Tour -> Turista -> Turista  
realizarTour unTour unTurista = foldl (flip hacerExcursion) (cambiarStress (stress unTurista + length unTour) unTurista) unTour

--b)
esConvincente :: Turista -> [Tour] -> Bool
esConvincente unTurista listaDeTours = any (esDesestrazante unTurista) listaDeTours

esDesestrazante :: Turista -> Tour -> Bool
esDesestrazante unTurista unTour = any (dejaAcompaniado unTurista) . excursionesDesestresantes unTurista $ unTour

dejaAcompaniado :: Turista -> Excursion -> Bool
dejaAcompaniado unTurista unaExcursion = not . viajaSolo $ hacerExcursion unaExcursion unTurista



--4)--------------------------------------------------------------------------------------------------------------------




























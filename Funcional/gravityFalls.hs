import Text.Show.Functions
import Data.List(genericLength)

--                              GRAVITY FALLS
--https://docs.google.com/document/d/1ivhqJIWGanstr324ElRY6lev0b0UN-QN3kcYFH9wqMs/edit#heading=h.slln8607g6w

--PRIMERA PARTE
--1)-------------------------------------------------------------------------------------------------------------------------
data Persona = Persona{
    edad        :: Int,
    items       :: [String],
    experiencia :: Int
} deriving (Show, Eq)

data Criatura = Criatura {
    peligrosidad :: Int,
    debilidad    :: Persona -> Bool
} deriving (Show)

siempreDetras :: Criatura
siempreDetras = Criatura 0 (const False)

gnomo :: Int -> Criatura 
gnomo cantidadGnomos 
    | cantidadGnomos == 0 = Criatura 0 (const False)
    | otherwise           = Criatura (2^cantidadGnomos) (\persona -> "soplador de hojas" `elem` items persona)


type AsuntoPendiente = Persona -> Bool

fantasma :: Int -> AsuntoPendiente -> Criatura
fantasma categoria asuntoPendiente = Criatura (20 * categoria) asuntoPendiente

--2)-------------------------------------------------------------------------------------------------------------------------
enfrentarCriatura :: Criatura -> Persona -> Persona
enfrentarCriatura unaCriatura unaPersona
    |debilidad unaCriatura unaPersona = cambiarExperiencia (peligrosidad unaCriatura) unaPersona
    |otherwise                        = cambiarExperiencia (1) unaPersona

cambiarExperiencia :: Int -> Persona -> Persona
cambiarExperiencia incrementoXP unaPersona = unaPersona {experiencia = sumarIncremento incrementoXP unaPersona}

sumarIncremento :: Int -> Persona -> Int
sumarIncremento incremento unaPersona = (+incremento) . experiencia $ unaPersona

--3)-------------------------------------------------------------------------------------------------------------------------
--a)
cantidadExperienciaAGanar :: Persona -> [Criatura] -> Int
cantidadExperienciaAGanar unaPersona criaturas = experiencia (personaEnfrentadaACriaturas criaturas unaPersona) - experiencia unaPersona 

personaEnfrentadaACriaturas :: [Criatura] -> Persona -> Persona
personaEnfrentadaACriaturas criaturas unaPersona = foldl (flip enfrentarCriatura) unaPersona criaturas

--b)
--defino una persona
anubis :: Persona
anubis = Persona 20 ["soplador de hojas" , "agua bendita", "ak 47"] 10

--defino lista criaturas
hordaCriaturas :: [Criatura]
hordaCriaturas = [ 
    siempreDetras,
    gnomo 10,
    fantasma 3 (\persona -> edad persona < 13 && "disfraz de oveja" `elem` items persona),
    fantasma 1 (\persona -> experiencia persona > 10)
    ]

--ghci> cantidadExperienciaAGanar anubis hordaCriaturas
--ghci> 1046

--SEGUNDA PARTE

--1)-------------------------------------------------------------------------------------------------------------------------
--recordando zipWith aplica una funcion al elemento de ua lista con el otro elemento de la lista
--zipWith (+) [1,2,3] [5,6,7] ----> [6,8,10]

-- que a partir de dos listas retorne una lista donde cada elemento:
-- - se corresponda con el elemento de la segunda lista, en caso de que el mismo no cumpla con la condición indicada
-- - en el caso contrario, debería usarse el resultado de aplicar la primer función con el par de elementos de dichas listas
-- usar recursividad
--zipWithIf' :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
-- usar recursividad

zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf _ _ [] [] = []
zipWithIf funcion condicion (x:xs) (y:ys)
    | not . condicion $ y = y : zipWithIf funcion condicion (x:xs) (ys)
    | otherwise           = funcion x y : zipWithIf funcion condicion (xs) (ys)

--2)-------------------------------------------------------------------------------------------------------------------------
--a)
abecedarioDesde :: Char -> [Char]
abecedarioDesde unaLetra = [unaLetra .. 'z'] ++ ['a' .. anteriorA unaLetra ]

anteriorA :: Char -> Char
anteriorA unaLetra = last . init $ ['a' .. unaLetra]

--b)
desencriptarLetra :: Char -> Char -> Char
desencriptarLetra letraClave letraADesencriptar = posicion (letraADesencriptar) (letraClave) !! (abecedarioDesde letraClave)

posicion :: Char -> Char -> Int
posicion unaLetra letraClave = length . takeWhile (/= unaLetra) . abecedarioDesde $ letraClave
































































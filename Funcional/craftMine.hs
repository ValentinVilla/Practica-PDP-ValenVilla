import Text.Show.Functions
import Data.List(genericLength)

--                                          CRAFTMINE


--1)--------------------------------------------------------------------------------------------------------------------
--defino recetas y personajes
data Personaje = Personaje {
    nombre     :: String,
    puntaje    :: Int,
    inventario :: [Material]
} deriving (Show)

type Material = String

data Receta = Receta {
    nombreMaterial       :: String,
    materialesNecesarios :: [Material],
    tiempoConstruccion   :: Int
} deriving (Show)

fogata :: Receta
fogata = Receta {
    nombreMaterial       = "Fogata",
    materialesNecesarios = ["madera", "fosforo"],
    tiempoConstruccion   = 10
}

polloAsado :: Receta
polloAsado = Receta {
    nombreMaterial       = "Pollo Asado",
    materialesNecesarios = ["fogata", "pollo"],
    tiempoConstruccion   = 300
}

sueter :: Receta
sueter = Receta {
    nombreMaterial       = "Sueter",
    materialesNecesarios = ["lana", "agujas", "tintura"],
    tiempoConstruccion   = 600
}

jugador1 :: Personaje
jugador1 = Personaje {
    nombre     = "jugador1",
    puntaje    = 1000,
    inventario = ["sueter", "fogata", "pollo", "pollo","lana", "agujas", "tintura"]
}

craftearObjeto :: Receta -> Personaje -> Personaje
craftearObjeto unaReceta unPersonaje
    | puedeCraftear unaReceta unPersonaje = cambiarPuntaje (puntaje unPersonaje + 10 * tiempoConstruccion unaReceta) . cambiarInventario (agregarMaterial (nombreMaterial unaReceta) . eliminarMateriales unaReceta $ unPersonaje) $ unPersonaje
    | otherwise                           = cambiarPuntaje (puntaje unPersonaje - 100) unPersonaje

puedeCraftear :: Receta -> Personaje -> Bool
puedeCraftear unaReceta unPersonaje = all (`elem` inventario unPersonaje) (materialesNecesarios unaReceta)

cambiarPuntaje :: Int -> Personaje -> Personaje
cambiarPuntaje nuevoPuntaje unPersonaje = unPersonaje { puntaje = nuevoPuntaje }

cambiarInventario :: [Material] -> Personaje -> Personaje
cambiarInventario nuevosMateriales unPersonaje = unPersonaje { inventario = nuevosMateriales }

agregarMaterial :: Material -> Personaje -> [Material]
agregarMaterial unMaterial unPersonaje = unMaterial : inventario unPersonaje

-- Modificar eliminarMateriales para usar eliminarPrimeraOcurrencia
eliminarMateriales :: Receta -> Personaje -> Personaje
eliminarMateriales unaReceta unPersonaje = 
        cambiarInventario (foldl (flip eliminarPrimeraOcurrencia) (inventario unPersonaje) (materialesNecesarios unaReceta)) unPersonaje

-- Función auxiliar para eliminar la primera ocurrencia de un material
eliminarPrimeraOcurrencia :: Material -> [Material] -> [Material]
eliminarPrimeraOcurrencia _ [] = []
eliminarPrimeraOcurrencia materialNecesario (material:materiales)
    | materialNecesario == material  = materiales
    | otherwise                      = material : eliminarPrimeraOcurrencia materialNecesario materiales


--2)--------------------------------------------------------------------------------------------------------------------
--a)
encontrarObjetosCrafteables :: Personaje -> [Receta] -> [Receta]
encontrarObjetosCrafteables unPersonaje listaRecetas = filter (duplicanPuntaje unPersonaje) listaRecetas

duplicanPuntaje :: Personaje -> Receta -> Bool
duplicanPuntaje unPersonaje unaReceta  = puntaje (craftearObjeto unaReceta unPersonaje) >= 2 * puntaje unPersonaje

--b)
craftearSucesivamente :: [Receta] -> Personaje -> Personaje
craftearSucesivamente listaRecetas unPersonaje = foldl (flip craftearObjeto) unPersonaje listaRecetas

--c)
convieneCraftearAlReves :: [Receta] -> Personaje -> Bool
convieneCraftearAlReves listaRecetas unPersonaje = puntaje (craftearSucesivamente listaRecetas unPersonaje) < puntaje (craftearSucesivamente (reverse listaRecetas) unPersonaje)


--                                          MINE
--1)--------------------------------------------------------------------------------------------------------------------
--defino biomas y herramientas  

data Bioma = Bioma {
    nombreBioma        :: String,
    materialesBioma    :: [Material],
    condicionParaMinar :: Condicion
} deriving (Show)

type Condicion   = [Material] -> Bool
type Herramienta = Bioma -> Material

artico :: Bioma
artico = Bioma {
    nombreBioma        = "Artico",
    materialesBioma    = ["hielo", "iglues", "lobos"],
    condicionParaMinar = tenerElementoEnInventario "sueter"
}

tenerElementoEnInventario :: Material -> Condicion
tenerElementoEnInventario materialNecesario listaMateriales = materialNecesario `elem` listaMateriales

hacha :: Herramienta
hacha unBioma = last (materialesBioma unBioma)

espada :: Herramienta
espada unBioma = head (materialesBioma unBioma)

pico :: Int -> Herramienta
pico posicion unBioma = materialesBioma unBioma !! posicion

minar :: Herramienta -> Bioma -> Personaje -> Personaje
minar unaHerramienta unBioma unPersonaje
    | condicionParaMinar unBioma (inventario unPersonaje) = cambiarPuntaje (puntaje unPersonaje + 50) . cambiarInventario (agregarMaterial (unaHerramienta unBioma) unPersonaje) $ unPersonaje
    | otherwise                                           = unPersonaje

--b)
pala :: Herramienta
pala unBioma = materialesBioma unBioma !! posicionIntermediaMaterialesDelBioma unBioma

posicionIntermediaMaterialesDelBioma :: Bioma -> Int
posicionIntermediaMaterialesDelBioma unBioma = (`div` 2) . length . materialesBioma $ unBioma

martillo :: String -> Herramienta
martillo materialBuscado unBioma = head (filter (\materialDelBioma -> materialBuscado == materialDelBioma) (materialesBioma unBioma)) -- Expresion lambda

martillo' :: String -> Herramienta
martillo' materialBuscado unBioma = head (filter (==materialBuscado) (materialesBioma unBioma)) -- Se puede hacer mejor de esta forma 
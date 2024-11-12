import miVillanoFav.miVIllanoFav.*

class Congelar{
    var property nivelDeConcentracionRequerido = 500

    method cumpleLosRequerimientos(minion) = 
        minion.contieneArma(rayoCongelador) && minion.tieneNivelSuficiente(nivelDeConcentracionRequerido)

    method realizatePor(villano){
        ciudad.bajarTemperatura(30)
        villano.ejercitoFiltrado(self).forEach{minion => minion.agregarBananas(10)}
    }
}

const congelar = new Congelar()

class Robar{
    var property objetivo 

    method cumpleLosRequerimientos(minion) = 
        minion.esPeligroso() && minion.puedeRobar(objetivo)

    method realizatePor(villano){
        ciudad.dejaDeTener(objetivo)
        villano.ejercitoFiltrado(self).forEach{minion => objetivo.premio(minion)}
    }
}

const roboPiramide = new Robar(objetivo = piramide100)
const roboSuero = new Robar(objetivo = sueroMutante)
const robolaluna = new Robar(objetivo = laLuna)

object sueroMutante{
    method puedeSerAsaltadoPor(minion) = minion.tieneAlMenosBananas(100) && minion.tieneNivelSuficiente(23)

    method premio(minion){
        minion.tomarSuero()
    }
    
}
object laLuna{

    method puedeSerAsaltadoPor(minion) = minion.contieneArma(rayoEncogedor)

    method premio(minion){
        minion.agregarArma(rayoCongelador)
    }

}

class Piramide {
    const altura =  100

    method calcularNivel() = altura / 2

    method puedeSerAsaltadoPor(minion) = minion.tieneNivelSuficiente(self.calcularNivel())

    method premio(minion){
        minion.agregarBananas(10)
    }
}
const piramide100 = new Piramide()
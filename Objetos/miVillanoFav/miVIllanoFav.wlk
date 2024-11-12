import maldades.*
object ciudad{
  var property temperatura = 31
  var cosasDeLaCiudad = [piramide100]


  method bajarTemperatura(unosGrados){
    temperatura =- unosGrados
  }

  method dejaDeTener(algo) {
    cosasDeLaCiudad.remove(algo)
  }

}

class Villano{
    var ejercito = []
    var maldades = [roboPiramide, roboSuero, robolaluna, congelar]

    method unMinionDeMiEjercito() = ejercito.anyOne()

    method integrarNuevoMinion(){
        ejercito.add(new Minion())      
    }

    method otorgarArma(unArma){
        self.unMinionDeMiEjercito().agregarArma(unArma)
    }

    method alimentar(unasBananas){
        self.unMinionDeMiEjercito().agregarBananas(unasBananas) 
    }

    method nivelDeConentracionDeUnMinion() = self.unMinionDeMiEjercito().nivelDeConcentracion()

    method esPeligrosoUnMinion() = self.unMinionDeMiEjercito().esPeligroso()

    method hacerTomarSuero(){
        self.unMinionDeMiEjercito().tomarSuero()
    }
    
    method ejercitoFiltrado(unaMaldad) = ejercito.filter{minion => minion.estaCapacitado(unaMaldad)}

    method realizarMaldad(unaMaldad) {
      unaMaldad.realizatePor(self)
    }

    method minionMasUtil(unasMaldades) = ejercito.max({minion => minion.participaciones(unasMaldades)})

    method minionsMenosUtiles(unasMaldades) = ejercito.removeAllSuchThat{minion => minion.estaCapacitadoParaAlguna(unasMaldades)}

}


class Minion{
  var color = amarillo
  var armas = [rayoCongelador]
  var bananas = 5

  method bananas() = bananas
  method armas() = armas

  method agregarBananas(unasBananas) {
    bananas =+ unasBananas
  }
  method agregarArma(unArma) {
    armas.add(unArma)
  }

  method tieneMasArmasQue(unasArmas) = armas.size() > unasArmas

  method alimentarse() {
    bananas =- 1
  }

   method descartarArmas() {
    armas = []
  }

  method potenciaDeSusArmas() = armas.sum{arma => arma.potencia()}

  method sacarBananas(unasBananas) {
    bananas =- unasBananas
  }

  method volverATenerArmas() {
    armas = [rayoCongelador]
  }

  method cambiarColor(unColor) {
    color = unColor
  }

  method contieneArma(unArma) = armas.contains(unArma)

  method esPeligroso() = color.peligro(self)

  method tomarSuero() {
    color.cambiar(self)
  }

  method nivelDeConcentracion() = color.calcularNivel(self)

  method tieneNivelSuficiente(unNivel) = self.nivelDeConcentracion() >= unNivel

  method estaCapacitado(unaMaldad) = unaMaldad.cumpleLosRequerimientos(self)

  method puedeRobar(unObjetivo) = unObjetivo.puedeSerAsaltadoPor(self)

  method tieneAlMenosBananas(unasBananas) = bananas >= unasBananas

  method participaciones(unasMaldades) = unasMaldades.count{maldad => maldad.cumpleLosRequerimientos(self)}

  method estaCapacitadoParaAlguna(unasMaldades) = unasMaldades.any{maldad => maldad.cumpleLosRequerimientos(self)}

}

object amarillo{
  method peligro(unMinion) = unMinion.tieneMasArmasQue(2)

  method cambiar(unMinion) {
    unMinion.cambiarColor(violeta)
    unMinion.descartarArmas()
    unMinion.sacarBananas(1)
  }

  method calcularNivel(unMinion) = unMinion.potenciaDeSusArmas() + unMinion.bananas()
  
}

object violeta{
  method peligro(unMinion) = true
  
  method cambiar(unMinion) {
    unMinion.cambiarColor(amarillo)
    unMinion.volverATenerArmas()
    unMinion.sacarBananas(1)
  }

  method calcularNivel(unMinion) = unMinion.bananas()
}

object rayoCongelador {
  method potencia() = 10
}

object rayoEncogedor {
  method potencia() = 50
}

/*
4. 
a) ¿Qué pasaría si los minions pudieran ser de otro color, de manera que, por ejemplo, los minions violetas se transforman en verdes al tomar el suero mutante, y éstos en amarillos, y además siendo verdes hacen cosas diferentes? 

- Yo crearia un nuevo objjeto "verde" tal que este se convierta en amarillo al tomar el suero mutante y que los minions verdes hagan cosas diferentes a los amarillos. tambien habria que modifficar los colores amarillo y violeta para que sepan como reaccionar ante un minion verde.


b) ¿Y si se estableciera que una vez que un minion amarillo pasa a violeta, es irreversible, y ya no puede volver a cambiar, por más suero mutante que tome?

- En este caso se deberia modificar el metodo cambiar de amarillo para que no pueda cambiar a violeta si ya lo hizo una vez.
capaz haciendo un if que verifique si el minion ya es violeta y si lo es no haga nada. asi:


object amarillo{
  method peligro(unMinion) = unMinion.tieneMasArmasQue(2)

 method cambiar(unMinion) {
    if(unMinion.color != violeta){
        unMinion.cambiarColor(violeta)
        unMinion.descartarArmas()
        unMinion.sacarBananas(1)
    }
  }

  method calcularNivel(unMinion) = unMinion.potenciaDeSusArmas() + unMinion.bananas()

}

*/


class Panelista{
    var puntosEstrella
    const tipoPanelista

    method puntosEstrella() = puntosEstrella

    method incrementarPuntosEstrella(unNumero) { 
        puntosEstrella += unNumero
    }

    method hacerRemate(unaTematica) {
        tipoPanelista.rematar(unaTematica)
    }

    method esDeportivo() = false
    
}

class Celebridad inherits Panelista{

    method rematar(unaTematica){ 
        self.incrementarPuntosEstrella(3)
    }

}

class Colorado inherits Panelista{
    const graciaDelMomento

     method rematar(unaTematica){ 
         self.incrementarPuntosEstrella(graciaDelMomento / 5)
         self.incrementarPuntosEstrella(1)
    }
}

class ColoradoConPeluca inherits Colorado{ 

        override method rematar(unaTematica){ 
           super(unaTematica)
           self.incrementarPuntosEstrella(1)
        }       
}

class Viejo inherits Panelista{
    
    method rematar(unaTematica) {
        self.incrementarPuntosEstrella(unaTematica.palabrasDelTitulo())
    }
        
}

class PanelistaDeportivo inherits Panelista{

    override method esDeportivo() = true

    method rematar(unaTematica) {
        // no hace nada porque no suma puntos
    }

}

// // // // // //
// // // // // //

class Tematica{
    const titulo
    
    method palabrasDelTitulo() = titulo.words().size()

    method titulo() = titulo

    method opina(unPanelista) {                  
        unPanelista.incrementarPuntosEstrella(1)
    }

    method esInteresante() = false

    method opinarYRematarPorVarios(unosPanelistas){
        unosPanelistas.forEach{ panelista => self.opinaYRemata(panelista) }
    } 

    method opinaYRemata(unPanelista){
        self.opina(unPanelista)
        unPanelista.hacerRemate(self)
    }

}

class Deportiva inherits Tematica{
   override method opina(unPanelista){
        super(unPanelista)
        if(unPanelista.esDeportivo()){
            unPanelista.incrementarPuntosEstrella(5)
        }
    }

    override method esInteresante() = titulo.words().contains("Messi")
}

class Farandula inherits Tematica{
    const involucrados 

    method cantInvolucrados() = involucrados.size()

    override method opina(unPanelista){
        super(unPanelista)
        if(unPanelista.esCelebridad()){
            unPanelista.incrementarPuntosEstrella(self.cantInvolucrados())
        }
    }

    override method esInteresante() = self.cantInvolucrados() >= 3
}

class Filosofica inherits Tematica{

    override method esInteresante() = self.palabrasDelTitulo() > 20

}

class Economica inherits Tematica{

}

class Moral inherits Tematica{

}

class Mixta inherits Tematica{
    const tematicas

    override method titulo() = tematicas.map{ tematica => tematica.titulo() }.join(" ")

    override method esInteresante() = tematicas.any{ tematica => tematica.esInteresante() }
    
    method opinarPor(unPanelista){
        tematicas.forEach{tematica => tematica.opinarPor(unPanelista)}
    }

}

// // // // // // // // //
// // // // // // // // //


class Programa{
    const tematicasATratar
    const panelistas 
    var emitio = false

    method cantidadDePanelistas() = panelistas.size()
    method cantidadDeTematicasATratar() = tematicasATratar.size()

    method puedeEmitir() = self.cantidadDePanelistas() >= 2 and self.mitadDeLasTematicasSonInteresantes()

    method cantTematicasInteresantes() = tematicasATratar.filter{ tematica => tematica.esInteresante()}

    method mitadDeLasTematicasSonInteresantes() = self.cantTematicasInteresantes() >= self.cantidadDeTematicasATratar() / 2

    method emite() {
        if(self.puedeEmitir()){
        tematicasATratar.forEach { tematica => tematica.opinarYRematarPorVarios(panelistas) }
        emitio = true
        } else {
             throw new DomainException(message = "No se puede saber el panelista, todavia no se emitio") 
        }
    }

    method panelistaEstrella(){
        if(emitio){
            panelistas.max{ panelista => panelista.puntosEstrella() }
        } else{
             throw new DomainException(message = "No se puede saber el panelista, todavia no se emitio") 
        }


    }

}
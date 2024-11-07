object tomarVino{
    method apply(unFilosofo) {
      unFilosofo.disminuirIluminacion(10)
      unFilosofo.agregarHonofico("El Borracho")
    }
}

class JuntarseEnElAgora{
    const filosofo 

    method apply(unFilosofo) {
        unFilosofo.aumentarIluminacion(filosofo.nivelDeIluminacion() / 10)
    }
}

object admirarElPaisaje{

    method apply(unFilosofo) {
        // No hace nada
    }
}

class MeditarBajoUnaCascada {
    const metrosDeLaCascada

    method apply(unFilosofo) {
        unFilosofo.aumentarIluminacion(10 * metrosDeLaCascada)      
    }
}

class PracticarUnDeporte {
    const deporte

    method apply(unFilosofo) {    
        unFilosofo.rejuvenece(deporte.diasDeRejuvenecimiento())
    }
}

object futbol{
    method diasDeRejuvenecimiento() = 1
}

object polo{
    method diasDeRejuvenecimiento() = 2
}

object waterpolo{
    method diasDeRejuvenecimiento() = polo.diasDeRejuvenecimiento() * 2
}
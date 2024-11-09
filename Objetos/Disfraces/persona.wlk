import disfraz.*
import opionesDelDisfraz.*


class Persona{
    var disfraz = null
    var personalidad
    var edad
    var opinionDelDisfraz

    method disfraz() = disfraz

    method tieneDisfraz() = disfraz != null

    method esSexy() = personalidad.esSexy(self)

    method edad() = edad

    method estaConformeConElTraje() = disfraz.puntaje() > 10 && opinionDelDisfraz.gusta()

    method noEstaConformeConElTraje() = !self.estaConformeConElTraje()


}

object alegre{
    method esSexy(unaPersona) = false
}

object taciturna{
    method esSexy(unaPersona) = unaPersona.edad() < 30
}

object cambiante{
    const personalidadActual = [alegre, taciturna]

    method esSexy(unaPersona) = personalidadActual.anyOne().esSexy(unaPersona)
}
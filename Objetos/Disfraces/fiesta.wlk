import persona.*

class Fiesta{
    var invitados = #{}

    // Punto 2
    method esUnBodrio() = invitados.all {invitado => invitado.noEstaConformeConElTraje()}
    
    // Punto 3
    method mejorDisfraz() = invitados.max {invitado => invitado.disfraz().puntaje()}

    // Punto 4
    method puedenIntercambiarDisfraz(unaPersona, otraPersona) = self.estanEnLaFiesta(unaPersona, otraPersona) && self.algunoEstaDisconforme(unaPersona, otraPersona) && self.cambiandoTrajesMejoran(unaPersona, otraPersona)

    method estanEnLaFiesta(unaPersona, otraPersona) = self.estaEnLaFiesta(unaPersona) && self.estaEnLaFiesta(otraPersona)

    method estaEnLaFiesta(unaPersona) = invitados.contains(unaPersona)

    method algunoEstaDisconforme(unaPersona, otraPersona) = unaPersona.estaDisconformeConSuDisfraz() || otraPersona.estaDisconformeConSuDisfraz()

    method cambiandoTrajesMejoran(unaPersona, otraPersona) = unaPersona.estaConformeConSuDisfraz(otraPersona.disfraz()) && otraPersona.estaConformeConSuDisfraz(unaPersona.disfraz())

    // Punto 5

    method agregarInvitado(nuevoInvitado) {
        if(nuevoInvitado.tieneDisfraz() && !self.estaEnLaFiesta(nuevoInvitado)){
            invitados.add(nuevoInvitado)
        }
    }

    // Punto 6

    method esInolvidable() = invitados.all{invitado => invitado.esSexy() && invitado.estaConformeConElTraje()}


}
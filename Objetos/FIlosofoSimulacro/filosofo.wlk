import actividades.*

class Filosofo {
  
  var property dias
  var property nivelDeIluminacion = 0

  const property nombre
  const property actividades = []
  const property honorificos = #{}

  method edad() = self.dias() / 365

  method presentarse() = self.nombre() + self.honorificosString()
  method honorificosString() = self.honorificos().join(" , ")

  method estaEnLoCorrecto() = self.nivelDeIluminacion() > 1000

  method aumentarIluminacion(cantidad) {
    nivelDeIluminacion = nivelDeIluminacion + cantidad
  }

  method disminuirIluminacion(cantidad) {
    nivelDeIluminacion = nivelDeIluminacion - cantidad
  }

  method agregarHonorifico(unHonorifico) {
    honorificos.add(unHonorifico)
  }

  method rejuvenece(unosDias) {
    dias = dias - unosDias
  }

  method envejecer(unosDias) {
    dias = dias + unosDias
  }

  method pasarDia() {
    self.envejecer(1)
    self.realizarTodasLasActividades()
    self.verificarCumpleanios()
  }

  method realizarTodasLasActividades() {
    actividades.forEach { actividad => actividad.apply(self) }
  }

  method verificarCumpleanios() {
    if(self.esElCumpleanio()){
      self.aumentarIluminacion(10)
      self.verificarJubilacion()
    }
  }
  
  method esElCumpleanio() = dias % 365 == 0

  method verificarJubilacion(){
    if(self.edad() == 60){
      self.agregarHonorifico("El Sabio")
    }
  }
}


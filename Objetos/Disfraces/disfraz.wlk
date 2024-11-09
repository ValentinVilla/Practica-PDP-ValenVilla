
class Disfraz {
  var persona
  var dias
  var caracteristicas = #{}
  var nivelDeGracia = 0
  var personaje
  var nombre
  
  method nombre() = nombre
  method dias() = dias
  method persona() = persona

  method puntaje() = caracteristicas.sum({caracteristica => caracteristica.puntos(self)})
}

object gracioso{

  method puntos(unDisfraz) = 
    if(unDisfraz.persona().edad() > 50){
        unDisfraz.nivelDeGraia() * 3
    } else {
        unDisfraz.nivelDeGraia()
    }

}

object tobara{

  method puntos(unDisfraz) = 
    if(unDisfraz.dias() >= 2) 5 else 3

}

object careta {
   method puntos(unDisfraz) = unDisfraz.personaje().valor()
  
}

object sexy{
  method puntos(unDisfraz) = 
    if(unDisfraz.persona().esSexy()) 15 else 2
}

class Personaje{
  var valor
  method valor() = valor
}
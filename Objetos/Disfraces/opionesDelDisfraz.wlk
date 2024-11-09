import persona.*

object caprichoso{
    method gusta(unDisfraz) = unDisfraz.nombre() % 2 == 0
}

object pretencioso{
    method gusta(unDisfraz) = unDisfraz.dias() < 30
}

class Numerologo{
    const cifra

    method gusta(unDisfraz) = unDisfraz.puntaje() == cifra
}
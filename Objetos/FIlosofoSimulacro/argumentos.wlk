class Argumento{
    
    const naturaleza 
    const descripcion

    method esEnriquecedor(){
        naturaleza.enriquece(self)
    }

    method cantidadDePalabras() = descripcion.words() 

    method esPregunta() = descripcion.endsWith("?")
}

object estoico{
    method enriquece(unArgumento) = true
}

object moralista {
    method enriquece(unArgumento) = unArgumento.cantidadDePalabras() >= 10
}

object esceptico{
    method enriquece(unArgumento) = unArgumento.esPregunta()
}

object cinico {
    method enriquece(unArgumento) = 1.randomUpTo(100) <= 30
}

class NaturalezaCombinada{
    const naturalezas

    method enriquece(unArgumento) = naturalezas.all { naturaleza => naturaleza.enriquece(unArgumento)}

}

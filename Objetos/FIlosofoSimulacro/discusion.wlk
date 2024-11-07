import argumentos.*

class Discusion {
    const partido1
    const partido2
    
    method esBuena() = partido1.esBueno() && partido2.esBueno()

}

class Partido{
    const filosofo
    const argumentos

    method esBueno() = filosofo.estaEnLoCorrecto() && self.tieneBuenosArgumentos()
    
    method tieneBuenosArgumentos() = self.cantidadArgumentosEnriquecedores() > self.cantidadDeArgumentos() / 2 

    method cantidadArgumentosEnriquecedores() = argumentos.count {
    argumento => argumento.esEnriquecedor()
    }
    
    method cantidadDeArgumentos() = argumentos.size() 

}
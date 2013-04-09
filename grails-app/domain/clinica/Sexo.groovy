package clinica

class Sexo {
    String descripcion
    String abreviacion

    static mapping = {
        table 'sexo'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'sexo__id'
        id generator: 'identity'
        version false
        columns {
            descripcion column: 'sexodscr'
            abreviacion column: 'sexoabrv'
        }
    }
    static constraints = {
        descripcion(maxSize: 40, blank: false, nullable: false)
        abreviacion(maxSize: 1, blank: false, nullable: false)
    }
}

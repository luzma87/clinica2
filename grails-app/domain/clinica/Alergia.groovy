package clinica

class Alergia {
    String descripcion

    static mapping = {
        table 'alrg'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'alrg__id'
        id generator: 'identity'
        version false
        columns {
            descripcion column: 'alrgdscr'
        }
    }
    static constraints = {
        descripcion(maxSize: 40, blank: false, nullable: false)
    }
}

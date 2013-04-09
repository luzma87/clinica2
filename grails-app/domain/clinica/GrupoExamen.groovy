package clinica

class GrupoExamen {
    String nombre

    static mapping = {
        table 'grex'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'grex__id'
        id generator: 'identity'
        version false
        columns {
            nombre column: 'grexnmbr'
        }
    }
    static constraints = {
        nombre(maxSize: 255, blank: false, nullable: false)
    }
}

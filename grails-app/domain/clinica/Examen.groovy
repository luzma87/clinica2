package clinica

class Examen {
    GrupoExamen grupoExamen
    String nombre
    Double valorInicial = 0
    Double valorFinal = 0

    static mapping = {
        table 'exmn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'exmn__id'
        id generator: 'identity'
        version false
        columns {
            grupoExamen column: 'grex__id'
            nombre column: 'exmnnmbr'
            valorInicial column: 'exmnvlin'
            valorFinal column: 'exmnvlfn'
        }
    }
    static constraints = {
        grupoExamen(blank: false, nullable: false)
        nombre(blank: false, nullable: false)
        valorInicial(blank: false, nullable: false)
        valorFinal(blank: false, nullable: false)
    }
}

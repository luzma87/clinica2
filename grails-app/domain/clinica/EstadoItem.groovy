package clinica

class EstadoItem {

    String codigo
    String descripcion
    TipoItem tipoItem

    static mapping = {
        table 'etit'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'etit__id'
        id generator: 'identity'
        version false
        columns {
            codigo column: 'etitcdgo'
            descripcion column: 'etitdscr'
            tipoItem column: 'tpit__id'
        }
    }
    static constraints = {
        codigo(maxSize: 1, blank: false, nullable: false)
        descripcion(maxSize: 255, blank: false, nullable: false)
    }
}

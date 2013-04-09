package clinica

class TipoItem {
    String codigo
    String descripcion

    String color //en hex: #aabbcc
    String color2 //en hex: #aabbcc

    static mapping = {
        table 'tpit'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpit__id'
        id generator: 'identity'
        version false
        columns {
            codigo column: 'tpitcdgo'
            descripcion column: 'tpitdscr'

            color column: 'tpitclor'
            color column: 'tpitclo2'
        }
    }
    static constraints = {
        codigo(maxSize: 1, blank: false, nullable: false)
        descripcion(maxSize: 255, blank: false, nullable: false)
        color(blank: false, nullable: false, size: 7..7)
        color2(blank: false, nullable: false, size: 7..7)
    }
}

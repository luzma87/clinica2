package clinica

class TipoCirugia {
    String nombre

    Integer duracionHoras
    Integer duracionMinutos

    Double valor
    Double costo

    static mapping = {
        table 'tpcr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpcr__id'
        id generator: 'identity'
        version false
        columns {
            nombre column: 'tpcrnmbr'

            duracionHoras column: 'itemdrhr'
            duracionMinutos column: 'itemdrmn'

            valor column: 'itemvlor'
            costo column: 'itemcsto'

        }
    }
    static constraints = {
        nombre(maxSize: 255, blank: false, nullable: false)
    }
}

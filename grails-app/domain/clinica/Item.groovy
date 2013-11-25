package clinica

import clinica.seguridad.Usuario

class Item {
    Usuario usuario

    Paciente paciente
    Date fecha
    Integer duracionHoras
    Integer duracionMinutos
    String razon
    Clinica clinica

    String observaciones

    Double valor
    Double costo

    Boolean pagado = false
    Boolean cobrado = false

    Date fechaPago
    Date fechaCobro

    TipoItem tipoItem
    TipoCirugia tipoCirugia

    EstadoItem estadoItem

    static mapping = {
        table 'item'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'item__id'
        id generator: 'identity'
        version false
        columns {
            usuario column: 'usro__id'
            paciente column: 'pcnt__id'
            fecha column: 'itemfcha'
            duracionHoras column: 'itemdrhr'
            duracionMinutos column: 'itemdrmn'
            razon column: 'itemrazn'
            razon type: 'text'
            clinica column: 'clnc__id'
            observaciones column: 'itemobsv'
            observaciones type: 'text'

            valor column: 'itemvlor'
            costo column: 'itemcsto'

            pagado column: 'itempgdo'
            cobrado column: 'itemcbrd'

            fechaPago column: 'itemfcpg'
            fechaCobro column: 'itemfccb'

            tipoCirugia column: 'tpcr__id'
            tipoItem column: 'tpit__id'

            estadoItem column: 'etit__id'
        }
    }
    static constraints = {
        usuario(blank: false, nullable: false)
        paciente(blank: false, nullable: false)
        fecha(blank: false, nullable: false)
        razon(blank: true, nullable: true)
        clinica(blank: true, nullable: true)
        observaciones(blank: true, nullable: true)

        valor(blank: false, nullable: false)
        costo(blank: false, nullable: false)

        fechaPago(blank: true, nullable: true)
        fechaCobro(blank: true, nullable: true)

        tipoCirugia(blank: true, nullable: true)
        tipoItem(blank: false, nullable: false)

        estadoItem(blank: false, nullable: false)
    }

    def getPorCobrar() {
        def val = this.valor
        def pagos = Pago.withCriteria {
            eq("item", this)
            eq("tipo", "C")
        }
        pagos = pagos.size() > 0 ? pagos.sum { it.valor } : 0
        return val - pagos
    }

    def getPorPagar() {
        def val = this.costo
        def pagos = Pago.withCriteria {
            eq("item", this)
            eq("tipo", "P")
        }
        pagos = pagos.size() > 0 ? pagos.sum { it.valor } : 0
        return val - pagos
    }
}

package clinica

import clinica.seguridad.Usuario

class Pago {

    Usuario usuario
    Item item

    Date fecha
    Double valor

    String tipo

    static mapping = {
        table 'pago'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'pago__id'
        id generator: 'identity'
        version false
        columns {
            usuario column: 'usro__id'
            item column: 'item__id'

            fecha column: 'pagofcha'
            valor column: 'pagovlor'

            tipo column: 'pagotipo'
        }
    }

    static constraints = {
        usuario(blank: true, nullable: true)
        item(blank: false, nullable: false)
        tipo(blank: false, nullable: false, inList: ['P', 'C'])
    }
}

package clinica

import clinica.seguridad.Usuario

class Historia {

    Usuario usuario
    Paciente paciente
    Date fecha
    String descripcion

    static mapping = {
        table 'hstr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'hstr__id'
        id generator: 'identity'
        version false
        columns {
            usuario column: 'usro__id'
            paciente column: 'pcnt__id'
            fecha column: 'hstrfcha'
            descripcion column: 'hstrdscr'
            descripcion type: "text"
        }
    }

    static constraints = {
    }
}

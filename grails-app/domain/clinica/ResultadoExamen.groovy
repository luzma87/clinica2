package clinica

import clinica.seguridad.Usuario

class ResultadoExamen {
    Usuario usuario

    Paciente paciente
    Examen examen
    Double resultado
    Date fecha
    String observaciones

    static mapping = {
        table 'rsex'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'rsex__id'
        id generator: 'identity'
        version false
        columns {
            usuario column: 'usro__id'
            paciente column: 'pcnt__id'
            examen column: 'exmn__id'
            resultado column: 'rsexrslt'
            fecha column: 'rsexfcha'
            observaciones column: 'rsexobsv'
        }
    }
    static constraints = {
        usuario(blank: false, nullable: false)
        paciente(blank: false, nullable: false)
        examen(blank: false, nullable: false)
        resultado(blank: false, nullable: false)
        fecha(blank: false, nullable: false)
        observaciones(blank: false, nullable: false)
    }
}

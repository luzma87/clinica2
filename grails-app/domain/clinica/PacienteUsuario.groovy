package clinica

import clinica.seguridad.Usuario

class PacienteUsuario {
    Usuario usuario
    Paciente paciente

    Date fechaRegistro = new Date()

    static mapping = {
        table 'pcus'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'pcus__id'
        id generator: 'identity'
        version false
        columns {
            usuario column: 'usro__id'
            paciente column: 'pcnt__id'
            fechaRegistro column: 'pcusfcrg'
        }
    }
    static constraints = {
        usuario(blank: false, nullable: false)
        paciente(blank: false, nullable: false)
        fechaRegistro(blank: false, nullable: false)
    }
}

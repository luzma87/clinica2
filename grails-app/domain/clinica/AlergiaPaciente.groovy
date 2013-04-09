package clinica

class AlergiaPaciente {
    Paciente paciente
    Alergia alergia
    Date fecha = new Date()
    String observaciones

    static mapping = {
        table 'alpc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'alpc__id'
        id generator: 'identity'
        version false
        columns {
            paciente column: 'pcnt__id'
            alergia column: 'alrg__id'
            fecha column: 'alpcfcha'
            observaciones column: 'alpcobsv'
        }
    }
    static constraints = {
        paciente(blank: false, nullable: false)
        alergia(blank: false, nullable: false)
        fecha(blank: false, nullable: false)
        observaciones(maxSize: 1023, blank: true, nullable: true)
    }
}

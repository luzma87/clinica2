package clinica

class Clinica {
    String nombre
    String direccion
    String telefono
    String observaciones

    static mapping = {
        table 'clnc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'clnc__id'
        id generator: 'identity'
        version false
        columns {
            nombre column: 'clncnmbr'
            direccion column: 'clncdrcc'
            telefono column: 'clnctlfn'
            observaciones column: 'clncobsv'
        }
    }
    static constraints = {
        nombre(blank: false, nullable: false)
        direccion(blank: true, nullable: true, maxSize: 511)
        telefono(blank: true, nullable: true, maxSize: 31)
        observaciones(blank: true, nullable: true, maxSize: 1023)
    }
}

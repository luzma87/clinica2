package clinica

class Paciente {
    String cedula
    String nombres
    String apellidos
    Date fechaNacimiento
    Sexo sexo
    String direccion
    String telefono
    String email

    Boolean fuma
    String fumaDesc
    Boolean bebe
    String bebeDesc
    Boolean drogas
    String drogasDesc

    static hasMany = [alergias: Alergia]

    static mapping = {
        table 'pcnt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'pcnt__id'
        id generator: 'identity'
        version false
        columns {
            cedula column: 'pcntcdla'
            nombres column: 'pcntnmbr'
            apellidos column: 'pcntapll'
            fechaNacimiento column: 'pcntfcnc'
            sexo column: 'sexo__id'
            direccion column: 'pcntdrcc'
            telefono column: 'pcnttlfn'
            email column: 'pcntmail'
            fuma column: 'pcntfuma'
            fumaDesc column: 'pcntfmds'
            bebe column: 'pcntbebe'
            bebeDesc column: 'pcntbbds'
            drogas column: 'pcntdrgs'
            drogasDesc column: 'pcntdrds'
        }
    }
    static constraints = {
        cedula(blank: false, nullable: false, maxSize: 10)
        nombres(blank: false, nullable: false, maxSize: 255)
        apellidos(blank: false, nullable: false, maxSize: 255)
        fechaNacimiento(blank: false, nullable: false)
        sexo(blank: false, nullable: false)
        direccion(blank: true, nullable: true, maxSize: 1023)
        telefono(blank: true, nullable: true, maxSize: 31)
        email(blank: true, nullable: true, email: true, maxSize: 65)
        fuma(blank: false, nullable: false)
        fumaDesc(blank: true, nullable: true)
        bebe(blank: false, nullable: false)
        bebeDesc(blank: true, nullable: true)
        drogas(blank: false, nullable: false)
        drogasDesc(blank: true, nullable: true)
    }

    def getEdad() {
        def edad = [:]
        def dias = new Date() - this.fechaNacimiento
        def meses = dias / 30
        def anios = dias / 365
        dias = dias % 30
        edad.days = dias
        edad.months = meses
        edad.years = anios
        return edad
    }

    def getCirugias(usu) {
        def cirugias = Item.withCriteria {
            eq("usuario", usu)
            eq("paciente", this)
            eq("tipoItem", TipoItem.findByCodigo("I"))
        }
        return cirugias
    }

    def getControles(usu) {
        def controles = Item.withCriteria {
            eq("usuario", usu)
            eq("paciente", this)
            eq("tipoItem", TipoItem.findByCodigo("O"))
        }
        return controles
    }
}

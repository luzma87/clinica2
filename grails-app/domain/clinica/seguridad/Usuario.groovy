package clinica.seguridad

class Usuario {
    String usuario
    String password
    String nombres
    String email

    static mapping = {
        table 'usro'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'usro__id'
        id generator: 'identity'
        version false
        columns {
            usuario column: 'usrouser'
            password column: 'usropass'
            nombres column: 'usronmbr'
            email column: 'usromail'
        }
    }
    static constraints = {
        usuario(blank: false, nullable: false, unique: true)
        password(blank: false, nullable: false, password: true)
        nombres(blank: false, nullable: false, maxSize: 511)
        email(blank: true, nullable: true, email: true, unique: true)
    }
}

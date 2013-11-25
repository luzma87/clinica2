import clinica.EstadoItem
import clinica.Sexo
import clinica.TipoItem
import clinica.seguridad.Usuario

class BootStrap {

    def init = { servletContext ->
        def su = Usuario.findByUsuario("admin")
        if (!su) {
            println "creando usuario admin"
            su = new Usuario()
            su.nombres = "Administrador"
            su.usuario = "admin"
            su.password = "123".encodeAsMD5()
            su.email = "luzma_87@yahoo.com"
            if (!su.save(flush: true)) {
                println "no se pudo crear usuario admin: "
                println su.errors
            }
        }
        if (Sexo.count() == 0) {
            println "creando Masculino"
            def m = new Sexo(descripcion: "Masculino", abreviacion: "M")
            if (!m.save(flush: true)) {
                println "\terror: " + m.errors
            }
            println "creando Femenino"
            def f = new Sexo(descripcion: "Femenino", abreviacion: "F")
            if (!f.save(flush: true)) {
                println "\terror: " + f.errors
            }
        }
        if (TipoItem.count() == 0) {
            println "creando Cirugia"
            def c = new TipoItem(codigo: 'I', descripcion: "Cirugía", color: "#9CE5C9", color2: "#2FA378")
            if (!c.save(flush: true)) {
                println "\terror: " + c.errors
            }
            println "creando Control"
            def o = new TipoItem(codigo: 'O', descripcion: "Control", color: "#88C1E0", color2: "#3081AD")
            if (!o.save(flush: true)) {
                println "\terror: " + o.errors
            }
        }
        if (EstadoItem.count() == 0) {
            def i = TipoItem.findByCodigo("I")
            def o = TipoItem.findByCodigo("O")
            println "creando A tiempo"
            def t = new EstadoItem(codigo: 'T', descripcion: "A tiempo", tipoItem: i)
            if (!t.save(flush: true)) {
                println "\terror: " + t.errors
            }
            t = new EstadoItem(codigo: 'T', descripcion: "A tiempo", tipoItem: o)
            if (!t.save(flush: true)) {
                println "\terror: " + t.errors
            }
            println "creando Postpuesto"
            def p = new EstadoItem(codigo: 'P', descripcion: "Postpuesta", tipoItem: i)
            if (!p.save(flush: true)) {
                println "\terror: " + p.errors
            }
            println "creando Completado"
            def c = new EstadoItem(codigo: 'C', descripcion: "Completada", tipoItem: i)
            if (!c.save(flush: true)) {
                println "\terror: " + c.errors
            }
            println "creando Cancelado"
            def a = new EstadoItem(codigo: 'A', descripcion: "Cancelada", tipoItem: i)
            if (!a.save(flush: true)) {
                println "\terror: " + a.errors
            }
            a = new EstadoItem(codigo: 'A', descripcion: "Cancelado", tipoItem: o)
            if (!a.save(flush: true)) {
                println "\terror: " + a.errors
            }
        }
    }
    def destroy = {
    }
}

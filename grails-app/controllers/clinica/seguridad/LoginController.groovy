package clinica.seguridad

class LoginController {

    def cnDefault = "inicio", anDefault = "index"

    def index() {
        redirect(action: 'login')
    }

    def login() {
        if (session.user) {
            if (session.cn && session.an) {
                redirect(controller: session.cn, action: session.attributeNames, params: session.pr)
            } else {
                redirect(controller: cnDefault, action: anDefault)
            }
        }
    }

    def logout() {
        session.user = null
        session.cn = null
        session.an = null
        session.pr = null
        redirect(action: "login")
    }

    def validarLogin() {
        def user = Usuario.withCriteria {
            and {
                or {
                    eq('usuario', params.user)
                    eq('email', params.user)
                }
                eq("password", params.pass.toString().encodeAsMD5())
            }
        }
        if (user.size() == 0) {
            flash.message = "No se encontr&oacute; el usuario"
            redirect(action: 'login')
            return
        } else if (user.size() > 1) {
            flash.message = "Error grave!"
            redirect(action: 'login')
            return
        } else {
            user = user[0]
            session.user = user
            if (session.cn && session.an) {
                redirect(controller: session.cn, action: session.attributeNames, params: session.pr)
            } else {
                redirect(controller: cnDefault, action: anDefault)
            }
            return
        }
    }

    def validarSesion() {
        if (session.user) {
            render "OK"
        } else {
            render "NO"
        }
    }
}

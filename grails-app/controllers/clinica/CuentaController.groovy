package clinica

import clinica.seguridad.Usuario

class CuentaController extends clinica.seguridad.Shield {

    def list() {
        if (!params.sort) {
            params.sort = "fecha"
        }
        if (!params.order) {
            params.order = "asc"
        }
        if (!params.old) {
            params.old = '1'
        }
        if (!params.today) {
            params.today = '1'
        }
        if (!params.future) {
            params.future = '1'
        }
        if (!params.cobrar) {
            params.cobrar = '1'
        }
        if (!params.pagar) {
            params.pagar = '1'
        }
        if (!params.completos) {
            params.completos = '1'
        }
        if (!params.incompletos) {
            params.incompletos = '1'
        }

        if (params.old == "0" && params.today == "0" && params.future == "0") {
            params.today = "1"
        }
        if (params.cobrar == "0" && params.pagar == "0") {
            params.cobrar = '1'
            params.pagar = '1'
        }
        if (params.completos == "0" && params.incompletos == "0") {
            params.completos = '1'
            params.incompletos = '1'
        }

        def usu = Usuario.get(session.user.id)
        def hoy1 = new Date()
        hoy1.hours = 0
        hoy1.minutes = 0
        hoy1.seconds = 0
        def hoy2 = new Date()
        hoy2.hours = 23
        hoy2.minutes = 59
        hoy2.seconds = 59

        def cobrar = [], pagar = []

        if (params.cobrar == '1') {
            def c = Item.createCriteria()
            cobrar = c.list(params) {
                eq("usuario", usu)
                gt("valor", 0.toDouble())
                or {
                    if (params.today == '1') {
                        between("fecha", hoy1, hoy2)
                    }
                    if (params.future == '1') {
                        gt("fecha", hoy2)
                    }
                    if (params.old == '1') {
                        lt("fecha", hoy1)
                    }
                }
            }
        }
        if (params.pagar == '1') {
            def p = Item.createCriteria()
            pagar = p.list(params) {
                eq("usuario", usu)
                gt("costo", 0.toDouble())
                or {
                    if (params.today == '1') {
                        between("fecha", hoy1, hoy2)
                    }
                    if (params.future == '1') {
                        gt("fecha", hoy2)
                    }
                    if (params.old == '1') {
                        lt("fecha", hoy1)
                    }
                }
            }
        }

        return [cobrar: cobrar, pagar: pagar, params: params]
    }
}

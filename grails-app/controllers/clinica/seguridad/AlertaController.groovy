package clinica.seguridad

import clinica.Clinica
import clinica.Item
import groovy.time.TimeCategory

class AlertaController extends Shield {

    def index() {

        if (!params.dias) {
            params.dias = "5"
        }

        def hoy = new Date().clearTime()

        def fechaFin
        use(TimeCategory) {
            fechaFin = hoy + params.dias.toInteger().days
        }

        Calendar calendar = GregorianCalendar.instance
        calendar.set(hoy.format("yyyy").toInteger(), hoy.format("MM").toInteger() - 1, hoy.format("dd").toInteger())
        def lastDay = calendar.getActualMaximum(GregorianCalendar.DAY_OF_MONTH)
        def endMonth = new Date().parse("dd-MM-yyyy", lastDay + hoy.format("-MM-yyyy"))

        def clinicas = Clinica.withCriteria {
            or {
                isNull("direccion")
                isNull("telefono")
            }
        }
        def pagosVencidos = Item.withCriteria {
            lt("fechaPago", hoy)
            eq("pagado", false)
        }
        def pagosDias = Item.withCriteria {
            between("fechaPago", hoy, fechaFin)
        }
        def pagosMes = Item.withCriteria {
            between("fechaPago", hoy, endMonth)
        }

        return [clinicas: clinicas, pagosVencidos: pagosVencidos, pagosDias: pagosDias, pagosMes: pagosMes, params: params]
    }
}

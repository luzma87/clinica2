package clinica

import clinica.seguridad.Usuario
import grails.converters.JSON
import groovy.time.TimeCategory

class CalendarioController extends clinica.seguridad.Shield {

    def index() {
        def usu = Usuario.get(session.user.id)
        def jsonString = "["
        Item.findAllByUsuario(usu).each { cirugia ->
            def strDate = cirugia.fecha.format("yyyy") + "," + (cirugia.fecha.format("MM").toInteger() - 1) + "," + cirugia.fecha.format("dd,HH,mm")
            def end
            def h = cirugia.duracionHoras
            def m = cirugia.duracionMinutos
            use(TimeCategory) {
                end = cirugia.fecha + h.hours + m.minutes
            }
            def strDateE = end.format("yyyy") + "," + (end.format("MM").toInteger() - 1) + "," + end.format("dd,HH,mm")
            jsonString += "{"
            jsonString += '"id":"i' + cirugia.id + '",'
            jsonString += '"iid":' + cirugia.id + ','
            jsonString += '"title":" ' + cirugia.paciente.nombres + " " + cirugia.paciente.apellidos + '",'
            jsonString += '"paciente":"' + cirugia.paciente.nombres + " " + cirugia.paciente.apellidos + '",'
            jsonString += '"ci":"' + cirugia.paciente.cedula + '",'
            jsonString += '"clinica":"' + cirugia?.clinica?.nombre + '",'
            jsonString += '"razon":"' + cirugia.razon + '",'
            jsonString += '"start": new Date(' + strDate + '),'
            jsonString += '"end": new Date(' + strDateE + '),'
            jsonString += '"allDay": false,'
            jsonString += '"color": "' + cirugia.tipoItem.color + '",'
            jsonString += '"tipo":"' + cirugia.tipoItem.codigo + '",'
            jsonString += '"className":"' + cirugia.tipoItem.codigo + '"'
            jsonString += "},"

            if (cirugia.fechaPago) {
                strDate = cirugia.fechaPago.format("yyyy") + "," + (cirugia.fechaPago.format("MM").toInteger() - 1) + "," + cirugia.fechaPago.format("dd,HH,mm")
                jsonString += "{"
                jsonString += '"id":"i' + cirugia.id + '",'
                jsonString += '"iid":' + cirugia.id + ','
                jsonString += '"title":" Pagar",'
                jsonString += '"start": new Date(' + strDate + '),'
                jsonString += '"allDay": true,'
                jsonString += '"color": "' + cirugia.tipoItem.color2 + '",'
                jsonString += '"tipo":"' + cirugia.tipoItem.codigo + '",'
                jsonString += '"className":"' + cirugia.tipoItem.codigo + '"'
                jsonString += "},"
            }
            if (cirugia.fechaCobro) {
                strDate = cirugia.fechaCobro.format("yyyy") + "," + (cirugia.fechaCobro.format("MM").toInteger() - 1) + "," + cirugia.fechaCobro.format("dd,HH,mm")
                jsonString += "{"
                jsonString += '"id":"i' + cirugia.id + '",'
                jsonString += '"iid":' + cirugia.id + ','
                jsonString += '"title":" Cobrar",'
                jsonString += '"start": new Date(' + strDate + '),'
                jsonString += '"allDay": true,'
                jsonString += '"color": "' + cirugia.tipoItem.color2 + '",'
                jsonString += '"tipo":"' + cirugia.tipoItem.codigo + '",'
                jsonString += '"className":"' + cirugia.tipoItem.codigo + '"'
                jsonString += "},"
            }
        }

        if (jsonString != "[") {
            jsonString = jsonString[0..jsonString.size() - 2]
        }
        jsonString += "]"
        return [events: jsonString]
    }
}

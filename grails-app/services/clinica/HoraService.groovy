package clinica

import clinica.seguridad.Usuario
import groovy.time.TimeCategory

class HoraService {

    def verificarHorario(Usuario user, Date fecha, Integer horas, Integer minutos) {
        def conflictosControl = []
        def conflictosCirugia = []
        def fechaFin
        use(TimeCategory) {
            fechaFin = fecha + horas.hours + minutos.minutes
        }
//        println fecha
//        println horas + "        " + minutos
//        println fechaFin
        /*
                   **** -> evento existente
                   ++++ -> evento a ingresar

                                   |++++++++++|
                   caso 0: ******  |          |
                   caso 1:   ******|**********|*******
                   caso 2: ********|***
                   caso 3:         |      ****|***********
                   caso 4:         |  *****   |
        */

        Item.withCriteria {
            eq("usuario", user)
            lt("fecha", fecha)
            eq("tipoItem", TipoItem.findByCodigo("O"))
        }.each { control ->
            def end
            def h = control.duracionHoras
            def m = control.duracionMinutos
            use(TimeCategory) {
                end = control.fecha + h.hours + m.minutes
            }

            //caso 1:
            if (control.fecha <= fecha && fecha <= end && fechaFin >= control.fecha && fechaFin <= end) {
//                println control
                conflictosControl.add(control)
            }
            //caso 2:
            if (end >= fecha && end <= fechaFin) {
//                println control
                conflictosControl.add(control)
            }
            //caso 3:
            if (control.fecha >= fecha && control.fecha <= fechaFin) {
//                println control
                conflictosControl.add(control)
            }
            //caso 4:
            if (control.fecha >= fecha && control.fecha <= fechaFin && end >= fechaFin && end <= fechaFin) {
//                println control
                conflictosControl.add(control)
            }
        }
        Item.withCriteria {
            eq("usuario", user)
            lt("fecha", fecha)
            eq("tipoItem", TipoItem.findByCodigo("I"))
        }.each { cirugia ->
            def end
            def h = cirugia.duracionHoras
            def m = cirugia.duracionMinutos
            use(TimeCategory) {
                end = cirugia.fecha + h.hours + m.minutes
            }
            //caso 1:
            if (cirugia.fecha <= fecha && fecha <= end && fechaFin >= cirugia.fecha && fechaFin <= end) {
//                println cirugia
                conflictosCirugia.add(cirugia)
            }
            //caso 2:
            if (end >= fecha && end <= fechaFin) {
//                println cirugia
                conflictosCirugia.add(cirugia)
            }
            //caso 3:
            if (cirugia.fecha >= fecha && cirugia.fecha <= fechaFin) {
//                println cirugia
                conflictosCirugia.add(cirugia)
            }
            //caso 4:
            if (cirugia.fecha >= fecha && cirugia.fecha <= fechaFin && end >= fechaFin && end <= fechaFin) {
//                println cirugia
                conflictosControl.add(cirugia)
            }
        }
        return [
                control: conflictosControl,
                cirugia: conflictosCirugia
        ]
    }
}

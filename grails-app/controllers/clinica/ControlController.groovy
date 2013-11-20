package clinica

import clinica.seguridad.Usuario
import org.springframework.dao.DataIntegrityViolationException

class ControlController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def horaService

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        def usu = Usuario.get(session.user.id)
        def paciente = Paciente.get(params.id)
        def c = Item.createCriteria()
        def list = c.list(params) {
            eq("paciente", paciente)
            eq("usuario", usu)
            eq("tipoItem", TipoItem.findByCodigo("O"))
        }
        return [controlInstanceList: list, params: params, paciente: paciente]
    } //list

    def listAll() {
        if (!params.sort) {
            params.sort = "fecha"
        }
        if (!params.order) {
            params.order = "asc"
        }
        if (!params.old) {
            params.old = '0'
        }
        if (!params.today) {
            params.today = '1'
        }
        if (!params.future) {
            params.future = '1'
        }

        if (params.old == "0" && params.today == "0" && params.future == "0") {
            params.today = "1"
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

        def c = Item.createCriteria()
        def lista = c.list(params) {
            eq("usuario", usu)
            eq("tipoItem", TipoItem.findByCodigo("O"))
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

        return [controlInstanceList: lista, params: params]
//        return [controlInstanceList: Control.findAllByUsuario(usu, params), params: params]
    }

    def findPaciente_ajax() {
        def pacientes = Paciente.findAllByCedula(params.ci.trim())
        if (pacientes.size() == 0) {
            render "NO"
        } else if (pacientes.size() == 1) {
            render "OK_" + pacientes[0].id + "_" + pacientes[0].nombres + " " + pacientes[0].apellidos
        } else {
            render "NO"
        }
    }

    def form_ajax() {
        def paciente = Paciente.get(params.paciente)
        def controlInstance = new Item(params)
        controlInstance.tipoItem = TipoItem.findByCodigo("O")
        controlInstance.paciente = paciente
        if (params.id) {
            controlInstance = Item.get(params.id)
            if (!controlInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Control con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        if (params.date) {
            controlInstance.fecha = new Date().parse("dd-MM-yyyy", params.date)
        }
        return [controlInstance: controlInstance]
    } //form_ajax

    def save() {
        if (params.fecha) {
            params.fecha = new Date().parse("dd-MM-yyyy HH:mm", (params.fecha + " " + params.hora + ":" + params.min))
        }
        if (params.fechaPago) {
            params.fechaPago = new Date().parse("dd-MM-yyyy", params.fechaPago)
        }
        if (params.fechaCobro) {
            params.fechaCobro = new Date().parse("dd-MM-yyyy", params.fechaCobro)
        }
        def usu = clinica.seguridad.Usuario.get(session.user.id)
        params.usuario = usu
        def conflictos = horaService.verificarHorario(session.user, params.fecha, params.duracionHoras.toInteger(), params.duracionMinutos.toInteger())
//        println conflictos
        if (conflictos.control.size() > 0 || conflictos.cirugia.size() > 0) {
            flash.clase = "alert-error"
            def str = "<h4>Se encontraron los siguientes conflictos</h4>"
            str += "<ul>"
            conflictos.control.each { co ->
                str += "<li>"
                str += "Control con " + co.paciente.nombres + " " + co.paciente.apellidos + " el " + co.fecha.format("dd-MM-yyyy HH:mm") + " (" + (co.duracionHoras.toString().padLeft(2, '0')) + ":" + (co.duracionMinutos.toString().padLeft(2, '0')) + ")"
                str += "</li>"
            }
            conflictos.cirugia.each { co ->
                str += "<li>"
                str += "Cirugía a " + co.paciente.nombres + " " + co.paciente.apellidos + " el " + co.fecha.format("dd-MM-yyyy HH:mm") + " (" + (co.duracionHoras.toString().padLeft(2, '0')) + ":" + (co.duracionMinutos.toString().padLeft(2, '0')) + ")"
                str += "</li>"
            }
            str += "</ul>"
            flash.message = str
            if (params.tipo) {
                switch (params.tipo) {
                    case "calendar":
                        redirect(controller: "calendario", action: "index")
                        break;
                    case "all":
                        redirect(action: 'listAll')
                        break;
                    default:
                        redirect(action: 'listAll')
                }
            } else {
                redirect(action: 'list', id: paciente.id)
            }
        } else {
            def paciente = Paciente.get(params.paciente.id)
            params.paciente = paciente
            def controlInstance
            if (params.id) {
                controlInstance = Item.get(params.id)
                if (!controlInstance) {
                    flash.clase = "alert-error"
                    flash.message = "No se encontró Control con id " + params.id
                    if (params.tipo) {
                        switch (params.tipo) {
                            case "calendar":
                                redirect(controller: "calendario", action: "index")
                                break;
                            case "all":
                                redirect(action: 'listAll')
                                break;
                            default:
                                redirect(action: 'listAll')
                        }
                    } else {
                        redirect(action: 'list', id: paciente.id)
                    }
                    return
                }//no existe el objeto
                controlInstance.properties = params
            }//es edit
            else {
                controlInstance = new Item(params)
                controlInstance.tipoItem = TipoItem.findByCodigo("O")
            } //es create
            if (!controlInstance.save(flush: true)) {
                flash.clase = "alert-error"
                def str = "<h4>No se pudo guardar Control " + (controlInstance.id ? controlInstance.id : "") + "</h4>"
                str += renderErrors(bean: controlInstance)
                flash.message = str
                if (params.tipo) {
                    switch (params.tipo) {
                        case "calendar":
                            redirect(controller: "calendario", action: "index")
                            break;
                        case "all":
                            redirect(action: 'listAll')
                            break;
                        default:
                            redirect(action: 'listAll')
                    }
                } else {
                    redirect(action: 'list', id: paciente.id)
                }
                return
            }

            if (params.id) {
                flash.clase = "alert-success"
                flash.message = "Se ha actualizado correctamente Control " + controlInstance.id
            } else {
                flash.clase = "alert-success"
                flash.message = "Se ha creado correctamente Control " + controlInstance.id
            }
            if (params.tipo) {
                switch (params.tipo) {
                    case "calendar":
                        redirect(controller: "calendario", action: "index")
                        break;
                    case "all":
                        redirect(action: 'listAll')
                        break;
                    default:
                        redirect(action: 'listAll')
                }
            } else {
                redirect(action: 'list', id: paciente.id)
            }
        }
    } //save

    def show_ajax() {
        def controlInstance = Item.get(params.id)
        if (!controlInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Control con id " + params.id
            redirect(action: "list", id: params.id)
            return
        }
        [controlInstance: controlInstance]
    } //show

    def delete() {
        def controlInstance = Item.get(params.id)
        if (!controlInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Control con id " + params.id
            redirect(action: "list", id: params.id)
            return
        }

        try {
            controlInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Control " + controlInstance.id
            redirect(action: "list", id: params.id)
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Control " + (controlInstance.id ? controlInstance.id : "")
            redirect(action: "list", id: params.id)
        }
    } //delete
} //fin controller

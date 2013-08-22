package clinica

import clinica.seguridad.Usuario
import groovy.time.TimeCategory
import groovy.time.TimeDuration
import org.springframework.dao.DataIntegrityViolationException


class PacienteController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        def usu = Usuario.get(session.user.id)
        def pacientes = PacienteUsuario.findAllByUsuario(usu).paciente
        return [pacienteInstanceList: pacientes, params: params]
    } //list

    def importar() {
        def usu = Usuario.get(session.user.id)
        def paciente = Paciente.findByCedula(params.ci)
        def pu = new PacienteUsuario([
                usuario: usu,
                paciente: paciente
        ])
        if (!pu.save(flush: true)) {
            render "NO"
        } else {
            render "OK"
        }
    }

    def checkCi_ajax() {
        if (params.id) {
            def paciente = Paciente.get(params.id)
            if (paciente.cedula == params.cedula) {
                render true
                return
            } else {
                render Paciente.countByCedula(params.cedula) == 0
                return
            }
        } else {
            render Paciente.countByCedula(params.cedula) == 0
            return
        }
    }

    def form_ajax() {
        def pacienteInstance = new Paciente(params)
        if (params.id) {
            pacienteInstance = Paciente.get(params.id)
            if (!pacienteInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Paciente con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [pacienteInstance: pacienteInstance]
    } //form_ajax

    def save() {
        println params
        def usu = Usuario.get(session.user.id)
        if (params.fechaNacimiento) {
            params.fechaNacimiento = new Date().parse("dd-MM-yyyy", params.fechaNacimiento)
        }
        def pacienteInstance
        if (params.id) {
            pacienteInstance = Paciente.get(params.id)
            if (!pacienteInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Paciente con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            pacienteInstance.properties = params
        }//es edit
        else {
            println "CREATE!!"
            pacienteInstance = new Paciente(params)
        } //es create
        if (!pacienteInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Paciente " + (pacienteInstance.id ? (pacienteInstance.nombres + " " + pacienteInstance.apellidos) : "") + "</h4>"
            str += renderErrors(bean: pacienteInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }
        if (!params.id) {
            def pacUsu = new PacienteUsuario(usuario: usu, paciente: pacienteInstance)
            if (!pacUsu.save(flush: true)) {
                println "error al crear usuario-paciente"
                flash.clase = "alert-error"
                flash.message = "No se pudo guardar el paciente"
            } else {
                if (params.id) {
                    flash.clase = "alert-success"
                    flash.message = "Se ha actualizado correctamente Paciente " + (pacienteInstance.nombres + " " + pacienteInstance.apellidos)
                } else {
                    flash.clase = "alert-success"
                    flash.message = "Se ha creado correctamente Paciente " + (pacienteInstance.nombres + " " + pacienteInstance.apellidos)
                }
            }
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def pacienteInstance
        if (params.id) {
            pacienteInstance = Paciente.get(params.id)
        } else if (params.ci) {
            pacienteInstance = Paciente.findByCedula(params.ci)
        }
        if (!pacienteInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Paciente con id " + params.id
            redirect(action: "list")
            return
        }
        [pacienteInstance: pacienteInstance]
    } //show

    def delete() {
        def pacienteInstance = Paciente.get(params.id)

        def alergias = AlergiaPaciente.countByPaciente(pacienteInstance)
        def items = Item.findAllByPaciente(pacienteInstance)
        def controles = items.count { it.tipoItem.codigo == "O" }
        def cirugias = items.count { it.tipoItem.codigo == "I" }
        def examenes = ResultadoExamen.countByPaciente(pacienteInstance)

        if (!pacienteInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Paciente con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            pacienteInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Paciente " + (pacienteInstance.nombres + " " + pacienteInstance.apellidos)
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Paciente " + (pacienteInstance.id ? (pacienteInstance.nombres + " " + pacienteInstance.apellidos) : "") + " pues tiene:"
            def list = "<ul>"
            list += controles > 0 ? "<li>${controles} control${controles == 1 ? '' : 'es'}</li>" : ""
            list += cirugias > 0 ? "<li>${cirugias} cirugía${cirugias == 1 ? '' : 's'}</li>" : ""
            list += examenes > 0 ? "<li>${examenes} examen${examenes == 1 ? '' : 'es'}</li>" : ""
            list += alergias > 0 ? "<li>${alergias} alergia${alergias == 1 ? '' : 's'}</li>" : ""
            list += "</ul>"
            flash.message += list
            redirect(action: "list")
        }
    } //delete
} //fin controller

package clinica

import clinica.seguridad.Usuario
import org.springframework.dao.DataIntegrityViolationException

class HistoriaController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        def usu = Usuario.get(session.user.id)
        def paciente = Paciente.get(params.id)
        def c = Historia.createCriteria()
        def list = c.list(params) {
            eq("paciente", paciente)
            eq("usuario", usu)
            order("fecha", "desc")
        }
        return [historiaInstanceList: list, params: params, paciente: paciente]
    } //list

    def form_ajax() {
        def paciente = Paciente.get(params.paciente)
        def historiaInstance = new Historia(params)
        historiaInstance.paciente = paciente
        if (params.id) {
            historiaInstance = Historia.get(params.id)
            if (!historiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Historia con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [historiaInstance: historiaInstance]
    } //form_ajax

    def save() {

        if (params.fecha) {
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        def usu = clinica.seguridad.Usuario.get(session.user.id)
        params.usuario = usu
        def paciente = Paciente.get(params.paciente.id)
        params.paciente = paciente

        def historiaInstance
        if (params.id) {
            historiaInstance = Historia.get(params.id)
            if (!historiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Historia con id " + params.id
                redirect(action: 'list', id: paciente.id)
                return
            }//no existe el objeto
            historiaInstance.properties = params
        }//es edit
        else {
            historiaInstance = new Historia(params)
        } //es create
        if (!historiaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar la Historia del " + (historiaInstance.id ? historiaInstance.fecha.format("dd-MM-yyyy") : "") + "</h4>"
            str += renderErrors(bean: historiaInstance)
            flash.message = str
            redirect(action: 'list', id: paciente.id)
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente la Historia del " + historiaInstance.fecha.format("dd-MM-yyyy")
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente la Historia del " + historiaInstance.fecha.format("dd-MM-yyyy")
        }
        redirect(action: 'list', id: paciente.id)
    } //save

    def show_ajax() {
        def historiaInstance = Historia.get(params.id)
        if (!historiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Historia con id " + params.id
            redirect(action: "list")
            return
        }
        [historiaInstance: historiaInstance]
    } //show

    def delete() {
        def historiaInstance = Historia.get(params.id)
        if (!historiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Historia con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            historiaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Historia " + historiaInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Historia " + (historiaInstance.id ? historiaInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

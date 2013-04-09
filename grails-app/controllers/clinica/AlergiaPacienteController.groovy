package clinica

import org.springframework.dao.DataIntegrityViolationException

class AlergiaPacienteController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def loadList() {
        def alergias = AlergiaPaciente.findAllByPaciente(Paciente.get(params.paciente))
        println alergias
        return [alergias: alergias]
    }

    def list_ajax() {
        def paciente = Paciente.get(params.id)
        def alergias = "["
        Alergia.list([sort: 'descripcion']).each { alergia ->
            alergias += "'${alergia.descripcion}',"
        }
        alergias = alergias[0..alergias.size() - 2]
        alergias += "]"

        return [alergias: alergias, paciente: paciente]
    }

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [alergiaPacienteInstanceList: AlergiaPaciente.list(params), params: params]
    } //list

    def form_ajax() {
        def alergiaPacienteInstance = new AlergiaPaciente(params)
        if (params.id) {
            alergiaPacienteInstance = AlergiaPaciente.get(params.id)
            if (!alergiaPacienteInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Alergia Paciente con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [alergiaPacienteInstance: alergiaPacienteInstance]
    } //form_ajax

    def save() {
        def alergia = Alergia.findOrSaveByDescripcion(params.alergia.trim())
        params.alergia = alergia
        def paciente = Paciente.get(params.paciente)
        params.paciente = paciente
        def alergiaPacienteInstance
        if (params.id) {
            alergiaPacienteInstance = AlergiaPaciente.get(params.id)
            if (!alergiaPacienteInstance) {
//                flash.clase = "alert-error"
//                flash.message = "No se encontró Alergia Paciente con id " + params.id
//                redirect(action: 'list')
                render "NO"
                return
            }//no existe el objeto
            alergiaPacienteInstance.properties = params
        }//es edit
        else {
            alergiaPacienteInstance = new AlergiaPaciente(params)
        } //es create
        if (!alergiaPacienteInstance.save(flush: true)) {
//            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Alergia Paciente " + (alergiaPacienteInstance.id ? alergiaPacienteInstance.id : "") + "</h4>"
//            str += renderErrors(bean: alergiaPacienteInstance)
//            flash.message = str
//            redirect(action: 'list')
            println alergiaPacienteInstance.errors
            render "NO"
            return
        }

        render "OK"
//        if (params.id) {
//            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Alergia Paciente " + alergiaPacienteInstance.id
//        } else {
//            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Alergia Paciente " + alergiaPacienteInstance.id
//        }
//        redirect(action: 'list')
    } //save

    def show_ajax() {
        def alergiaPacienteInstance = AlergiaPaciente.get(params.id)
        if (!alergiaPacienteInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Alergia Paciente con id " + params.id
            redirect(action: "list")
            return
        }
        [alergiaPacienteInstance: alergiaPacienteInstance]
    } //show

    def deleteAl() {
        def alergiaPacienteInstance = AlergiaPaciente.get(params.id)
        if (!alergiaPacienteInstance) {
//            flash.clase = "alert-error"
//            flash.message = "No se encontró Alergia Paciente con id " + params.id
//            redirect(action: "list")
            render "NO"
            return
        }

        try {
            alergiaPacienteInstance.delete(flush: true)
//            flash.clase = "alert-success"
//            flash.message = "Se ha eliminado correctamente Alergia Paciente " + alergiaPacienteInstance.id
//            redirect(action: "list")
            render "OK"
        }
        catch (DataIntegrityViolationException e) {
//            flash.clase = "alert-error"
//            flash.message = "No se pudo eliminar Alergia Paciente " + (alergiaPacienteInstance.id ? alergiaPacienteInstance.id : "")
//            redirect(action: "list")
            render "NO"
        }
    } //delete
} //fin controller

package clinica



import org.springframework.dao.DataIntegrityViolationException

class PacienteUsuarioController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [pacienteUsuarioInstanceList: PacienteUsuario.list(params), params: params]
    } //list

    def form_ajax() {
        def pacienteUsuarioInstance = new PacienteUsuario(params)
        if (params.id) {
            pacienteUsuarioInstance = PacienteUsuario.get(params.id)
            if (!pacienteUsuarioInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Paciente Usuario con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [pacienteUsuarioInstance: pacienteUsuarioInstance]
    } //form_ajax

    def save() {
        def pacienteUsuarioInstance
        if (params.id) {
            pacienteUsuarioInstance = PacienteUsuario.get(params.id)
            if (!pacienteUsuarioInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Paciente Usuario con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            pacienteUsuarioInstance.properties = params
        }//es edit
        else {
            pacienteUsuarioInstance = new PacienteUsuario(params)
        } //es create
        if (!pacienteUsuarioInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Paciente Usuario " + (pacienteUsuarioInstance.id ? pacienteUsuarioInstance.id : "") + "</h4>"
            str += renderErrors(bean: pacienteUsuarioInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Paciente Usuario " + pacienteUsuarioInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Paciente Usuario " + pacienteUsuarioInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def pacienteUsuarioInstance = PacienteUsuario.get(params.id)
        if (!pacienteUsuarioInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Paciente Usuario con id " + params.id
            redirect(action: "list")
            return
        }
        [pacienteUsuarioInstance: pacienteUsuarioInstance]
    } //show

    def delete() {
        def pacienteUsuarioInstance = PacienteUsuario.get(params.id)
        if (!pacienteUsuarioInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Paciente Usuario con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            pacienteUsuarioInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Paciente Usuario " + pacienteUsuarioInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Paciente Usuario " + (pacienteUsuarioInstance.id ? pacienteUsuarioInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

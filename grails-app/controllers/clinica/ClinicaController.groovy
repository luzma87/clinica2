package clinica



import org.springframework.dao.DataIntegrityViolationException

class ClinicaController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [clinicaInstanceList: Clinica.list(params), params: params]
    } //list

    def form_ajax() {
        def clinicaInstance = new Clinica(params)
        if (params.id) {
            clinicaInstance = Clinica.get(params.id)
            if (!clinicaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Clinica con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [clinicaInstance: clinicaInstance]
    } //form_ajax

    def save() {
        def clinicaInstance
        if (params.id) {
            clinicaInstance = Clinica.get(params.id)
            if (!clinicaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Clinica con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            clinicaInstance.properties = params
        }//es edit
        else {
            clinicaInstance = new Clinica(params)
        } //es create
        if (!clinicaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Clinica " + (clinicaInstance.id ? clinicaInstance.id : "") + "</h4>"
            str += renderErrors(bean: clinicaInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Clinica " + clinicaInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Clinica " + clinicaInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def clinicaInstance = Clinica.get(params.id)
        if (!clinicaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Clinica con id " + params.id
            redirect(action: "list")
            return
        }
        [clinicaInstance: clinicaInstance]
    } //show

    def delete() {
        def clinicaInstance = Clinica.get(params.id)
        if (!clinicaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Clinica con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            clinicaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Clinica " + clinicaInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Clinica " + (clinicaInstance.id ? clinicaInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

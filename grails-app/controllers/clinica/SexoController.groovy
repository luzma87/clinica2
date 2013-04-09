package clinica



import org.springframework.dao.DataIntegrityViolationException

class SexoController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [sexoInstanceList: Sexo.list(params), params: params]
    } //list

    def form_ajax() {
        def sexoInstance = new Sexo(params)
        if (params.id) {
            sexoInstance = Sexo.get(params.id)
            if (!sexoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Sexo con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [sexoInstance: sexoInstance]
    } //form_ajax

    def save() {
        def sexoInstance
        if (params.id) {
            sexoInstance = Sexo.get(params.id)
            if (!sexoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Sexo con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            sexoInstance.properties = params
        }//es edit
        else {
            sexoInstance = new Sexo(params)
        } //es create
        if (!sexoInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Sexo " + (sexoInstance.id ? sexoInstance.id : "") + "</h4>"
            str += renderErrors(bean: sexoInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Sexo " + sexoInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Sexo " + sexoInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def sexoInstance = Sexo.get(params.id)
        if (!sexoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Sexo con id " + params.id
            redirect(action: "list")
            return
        }
        [sexoInstance: sexoInstance]
    } //show

    def delete() {
        def sexoInstance = Sexo.get(params.id)
        if (!sexoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Sexo con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            sexoInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Sexo " + sexoInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Sexo " + (sexoInstance.id ? sexoInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

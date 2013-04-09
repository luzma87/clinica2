package clinica



import org.springframework.dao.DataIntegrityViolationException

class AlergiaController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [alergiaInstanceList: Alergia.list(params), params: params]
    } //list

    def form_ajax() {
        def alergiaInstance = new Alergia(params)
        if (params.id) {
            alergiaInstance = Alergia.get(params.id)
            if (!alergiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Alergia con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [alergiaInstance: alergiaInstance]
    } //form_ajax

    def save() {
        def alergiaInstance
        if (params.id) {
            alergiaInstance = Alergia.get(params.id)
            if (!alergiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Alergia con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            alergiaInstance.properties = params
        }//es edit
        else {
            alergiaInstance = new Alergia(params)
        } //es create
        if (!alergiaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Alergia " + (alergiaInstance.id ? alergiaInstance.id : "") + "</h4>"
            str += renderErrors(bean: alergiaInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Alergia " + alergiaInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Alergia " + alergiaInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def alergiaInstance = Alergia.get(params.id)
        if (!alergiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Alergia con id " + params.id
            redirect(action: "list")
            return
        }
        [alergiaInstance: alergiaInstance]
    } //show

    def delete() {
        def alergiaInstance = Alergia.get(params.id)
        if (!alergiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Alergia con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            alergiaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Alergia " + alergiaInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Alergia " + (alergiaInstance.id ? alergiaInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

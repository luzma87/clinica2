package clinica



import org.springframework.dao.DataIntegrityViolationException

class TipoCirugiaController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [tipoCirugiaInstanceList: TipoCirugia.list(params), params: params]
    } //list

    def form_ajax() {
        def tipoCirugiaInstance = new TipoCirugia(params)
        if (params.id) {
            tipoCirugiaInstance = TipoCirugia.get(params.id)
            if (!tipoCirugiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Tipo Cirugia con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [tipoCirugiaInstance: tipoCirugiaInstance]
    } //form_ajax

    def save() {
        def tipoCirugiaInstance
        if (params.id) {
            tipoCirugiaInstance = TipoCirugia.get(params.id)
            if (!tipoCirugiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Tipo Cirugia con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            tipoCirugiaInstance.properties = params
        }//es edit
        else {
            tipoCirugiaInstance = new TipoCirugia(params)
        } //es create
        if (!tipoCirugiaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Tipo Cirugia " + (tipoCirugiaInstance.id ? tipoCirugiaInstance.id : "") + "</h4>"
            str += renderErrors(bean: tipoCirugiaInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Tipo Cirugia " + tipoCirugiaInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Tipo Cirugia " + tipoCirugiaInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def tipoCirugiaInstance = TipoCirugia.get(params.id)
        if (!tipoCirugiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Tipo Cirugia con id " + params.id
            redirect(action: "list")
            return
        }
        [tipoCirugiaInstance: tipoCirugiaInstance]
    } //show

    def delete() {
        def tipoCirugiaInstance = TipoCirugia.get(params.id)
        if (!tipoCirugiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Tipo Cirugia con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            tipoCirugiaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Tipo Cirugia " + tipoCirugiaInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Tipo Cirugia " + (tipoCirugiaInstance.id ? tipoCirugiaInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

package clinica

import org.springframework.dao.DataIntegrityViolationException

class GrupoExamenController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [grupoExamenInstanceList: GrupoExamen.list(params), params: params]
    } //list

    def form_ajax() {
        def grupoExamenInstance = new GrupoExamen(params)
        if (params.id) {
            grupoExamenInstance = GrupoExamen.get(params.id)
            if (!grupoExamenInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Grupo Examen con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [grupoExamenInstance: grupoExamenInstance]
    } //form_ajax

    def save() {
        def grupoExamenInstance
        if (params.id) {
            grupoExamenInstance = GrupoExamen.get(params.id)
            if (!grupoExamenInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Grupo Examen con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            grupoExamenInstance.properties = params
        }//es edit
        else {
            grupoExamenInstance = new GrupoExamen(params)
        } //es create
        if (!grupoExamenInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Grupo Examen " + (grupoExamenInstance.id ? grupoExamenInstance.nombre : "") + "</h4>"
            str += renderErrors(bean: grupoExamenInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Grupo Examen " + grupoExamenInstance.nombre
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Grupo Examen " + grupoExamenInstance.nombre
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def grupoExamenInstance = GrupoExamen.get(params.id)
        if (!grupoExamenInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Grupo Examen con id " + params.id
            redirect(action: "list")
            return
        }
        [grupoExamenInstance: grupoExamenInstance]
    } //show

    def delete() {
        def grupoExamenInstance = GrupoExamen.get(params.id)
        if (!grupoExamenInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Grupo Examen con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            grupoExamenInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Grupo Examen " + grupoExamenInstance.nombre
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Grupo Examen " + (grupoExamenInstance.id ? grupoExamenInstance.nombre : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

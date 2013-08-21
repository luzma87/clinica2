package clinica

import clinica.seguridad.Usuario
import groovy.json.JsonBuilder
import org.springframework.dao.DataIntegrityViolationException

class ExamenController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        if (!params.sort) {
            params.sort = "grupoExamen"
        }
        return [examenInstanceList: Examen.list(params), params: params]
    } //list

    def form_ajax() {
        def examenInstance = new Examen(params)
        if (params.id) {
            examenInstance = Examen.get(params.id)
            if (!examenInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Examen con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit

        def grupos = "["
        GrupoExamen.list([sort: 'nombre']).each { grupo ->
            grupos += "'${grupo.nombre}',"
        }
        grupos = grupos[0..grupos.size() - 2]
        grupos += "]"
        return [examenInstance: examenInstance, grupos: grupos]
    } //form_ajax

    def save() {
        def grupo = GrupoExamen.findOrSaveByNombre(params.grupoExamen.trim())
        params.grupoExamen = grupo
        def examenInstance
        if (params.id) {
            examenInstance = Examen.get(params.id)
            if (!examenInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Examen con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            examenInstance.properties = params
        }//es edit
        else {
            examenInstance = new Examen(params)
        } //es create

        if (!examenInstance.save(flush: true)) {
            println examenInstance.errors
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Examen " + (examenInstance.id ? examenInstance.nombre : "") + "</h4>"
            str += renderErrors(bean: examenInstance)
            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Examen " + examenInstance.nombre
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Examen " + examenInstance.nombre
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def examenInstance = Examen.get(params.id)
        if (!examenInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Examen con id " + params.id
            redirect(action: "list")
            return
        }
        [examenInstance: examenInstance]
    } //show

    def delete() {
        def examenInstance = Examen.get(params.id)
        if (!examenInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Examen con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            examenInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Examen " + examenInstance.nombre
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Examen " + (examenInstance.id ? examenInstance.nombre : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

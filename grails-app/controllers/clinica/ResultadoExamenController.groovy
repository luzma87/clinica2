package clinica

import clinica.seguridad.Usuario
import org.springframework.dao.DataIntegrityViolationException

class ResultadoExamenController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        def paciente = Paciente.get(params.id)
        return [resultadoExamenInstanceList: ResultadoExamen.findAllByPaciente(paciente, params), params: params, paciente: paciente]
    } //list

    def examenesGrupo() {
        def grupo = GrupoExamen.get(params.id)
        def examenes = Examen.findAllByGrupoExamen(grupo)
        /*
         <g:select id="examen" name="examen.id" value="${resultadoExamenInstance?.examen?.id}"
                      from="${clinica.Examen.findAllByGrupoExamen(clinica.GrupoExamen.list([sort: 'nombre'])[0])}"
                      optionKey="id" class="many-to-one required"
                      optionValue="nombre"/>
         */
        def sel = elm.select(id: "examen", name: "examen.id", from: examenes, optionKey: "id", optionValue: "nombre",
                "class": "many-to-one required", optionClass: { it.valorInicial + ' - ' + it.valorFinal })

        def js = "<script type='text/javascript'>"
        js += '$("#examen").change(function () {'
        js += 'updateValorNormal();'
        js += '});'
        js += "</script>"

        render sel + js
    }

    def form_ajax() {
        def paciente = Paciente.get(params.paciente)
        def resultadoExamenInstance = new ResultadoExamen(params)
        if (params.id) {
            resultadoExamenInstance = ResultadoExamen.get(params.id)
            if (!resultadoExamenInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Resultado Examen con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        resultadoExamenInstance.paciente = paciente
        return [resultadoExamenInstance: resultadoExamenInstance]
    } //form_ajax

    def save() {
        def usu = Usuario.get(session.user.id)
        params.usuario = usu
        if (params.fecha) {
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }
        def resultadoExamenInstance
        if (params.id) {
            resultadoExamenInstance = ResultadoExamen.get(params.id)
            if (!resultadoExamenInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Resultado Examen con id " + params.id
                redirect(action: 'list', id: resultadoExamenInstance.pacienteId)
                return
            }//no existe el objeto
            resultadoExamenInstance.properties = params
        }//es edit
        else {
            resultadoExamenInstance = new ResultadoExamen(params)
        } //es create
        if (!resultadoExamenInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Resultado Examen " + (resultadoExamenInstance.id ? resultadoExamenInstance.id : "") + "</h4>"
            str += g.renderErrors(bean: resultadoExamenInstance)
            flash.message = str
            redirect(action: 'list', id: resultadoExamenInstance.pacienteId)
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Resultado Examen " + resultadoExamenInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Resultado Examen " + resultadoExamenInstance.id
        }
        redirect(action: 'list', id: resultadoExamenInstance.pacienteId)
    } //save

    def show_ajax() {
        def resultadoExamenInstance = ResultadoExamen.get(params.id)
        if (!resultadoExamenInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Resultado Examen con id " + params.id
            redirect(action: "list")
            return
        }
        [resultadoExamenInstance: resultadoExamenInstance]
    } //show

    def delete() {
        def resultadoExamenInstance = ResultadoExamen.get(params.id)
        def paciente = resultadoExamenInstance.pacienteId
        if (!resultadoExamenInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Resultado Examen con id " + params.id
            redirect(action: "list", id: paciente)
            return
        }

        try {
            resultadoExamenInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Resultado Examen " + resultadoExamenInstance.id
            redirect(action: "list", id: paciente)
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Resultado Examen " + (resultadoExamenInstance.id ? resultadoExamenInstance.id : "")
            redirect(action: "list", id: paciente)
        }
    } //delete
} //fin controller

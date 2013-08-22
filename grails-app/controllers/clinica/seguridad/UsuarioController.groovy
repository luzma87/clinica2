package clinica.seguridad

import clinica.Examen
import clinica.Item
import clinica.PacienteUsuario
import clinica.Pago
import clinica.ResultadoExamen
import org.springframework.dao.DataIntegrityViolationException

class UsuarioController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [usuarioInstanceList: Usuario.list(params), params: params]
    } //list

    def checkUser_ajax() {
        params.usuario = params.usuario.toString().trim()
        if (params.id) {
            def user = Usuario.get(params.id)
            if (user.usuario == params.usuario) {
                render true
                return
            } else {
                render Usuario.countByUsuario(params.usuario) == 0
                return
            }
        } else {
            render Usuario.countByUsuario(params.usuario) == 0
            return
        }
    }

    def checkMail_ajax() {
        params.email = params.email.toString().trim()
        if (params.id) {
            def user = Usuario.get(params.id)
            if (user.email == params.email) {
                render true
                return
            } else {
                render Usuario.countByEmail(params.email) == 0
                return
            }
        } else {
            render Usuario.countByEmail(params.email) == 0
            return
        }
    }

    def checkPassAct_ajax() {
        params.passwordAct = params.passwordAct.toString().trim()
        if (params.id) {
            def user = Usuario.get(params.id)
            if (user.password == params.passwordAct.toString().trim().encodeAsMD5()) {
                render true
                return
            }
        }
        render false
    }

    def pass_ajax() {
        def usuarioInstance
        if (params.id) {
            usuarioInstance = Usuario.get(params.id)
            if (!usuarioInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Usuario con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        else {
            flash.clase = "alert-error"
            flash.message = "No se encontró Usuario con id " + params.id
            redirect(action: "list")
            return
        }
        return [usuarioInstance: usuarioInstance]
    }

    def form_ajax() {
        def usuarioInstance = new Usuario(params)
        if (params.id) {
            usuarioInstance = Usuario.get(params.id)
            if (!usuarioInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Usuario con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [usuarioInstance: usuarioInstance]
    } //form_ajax

    def save() {
        if (params.password) {
            params.password = params.password.toString().encodeAsMD5()
        }

        def usuarioInstance
        if (params.id) {
            usuarioInstance = Usuario.get(params.id)
            if (!usuarioInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Usuario con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            usuarioInstance.properties = params
        }//es edit
        else {
            usuarioInstance = new Usuario(params)
        } //es create
        if (!usuarioInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Usuario " + (usuarioInstance.id ? usuarioInstance.usuario : "") + "</h4>"
            str += renderErrors(bean: usuarioInstance)

            flash.message = str
            redirect(action: 'list')
            return
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Usuario " + usuarioInstance.usuario
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Usuario " + usuarioInstance.usuario
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def usuarioInstance = Usuario.get(params.id)
        if (!usuarioInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Usuario con id " + params.id
            redirect(action: "list")
            return
        }
        [usuarioInstance: usuarioInstance]
    } //show

    def delete() {
        def usuarioInstance = Usuario.get(params.id)

        def usuarios = Usuario.count()
        if (usuarios == 1) {
            flash.clase = "alert-error"
            flash.message = "No se puede eliminar el único usuario existente. Cree uno nuevo para eliminar a " + usuarioInstance.usuario + "."
            redirect(action: "list")
            return
        }

        def pacientes = PacienteUsuario.countByUsuario(usuarioInstance)
        def items = Item.findAllByUsuario(usuarioInstance)
        def controles = items.count { it.tipoItem.codigo == "O" }
        def cirugias = items.count { it.tipoItem.codigo == "I" }
        def examenes = ResultadoExamen.countByUsuario(usuarioInstance)
        def pagos = Pago.countByUsuario(usuarioInstance)

//        println pacientes
//        println items
//        println controles
//        println cirugias
//        println examenes
//        println pagos

        if (!usuarioInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Usuario con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            usuarioInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Usuario " + usuarioInstance.usuario
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Usuario " + (usuarioInstance.id ? usuarioInstance.usuario : "") + " pues tiene: "
            def list = "<ul>"
            list += pacientes > 0 ? "<li>${pacientes} paciente${pacientes == 1 ? '' : 's'}</li>" : ""
            list += controles > 0 ? "<li>${controles} control${controles == 1 ? '' : 'es'}</li>" : ""
            list += cirugias > 0 ? "<li>${cirugias} cirugía${cirugias == 1 ? '' : 's'}</li>" : ""
            list += examenes > 0 ? "<li>${examenes} examen${examenes == 1 ? '' : 'es'}</li>" : ""
            list += pagos > 0 ? "<li>${pagos} pago${pagos == 1 ? '' : 's'}</li>" : ""
            list += "</ul>"
            flash.message += list
            redirect(action: "list")
        }
    } //delete
} //fin controller

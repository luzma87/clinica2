package clinica.seguridad



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
            flash.message = "No se pudo eliminar Usuario " + (usuarioInstance.id ? usuarioInstance.usuario : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller

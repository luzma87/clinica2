package clinica.seguridad

/**
 * Created with IntelliJ IDEA.
 * User: luz
 * Date: 3/13/13
 * Time: 12:49 PM
 * To change this template use File | Settings | File Templates.
 */
class Shield {
    def beforeInterceptor = [action: this.&auth, except: 'login']
    /**
     * Verifica si se ha iniciado una sesión
     * Verifica si el usuario actual tiene los permisos para ejecutar una acción
     */
    def auth() {
//        return true
//        println "an " + actionName + " cn " + controllerName + "  "

//        println session
        session.an = actionName
        session.cn = controllerName
        session.pr = params
//        return true
        /** **************************************************************************/
        if (!session.user) {
            //            println "1"
            redirect(controller: 'login', action: 'login')
//            session.finalize()
            return false
        } else {
            return true
        }
        /*************************************************************************** */
    }

    boolean isAllowed() {

//        try {
//            if (session.permisos[actionName] == controllerName)
//                return true
//        } catch (e) {
//            println "Shield execption e: " + e
//            return true
//        }
//        return true
        return true
    }
}


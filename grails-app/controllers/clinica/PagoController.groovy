package clinica

import clinica.seguridad.Usuario
import org.springframework.dao.DataIntegrityViolationException

class PagoController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        return [pagoInstanceList: Pago.list(params), params: params]
    } //list

    def form_ajax() {
        def pagoInstance = new Pago(params)
        if (params.id) {
            pagoInstance = Pago.get(params.id)
            if (!pagoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Pago con id " + params.id
                redirect(controller: 'cuenta', action: "list")
                return
            } //no existe el objeto
        } //es edit
        return [pagoInstance: pagoInstance]
    } //form_ajax

    def save() {
        def usu = Usuario.get(session.user.id)
        params.usuario = usu

        if (params.fecha) {
            params.fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        }

        def pagoInstance
        if (params.id) {
            pagoInstance = Pago.get(params.id)
            if (!pagoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Pago con id " + params.id
                redirect(controller: 'cuenta', action: 'list')
                return
            }//no existe el objeto
            pagoInstance.properties = params
        }//es edit
        else {
            pagoInstance = new Pago(params)
        } //es create
        if (!pagoInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Pago " + (pagoInstance.id ? pagoInstance.id : "") + "</h4>"
            str += renderErrors(bean: pagoInstance)
            flash.message = str
            redirect(controller: 'cuenta', action: 'list')
            return
        }

        if (params.tipo == "C") {
            def tot = pagoInstance.item.valor
            def pagos = Pago.findAllByItemAndTipo(pagoInstance.item, 'C')
            def val = pagos.sum { it.valor } ?: 0.00
            def saldo = tot - val
            if (saldo == 0) {
                def item = pagoInstance.item
                item.cobrado = true
                if (!item.save(flush: true)) {
                    println "ERROR 1: " + item.errors
                }
            }
        } else if (params.tipo == "P") {
            def tot = pagoInstance.item.costo
            def pagos = Pago.findAllByItemAndTipo(pagoInstance.item, 'P')
            def val = pagos.sum { it.valor } ?: 0.00
            def saldo = tot - val
            if (saldo == 0) {
                def item = pagoInstance.item
                item.pagado = true
                if (!item.save(flush: true)) {
                    println "ERROR 2: " + item.errors
                }
            }
        }

        if (params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Pago " + pagoInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Pago " + pagoInstance.id
        }
        redirect(controller: 'cuenta', action: 'list')
    } //save

    def show_ajax() {
        def pagoInstance = Pago.get(params.id)
        if (!pagoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Pago con id " + params.id
            redirect(controller: 'cuenta', action: "list")
            return
        }
        [pagoInstance: pagoInstance]
    } //show

    def delete() {
        def pagoInstance = Pago.get(params.id)
        if (!pagoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Pago con id " + params.id
            redirect(controller: 'cuenta', action: "list")
            return
        }

        try {
            pagoInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Pago " + pagoInstance.id
            redirect(controller: 'cuenta', action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Pago " + (pagoInstance.id ? pagoInstance.id : "")
            redirect(controller: 'cuenta', action: "list")
        }
    } //delete
} //fin controller

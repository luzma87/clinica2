package clinica

import clinica.seguridad.Usuario
import groovy.io.FileType
import groovy.json.JsonBuilder
import org.imgscalr.Scalr
import org.springframework.dao.DataIntegrityViolationException

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

class CirugiaController extends clinica.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def horaService

    def index() {
        redirect(action: "list", params: params)
    } //index

    def delPic_ajax() {
        def cirugia = Item.get(params.id)
        return [cirugia: cirugia]
    }

    def delPic() {
        def cirugia = Item.get(params.id)
        def file = params.file
        def tipo = params.tipo
        def paciente = cirugia.paciente
        def nombreCarpeta = paciente.apellidos + " " + paciente.nombres + "/cirugia" + cirugia.id
        nombreCarpeta = nombreCarpeta.replaceAll(" ", "_")
        def path = servletContext.getRealPath("/") + "imgs/"  //web-app/imgs
        path = path + nombreCarpeta + "/" + tipo + "/"
        def dir = new File(path)
        if (dir.exists()) {
            dir.eachFile(FileType.FILES) { f ->
                if (f.exists()) {
                    def nombre = f.getName()
                    if (nombre == file) {
                        f.delete()
                    }
                }
            }
        }
        render "OK"
    }

    def list() {
        def paciente = Paciente.get(params.id)
        return [cirugiaInstanceList: Item.findAllByPacienteAndTipoItem(paciente, TipoItem.findByCodigo("I"), params), params: params, paciente: paciente]
    } //list

    def listAll() {
        if (!params.sort) {
            params.sort = "fecha"
        }
        if (!params.order) {
            params.order = "asc"
        }
        if (!params.old) {
            params.old = '0'
        }
        if (!params.today) {
            params.today = '1'
        }
        if (!params.future) {
            params.future = '1'
        }

        if (params.old == "0" && params.today == "0" && params.future == "0") {
            params.today = "1"
        }

        def usu = Usuario.get(session.user.id)
        def hoy1 = new Date()
        hoy1.hours = 0
        hoy1.minutes = 0
        hoy1.seconds = 0
        def hoy2 = new Date()
        hoy2.hours = 23
        hoy2.minutes = 59
        hoy2.seconds = 59

        def c = Item.createCriteria()
        def lista = c.list(params) {
            eq("usuario", usu)
            eq("tipoItem", TipoItem.findByCodigo("I"))
            or {
                if (params.today == '1') {
                    between("fecha", hoy1, hoy2)
                }
                if (params.future == '1') {
                    gt("fecha", hoy2)
                }
                if (params.old == '1') {
                    lt("fecha", hoy1)
                }
            }
        }
//        return [cirugiaInstanceList: Cirugia.findAllByUsuario(usu, params), params: params]
        return [cirugiaInstanceList: lista, params: params]
    }

    def findPaciente_ajax() {
        def pacientes = Paciente.findAllByCedula(params.ci.trim())
        if (pacientes.size() == 0) {
            render "NO"
        } else if (pacientes.size() == 1) {
            render "OK_" + pacientes[0].id + "_" + pacientes[0].nombres + " " + pacientes[0].apellidos
        } else {
            render "NO"
        }
    }

    def form_ajax() {
        def paciente = Paciente.get(params.paciente)
        def cirugiaInstance = new Item(params)
        cirugiaInstance.tipoItem = TipoItem.findByCodigo("I")
        cirugiaInstance.paciente = paciente
        if (params.id) {
            cirugiaInstance = Item.get(params.id)
            if (!cirugiaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Cirugía con id " + params.id
                redirect(action: "list")
                return
            } //no existe el objeto
        } //es edit
        if (params.date) {
            cirugiaInstance.fecha = new Date().parse("dd-MM-yyyy", params.date)
        }
        def clinicas = "["
        Clinica.list([sort: 'nombre']).each { clinica ->
            clinicas += "'${clinica.nombre}',"
        }
        if (clinicas != "[")
            clinicas = clinicas[0..clinicas.size() - 2]
        clinicas += "]"
        def cirugias = "["
        TipoCirugia.list([sort: 'nombre']).each { tipoCirugia ->
            cirugias += "'${tipoCirugia.nombre}',"
        }
        if (cirugias != "[")
            cirugias = cirugias[0..cirugias.size() - 2]
        cirugias += "]"

        def cer = []
        TipoCirugia.list([sort: 'nombre']).each { tipoCirugia ->
            cer.add([
                    label: tipoCirugia.nombre,
                    valor: tipoCirugia.valor,
                    costo: tipoCirugia.costo,
                    duracionH: tipoCirugia.duracionHoras,
                    duracionM: tipoCirugia.duracionMinutos
            ])
        }
        def json = new JsonBuilder(cer)

        return [cirugiaInstance: cirugiaInstance, clinicas: clinicas, cirugias: json]
    } //form_ajax

    def upload(f, path) {
        path += "\\"
//        println path
        def acceptedExt = ["jpg", "jpeg", "png"]
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }
            if (acceptedExt.contains(ext)) {
                fileName = /*"cirugia_" + cirugiaInstance.id + "_" +  tipo + "_" +*/ (new Date().format("dd-MM-yyyy_HH-mm"))
                fileName = fileName + "." + ext
//                path += cirugiaInstance.id + "/"
                def pathFile = path + fileName
                def file = new File(pathFile)
                f.transferTo(file) // guarda el archivo subido al nuevo path
                BufferedImage thumbnail = Scalr.resize(ImageIO.read(file), 800);
                File thumbFile = new File(path + fileName);
                ImageIO.write(thumbnail, "PNG", thumbFile);

                return [estado: "success", path: fileName]
            } else {
//                flash.message = "Seleccione una foto para subir (extenciones aceptadas: " + acceptedExt + ")"
//                redirect(action: 'selectFile')
                return [estado: "error", tipo: "file not supported", mensaje: "Seleccione una foto para subir (extenciones aceptadas: " + acceptedExt + ")"]
            }
        } else {
            return [estado: "error", tipo: "no file", mensaje: "Seleccione una foto para subir (extenciones aceptadas: " + acceptedExt + ")"]
//            flash.message = "Seleccione una foto para subir (extenciones aceptadas: " + acceptedExt + ")"
//            redirect(action: 'selectFile')
//            println "NO FILE"
        }
    }

    def save() {
//        println params
        def clinica = Clinica.findOrSaveByNombre(params.clinica.trim())
        params.clinica = clinica
        def usu = clinica.seguridad.Usuario.get(session.user.id)
        params.usuario = usu
        if (params.fecha) {
            params.fecha = new Date().parse("dd-MM-yyyy HH:mm", (params.fecha + " " + params.hora + ":" + params.min))
        }
        if (params.fechaPago) {
            params.fechaPago = new Date().parse("dd-MM-yyyy", params.fechaPago)
        }
        if (params.fechaCobro) {
            params.fechaCobro = new Date().parse("dd-MM-yyyy", params.fechaCobro)
        }
        def conflictos = horaService.verificarHorario(session.user, params.fecha, params.duracionHoras.toInteger(), params.duracionMinutos.toInteger())
//        println conflictos
        if (conflictos.control.size() > 0 || conflictos.cirugia.size() > 0) {
            flash.clase = "alert-error"
            def str = "<h4>Se encontraron los siguientes conflictos</h4>"
            str += "<ul>"
            conflictos.control.each { co ->
                str += "<li>"
                str += "Control con " + co.paciente.nombres + " " + co.paciente.apellidos + " el " + co.fecha.format("dd-MM-yyyy HH:mm") + " (" + (co.duracionHoras.toString().padLeft(2, '0')) + ":" + (co.duracionMinutos.toString().padLeft(2, '0')) + ")"
                str += "</li>"
            }
            conflictos.cirugia.each { co ->
                str += "<li>"
                str += "Cirugía a " + co.paciente.nombres + " " + co.paciente.apellidos + " el " + co.fecha.format("dd-MM-yyyy HH:mm") + " (" + (co.duracionHoras.toString().padLeft(2, '0')) + ":" + (co.duracionMinutos.toString().padLeft(2, '0')) + ")"
                str += "</li>"
            }
            str += "</ul>"
            flash.message = str
            if (params.tipo) {
                switch (params.tipo) {
                    case "calendar":
                        redirect(controller: "calendario", action: "index")
                        break;
                    case "all":
                        redirect(action: 'listAll')
                        break;
                    default:
                        redirect(action: 'listAll')
                }
            } else {
                redirect(action: 'list', id: paciente.id)
            }
        } else {
            def paciente = Paciente.get(params.paciente.id)
            params.paciente = paciente
            def cirugiaInstance

            def tipoCirugia = params.cirugia
            def tipo = TipoCirugia.findByNombre(tipoCirugia)
            if (!tipo) {
                tipo = new TipoCirugia(
                        nombre: tipoCirugia,
                        duracionHoras: params.duracionHoras,
                        duracionMinutos: params.duracionMinutos,
                        valor: params.valor,
                        costo: params.costo
                )
                if (!tipo.save(flush: true)) {
                    println "error al crear el tipo de cirugia " + tipo.errors
                }
            }
            params.tipoCirugia = tipo

            if (params.id) {
                cirugiaInstance = Item.get(params.id)
                if (!cirugiaInstance) {
                    flash.clase = "alert-error"
                    flash.message = "No se encontró Cirugía con id " + params.id
                    if (params.tipo) {
                        switch (params.tipo) {
                            case "calendar":
                                redirect(controller: "calendario", action: "index")
                                break;
                            case "all":
                                redirect(action: 'listAll')
                                break;
                            default:
                                redirect(action: 'listAll')
                        }
                    } else {
                        redirect(action: 'list', id: paciente.id)
                    }
                    return
                }//no existe el objeto
                cirugiaInstance.properties = params
            }//es edit
            else {
                cirugiaInstance = new Item(params)
                cirugiaInstance.tipoItem = TipoItem.findByCodigo("I")
            } //es create

            if (!cirugiaInstance.save(flush: true)) {
                flash.clase = "alert-error"
                def str = "<h4>No se pudo guardar Cirugía</h4>"
                str += renderErrors(bean: cirugiaInstance)
                flash.message = str
                println cirugiaInstance.errors
                if (params.tipo) {
                    switch (params.tipo) {
                        case "calendar":
                            redirect(controller: "calendario", action: "index")
                            break;
                        case "all":
                            redirect(action: 'listAll')
                            break;
                        default:
                            redirect(action: 'listAll')
                    }
                } else {
                    redirect(action: 'list', id: paciente.id)
                }
                return
            }

            //handle uploaded file
            def nombreCarpeta = paciente.apellidos + " " + paciente.nombres + "/cirugia" + cirugiaInstance.id
            nombreCarpeta = nombreCarpeta.replaceAll(" ", "_")
            def path = servletContext.getRealPath("/") + "imgs/"  //web-app/imgs
            def pathAntes = path + nombreCarpeta + "/antes/"
            def pathDespues = path + nombreCarpeta + "/despues/"

            new File(pathAntes).mkdirs()
            new File(pathDespues).mkdirs()
            def f = request.getFile('ffotoAntes')  //archivo = name del input type file
            if (f && !f.empty) {
                upload(f, pathAntes)
            }
            def f2 = request.getFile('ffotoDespues')  //archivo = name del input type file
            if (f2 && !f2.empty) {
                upload(f2, pathDespues)
            }
            //fin upload

            if (params.id) {
                flash.clase = "alert-success"
                flash.message = "Se ha actualizado correctamente Cirugía "
            } else {
                flash.clase = "alert-success"
                flash.message = "Se ha creado correctamente Cirugía "
            }
            if (params.tipo) {
                switch (params.tipo) {
                    case "calendar":
                        redirect(controller: "calendario", action: "index")
                        break;
                    case "all":
                        redirect(action: 'listAll')
                        break;
                    default:
                        redirect(action: 'listAll')
                }
            } else {
                redirect(action: 'list', id: paciente.id)
            }
        }
    } //save

    def show_ajax() {
        def cirugiaInstance = Item.get(params.id)
        if (!cirugiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Cirugía con id " + params.id
            redirect(action: "list")
            return
        }
        [cirugiaInstance: cirugiaInstance]
    } //show

    def delete() {
        def cirugiaInstance = Item.get(params.id)
        if (!cirugiaInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Cirugía con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            cirugiaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Cirugía "
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Cirugía "
            redirect(action: "list")
        }
    } //delete
} //fin controller

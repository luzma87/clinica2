package clinica

import clinica.seguridad.Usuario
import org.codehaus.groovy.grails.commons.DomainClassArtefactHandler
import org.springframework.beans.SimpleTypeConverter
import org.springframework.context.MessageSourceResolvable
import org.springframework.web.servlet.support.RequestContextUtils

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import groovy.io.FileType

class ElementosTagLib {

    static namespace = "elm"

    def tablaCuentas = { attrs ->
        def tipo = attrs.tipo
        def params = attrs.params
        def lbl = []
        if (!tipo) {
            tipo = "C"
        }
        if (tipo == "C") {
            lbl[0] = "Cobrar"
            lbl[1] = "Valor"
            lbl[2] = "Cobrado"
        } else {
            lbl[0] = "Pagar"
            lbl[1] = "Costo"
            lbl[2] = "Pagado"
        }

        if (!params.completos) params.completos = "1"
        if (!params.incompletos) params.incompletos = "1"

        if (!attrs.pagos) attrs.pagos = "1"

        def html = ""

//        html += '<h3>Cuentas por ' + lbl[0] + '</h3>'
        html += '<table class="table table-bordered table-striped table-condensed">'
        html += '<thead>'
        html += '<tr>'
        html += '<th>Tipo</th>'
        html += '<th>Paciente</th>'
        html += '<th>Clínica</th>'
        html += '<th>Fecha</th>'
        html += '<th>Concepto</th>'
        html += '<th>' + lbl[1] + '</th>'
        html += '<th>' + lbl[2] + '</th>'
        html += '<th>Saldo</th>'
        html += '<th>Fecha tope</th>'
        if (attrs.pagos == "1") {
            html += '<th>Pagos</th>'
        }
        html += '</tr>'
        html += '</thead>'
        html += '<tbody>'
        attrs.items.each { item ->

            def pagos = clinica.Pago.findAllByItemAndTipo(item, tipo)
            def val = pagos.sum { it.valor } ?: 0.00
            def saldo = (tipo == "C" ? item.valor : item.costo) - val

            if ((saldo.toDouble() == 0.toDouble() && params.completos == '1') || (saldo > 0 && params.incompletos == '1')) {
                html += '<tr class="fila ' + (saldo == 0 ? 'completo' : "incompleto") + ' " id="' + item.id + '" data-max="' + saldo + '" data-tipo="' + tipo + '">'
                html += '<td>'
                html += item.tipoItem.descripcion
                html += '</td>'
                html += '<td>'
                html += item.paciente.nombres + " " + item.paciente.apellidos
                html += '</td>'
                html += '<td>'
                html += item.clinica?.nombre ?: ""
                html += '</td>'
                html += '<td>'
                html += g.formatDate(date: item.fecha, format: "dd-MM-yyyy")
                html += '</td>'
                html += '<td>'
                html += item.tipoItem.codigo == 'I' ? item.tipoCirugia.nombre + " (" + item.razon + ")" : item.observaciones
                html += '</td>'
                html += '<td class="taRight">'
                html += g.formatNumber(number: tipo == 'C' ? item.valor : item.costo, maxFractionDigits: "2", minFractionDigits: "2")
                html += '</td>'
                html += '<td class="taRight">'
                html += g.formatNumber(number: val, minFractionDigits: "2", maxFractionDigits: "2")
                html += '</td>'
                html += '<td class="taRight">'
                html += g.formatNumber(number: saldo, minFractionDigits: "2", maxFractionDigits: "2")
                html += '</td>'
                html += '<td>'
                html += g.formatDate(date: (tipo == "C" ? item.fechaCobro : item.fechaPago), format: "dd-MM-yyyy")
                html += '</td>'
                if (attrs.pagos == "1") {
                    html += '<td>'
                    html += pagos.size()
                    if (pagos.size() > 0) {
                        html += ' <a href="#" class="togglePagos btn btn-mini">'
                        html += '<i class="icon-plus-sign"></i>'
                        html += '</a>'
                    }
                    if (pagos.size() > 0) {
                        html += '<tr class="hide">'
                        html += '<td colspan="10" class="taCenter">'
                        html += '<table class="small table table-bordered table-striped table-condensed table-hover">'
                        html += '<thead>'
                        html += '<tr>'
                        html += '<th>Fecha</th>'
                        html += '<th>Valor</th>'
                        html += '</tr>'
                        html += '</thead>'
                        html += '<tbody>'
                        pagos.each { pago ->
                            html += '<tr>'
                            html += '<td>'
                            html += g.formatDate(date: pago.fecha, format: "dd-MM-yyyy")
                            html += '</td>'
                            html += '<td class="taRight">'
                            html += g.formatNumber(number: pago.valor, maxFractionDigits: "2", minFractionDigits: "2")
                            html += '</td>'
                            html += '</tr>'
                        }
                        html += '</tbody>'
                        html += '</table>'
                        html += '</td>'
                    }
                    html += '</tr>'
                }
                html += '</td>'
                html += '</tr>'
            }
        }
        html += '</tbody>'
        html += '</table>'

        out << html
    }

    def barraTiempo = { attrs ->
        def html = ""
        html += '<div class="btn-group" role="navigation" data-toggle="buttons-checkbox">'
        html += '<a href="#" class="btn btn-small btn-info toggle ' + (attrs.old == '1' ? 'active' : '') + '" id="old">'
        html += '<i class="icon-arrow-left"></i> '
        html += 'Anteriores'
        html += '</a>'
        html += '<a href="#" class="btn btn-small btn-info toggle ' + (attrs.today == '1' ? 'active' : '') + '" id="today">'
        html += '<i class="icon-arrow-down"></i> '
        html += 'Hoy'
        html += '</a>'
        html += '<a href="#" class="btn btn-small btn-info toggle ' + (attrs.future == '1' ? 'active' : '') + '" id="future">'
        html += '<i class="icon-arrow-right"></i> '
        html += 'Futuros'
        html += '</a>'
        html += '</div>'

        out << html
    }

    def mostrarImagen = { attrs ->
//        println attrs
        def path = attrs.url

        def pathImgs = servletContext.getRealPath("/") + "imgs/"  //web-app/imgs

        def parts = path.split("\\?")
        path = parts[0]
        def w, h

        parts = path.split("/")
        def fileName = parts.last()
        def pathFolder = parts[3] + "/" + parts[4] + "/" + parts[5] + "/"

        parts = fileName.split("\\.")
        def overlayFileName = parts[0] + "_overlay.png"

        def img = ImageIO.read(new File(pathImgs + pathFolder + fileName));
        def image = new File(pathImgs + pathFolder + fileName)
        def overlay = new File(pathImgs + pathFolder + overlayFileName)
        def ow = img.getWidth()
        def oh = img.getHeight()

        w = ow
        h = oh

//        println attrs
//        println "w:" + w + "  h:" + h + "   ow:" + ow + "    oh:" + oh

        if (attrs.width && attrs.height) {
//            println "1"
            w = attrs.width.toDouble()
            h = attrs.height.toDouble()
        } else if (attrs.width) {
//            println "2"
            w = attrs.width.toDouble()
            h = ((w * oh) / ow) + 5
        } else if (attrs.height) {
//            println "3"
            h = attrs.height.toDouble()
            w = (ow * h) / oh
        }
//        println "w:" + w + "  h:" + h + "   ow:" + ow + "    oh:" + oh

        fileName = resource(dir: 'imgs/' + pathFolder, file: fileName)
        overlayFileName = resource(dir: 'imgs/' + pathFolder, file: overlayFileName)
        def html = ""
        if (image.exists()) {
            html = "<div style='position: relative; width:${w}px; height:${h}px;'>"
            html += "<img width='${w}' src='${fileName}' style='position: absolute; top:0; left:0; z-index:1;' class='" + attrs["class"] + "' " + attrs.extra + " />"
            if (overlay.exists()) {
                html += "<img width='${w}' src='${overlayFileName}' style='position: absolute; top:0; left:0; z-index:2;' class='" + attrs["class"] + "' " + attrs.extra + " />"
            }
        }
        html += "</div>"

//        println html

        out << html
    }

    def imagenCirugia = { attrs ->
        def usu = Usuario.get(session.user.id)
        def cirugia = attrs.cirugia
        def tipo = attrs.tipo.toLowerCase()
//
        def nombreCarpeta = (cirugia.paciente.apellidos + " " + cirugia.paciente.nombres).replaceAll(' ', '_') + "/cirugia" + cirugia.id + "/" + tipo + "/"
        def group = ""
        if ((attrs.group && attrs.group == "true") || !attrs.group) {
            group = (cirugia.paciente.apellidos + " " + cirugia.paciente.nombres).replaceAll(' ', '_')
        }

        def path = servletContext.getRealPath("/") + "imgs/"  //web-app/imgs
        path += nombreCarpeta

        def w = 100
        if (attrs['class'] == "mini") {
            w = 50
        }

        def dir = new File(path)
        if (dir.exists()) {
            dir.eachFile(FileType.FILES) { f ->
                if (f.exists()) {
                    def file = f.getName()
                    if (!file.contains("overlay")) {
                        //def img = "<img src='" + resource(dir: 'imgs/' + nombreCarpeta, file: file) + "' class='thumb " + attrs["class"] + " ui-corner-all' data-file='" + file + "' data-tipo='" + tipo + "' />"

                        def img = mostrarImagen(url: resource(dir: 'imgs/' + nombreCarpeta, file: file), width: w, class: "thumb " + attrs["class"] + " ui-corner-all", extra: "data-file='${file}' data-tipo='${tipo}'")

                        if ((attrs.fancy && attrs.fancy == "true") || !attrs.fancy) {
//                            out << "<a href='" + resource(dir: 'imgs/' + nombreCarpeta, file: file) + "' class='fancybox' rel='" + group + "' title='" + tipo.capitalize() + "'>" + img + "</a>"

                            out << "<a href='" + createLink(controller: 'cirugia', action: 'mostrarFoto', params: [url: resource(dir: 'imgs/' + nombreCarpeta, file: file)]) + "' class='fancybox' rel='" + group + "' title='" + tipo.capitalize() + "'>" + img + "</a>"
                        } else {
                            out << img
                        }
                    }
                }
            }
        }
//        def file
//
//        switch (tipo) {
//            case "antes":
//            case "before":
//                file = cirugia.fotoAntes
//                break;
//            case "despues":
//            case "after":
//                file = cirugia.fotoDespues
//                break;
//        }
//
//        def group = ""
//        if ((attrs.group && attrs.group == "true") || !attrs.group) {
//            group = nombreCarpeta
//        }
//        def img = "<img src='" + resource(dir: 'imgs/' + nombreCarpeta, file: file) + "' class='thumb " + attrs["class"] + " ui-corner-all' />"
//        out << "<a href='" + resource(dir: 'imgs/' + nombreCarpeta, file: file) + "' class='fancybox' rel='" + group + "' title='" + tipo.capitalize() + "'>" + img + "</a>"
    }

    def edad = { attrs ->
        def str = ""
        def paciente = attrs.paciente

        Random rand = new Random()

        def id = attrs.id ?: attrs.name ?: "edad_" + rand.nextInt(1000 + 1)

//        def fn = paciente.fechaNacimiento.format("yyyy") + "," + (paciente.fechaNacimiento.format("MM").toInteger() - 1) + "," + paciente.fechaNacimiento.format("dd")
        def fn = paciente.fechaNacimiento.format("yyyy") + "," + paciente.fechaNacimiento.format("MM") + "," + paciente.fechaNacimiento.format("dd")
        str += '<span id="' + id + '" class="edad" data-nacimiento="' + fn + '"></span>'
        out << str
    }

    def datosPaciente = { attrs ->
        def str = ""
        def paciente = attrs.paciente
        str += '<div class="well">'
        str += '<div class="row">'
        str += '<div class="span1 lbl">Paciente</div>'
        str += '<div class="span3">' + paciente.apellidos + ' ' + paciente.nombres + '</div>'
        str += '<div class="span1 lbl">C&eacute;dula</div>'
        str += '<div class="span2">' + paciente.cedula + '</div>'
        str += '<div class="span1 lbl">Edad</div>'
        str += '<div class="span3">' + elm.edad(paciente: paciente) + '</div>'
        str += '</div>'
//        def fn = paciente.fechaNacimiento.format("yyyy") + "," + (paciente.fechaNacimiento.format("MM").toInteger() - 1) + "," + paciente.fechaNacimiento.format("dd")
//        str += '<div class="span3"><span class="edad" data-nacimiento="' + fn + '"></span></div>'

        if (attrs.cirugia) {
            def cirugia = attrs.cirugia
            str += '<div class="row" style="margin-top:10px;">'
            str += '<div class="span1 lbl">Fecha</div>'
            str += '<div class="span2">' + cirugia.fecha.format("dd-MM-yyyy HH:mm") + '</div>'
            str += '<div class="span1 lbl">Duración</div>'
            str += '<div class="span1">' + (cirugia.duracionHoras.toString().padLeft(2, '0') + ":" + cirugia.duracionMinutos.toString().padLeft(2, '0')) + '</div>'
            str += '<div class="span1 lbl">Clínica</div>'
            str += '<div class="span2">' + cirugia.clinica?.nombre + '</div>'
            str += '<div class="span1 lbl">Razón</div>'
            str += '<div class="span2">' + cirugia.razon + '</div>'
            str += '</div>'
        }

        str += '</div>'

        out << str
    }

    def datepicker = { attrs ->
        def str = ""
        def clase = attrs.remove("class")
        def name = attrs.remove("name")
        def id = attrs.id ? attrs.remove("id") : name
        if (id.contains(".")) {
            id = id.replaceAll("\\.", "_")
        }

        def value = attrs.remove("value")
        if (value.toString() == 'none') {
            value = null
        } else if (!value) {
            value = null
        }

        def format = attrs.format ? attrs.remove("format") : "dd-MM-yyyy"
        def formatJs = format
        formatJs = formatJs.replaceAll("M", "m")
        formatJs = formatJs.replaceAll("yyyy", "yy")

        str += "<input type='text' class='datepicker " + clase + "' name='" + name + "' id='" + id + "' value='" + g.formatDate(date: value, format: format) + "'"
        str += renderAttributes(attrs)
        str += "/>"

        def js = "<script type='text/javascript'>"
        js += '$(function() {'
        js += '$("#' + id + '").datepicker({'
        js += 'dateFormat: "' + formatJs + '",'
        js += 'changeMonth: true,'
        js += 'changeYear: true'
        if (attrs.onClose) {
            js += ','
            js += 'onClose: ' + attrs.onClose
        }
        if (attrs.yearRange) {
            js += ','
// println attrs.yearRange
            js += 'yearRange: "' + attrs.yearRange + '"'
        }
        if (attrs.minDate) {
            js += ","
            js += "minDate:" + attrs.minDate
        }
        if (attrs.maxDate) {
            js += ","
            js += "maxDate:" + attrs.maxDate
        }
// js += 'showOn : "both",'
// js += 'buttonImage : "' + resource(dir: 'images', file: 'calendar.png') + '",'
// js += 'buttonImageOnly : true'
        js += '});'
        js += '});'
        js += "</script>"

        out << str
        out << js
    }

    Closure select = { attrs ->
        if (!attrs.name) {
            throwTagError("Tag [select] is missing required attribute [name]")
        }
        if (!attrs.containsKey('from')) {
            throwTagError("Tag [select] is missing required attribute [from]")
        }
        def messageSource = grailsAttributes.getApplicationContext().getBean("messageSource")
        def locale = RequestContextUtils.getLocale(request)
        def writer = out
        def from = attrs.remove('from')
        def keys = attrs.remove('keys')
        def optionKey = attrs.remove('optionKey')
        def optionValue = attrs.remove('optionValue')
        def optionClass = attrs.remove('optionClass')
        def value = attrs.remove('value')
        if (value instanceof Collection && attrs.multiple == null) {
            attrs.multiple = 'multiple'
        }
        if (value instanceof CharSequence) {
            value = value.toString()
        }
        def valueMessagePrefix = attrs.remove('valueMessagePrefix')
        def classMessagePrefix = attrs.remove('classMessagePrefix')
        def noSelection = attrs.remove('noSelection')
        if (noSelection != null) {
            noSelection = noSelection.entrySet().iterator().next()
        }
        booleanToAttribute(attrs, 'disabled')
        booleanToAttribute(attrs, 'readonly')

        writer << "<select "
        // process remaining attributes
        outputAttributes(attrs, writer, true)

        writer << '>'
        writer.println()

        if (noSelection) {
            renderNoSelectionOptionImpl(writer, noSelection.key, noSelection.value, value)
            writer.println()
        }

        // create options from list
        if (from) {
            from.eachWithIndex { el, i ->
                def keyValue = null
                writer << '<option '
                if (keys) {
                    keyValue = keys[i]
                    writeValueAndCheckIfSelected(keyValue, value, writer)
                } else if (optionKey) {
                    def keyValueObject = null
                    if (optionKey instanceof Closure) {
                        keyValue = optionKey(el)
                    } else if (el != null && optionKey == 'id' && grailsApplication.getArtefact(DomainClassArtefactHandler.TYPE, el.getClass().name)) {
                        keyValue = el.ident()
                        keyValueObject = el
                    } else {
                        keyValue = el[optionKey]
                        keyValueObject = el
                    }
                    writeValueAndCheckIfSelected(keyValue, value, writer, keyValueObject)
                } else {
                    keyValue = el
                    writeValueAndCheckIfSelected(keyValue, value, writer)
                }

                /** **********************************************************************************************************************************************************/
                if (optionClass) {
                    if (optionClass instanceof Closure) {
                        writer << "class='" << optionClass(el).toString().encodeAsHTML() << "'"
                    } else {
                        writer << "class='" << el[optionClass].toString().encodeAsHTML() << "'"
                    }
                } else if (el instanceof MessageSourceResolvable) {
                    writer << "class='" << messageSource.getMessage(el, locale) << "'"
                } else if (classMessagePrefix) {
                    def message = messageSource.getMessage("${classMessagePrefix}.${keyValue}", null, null, locale)
                    if (message != null) {
                        writer << "class='" << message.encodeAsHTML() << "'"
                    } else if (keyValue && keys) {
                        def s = el.toString()
                        if (s) writer << "class='" << s.encodeAsHTML() << "'"
                    } else if (keyValue) {
                        writer << "class='" << keyValue.encodeAsHTML() << "'"
                    } else {
                        def s = el.toString()
                        if (s) writer << "class='" << s.encodeAsHTML() << "'"
                    }
                } else {
                    def s = el.toString()
                    if (s) writer << "class='" << s.encodeAsHTML() << "'"
                }
                /** **********************************************************************************************************************************************************/

                writer << '>'
                if (optionValue) {
                    if (optionValue instanceof Closure) {
                        writer << optionValue(el).toString().encodeAsHTML()
                    } else {
                        writer << el[optionValue].toString().encodeAsHTML()
                    }
                } else if (el instanceof MessageSourceResolvable) {
                    writer << messageSource.getMessage(el, locale)
                } else if (valueMessagePrefix) {
                    def message = messageSource.getMessage("${valueMessagePrefix}.${keyValue}", null, null, locale)
                    if (message != null) {
                        writer << message.encodeAsHTML()
                    } else if (keyValue && keys) {
                        def s = el.toString()
                        if (s) writer << s.encodeAsHTML()
                    } else if (keyValue) {
                        writer << keyValue.encodeAsHTML()
                    } else {
                        def s = el.toString()
                        if (s) writer << s.encodeAsHTML()
                    }
                } else {
                    def s = el.toString()
                    if (s) writer << s.encodeAsHTML()
                }
                writer << '</option>'
                writer.println()
            }
        }
        // close tag
        writer << '</select>'
    }

/**
 * renders attributes in HTML compliant fashion returning them in a string
 */
    String renderAttributes(attrs) {
        def ret = ""
        attrs.remove('tagName') // Just in case one is left
        attrs.each { k, v ->
            ret += k
            ret += '="'
            if (v) {
                ret += v.encodeAsHTML()
            } else {
                ret += ""
            }
            ret += '" '
        }
        return ret
    }

/**
 * Some attributes can be defined as Boolean values, but the html specification
 * mandates the attribute must have the same value as its name. For example,
 * disabled, readonly and checked.
 */
    private void booleanToAttribute(def attrs, String attrName) {
        def attrValue = attrs.remove(attrName)
        // If the value is the same as the name or if it is a boolean value,
        // reintroduce the attribute to the map according to the w3c rules, so it is output later
        if (Boolean.valueOf(attrValue) ||
                (attrValue instanceof String && attrValue?.equalsIgnoreCase(attrName))) {
            attrs.put(attrName, attrName)
        } else if (attrValue instanceof String && !attrValue?.equalsIgnoreCase('false')) {
            // If the value is not the string 'false', then we should just pass it on to
            // keep compatibility with existing code
            attrs.put(attrName, attrValue)
        }
    }

/**
 * Dump out attributes in HTML compliant fashion.
 */
    void outputAttributes(attrs, writer, boolean useNameAsIdIfIdDoesNotExist = false) {
        attrs.remove('tagName') // Just in case one is left
        attrs.each { k, v ->
            writer << k
            writer << '="'
            writer << v.encodeAsHTML()
            writer << '" '
        }
        if (useNameAsIdIfIdDoesNotExist) {
            outputNameAsIdIfIdDoesNotExist(attrs, writer)
        }
    }

    Closure renderNoSelectionOption = { noSelectionKey, noSelectionValue, value ->
        renderNoSelectionOptionImpl(out, noSelectionKey, noSelectionValue, value)
    }

    def renderNoSelectionOptionImpl(out, noSelectionKey, noSelectionValue, value) {
        // If a label for the '--Please choose--' first item is supplied, write it out
        out << "<option value=\"${(noSelectionKey == null ? '' : noSelectionKey)}\"${noSelectionKey == value ? ' selected="selected"' : ''}>${noSelectionValue.encodeAsHTML()}</option>"
    }

    private outputNameAsIdIfIdDoesNotExist(attrs, out) {
        if (!attrs.containsKey('id') && attrs.containsKey('name')) {
            out << 'id="'
            out << attrs.name?.encodeAsHTML()
            out << '" '
        }
    }


    private writeValueAndCheckIfSelected(keyValue, value, writer) {
        writeValueAndCheckIfSelected(keyValue, value, writer, null)
    }

    private writeValueAndCheckIfSelected(keyValue, value, writer, el) {

        boolean selected = false
        def keyClass = keyValue?.getClass()
        if (keyClass.isInstance(value)) {
            selected = (keyValue == value)
        } else if (value instanceof Collection) {
            // first try keyValue
            selected = value.contains(keyValue)
            if (!selected && el != null) {
                selected = value.contains(el)
            }
        }
        // GRAILS-3596: Make use of Groovy truth to handle GString <-> String
        // and other equivalent types (such as numbers, Integer <-> Long etc.).
        else if (keyValue == value) {
            selected = true
        } else if (keyClass && value != null) {
            try {
                def typeConverter = new SimpleTypeConverter()
                value = typeConverter.convertIfNecessary(value, keyClass)
                selected = (keyValue == value)
            }
            catch (e) {
                // ignore
            }
        }
        writer << "value=\"${keyValue}\" "
        if (selected) {
            writer << 'selected="selected" '
        }
    }

}

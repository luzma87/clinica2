package clinica

import clinica.seguridad.Usuario
import groovy.time.TimeCategory

class MenuTagLib {
    static namespace = "mn"

    def renderItem(item, tipo) {
        def str = "", clase = ""
        if (session.cn == item.controller && session.an == item.action) {
            clase = "active"
        }
        if (item.items) {
            clase += " dropdown"
        }
        str += "<li class='" + clase + "'>"
        if (item.items) {
            str += "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>"
            if (item.icon) {
                str += item.icon
                str += " "
            }
            str += item.label
            str += "<b class=\"caret\"></b></a>"
            str += '<ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">'
            item.items.each { t, i ->
                str += renderItem(i, t)
            }
            str += "</ul>"
        } else {
            str += "<a href='" + createLink(controller: item.controller, action: item.action, params: item.params) + "'>"
            if (item.icon) {
                str += item.icon
                str += " "
            }
            str += item.label
            str += "</a>"
        }
        str += "</li>"

        return str
    }

    def menu = { attrs ->

        def usuario = Usuario.get(attrs.user)

        def items = [
                home: [
                        controller: "inicio",
                        action: "index",
                        label: "Inicio",
                        icon: "<i class='icon-home'></i>"
                ],
                paciente: [
                        controller: "paciente",
                        action: "list",
                        label: "Pacientes",
                        icon: "<i class='icon-group'></i>"
                ],
                agenda: [
                        label: "Agenda",
                        icon: "<i class='icon-calendar'></i>",
                        items: [
                                calendario: [
                                        controller: "calendario",
                                        action: "index",
                                        label: "Calendario",
                                        icon: "<i class='icon-calendar'></i>"
                                ],
                                controles: [
                                        controller: "control",
                                        action: "listAll",
                                        label: "Controles",
                                        icon: "<i class='icon-stethoscope'></i>"
                                ],
                                cirugias: [
                                        controller: "cirugia",
                                        action: "listAll",
                                        label: "Cirug&iacute;as",
                                        icon: "<i class='icon-medkit'></i>"
                                ]
                        ]
                ],
                admin: [
                        label: "Administración",
                        icon: "<i class='icon-cog'></i>",
                        items: [
                                alergia: [
                                        controller: "alergia",
                                        action: "list",
                                        label: "Alergias",
                                        icon: "<i class='icon-stethoscope'></i>"
                                ],
                                clinica: [
                                        controller: "clinica",
                                        action: "list",
                                        label: "Clínicas",
                                        icon: "<i class='icon-hospital'></i>"
                                ],
                                examen: [
                                        controller: "examen",
                                        action: "list",
                                        label: "Exámenes",
                                        icon: "<i class='icon-bar-chart'></i>"
                                ],
                                cirugia: [
                                        controller: "tipoCirugia",
                                        action: "list",
                                        label: "Cirugias",
                                        icon: "<i class='icon-tint'></i>"
                                ],
                                sexo: [
                                        controller: "sexo",
                                        action: "list",
                                        label: "Sexo",
                                        icon: "<i class='icon-github-alt'></i>"
                                ],
                                usuario: [
                                        controller: "usuario",
                                        action: "list",
                                        label: "Usuarios",
                                        icon: "<i class='icon-user-md'></i>"
                                ]
                        ]
                ],
                cuentas: [
                        label: "Cuentas",
                        icon: "<i class='icon-money'></i>",
                        controller: "cuenta",
                        action: "list",
                        params: ["cobrar": "1", "pagar": "1"]
                ]
        ]

        def strItems = ""
        items.each { tipo, item ->
            strItems += renderItem(item, tipo)
        }

//        println strItems

        /* *************************** calculo de numero de alertas *************************/
        def cantAlertas = 0
        def dias = "5"

        def hoy = new Date().clearTime()

        def fechaFin
        use(TimeCategory) {
            fechaFin = hoy + dias.toInteger().days
        }

        Calendar calendar = GregorianCalendar.instance
        calendar.set(hoy.format("yyyy").toInteger(), hoy.format("MM").toInteger() - 1, hoy.format("dd").toInteger())
        def lastDay = calendar.getActualMaximum(GregorianCalendar.DAY_OF_MONTH)
        def endMonth = new Date().parse("dd-MM-yyyy", lastDay + hoy.format("-MM-yyyy"))

        def clinicas = Clinica.withCriteria {
            or {
                isNull("direccion")
                isNull("telefono")
            }
        }
        def pagosVencidos = Item.withCriteria {
            lt("fechaPago", hoy)
            eq("pagado", false)
        }
        def pagosDias = Item.withCriteria {
            between("fechaPago", hoy, fechaFin)
        }
        def pagosMes = Item.withCriteria {
            between("fechaPago", hoy, endMonth)
        }

        cantAlertas += clinicas.size() + pagosVencidos.size() + pagosDias.size() + pagosMes.size()

        /* ********************************* fin alertas ***************************/

        def html = ""
        html += '<div class="navbar navbar-fixed-top">'
        html += '<div class="navbar-inner">'
        html += '<div class="container">'
        html += '<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">'
        html += '<span class="icon-bar"></span>'
        html += '<span class="icon-bar"></span>'
        html += '<span class="icon-bar"></span>'
        html += '</a>'
        html += '<a class="brand" href="#">'
        html += attrs.title
        html += '</a>'

        html += '<div class="nav-collapse">'
        html += '<ul class="nav">'
        html += strItems
        html += '</ul>'
        //        html += '<li class="divider-vertical"></li>'
        html += '<p class="navbar-text pull-right" id="countdown"></p>'
        html += '<ul class="nav pull-right">'
        html += '<li id="liAlertas"><a href="' + g.createLink(controller: 'alerta', action: 'index') + '"><i class="icon-warning-sign"></i>'
        html += ' Alertas (<span id="spAlertas">' + cantAlertas + '</span>)</a></li>'
        html += '<li><a href="' + g.createLink(controller: 'login', action: 'logout') + '"><i class="icon-off"></i> Salir</a></li>'
        html += '</ul>'
        html += '</div><!--/.nav-collapse -->'
        html += '</div>'
        html += '</div>'
        html += '</div>'

        out << html
    } //menu
}

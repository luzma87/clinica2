<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 11/25/13
  Time: 12:12 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Resumen</title>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/fancyapps-fancyBox-0ffc358/source', file: 'jquery.fancybox.css?v=2.1.4')}" type="text/css" media="screen"/>
        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/fancyapps-fancyBox-0ffc358/source', file: 'jquery.fancybox.pack.js?v=2.1.4')}"></script>

        <style type="text/css">
        .alergia {
            display : inline-block;
        }

        .nombre {
            text-decoration : underline;
        }
        </style>

    </head>

    <body>
        <g:if test="${flash.message}">
            <div class="row">
                <div class="span12">
                    <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                        <a class="close" data-dismiss="alert" href="#">×</a>
                        ${flash.message}
                    </div>
                </div>
            </div>
        </g:if>

        <div class="row" style="margin-bottom: 10px;">
            <div class="span9 btn-group" role="navigation">
                <g:link controller="paciente" action="list" class="btn">
                    <i class="icon-group"></i>
                    Pacientes
                </g:link>
            </div>

            <div class="span3" id="busqueda-cirugia"></div>
        </div>

        <elm:datosPaciente paciente="${paciente}"/>


        <div class="accordion" id="accordion2">
            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" href="#historia">
                        <img src="${resource(dir: 'images/contextMenu', file: 'clipboard_text.png')}"/>
                        Historia clínica
                    </a>
                </div>

                <div id="historia" class="accordion-body ">
                    <div class="accordion-inner">
                        <g:set var="colores" value="${['info', 'success', 'warning']}"/>
                        <g:each in="${historias}" status="i" var="historia">
                            <div class="alert alert-${colores[i % 3]} historia">
                                <h5><g:formatDate date="${historia.fecha}" format="dd-MM-yyyy"/></h5>
                                ${historia.descripcion}
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>

            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" href="#alergias">
                        <img src="${resource(dir: 'images/contextMenu', file: 'allergy_vials.png')}"/>
                        Alergias
                    </a>
                </div>

                <div id="alergias" class="accordion-body hide">
                    <div class="accordion-inner">
                        <g:each in="${alergias}" status="i" var="alergia">
                            <div class="alert alert-${colores[i % 3]} alergia">
                                <h5><span class="nombre">${alergia.alergia.descripcion}</span> (<g:formatDate date="${alergia.fecha}" format="dd-MM-yyyy"/>)
                                </h5>
                                ${alergia.observaciones}
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>

            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" href="#controles">
                        <img src="${resource(dir: 'images/contextMenu', file: 'stethoscope.png')}"/>
                        Controles
                    </a>
                </div>

                <div id="controles" class="accordion-body hide">
                    <div class="accordion-inner">
                        <g:each in="${controles}" status="i" var="control">
                            <div class="alert alert-${colores[i % 3]} alergia">
                                <g:set var="hI" value="${control.fecha.format('HH').toInteger()}"/>
                                <g:set var="mI" value="${control.fecha.format('mm').toInteger()}"/>
                                <h5><g:formatDate date="${control.fecha}" format="dd-MM-yyyy HH:mm"/> -
                                    ${(hI + control.duracionHoras).toString().padLeft(2, '0')}:${(mI + control.duracionMinutos).toString().padLeft(2, '0')}</h5>
                                <g:if test="${control.observaciones}">
                                    ${control.observaciones}<br/>
                                </g:if>
                                Por Cobrar:
                                <g:formatNumber number="${control.porCobrar}" type="currency"/> hasta el
                                <g:formatDate date="${control.fechaCobro}" format="dd-MM-yyyy"/> (de <g:formatNumber number="${control.valor}" type="currency"/>)
                                <br/>
                                Por Pagar:
                                <g:formatNumber number="${control.porPagar}" type="currency"/> hasta el
                                <g:formatDate date="${control.fechaPago}" format="dd-MM-yyyy"/> (de <g:formatNumber number="${control.costo}" type="currency"/>)
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>

            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" href="#examenes">
                        <img src="${resource(dir: 'images/contextMenu', file: 'clipboard.png')}"/>
                        Resultados de exámenes
                    </a>
                </div>

                <div id="examenes" class="accordion-body hide">
                    <div class="accordion-inner">
                        <g:each in="${examenes}" status="i" var="examen">
                            <div class="alert alert-${colores[i % 3]} alergia">
                                <h5><span class="nombre">${examen.examen.grupoExamen.nombre} - ${examen.examen.nombre}</span> (<g:formatDate date="${examen.fecha}" format="dd-MM-yyyy"/>)
                                </h5>
                                Resultado: ${examen.resultado} (valores normales: ${examen.examen.valorInicial} - ${examen.examen.valorFinal})<br/>
                                Observaciones: ${examen.observaciones}
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>

            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" href="#cirugias">
                        <img src="${resource(dir: 'images/contextMenu', file: 'scalpel.png')}"/>
                        Cirugías
                    </a>
                </div>

                <div id="cirugias" class="accordion-body hide">
                    <div class="accordion-inner">
                        <g:each in="${cirugias}" status="i" var="cirugia">
                            <div class="alert alert-${colores[i % 3]} alergia">
                                <g:set var="hI" value="${cirugia.fecha.format('HH').toInteger()}"/>
                                <g:set var="mI" value="${cirugia.fecha.format('mm').toInteger()}"/>
                                <h5>${cirugia.razon} <g:formatDate date="${cirugia.fecha}" format="dd-MM-yyyy HH:mm"/> -
                                    ${(hI + cirugia.duracionHoras).toString().padLeft(2, '0')}:${(mI + cirugia.duracionMinutos).toString().padLeft(2, '0')}</h5>
                                <g:if test="${cirugia.observaciones}">
                                    ${cirugia.observaciones}<br/>
                                </g:if>
                                Clínica: ${cirugia.clinica.nombre}<br/>
                                Fotos antes:
                                <elm:imagenCirugia cirugia="${cirugia}" tipo="antes" class="mini"/><br/>
                                Fotos después:
                                <elm:imagenCirugia cirugia="${cirugia}" tipo="despues" class="mini"/><br/>
                                Por Cobrar:
                                <g:formatNumber number="${cirugia.porCobrar}" type="currency"/> hasta el
                                <g:formatDate date="${cirugia.fechaCobro}" format="dd-MM-yyyy"/> (de <g:formatNumber number="${cirugia.valor}" type="currency"/>)
                                <br/>
                                Por Pagar:
                                <g:formatNumber number="${cirugia.porPagar}" type="currency"/> hasta el
                                <g:formatDate date="${cirugia.fechaPago}" format="dd-MM-yyyy"/> (de <g:formatNumber number="${cirugia.costo}" type="currency"/>)
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                $(".accordion-toggle").click(function () {
                    var $target = $($(this).attr("href"));
                    $target.toggle("blind");
                    return false;
                });

                $(".fancybox").fancybox({
                    type    : 'ajax',
                    helpers : {
                        overlay : {
                            css : {
//                                'background' : 'rgba(66, 172, 233, 0.95)'
                                'background' : 'rgba(77, 133, 166, 0.8)'
                            }
                        }
                    }
                });
            });
        </script>

    </body>
</html>
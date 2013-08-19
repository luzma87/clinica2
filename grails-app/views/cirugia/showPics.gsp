<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 7/1/13
  Time: 5:41 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Imagenes de cirugía</title>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/fancyapps-fancyBox-0ffc358/source', file: 'jquery.fancybox.css?v=2.1.4')}" type="text/css" media="screen"/>
        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/fancyapps-fancyBox-0ffc358/source', file: 'jquery.fancybox.pack.js?v=2.1.4')}"></script>

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

        <div class="row" style="margin-bottom: 20px;">
            <div class="span9 btn-group" role="navigation">
                <g:link controller="cirugia" action="list" id="${cirugia.pacienteId}" class="btn">
                    <i class="icon-medkit"></i>
                    Cirugías
                </g:link>
            </div>

            <div class="span3" id="busqueda-cirugia"></div>
        </div>

        <elm:datosPaciente paciente="${cirugia.paciente}" cirugia="${cirugia}"/>

        <div id="list-Cirugia" role="main" style="margin-top: 10px;">
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <th>Fotos antes</th>
                        <th>Fotos después</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="img">
                            <elm:imagenCirugia cirugia="${cirugia}" tipo="antes"/>
                        </td>
                        <td class="img">
                            <elm:imagenCirugia cirugia="${cirugia}" tipo="despues"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <script type="text/javascript">

            $(function () {
                $(".fancybox").fancybox({
                    helpers : {
                        overlay : {
                            css : {
//                                'background' : 'rgba(66, 172, 233, 0.95)'
                                'background' : 'rgba(77, 133, 166, 0.8)'
                            }
                        }
                    }
                });

                $.contextMenu({
                    selector : 'img',
                    items    : {
                        "show" : {
                            name     : "Editar",
                            icon     : "editPic",
                            callback : function (key, options) {
                                var pic = options.$trigger;
                                var path = pic.attr("src");
                                location.href = "${createLink(action:'editPic')}/${cirugia.id}?path=" + path;
                            }
                        }
                    }
                });
            });
        </script>
    </body>
</html>
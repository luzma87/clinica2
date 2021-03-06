<%@ page import="clinica.Item" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Cirugías
        </title>

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

        <div class="row">
            <div class="span9 btn-group" role="navigation">
                <g:link controller="paciente" action="list" class="btn">
                    <i class="icon-group"></i>
                    Pacientes
                </g:link>
                <a href="#" class="btn btn-ajax btn-new" id="btnNewCirugia">
                    <i class="icon-file"></i>
                    Nueva  Cirugía
                </a>
            </div>

            <div class="span3" id="busqueda-cirugia"></div>
        </div>

        <g:form action="delete" name="frmDelete-cirugia" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <elm:datosPaciente paciente="${paciente}"/>

        <div id="list-Cirugia" role="main" style="margin-top: 10px;">
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <g:sortableColumn property="fecha" title="Fecha" style="width:110px;"/>
                        <g:sortableColumn property="duracionHoras" title="Duraci&oacute;n" style="width:63px;"/>
                        <g:sortableColumn property="clinica" title="Clínica" style="width:200px;"/>
                        <g:sortableColumn property="razon" title="Razón"/>
                        <th>Por cobrar</th>
                        <th>Por pagar</th>
                        <g:sortableColumn property="estado" title="Estado"/>
                        <th>Fotos antes</th>
                        <th>Fotos después</th>

                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${cirugiaInstanceList}" status="i" var="cirugiaInstance">
                        <tr class="fila" id="${cirugiaInstance.id}">
                            <td><g:formatDate date="${cirugiaInstance.fecha}" format="dd-MM-yyyy HH:mm"/></td>
                            <td>
                                ${cirugiaInstance.duracionHoras.toString().padLeft(2, '0')}:${cirugiaInstance.duracionMinutos.toString().padLeft(2, '0')}
                                %{--${cirugiaInstance.duracionHoras}--}%
                                %{--hora${cirugiaInstance.duracionHoras == 1 ? "" : "s"}--}%
                                %{--${cirugiaInstance.duracionMinutos}--}%
                                %{--minuto${cirugiaInstance.duracionMinutos == 1 ? "" : "s"}--}%
                            </td>
                            <td>${cirugiaInstance.clinica?.nombre}</td>
                            <td>${fieldValue(bean: cirugiaInstance, field: "razon")}</td>
                            <td>
                                <g:formatNumber number="${cirugiaInstance.porCobrar}" type="currency"/> hasta el
                                <g:formatDate date="${cirugiaInstance.fechaCobro}" format="dd-MM-yyyy"/> (de <g:formatNumber number="${cirugiaInstance.valor}" type="currency"/>)
                            </td>
                            <td>
                                <g:formatNumber number="${cirugiaInstance.porPagar}" type="currency"/> hasta el
                                <g:formatDate date="${cirugiaInstance.fechaPago}" format="dd-MM-yyyy"/> (de <g:formatNumber number="${cirugiaInstance.costo}" type="currency"/>)
                            </td>
                            <td>${cirugiaInstance.estadoItem.descripcion}</td>
                            <td class="img">
                                <elm:imagenCirugia cirugia="${cirugiaInstance}" tipo="antes" class="mini"/>
                            </td>
                            <td class="img">
                                <elm:imagenCirugia cirugia="${cirugiaInstance}" tipo="despues" class="mini"/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-cirugia">
            <div class="modal-header" id="modalHeader-cirugia">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-cirugia"></h3>
            </div>

            <div class="modal-body" id="modalBody-cirugia">
            </div>

            <div class="modal-footer" id="modalFooter-cirugia">
            </div>
        </div>

        <div class="modal hide fade" id="modal-alert">
            <div class="modal-header" id="modalHeader-alert">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-alert"></h3>
            </div>

            <div class="modal-body" id="modalBody-alert">
            </div>

            <div class="modal-footer" id="modalFooter-alert">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-cirugia").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-cirugia").submit();
            }

            $(function () {
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

                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-cirugia"),
                    float          : "right"
                });

                $("#btnNewCirugia").click(function () {
                    var btn = $(this).clone(true);
                    $(this).replaceWith(spinner);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        data    : {
                            paciente : "${paciente.id}"
                        },
                        success : function (msg) {
                            spinner.replaceWith(btn);
                            var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            $("#modalTitle-cirugia").html("Crear Cirugía");
                            $("#modalBody-cirugia").html(msg);
                            $("#modalFooter-cirugia").html("").append(btnCancel).append(btnSave);
                            $("#modal-cirugia").modal("show");
                        }
                    });
                    return false;
                }); //click btn new

                $.contextMenu({
                    selector : '.fila',
                    items    : {
                        "show"      : {
                            name     : "Ver",
                            icon     : "show",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'show_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                                        $("#modalTitle-cirugia").html("Ver Cirugía");
                                        $("#modalBody-cirugia").html(msg);
                                        $("#modalFooter-cirugia").html("").append(btnOk);
                                        $("#modal-cirugia").modal("show");
                                    }
                                });
                            }
                        },
                        "edit"      : {
                            name     : "Editar",
                            icon     : "edit",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'form_ajax')}",
                                    data    : {
                                        id       : id,
                                        paciente : "${paciente.id}"
                                    },
                                    success : function (msg) {
                                        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                                        btnSave.click(function () {
                                            submitForm(btnSave);
                                            return false;
                                        });

                                        $("#modalTitle-cirugia").html("Editar Cirugía");
                                        $("#modalBody-cirugia").html(msg);
                                        $("#modalFooter-cirugia").html("").append(btnCancel).append(btnSave);
                                        $("#modal-cirugia").modal("show");
                                    }
                                });
                            }
                        },
                        "sep1"      : "---------",
                        "showPic"   : {
                            name     : "Ver fotos",
                            icon     : "showPic",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                location.href = "${createLink(action:'showPics')}/" + id;
                            }
                        },
                        "deletePic" : {
                            name     : "Eliminar fotos",
                            icon     : "deletePic",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'delPic_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                                        btnSave.click(function () {
                                            submitForm(btnSave);
                                            return false;
                                        });

                                        $("#modalTitle-cirugia").html("Eliminar fotos");
                                        $("#modalBody-cirugia").html(msg);
                                        $("#modalFooter-cirugia").html("").append(btnCancel).append(btnSave);
                                        $("#modal-cirugia").modal("show");
                                    }
                                });
                            }
                        },
                        "sep2"      : "---------",
                        "delete"    : {
                            name     : "Eliminar",
                            icon     : "delete",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $("#id").val(id);
                                var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

                                btnDelete.click(function () {
                                    btnDelete.replaceWith(spinner);
                                    $("#frmDelete-cirugia").submit();
                                    return false;
                                });

                                $("#modalTitle-cirugia").html("Eliminar Cirugía");
                                $("#modalBody-cirugia").html("<p>¿Está seguro de querer eliminar esta Cirugía?</p>");
                                $("#modalFooter-cirugia").html("").append(btnCancel).append(btnDelete);
                                $("#modal-cirugia").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>

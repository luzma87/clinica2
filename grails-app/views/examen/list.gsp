<%@ page import="clinica.Examen" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Exámenes
        </title>

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
                <g:link controller="grupoExamen" action="list" class="btn">
                    <i class="icon-sitemap"></i>
                    Grupos de  Examen
                </g:link>
                <a href="#" class="btn btn-ajax btn-new" id="btnNewExamen">
                    <i class="icon-file"></i>
                    Crear  Examen
                </a>
            </div>

            <div class="span3" id="busqueda-examen"></div>
        </div>

        <g:form action="delete" name="frmDelete-examen" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Examen" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>

                        <th>Grupo Examen</th>

                        <g:sortableColumn property="nombre" title="Nombre"/>

                        <g:sortableColumn property="valorInicial" title="Valor Inicial"/>

                        <g:sortableColumn property="valorFinal" title="Valor Final"/>

                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${examenInstanceList}" status="i" var="examenInstance">
                        <tr class="fila" id="${examenInstance.id}">

                            <td>${examenInstance.grupoExamen.nombre}</td>

                            <td>${fieldValue(bean: examenInstance, field: "nombre")}</td>

                            <td>${fieldValue(bean: examenInstance, field: "valorInicial")}</td>

                            <td>${fieldValue(bean: examenInstance, field: "valorFinal")}</td>

                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-examen">
            <div class="modal-header" id="modalHeader-examen">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-examen"></h3>
            </div>

            <div class="modal-body" id="modalBody-examen">
            </div>

            <div class="modal-footer" id="modalFooter-examen">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-examen").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-examen").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-examen"),
                    float          : "right"
                });

                $("#btnNewExamen").click(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        success : function (msg) {
                            var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            $("#modalTitle-examen").html("Crear Examen");
                            $("#modalBody-examen").html(msg);
                            $("#modalFooter-examen").html("").append(btnCancel).append(btnSave);
                            $("#modal-examen").modal("show");
                        }
                    });
                    return false;
                }); //click btn new

                $.contextMenu({
                    selector : '.fila',
                    items    : {
                        "show"   : {
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
                                        $("#modalTitle-examen").html("Ver Examen");
                                        $("#modalBody-examen").html(msg);
                                        $("#modalFooter-examen").html("").append(btnOk);
                                        $("#modal-examen").modal("show");
                                    }
                                });
                            }
                        },
                        "edit"   : {
                            name     : "Editar",
                            icon     : "edit",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'form_ajax')}",
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

                                        $("#modalTitle-examen").html("Editar Examen");
                                        $("#modalBody-examen").html(msg);
                                        $("#modalFooter-examen").html("").append(btnCancel).append(btnSave);
                                        $("#modal-examen").modal("show");
                                    }
                                });
                            }
                        },
                        "sep1"   : "---------",
                        "delete" : {
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
                                    $("#frmDelete-examen").submit();
                                    return false;
                                });

                                $("#modalTitle-examen").html("Eliminar Examen");
                                $("#modalBody-examen").html("<p>¿Está seguro de querer eliminar esta Examen?</p>");
                                $("#modalFooter-examen").html("").append(btnCancel).append(btnDelete);
                                $("#modal-examen").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>

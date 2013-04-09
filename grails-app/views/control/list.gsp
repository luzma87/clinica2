<%@ page import="clinica.Item" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Controles
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
                <g:link controller="paciente" action="list" class="btn">
                    <i class="icon-group"></i>
                    Pacientes
                </g:link>
                <a href="#" class="btn btn-ajax btn-new" id="btnNewControl">
                    <i class="icon-file"></i>
                    Crear  Control
                </a>
            </div>

            <div class="span3" id="busqueda-control"></div>
        </div>

        <g:form action="delete" name="frmDelete-control" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <elm:datosPaciente paciente="${paciente}"/>

        <div id="list-Control" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <g:sortableColumn property="fecha" title="Fecha"/>
                        <g:sortableColumn property="duracionHoras" title="Duracion"/>
                        <g:sortableColumn property="observaciones" title="Observaciones"/>
                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${controlInstanceList}" status="i" var="controlInstance">
                        <tr class="fila" id="${controlInstance.id}">
                            <td><g:formatDate date="${controlInstance.fecha}" format="dd-MM-yyyy HH:mm"/></td>
                            <td>
                                ${controlInstance.duracionHoras.toString().padLeft(2, '0')}:${controlInstance.duracionMinutos.toString().padLeft(2, '0')}
                            </td>
                            <td>${fieldValue(bean: controlInstance, field: "observaciones")}</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-control">
            <div class="modal-header" id="modalHeader-control">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-control"></h3>
            </div>

            <div class="modal-body" id="modalBody-control">
            </div>

            <div class="modal-footer" id="modalFooter-control">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-control").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-control").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-control"),
                    float          : "right"
                });

                $("#btnNewControl").click(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        data    : {
                            paciente : "${paciente.id}"
                        },
                        success : function (msg) {
                            var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            $("#modalHeader-control").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle-control").html("Crear Control");
                            $("#modalBody-control").html(msg);
                            $("#modalFooter-control").html("").append(btnCancel).append(btnSave);
                            $("#modal-control").modal("show");
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
                                        $("#modalHeader-control").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");
                                        $("#modalTitle-control").html("Ver Control");
                                        $("#modalBody-control").html(msg);
                                        $("#modalFooter-control").html("").append(btnOk);
                                        $("#modal-control").modal("show");
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

                                        $("#modalHeader-control").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
                                        $("#modalTitle-control").html("Editar Control");
                                        $("#modalBody-control").html(msg);
                                        $("#modalFooter-control").html("").append(btnCancel).append(btnSave);
                                        $("#modal-control").modal("show");
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
                                    $("#frmDelete-control").submit();
                                    return false;
                                });

                                $("#modalHeader-control").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
                                $("#modalTitle-control").html("Eliminar Control");
                                $("#modalBody-control").html("<p>¿Está seguro de querer eliminar esta Control?</p>");
                                $("#modalFooter-control").html("").append(btnCancel).append(btnDelete);
                                $("#modal-control").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>

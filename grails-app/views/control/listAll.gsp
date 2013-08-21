<%@ page import="clinica.Item" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Controles
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

        %{--<div class="btn-group" role="navigation" data-toggle="buttons-checkbox">--}%
        %{--<a href="#" class="btn btn-small btn-info toggle ${params.old == '1' ? 'active' : ''}" id="old">--}%
        %{--Anteriores--}%
        %{--</a>--}%
        %{--<a href="#" class="btn btn-small btn-info toggle ${params.today == '1' ? 'active' : ''}" id="today">--}%
        %{--Hoy--}%
        %{--</a>--}%
        %{--<a href="#" class="btn btn-small btn-info toggle ${params.future == '1' ? 'active' : ''}" id="future">--}%
        %{--Futuros--}%
        %{--</a>--}%
        %{--</div>--}%
        <elm:barraTiempo future="${params.future}" today="${params.today}" old="${params.old}"/>

        <div id="list-Control" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <g:sortableColumn property="paciente" title="Paciente"/>
                        <g:sortableColumn property="fecha" title="Fecha"/>
                        <g:sortableColumn property="duracionHoras" title="Duración"/>
                        <th>Por cobrar</th>
                        <th>Por pagar</th>
                        <g:sortableColumn property="estado" title="Estado"/>
                        <th>Observaciones</th>
                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${controlInstanceList}" status="i" var="controlInstance">
                        <tr class="fila" id="${controlInstance.id}">
                            <td>${controlInstance.paciente.nombres} ${controlInstance.paciente.apellidos}</td>
                            <td><g:formatDate date="${controlInstance.fecha}" format="dd-MM-yyyy HH:mm"/></td>
                            <td>
                                ${controlInstance.duracionHoras.toString().padLeft(2, '0')}:${controlInstance.duracionMinutos.toString().padLeft(2, '0')}
                            </td>
                            <td>
                                <g:formatNumber number="${controlInstance.valor}" type="currency"/> hasta el
                                <g:formatDate date="${controlInstance.fechaCobro}" format="dd-MM-yyyy"/>
                            </td>
                            <td>
                                <g:formatNumber number="${controlInstance.costo}" type="currency"/> hasta el
                                <g:formatDate date="${controlInstance.fechaPago}" format="dd-MM-yyyy"/>
                            </td>
                            <td>${controlInstance.estadoItem.descripcion}</td>
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

                $(".toggle").click(function () {
                    var tipo = $(this).attr("id");
                    var active = $(this).hasClass("active");
                    var params = "${params}";
                    var val = active ? '0' : '1';
                    params = params.substr(1, params.length - 2);
                    var p = "";
                    var parts = params.split(",");
                    for (var i = 0; i < parts.length; i++) {
                        if (parts[i].indexOf(tipo) == -1) {
                            p += $.trim(parts[i]).replace(":", "=") + "&";
                        }
                    }
                    p += tipo + "=" + val;
                    location.href = "${createLink(action: 'listAll')}?" + p;
                });

                $("#btnNewControl").click(function () {
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

                            $("#modalHeader-control").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle-control").html("Crear Control");
                            $("#modalBody-control").html(msg);
                            $("#modalFooter-control").html("").append(btnCancel).append(btnSave);
                            $("#modal-control").modal("show");
                            $("#tipo").val("all");
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
                                        id : id
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
                                        $("#tipo").val("all");
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
                                $("#tipo").val("all");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>

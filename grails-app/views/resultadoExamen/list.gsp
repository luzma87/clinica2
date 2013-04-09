<%@ page import="clinica.ResultadoExamen" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Resultados de Exámenes
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewResultadoExamen">
                    <i class="icon-file"></i>
                    Nuevo Examen
                </a>
            </div>

            <div class="span3" id="busqueda-resultadoexamen"></div>
        </div>

        <g:form action="delete" name="frmDelete-resultadoexamen" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <elm:datosPaciente paciente="${paciente}"/>

        <div id="list-ResultadoExamen" role="main" style="margin-top: 10px;">
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <th>Grupo Examen</th>
                        <g:sortableColumn property="examen" title="Examen"/>
                        <g:sortableColumn property="resultado" title="Resultado"/>
                        <th>Valores normales</th>
                        <g:sortableColumn property="fecha" title="Fecha"/>
                        <g:sortableColumn property="observaciones" title="Observaciones"/>
                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${resultadoExamenInstanceList}" status="i" var="resultadoExamenInstance">
                        <tr class="fila" id="${resultadoExamenInstance.id}">
                            <td>${resultadoExamenInstance.examen.grupoExamen.nombre}</td>
                            <td>${resultadoExamenInstance.examen.nombre}</td>
                            <td>${fieldValue(bean: resultadoExamenInstance, field: "resultado")}</td>
                            <td>${resultadoExamenInstance.examen.valorInicial} - ${resultadoExamenInstance.examen.valorFinal}</td>
                            <td><g:formatDate date="${resultadoExamenInstance.fecha}" format="dd-MM-yyyy"/></td>
                            <td>${fieldValue(bean: resultadoExamenInstance, field: "observaciones")}</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-resultadoexamen">
            <div class="modal-header" id="modalHeader-resultadoexamen">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-resultadoexamen"></h3>
            </div>

            <div class="modal-body" id="modalBody-resultadoexamen">
            </div>

            <div class="modal-footer" id="modalFooter-resultadoexamen">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-resultadoexamen").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-resultadoexamen").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-resultadoexamen"),
                    float          : "right"
                });

                $("#btnNewResultadoExamen").click(function () {
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

                            $("#modalTitle-resultadoexamen").html("Crear Resultado de Examen");
                            $("#modalBody-resultadoexamen").html(msg);
                            $("#modalFooter-resultadoexamen").html("").append(btnCancel).append(btnSave);
                            $("#modal-resultadoexamen").modal("show");
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
                                        $("#modalTitle-resultadoexamen").html("Ver Resultado de Examen");
                                        $("#modalBody-resultadoexamen").html(msg);
                                        $("#modalFooter-resultadoexamen").html("").append(btnOk);
                                        $("#modal-resultadoexamen").modal("show");
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

                                        $("#modalTitle-resultadoexamen").html("Editar Resultado de Examen");
                                        $("#modalBody-resultadoexamen").html(msg);
                                        $("#modalFooter-resultadoexamen").html("").append(btnCancel).append(btnSave);
                                        $("#modal-resultadoexamen").modal("show");
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
                                    $("#frmDelete-resultadoexamen").submit();
                                    return false;
                                });

                                $("#modalTitle-resultadoexamen").html("Eliminar Resultado de Examen");
                                $("#modalBody-resultadoexamen").html("<p>¿Está seguro de querer eliminar esta ResultadoExamen?</p>");
                                $("#modalFooter-resultadoexamen").html("").append(btnCancel).append(btnDelete);
                                $("#modal-resultadoexamen").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>


<%@ page import="clinica.AlergiaPaciente" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
             Alergia Pacientes
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewAlergiaPaciente">
                    <i class="icon-file"></i>
                    Crear  Alergia Paciente
                </a>
            </div>
            <div class="span3" id="busqueda-alergiapaciente"></div>
        </div>

        <g:form action="delete" name="frmDelete-alergiapaciente" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-AlergiaPaciente" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <th>Paciente</th>
                    
                        <th>Alergia</th>
                    
                        <g:sortableColumn property="fecha" title="Fecha" />
                    
                        <g:sortableColumn property="observaciones" title="Observaciones" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${alergiaPacienteInstanceList}" status="i" var="alergiaPacienteInstance">
                    <tr class="fila" id="${alergiaPacienteInstance.id}">
                    
                        <td>${fieldValue(bean: alergiaPacienteInstance, field: "paciente")}</td>
                    
                        <td>${fieldValue(bean: alergiaPacienteInstance, field: "alergia")}</td>
                    
                        <td><g:formatDate date="${alergiaPacienteInstance.fecha}" /></td>
                    
                        <td>${fieldValue(bean: alergiaPacienteInstance, field: "observaciones")}</td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-alergiapaciente">
            <div class="modal-header" id="modalHeader-alergiapaciente">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-alergiapaciente"></h3>
            </div>

            <div class="modal-body" id="modalBody-alergiapaciente">
            </div>

            <div class="modal-footer" id="modalFooter-alergiapaciente">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-alergiapaciente").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-alergiapaciente").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-alergiapaciente"),
                    float          : "right"
                });

                $("#btnNewAlergiaPaciente").click(function () {
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

                            $("#modalTitle-alergiapaciente").html("Crear Alergia Paciente");
                            $("#modalBody-alergiapaciente").html(msg);
                            $("#modalFooter-alergiapaciente").html("").append(btnCancel).append(btnSave);
                            $("#modal-alergiapaciente").modal("show");
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
                                    $("#modalTitle-alergiapaciente").html("Ver AlergiaPaciente");
                                    $("#modalBody-alergiapaciente").html(msg);
                                    $("#modalFooter-alergiapaciente").html("").append(btnOk);
                                    $("#modal-alergiapaciente").modal("show");
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

                                    $("#modalTitle-alergiapaciente").html("Editar AlergiaPaciente");
                                    $("#modalBody-alergiapaciente").html(msg);
                                    $("#modalFooter-alergiapaciente").html("").append(btnCancel).append(btnSave);
                                    $("#modal-alergiapaciente").modal("show");
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
                                $("#frmDelete-alergiapaciente").submit();
                                return false;
                            });

                            $("#modalTitle-alergiapaciente").html("Eliminar AlergiaPaciente");
                            $("#modalBody-alergiapaciente").html("<p>¿Está seguro de querer eliminar esta AlergiaPaciente?</p>");
                            $("#modalFooter-alergiapaciente").html("").append(btnCancel).append(btnDelete);
                            $("#modal-alergiapaciente").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

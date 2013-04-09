
<%@ page import="clinica.PacienteUsuario" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Paciente Usuarios
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewPacienteUsuario">
                    <i class="icon-file"></i>
                    Crear  Paciente Usuario
                </a>
            </div>
            <div class="span3" id="busqueda-pacienteusuario"></div>
        </div>

        <g:form action="delete" name="frmDelete-pacienteusuario" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-PacienteUsuario" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <th>Usuario</th>
                    
                        <th>Paciente</th>
                    
                        <g:sortableColumn property="fechaRegistro" title="Fecha Registro" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${pacienteUsuarioInstanceList}" status="i" var="pacienteUsuarioInstance">
                    <tr class="fila" id="${pacienteUsuarioInstance.id}">
                    
                        <td>${fieldValue(bean: pacienteUsuarioInstance, field: "usuario")}</td>
                    
                        <td>${fieldValue(bean: pacienteUsuarioInstance, field: "paciente")}</td>
                    
                        <td><g:formatDate date="${pacienteUsuarioInstance.fechaRegistro}" /></td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-pacienteusuario">
            <div class="modal-header" id="modalHeader-pacienteusuario">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-pacienteusuario"></h3>
            </div>

            <div class="modal-body" id="modalBody-pacienteusuario">
            </div>

            <div class="modal-footer" id="modalFooter-pacienteusuario">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-pacienteusuario").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-pacienteusuario").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-pacienteusuario"),
                    float          : "right"
                });

                $("#btnNewPacienteUsuario").click(function () {
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

                            $("#modalTitle-pacienteusuario").html("Crear Paciente Usuario");
                            $("#modalBody-pacienteusuario").html(msg);
                            $("#modalFooter-pacienteusuario").html("").append(btnCancel).append(btnSave);
                            $("#modal-pacienteusuario").modal("show");
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
                                    $("#modalTitle-pacienteusuario").html("Ver PacienteUsuario");
                                    $("#modalBody-pacienteusuario").html(msg);
                                    $("#modalFooter-pacienteusuario").html("").append(btnOk);
                                    $("#modal-pacienteusuario").modal("show");
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

                                    $("#modalTitle-pacienteusuario").html("Editar PacienteUsuario");
                                    $("#modalBody-pacienteusuario").html(msg);
                                    $("#modalFooter-pacienteusuario").html("").append(btnCancel).append(btnSave);
                                    $("#modal-pacienteusuario").modal("show");
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
                                $("#frmDelete-pacienteusuario").submit();
                                return false;
                            });

                            $("#modalTitle-pacienteusuario").html("Eliminar PacienteUsuario");
                            $("#modalBody-pacienteusuario").html("<p>¿Está seguro de querer eliminar esta PacienteUsuario?</p>");
                            $("#modalFooter-pacienteusuario").html("").append(btnCancel).append(btnDelete);
                            $("#modal-pacienteusuario").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

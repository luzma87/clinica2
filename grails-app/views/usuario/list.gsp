<%@ page import="clinica.seguridad.Usuario" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
             Usuarios
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewUsuario">
                    <i class="icon-file"></i>
                    Crear  Usuario
                </a>
            </div>

            <div class="span3" id="busqueda-usuario"></div>
        </div>

        <g:form action="delete" name="frmDelete-usuario" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Usuario" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <g:sortableColumn property="usuario" title="Usuario"/>
                        <g:sortableColumn property="nombres" title="Nombres"/>
                        <g:sortableColumn property="email" title="Email"/>
                        %{--<th>Path fotos</th>--}%
                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${usuarioInstanceList}" status="i" var="usuarioInstance">
                        <tr class="fila" id="${usuarioInstance.id}">
                            <td>${fieldValue(bean: usuarioInstance, field: "usuario")}</td>
                            <td>${fieldValue(bean: usuarioInstance, field: "nombres")}</td>
                            <td>${fieldValue(bean: usuarioInstance, field: "email")}</td>
                            %{--<td>${fieldValue(bean: usuarioInstance, field: "pathFotos")}</td>--}%
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-usuario">
            <div class="modal-header" id="modalHeader-usuario">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-usuario"></h3>
            </div>

            <div class="modal-body" id="modalBody-usuario">
            </div>

            <div class="modal-footer" id="modalFooter-usuario">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-usuario").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-usuario").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-usuario"),
                    float          : "right"
                });

                $("#btnNewUsuario").click(function () {
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

                            $("#modalTitle-usuario").html("Crear Usuario");
                            $("#modalBody-usuario").html(msg);
                            $("#modalFooter-usuario").html("").append(btnCancel).append(btnSave);
                            $("#modal-usuario").modal("show");
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
                                        $("#modalTitle-usuario").html("Ver Usuario");
                                        $("#modalBody-usuario").html(msg);
                                        $("#modalFooter-usuario").html("").append(btnOk);
                                        $("#modal-usuario").modal("show");
                                    }
                                });
                            }
                        },
                        "edit"   : {
                            name     : "Editar",
                            icon     : "edit",
                            disabled : function (key, opt) {
                                var row = opt.$trigger;
                                var id = row.attr("id");
                                return (id.toString() != "${session.user.id}");
                            },
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
                                        $("#modalTitle-usuario").html("Editar Usuario");
                                        $("#modalBody-usuario").html(msg);
                                        $("#modalFooter-usuario").html("").append(btnCancel).append(btnSave);
                                        $("#modal-usuario").modal("show");
                                    }
                                });
                            }
                        },
                        "pass"   : {
                            name     : "Cambiar password",
                            icon     : "key",
                            disabled : function (key, opt) {
                                var row = opt.$trigger;
                                var id = row.attr("id");
                                return (id.toString() != "${session.user.id}");
                            },
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'pass_ajax')}",
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
                                        $("#modalTitle-usuario").html("Cambiar Password");
                                        $("#modalBody-usuario").html(msg);
                                        $("#modalFooter-usuario").html("").append(btnCancel).append(btnSave);
                                        $("#modal-usuario").modal("show");
                                    }
                                });
                            }
                        },
                        "sep1"   : "---------",
                        "delete" : {
                            name     : "Eliminar",
                            icon     : "delete",
                            disabled : function (key, opt) {
                                var row = opt.$trigger;
                                var id = row.attr("id");
                                return (id.toString() != "${session.user.id}");
                            },
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $("#id").val(id);
                                var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

                                btnDelete.click(function () {
                                    btnDelete.replaceWith(spinner);
                                    $("#frmDelete-usuario").submit();
                                    return false;
                                });
                                $("#modalTitle-usuario").html("Eliminar Usuario");
                                $("#modalBody-usuario").html("<p>¿Está seguro de querer eliminar esta Usuario?</p>");
                                $("#modalFooter-usuario").html("").append(btnCancel).append(btnDelete);
                                $("#modal-usuario").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>


<%@ page import="clinica.Sexo" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Sexos
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewSexo">
                    <i class="icon-file"></i>
                    Crear  Sexo
                </a>
            </div>
            <div class="span3" id="busqueda-sexo"></div>
        </div>

        <g:form action="delete" name="frmDelete-sexo" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Sexo" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <g:sortableColumn property="descripcion" title="Descripcion" />
                    
                        <g:sortableColumn property="abreviacion" title="Abreviacion" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${sexoInstanceList}" status="i" var="sexoInstance">
                    <tr class="fila" id="${sexoInstance.id}">
                    
                        <td>${fieldValue(bean: sexoInstance, field: "descripcion")}</td>
                    
                        <td>${fieldValue(bean: sexoInstance, field: "abreviacion")}</td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-sexo">
            <div class="modal-header" id="modalHeader-sexo">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-sexo"></h3>
            </div>

            <div class="modal-body" id="modalBody-sexo">
            </div>

            <div class="modal-footer" id="modalFooter-sexo">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-sexo").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-sexo").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-sexo"),
                    float          : "right"
                });

                $("#btnNewSexo").click(function () {
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

                            $("#modalTitle-sexo").html("Crear Sexo");
                            $("#modalBody-sexo").html(msg);
                            $("#modalFooter-sexo").html("").append(btnCancel).append(btnSave);
                            $("#modal-sexo").modal("show");
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
                                    $("#modalTitle-sexo").html("Ver Sexo");
                                    $("#modalBody-sexo").html(msg);
                                    $("#modalFooter-sexo").html("").append(btnOk);
                                    $("#modal-sexo").modal("show");
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

                                    $("#modalTitle-sexo").html("Editar Sexo");
                                    $("#modalBody-sexo").html(msg);
                                    $("#modalFooter-sexo").html("").append(btnCancel).append(btnSave);
                                    $("#modal-sexo").modal("show");
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
                                $("#frmDelete-sexo").submit();
                                return false;
                            });

                            $("#modalTitle-sexo").html("Eliminar Sexo");
                            $("#modalBody-sexo").html("<p>¿Está seguro de querer eliminar esta Sexo?</p>");
                            $("#modalFooter-sexo").html("").append(btnCancel).append(btnDelete);
                            $("#modal-sexo").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

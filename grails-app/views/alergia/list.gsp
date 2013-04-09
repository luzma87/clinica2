
<%@ page import="clinica.Alergia" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Alergias
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewAlergia">
                    <i class="icon-file"></i>
                    Crear  Alergia
                </a>
            </div>
            <div class="span3" id="busqueda-alergia"></div>
        </div>

        <g:form action="delete" name="frmDelete-alergia" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Alergia" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <g:sortableColumn property="descripcion" title="Descripcion" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${alergiaInstanceList}" status="i" var="alergiaInstance">
                    <tr class="fila" id="${alergiaInstance.id}">
                    
                        <td>${fieldValue(bean: alergiaInstance, field: "descripcion")}</td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-alergia">
            <div class="modal-header" id="modalHeader-alergia">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-alergia"></h3>
            </div>

            <div class="modal-body" id="modalBody-alergia">
            </div>

            <div class="modal-footer" id="modalFooter-alergia">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-alergia").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-alergia").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-alergia"),
                    float          : "right"
                });

                $("#btnNewAlergia").click(function () {
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

                            $("#modalTitle-alergia").html("Crear Alergia");
                            $("#modalBody-alergia").html(msg);
                            $("#modalFooter-alergia").html("").append(btnCancel).append(btnSave);
                            $("#modal-alergia").modal("show");
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
                                    $("#modalTitle-alergia").html("Ver Alergia");
                                    $("#modalBody-alergia").html(msg);
                                    $("#modalFooter-alergia").html("").append(btnOk);
                                    $("#modal-alergia").modal("show");
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

                                    $("#modalTitle-alergia").html("Editar Alergia");
                                    $("#modalBody-alergia").html(msg);
                                    $("#modalFooter-alergia").html("").append(btnCancel).append(btnSave);
                                    $("#modal-alergia").modal("show");
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
                                $("#frmDelete-alergia").submit();
                                return false;
                            });

                            $("#modalTitle-alergia").html("Eliminar Alergia");
                            $("#modalBody-alergia").html("<p>¿Está seguro de querer eliminar esta Alergia?</p>");
                            $("#modalFooter-alergia").html("").append(btnCancel).append(btnDelete);
                            $("#modal-alergia").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

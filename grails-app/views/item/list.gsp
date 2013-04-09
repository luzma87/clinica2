
<%@ page import="clinica.Item" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Items
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewItem">
                    <i class="icon-file"></i>
                    Crear  Item
                </a>
            </div>
            <div class="span3" id="busqueda-item"></div>
        </div>

        <g:form action="delete" name="frmDelete-item" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Item" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <th>Usuario</th>
                    
                        <th>Paciente</th>
                    
                        <g:sortableColumn property="fecha" title="Fecha" />
                    
                        <g:sortableColumn property="razon" title="Razon" />
                    
                        <th>Clinica</th>
                    
                        <g:sortableColumn property="observaciones" title="Observaciones" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${itemInstanceList}" status="i" var="itemInstance">
                    <tr class="fila" id="${itemInstance.id}">
                    
                        <td>${fieldValue(bean: itemInstance, field: "usuario")}</td>
                    
                        <td>${fieldValue(bean: itemInstance, field: "paciente")}</td>
                    
                        <td><g:formatDate date="${itemInstance.fecha}" /></td>
                    
                        <td>${fieldValue(bean: itemInstance, field: "razon")}</td>
                    
                        <td>${fieldValue(bean: itemInstance, field: "clinica")}</td>
                    
                        <td>${fieldValue(bean: itemInstance, field: "observaciones")}</td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-item">
            <div class="modal-header" id="modalHeader-item">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-item"></h3>
            </div>

            <div class="modal-body" id="modalBody-item">
            </div>

            <div class="modal-footer" id="modalFooter-item">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-item").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-item").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-item"),
                    float          : "right"
                });

                $("#btnNewItem").click(function () {
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

                            $("#modalTitle-item").html("Crear Item");
                            $("#modalBody-item").html(msg);
                            $("#modalFooter-item").html("").append(btnCancel).append(btnSave);
                            $("#modal-item").modal("show");
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
                                    $("#modalTitle-item").html("Ver Item");
                                    $("#modalBody-item").html(msg);
                                    $("#modalFooter-item").html("").append(btnOk);
                                    $("#modal-item").modal("show");
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

                                    $("#modalTitle-item").html("Editar Item");
                                    $("#modalBody-item").html(msg);
                                    $("#modalFooter-item").html("").append(btnCancel).append(btnSave);
                                    $("#modal-item").modal("show");
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
                                $("#frmDelete-item").submit();
                                return false;
                            });

                            $("#modalTitle-item").html("Eliminar Item");
                            $("#modalBody-item").html("<p>¿Está seguro de querer eliminar esta Item?</p>");
                            $("#modalFooter-item").html("").append(btnCancel).append(btnDelete);
                            $("#modal-item").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

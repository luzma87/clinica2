
<%@ page import="clinica.Pago" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
             Pagos
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewPago">
                    <i class="icon-file"></i>
                    Crear  Pago
                </a>
            </div>
            <div class="span3" id="busqueda-pago"></div>
        </div>

        <g:form action="delete" name="frmDelete-pago" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Pago" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <th>Usuario</th>
                    
                        <th>Paciente</th>
                    
                        <th>Item</th>
                    
                        <g:sortableColumn property="fecha" title="Fecha" />
                    
                        <g:sortableColumn property="valor" title="Valor" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${pagoInstanceList}" status="i" var="pagoInstance">
                    <tr class="fila" id="${pagoInstance.id}">
                    
                        <td>${fieldValue(bean: pagoInstance, field: "usuario")}</td>
                    
                        <td>${fieldValue(bean: pagoInstance, field: "paciente")}</td>
                    
                        <td>${fieldValue(bean: pagoInstance, field: "item")}</td>
                    
                        <td><g:formatDate date="${pagoInstance.fecha}" /></td>
                    
                        <td>${fieldValue(bean: pagoInstance, field: "valor")}</td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-pago">
            <div class="modal-header" id="modalHeader-pago">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-pago"></h3>
            </div>

            <div class="modal-body" id="modalBody-pago">
            </div>

            <div class="modal-footer" id="modalFooter-pago">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-pago").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-pago").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-pago"),
                    float          : "right"
                });

                $("#btnNewPago").click(function () {
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

                            $("#modalTitle-pago").html("Crear Pago");
                            $("#modalBody-pago").html(msg);
                            $("#modalFooter-pago").html("").append(btnCancel).append(btnSave);
                            $("#modal-pago").modal("show");
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
                                    $("#modalTitle-pago").html("Ver Pago");
                                    $("#modalBody-pago").html(msg);
                                    $("#modalFooter-pago").html("").append(btnOk);
                                    $("#modal-pago").modal("show");
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

                                    $("#modalTitle-pago").html("Editar Pago");
                                    $("#modalBody-pago").html(msg);
                                    $("#modalFooter-pago").html("").append(btnCancel).append(btnSave);
                                    $("#modal-pago").modal("show");
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
                                $("#frmDelete-pago").submit();
                                return false;
                            });

                            $("#modalTitle-pago").html("Eliminar Pago");
                            $("#modalBody-pago").html("<p>¿Está seguro de querer eliminar esta Pago?</p>");
                            $("#modalFooter-pago").html("").append(btnCancel).append(btnDelete);
                            $("#modal-pago").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

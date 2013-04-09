
<%@ page import="clinica.Clinica" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Clínicas
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewClinica">
                    <i class="icon-file"></i>
                    Crear  Clínica
                </a>
            </div>
            <div class="span3" id="busqueda-clinica"></div>
        </div>

        <g:form action="delete" name="frmDelete-clinica" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Clinica" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <g:sortableColumn property="nombre" title="Nombre" />
                    
                        <g:sortableColumn property="direccion" title="Dirección" />
                    
                        <g:sortableColumn property="telefono" title="Teléfono" />
                    
                        <g:sortableColumn property="observaciones" title="Observaciones" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${clinicaInstanceList}" status="i" var="clinicaInstance">
                    <tr class="fila" id="${clinicaInstance.id}">
                    
                        <td>${fieldValue(bean: clinicaInstance, field: "nombre")}</td>
                    
                        <td>${fieldValue(bean: clinicaInstance, field: "direccion")}</td>
                    
                        <td>${fieldValue(bean: clinicaInstance, field: "telefono")}</td>
                    
                        <td>${fieldValue(bean: clinicaInstance, field: "observaciones")}</td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-clinica">
            <div class="modal-header" id="modalHeader-clinica">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-clinica"></h3>
            </div>

            <div class="modal-body" id="modalBody-clinica">
            </div>

            <div class="modal-footer" id="modalFooter-clinica">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-clinica").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-clinica").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-clinica"),
                    float          : "right"
                });

                $("#btnNewClinica").click(function () {
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

                            $("#modalTitle-clinica").html("Crear Clínica");
                            $("#modalBody-clinica").html(msg);
                            $("#modalFooter-clinica").html("").append(btnCancel).append(btnSave);
                            $("#modal-clinica").modal("show");
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
                                    $("#modalTitle-clinica").html("Ver Clínica");
                                    $("#modalBody-clinica").html(msg);
                                    $("#modalFooter-clinica").html("").append(btnOk);
                                    $("#modal-clinica").modal("show");
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

                                    $("#modalTitle-clinica").html("Editar Clínica");
                                    $("#modalBody-clinica").html(msg);
                                    $("#modalFooter-clinica").html("").append(btnCancel).append(btnSave);
                                    $("#modal-clinica").modal("show");
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
                                $("#frmDelete-clinica").submit();
                                return false;
                            });

                            $("#modalTitle-clinica").html("Eliminar Clínica");
                            $("#modalBody-clinica").html("<p>¿Está seguro de querer eliminar esta Clínica?</p>");
                            $("#modalFooter-clinica").html("").append(btnCancel).append(btnDelete);
                            $("#modal-clinica").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

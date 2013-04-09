
<%@ page import="clinica.TipoCirugia" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Tipo Cirugias
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewTipoCirugia">
                    <i class="icon-file"></i>
                    Crear  Tipo Cirugia
                </a>
            </div>
            <div class="span3" id="busqueda-tipocirugia"></div>
        </div>

        <g:form action="delete" name="frmDelete-tipocirugia" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-TipoCirugia" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    
                        <g:sortableColumn property="nombre" title="Nombre" />

                        <g:sortableColumn property="duracionHoras" title="Duración" />

                        <g:sortableColumn property="valor" title="Valor" />
                    
                        <g:sortableColumn property="costo" title="Costo" />
                    
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="${tipoCirugiaInstanceList}" status="i" var="tipoCirugiaInstance">
                    <tr class="fila" id="${tipoCirugiaInstance.id}">
                    
                        <td>${fieldValue(bean: tipoCirugiaInstance, field: "nombre")}</td>

                        <td>${tipoCirugiaInstance.duracionHoras}:${tipoCirugiaInstance.duracionMinutos}</td>

                        <td>${fieldValue(bean: tipoCirugiaInstance, field: "valor")}</td>
                    
                        <td>${fieldValue(bean: tipoCirugiaInstance, field: "costo")}</td>
                    
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-tipocirugia">
            <div class="modal-header" id="modalHeader-tipocirugia">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-tipocirugia"></h3>
            </div>

            <div class="modal-body" id="modalBody-tipocirugia">
            </div>

            <div class="modal-footer" id="modalFooter-tipocirugia">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-tipocirugia").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-tipocirugia").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-tipocirugia"),
                    float          : "right"
                });

                $("#btnNewTipoCirugia").click(function () {
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

                            $("#modalTitle-tipocirugia").html("Crear Tipo Cirugia");
                            $("#modalBody-tipocirugia").html(msg);
                            $("#modalFooter-tipocirugia").html("").append(btnCancel).append(btnSave);
                            $("#modal-tipocirugia").modal("show");
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
                                    $("#modalTitle-tipocirugia").html("Ver TipoCirugia");
                                    $("#modalBody-tipocirugia").html(msg);
                                    $("#modalFooter-tipocirugia").html("").append(btnOk);
                                    $("#modal-tipocirugia").modal("show");
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

                                    $("#modalTitle-tipocirugia").html("Editar TipoCirugia");
                                    $("#modalBody-tipocirugia").html(msg);
                                    $("#modalFooter-tipocirugia").html("").append(btnCancel).append(btnSave);
                                    $("#modal-tipocirugia").modal("show");
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
                                $("#frmDelete-tipocirugia").submit();
                                return false;
                            });

                            $("#modalTitle-tipocirugia").html("Eliminar TipoCirugia");
                            $("#modalBody-tipocirugia").html("<p>¿Está seguro de querer eliminar esta TipoCirugia?</p>");
                            $("#modalFooter-tipocirugia").html("").append(btnCancel).append(btnDelete);
                            $("#modal-tipocirugia").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

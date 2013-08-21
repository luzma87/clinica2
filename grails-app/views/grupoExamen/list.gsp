<%@ page import="clinica.GrupoExamen" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
             Grupo Examens
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
                <g:link controller="examen" class="btn btn-ajax">
                    <i class="icon-bar-chart"></i>
                    Exámenes
                </g:link>
                <a href="#" class="btn btn-ajax btn-new" id="btnNewGrupoExamen">
                    <i class="icon-file"></i>
                    Crear  Grupo Examen
                </a>
            </div>

            <div class="span3" id="busqueda-grupoexamen"></div>
        </div>

        <g:form action="delete" name="frmDelete-grupoexamen" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-GrupoExamen" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>

                        <g:sortableColumn property="nombre" title="Nombre"/>

                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${grupoExamenInstanceList}" status="i" var="grupoExamenInstance">
                        <tr class="fila" id="${grupoExamenInstance.id}">

                            <td>${fieldValue(bean: grupoExamenInstance, field: "nombre")}</td>

                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-grupoexamen">
            <div class="modal-header" id="modalHeader-grupoexamen">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-grupoexamen"></h3>
            </div>

            <div class="modal-body" id="modalBody-grupoexamen">
            </div>

            <div class="modal-footer" id="modalFooter-grupoexamen">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-grupoexamen").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-grupoexamen").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-grupoexamen"),
                    float          : "right"
                });

                $("#btnNewGrupoExamen").click(function () {
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

                            $("#modalTitle-grupoexamen").html("Crear Grupo Examen");
                            $("#modalBody-grupoexamen").html(msg);
                            $("#modalFooter-grupoexamen").html("").append(btnCancel).append(btnSave);
                            $("#modal-grupoexamen").modal("show");
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
                                        $("#modalTitle-grupoexamen").html("Ver GrupoExamen");
                                        $("#modalBody-grupoexamen").html(msg);
                                        $("#modalFooter-grupoexamen").html("").append(btnOk);
                                        $("#modal-grupoexamen").modal("show");
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

                                        $("#modalTitle-grupoexamen").html("Editar GrupoExamen");
                                        $("#modalBody-grupoexamen").html(msg);
                                        $("#modalFooter-grupoexamen").html("").append(btnCancel).append(btnSave);
                                        $("#modal-grupoexamen").modal("show");
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
                                    $("#frmDelete-grupoexamen").submit();
                                    return false;
                                });

                                $("#modalTitle-grupoexamen").html("Eliminar GrupoExamen");
                                $("#modalBody-grupoexamen").html("<p>¿Está seguro de querer eliminar esta GrupoExamen?</p>");
                                $("#modalFooter-grupoexamen").html("").append(btnCancel).append(btnDelete);
                                $("#modal-grupoexamen").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>

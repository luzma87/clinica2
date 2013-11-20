<%@ page import="clinica.Historia" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Historia clínica
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

        <div class="row" style="margin-bottom: 10px;">
            <div class="span9 btn-group" role="navigation">
                <g:link controller="paciente" action="list" class="btn">
                    <i class="icon-group"></i>
                    Pacientes
                </g:link>
                <a href="#" class="btn btn-ajax btn-new" id="btnNewHistoria">
                    <i class="icon-file"></i>
                    Crear  Historia
                </a>
            </div>

            <div class="span3" id="busqueda-historia"></div>
        </div>

        <g:form action="delete" name="frmDelete-historia" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <elm:datosPaciente paciente="${paciente}"/>

        <div id="list-Historia" role="main" style="margin-top: 10px;">
            <g:set var="colores" value="${['info', 'success', 'warning']}"/>
            <g:each in="${historiaInstanceList}" status="i" var="historiaInstance">
                <div class="alert alert-${colores[i % 3]} elemento" id="${historiaInstance.id}">
                    <h5><g:formatDate date="${historiaInstance.fecha}" format="dd-MM-yyyy"/></h5>
                    ${historiaInstance.descripcion}
                </div>
            </g:each>
        </div>

        <div class="modal bigModal hide fade" id="modal-historia">
            <div class="modal-header" id="modalHeader-historia">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-historia"></h3>
            </div>

            <div class="modal-body" id="modalBody-historia">
            </div>

            <div class="modal-footer" id="modalFooter-historia">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-historia").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-historia").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-historia"),
                    float          : "right"
                });

                $("#btnNewHistoria").click(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        data    : {
                            paciente : "${paciente.id}"
                        },
                        success : function (msg) {
                            var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            $("#modalHeader-historia").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle-historia").html("Crear Historia");
                            $("#modalBody-historia").html(msg);
                            $("#modalFooter-historia").html("").append(btnCancel).append(btnSave);
                            $("#modal-historia").modal("show");
                        }
                    });
                    return false;
                }); //click btn new

                $.contextMenu({
                    selector : '.elemento',
                    items    : {
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
                                        id       : id,
                                        paciente : "${paciente.id}"
                                    },
                                    success : function (msg) {
                                        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                                        btnSave.click(function () {
                                            submitForm(btnSave);
                                            return false;
                                        });

                                        $("#modalHeader-historia").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
                                        $("#modalTitle-historia").html("Editar Historia");
                                        $("#modalBody-historia").html(msg);
                                        $("#modalFooter-historia").html("").append(btnCancel).append(btnSave);
                                        $("#modal-historia").modal("show");
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
                                    $("#frmDelete-historia").submit();
                                    return false;
                                });

                                $("#modalHeader-historia").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
                                $("#modalTitle-historia").html("Eliminar Historia");
                                $("#modalBody-historia").html("<p>¿Está seguro de querer eliminar esta Historia?</p>");
                                $("#modalFooter-historia").html("").append(btnCancel).append(btnDelete);
                                $("#modal-historia").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>

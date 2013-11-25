<%@ page import="clinica.Paciente" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Pacientes
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
                <a href="#" class="btn btn-ajax btn-new" id="btnNewPaciente">
                    <i class="icon-file"></i>
                    Crear  Paciente
                </a>
            </div>

            <div class="span3" id="busqueda-paciente"></div>
        </div>

        <g:form action="delete" name="frmDelete-paciente" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Paciente" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <th style="width:80px;">Cédula</th>
                        <g:sortableColumn property="apellidos" title="Apellidos"/>
                        <g:sortableColumn property="nombres" title="Nombres"/>
                        <th>Email</th>
                        <th style="width:80px;">Teléfono</th>
                        <g:sortableColumn property="fechaNacimiento" title="Fecha Nacimiento" style="width:125px;"/>
                        <th>Edad</th>
                        <g:sortableColumn property="sexo" title="Sexo" style="width:65px;"/>
                        <g:sortableColumn property="fuma" title="Fuma" style="width:50px;"/>
                        <g:sortableColumn property="bebe" title="Bebe" style="width:50px;"/>
                        <g:sortableColumn property="drogas" title="Drogas" style="width:50px;"/>

                        <th>Alergias</th>
                        <th>Examenes</th>
                        <th>Cirug&iacute;as</th>
                        <th>Controles</th>
                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${pacienteInstanceList}" status="i" var="pacienteInstance">
                        <tr class="fila" id="${pacienteInstance.id}">
                            <td>${fieldValue(bean: pacienteInstance, field: "cedula")}</td>
                            <td>${fieldValue(bean: pacienteInstance, field: "apellidos")}</td>
                            <td>${fieldValue(bean: pacienteInstance, field: "nombres")}</td>
                            <td>${fieldValue(bean: pacienteInstance, field: "email")}</td>
                            <td>${fieldValue(bean: pacienteInstance, field: "telefono")}</td>
                            <td><g:formatDate date="${pacienteInstance.fechaNacimiento}" format="dd-MM-yyyy"/></td>
                            <td><elm:edad paciente="${pacienteInstance}"/></td>
                            <td>${pacienteInstance.sexo.descripcion}</td>
                            <td>
                                <g:formatBoolean boolean="${pacienteInstance.fuma}" true="Si" false="No"/>
                                ${pacienteInstance.fuma ? pacienteInstance.fumaDesc : ''}
                            </td>
                            <td>
                                <g:formatBoolean boolean="${pacienteInstance.bebe}" true="Si" false="No"/>
                                ${pacienteInstance.bebe ? pacienteInstance.bebeDesc : ''}
                            </td>
                            <td>
                                <g:formatBoolean boolean="${pacienteInstance.drogas}" true="Si" false="No"/>
                                ${pacienteInstance.drogas ? pacienteInstance.drogasDesc : ''}
                            </td>
                            <td>${pacienteInstance.alergias.size()}</td>
                            <td>${clinica.ResultadoExamen.countByPacienteAndUsuario(pacienteInstance, session.user)}</td>
                            <td>${pacienteInstance.getCirugias(session.user).size()}</td>
                            <td>${pacienteInstance.getControles(session.user).size()}</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-paciente">
            <div class="modal-header" id="modalHeader-paciente">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-paciente"></h3>
            </div>

            <div class="modal-body" id="modalBody-paciente">
            </div>

            <div class="modal-footer" id="modalFooter-paciente">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-paciente").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-paciente").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-paciente"),
                    float          : "right"
                });

                $("#btnNewPaciente").click(function () {
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

                            $("#modalTitle-paciente").html("Crear Paciente");
                            $("#modalBody-paciente").html(msg);
                            $("#modalFooter-paciente").html("").append(btnCancel).append(btnSave);
                            $("#modal-paciente").modal("show");
                        }
                    });
                    return false;
                }); //click btn new

                $.contextMenu({
                    selector : '.fila',
                    items    : {
                        "show"      : {
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
                                        $("#modalTitle-paciente").html("Ver Paciente");
                                        $("#modalBody-paciente").html(msg);
                                        $("#modalFooter-paciente").html("").append(btnOk);
                                        $("#modal-paciente").modal("show");
                                    }
                                });
                            }
                        },
                        "edit"      : {
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

                                        $("#modalTitle-paciente").html("Editar Paciente");
                                        $("#modalBody-paciente").html(msg);
                                        $("#modalFooter-paciente").html("").append(btnCancel).append(btnSave);
                                        $("#modal-paciente").modal("show");
                                    }
                                });
                            }
                        },
                        "sep1"      : "---------",
                        "alergia"   : {
                            name     : "Alergias",
                            icon     : "alergia",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'alergiaPaciente', action:'list_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                                        btnCancel.click(function () {
                                            location.reload(true);
                                        });
                                        $("#modalTitle-paciente").html("Alergias Paciente");
                                        $("#modalBody-paciente").html(msg);
                                        $("#modalFooter-paciente").html("").append(btnCancel);
                                        $("#modal-paciente").modal("show");
                                    }
                                });
                            }
                        },
                        "sep2"      : "---------",
                        "control"   : {
                            name     : "Controles",
                            icon     : "control",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                var url = "${createLink(controller: 'control', action: 'list')}/" + id
                                location.href = url;
                            }
                        },
                        "examen"    : {
                            name     : "Exámenes",
                            icon     : "examen",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                var url = "${createLink(controller: 'resultadoExamen', action: 'list')}/" + id
                                location.href = url;
                            }
                        },
                        "cirugia"   : {
                            name     : "Cirugías",
                            icon     : "cirugia",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                var url = "${createLink(controller: 'cirugia', action: 'list')}/" + id
                                location.href = url;
                            }
                        },
                        "historial" : {
                            name     : "Historia clínica",
                            icon     : "historial",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                var url = "${createLink(controller: 'historia', action: 'list')}/" + id
                                location.href = url;
                            }
                        },
                        "sep3"      : "---------",
                        "resumen"   : {
                            name     : "Resumen",
                            icon     : "resumen",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                var url = "${createLink( action: 'resumen')}/" + id
                                location.href = url;
                            }
                        },
                        "sep4"      : "---------",
                        "delete"    : {
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
                                    $("#frmDelete-paciente").submit();
                                    return false;
                                });

                                $("#modalTitle-paciente").html("Eliminar Paciente");
                                $("#modalBody-paciente").html("<p>¿Está seguro de querer eliminar esta Paciente?</p>");
                                $("#modalFooter-paciente").html("").append(btnCancel).append(btnDelete);
                                $("#modal-paciente").modal("show");
                            }
                        }
                    }
                });

            });

        </script>

    </body>
</html>

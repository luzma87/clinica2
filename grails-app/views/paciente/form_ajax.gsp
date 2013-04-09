<%@ page import="clinica.Paciente" %>

<g:form class="form-horizontal" name="frmSave-paciente" action="save">
    <g:hiddenField name="id" value="${pacienteInstance?.id}"/>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Cédula
            </span>
        </div>

        <div class="controls">
            <g:textField name="cedula" maxlength="10" class=" required cedula" autocomplete="off" value="${pacienteInstance?.cedula}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Nombres
            </span>
        </div>

        <div class="controls">
            <g:textField name="nombres" cols="40" rows="5" maxlength="255" class=" required" value="${pacienteInstance?.nombres}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Apellidos
            </span>
        </div>

        <div class="controls">
            <g:textField name="apellidos" cols="40" rows="5" maxlength="255" class=" required" value="${pacienteInstance?.apellidos}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Fecha Nacimiento
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fechaNacimiento" class=" required" value="${pacienteInstance?.fechaNacimiento}"
                            maxDate="new Date()" yearRange="-100:+0"/>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Sexo
            </span>
        </div>

        <div class="controls">
            <g:select id="sexo" name="sexo.id" from="${clinica.Sexo.list()}" optionKey="id" optionValue="descripcion"
                      class="many-to-one  required" value="${pacienteInstance?.sexo?.id}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Dirección
            </span>
        </div>

        <div class="controls">
            <g:textArea name="direccion" cols="40" rows="5" maxlength="1023" class="" value="${pacienteInstance?.direccion}"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Teléfono
            </span>
        </div>

        <div class="controls">
            <g:textField name="telefono" maxlength="31" class="" value="${pacienteInstance?.telefono}"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Email
            </span>
        </div>

        <div class="controls">
            <g:field type="email" name="email" maxlength="65" class="" value="${pacienteInstance?.email}"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Fuma
            </span>
        </div>

        <div class="controls">
            <g:checkBox name="fuma" class="check" value="${pacienteInstance?.fuma}"/>
            <g:textArea name="fumaDesc" value="${pacienteInstance?.fumaDesc}" class="input-large ${pacienteInstance?.fuma ? '' : 'hide'}"/>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Bebe
            </span>
        </div>

        <div class="controls">
            <g:checkBox name="bebe" class="check" value="${pacienteInstance?.bebe}"/>
            <g:textArea name="bebeDesc" value="${pacienteInstance?.bebeDesc}" class="input-large  ${pacienteInstance?.bebe ? '' : 'hide'}"/>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Drogas
            </span>
        </div>

        <div class="controls">
            <g:checkBox name="drogas" class="check" value="${pacienteInstance?.drogas}"/>
            <g:textArea name="drogasDesc" value="${pacienteInstance?.drogasDesc}" class="input-large  ${pacienteInstance?.drogas ? '' : 'hide'}"/>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:form>


<div class="modal hide fade" id="modal-pacienteImport">
    <div class="modal-header" id="modalHeader-pacienteImport">
        <button type="button" class="close darker" data-dismiss="modal">
            <i class="icon-remove-circle"></i>
        </button>

        <h3 id="modalTitle-pacienteImport"></h3>
    </div>

    <div class="modal-body" id="modalBody-pacienteImport">
    </div>

    <div class="modal-footer" id="modalFooter-pacienteImport">
    </div>
</div>

<script type="text/javascript">
    var dataErr;

    $(".check").click(function () {
        var id = $(this).attr("id");
        var checked = $(this).is(":checked")
        var $elm = $("#" + id + "Desc");
        if (checked) {
            $elm.show();
        } else {
            $elm.hide();
        }
    });

    $("#frmSave-paciente").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        rules          : {
            cedula : {
                remote : {
                    url        : "${createLink(action: 'checkCi_ajax')}",
                    type       : "post",
                    data       : {
                        id : "${pacienteInstance.id}"
                    },
                    dataFilter : function (data) {
                        dataErr = data;
                        return data;
                    },
                    complete   : function () {
                        if (dataErr == "false") {
                            var sp = $("[for=cedula]");

                            var $importar = $("<a href='#'>Ver</a>");

                            $importar.click(function () {
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'show_ajax')}",
                                    data    : {
                                        ci : $("#cedula").val()
                                    },
                                    success : function (msg) {
                                        var btnOk = $('<a href="#" class="btn btn-primary">Aceptar</a>');
                                        btnOk.click(function () {
                                            $("#modal-pacienteImport").modal("hide");
                                        });
                                        var btnImport = $('<a href="#" class="btn btn-success">Importar</a>');
                                        btnImport.click(function () {
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action:'importar')}",
                                                data    : {
                                                    ci : $("#cedula").val()
                                                },
                                                success : function (msg) {
                                                    btnImport.replaceWith(spinner);
                                                    location.reload(true);
                                                }
                                            });
                                        });
                                        $("#modalTitle-pacienteImport").html("Ver Paciente");
                                        $("#modalBody-pacienteImport").html(msg);
                                        $("#modalFooter-pacienteImport").html("").append(btnOk).append(btnImport);
                                        $("#modal-pacienteImport").modal("show");
                                    }
                                });
                            });

                            sp.parent().append($importar);
                        }
                    }
                }
            }
        },
        messages       : {
            cedula : {
                remote : "Paciente ya ingresado"
            }
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });
</script>

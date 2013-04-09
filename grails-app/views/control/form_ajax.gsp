<%@ page import="clinica.TipoItem; clinica.Item" %>

<g:form class="form-horizontal" name="frmSave-control" action="save">
    <g:hiddenField name="id" value="${controlInstance?.id}"/>
    <g:hiddenField name="tipo" value=""/>
    <g:hiddenField name="paciente.id" id="pac" value="${controlInstance?.pacienteId}"/>
    <g:if test="${!controlInstance?.paciente}">
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Paciente c&eacute;dula
                </span>
            </div>

            <div class="controls">
                <g:textField name="cedula" class="required cedula"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Paciente
                </span>
            </div>

            <div class="controls">
                <span class="uneditable-input" id="spNombre"></span>
            </div>
        </div>
    </g:if>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Fecha
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fecha" class="input-small required" value="${controlInstance?.fecha}"/>
            <g:select name="hora" from="${0..23}" class="input-mini"
                      optionValue="${{ it.toString().padLeft(2, '0') }}" value="${controlInstance?.fecha?.format('HH')}"/>
            <g:select name="min" from="${0..59}" class="input-mini"
                      optionValue="${{ it.toString().padLeft(2, '0') }}" value="${controlInstance?.fecha?.format('mm')}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Duraci&oacute;n
            </span>
        </div>

        <div class="controls">
            %{--<g:textField name="duracion" class="required number"/>--}%
            <div class="input-append">
                <g:textField class="input-mini required digits" name="duracionHoras" type="text" value="${controlInstance?.duracionHoras ?: 0}"/>
                <span class="add-on">horas</span>
            </div>

            <div class="input-append">
                <g:textField class="input-mini required digits" name="duracionMinutos" type="text" value="${controlInstance?.duracionMinutos ?: 0}"/>
                <span class="add-on">minutos</span>
            </div>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Por cobrar
            </span>
        </div>

        <div class="controls">
            <div class="input-append">
                <g:field type="number" name="valor" class="input-small number required" value="${fieldValue(bean: controlInstance, field: 'valor')}"/>
                <span class="add-on">$</span>
            </div>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Hasta el
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fechaCobro" class=" input-small" value="${cirugiaInstance?.fechaCobro}"/>
            <span class="mandatory"></span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Por pagar
            </span>
        </div>

        <div class="controls">
            <div class="input-append">
                <g:field type="number" name="costo" class="input-small number required" value="${fieldValue(bean: controlInstance, field: 'costo')}"/>
                <span class="add-on">$</span>
            </div>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Hasta el
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fechaPago" class=" input-small" value="${cirugiaInstance?.fechaPago}"/>
            <span class="mandatory"></span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Estado
            </span>
        </div>

        <div class="controls">
            <g:select name="estadoItem.id" from="${clinica.EstadoItem.findAllByTipoItem(TipoItem.findByCodigo('O'), [sort: 'descripcion'])}"
                      optionKey="id" optionValue="descripcion" value="${controlInstance?.estadoItemId}" class="required"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Observaciones
            </span>
        </div>

        <div class="controls">
            <g:textArea name="observaciones" cols="40" rows="5" maxlength="1023" class="" value="${controlInstance?.observaciones}"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:form>

<script type="text/javascript">
    $("#cedula").blur(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'findPaciente_ajax')}",
            data    : {
                ci : $("#cedula").val()
            },
            success : function (msg) {
                var parts = msg.split("_");
                if (parts[0] == "OK") {
                    $("#pac").val(parts[1]);
                    $("#spNombre").html(parts[2]);
                }
            }
        });
    });

    $(".digits").keydown(function (ev) {
        return validarNumInt(ev);
    });
    $(".number").keydown(function (ev) {
        return validarNumDec(ev);
    });

    $("#frmSave-control").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });
</script>

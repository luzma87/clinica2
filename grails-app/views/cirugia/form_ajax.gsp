<%@ page import="clinica.TipoItem; clinica.Item" %>

<g:uploadForm class="form-horizontal" name="frmSave-cirugia" action="save">
    <g:hiddenField name="id" value="${cirugiaInstance?.id}"/>
    <g:hiddenField name="paciente.id" id="pac" value="${cirugiaInstance?.pacienteId}"/>
    <g:hiddenField name="tipo" value=""/>
    <g:if test="${!cirugiaInstance?.paciente}">
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Paciente c&eacute;dula
                </span>
            </div>

            <div class="controls">
                <g:textField name="cedula" class="required cedula" autocomplete="off"/>
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
                Clínica
            </span>
        </div>

        <div class="controls">
            %{--<g:select id="clinica" name="clinica.id" from="${clinica.Clinica.list()}" optionKey="id" class="many-to-one  required" value="${cirugiaInstance?.clinica?.id}"/>--}%
            <g:textField name="clinica" class="required autocomplete" value="${cirugiaInstance?.clinica?.nombre}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Cirugía
            </span>
        </div>

        <div class="controls">
            %{--<g:select id="clinica" name="clinica.id" from="${clinica.Clinica.list()}" optionKey="id" class="many-to-one  required" value="${cirugiaInstance?.clinica?.id}"/>--}%
            <g:textField name="cirugia" class="required autocomplete" value="${cirugiaInstance?.tipoCirugia?.nombre}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Fecha
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fecha" class=" required input-small" value="${cirugiaInstance?.fecha}"/>
            <g:select name="hora" from="${0..23}" class="input-mini"
                      optionValue="${{ it.toString().padLeft(2, '0') }}" value="${cirugiaInstance?.fecha?.format('HH')}"/>
            <g:select name="min" from="${0..59}" class="input-mini"
                      optionValue="${{ it.toString().padLeft(2, '0') }}" value="${cirugiaInstance?.fecha?.format('mm')}"/>
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
                <g:textField class="input-mini required digits" name="duracionHoras" type="text" value="${cirugiaInstance?.duracionHoras ?: 0}"/>
                <span class="add-on">horas</span>
            </div>

            <div class="input-append">
                <g:textField class="input-mini required digits" name="duracionMinutos" type="text" value="${cirugiaInstance?.duracionMinutos ?: 0}"/>
                <span class="add-on">minutos</span>
            </div>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Razón
            </span>
        </div>

        <div class="controls">
            <g:textArea name="razon" class=" required" value="${cirugiaInstance?.razon}"/>
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
                <g:field type="number" name="valor" class="input-small number required" value="${fieldValue(bean: cirugiaInstance, field: 'valor')}"/>
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
                <g:field type="number" name="costo" class="input-small number required" value="${fieldValue(bean: cirugiaInstance, field: 'costo')}"/>
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
            <g:select name="estadoItem.id" from="${clinica.EstadoItem.findAllByTipoItem(TipoItem.findByCodigo('I'), [sort: 'descripcion'])}"
                      optionKey="id" optionValue="descripcion" value="${cirugiaInstance?.estadoItemId}" class="required"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Foto Antes
            </span>
        </div>

        <div class="controls">
            %{--<g:if test="${cirugiaInstance?.fotoAntes}">--}%
            %{--<elm:imagenCirugia cirugia="${cirugiaInstance}" tipo="antes" group="false" class="mini"/>--}%
            %{--</g:if>--}%
            %{--<g:else>--}%
            <input type="file" name="ffotoAntes"/>
            %{--</g:else>--}%

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Foto Después
            </span>
        </div>

        <div class="controls">
            %{--<g:if test="${cirugiaInstance?.fotoDespues}">--}%
            %{--<elm:imagenCirugia cirugia="${cirugiaInstance}" tipo="despues" group="false" class="mini"/>--}%
            %{--</g:if>--}%
            %{--<g:else>--}%
            <input type="file" name="ffotoDespues"/>
            %{--</g:else>--}%

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
            <g:textField name="observaciones" class="" value="${cirugiaInstance?.observaciones}"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:uploadForm>

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

    $("#frmSave-cirugia").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        }
    });

    $(".digits").keydown(function (ev) {
        return validarNumInt(ev);
    });

    $(".number").keydown(function (ev) {
        return validarNumDec(ev);
    });

    $(".datepicker").keydown(function () {
        return false;
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });

    $("#clinica").autocomplete({
        source : function (request, response) {
            var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
            response($.grep(${clinicas}, function (value) {
                value = value.label || value.value || value;
                console.log(value)
                return matcher.test(value) || matcher.test(value.arreglar());
            }));
        }
    });

    $("#cirugia").autocomplete({
        source : function (request, response) {
            var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
            response($.grep(${cirugias}, function (value) {
                value = value.label || value.value || value;
                return matcher.test(value) || matcher.test(value.arreglar());
            }));
        },
        select : function (event, ui) {
            $("#cirugia").val(ui.item.label);
            $("#duracionHoras").val(ui.item.duracionH);
            $("#duracionMinutos").val(ui.item.duracionM);
            $("#valor").val(ui.item.valor);
            $("#costo").val(ui.item.costo);
            return false;
        }
    });

</script>

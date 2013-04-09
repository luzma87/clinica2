<%@ page import="clinica.TipoCirugia" %>

<g:form class="form-horizontal" name="frmSave-tipocirugia" action="save">
    <g:hiddenField name="id" value="${tipoCirugiaInstance?.id}"/>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Nombre
            </span>
        </div>

        <div class="controls">
            <g:textArea name="nombre" cols="40" rows="5" maxlength="255" class=" required" value="${tipoCirugiaInstance?.nombre}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Duración
            </span>
        </div>

        <div class="controls">
            %{--<g:field type="number" name="duracionHoras" class="digits required" value="${fieldValue(bean: tipoCirugiaInstance, field: 'duracionHoras')}"/>--}%
            <div class="input-append">
                <g:textField class="input-mini required digits" name="duracionHoras" type="text" value="${tipoCirugiaInstance?.duracionHoras ?: 0}"/>
                <span class="add-on">horas</span>
            </div>

            <div class="input-append">
                <g:textField class="input-mini required digits" name="duracionMinutos" type="text" value="${tipoCirugiaInstance?.duracionMinutos ?: 0}"/>
                <span class="add-on">minutos</span>
            </div>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Valor
            </span>
        </div>

        <div class="controls">
            <div class="input-append">
                <g:field type="number" name="valor" class="input-small number required" value="${fieldValue(bean: tipoCirugiaInstance, field: 'valor')}"/>
                <span class="add-on">$</span>
            </div>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Costo
            </span>
        </div>

        <div class="controls">
            <div class="input-append">
                <g:field type="number" name="costo" class="input-small number required" value="${fieldValue(bean: tipoCirugiaInstance, field: 'costo')}"/>
                <span class="add-on">$</span>
            </div>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-tipocirugia").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });

    $(".digits").keydown(function (ev) {
        return validarNumInt(ev);
    });

    $(".number").keydown(function (ev) {
        return validarNumDec(ev);
    });
</script>

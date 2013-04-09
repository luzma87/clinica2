<%@ page import="clinica.Pago" %>

<g:form class="form-horizontal" name="frmSave-pago" action="save">
    <g:hiddenField name="id" value="${pagoInstance?.id}"/>
    <g:hiddenField name="item.id" id="item" value="${pagoInstance?.itemId}"/>
    <g:hiddenField name="tipo" value="${pagoInstance?.tipo}"/>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Fecha
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fecha" class="input-small required" value="${pagoInstance?.fecha}"/>

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
                <g:field type="number" name="valor" class="input-small number required"
                         value="${fieldValue(bean: pagoInstance, field: 'valor')}"/>
                <span class="add-on">$</span>
            </div>
            de $<span id="max"></span>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-pago").validate({
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

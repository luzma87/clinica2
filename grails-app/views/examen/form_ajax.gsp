<%@ page import="clinica.Examen" %>

<g:form class="form-horizontal" name="frmSave-examen" action="save">
    <g:hiddenField name="id" value="${examenInstance?.id}"/>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Grupo Examen
            </span>
        </div>

        <div class="controls">
            %{--<g:select id="grupoExamen" name="grupoExamen.id" from="${clinica.GrupoExamen.list()}" optionKey="id" class="many-to-one  required" value="${examenInstance?.grupoExamen?.id}"/>--}%

            <g:textField name="grupoExamen" class="required autocomplete" value="${examenInstance?.grupoExamen?.nombre}"/>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Nombre
            </span>
        </div>

        <div class="controls">
            <g:textField name="nombre" class=" required" value="${examenInstance?.nombre}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Valor Inicial
            </span>
        </div>

        <div class="controls">
            <g:field type="number" name="valorInicial" class=" required" value="${fieldValue(bean: examenInstance, field: 'valorInicial')}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Valor Final
            </span>
        </div>

        <div class="controls">
            <g:field type="number" name="valorFinal" class=" required" value="${fieldValue(bean: examenInstance, field: 'valorFinal')}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-examen").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });

    $("#grupoExamen").autocomplete({
        source : function (request, response) {
            var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
            response($.grep(${grupos}, function (value) {
                value = value.label || value.value || value;
                return matcher.test(value) || matcher.test(value.arreglar());
            }));
        }
    });

</script>

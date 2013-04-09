
<%@ page import="clinica.Sexo" %>

<g:form class="form-horizontal" name="frmSave-sexo" action="save">
    <g:hiddenField name="id" value="${sexoInstance?.id}"/>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Descripcion
            </span>
        </div>

        <div class="controls">
            <g:textField name="descripcion" maxlength="40" class=" required" value="${sexoInstance?.descripcion}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Abreviacion
            </span>
        </div>

        <div class="controls">
            <g:textField name="abreviacion" maxlength="1" class=" required" value="${sexoInstance?.abreviacion}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
</g:form>

<script type="text/javascript">
    $("#frmSave-sexo").validate({
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

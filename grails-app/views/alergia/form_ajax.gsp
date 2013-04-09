
<%@ page import="clinica.Alergia" %>

<g:form class="form-horizontal" name="frmSave-alergia" action="save">
    <g:hiddenField name="id" value="${alergiaInstance?.id}"/>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Descripcion
            </span>
        </div>

        <div class="controls">
            <g:textField name="descripcion" maxlength="40" class=" required" value="${alergiaInstance?.descripcion}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
</g:form>

<script type="text/javascript">
    $("#frmSave-alergia").validate({
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

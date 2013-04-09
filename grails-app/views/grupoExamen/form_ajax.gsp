
<%@ page import="clinica.GrupoExamen" %>

<g:form class="form-horizontal" name="frmSave-grupoexamen" action="save">
    <g:hiddenField name="id" value="${grupoExamenInstance?.id}"/>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Nombre
            </span>
        </div>

        <div class="controls">
            <g:textArea name="nombre" cols="40" rows="5" maxlength="255" class=" required" value="${grupoExamenInstance?.nombre}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
</g:form>

<script type="text/javascript">
    $("#frmSave-grupoexamen").validate({
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

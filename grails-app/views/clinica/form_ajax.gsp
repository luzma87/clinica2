
<%@ page import="clinica.Clinica" %>

<g:form class="form-horizontal" name="frmSave-clinica" action="save">
    <g:hiddenField name="id" value="${clinicaInstance?.id}"/>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Nombre
            </span>
        </div>

        <div class="controls">
            <g:textField name="nombre" class=" required" value="${clinicaInstance?.nombre}"/>
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
            <g:textArea name="direccion" cols="40" rows="5" maxlength="511" class="" value="${clinicaInstance?.direccion}"/>
            
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
            <g:textField name="telefono" maxlength="31" class="" value="${clinicaInstance?.telefono}"/>
            
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
            <g:textArea name="observaciones" cols="40" rows="5" maxlength="1023" class="" value="${clinicaInstance?.observaciones}"/>
            
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
</g:form>

<script type="text/javascript">
    $("#frmSave-clinica").validate({
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

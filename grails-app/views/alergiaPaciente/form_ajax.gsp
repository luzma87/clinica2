
<%@ page import="clinica.AlergiaPaciente" %>

<g:form class="form-horizontal" name="frmSave-alergiapaciente" action="save">
    <g:hiddenField name="id" value="${alergiaPacienteInstance?.id}"/>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Paciente
            </span>
        </div>

        <div class="controls">
            <g:select id="paciente" name="paciente.id" from="${clinica.Paciente.list()}" optionKey="id" class="many-to-one  required" value="${alergiaPacienteInstance?.paciente?.id}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Alergia
            </span>
        </div>

        <div class="controls">
            <g:select id="alergia" name="alergia.id" from="${clinica.Alergia.list()}" optionKey="id" class="many-to-one  required" value="${alergiaPacienteInstance?.alergia?.id}"/>
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
            <elm:datepicker name="fecha" class=" required" value="${alergiaPacienteInstance?.fecha}"/>

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
            <g:textArea name="observaciones" cols="40" rows="5" maxlength="1023" class="" value="${alergiaPacienteInstance?.observaciones}"/>
            
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
</g:form>

<script type="text/javascript">
    $("#frmSave-alergiapaciente").validate({
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

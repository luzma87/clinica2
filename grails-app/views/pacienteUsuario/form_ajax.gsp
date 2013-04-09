
<%@ page import="clinica.PacienteUsuario" %>

<g:form class="form-horizontal" name="frmSave-pacienteusuario" action="save">
    <g:hiddenField name="id" value="${pacienteUsuarioInstance?.id}"/>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Usuario
            </span>
        </div>

        <div class="controls">
            <g:select id="usuario" name="usuario.id" from="${clinica.seguridad.Usuario.list()}" optionKey="id" class="many-to-one  required" value="${pacienteUsuarioInstance?.usuario?.id}"/>
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
            <g:select id="paciente" name="paciente.id" from="${clinica.Paciente.list()}" optionKey="id" class="many-to-one  required" value="${pacienteUsuarioInstance?.paciente?.id}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Fecha Registro
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fechaRegistro" class=" required" value="${pacienteUsuarioInstance?.fechaRegistro}"/>

            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
</g:form>

<script type="text/javascript">
    $("#frmSave-pacienteusuario").validate({
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

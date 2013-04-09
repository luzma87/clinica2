
<%@ page import="clinica.Item" %>

<g:form class="form-horizontal" name="frmSave-item" action="save">
    <g:hiddenField name="id" value="${itemInstance?.id}"/>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Usuario
            </span>
        </div>

        <div class="controls">
            <g:select id="usuario" name="usuario.id" from="${clinica.seguridad.Usuario.list()}" optionKey="id" class="many-to-one  required" value="${itemInstance?.usuario?.id}"/>
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
            <g:select id="paciente" name="paciente.id" from="${clinica.Paciente.list()}" optionKey="id" class="many-to-one  required" value="${itemInstance?.paciente?.id}"/>
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
            <elm:datepicker name="fecha" class=" required" value="${itemInstance?.fecha}"/>

            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Razon
            </span>
        </div>

        <div class="controls">
            <g:textField name="razon" class=" required" value="${itemInstance?.razon}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Clinica
            </span>
        </div>

        <div class="controls">
            <g:select id="clinica" name="clinica.id" from="${clinica.Clinica.list()}" optionKey="id" class="many-to-one " value="${itemInstance?.clinica?.id}" noSelection="['null': '']"/>
            
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
            <g:textField name="observaciones" class="" value="${itemInstance?.observaciones}"/>
            
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
            <g:field type="number" name="valor" class=" required" value="${fieldValue(bean: itemInstance, field: 'valor')}"/>
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
            <g:field type="number" name="costo" class=" required" value="${fieldValue(bean: itemInstance, field: 'costo')}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Tipo Cirugia
            </span>
        </div>

        <div class="controls">
            <g:select id="tipoCirugia" name="tipoCirugia.id" from="${clinica.TipoCirugia.list()}" optionKey="id" class="many-to-one " value="${itemInstance?.tipoCirugia?.id}" noSelection="['null': '']"/>
            
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Tipo Item
            </span>
        </div>

        <div class="controls">
            <g:select id="tipoItem" name="tipoItem.id" from="${clinica.TipoItem.list()}" optionKey="id" class="many-to-one  required" value="${itemInstance?.tipoItem?.id}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Estado Item
            </span>
        </div>

        <div class="controls">
            <g:select id="estadoItem" name="estadoItem.id" from="${clinica.EstadoItem.list()}" optionKey="id" class="many-to-one  required" value="${itemInstance?.estadoItem?.id}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Cobrado
            </span>
        </div>

        <div class="controls">
            <g:checkBox name="cobrado" value="${itemInstance?.cobrado}" />
            
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Duracion Horas
            </span>
        </div>

        <div class="controls">
            <g:field type="number" name="duracionHoras" class=" required" value="${fieldValue(bean: itemInstance, field: 'duracionHoras')}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Duracion Minutos
            </span>
        </div>

        <div class="controls">
            <g:field type="number" name="duracionMinutos" class=" required" value="${fieldValue(bean: itemInstance, field: 'duracionMinutos')}"/>
            <span class="mandatory">*</span>
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Pagado
            </span>
        </div>

        <div class="controls">
            <g:checkBox name="pagado" value="${itemInstance?.pagado}" />
            
            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>
            
</g:form>

<script type="text/javascript">
    $("#frmSave-item").validate({
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

<%@ page import="clinica.Historia" %>

<script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/ckeditor', file: 'ckeditor.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/ckeditor/adapters', file: 'jquery.js')}"></script>

<g:form class="form-horizontal" name="frmSave-historia" action="save">
    <g:hiddenField name="id" value="${historiaInstance?.id}"/>
    <g:hiddenField name="paciente.id" id="pac" value="${historiaInstance?.pacienteId}"/>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Fecha
            </span>
        </div>

        <div class="controls">
            <elm:datepicker name="fecha" class=" required" value="${historiaInstance?.fecha}"/>

            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <g:textArea name="descripcion" class="" value="${historiaInstance?.descripcion}"
                    style="width: 515px; height: 285px;"/>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-historia").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });

    $('textarea').ckeditor({
        height : 300
    });
</script>

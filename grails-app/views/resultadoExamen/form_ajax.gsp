<%@ page import="clinica.ResultadoExamen" %>

<g:form class="form-horizontal" name="frmSave-resultadoexamen" action="save">
    <g:hiddenField name="id" value="${resultadoExamenInstance?.id}"/>
    <g:hiddenField name="paciente.id" value="${resultadoExamenInstance?.pacienteId}"/>


    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Grupo Examen
            </span>
        </div>

        <div class="controls">
            <g:select id="grupoExamen" name="grupoExamen" from="${clinica.GrupoExamen.list([sort: 'nombre'])}"
                      optionKey="id" optionValue="nombre"
                      class="many-to-one  required"
                      value="${resultadoExamenInstance?.examen?.id}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Examen
            </span>
        </div>

        <div class="controls">
            <g:set var="first" value="${clinica.Examen.findAllByGrupoExamen(clinica.GrupoExamen.list([sort: 'nombre'])[0])[0]}"/>
            <span id="selExm">
                <elm:select id="examen" name="examen.id" value="${resultadoExamenInstance?.examen?.id}"
                            from="${clinica.Examen.findAllByGrupoExamen(clinica.GrupoExamen.list([sort: 'nombre'])[0])}"
                            optionKey="id" class="many-to-one required"
                            optionClass="${{ it.valorInicial + ' - ' + it.valorFinal }}"
                            optionValue="nombre"/>
            </span>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Resultado
            </span>
        </div>

        <div class="controls">
            <g:field type="number" name="resultado" class=" required" value="${fieldValue(bean: resultadoExamenInstance, field: 'resultado')}"/>
            <span class="mandatory">*</span>
            <span id="valoresNormales" class="label label-info">
                ${first?.valorInicial} - ${first?.valorFinal}
            </span>

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
            <elm:datepicker name="fecha" class=" required" value="${resultadoExamenInstance?.fecha}"/>

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
            <g:textField name="observaciones" class=" required" value="${resultadoExamenInstance?.observaciones}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-resultadoexamen").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        }
    });

    function updateValorNormal() {
        var vn = $("#examen option:selected").attr("class");
        if (vn) {
            $("#valoresNormales").text(vn);
        } else {
            $("#valoresNormales").text("");
        }
    }

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });

    $("#examen").change(function () {
        updateValorNormal();
    });

    $("#grupoExamen").change(function () {
        var id = $(this).val();
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'examenesGrupo')}",
            data    : {
                id : id
            },
            success : function (msg) {
                $("#selExm").html(msg);
                updateValorNormal();
            }
        })
    });
</script>

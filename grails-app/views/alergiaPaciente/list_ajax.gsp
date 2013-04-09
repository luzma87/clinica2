<g:hiddenField name="paciente.id" value="${cirugiaInstance?.pacienteId}"/>

<div class="row">
    <div class="span2">Alergia</div>

    <div class="span3">Observaciones</div>
</div>

<div class="row">
    <div class="span2">
        <g:textField name="alergia" class="required autocomplete span2"/>
    </div>

    <div class="span">
        <g:textArea name="observaciones" class="required span3"/>

        <a href="#" id="btnAdd" class="btn btn-success" rel="tooltip" title="Agregar">
            <i class="icon-plus"></i>
        </a>
    </div>
</div>

<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
        <tr>
            <th>Alergia</th>
            <th>Fecha</th>
            <th>Observaciones</th>
            <th style="width:37px;"></th>
        </tr>
    </thead>
    <tbody id="tbl">

    </tbody>
</table>

<script type="text/javascript">
    function loadTabla() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'loadList')}",
            data    : {
                paciente : "${paciente.id}"
            },
            success : function (msg) {
                $("#tbl").html(msg);
            }
        });
    }

    loadTabla();

    $('[rel=tooltip]').tooltip();
    $("#alergia").autocomplete({
        source : function (request, response) {
            var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
            response($.grep(${alergias}, function (value) {
                value = value.label || value.value || value;
                return matcher.test(value) || matcher.test(value.arreglar());
            }));
        }
    });

    $("#btnAdd").click(function () {
        var btn = $(this);
        btn.hide().next(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'save')}",
            data    : {
                paciente      : "${paciente.id}",
                alergia       : $("#alergia").val(),
                observaciones : $("#observaciones").val()
            },
            success : function (msg) {
                loadTabla();
                spinner.remove();
                btn.show();
                $("#alergia").val("");
                $("#observaciones").val("");
            }
        });
    });
</script>
<g:each in="${alergias}" var="al">
    <tr>
        <td>${al.alergia.descripcion}</td>
        <td><g:formatDate date="${al.fecha}" format="dd-MM-yyyy"/></td>
        <td>${al.observaciones}</td>
        <td>
            <a href="#" id="${al.id}" class="btn btn-danger deleteAl">
                <i class="icon-trash"></i>
            </a>
        </td>
    </tr>
</g:each>

<script type="text/javascript">
    $(".deleteAl").click(function () {
        var btn = $(this);
        btn.hide().next(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'deleteAl')}",
            data    : {
                id : btn.attr("id")
            },
            success : function (msg) {
                loadTabla();
            }
        });
    });
</script>
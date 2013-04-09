<h3>Antes</h3>
<elm:imagenCirugia cirugia="${cirugia}" tipo="antes" class="mini delete" fancy="false"/>
<h3>Despu&eacute;s</h3>
<elm:imagenCirugia cirugia="${cirugia}" tipo="despues" class="mini delete" fancy="false"/>

<script type="text/javascript">
    $(".mini.delete").css("cursor", "pointer").click(function () {
        var f = $(this);
        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
        var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');
        var nombre = f.data("file");
        var tipo = f.data("tipo");
        btnDelete.click(function () {
            btnDelete.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'delPic')}",
                data    : {
                    id   : "${cirugia.id}",
                    file : nombre,
                    tipo : tipo
                },
                success : function (msg) {
                    location.href = "${createLink(action:'list', id:cirugia.pacienteId)}";
                }
            });
            return false;
        });

        var img = "<img src='" + $(this).attr("src") + "' style='height:300px;'/>";

        $("#modalTitle-alert").html("Eliminar Foto");
        $("#modalBody-alert").html("Est&aacute; seguro de querer eliminar esta foto?<br/>" + img);
        $("#modalFooter-alert").html("").append(btnCancel).append(btnDelete);
        $("#modal-alert").modal("show");
    });
</script>
<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 3/17/13
  Time: 12:36 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cuentas</title>
    </head>

    <body>

        <g:if test="${flash.message}">
            <div class="row">
                <div class="span12">
                    <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                        <a class="close" data-dismiss="alert" href="#">×</a>
                        ${flash.message}
                    </div>
                </div>
            </div>
        </g:if>

        <elm:barraTiempo future="${params.future}" today="${params.today}" old="${params.old}"/>

        <div data-toggle="buttons-checkbox" role="navigation" class="btn-group">
            <a id="cobrar" class="btn btn-small btn-cuentas toggle ${params.cobrar == '1' ? 'active' : ''} " href="#">
                <i class="icon-cloud-download"></i> Cobrar
            </a>
            <a id="pagar" class="btn btn-small btn-cuentas toggle ${params.pagar == '1' ? 'active' : ''}" href="#">
                <i class=" icon-cloud-upload"></i> Pagar
            </a>
        </div>

        <div data-toggle="buttons-checkbox" role="navigation" class="btn-group">
            <a id="completos" class="btn btn-small btn-completo toggle ${params.completos == '1' ? 'active' : ''} " href="#">
                <i class="icon-circle"></i> Completos
            </a>
            <a id="incompletos" class="btn btn-small btn-completo toggle ${params.incompletos == '1' ? 'active' : ''}" href="#">
                <i class=" icon-circle-blank"></i> Incompletos
            </a>
        </div>

        <div id="list-Control" role="main" style="margin-top: 10px;">

            <h3>Cuentas por Cobrar</h3>
            <elm:tablaCuentas tipo="C" items="${cobrar}" params="${params}"/>
            <h3>Cuentas por Pagar</h3>
            <elm:tablaCuentas tipo="P" items="${pagar}" params="${params}"/>

        </div>

        <div class="modal hide fade" id="modal-pago">
            <div class="modal-header" id="modalHeader-pago">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-pago"></h3>
            </div>

            <div class="modal-body" id="modalBody-pago">
            </div>

            <div class="modal-footer" id="modalFooter-pago">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if ($("#frmSave-pago").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-pago").submit();
            }

            function togglePagos($btn) {
                $btn.toggleClass("active").parents("tr").next().toggle();
            }

            $(function () {
                $(".togglePagos ").click(function () {
                    togglePagos($(this));
                });

                $(".toggle").click(function () {
                    var tipo = $(this).attr("id");
                    var active = $(this).hasClass("active");
                    var params = "${params}";
                    var val = active ? '0' : '1';
                    params = params.substr(1, params.length - 2);
                    var p = "";
                    var parts = params.split(",");
                    for (var i = 0; i < parts.length; i++) {
                        if (parts[i].indexOf(tipo) == -1) {
                            p += $.trim(parts[i]).replace(":", "=") + "&";
                        }
                    }
                    p += tipo + "=" + val;
                    location.href = "${createLink(action: 'list')}?" + p;
                });

                $.contextMenu({
                    selector : '.fila',
                    items    : {
                        "pay" : {
                            name     : "Pago",
                            icon     : "money",
                            callback : function (key, options) {
                                var row = options.$trigger;
                                var id = row.attr("id");
                                var max = row.data("max");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'pago', action:'form_ajax')}",
                                    success : function (msg) {
                                        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                                        btnSave.click(function () {
                                            submitForm(btnSave);
                                            return false;
                                        });

                                        $("#modalTitle-pago").html("Nuevo Pago");
                                        $("#modalBody-pago").html(msg);
                                        $("#modalFooter-pago").html("").append(btnCancel).append(btnSave);
                                        $("#modal-pago").modal("show");
                                        $("#item").val(id);
                                        $("#valor").attr("max", max);
                                        $("#max").text(number_format(max, 2, ".", ""));
                                        $("#tipo").val(row.data("tipo"));
                                    }
                                });
                            }
                        }
                    }
                });

            });
        </script>

    </body>
</html>
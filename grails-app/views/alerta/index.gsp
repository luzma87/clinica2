<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 3/17/13
  Time: 10:02 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Alertas</title>
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

        <div class="row">
            <div class="span9 btn-group" role="navigation">
                %{--<a href="#" class="btn btn-ajax btn-new" id="btnNewAlergiaPaciente">--}%
                %{--<i class="icon-file"></i>--}%
                %{--Crear  Alergia Paciente--}%
                %{--</a>--}%
            </div>
        </div>

        <g:if test="${clinicas.size() > 0}">
            <h3>Clínicas con datos incompletos</h3>
            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <g:sortableColumn property="nombre" title="Nombre"/>
                        <g:sortableColumn property="direccion" title="Dirección"/>
                        <g:sortableColumn property="telefono" title="Teléfono"/>
                        <g:sortableColumn property="observaciones" title="Observaciones"/>
                        <th></th>
                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${clinicas}" status="i" var="clinicaInstance">
                        <tr class="fila" data-id="${clinicaInstance.id}" data-nombre="${clinicaInstance.nombre}" data-direccion="${clinicaInstance.direccion}"
                            data-telefono="${clinicaInstance.telefono}" data-observaciones="${clinicaInstance.observaciones}">
                            <td class="dblclick" data-tipo="nombre">${fieldValue(bean: clinicaInstance, field: "nombre")}</td>
                            <td class="dblclick" data-tipo="direccion">${fieldValue(bean: clinicaInstance, field: "direccion")}</td>
                            <td class="dblclick" data-tipo="telefono">${fieldValue(bean: clinicaInstance, field: "telefono")}</td>
                            <td class="dblclick" data-tipo="observaciones">${fieldValue(bean: clinicaInstance, field: "observaciones")}</td>
                            <td>
                                <a href="#" class="btn btn-success btnSave" id="${clinicaInstance.id}">
                                    <i class="icon-save">&nbsp;Guardar</i>
                                </a>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
        </g:if>
        <g:if test="${pagosVencidos.size() > 0}">
            <h3>Pagos vencidos</h3>
            <elm:tablaCuentas tipo="P" items="${pagosVencidos}" params="${params}" pagos="0"/>
        </g:if>
        <g:if test="${pagosDias.size() > 0}">
            <h3>Pagos en los proximos ${params.dias} días</h3>
            <elm:tablaCuentas tipo="P" items="${pagosDias}" params="${params}" pagos="0"/>
        </g:if>
        <g:if test="${pagosMes.size() > 0}">
            <h3>Pagos este mes</h3>
            <elm:tablaCuentas tipo="P" items="${pagosMes}" params="${params}" pagos="0"/>
        </g:if>

        <script type="text/javascript">

            $(function () {
                $(".btnSave").click(function () {

                    var $tr = $(this).parents("tr");
                    var id = $tr.data("id");
                    var nombre = $tr.data("nombre");
                    var direccion = $tr.data("direccion");
                    var telefono = $tr.data("telefono");
                    var observaciones = $tr.data("observaciones");

                    $(this).replaceWith(spinner);
                    $(".editing").each(function () {
                        var nc = $(this).val();
                        $(this).parents("tr").data($(this).parent("td").data("tipo"), nc);
                        $(this).parent("td").html(nc);
                    });

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'clinica', action: 'save_ajax')}",
                        data    : {
                            id            : id,
                            nombre        : nombre,
                            direccion     : direccion,
                            telefono      : telefono,
                            observaciones : observaciones
                        },
                        success : function (msg) {
                            console.log(msg)
                            location.reload(true);
                        }
                    });
                });

                $(".dblclick").dblclick(function () {
                    var $elm = $(this);
                    var tfs = $elm.children("input").length;
                    if ($elm.is("td") && tfs == 0) {

                        $(".editing").each(function () {
                            var nc = $(this).val();
                            $(this).parents("tr").data($(this).parent("td").data("tipo"), nc);
                            $(this).parent("td").html(nc);
                        });

                        var cont = $elm.text();
                        var w = $elm.innerWidth();
                        var tfW = w - 30;

                        var $tf = $("<input type='text'/>").addClass("editing").val(cont).innerWidth(tfW);

                        $tf.keyup(function (ev) {
                            if (ev.keyCode == 13) {
                                var newCont = $tf.val();
                                $elm.html(newCont);
                                $elm.parent("tr").data($elm.data("tipo"), newCont);
                            }
                        });

                        $elm.html($tf).innerWidth(w);
                        $tf.focus();
                    }
                });
            });
        </script>

    </body>
</html>
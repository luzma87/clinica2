<%@ page import="clinica.seguridad.Usuario" %>

<g:form class="form-horizontal" name="frmSave-usuario" action="save">
    <g:hiddenField name="id" value="${usuarioInstance?.id}"/>

    <g:if test="${usuarioInstance.id}">
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Password actual
                </span>
            </div>

            <div class="controls">
                <g:field type="password" name="passwordAct" class=" required"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Nuevo Password
                </span>
            </div>

            <div class="controls">
                <g:field type="password" name="password" class=" required"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Confirmar Password
                </span>
            </div>

            <div class="controls">
                <g:field type="password" name="password2" class=" required" equalTo="#password"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
    </g:if>

</g:form>

<script type="text/javascript">
    $("#frmSave-usuario").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        rules          : {
            passwordAct : {
                remote : {
                    url  : "${createLink(action: 'checkPassAct_ajax')}",
                    type : "post",
                    data : {
                        id : "${usuarioInstance.id}"
                    }
                }
            }
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });
</script>

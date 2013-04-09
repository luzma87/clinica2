<%@ page import="clinica.seguridad.Usuario" %>

<g:form class="form-horizontal" name="frmSave-usuario" action="save">
    <g:hiddenField name="id" value="${usuarioInstance?.id}"/>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Nombres
            </span>
        </div>

        <div class="controls">
            <g:textField name="nombres" cols="40" rows="5" maxlength="511" class=" required" value="${usuarioInstance?.nombres}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Usuario
            </span>
        </div>

        <div class="controls">
            <g:textField name="usuario" class=" required" value="${usuarioInstance?.usuario}"/>
            <span class="mandatory">*</span>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <g:if test="${!usuarioInstance.id}">
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Password
                </span>
            </div>

            <div class="controls">
                <g:field type="password" name="password" class=" required" value="${usuarioInstance?.password}"/>
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
                <g:field type="password" name="password2" class=" required" equalTo="#password" value="${usuarioInstance?.password}"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
    </g:if>

    <div class="control-group">
        <div>
            <span class="control-label label label-inverse">
                Email
            </span>
        </div>

        <div class="controls">
            <g:field type="email" name="email" class="email" value="${usuarioInstance?.email}"/>

            <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    %{--<div class="control-group">--}%
        %{--<div>--}%
            %{--<span class="control-label label label-inverse">--}%
                %{--Path fotos--}%
            %{--</span>--}%
        %{--</div>--}%

        %{--<div class="controls">--}%
            %{--<g:textField name="pathFotos" class="" value="${usuarioInstance?.pathFotos}"/>--}%

            %{--<p class="help-block ui-helper-hidden"></p>--}%
        %{--</div>--}%
    %{--</div>--}%

</g:form>

<script type="text/javascript">
    $("#frmSave-usuario").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        rules          : {
            usuario : {
                remote : {
                    url  : "${createLink(action: 'checkUser_ajax')}",
                    type : "post",
                    data : {
                        id : "${usuarioInstance.id}"
                    }
                }
            },
            email   : {
                remote : {
                    url  : "${createLink(action: 'checkMail_ajax')}",
                    type : "post",
                    data : {
                        id : "${usuarioInstance.id}"
                    }
                }
            }
        },
        messages       : {
            usuario : {
                remote : "Usuario no disponible"
            },
            email   : {
                remote : "Email no disponible"
            }
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });
</script>

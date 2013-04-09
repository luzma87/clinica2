<%@ page import="clinica.seguridad.Usuario" %>
<form class="form-horizontal">

    <g:if test="${usuarioInstance?.usuario}">
        <div class="control-group">
            <div>
                <span id="usuario-label" class="control-label label label-inverse">
                    Usuario
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="usuario-label">
                    <g:fieldValue bean="${usuarioInstance}" field="usuario"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${usuarioInstance?.nombres}">
        <div class="control-group">
            <div>
                <span id="nombres-label" class="control-label label label-inverse">
                    Nombres
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="nombres-label">
                    <g:fieldValue bean="${usuarioInstance}" field="nombres"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${usuarioInstance?.email}">
        <div class="control-group">
            <div>
                <span id="email-label" class="control-label label label-inverse">
                    Email
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="email-label">
                    <g:fieldValue bean="${usuarioInstance}" field="email"/>
                </span>

            </div>
        </div>
    </g:if>

</form>

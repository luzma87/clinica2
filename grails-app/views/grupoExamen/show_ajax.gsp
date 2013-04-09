
<%@ page import="clinica.GrupoExamen" %>

<form class="form-horizontal">

<g:if test="${grupoExamenInstance?.nombre}">
    <div class="control-group">
        <div>
            <span id="nombre-label" class="control-label label label-inverse">
                Nombre
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="nombre-label">
                <g:fieldValue bean="${grupoExamenInstance}" field="nombre"/>
            </span>
    
        </div>
    </div>
</g:if>

</form>
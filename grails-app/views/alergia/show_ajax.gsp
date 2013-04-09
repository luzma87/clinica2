
<%@ page import="clinica.Alergia" %>

<form class="form-horizontal">

<g:if test="${alergiaInstance?.descripcion}">
    <div class="control-group">
        <div>
            <span id="descripcion-label" class="control-label label label-inverse">
                Descripcion
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="descripcion-label">
                <g:fieldValue bean="${alergiaInstance}" field="descripcion"/>
            </span>
    
        </div>
    </div>
</g:if>

</form>
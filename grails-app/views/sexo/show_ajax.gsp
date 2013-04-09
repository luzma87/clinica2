
<%@ page import="clinica.Sexo" %>

<form class="form-horizontal">

<g:if test="${sexoInstance?.descripcion}">
    <div class="control-group">
        <div>
            <span id="descripcion-label" class="control-label label label-inverse">
                Descripcion
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="descripcion-label">
                <g:fieldValue bean="${sexoInstance}" field="descripcion"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${sexoInstance?.abreviacion}">
    <div class="control-group">
        <div>
            <span id="abreviacion-label" class="control-label label label-inverse">
                Abreviacion
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="abreviacion-label">
                <g:fieldValue bean="${sexoInstance}" field="abreviacion"/>
            </span>
    
        </div>
    </div>
</g:if>

</form>
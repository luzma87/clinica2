
<%@ page import="clinica.Examen" %>

<form class="form-horizontal">

<g:if test="${examenInstance?.grupoExamen}">
    <div class="control-group">
        <div>
            <span id="grupoExamen-label" class="control-label label label-inverse">
                Grupo Examen
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="grupoExamen-label">
    %{--<g:link controller="grupoExamen" action="show" id="${examenInstance?.grupoExamen?.id}">--}%
                ${examenInstance?.grupoExamen?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${examenInstance?.nombre}">
    <div class="control-group">
        <div>
            <span id="nombre-label" class="control-label label label-inverse">
                Nombre
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="nombre-label">
                <g:fieldValue bean="${examenInstance}" field="nombre"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${examenInstance?.valorInicial}">
    <div class="control-group">
        <div>
            <span id="valorInicial-label" class="control-label label label-inverse">
                Valor Inicial
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="valorInicial-label">
                <g:fieldValue bean="${examenInstance}" field="valorInicial"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${examenInstance?.valorFinal}">
    <div class="control-group">
        <div>
            <span id="valorFinal-label" class="control-label label label-inverse">
                Valor Final
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="valorFinal-label">
                <g:fieldValue bean="${examenInstance}" field="valorFinal"/>
            </span>
    
        </div>
    </div>
</g:if>

</form>
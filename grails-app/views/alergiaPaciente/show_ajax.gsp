
<%@ page import="clinica.AlergiaPaciente" %>

<form class="form-horizontal">

<g:if test="${alergiaPacienteInstance?.paciente}">
    <div class="control-group">
        <div>
            <span id="paciente-label" class="control-label label label-inverse">
                Paciente
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="paciente-label">
    %{--<g:link controller="paciente" action="show" id="${alergiaPacienteInstance?.paciente?.id}">--}%
                ${alergiaPacienteInstance?.paciente?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${alergiaPacienteInstance?.alergia}">
    <div class="control-group">
        <div>
            <span id="alergia-label" class="control-label label label-inverse">
                Alergia
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="alergia-label">
    %{--<g:link controller="alergia" action="show" id="${alergiaPacienteInstance?.alergia?.id}">--}%
                ${alergiaPacienteInstance?.alergia?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${alergiaPacienteInstance?.fecha}">
    <div class="control-group">
        <div>
            <span id="fecha-label" class="control-label label label-inverse">
                Fecha
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="fecha-label">
                <g:formatDate date="${alergiaPacienteInstance?.fecha}" />
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${alergiaPacienteInstance?.observaciones}">
    <div class="control-group">
        <div>
            <span id="observaciones-label" class="control-label label label-inverse">
                Observaciones
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="observaciones-label">
                <g:fieldValue bean="${alergiaPacienteInstance}" field="observaciones"/>
            </span>
    
        </div>
    </div>
</g:if>

</form>
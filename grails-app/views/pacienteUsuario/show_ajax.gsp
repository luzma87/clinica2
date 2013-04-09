
<%@ page import="clinica.PacienteUsuario" %>

<form class="form-horizontal">

<g:if test="${pacienteUsuarioInstance?.usuario}">
    <div class="control-group">
        <div>
            <span id="usuario-label" class="control-label label label-inverse">
                Usuario
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="usuario-label">
    %{--<g:link controller="usuario" action="show" id="${pacienteUsuarioInstance?.usuario?.id}">--}%
                ${pacienteUsuarioInstance?.usuario?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${pacienteUsuarioInstance?.paciente}">
    <div class="control-group">
        <div>
            <span id="paciente-label" class="control-label label label-inverse">
                Paciente
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="paciente-label">
    %{--<g:link controller="paciente" action="show" id="${pacienteUsuarioInstance?.paciente?.id}">--}%
                ${pacienteUsuarioInstance?.paciente?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${pacienteUsuarioInstance?.fechaRegistro}">
    <div class="control-group">
        <div>
            <span id="fechaRegistro-label" class="control-label label label-inverse">
                Fecha Registro
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="fechaRegistro-label">
                <g:formatDate date="${pacienteUsuarioInstance?.fechaRegistro}" />
            </span>
    
        </div>
    </div>
</g:if>

</form>
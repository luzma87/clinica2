
<%@ page import="clinica.Clinica" %>

<form class="form-horizontal">

<g:if test="${clinicaInstance?.nombre}">
    <div class="control-group">
        <div>
            <span id="nombre-label" class="control-label label label-inverse">
                Nombre
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="nombre-label">
                <g:fieldValue bean="${clinicaInstance}" field="nombre"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${clinicaInstance?.direccion}">
    <div class="control-group">
        <div>
            <span id="direccion-label" class="control-label label label-inverse">
                Dirección
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="direccion-label">
                <g:fieldValue bean="${clinicaInstance}" field="direccion"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${clinicaInstance?.telefono}">
    <div class="control-group">
        <div>
            <span id="telefono-label" class="control-label label label-inverse">
                Teléfono
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="telefono-label">
                <g:fieldValue bean="${clinicaInstance}" field="telefono"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${clinicaInstance?.observaciones}">
    <div class="control-group">
        <div>
            <span id="observaciones-label" class="control-label label label-inverse">
                Observaciones
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="observaciones-label">
                <g:fieldValue bean="${clinicaInstance}" field="observaciones"/>
            </span>
    
        </div>
    </div>
</g:if>

</form>
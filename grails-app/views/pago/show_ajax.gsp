
<%@ page import="clinica.Pago" %>

<form class="form-horizontal">

<g:if test="${pagoInstance?.usuario}">
    <div class="control-group">
        <div>
            <span id="usuario-label" class="control-label label label-inverse">
                Usuario
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="usuario-label">
    %{--<g:link controller="usuario" action="show" id="${pagoInstance?.usuario?.id}">--}%
                ${pagoInstance?.usuario?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${pagoInstance?.paciente}">
    <div class="control-group">
        <div>
            <span id="paciente-label" class="control-label label label-inverse">
                Paciente
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="paciente-label">
    %{--<g:link controller="paciente" action="show" id="${pagoInstance?.paciente?.id}">--}%
                ${pagoInstance?.paciente?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${pagoInstance?.item}">
    <div class="control-group">
        <div>
            <span id="item-label" class="control-label label label-inverse">
                Item
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="item-label">
    %{--<g:link controller="item" action="show" id="${pagoInstance?.item?.id}">--}%
                ${pagoInstance?.item?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${pagoInstance?.fecha}">
    <div class="control-group">
        <div>
            <span id="fecha-label" class="control-label label label-inverse">
                Fecha
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="fecha-label">
                <g:formatDate date="${pagoInstance?.fecha}" />
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${pagoInstance?.valor}">
    <div class="control-group">
        <div>
            <span id="valor-label" class="control-label label label-inverse">
                Valor
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="valor-label">
                <g:fieldValue bean="${pagoInstance}" field="valor"/>
            </span>
    
        </div>
    </div>
</g:if>

</form>

<%@ page import="clinica.Item" %>

<form class="form-horizontal">

<g:if test="${itemInstance?.usuario}">
    <div class="control-group">
        <div>
            <span id="usuario-label" class="control-label label label-inverse">
                Usuario
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="usuario-label">
    %{--<g:link controller="usuario" action="show" id="${itemInstance?.usuario?.id}">--}%
                ${itemInstance?.usuario?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.paciente}">
    <div class="control-group">
        <div>
            <span id="paciente-label" class="control-label label label-inverse">
                Paciente
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="paciente-label">
    %{--<g:link controller="paciente" action="show" id="${itemInstance?.paciente?.id}">--}%
                ${itemInstance?.paciente?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.fecha}">
    <div class="control-group">
        <div>
            <span id="fecha-label" class="control-label label label-inverse">
                Fecha
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="fecha-label">
                <g:formatDate date="${itemInstance?.fecha}" />
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.razon}">
    <div class="control-group">
        <div>
            <span id="razon-label" class="control-label label label-inverse">
                Razon
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="razon-label">
                <g:fieldValue bean="${itemInstance}" field="razon"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.clinica}">
    <div class="control-group">
        <div>
            <span id="clinica-label" class="control-label label label-inverse">
                Clinica
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="clinica-label">
    %{--<g:link controller="clinica" action="show" id="${itemInstance?.clinica?.id}">--}%
                ${itemInstance?.clinica?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.observaciones}">
    <div class="control-group">
        <div>
            <span id="observaciones-label" class="control-label label label-inverse">
                Observaciones
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="observaciones-label">
                <g:fieldValue bean="${itemInstance}" field="observaciones"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.valor}">
    <div class="control-group">
        <div>
            <span id="valor-label" class="control-label label label-inverse">
                Valor
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="valor-label">
                <g:fieldValue bean="${itemInstance}" field="valor"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.costo}">
    <div class="control-group">
        <div>
            <span id="costo-label" class="control-label label label-inverse">
                Costo
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="costo-label">
                <g:fieldValue bean="${itemInstance}" field="costo"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.tipoCirugia}">
    <div class="control-group">
        <div>
            <span id="tipoCirugia-label" class="control-label label label-inverse">
                Tipo Cirugia
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="tipoCirugia-label">
    %{--<g:link controller="tipoCirugia" action="show" id="${itemInstance?.tipoCirugia?.id}">--}%
                ${itemInstance?.tipoCirugia?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.tipoItem}">
    <div class="control-group">
        <div>
            <span id="tipoItem-label" class="control-label label label-inverse">
                Tipo Item
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="tipoItem-label">
    %{--<g:link controller="tipoItem" action="show" id="${itemInstance?.tipoItem?.id}">--}%
                ${itemInstance?.tipoItem?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.estadoItem}">
    <div class="control-group">
        <div>
            <span id="estadoItem-label" class="control-label label label-inverse">
                Estado Item
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="estadoItem-label">
    %{--<g:link controller="estadoItem" action="show" id="${itemInstance?.estadoItem?.id}">--}%
                ${itemInstance?.estadoItem?.encodeAsHTML()}
    %{--</g:link>--}%
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.cobrado}">
    <div class="control-group">
        <div>
            <span id="cobrado-label" class="control-label label label-inverse">
                Cobrado
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="cobrado-label">
                <g:formatBoolean boolean="${itemInstance?.cobrado}" />
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.duracionHoras}">
    <div class="control-group">
        <div>
            <span id="duracionHoras-label" class="control-label label label-inverse">
                Duracion Horas
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="duracionHoras-label">
                <g:fieldValue bean="${itemInstance}" field="duracionHoras"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.duracionMinutos}">
    <div class="control-group">
        <div>
            <span id="duracionMinutos-label" class="control-label label label-inverse">
                Duracion Minutos
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="duracionMinutos-label">
                <g:fieldValue bean="${itemInstance}" field="duracionMinutos"/>
            </span>
    
        </div>
    </div>
</g:if>

<g:if test="${itemInstance?.pagado}">
    <div class="control-group">
        <div>
            <span id="pagado-label" class="control-label label label-inverse">
                Pagado
            </span>
        </div>
        <div class="controls">
    
            <span aria-labelledby="pagado-label">
                <g:formatBoolean boolean="${itemInstance?.pagado}" />
            </span>
    
        </div>
    </div>
</g:if>

</form>
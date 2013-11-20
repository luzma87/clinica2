<%@ page import="clinica.Historia" %>

<form class="form-horizontal">

    <g:if test="${historiaInstance?.fecha}">
        <div class="control-group">
            <div>
                <span id="fecha-label" class="control-label label label-inverse">
                    Fecha
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fecha-label">
                    <g:formatDate date="${historiaInstance?.fecha}" format="dd-MM-yyyy"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${historiaInstance?.descripcion}">
        <div class="control-group">
            <span aria-labelledby="descripcion-label">
                ${historiaInstance?.descripcion}
            </span>
        </div>
    </g:if>

</form>
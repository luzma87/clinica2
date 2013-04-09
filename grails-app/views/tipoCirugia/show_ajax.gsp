<%@ page import="clinica.TipoCirugia" %>

<form class="form-horizontal">

    <g:if test="${tipoCirugiaInstance?.nombre}">
        <div class="control-group">
            <div>
                <span id="nombre-label" class="control-label label label-inverse">
                    Nombre
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="nombre-label">
                    <g:fieldValue bean="${tipoCirugiaInstance}" field="nombre"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${tipoCirugiaInstance?.costo}">
        <div class="control-group">
            <div>
                <span id="costo-label" class="control-label label label-inverse">
                    Costo
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="costo-label">
                    <g:fieldValue bean="${tipoCirugiaInstance}" field="costo"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${tipoCirugiaInstance?.duracionHoras}">
        <div class="control-group">
            <div>
                <span id="duracionHoras-label" class="control-label label label-inverse">
                    Duracion Horas
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="duracionHoras-label">
                    <g:fieldValue bean="${tipoCirugiaInstance}" field="duracionHoras"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${tipoCirugiaInstance?.duracionMinutos}">
        <div class="control-group">
            <div>
                <span id="duracionMinutos-label" class="control-label label label-inverse">
                    Duracion Minutos
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="duracionMinutos-label">
                    <g:fieldValue bean="${tipoCirugiaInstance}" field="duracionMinutos"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${tipoCirugiaInstance?.valor}">
        <div class="control-group">
            <div>
                <span id="valor-label" class="control-label label label-inverse">
                    Valor
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="valor-label">
                    <g:fieldValue bean="${tipoCirugiaInstance}" field="valor"/>
                </span>

            </div>
        </div>
    </g:if>

</form>
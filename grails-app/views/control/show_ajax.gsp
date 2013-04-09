<%@ page import="clinica.Item" %>

<form class="form-horizontal">

    <g:if test="${controlInstance?.paciente}">
        <div class="control-group">
            <div>
                <span id="paciente-label" class="control-label label label-inverse">
                    Paciente
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="paciente-label">
                    %{--<g:link controller="paciente" action="show" id="${controlInstance?.paciente?.id}">--}%
                    ${controlInstance?.paciente?.nombres} ${controlInstance?.paciente?.apellidos} (CI: ${controlInstance?.paciente?.cedula})
                    %{--</g:link>--}%
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${controlInstance?.fecha}">
        <div class="control-group">
            <div>
                <span id="fecha-label" class="control-label label label-inverse">
                    Fecha
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fecha-label">
                    <g:formatDate date="${controlInstance?.fecha}" format="dd-MM-yyyy HH:mm"/>
                    ${controlInstance.duracionHoras.toString().padLeft(2, '0')}:${controlInstance.duracionMinutos.toString().padLeft(2, '0')}
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${controlInstance?.observaciones}">
        <div class="control-group">
            <div>
                <span id="observaciones-label" class="control-label label label-inverse">
                    Observaciones
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="observaciones-label">
                    <g:fieldValue bean="${controlInstance}" field="observaciones"/>
                </span>

            </div>
        </div>
    </g:if>

</form>
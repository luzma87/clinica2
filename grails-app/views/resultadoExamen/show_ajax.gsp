<%@ page import="clinica.ResultadoExamen" %>

<form class="form-horizontal">

    <g:if test="${resultadoExamenInstance?.paciente}">
        <div class="control-group">
            <div>
                <span id="paciente-label" class="control-label label label-inverse">
                    Paciente
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="paciente-label">
                    %{--<g:link controller="paciente" action="show" id="${resultadoExamenInstance?.paciente?.id}">--}%
                    ${resultadoExamenInstance.paciente.nombres} ${resultadoExamenInstance.paciente.apellidos}
                    %{--</g:link>--}%
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${resultadoExamenInstance?.examen}">
        <div class="control-group">
            <div>
                <span id="examen-label" class="control-label label label-inverse">
                    Examen
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="examen-label">
                    %{--<g:link controller="examen" action="show" id="${resultadoExamenInstance?.examen?.id}">--}%
                    ${resultadoExamenInstance?.examen?.grupoExamen.nombre} -
                    ${resultadoExamenInstance?.examen?.nombre}
                    %{--</g:link>--}%
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${resultadoExamenInstance?.resultado}">
        <div class="control-group">
            <div>
                <span id="resultado-label" class="control-label label label-inverse">
                    Resultado
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="resultado-label">
                    <g:fieldValue bean="${resultadoExamenInstance}" field="resultado"/>
                    (Valores normales: ${resultadoExamenInstance?.examen?.valorInicial} - ${resultadoExamenInstance?.examen?.valorFinal})
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${resultadoExamenInstance?.fecha}">
        <div class="control-group">
            <div>
                <span id="fecha-label" class="control-label label label-inverse">
                    Fecha
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fecha-label">
                    <g:formatDate date="${resultadoExamenInstance?.fecha}" format="dd-MM-yyyy"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${resultadoExamenInstance?.observaciones}">
        <div class="control-group">
            <div>
                <span id="observaciones-label" class="control-label label label-inverse">
                    Observaciones
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="observaciones-label">
                    <g:fieldValue bean="${resultadoExamenInstance}" field="observaciones"/>
                </span>

            </div>
        </div>
    </g:if>

</form>
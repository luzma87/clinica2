<%@ page import="clinica.Item" %>

<form class="form-horizontal">

    <g:if test="${cirugiaInstance?.paciente}">
        <div class="control-group">
            <div>
                <span id="paciente-label" class="control-label label label-inverse">
                    Paciente
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="paciente-label">
                    ${cirugiaInstance?.paciente?.nombres} ${cirugiaInstance?.paciente?.apellidos}
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${cirugiaInstance?.fecha}">
        <div class="control-group">
            <div>
                <span id="fecha-label" class="control-label label label-inverse">
                    Fecha
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fecha-label">
                    <g:formatDate date="${cirugiaInstance?.fecha}" format="dd-MM-yyyy hh:mm"/>
                    ${cirugiaInstance.duracionHoras.toString().padLeft(2, '0')}:${cirugiaInstance.duracionMinutos.toString().padLeft(2, '0')}
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${cirugiaInstance?.clinica}">
        <div class="control-group">
            <div>
                <span id="clinica-label" class="control-label label label-inverse">
                    Clínica
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="clinica-label">
                    %{--<g:link controller="clinica" action="show" id="${cirugiaInstance?.clinica?.id}">--}%
                    ${cirugiaInstance?.clinica?.nombre}
                    %{--</g:link>--}%
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${cirugiaInstance?.razon}">
        <div class="control-group">
            <div>
                <span id="razon-label" class="control-label label label-inverse">
                    Razón
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="razon-label">
                    <g:fieldValue bean="${cirugiaInstance}" field="razon"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${cirugiaInstance?.valor}">
        <div class="control-group">
            <div>
                <span id="valor-label" class="control-label label label-inverse">
                    Por cobrar
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="valor-label">
                    <g:formatNumber number="${cirugiaInstance?.valor}" type="currency"/>
                    hasta el <g:formatDate date="${cirugiaInstance?.fechaCobro}" format="dd-MM-yyyy"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${cirugiaInstance?.costo}">
        <div class="control-group">
            <div>
                <span id="costo-label" class="control-label label label-inverse">
                    Por pagar
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="costo-label">
                    <g:formatNumber number="${cirugiaInstance?.costo}" type="currency"/>
                    hasta el <g:formatDate date="${cirugiaInstance?.fechaPago}" format="dd-MM-yyyy"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${cirugiaInstance?.estadoItem}">
        <div class="control-group">
            <div>
                <span id="estado-label" class="control-label label label-inverse">
                    Estado
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="estado-label">
                    ${cirugiaInstance.estadoItem.descripcion}
                </span>

            </div>
        </div>
    </g:if>

    <div class="control-group">
        <div>
            <span id="fotoAntes-label" class="control-label label label-inverse">
                Foto Antes
            </span>
        </div>

        <div class="controls">

            <span aria-labelledby="fotoAntes-label">
                <elm:imagenCirugia cirugia="${cirugiaInstance}" tipo="antes" class="mini"/>
            </span>

        </div>
    </div>

    <div class="control-group">
        <div>
            <span id="fotoDespues-label" class="control-label label label-inverse">
                Foto Después
            </span>
        </div>

        <div class="controls">

            <span aria-labelledby="fotoDespues-label">
                <elm:imagenCirugia cirugia="${cirugiaInstance}" tipo="despues" class="mini"/>
            </span>

        </div>
    </div>

    <g:if test="${cirugiaInstance?.observaciones}">
        <div class="control-group">
            <div>
                <span id="observaciones-label" class="control-label label label-inverse">
                    Observaciones
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="observaciones-label">
                    <g:fieldValue bean="${cirugiaInstance}" field="observaciones"/>
                </span>

            </div>
        </div>
    </g:if>

</form>
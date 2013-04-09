<%@ page import="clinica.Paciente" %>

<form class="form-horizontal">

    <g:if test="${pacienteInstance?.cedula}">
        <div class="control-group">
            <div>
                <span id="cedula-label" class="control-label label label-inverse">
                    Cedula
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="cedula-label">
                    <g:fieldValue bean="${pacienteInstance}" field="cedula"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${pacienteInstance?.nombres}">
        <div class="control-group">
            <div>
                <span id="nombres-label" class="control-label label label-inverse">
                    Nombres
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="nombres-label">
                    <g:fieldValue bean="${pacienteInstance}" field="nombres"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${pacienteInstance?.apellidos}">
        <div class="control-group">
            <div>
                <span id="apellidos-label" class="control-label label label-inverse">
                    Apellidos
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="apellidos-label">
                    <g:fieldValue bean="${pacienteInstance}" field="apellidos"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${pacienteInstance?.fechaNacimiento}">
        <div class="control-group">
            <div>
                <span id="fechaNacimiento-label" class="control-label label label-inverse">
                    Fecha Nacimiento
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fechaNacimiento-label">
                    <g:formatDate date="${pacienteInstance?.fechaNacimiento}" format="dd-MM-yyyy"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${pacienteInstance?.sexo}">
        <div class="control-group">
            <div>
                <span id="sexo-label" class="control-label label label-inverse">
                    Sexo
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="sexo-label">
                    %{--<g:link controller="sexo" action="show" id="${pacienteInstance?.sexo?.id}">--}%
                    ${pacienteInstance?.sexo?.descripcion}
                    %{--</g:link>--}%
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${pacienteInstance?.direccion}">
        <div class="control-group">
            <div>
                <span id="direccion-label" class="control-label label label-inverse">
                    Direccion
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="direccion-label">
                    <g:fieldValue bean="${pacienteInstance}" field="direccion"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${pacienteInstance?.telefono}">
        <div class="control-group">
            <div>
                <span id="telefono-label" class="control-label label label-inverse">
                    Telefono
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="telefono-label">
                    <g:fieldValue bean="${pacienteInstance}" field="telefono"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${pacienteInstance?.email}">
        <div class="control-group">
            <div>
                <span id="email-label" class="control-label label label-inverse">
                    Email
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="email-label">
                    <g:fieldValue bean="${pacienteInstance}" field="email"/>
                </span>

            </div>
        </div>
    </g:if>

    <div class="control-group">
        <div>
            <span id="fuma-label" class="control-label label label-inverse">
                Fuma
            </span>
        </div>

        <div class="controls">

            <span aria-labelledby="fuma-label">
                <g:formatBoolean boolean="${pacienteInstance?.fuma}" true="Sí" false="No"/>
            </span>

        </div>
    </div>

    <div class="control-group">
        <div>
            <span id="bebe-label" class="control-label label label-inverse">
                Bebe
            </span>
        </div>

        <div class="controls">

            <span aria-labelledby="bebe-label">
                <g:formatBoolean boolean="${pacienteInstance?.bebe}" true="Sí" false="No"/>
            </span>

        </div>
    </div>

    <div class="control-group">
        <div>
            <span id="drogas-label" class="control-label label label-inverse">
                Drogas
            </span>
        </div>

        <div class="controls">

            <span aria-labelledby="drogas-label">
                <g:formatBoolean boolean="${pacienteInstance?.drogas}" true="Sí" false="No"/>
            </span>

        </div>
    </div>

    <g:if test="${pacienteInstance?.alergias}">
        <div class="control-group">
            <div>
                <span id="alergias-label" class="control-label label label-inverse">
                    Alergias
                </span>
            </div>

            <div class="controls">

                <g:each in="${pacienteInstance.alergias}" var="a" status="i">
                    <span aria-labelledby="alergias-label">
                        %{--<g:link controller="alergiaPaciente" action="show" id="${a.id}">--}%
                        ${a?.alergia?.descripcion}${i < pacienteInstance.alergias.size() - 1 ? ',' : ''}
                        %{--</g:link>--}%
                    </span>
                </g:each>

            </div>
        </div>
    </g:if>

%{--<g:if test="${pacienteInstance?.cirujias}">--}%
%{--<div class="control-group">--}%
%{--<div>--}%
%{--<span id="cirujias-label" class="control-label label label-inverse">--}%
%{--Cirujias--}%
%{--</span>--}%
%{--</div>--}%
%{--<div class="controls">--}%
%{----}%
%{--<g:each in="${pacienteInstance.cirujias}" var="c">--}%
%{--<span aria-labelledby="cirujias-label">--}%
%{--<g:link controller="cirugia" action="show" id="${c.id}">--}%
%{--${c?.encodeAsHTML()}--}%
%{--</g:link>--}%
%{--</span>--}%
%{--</g:each>--}%
%{----}%
%{--</div>--}%
%{--</div>--}%
%{--</g:if>--}%

%{--<g:if test="${pacienteInstance?.resultadosExamen}">--}%
%{--<div class="control-group">--}%
%{--<div>--}%
%{--<span id="resultadosExamen-label" class="control-label label label-inverse">--}%
%{--Resultados Examen--}%
%{--</span>--}%
%{--</div>--}%
%{--<div class="controls">--}%
%{----}%
%{--<g:each in="${pacienteInstance.resultadosExamen}" var="r">--}%
%{--<span aria-labelledby="resultadosExamen-label">--}%
%{--<g:link controller="resultadoExamen" action="show" id="${r.id}">--}%
%{--${r?.encodeAsHTML()}--}%
%{--</g:link>--}%
%{--</span>--}%
%{--</g:each>--}%
%{----}%
%{--</div>--}%
%{--</div>--}%
%{--</g:if>--}%

</form>
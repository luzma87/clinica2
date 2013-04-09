<% import grails.persistence.Event %>
<%=packageName%>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de${className.replaceAll('[A-Z]') {' ' + it}}s
        </title>


    </head>
    <body>

        <g:if test="\${flash.message}">
            <div class="row">
                <div class="span12">
                    <div class="alert \${flash.clase ?: 'alert-info'}" role="status">
                        <a class="close" data-dismiss="alert" href="#">×</a>
                        \${flash.message}
                    </div>
                </div>
            </div>
        </g:if>

        <div class="row">
            <div class="span9 btn-group" role="navigation">
                <a href="#" class="btn btn-ajax btn-new" id="btnNew${className}">
                    <i class="icon-file"></i>
                    Crear ${className.replaceAll('[A-Z]') {' ' + it}}
                </a>
            </div>
            <div class="span3" id="busqueda-${className.toLowerCase()}"></div>
        </div>

        <g:form action="delete" name="frmDelete-${className.toLowerCase()}" class="hide">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-${className}" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                    <%  excludedProps = Event.allEvents.toList() << 'id' << 'version'
                        allowedNames = domainClass.persistentProperties*.name << 'dateCreated' << 'lastUpdated'
                        props = domainClass.properties.findAll { allowedNames.contains(it.name) && !excludedProps.contains(it.name) && it.type != null && !Collection.isAssignableFrom(it.type) }
                        Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
                        props.eachWithIndex { p, i ->
                            if (i < 6) {
                                if (p.isAssociation()) { %>
                        <th>${p.naturalName}</th>
                    <%      } else { %>
                        <g:sortableColumn property="${p.name}" title="${p.naturalName}" />
                    <%  }   }   } %>
                    </tr>
                </thead>
                <tbody class="paginate">
                <g:each in="\${${propertyName}List}" status="i" var="${propertyName}">
                    <tr class="fila" id="\${${propertyName}.id}">
                    <%  props.eachWithIndex { p, i ->
                            if (i == 0) { %>
                        <td>\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</td>
                    <%      } else if (i < 6) {
                                if (p.type == Boolean || p.type == boolean) { %>
                        <td><g:formatBoolean boolean="\${${propertyName}.${p.name}}" /></td>
                    <%          } else if (p.type == Date || p.type == java.sql.Date || p.type == java.sql.Time || p.type == Calendar) { %>
                        <td><g:formatDate date="\${${propertyName}.${p.name}}" /></td>
                    <%          } else { %>
                        <td>\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</td>
                    <%  }   }   } %>
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

        <div class="modal hide fade" id="modal-${className.toLowerCase()}">
            <div class="modal-header" id="modalHeader-${className.toLowerCase()}">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-${className.toLowerCase()}"></h3>
            </div>

            <div class="modal-body" id="modalBody-${className.toLowerCase()}">
            </div>

            <div class="modal-footer" id="modalFooter-${className.toLowerCase()}">
            </div>
        </div>

        <script type="text/javascript">
            function submitForm(btn) {
                if (\$("#frmSave-${className.toLowerCase()}").valid()) {
                    btn.replaceWith(spinner);
                }
                \$("#frmSave-${className.toLowerCase()}").submit();
            }

            \$(function () {
                \$('[rel=tooltip]').tooltip();

                \$(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : \$("#busqueda-${className.toLowerCase()}"),
                    float          : "right"
                });

                \$("#btnNew${className}").click(function () {
                    \$.ajax({
                        type    : "POST",
                        url     : "\${createLink(action:'form_ajax')}",
                        success : function (msg) {
                            var btnCancel = \$('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = \$('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            \$("#modalTitle-${className.toLowerCase()}").html("Crear${className.replaceAll('[A-Z]') {' ' + it}}");
                            \$("#modalBody-${className.toLowerCase()}").html(msg);
                            \$("#modalFooter-${className.toLowerCase()}").html("").append(btnCancel).append(btnSave);
                            \$("#modal-${className.toLowerCase()}").modal("show");
                        }
                    });
                    return false;
                }); //click btn new

            \$.contextMenu({
                selector : '.fila',
                items    : {
                    "show"   : {
                        name     : "Ver",
                        icon     : "show",
                        callback : function (key, options) {
                            var row = options.\$trigger;
                            var id = row.attr("id");
                            \$.ajax({
                                type    : "POST",
                                url     : "\${createLink(action:'show_ajax')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    var btnOk = \$('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                                    \$("#modalTitle-${className.toLowerCase()}").html("Ver ${className}");
                                    \$("#modalBody-${className.toLowerCase()}").html(msg);
                                    \$("#modalFooter-${className.toLowerCase()}").html("").append(btnOk);
                                    \$("#modal-${className.toLowerCase()}").modal("show");
                                }
                            });
                        }
                    },
                    "edit"   : {
                        name     : "Editar",
                        icon     : "edit",
                        callback : function (key, options) {
                            var row = options.\$trigger;
                            var id = row.attr("id");
                            \$.ajax({
                                type    : "POST",
                                url     : "\${createLink(action:'form_ajax')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    var btnCancel = \$('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                    var btnSave = \$('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                                    btnSave.click(function () {
                                        submitForm(btnSave);
                                        return false;
                                    });

                                    \$("#modalTitle-${className.toLowerCase()}").html("Editar ${className}");
                                    \$("#modalBody-${className.toLowerCase()}").html(msg);
                                    \$("#modalFooter-${className.toLowerCase()}").html("").append(btnCancel).append(btnSave);
                                    \$("#modal-${className.toLowerCase()}").modal("show");
                                }
                            });
                        }
                    },
                    "sep1"   : "---------",
                    "delete" : {
                        name     : "Eliminar",
                        icon     : "delete",
                        callback : function (key, options) {
                            var row = options.\$trigger;
                            var id = row.attr("id");
                            \$("#id").val(id);
                            var btnCancel = \$('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnDelete = \$('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

                            btnDelete.click(function () {
                                btnDelete.replaceWith(spinner);
                                \$("#frmDelete-${className.toLowerCase()}").submit();
                                return false;
                            });

                            \$("#modalTitle-${className.toLowerCase()}").html("Eliminar ${className}");
                            \$("#modalBody-${className.toLowerCase()}").html("<p>¿Está seguro de querer eliminar esta ${className}?</p>");
                            \$("#modalFooter-${className.toLowerCase()}").html("").append(btnCancel).append(btnDelete);
                            \$("#modal-${className.toLowerCase()}").modal("show");
                        }
                    }
                }
            });

            });

        </script>

    </body>
</html>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 2/3/13
  Time: 5:00 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Calendario</title>

        <script type='text/javascript' src='${resource(dir: "js/jquery/plugins/fullcalendar-1.5.4/fullcalendar", file: "fullcalendar.js")}'></script>
        <link rel='stylesheet' type='text/css' href='${resource(dir: "js/jquery/plugins/fullcalendar-1.5.4/fullcalendar", file: "fullcalendar.css")}'/>
        <link rel='stylesheet' type='text/css' href='${resource(dir: "js/jquery/plugins/fullcalendar-1.5.4/fullcalendar", file: "fullcalendar.print.css")}' media='print'/>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/fancyapps-fancyBox-0ffc358/source', file: 'jquery.fancybox.css?v=2.1.4')}" type="text/css" media="screen"/>
        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/fancyapps-fancyBox-0ffc358/source', file: 'jquery.fancybox.pack.js?v=2.1.4')}"></script>

        <style type="text/css">
        #loading {
            position : absolute;
            top      : 5px;
            right    : 5px;
        }

        #calendar {
            width  : 800px;
            margin : 0 auto;
        }

        .fc-day-number, .fc-event {
            cursor : pointer;
        }

        .fc-day-number {
            text-decoration : underline;
            color           : #435EE8;
        }

        .fc-event-time {
            font-size   : smaller;
            font-weight : bolder;
            float       : left;
        }
        </style>

    </head>

    <body>

        <div id='loading' style='display:none'>loading...</div>

        <div id='calendar'></div>

        <div class="modal hide fade" id="modal-ajax">
            <div class="modal-header" id="modalHeader-ajax">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>

                <h3 id="modalTitle-ajax"></h3>
            </div>

            <div class="modal-body" id="modalBody-ajax">
            </div>

            <div class="modal-footer" id="modalFooter-ajax">
            </div>
        </div>

        <script type="text/javascript">
            $(function () {

                $(".fancybox").fancybox({
                    helpers : {
                        overlay : {
                            css : {
//                                'background' : 'rgba(66, 172, 233, 0.95)'
                                'background' : 'rgba(77, 133, 166, 0.8)'
                            }
                        }
                    }
                });

                $('#calendar').fullCalendar({
                    height          : 600,
                    header          : {
                        left   : 'prev,next today',
                        center : 'title',
                        right  : 'month,agendaWeek,agendaDay'
                    },
                    editable        : false,
                    events          : ${events},
                    dayClick        : function (date, allDay, jsEvent, view) {
                        if ($(jsEvent.target).hasClass("fc-day-number")) {
//                            console.log(date);
//                            console.log(jsEvent.target)
                            $("#calendar").fullCalendar('gotoDate', date.getFullYear(), date.getMonth(), date.getDate())
                                    .fullCalendar('changeView', "agendaDay");
                        }
                    },
                    eventClick      : function (calEvent, jsEvent, view) {
//                        console.log('Event: ', calEvent);
//                        console.log('Event: ', calEvent.tipo);

                        var url, tipo;
                        switch (calEvent.tipo) {
                            case "I":
                                url = "${createLink(controller: 'cirugia', action: 'show_ajax')}";
                                tipo = "cirug&iacute;a";
                                break;
                            case "O":
                                url = "${createLink(controller: 'control', action: 'show_ajax')}";
                                tipo = "control";
                                break;
                        }
                        url += "/" + calEvent.iid;
//                        console.log(url);

                        $.ajax({
                            type    : "POST",
                            url     : url,
                            success : function (msg) {
                                resetTimer();
                                var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Aceptar</a>');

                                $("#modalTitle-ajax").html("Ver " + tipo);
                                $("#modalBody-ajax").html(msg);
                                $("#modalFooter-ajax").html("").append(btnOk);
                                $("#modal-ajax").modal("show");
                            }
                        });
                    },
                    loading         : function (bool) {
                        if (bool) $('#loading').show();
                        else $('#loading').hide();
                    },
                    timeFormat      : {
                        month : 'HH:mm{ - HH:mm}', // uppercase H for 24-hour clock
                        week  : 'HH:mm',
                        day   : 'HH:mm'
                    },
                    columnFormat    : {
                        month : 'ddd',    // Mon
                        week  : 'ddd dd-MM', // Mon 9/7
                        day   : 'dddd dd MMMM'  // Monday 9/7
                    },
                    titleFormat     : {
                        month : 'MMMM yyyy',                             // September 2009
                        week  : "dd[ MMM][ yyyy]{ '&#8212;' dd MMM  yyyy}", // Sep 7 - 13 2009
                        day   : 'dddd, dd MMM, yyyy'                  // Tuesday, Sep 8, 2009
                    },
                    buttonText      : {
                        prev     : '&nbsp;&#9668;&nbsp;',  // left triangle
                        next     : '&nbsp;&#9658;&nbsp;',  // right triangle
                        prevYear : '&nbsp;&lt;&lt;&nbsp;', // <<
                        nextYear : '&nbsp;&gt;&gt;&nbsp;', // >>
                        today    : 'hoy',
                        month    : 'mes',
                        week     : 'semana',
                        day      : 'd&iacute;a'
                    },
                    monthNames      : ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio',
                        'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                    monthNamesShort : ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                    dayNames        : ['Domingo', 'Lunes', 'Martes', 'Mi&eacute;rcoles',
                        'Jueves', 'Viernes', 'S&aacute;bado'],
                    dayNamesShort   : ['Dom', 'Lun', 'Mar', 'Mi&eacute;', 'Jue', 'Vie', 'S&aacute;b']
                });

                $.contextMenu({
                    selector : '.fc-widget-content',
                    items    : {
                        "control" : {
                            name     : "Nuevo control",
                            icon     : "control",
                            disabled : function (key, options) {
                                var cell = options.$trigger;
                                var date = cell.data("date");
                                var xdate = new XDate(date);
                                var today = XDate.today();
                                return xdate < today;
                            },
                            callback : function (key, options) {
                                var cell = options.$trigger;
                                var date = cell.data("date");
                                var strDate = date.getDate() + "-" + (date.getMonth() + 1 ) + "-" + date.getFullYear();
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'control', action:'form_ajax')}",
                                    data    : {
                                        date : strDate
                                    },
                                    success : function (msg) {
                                        resetTimer();

                                        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                                        btnSave.click(function () {
                                            if ($("#frmSave-control").valid()) {
                                                btnSave.replaceWith(spinner);
                                            }
                                            $("#frmSave-control").submit();
                                            return false;
                                        });

                                        $("#modalTitle-ajax").html("Nuevo control");
                                        $("#modalBody-ajax").html(msg);
                                        $("#modalFooter-ajax").html("").append(btnCancel).append(btnSave);
                                        $("#modal-ajax").modal("show");

                                        $("#tipo").val("calendar");
                                    }
                                });
                            }
                        }, //control
                        "cirugia" : {
                            name     : "Nueva cirugía",
                            icon     : "cirugia",
                            disabled : function (key, options) {
                                var cell = options.$trigger;
                                var date = cell.data("date");
                                var xdate = new XDate(date);
                                var today = XDate.today();
                                return xdate < today;
                            },
                            callback : function (key, options) {
                                var cell = options.$trigger;
                                var date = cell.data("date");
                                var strDate = date.getDate() + "-" + (date.getMonth() + 1 ) + "-" + date.getFullYear();
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'cirugia', action:'form_ajax')}",
                                    data    : {
                                        date : strDate
                                    },
                                    success : function (msg) {
                                        resetTimer();

                                        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                                        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                                        btnSave.click(function () {
                                            if ($("#frmSave-cirugia").valid()) {
                                                btnSave.replaceWith(spinner);
                                            }
                                            $("#frmSave-cirugia").submit();
                                            return false;
                                        });

                                        $("#modalTitle-ajax").html("Nueva cirugía");
                                        $("#modalBody-ajax").html(msg);
                                        $("#modalFooter-ajax").html("").append(btnCancel).append(btnSave);
                                        $("#modal-ajax").modal("show");

                                        $("#tipo").val("calendar");
                                    }
                                });

                            }
                        }
                    }
                });

            });
        </script>
    </body>
</html>
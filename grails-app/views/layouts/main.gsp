<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <title>
            <g:layoutTitle default="Clínica"/>
        </title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">

        <script src="${resource(dir: 'js/jquery/js', file: 'jquery-1.9.1.js')}"></script>
        <script src="${resource(dir: 'js/jquery/js', file: 'jquery-ui-1.10.1.custom.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/countdown', file: 'jquery.countdown.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/countdown', file: 'jquery.countdown-es.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins', file: 'date.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins', file: 'jquery.luz.paginate.js')}"></script>

        <script src="${resource(dir: 'js/jquery/plugins', file: 'xdate.js')}"></script>

        <!-- Le styles -->
        <link href="${resource(dir: 'css/bootstrap/css', file: 'bootstrap_cerulean.css')}" rel="stylesheet">
        <link href="${resource(dir: 'css/bootstrap/css', file: 'bootstrap-responsive.css')}" rel="stylesheet">

        <link href="${resource(dir: 'css/fontawsome/css', file: 'font-awesome.css')}" rel="stylesheet">

        <link href="${resource(dir: 'css', file: 'mobile.css')}" rel="stylesheet">
        <script src="${resource(dir: 'js/jquery/plugins', file: 'jquery-highlight.js')}"></script>
        <style>

        .hasCountdown {
            background : none !important;
            border     : none !important;
        }

        .countdown_amount {
            font-size : 150% !important;
        }

        </style>
        <link href="${resource(dir: 'css/bootstrap/css', file: 'bootstrap-responsive.css')}" rel="stylesheet">

        <link href="${resource(dir: 'js/jquery/css/overcast', file: 'jquery-ui.css')}" rel="stylesheet">
        <link href="${resource(dir: 'js/jquery/plugins/countdown', file: 'jquery.countdown.css')}" rel="stylesheet">

        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.10', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.10', file: 'messages_es.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.10', file: 'additional-methods.js')}"></script>

        <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.js')}"></script>
        <link href="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.css')}" rel="stylesheet">
        <link href="${resource(dir: 'css', file: 'customContextMenu.css')}" rel="stylesheet">

        <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

        <link rel="shortcut icon" href="${resource(dir: 'images/ico', file: 'clipboard_16.png')}">
        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="${resource(dir: 'images/ico', file: 'clipboard_144.png')}">
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="${resource(dir: 'images/ico', file: 'clipboard_114.png')}">
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="${resource(dir: 'images/ico', file: 'clipboard_72.png')}">
        <link rel="apple-touch-icon-precomposed" href="${resource(dir: 'images/ico', file: 'clipboard_57.png')}">

        <script src="${resource(dir: 'js', file: 'functions.js')}"></script>
        <g:layoutHead/>

        <link href="${resource(dir: 'css', file: 'custom.css')}" rel="stylesheet">
        <link href="${resource(dir: 'css', file: 'customButtons.css')}" rel="stylesheet">
    </head>

    <body>

        <mn:menu title="${g.layoutTitle(default: 'Clínica')}" user="${session.user.id}"/>

        <script type="text/javascript">
            var url = "${resource(dir:'images', file:'spinner_24.gif')}";
            var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");
            var urlBg = "${resource(dir:'images', file:'spinner64.gif')}";
            var spinnerBg = $("<img src='" + url + "' alt='Cargando...'/>");

            $(function () {

                $("#dlgLoad").dialog({
                    modal         : true,
                    autoOpen      : false,
                    closeOnEscape : false,
                    draggable     : false,
                    resizable     : false,
                    zIndex        : 9000,
                    open          : function (event, ui) {
                        $(event.target).parent().find(".ui-dialog-titlebar-close").remove();
                    }
                });

            });
        </script>

        <div class="container">
            <g:layoutBody/>
        </div>

        <div id="dlgLoad" class="ui-helper-hidden" title="CARGANDO..." style="text-align:center;">
            Cargando.....Por favor espere......<br/><br/>
            <img src="${resource(dir: 'images', file: 'spinner64.gif')}" alt=""/>
        </div>

        <script src="${resource(dir: 'css/bootstrap/js', file: 'bootstrap.js')}"></script>

        <script type="text/javascript">
            var ot = document.title;

            function resetTimer() {
                var ahora = new Date();
                var fin = ahora.clone().add(20).minute();
                $("#countdown").countdown('option', {
                    until : fin
                });
                $(".countdown_amount").removeClass("highlight");
                document.title = ot;
            }

            function validarSesion() {
                $.ajax({
                    url     : '${createLink(controller: "login", action:"validarSesion")}',
                    success : function (msg) {
                        if (msg == "NO") {
                            location.href = "${g.createLink(controller: 'login', action: 'login')}";
                        } else {
                            resetTimer();
                        }
                    }
                });
            }

            function highlight(periods) {
                if ((periods[5] == 5 && periods[6] == 0) || (periods[5] < 5)) {
                    document.title = "Fin de sesión en " + (periods[5].toString().lpad('0', 2)) + ":" + (periods[6].toString().lpad('0', 2)) + " - " + ot;
                    $(".countdown_amount").addClass("highlight");
                }
            }

            $(function () {

                var ahora = new Date();
                var fin = ahora.clone().add(20).minute();

                $('#countdown').countdown({
                    until    : fin,
                    format   : 'MS',
                    compact  : true,
                    onExpiry : validarSesion,
                    onTick   : highlight
                });

                $(".btn-ajax").click(function () {
                    resetTimer();
                });

                $(".edad").each(function () {
                    var $sp = $(this);
                    var f = new XDate($sp.data("nacimiento"));
                    var otherDate = new Date();
                    var y = Math.floor(f.diffYears(otherDate));
                    var m = Math.floor(f.diffMonths(otherDate));
                    var d = Math.floor(f.diffDays(otherDate));
                    if (y > 0) {
                        $sp.html(y + " a&ntilde;o" + (y == 1 ? "" : "s"));
                    } else if (m > 0) {
                        $sp.html(m + " mes" + (m == 1 ? "" : "es"));
                    } else if (d > 0) {
                        $sp.html(d + " d&iacute;a" + (d == 1 ? "" : "s"));
                    }
                });



            });
        </script>

    </body>
</html>
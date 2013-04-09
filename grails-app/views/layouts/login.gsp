<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <title>
            <g:layoutTitle default="Login"/>
        </title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">

        <script src="${resource(dir: 'js/jquery/js', file: 'jquery-1.9.1.js')}"></script>
        <script src="${resource(dir: 'js/jquery/js', file: 'jquery-ui-1.10.1.custom.min.js')}"></script>

        <!-- Le styles -->
        <link href="${resource(dir: 'css/bootstrap/css', file: 'bootstrap_cerulean.css')}" rel="stylesheet">
        <link href="${resource(dir: 'css/bootstrap/css', file: 'bootstrap-responsive.css')}" rel="stylesheet">

        <link href="${resource(dir: 'css/fontawsome/css', file: 'font-awesome.css')}" rel="stylesheet">

        <link href="${resource(dir: 'js/jquery/css/overcast', file: 'jquery-ui.css')}" rel="stylesheet">
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.10', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.10', file: 'messages_es.js')}"></script>

        <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

        <link rel="shortcut icon" href="${resource(dir: 'images/ico', file: 'clipboard_16.png')}">
        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="${resource(dir: 'images/ico', file: 'clipboard_144.png')}">
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="${resource(dir: 'images/ico', file: 'clipboard_114.png')}">
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="${resource(dir: 'images/ico', file: 'clipboard_72.png')}">
        <link rel="apple-touch-icon-precomposed" href="${resource(dir: 'images/ico', file: 'clipboard_57.png')}">

        <g:layoutHead/>
    </head>

    <body>
        <script type="text/javascript">
            var url = "${resource(dir:'images', file:'spinner_24.gif')}";
            var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");
        </script>

        <div class="container">
            <g:layoutBody/>
        </div>

        <div id="dlgLoad" class="ui-helper-hidden" title="CARGANDO..." style="text-align:center;">
            Cargando.....Por favor espere......<br/><br/>
            <img src="${resource(dir: 'images', file: 'spinner64.gif')}" alt=""/>
        </div>

        <script src="${resource(dir: 'css/bootstrap/js', file: 'bootstrap.js')}"></script>
    </body>
</html>
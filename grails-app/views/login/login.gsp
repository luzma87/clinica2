<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="layout" content="login">

        <style type="text/css">
        body {
            padding-top      : 40px;
            padding-bottom   : 40px;
            background-color : #f5f5f5;
        }

        .form-signin {
            max-width             : 300px;
            padding               : 19px 29px 29px;
            margin                : 0 auto 20px;
            background-color      : #fff;
            border                : 1px solid #e5e5e5;
            -webkit-border-radius : 5px;
            -moz-border-radius    : 5px;
            border-radius         : 5px;
            -webkit-box-shadow    : 0 1px 2px rgba(0, 0, 0, .05);
            -moz-box-shadow       : 0 1px 2px rgba(0, 0, 0, .05);
            box-shadow            : 0 1px 2px rgba(0, 0, 0, .05);
        }

        .form-signin .form-signin-heading {
            margin-bottom : 10px;
        }

        .form-signin input[type="text"],
        .form-signin input[type="password"] {
            font-size     : 16px;
            height        : auto;
            margin-bottom : 15px;
            padding       : 7px 9px;
        }

        </style>

    </head>

    <body>

        <div class="container">
            <g:form class="form-signin" action="validarLogin" name="frmLogin">
                <h2 class="form-signin-heading">Ingreso</h2>

                <g:if test="${flash.message}">
                    <div class="alert alert-error" style="padding-bottom: 14px;">
                        <i class="icon-warning-sign icon-2x pull-left"></i>
                        ${flash.message}
                    </div>
                </g:if>

                <input type="text" class="input-block-level" placeholder="Usuario" name="user"/>
                <input type="password" class="input-block-level" placeholder="Password" name="pass"/>
                <a href="#" class="btn btn-large btn-primary" id="btnLogin">
                    <i class="icon-unlock"></i> Entrar
                </a>
            </g:form>
        </div> <!-- /container -->

        <script type="text/javascript">
            function submit() {
                $("#btnLogin").replaceWith(spinner);
                $("#frmLogin").submit();
            }
            $(function () {
                $("#btnLogin").click(function () {
                    submit();
                });
                $("input").keyup(function (ev) {
                    if (ev.keyCode == 13) {
                        submit();
                    }
                });

            });
        </script>

    </body>
</html>

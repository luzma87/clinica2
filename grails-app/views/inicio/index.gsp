<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 1/10/13
  Time: 7:53 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title></title>
        <style type="text/css">
        .caption {
            text-align : center;
        }

        .thumbnail {
            -moz-box-shadow    : 10px 10px 10px #03427E;
            -webkit-box-shadow : 10px 10px 10px #03427E;
            box-shadow         : 10px 10px 10px #03427E;
        }

        .thumbnail:hover {
            -moz-box-shadow    : 10px 10px 5px #43ACE9;
            -webkit-box-shadow : 10px 10px 5px #43ACE9;
            box-shadow         : 10px 10px 5px #43ACE9;
        }

        .thumbnail img {
            height : 200px;
        }
        </style>
    </head>

    <body>
        <div class="row">
            <ul class="thumbnails">
                <g:link controller="paciente" action="list">
                    <li class="span3">
                        <div class="thumbnail">
                            <img alt="Pacientes" src="${resource(dir: 'images/init', file: 'pacientes.jpg')}">

                            <div class="caption">
                                <h3>Pacientes</h3>
                            </div>
                        </div>
                    </li>
                </g:link>
                <g:link controller="calendario" action="index">
                    <li class="span3">
                        <div class="thumbnail">
                            <img alt="Calendario" src="${resource(dir: 'images/init', file: 'calendario.jpg')}">

                            <div class="caption">
                                <h3>Calendario</h3>
                            </div>
                        </div>
                    </li>
                </g:link>
                <g:link controller="control" action="listAll">
                    <li class="span3">
                        <div class="thumbnail">
                            <img alt="Controles" src="${resource(dir: 'images/init', file: 'controles.png')}">

                            <div class="caption">
                                <h3>Controles</h3>
                            </div>
                        </div>
                    </li>
                </g:link>
                <g:link controller="cirugia" action="listAll">
                    <li class="span3">
                        <div class="thumbnail">
                            <img alt="Cirugías" src="${resource(dir: 'images/init', file: 'cirugias.jpg')}">

                            <div class="caption">
                                <h3>Cirugias</h3>
                            </div>
                        </div>
                    </li>
                </g:link>

            </ul>
        </div>
    </body>
</html>
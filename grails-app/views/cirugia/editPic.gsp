<%--
  Created by IntelliJ IDEA.
  User: Luz
  Date: 7/1/13
  Time: 6:10 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">

        <script type="text/javascript" src='${resource(dir: "js/jquery/plugins/bgrins-spectrum-2c2010c", file: "spectrum.js")}'></script>
        <link rel='stylesheet' type="text/css" href='${resource(dir: "js/jquery/plugins/bgrins-spectrum-2c2010c", file: "spectrum.css")}'/>

        <title>Editar imagen</title>

        <style type="text/css">
        .editArea {
            min-height : 200px;
            /*background : red;*/
        }

        .bg {
            position : absolute;
            top      : 0;
            left     : 0;
        }

        #paint {
            border     : solid 3px black;
            background : url("${path}");
        }

        #sketch {
            position : relative;
        }

        canvas {
            display : inline-block;
            cursor  : crosshair;
        }

        #tmp_canvas {
            border   : dashed 3px #000000;
            position : absolute;
            /*cursor   : crosshair;*/
            bottom   : 0;
            left     : 0;
            right    : 0;
            top      : 0;
        }

        #text_tool {
            position    : absolute;
            border      : 1px dashed black;
            outline     : 0;
            display     : none;

            font        : 14px Verdana;
            overflow    : hidden;
            white-space : nowrap;
            background  : none;

            color       : red;
        }

            /*.btn {*/
            /*width : 50px;*/
            /*}*/

        .btn-group-vertical, .vert {
            float   : right;
            z-index : 999;
        }
        </style>
    </head>

    <body>
        <g:if test="${flash.message}">
            <div class="row">
                <div class="span12">
                    <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                        <a class="close" data-dismiss="alert" href="#">×</a>
                        ${flash.message}
                    </div>
                </div>
            </div>
        </g:if>

        <div class="row" style="margin-bottom: 20px;">
            <div class="span9 btn-group" role="navigation">
                <g:link controller="cirugia" action="showPics" id="${cirugia.id}" class="btn">
                    <i class="icon-picture"></i>
                    Imagenes
                </g:link>
                <g:link controller="cirugia" action="list" id="${cirugia.pacienteId}" class="btn">
                    <i class="icon-medkit"></i>
                    Cirugías
                </g:link>
            </div>

            <div class="span3" id="busqueda-cirugia"></div>
        </div>

        <elm:datosPaciente paciente="${cirugia.paciente}" cirugia="${cirugia}"/>

        <div class="vert">
            <div>
                Lápiz
                &nbsp;&nbsp;&nbsp;
                Fondo/Texto
            </div>
            <input type='text' class="colorpicker" data-tipo="line" title="Color lápiz"/>
            <input type='text' class="colorpicker" data-tipo="fill" title="Color fondo"/>

            <div style="margin-top: 10px;">Grosor línea: <span id="spWidth"></span></div>

            <div id="slider" style="height: 150px; margin-left: 15px;"></div>

            <div style="margin-top: 10px;">Tamaño texto: <span id="spTextSize"></span></div>

            <div id="sliderText" style="height: 150px; margin-left: 15px;"></div>
        </div>

        <div class="btn-group" style="margin-bottom: 10px;">
            <a href="#" class="btn" title="Guardar" id="save">
                <i class="icon-save icon-2x"></i>
            </a>
            <a href="#" class="btn tool" data-tool="pencil" title="Lápiz">
                <i class="icon-pencil icon-2x"></i>
            </a>
            <a href="#" class="btn  tool" data-tool="line" title="Línea">
                <i class="icon-resize-horizontal icon-2x"></i>
            </a>
            <a href="#" class="btn  tool" data-tool="square" title="Cuadrado">
                <span class=" icon-stack">
                    <i class="icon-check-empty icon-stack-base"></i>
                    <i class="icon-ok"></i>
                </span>
            </a>
            <a href="#" class="btn   tool" data-tool="rectangle" title="Rectángulo">
                <i class="icon-unchecked icon-2x"></i>
            </a>
            <a href="#" class="btn   tool" data-tool="circle" title="Círculo">
                <span class=" icon-stack">
                    <i class="icon-circle-blank icon-stack-base"></i>
                    <i class="icon-ok"></i>
                </span>
            </a>
            <a href="#" class="btn   tool" data-tool="oval" title="Óvalo">
                <i class="icon-circle-blank icon-2x"></i>
            </a>
            <a href="#" class="btn   erase" data-tool="eraser" title="Borrador">
                <i class="icon-eraser icon-2x"></i>
            </a>
            <a href="#" class="btn   tool" data-tool="text" title="Texto">
                <i class="icon-font icon-2x"></i></a>

            <a href="#" class="btn   filled" data-fill="fill" title="Vacío">
                <i class="icon-bell icon-2x"></i>
            </a>
        </div>

        %{--Size: <span id="size">3</span>--}%
        %{--<a href="#" class="size" data-size="inc">increase</a>--}%
        %{--<a href="#" class="size" data-size="dec">decrease</a>--}%

        <div class="editArea">

            <div id="sketch">
                <img class="bg" src="${path}" style="display: none;"/>
                <canvas id="paint"></canvas>
            </div>

            %{--<div id="colors">--}%
            %{--Line--}%
            %{--<a href="#" class="line" data-color="red">Red</a>--}%
            %{--<a href="#" class="line" data-color="blue">Blue</a>--}%
            %{--<a href="#" class="line" data-color="green">Green</a>--}%
            %{--&nbsp;&nbsp;&nbsp;&nbsp;--}%
            %{--Fill--}%
            %{--<a href="#" class="fill" data-color="red">Red</a>--}%
            %{--<a href="#" class="fill" data-color="blue">Blue</a>--}%
            %{--<a href="#" class="fill" data-color="green">Green</a>--}%
            %{--&nbsp;&nbsp;&nbsp;&nbsp;--}%
            %{--<a href="#" class="filled" data-fill="fill">Not Filled</a>--}%
            %{--&nbsp;&nbsp;&nbsp;&nbsp;--}%
            %{--<a href="#" class="save">Save</a>--}%
            %{--</div>--}%
        </div>

        %{--<a href="#" id="fontSize">Font</a>--}%

        <script type="text/javascript" src="${resource(dir: 'js', file: 'paint.js')}"></script>
        <script type="text/javascript">
            $('.btn').tooltip();

            setOverlay("${overlay}");

            $("#fontSize").click(function () {
                $("#text_tool").css("font-size", 20);
            });

            $("#save").click(function () {
                var dataURL = canvas.toDataURL();
                $.ajax({
                    type : "POST",
                    url  : "${createLink(action:'saveEditedPic')}",
                    data : {
                        id   : "${cirugia.id}",
                        path : "${path}",
                        img  : dataURL
                    }
                }).done(function (o) {
                            console.log('saved');
                        });
                return false;
            });

            $(".colorpicker").spectrum({
                color           : "red",
                localStorageKey : "colores",
                cancelText      : "cancelar",
                chooseText      : "OK",
                change          : function (color) {
                    var tipo = $(this).data("tipo");
                    switch (tipo) {
                        case "line":
                            line = color.toHexString();
                            break;
                        case "fill":
                            fill = color.toHexString();
                            $("#text_tool").css("color", color.toHexString());
                            break;
                    }
                    changeColors();
//                    console.log(color.toHexString()); // #ff0000
                }
            });
            $("#spWidth").text(getPencilSize());
            $("#slider").slider({
                orientation : "vertical",
                value       : getPencilSize(),
                min         : 1,
                max         : 100,
                step        : 1,
                slide       : function (event, ui) {
//                    $("#amount").val("$" + ui.value);
                    $("#spWidth").text(ui.value);
                    changePencilSize(ui.value);
                }
            });
            $("#spTextSize").text(14);
            $("#sliderText").slider({
                orientation : "vertical",
                value       : 14,
                min         : 10,
                max         : 150,
                step        : 1,
                slide       : function (event, ui) {
                    $("#text_tool").css("font-size", ui.value);
                    $("#spTextSize").text(ui.value);
                }
            });

            $(".save").click(function () {
                var dataURL = canvas.toDataURL("image/png");
                if (!window.open(dataURL)) {
                    document.location.href = dataURL;
                }
                return false;
            });

            $(".tool").click(function () {
                tool = $(this).data("tool");
                setTempVisibility(true);
                return false;
            });
            $(".erase").click(function () {
                setTempVisibility(false);
                return false;
            });
            $(".size").click(function () {
                var size = getPencilSize();
                switch ($(this).data("size")) {
                    case "inc":
                        size++;
                        break;
                    case "dec":
                        size--;
                        break;
                    default:
                        size = $(this).data("size");
                }
                $("#size").text(size);
                changePencilSize(size);
                return false;
            });
            $(".line").click(function () {
                line = $(this).data("color");
                changeColors();
                return false;
            });
            $(".fill").click(function () {
                fill = $(this).data("color");
                changeColors();
                $("#text_tool").css({
                    color : fill
                });
                return false;
            });

            $(".filled").click(function () {
                if (filled) {
                    $(this).html('<i class="icon-bell icon-2x"></i>').attr("title", "Vacío");
                } else {
                    $(this).html('<i class="icon-bell-alt icon-2x"></i>').attr("title", "Lleno");
                }
                filled = !filled;
                return false;
            });
        </script>

    </body>
</html>
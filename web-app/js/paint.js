/**
 * Created with IntelliJ IDEA.
 * User: Luz
 * Date: 6/30/13
 * Time: 8:26 PM
 * To change this template use File | Settings | File Templates.
 */

var tool = "pencil";
var filled = false;

var line = "red";
var fill = "red";

var canvas = document.querySelector("#paint");
var ctx = canvas.getContext("2d");

var sketch = document.querySelector("#sketch");

var bg = $(".bg");
var bgW = bg.width();
var bgH = bg.height();
canvas.width = bgW;
canvas.height = bgH;
//canvas.width = $(window).width() - 25;
//canvas.height = $(window).height() - 75;

// Creating a tmp canvas
var tmp_canvas = document.createElement('canvas');
var tmp_ctx = tmp_canvas.getContext('2d');
tmp_canvas.id = 'tmp_canvas';
tmp_canvas.width = canvas.width;
tmp_canvas.height = canvas.height;
sketch.appendChild(tmp_canvas);

var mouse = {x : 0, y : 0};
var start_mouse = {x : 0, y : 0};

var textarea = document.createElement('textarea');
textarea.id = 'text_tool';
sketch.appendChild(textarea);
// Text tool's text container for calculating lines/chars
var tmp_txt_ctn = document.createElement('div');
tmp_txt_ctn.style.display = 'none';
sketch.appendChild(tmp_txt_ctn);

// Pencil Points
var ppts = [];

function setOverlay(path) {
    if (path != "") {
        var img = new Image();
        img.onload = function () {
            ctx.drawImage(img, 0, 0);
        }
        img.src = path;
    }
}

function changeColors() {
    tmp_ctx.strokeStyle = line;
    tmp_ctx.fillStyle = fill;
}

function getPencilSize() {
    return tmp_ctx.lineWidth;
}

function changePencilSize(size) {
    tmp_ctx.lineWidth = size;
    ctx.lineWidth = size;
}

function setTempVisibility(visible) {
    if (visible) {
        tmp_canvas.style.display = 'block';
        tmp_ctx.strokeStyle = line;
        tmp_ctx.fillStyle = fill;
        ctx.globalCompositeOperation = 'source-over';
    } else {
        ctx.globalCompositeOperation = 'destination-out';
        tmp_canvas.style.display = 'none';
        ctx.fillStyle = 'rgba(0,0,0,1)';
        ctx.strokeStyle = 'rgba(0,0,0,1)';
    }
}

/* Mouse Capturing Work */
tmp_canvas.addEventListener('mousemove', function (e) {
    mouse.x = typeof e.offsetX !== 'undefined' ? e.offsetX : e.layerX;
    mouse.y = typeof e.offsetY !== 'undefined' ? e.offsetY : e.layerY;
}, false);

/* Drawing on Paint App */
tmp_ctx.lineWidth = 3;
tmp_ctx.lineJoin = 'round';
tmp_ctx.lineCap = 'round';
tmp_ctx.strokeStyle = line;
tmp_ctx.fillStyle = fill;

ctx.lineWidth = 3;
ctx.lineJoin = 'round';
ctx.lineCap = 'round';

textarea.addEventListener('mouseup', function (e) {
    tmp_canvas.removeEventListener('mousemove', onPaint, false);
}, false);

canvas.addEventListener('mousedown', function (e) {
    canvas.addEventListener('mousemove', onErase, false);
    mouse.x = typeof e.offsetX !== 'undefined' ? e.offsetX : e.layerX;
    mouse.y = typeof e.offsetY !== 'undefined' ? e.offsetY : e.layerY;
    ppts.push({x : mouse.x, y : mouse.y});
    onErase();
}, false);
canvas.addEventListener('mouseup', function () {
    canvas.removeEventListener('mousemove', onErase, false);
// Emptying up Pencil Points
    ppts = [];
}, false);
canvas.addEventListener('mousemove', function (e) {
    mouse.x = typeof e.offsetX !== 'undefined' ? e.offsetX : e.layerX;
    mouse.y = typeof e.offsetY !== 'undefined' ? e.offsetY : e.layerY;
}, false);

tmp_canvas.addEventListener('mousedown', function (e) {
    tmp_canvas.addEventListener('mousemove', onPaint, false);
    mouse.x = typeof e.offsetX !== 'undefined' ? e.offsetX : e.layerX;
    mouse.y = typeof e.offsetY !== 'undefined' ? e.offsetY : e.layerY;
    start_mouse.x = mouse.x;
    start_mouse.y = mouse.y;
    switch (tool) {
        case "pencil":
//            tmp_canvas.addEventListener('mousemove', onPaint, false);
//            mouse.x = typeof e.offsetX !== 'undefined' ? e.offsetX : e.layerX;
//            mouse.y = typeof e.offsetY !== 'undefined' ? e.offsetY : e.layerY;
            ppts.push({x : mouse.x, y : mouse.y});
            onPaint();
            break;
        case "text":
//            tmp_canvas.addEventListener('mousemove', onPaint, false);
//            mouse.x = typeof e.offsetX !== 'undefined' ? e.offsetX : e.layerX;
//            mouse.y = typeof e.offsetY !== 'undefined' ? e.offsetY : e.layerY;
//            start_mouse.x = mouse.x;
//            start_mouse.y = mouse.y;
            break;
        case "line":
        case "square":
        case "rectangle":
        case "circle":
        case "oval":
            onPaint();
            break;
    }
}, false);

tmp_canvas.addEventListener('mouseup', function () {
    tmp_canvas.removeEventListener('mousemove', onPaint, false);
    if (tool == "text") {
        var lines = textarea.value.split('\n');
        var processed_lines = [];
        for (var i = 0; i < lines.length; i++) {
            var chars = lines[i].length;
            for (var j = 0; j < chars; j++) {
                var text_node = document.createTextNode(lines[i][j]);
                tmp_txt_ctn.appendChild(text_node);
                // Since tmp_txt_ctn is not taking any space
                // in layout due to display: none, we gotta
                // make it take some space, while keeping it
                // hidden/invisible and then get dimensions
                tmp_txt_ctn.style.position = 'absolute';
                tmp_txt_ctn.style.visibility = 'hidden';
                tmp_txt_ctn.style.display = 'block';
                var width = tmp_txt_ctn.offsetWidth;
                var height = tmp_txt_ctn.offsetHeight;
                tmp_txt_ctn.style.position = '';
                tmp_txt_ctn.style.visibility = '';
                tmp_txt_ctn.style.display = 'none';
                // Logix
                // console.log(width, parseInt(textarea.style.width));
                if (width > parseInt(textarea.style.width)) {
                    break;
                }
            }
            processed_lines.push(tmp_txt_ctn.textContent);
            tmp_txt_ctn.innerHTML = '';
        }
        var ta_comp_style = getComputedStyle(textarea);
        var fs = ta_comp_style.getPropertyValue('font-size');
        var ff = ta_comp_style.getPropertyValue('font-family');

        tmp_ctx.font = fs + ' ' + ff;

        tmp_ctx.textBaseline = 'top';
        for (var n = 0; n < processed_lines.length; n++) {
            var processed_line = processed_lines[n];
            tmp_ctx.fillText(
                processed_line,
                parseInt(textarea.style.left),
                parseInt(textarea.style.top) + n * parseInt(fs)
            );
        }
        // Writing down to real canvas now
        ctx.drawImage(tmp_canvas, 0, 0);
        // Clearing tmp canvas
        tmp_ctx.clearRect(0, 0, tmp_canvas.width, tmp_canvas.height);
        // clearInterval(sprayIntervalID);
        textarea.style.display = 'none';
        textarea.value = '';
    } else {
        // Writing down to real canvas now
        ctx.drawImage(tmp_canvas, 0, 0);
        // Clearing tmp canvas
        tmp_ctx.clearRect(0, 0, tmp_canvas.width, tmp_canvas.height);
        // Emptying up Pencil Points
        ppts = [];
    }
}, false);

var onErase = function () {
    // Saving all the points in an array
    ppts.push({x : mouse.x, y : mouse.y});
    if (ppts.length < 3) {
        var b = ppts[0];
        ctx.beginPath();
        //ctx.moveTo(b.x, b.y);
        //ctx.lineTo(b.x+50, b.y+50);
        ctx.arc(b.x, b.y, ctx.lineWidth / 2, 0, Math.PI * 2, !0);
        ctx.fill();
        ctx.closePath();
        return;
    }
    // Tmp canvas is always cleared up before drawing.
    // ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
    ctx.moveTo(ppts[0].x, ppts[0].y);
    for (var i = 1; i < ppts.length - 2; i++) {
        var c = (ppts[i].x + ppts[i + 1].x) / 2;
        var d = (ppts[i].y + ppts[i + 1].y) / 2;
        ctx.quadraticCurveTo(ppts[i].x, ppts[i].y, c, d);
    }
    // For the last 2 points
    ctx.quadraticCurveTo(
        ppts[i].x,
        ppts[i].y,
        ppts[i + 1].x,
        ppts[i + 1].y
    );
    ctx.stroke();
};

var onPaint = function () {
//    changeColors();
    // Saving all the points in an array
    ppts.push({x : mouse.x, y : mouse.y});
    if (ppts.length < 3) {
        var b = ppts[0];
        tmp_ctx.beginPath();
        //ctx.moveTo(b.x, b.y);
        //ctx.lineTo(b.x+50, b.y+50);
        tmp_ctx.arc(b.x, b.y, tmp_ctx.lineWidth / 2, 0, Math.PI * 2, !0);
        tmp_ctx.fill();
        tmp_ctx.closePath();
        return;
    }
    // Tmp canvas is always cleared up before drawing.
    tmp_ctx.clearRect(0, 0, tmp_canvas.width, tmp_canvas.height);

    var x, y, w, h;

    switch (tool) {
        case "pencil":
            tmp_ctx.beginPath();
            tmp_ctx.moveTo(ppts[0].x, ppts[0].y);
            for (var i = 1; i < ppts.length - 2; i++) {
                var c = (ppts[i].x + ppts[i + 1].x) / 2;
                var d = (ppts[i].y + ppts[i + 1].y) / 2;
                tmp_ctx.quadraticCurveTo(ppts[i].x, ppts[i].y, c, d);
            }
            // For the last 2 points
            tmp_ctx.quadraticCurveTo(
                ppts[i].x,
                ppts[i].y,
                ppts[i + 1].x,
                ppts[i + 1].y
            );
            tmp_ctx.stroke();
            break;
        case "line":
            tmp_ctx.beginPath();
            tmp_ctx.moveTo(start_mouse.x, start_mouse.y);
            tmp_ctx.lineTo(mouse.x, mouse.y);
            tmp_ctx.stroke();
            tmp_ctx.closePath();
            break;
        case "square":
            x = Math.min(mouse.x, start_mouse.x);
            y = Math.min(mouse.y, start_mouse.y);
            w = Math.max(
                Math.abs(mouse.x - start_mouse.x),
                Math.abs(mouse.y - start_mouse.y)
            );
            drawRect(tmp_ctx, x, y, w, w);
            break;
        case "rectangle":
            x = Math.min(mouse.x, start_mouse.x);
            y = Math.min(mouse.y, start_mouse.y);
            w = Math.abs(mouse.x - start_mouse.x);
            h = Math.abs(mouse.y - start_mouse.y);
            drawRect(tmp_ctx, x, y, w, h);
            break;
        case "circle":
            x = (mouse.x + start_mouse.x) / 2;
            y = (mouse.y + start_mouse.y) / 2;
            var radius = Math.max(
                Math.abs(mouse.x - start_mouse.x),
                Math.abs(mouse.y - start_mouse.y)
            ) / 2;
            drawCircle(tmp_ctx, x, y, radius);
            break;
        case "oval":
            x = Math.min(mouse.x, start_mouse.x);
            y = Math.min(mouse.y, start_mouse.y);
            w = Math.abs(mouse.x - start_mouse.x);
            h = Math.abs(mouse.y - start_mouse.y);
            drawEllipse(tmp_ctx, x, y, w, h);
            break;
        case "text":
            var difX = mouse.x - start_mouse.x;
            var difY = mouse.y - start_mouse.y;

            if (difX + difY > 50) {
                x = Math.min(mouse.x, start_mouse.x);
                y = Math.min(mouse.y, start_mouse.y);
                w = Math.abs(mouse.x - start_mouse.x);
                h = Math.abs(mouse.y - start_mouse.y);
                textarea.style.left = x + 'px';
                textarea.style.top = y + 'px';
                textarea.style.width = w + 'px';
                textarea.style.height = h + 'px';
                textarea.style.display = 'block';
            }
            break;
    }

    function drawRect(ctx, x, y, w, h) {
        if (filled) {
            ctx.fillRect(x, y, w, h);
        }
        ctx.strokeRect(x, y, w, h);
    }

    function drawCircle(ctx, x, y, r) {
        ctx.beginPath();
        ctx.arc(x, y, r, 0, Math.PI * 2, false);
        // tmp_ctx.arc(x, y, 5, 0, Math.PI*2, false);
        if (filled) {
            ctx.fill();
        }
        ctx.stroke();
        ctx.closePath();
    }

    function drawEllipse(ctx, x, y, w, h) {
        var kappa = .5522848;
        var ox = (w / 2) * kappa, // control point offset horizontal
            oy = (h / 2) * kappa, // control point offset vertical
            xe = x + w,           // x-end
            ye = y + h,           // y-end
            xm = x + w / 2,       // x-middle
            ym = y + h / 2;       // y-middle

        ctx.beginPath();
        ctx.moveTo(x, ym);
        ctx.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
        ctx.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
        ctx.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
        ctx.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
        ctx.closePath();
        if (filled) {
            ctx.fill();
        }
        ctx.stroke();
    }

};
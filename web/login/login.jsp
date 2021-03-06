<%--
  Created by IntelliJ IDEA.
  User: Ace
  Date: 2017/4/5
  Time: 21:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta charset="UTF-8">
    <title>学生信息系统</title>
    <script src="<%=basePath%>modules/jquery.js"></script>
    <link rel="stylesheet" href="<%=basePath%>modules/semantic.css">
    <script src="<%=basePath%>modules/semantic.min.js"></script>
    <link rel="stylesheet" href="<%=basePath%>css/login.css">
</head>
<body>
<canvas id="Mycanvas"></canvas>
<script>
    //定义画布宽高和生成点的个数
    var WIDTH = window.innerWidth, HEIGHT = window.innerHeight, POINT = 35;

    var canvas = document.getElementById('Mycanvas');
    canvas.width = WIDTH,
        canvas.height = HEIGHT;
    var context = canvas.getContext('2d');
    context.strokeStyle = 'rgba(0,0,0,0.02)',
        context.strokeWidth = 1,
        context.fillStyle = 'rgba(0,0,0,0.05)';
    var circleArr = [];

    //线条：开始xy坐标，结束xy坐标，线条透明度
    function Line (x, y, _x, _y, o) {
        this.beginX = x,
            this.beginY = y,
            this.closeX = _x,
            this.closeY = _y,
            this.o = o;
    }
    //点：圆心xy坐标，半径，每帧移动xy的距离
    function Circle (x, y, r, moveX, moveY) {
        this.x = x,
            this.y = y,
            this.r = r,
            this.moveX = moveX,
            this.moveY = moveY;
    }
    //生成max和min之间的随机数
    function num (max, _min) {
        var min = arguments[1] || 0;
        return Math.floor(Math.random()*(max-min+1)+min);
    }
    // 绘制原点
    function drawCricle (cxt, x, y, r, moveX, moveY) {
        var circle = new Circle(x, y, r, moveX, moveY)
        cxt.beginPath()
        cxt.arc(circle.x, circle.y, circle.r, 0, 2*Math.PI)
        cxt.closePath()
        cxt.fill();
        return circle;
    }
    //绘制线条
    function drawLine (cxt, x, y, _x, _y, o) {
        var line = new Line(x, y, _x, _y, o)
        cxt.beginPath()
        cxt.strokeStyle = 'rgba(0,0,0,'+ o +')'
        cxt.moveTo(line.beginX, line.beginY)
        cxt.lineTo(line.closeX, line.closeY)
        cxt.closePath()
        cxt.stroke();

    }
    //初始化生成原点
    function init () {
        circleArr = [];
        for (var i = 0; i < POINT; i++) {
            circleArr.push(drawCricle(context, num(WIDTH), num(HEIGHT), num(15, 2), num(10, -10)/40, num(10, -10)/40));
        }
        draw();
    }

    //每帧绘制
    function draw () {
        context.clearRect(0,0,canvas.width, canvas.height);
        for (var i = 0; i < POINT; i++) {
            drawCricle(context, circleArr[i].x, circleArr[i].y, circleArr[i].r);
        }
        for (var i = 0; i < POINT; i++) {
            for (var j = 0; j < POINT; j++) {
                if (i + j < POINT) {
                    var A = Math.abs(circleArr[i+j].x - circleArr[i].x),
                        B = Math.abs(circleArr[i+j].y - circleArr[i].y);
                    var lineLength = Math.sqrt(A*A + B*B);
                    var C = 1/lineLength*7-0.009;
                    var lineOpacity = C > 0.03 ? 0.03 : C;
                    if (lineOpacity > 0) {
                        drawLine(context, circleArr[i].x, circleArr[i].y, circleArr[i+j].x, circleArr[i+j].y, lineOpacity);
                    }
                }
            }
        }
    }

    //调用执行
    window.onload = function () {
        init();
        setInterval(function () {
            for (var i = 0; i < POINT; i++) {
                var cir = circleArr[i];
                cir.x += cir.moveX;
                cir.y += cir.moveY;
                if (cir.x > WIDTH) cir.x = 0;
                else if (cir.x < 0) cir.x = WIDTH;
                if (cir.y > HEIGHT) cir.y = 0;
                else if (cir.y < 0) cir.y = HEIGHT;

            }
            draw();
        }, 16);
    }
</script>
<div class="ui middle aligned center Stackable aligned centered grid" style="position: fixed;top:0px;width: 70%;left: 15%">
    <div id="login" class="six wide column">
        <h2 class="ui center aligned icon header">
            <i class="circular users icon"></i>
            SIS
        </h2>
        <form class="ui large form" action="/SIS/desktop/login" method="post">
            <div class="field">
                <div class="ui mini left icon input">
                    <i class="user icon"></i>
                    <input type="text" name="id" placeholder="账号">
                </div>
            </div>
            <div class="field">
                <div class="ui left icon mini input">
                    <i class="lock icon"></i>
                    <input type="password" name="password" placeholder="密码">
                </div>
            </div>
            <div class="ui three column centered Stackable grid field">
                <div class="ui left icon radio checkbox column">
                    <input type="radio" name="type" checked="checked" value="1">
                    <label>管理员</label>
                </div>
                <div class="ui left icon radio checkbox column">
                    <input type="radio" name="type"value="2">
                    <label>教师</label>
                </div>
                <div class="ui left icon radio checkbox column">
                    <input type="radio" name="type"value="3">
                    <label>学生</label>
                </div>
            </div>
            <div class="ui fluid large blue submit button" onclick="checkHeight()">登录</div>
            <div class="ui error message">
            </div>
        </form>

        <div class="ui message" style="background-color: transparent;border: none">
            忘记密码? <a href="javascript:void(0);">请联系教务中心</a>
        </div>
    </div>
    <div id="picture" class="computer only ten wide column" style="height: 100%">
        <div class="content" style="margin-top: 30%;">
            <h2 class="ui header" style="height:100%;line-height: 100%;vertical-align: middle;color: white;margin-left: 5%;font-weight: 100">
                智能化OS
                <div class="sub header" style="color: white;margin-left: 15%">欢迎使用学生信息系统</div>
            </h2>
        </div>
    </div>
</div>
<script>
    $(window).resize(function(){
        $('#picture').outerHeight($('#login').outerHeight())
    });
    $('.ui.checkbox')
        .checkbox()
    ;
    $('#picture').outerHeight($('#login').outerHeight()).fadeIn();
    $('#login').fadeIn();
    $(function(){
        document.onkeydown = function(e){
            var ev = document.all ? window.event : e;
            if(ev.keyCode==13) {
                $('#picture').outerHeight($('#login').outerHeight())
            }
        }
    });//监听回车事件
    function checkHeight() {
        $(document)
            .ready(function() {
                $('#picture').outerHeight($('#login').outerHeight())
            })
        ;
    }
    $(document)
        .ready(function() {
            $('.ui.form')
                .form({
                    fields: {
                        id: {
                            identifier  : 'id',
                            rules: [
                                {
                                    type   : 'empty',
                                    prompt : '请输入账号'
                                }
                            ]
                        },
                        password: {
                            identifier  : 'password',
                            rules: [
                                {
                                    type   : 'empty',
                                    prompt : '请输入密码'
                                },
                                {
                                    type   : 'length[6]',
                                    prompt : '密码长度至少应大于6位'
                                }
                            ]
                        }
                    }
                })
            ;
        })
    ;
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <%--base href="<%=basePath%>">--%>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>学生信息系统</title>
    <script src="../modules/jquery.js"></script>
    <link rel="stylesheet" href="../modules/semantic.css">
    <script src="../modules/semantic.min.js"></script>
    <link rel="stylesheet" href="../css/general.css">
    <link rel="stylesheet" href="../css/index.css">
    <link rel="stylesheet" href="../css/field.css">
    <script src="../js/util.js"></script>
</head>
<body>
<form class="ui form" id="field" method="post" action="/SIS/teacher/update?resourceId=${id}" id="main">
    <div class="ui small menu" id="menu">
        <div class="left menu">
            <div class="item">
                <div class="ui green button" id="save" style="margin-right: 5px">保存</div>
                <div class="ui grey button" id="return">返回</div>
            </div>
        </div>
    </div>
    <div class="ui segment stackable three column grid">
        <div class="column">
            <div class="ui black basic horizontal label">教师编号</div>
            <div class="ui input">
                <input type="text" name="id" value="${id}">
            </div>
        </div>
        <div class="column">
            <div class="ui black basic horizontal label">教师名称</div>
            <div class="ui input">
                <input type="text" name="name" value="${name}">
            </div>
        </div>
        <div class="column">
            <div class="ui black basic horizontal label">教师性别</div>
            <div class="ui input">
                <select class="ui dropdown" name="gender">
                    <option value="0"
                            <c:if test="${gender==\"0\"}">
                                selected=/"selected/"
                            </c:if>
                    >男</option>
                    <option value="1"
                            <c:if test="${gender==\"1\"}">
                                selected=/"selected/"
                            </c:if>
                    >女</option>
                </select>
            </div>
        </div>
    </div>
    <div class="ui error message"></div>
</form>
<script>
    var strs= new Array(); //定义一数组
    strs=window.location.pathname.split("/");
    if(strs.length>0&&strs[strs.length-1]=="open"){
        $('form').attr('action','/SIS/teacher/insert');
    }
    $('#return').click(function () {
        $('#field')
            .form({
                fields: {}
            })
        ;
        setAction('#field','/SIS/teacher/view?curPage=${sessionScope.teacherBack}');
    })
    ;
    $('#save').click(function () {
        $('#field')
            .form({
                fields: {
                    id: {
                        identifier: 'id',
                        rules: [
                            {
                                type: 'empty',
                                prompt: '教师编号不能为空！！！'
                            }
                        ]
                    },
                    name: {
                        identifier: 'name',
                        rules: [
                            {
                                type: 'empty',
                                prompt: '教师名称不能为空！！！'
                            }
                        ]
                    },
                    gender: {
                        identifier: 'gender',
                        rules: [
                            {
                                type: 'empty',
                                prompt: '教师性别不能为空！！！'
                            }
                        ]
                    }
                }
            })
        ;
        $('#field').submit()
    })
    ;
    $('.ui.input').outerWidth($('input').outerWidth());
    $('.ui.dropdown')
        .dropdown()
    ;/*下拉菜单初始化*/
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%
        String basePath = request.getScheme() + "://" +
                request.getServerName() + ":" + request.getServerPort() +
                request.getContextPath() + "/";
    %>
    <base href=<%=basePath%>/>

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        if(window.top!=window){
            window.top.location=window.location; //始终是顶级窗口
        }
        $(function () {
            $("#loginAct").focus()
            $(window).keydown(function (even) {
                if(even.keyCode == 13){
                    $("#submitBtn").click()
                }
            })
            $("#submitBtn").click(function () {
                var loginAct = $.trim($("#loginAct").val());
                var loginPwd = $.trim($("#loginPwd").val());
                //	判断输入的账号和密码是否符合我所要求的规矩
                if (loginAct == "") {
                    $("#msg").html("账号不能为空")
                    return;
                } else if (loginPwd == "") {
                    $("#msg").html("密码不能为空")
                    return;
                }
                $.ajax({
                    url: "<%=basePath%>user/query-exist.do",
                    data: {
                        "loginAct": loginAct,
                        "loginPwd": loginPwd
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        /*后端返回 ： data {success : boolean, msg : error}*/
                        if (data.success) {
                            window.location.href = "<%=basePath%>workbench/index.jsp";
                        } else {
                            $("#msg").html(data.msg);
                        }
                    }
                })

            })
        })
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.jpg" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2020&nbsp;K&nbsp;N&nbsp;Y</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input id="loginAct" class="form-control" type="text" placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input id="loginPwd" class="form-control" type="password" placeholder="密码">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
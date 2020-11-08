<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $(".time1").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd",//显示格式
                minView: "month",//设置只显示到分钟
                autoclose: true,//选中自动关闭
                todayBtn: true, //显示今日按钮
                pickerPosition: "bottom-left"
            });
            $(".time2").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd",//显示格式
                minView: "month",//设置只显示到分钟
                autoclose: true,//选中自动关闭
                todayBtn: true, //显示今日按钮
                pickerPosition: "top-left"
            });

            $.ajax({
                url: "tran/query-allUser.do",  //到user表查询名字 user表的操作都交给 UserController负责
                type: "get",
                dataType: "json",
                success: function (data) {
                    //$("#create-owner").html("")
                    $.each(data, function (i, n) {
                        $("#create-owner").append("<option value='" + n.id + "'>" + n.name + "</option>")
                    })

                    $("#create-owner").val("${user.id}")  //使下拉列表默认选中该用户
                }
            })

            $("#create-CustomerName").typeahead({
                source: function (query, process) {
                    $.get(
                        "tran/getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 1500
            });

            var posJson = eval("(" + "${possibility}" + ")");
            $("#stage").change(function () {
                var stage = $("#stage").val();
                $("#possibility").val(posJson[stage])
            })

            $("#openFindMarketActivity").click(function () {
                $("#findMarketActivity").modal("show")
            })
            $("#search-activity").keydown(function (e) {
                if(e.keyCode == 13){
                    $.ajax({
                        url: "tran/query-activity.do",
                        data:{
                            "name": $(this).val()
                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            var html = "";
                            $.each(data,function(i,n){
                                html += '<tr>' +
                                        '<td><input type="radio" value="'+n.id+'" name="actXZ"/></td>' +
                                        '<td id="'+n.id+'">'+n.name+'</td>' +
                                        '<td>'+n.startDate+'</td>' +
                                        '<td>'+n.endDate+'</td>' +
                                        '<td>'+n.owner+'</td>' +
                                        '</tr>'
                            })
                            $("#actBody").html(html)
                        }
                    })
                    return false;
                }
            })
            $("#actBtn").click(function(){
                var id = $("input[name='actXZ']:checked").val();
                $("#create-activityId").val(id)
                $("#create-activityName").val($("#"+id).html())
                $("#search-activity").val("")
                $("#actBody").html("")
                $("#findMarketActivity").modal("hide")
            })

            //查找联系人相关操作
            $("#openFindContacts").click(function () {
                $("#findContacts").modal("show")
            })
            $("#search-contacts").keydown(function (e) {
                if(e.keyCode == 13){
                    $.ajax({
                        url: "tran/query-contacts.do",
                        data:{
                            "name" : $(this).val()
                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            var html = "";
                            $.each(data,function (i,n) {
                                html += '<tr>' +
                                        '<td><input type="radio" value="'+n.id+'" name="conXZ"/></td>' +
                                        '<td id="'+n.id+'">'+n.fullname+'</td>' +
                                        '<td>'+n.email+'</td>' +
                                        '<td>'+n.mphone+'</td>' +
                                        '</tr>'
                            })
                            $("#conBody").html(html)
                        }
                    })
                    return false;
                }
            })
            $("#conBtn").click(function(){
                var id = $("input[name='conXZ']:checked").val();
                $("#create-contactsId").val(id)
                $("#create-contactsName").val($("#"+id).html())
                $("#search-contacts").val("")
                $("#conBody").html("")
                $("#findContacts").modal("hide")
            })

            $("#subBtn").click(function () {
                $("#tranForm").submit();
            })
        })
    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="search-activity" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="actBody"></tbody>
                </table>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="actBtn">确定</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="search-contacts" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="conBody"></tbody>
                </table>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="conBtn">确定</button>
                </div>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="subBtn">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;" action="tran/save-tran.do" method="post" id="tranForm">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-owner" name="owner"></select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney" name="money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName" name="name">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-CustomerName" name="customerName">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="stage" name="stage">
                <option></option>
                <c:forEach items="${stageList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType" name="type">
                <option></option>
                <c:forEach items="${transactionTypeList}" var="t">
                    <option value="${t.value}">${t.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource" name="source">
                <option></option>
                <c:forEach items="${sourceList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;
            <a href="javascript:void(0);" id="openFindMarketActivity" ><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activityName">
            <input type="hidden" class="form-control" id="create-activityId" name="activityId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;
            <a href="javascript:void(0);" id="openFindContacts"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsName">
            <input type="hidden" class="form-control" id="create-contactsId" name="contactsId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>
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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>


    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;
        $(function () {
            var paramId = "${param.id}"
            var owner = "${param.owner}" //保存市场活动所有者的名字 除了第一次请求外 其余的都是动态赋值  用于显示所有者姓名
            var ownerId;    //保存市场活动所有的id 动态赋值  用于下拉框的默认选项
            //页面初始化完毕后加载活动详细信息和活动备注信息
            initLoad()
            initRemark()

            $(".time").datetimepicker({            //可以为此段专门写一个文件 因为要多处使用
                language: "zh-CN",
                format: "yyyy-mm-dd",//显示格式
                minView: "month",//设置只显示到分钟
                autoclose: true,//选中自动关闭
                todayBtn: true, //显示今日按钮
                pickerPosition: "bottom-left"
            });

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });


            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })


            $("#edit-activityBtn").click(function () {
                $.ajax({
                    url: "activity/query-allUser.do",
                    type: "get",
                    dataType: "json",
                    success: function (data) {     //{list}
                        //初始化模态窗口
                        $("#edit-activityOwner").html("")
                        $.each(data, function (i, n) {
                            $("#edit-activityOwner").append("<option value='" + n.id + "'>" + n.name + "</option>")
                        })
                        $("#edit-activityOwner").val(ownerId)  //使下拉列表默认选中该用户

                        $("#edit-activityName").val($("#show-activityName").text())
                        $("#edit-startDate").val($("#show-startDate").text())
                        $("#edit-endDate").val($("#show-endDate").text())
                        $("#edit-cost").val($("#show-cost").text())
                        $("#edit-describe").val($("#show-describe").text())

                        $("#editActivityModal").modal("show");
                    }
                })
            })

            $("#update-activity").click(function () {
                var activityName = $.trim($("#edit-activityName").val());
                //判断是否是合法输入...
                if (activityName == "") {
                    alert("请完善 * 所标识的内容")
                    return;
                }

                if ($("#edit-startDate").val() > $("#edit-endDate").val()) {
                    alert("活动开始日期不能大于结束日期")
                    return;
                }
                $.ajax({
                    url: "activity/update-activity.do",
                    data: {
                        "id": paramId,
                        "owner": $.trim($("#edit-activityOwner").val()),
                        "name": activityName,
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-describe").val())
                    },
                    type: "post",
                    dataType: "json",
                    // {success : boolean}
                    success: function (data) {
                        if (data.success) {
                            initLoad();
                            //关闭模态窗口
                            $("#editActivityModal").modal("hide");

                            //修改下拉框默认选项
                            ownerId = $.trim($("#edit-activityOwner").val());
                            //初始化所有者姓名
                            owner = $.trim($("#edit-activityOwner option:checked").text())

                            //初始化 备注信息列表的活动名称
                            $("b[name=activityName]").text(activityName)
                        } else {
                            alert(data.msg);
                        }
                    }
                })
            })

            $("#del-activityBtn").click(function () {
                if (confirm("确认删除吗？删除后不可恢复")) {
                    $.ajax({
                        url: "activity/del-activityList.do",
                        data: {
                            "id": paramId
                        },
                        type: "post",
                        dataType: "json",
                        //接收   {success:boolean}
                        success: function (data) {
                            if (data.success) {
                                window.location.href = 'workbench/activity/index.jsp';
                            } else {
                                alert("删除失败")
                            }
                        }

                    })
                }
            })

            $("#save-remark").click(function () {
                var noteContent = $.trim($("#remark").val());
                if (noteContent == "" || noteContent == null) {
                    alert("请输入有效内容" + noteContent)
                    return;
                }
                $.ajax({
                    url: "activity/save-remark.do",
                    data: {
                        "activityId": paramId,
                        "noteContent": noteContent
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        //  data{success: boolean, remark:ActivityRemark对象}
                        if (data.success) {
                            $("#remarkDiv").before('<div class="remarkDiv" style="height: 60px;">\n' +
                                '<img title="' + data.remark.createBy + '" src="image/user-thumbnail.png" style="width: 30px; height:30px;">\n' +
                                '<div style="position: relative; top: -40px; left: 40px;">\n' +
                                '<h5 id="h' + data.remark.id + '">' + data.remark.noteContent + '</h5>\n' +
                                '<font color="gray">市场活动</font> <font color="gray">-</font> <b name="activityName">' + $("#show-activityName").text() + '</b>' +
                                '<small id="s' + data.remark.id + '" style="color: gray;">\n' + data.remark.createTime + '由' + data.remark.createBy + '</small>\n' +
                                '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">\n' +
                                '<a class="myHref" href="javascript:void(0);" onclick=editRemark("' + data.remark.id + '")>' +
                                '<span class="glyphicon glyphicon-edit"\n style="font-size: 20px; color: #00FF00;"></span></a>\n' +
                                '&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                                '<a class="myHref" href="javascript:void(0);" onclick=delRemark("' + data.remark.id + '")>' +
                                '<span class="glyphicon glyphicon-remove"\n style="font-size: 20px; color: #FF0000;"></span></a>\n' +
                                '</div>\n' +
                                '</div>\n' +
                                '</div>');
                            //清空文本域
                            $("#remark").val("");
                            //触发 取消按钮 单击事件
                            $("#cancelBtn").click()
                        } else {
                            alert("保存失败 请稍后再试")
                        }
                    }
                })
            })

            $("#updateRemarkBtn").click(function () {
                var content = $.trim($("#edit-content").val())
                var id = $.trim($("#remarkId").val());
                if (content == "" || content == null) {
                    alert("内容不能为空")
                    return;
                }

                $.ajax({
                    url: "activity/update-remark.do",
                    data: {
                        "id": id,
                        "noteContent": content
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) { // data{success: false, editTime: editTime, editBy:editBy}
                        if (data.success) {
                            //修改成功后 刷新页面上的旧数据
                            $("#h" + id).text(content)
                            $("#s"+id).text(data.editTime + '由' + data.editBy)
                            $("#editRemarkModal").modal("hide")
                        } else {
                            alert("修改失败")
                        }
                    }

                })
            })

            //以下两个方法需要用到 jquery代码块中的变量 所以声明在 jquery中
            function initLoad() {
                $.ajax({
                    url: "activity/query-showActivity.do",
                    data: {
                        "id": paramId
                    },
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        //给ownerId赋值 修改市场活动的 所有者下拉框 默认选项
                        ownerId = data.owner;
                        // {Activity对象{id:...,name:...}}
                        $("#title").html(data.name + "<small>" + data.startDate + "~" + data.endDate + "</small>")

                        $("#show-activityOwner").text(owner)
                        $("#show-activityName").text(data.name)
                        $("#show-startDate").text(data.startDate)
                        $("#show-endDate").text(data.endDate)
                        $("#show-cost").text(data.cost)
                        $("#show-createBy").text(data.createBy)
                        $("#show-createTime").text(data.createTime)
                        $("#show-editBy").text(data.editBy)
                        $("#show-editTime").text(data.editTime)
                        $("#show-describe").text(data.description)
                    }
                })
            }

            function initRemark() {
                $.ajax({
                    url: "activity/query_showRemark.do",
                    data: {
                        "activityId": paramId
                    },
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        //data{{Object:ActivityRemark对象},...}
                        var html = "";
                        $.each(data, function (i, n) {
                            html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">\n' +
                                '<img title="' + n.createBy + '" src="image/user-thumbnail.png" style="width: 30px; height:30px;">\n' +
                                '<div style="position: relative; top: -40px; left: 40px;">\n' +
                                '<h5 id="h' + n.id + '">' + n.noteContent + '</h5>\n' +
                                '<font color="gray">市场活动</font> <font color="gray">-</font> <b name="activityName">' + $("#show-activityName").text() + '</b>' +
                                '<small id="s' + n.id + '" style="color: gray;">' + (n.editFlag == "0" ? n.createTime : n.editTime) + '由' + (n.editFlag == "0" ? n.createBy : n.editBy) + '</small>\n' +
                                '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">\n' +
                                '<a class="myHref" href="javascript:void(0);" onclick=editRemark("' + n.id + '")>' +
                                '<span class="glyphicon glyphicon-edit"\n style="font-size: 20px; color: #00FF00;"></span></a>\n' +
                                '&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                                '<a class="myHref" href="javascript:void(0);" onclick=delRemark("' + n.id + '")>' +
                                '<span class="glyphicon glyphicon-remove"\n style="font-size: 20px; color: #FF0000;"></span></a>\n' +
                                '</div>\n' +
                                '</div>\n' +
                                '</div>'
                        })
                        $("#remarkDiv").before(html)
                    }
                })
            }

        });

        function delRemark(id) {
            if(confirm("确认删除")) {
                $.ajax({
                    url: "activity/del-remark.do",
                    data: {
                        "id": id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            $("#" + id).remove()
                        } else {
                            alert("删除失败")
                        }
                    }
                })
            }
        }

        function editRemark(id) {
            $("#remarkId").val(id)
            $("#edit-content").val($("#h" + id).text())
            $("#editRemarkModal").modal("show")
        }

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-content"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-activityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-activityOwner"></select>
                        </div>
                        <label for="edit-activityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-activityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate" readonly>
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update-activity">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3 id="title"></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="edit-activityBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" id="del-activityBtn" class="btn btn-danger"><span
                class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="show-activityOwner"></b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="show-activityName"></b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="show-startDate"></b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="show-endDate"></b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="show-cost"></b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b id="show-createBy"></b>
            <small style="font-size: 10px; color: gray;" id="show-createTime"></small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b id="show-editBy">&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;" id="show-editTime"></small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="show-describe"></b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="save-remark">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>
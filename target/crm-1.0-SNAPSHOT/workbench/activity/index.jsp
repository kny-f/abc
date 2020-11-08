<%@ page import="com.kny.crm.utils.DateTimeUtil" %>
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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>
    <%--	引用bootstrap datetimepicker（日期拾取器）插件 （1）引入jQuery的库（2）引入bootstrap的库（3）引入datetimepicker的css库和js库（注意引入先后顺序）--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <%--    pagination分页插件相关css和js--%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

        $(function () {
            //页面加载完毕显示活动列表
            pageList(1,5)

            $(".time").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd",//显示格式
                minView: "month",//设置只显示到分钟
                autoclose: true,//选中自动关闭
                todayBtn: true, //显示今日按钮
                pickerPosition: "bottom-left"
            });

            $("#create-search-owner").click(function () {
                //当点击创建的时候 发送ajax请求到服务器查询user表的所有user  接收 list<user> 集合
                $.ajax({
                    url: "activity/query-allUser.do",  //到user表查询名字 user表的操作都交给 UserController负责
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        // {list}
                        $("#create-ActivityOwner").html("")
                        $.each(data, function (i, n) {
                            $("#create-ActivityOwner").append("<option value='" + n.id + "'>" + n.name + "</option>")
                        })

                        //初始化模态窗口
                        $("#create-ActivityOwner").val("${user.id}")  //使下拉列表默认选中该用户
                        $("#create-ActivityName").val("")
                        $("#create-startDate").val("<%=DateTimeUtil.getYMDTime()%>")
                        $("#create-endDate").val("<%=DateTimeUtil.getYMDTime()%>")
                        $("#create-cost").val("")
                        $("#create-describe").val("")

                        $("#createActivityModal").modal("show")     //显示模态窗口
                    }
                })
            })

            $("#add-Activity").click(function () {
                //判断是否是合法输入...
                if ($.trim($("#create-ActivityName").val()) == "") {
                    alert("请完善 * 所标识的内容")
                    return;
                }

                if ($("#create-startDate").val() > $("#create-endDate").val()) {
                    alert("活动开始日期不能大于结束日期")
                    return;
                }
                $.ajax({
                    url: "activity/save-activity.do",
                    data: {

                        "owner": $.trim($("#create-ActivityOwner").val()),
                        "name": $.trim($("#create-ActivityName").val()),
                        "startDate": $.trim($("#create-startDate").val()),
                        "endDate": $.trim($("#create-endDate").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-describe").val())
                    },
                    type: "post",
                    dataType: "json",
                    // {success : boolean}
                    success: function (data) {
                        if (data.success) {
                            //刷新市场活动列表
                            pageList(1 ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //关闭模态窗口
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert(data.msg);
                        }
                    }
                })
            })

            $("#edit-search-activity").click(function () {
                var $xz = $("input[name=xz]:checked");
                if($xz.length > 1){
                    alert("不能选择多个活动记录")
                    return;
                }
                if($xz.length < 1){
                    alert("请选择要修改的活动")
                    return;
                }

                $.ajax({
                    url: "activity/query-activity.do",
                    data: {
                        "id": $xz.val()
                    },
                    type: "get",
                    dataType: "json",
                    success : function (data) {     //{userList:{user1,user2...}, activity: Activity对象}
                        //初始化模态窗口
                        $("#edit-ActivityOwner").html("")
                        $.each(data.userList, function (i, n) {
                            $("#edit-ActivityOwner").append("<option value='" + n.id + "'>" + n.name + "</option>")
                        })
                        $("#edit-ActivityOwner").val(data.activity.owner)  //使下拉列表默认选中
                        $("#edit-ActivityName").val(data.activity.name)
                        $("#edit-startDate").val(data.activity.startDate)
                        $("#edit-endDate").val(data.activity.startDate)
                        $("#edit-cost").val(data.activity.cost)
                        $("#edit-describe").val(data.activity.description)

                        $("#editActivityModal").modal("show");
                    }
                })
            })

            $("#update-activity").click(function () {
                //判断是否是合法输入...
                if ($.trim($("#edit-ActivityName").val()) == "") {
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
                        "id": $("input[name=xz]:checked").val(),
                        "owner": $.trim($("#edit-ActivityOwner").val()),
                        "name": $.trim($("#edit-ActivityName").val()),
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
                            //刷新市场活动列表 更新后，在哪一页还回到哪一页
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage'),
                                $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //关闭模态窗口
                            $("#editActivityModal").modal("hide");
                        } else {
                            alert(data.msg);
                        }
                    }
                })
            })

            $("#search-activityBtn").click(function () {

                $("#hide-search-name").val($("#search-name").val())
                $("#hide-search-owner").val($("#search-owner").val())
                $("#hide-search-startDate").val($("#search-startDate").val())
                $("#hide-search-endDate").val($("#search-endDate").val())

                pageList(1 ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            //复选框全选
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked",this.checked)
            })
            $("#show-activity").on("click",$("input[name=xz]"),function () {
                $("#qx").prop("checked",$("input[name=xz]:checked").length == $("input[name='xz']").length)
            })

            $("#del-btn").click(function () {
                var $xz = $("input[name=xz]:checked");
                if($xz.length < 1){
                    return;
                }
                if(confirm("确认删除吗？删除后不可恢复")){

                    var pram = "";
                    for (var i = 0; i < $xz.length; i++) {
                        if (i > 0) {
                            pram += "&";
                        }
                        pram += "id=" + $($xz[i]).val()
                    }
                    $.ajax({
                        url: "activity/del-activityList.do",
                        data: pram,
                        type: "post",
                        dataType: "json",
                        //接收   {success:boolean}
                        success: function (data) {
                            if (data.success) {
                                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                                alert("删除成功")
                            } else {
                                alert("删除失败")
                            }
                        }

                    })
                }
            })

        });

        function pageList(pageNo, pageSize) {
            $("#qx").prop("checked",false) //当活动列表刷新时 使全选按钮为false
            $.ajax({
                url: "activity/query-pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#hide-search-name").val()),
                    "owner": $.trim($("#hide-search-owner").val()),
                    "startTime": $.trim($("#hide-search-startDate").val()),
                    "endTime": $.trim($("#hide-search-endDate").val())

                },
                type: "get",
                dataType: "json",
                //接收 { total : 总条数，list{activity...} }
                success: function (data) {
                    //填充activity
                    $("#show-activity").html("")
                    $.each(data.list,function (i,n) {
                        $("#show-activity").append("<tr><td><input type='checkbox' name='xz' value='"+ n.id +"'/></td>" +
                            "<td><a style=\"text-decoration: none; cursor: pointer;\"" +
                            "onclick=\"window.location.href='workbench/activity/detail.jsp?id="+n.id+"&owner="+n.owner+"'\";>"+ n.name +"</a></td>" +
                            "<td>"+ n.owner +"</td>" +
                            "<td>"+ n.startDate +"</td>" +
                            "<td>"+ n.endDate +"</td>" +
                            "</tr>")
                    })

                    var totalPages = data.total % pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize) + 1;
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                            $("#search-name").val($("#hide-search-name").val())
                            $("#search-owner").val($("#hide-search-owner").val())
                            $("#search-startDate").val($("#hide-search-startDate").val())
                            $("#search-endDate").val($("#hide-search-endDate").val())
                        }
                    });
                }
            })
        }

    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-ActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-ActivityOwner">
                                <%--此处使用服务器发送过来的数据进行填充--%>
                            </select>
                        </div>
                        <label for="create-ActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-ActivityName" placeholder="30字以内">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe" placeholder="200字以内"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="add-Activity">保存</button>
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
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-ActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-ActivityOwner"></select>
                        </div>
                        <label for="edit-ActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-ActivityName">
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
                            <input type="text" class="form-control" id="edit-cost" >
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

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input id="search-name" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="search-owner" class="form-control" type="text">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input id="search-startDate" class="form-control time" type="text" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input id="search-endDate" class="form-control time" type="text" readonly>
                    </div>
                </div>

                <button id="search-activityBtn" type="button" class="btn btn-default">查询</button>
                <button type="reset" class="btn btn-default">清空</button>
            </form>
            <input id="hide-search-name" hidden>
            <input id="hide-search-owner" hidden>
            <input id="hide-search-startDate" hidden>
            <input id="hide-search-endDate" hidden>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" id="create-search-owner" class="btn btn-primary">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" id="edit-search-activity" class="btn btn-default">
                    <span class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" id="del-btn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="show-activity">
                    <%--填充后端数据--%>
                </tbody>
            </table>
        </div>

        <div id="activityPage"></div>

    </div>

</div>
</body>
</html>
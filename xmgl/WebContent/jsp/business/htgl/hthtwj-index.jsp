<!DOCTYPE html>
<html>
<head>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/tld/base.tld" prefix="app"%>
<app:base/>
<title>合同文件首页</title>
<script src="${pageContext.request.contextPath }/js/common/xWindow.js"></script>
<script type="text/javascript" charset="utf-8">
//请求路径，对应后台RequestMapping
var controllername= "${pageContext.request.contextPath }/htgl/gcHtglHtWjController.do";

//页面初始化
$(function() {
	init();
	//按钮绑定事件（查询）
	$("#btnQuery").click(function() {
		//生成json串
		var data = combineQuery.getQueryCombineData(queryForm,frmPost,DT1);
		//调用ajax插入
		defaultJson.doQueryJsonList(controllername+"?query",data,DT1);
	});
	//按钮绑定事件(新增)
	$("#btnInsert").click(function() {
		parent.$("body").manhuaDialog({"title":"合同文件>新增","type":"text","content":"${pageContext.request.contextPath }/jsp/business/htgl/hthtwj-add.jsp?type=insert","modal":"1"});
	});
	//按钮绑定事件(修改)
	$("#btnUpdate").click(function() {
		if($("#DT1").getSelectedRowIndex()==-1)
		 {
			requireSelectedOneRow();
		    return
		 }
		$("#resultXML").val($("#DT1").getSelectedRow());
		parent.$("body").manhuaDialog({"title":"合同文件>修改","type":"text","content":"${pageContext.request.contextPath }/jsp/business/htgl/hthtwj-add.jsp?type=update","modal":"1"});
	});
	//按钮绑定事件（导出EXCEL）
	$("#btnExpExcel").click(function() {
		 var t = $("#DT1").getTableRows();
		 if(t<=0)
		 {
			 xAlert("提示信息","请至少查询出一条记录！");
			 return;
		 }
	  	 $("body").manhuaDialog({"title":"导出","type":"text","content":"${pageContext.request.contextPath }/jsp/framework/print/TabListEXP.jsp?tabId=DT1","modal":"3"});
	});
	//按钮绑定事件（清空）
    $("#btnClear").click(function() {
        $("#queryForm").clearFormResult();
    });
	
});

//页面默认参数
function init(){
	//生成json串
	var data = combineQuery.getQueryCombineData(queryForm,frmPost,DT1);
	//调用ajax插入
	defaultJson.doQueryJsonList(controllername+"?query",data,DT1);
}

//点击获取行对象
function tr_click(obj,tabListid){
	//alert(JSON.stringify(obj));
}

//回调函数--用于修改新增
getWinData = function(data){
	//var subresultmsgobj = defaultJson.dealResultJson(data);
	var data1 = defaultJson.packSaveJson(data);
	if(JSON.parse(data).ID == "" || JSON.parse(data).ID == null){
		defaultJson.doInsertJson(controllername + "?insert", data1,DT1);
	}else{
		defaultJson.doUpdateJson(controllername + "?update", data1,DT1);
	}
	
};

//详细信息
function rowView(index){
	$("#DT1").setSelect(index);
	if($("#DT1").getSelectedRowIndex()==-1)
	 {
		requireSelectedOneRow();
	    return
	 }
	$("#resultXML").val($("#DT1").getSelectedRow());
	parent.$("body").manhuaDialog({"title":"合同文件>详细信息","type":"text","content":"${pageContext.request.contextPath }/jsp/business/htgl/hthtwj-add.jsp?type=detail","modal":"1"});
}
</script>
</head>
<body>
<app:dialogs/>
<div class="container-fluid">
	<p></p>
	<div class="row-fluid">
		<div class="B-small-from-table-autoConcise">
			<h4 class="title">
				合同文件
				<span class="pull-right">  
					<button id="btnInsert" class="btn" type="button" style="font-family:SimYou,Microsoft YaHei;font-weight:bold;">新增</button>
      				<button id="btnUpdate" class="btn" type="button" style="font-family:SimYou,Microsoft YaHei;font-weight:bold;">修改</button>
      				<button id="btnExpExcel" class="btn" type="button" style="font-family:SimYou,Microsoft YaHei;font-weight:bold;">导出</button>
				</span>
			</h4>
			<form method="post" id="queryForm">
				<table class="B-table" width="100%">
					<!--可以再此处加入hidden域作为过滤条件 -->
					<TR style="display: none;">
						<TD class="right-border bottom-border"></TD>
						<TD class="right-border bottom-border">
							<INPUT type="text" class="span12" kind="text" id="num" fieldname="rownum" value="1000" operation="<="/>
						</TD>
					</TR>
					<!--可以再此处加入hidden域作为过滤条件 -->
					<tr>
						<td width="7%" class="right-border bottom-border">
							<select class="span12" id="QND" name="ND" fieldname="ND" operation="=" kind="dic" src="XMNF"  defaultMemo="-年度-">
						</td>
						<th width="5%" class="right-border bottom-border text-right">项目名称</th>
						<td class="right-border bottom-border" width="20%">
							<input class="span12" type="text" id="QXMMC" name="XMMC" fieldname="XMMC" operation="like" >
						</td>
						
						
			            <td class="text-left bottom-border text-right">
	                        <button id="btnQuery" class="btn btn-link"  type="button" style="font-family:SimYou,Microsoft YaHei;font-weight:bold;"><i class="icon-search"></i>查询</button>
           					<button id="btnClear" class="btn btn-link" type="button" style="font-family:SimYou,Microsoft YaHei;font-weight:bold;"><i class="icon-trash"></i>清空</button>
			            </td>							
					</tr>
				</table>
			</form>
			<div style="height:5px;"> </div>	
			<div class="overFlowX">
	            <table width="100%" class="table-hover table-activeTd B-table" id="DT1" type="single"  pageNum="18">
	                <thead>
	                	<tr>
	                		<th  name="XH" id="_XH" style="width:10px" colindex=1 tdalign="center">&nbsp;#&nbsp;</th>
							<th fieldname="HTBM" colindex=3 tdalign="center" maxlength="30" >&nbsp;合同编码&nbsp;</th>
							<th fieldname="HTMC" colindex=4 tdalign="center" maxlength="30"  hasLink="true" linkFunction="rowView">&nbsp;合同名称&nbsp;</th>
							<th fieldname="HTLX" colindex=1 tdalign="center" maxlength="30" >&nbsp;合同类型&nbsp;</th>
							<th fieldname="HTZT" colindex=6 tdalign="center" maxlength="30" >&nbsp;合同状态&nbsp;</th>
							<th fieldname="WJLX" colindex=2 tdalign="center" maxlength="30" >&nbsp;文件类型&nbsp;</th>
							<th fieldname="JDLX" colindex=3 tdalign="center" maxlength="30" >&nbsp;节点类型&nbsp;</th>
							<th fieldname="WJMC" colindex=4 tdalign="center" maxlength="30" >&nbsp;文件名称&nbsp;</th>
							<th fieldname="WJKZM" colindex=5 tdalign="center" >&nbsp;文件扩展名&nbsp;</th>
							<th fieldname="WJDX" colindex=6 tdalign="center" >&nbsp;文件大小(Byte)&nbsp;</th>
							<th fieldname="MIMELX" colindex=7 tdalign="center" maxlength="30" >&nbsp;MIME_TYPE&nbsp;</th>
	                	</tr>
	                </thead>
	              	<tbody></tbody>
	           </table>
	       </div>
	 	</div>
	</div>     
</div>
<div align="center">
	<FORM name="frmPost" method="post" style="display: none" target="_blank">
		<!--系统保留定义区域-->
		<input type="hidden" name="queryXML"/> 
		<input type="hidden" name="txtXML"/>
		<input type="hidden" name="txtFilter" order="desc" fieldname="t.LRSJ" id="txtFilter"/>
		<input type="hidden" name="resultXML" id="resultXML"/>
		<!--传递行数据用的隐藏域-->
		<input type="hidden" name="rowData"/>
		<input type="hidden" name="queryResult" id="queryResult"/>
	</FORM>
</div>
</body>
</html>
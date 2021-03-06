<!DOCTYPE html>
<html>
<head>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/tld/base.tld" prefix="app"%>
<%@ page import="com.ccthanking.framework.common.User"%>
<%@ page import="com.ccthanking.framework.common.OrgDept"%>
<%@ page import="com.ccthanking.framework.Globals"%>
<%@ page import="com.ccthanking.framework.util.Pub"%>
<app:base/>
<title>部门提请款首页</title>
<%
String type=request.getParameter("type");
//获取当前用户信息
User user = (User) request.getSession().getAttribute(Globals.USER_KEY);
OrgDept dept = user.getOrgDept();
String deptId = dept.getDeptID();
String deptName = dept.getDept_Name();
String userid = user.getAccount();
String username = user.getName();
String sysdate = Pub.getDate("yyyy-MM-dd");
String cYear = Pub.getDate("yyyy");
String cMonth = Pub.getDate("MM");

%>
<script src="${pageContext.request.contextPath }/js/common/xWindow.js"></script>
<script type="text/javascript" charset="utf-8">
//请求路径，对应后台RequestMapping
var controllername= "${pageContext.request.contextPath }/zjgl/gcZjglTqkbmController.do";

//计算本页表格分页数
function setPageHeight(){
	var height = g_iHeight-pageTopHeight-pageTitle-pageQuery-getTableTh(1)-pageNumHeight;
	var pageNum = parseInt(height/pageTableOne,10);
	$("#DT1").attr("pageNum",pageNum);
}

//页面初始化
$(function() {
	setPageHeight();
	init();
	//按钮绑定事件（查询）
	$("#btnQuery").click(function() {
		//生成json串
		var data = combineQuery.getQueryCombineData(queryForm,frmPost,DT1);
		//调用ajax插入
		defaultJson.doQueryJsonList(controllername+"?query&opttype=tqkzh",data,DT1);
	});
	//按钮绑定事件(新增)
	$("#btnInsert").click(function() {
		if($("#DT1").getSelectedRowIndex()==-1)
		 {
			requireSelectedOneRow();
		    return
		 }
		$("#resultXML").val($("#DT1").getSelectedRow());
		var rowValue = $("#DT1").getSelectedRow();
		var tempJson = convertJson.string2json1(rowValue);
		var idvar = tempJson.ID;
		$(window).manhuaDialog({"title":"提请款>处理","type":"text","content":"${pageContext.request.contextPath }/jsp/business/zjgl/tqk-add-zh.jsp?type=insert&QKLX="+tempJson.QKLX+"&QKNF="+tempJson.QKNF+"&YF="+tempJson.GCPC+"&TQKID="+tempJson.ID,"modal":"1"});
	});
	$("#btnUpdateBM").click(function() {
		if($("#DT1").getSelectedRowIndex()==-1)
		 {
			requireSelectedOneRow();
		    return
		 }
		
		xConfirm("信息确认","提交后记录为不可修改！是否确认提交所选的记录？ ");
		
		$('#ConfirmYesButton').attr('click','');
		$('#ConfirmYesButton').one("click",function(){
			var rowValue = $("#DT1").getSelectedRow();
			var tempJson = convertJson.string2json1(rowValue);
			//更新记录为提交状态
			$("#QTQKZT").val("2");
			$("#QID").val(tempJson.ID);
		    //生成json串
		    var data = Form2Json.formToJSON(queryFormTqkBmChange);
		  	//组成保存json串格式
		    var data1 = defaultJson.packSaveJson(data);
		    var success= defaultJson.doUpdateJson(controllername + "?update&opttype=bm", data1);
		    if(success==true)
			{
		    	//$("#btnInsert_bm").attr("disabled", true);
		    	$("#btnQuery").click();
			}
		});
	});
	
	$("#btnUpdateCWB").click(function() {
		if($("#DT1").getSelectedRowIndex()==-1)
		 {
			requireSelectedOneRow();
		    return
		 }
		$("#resultXML").val($("#DT1").getSelectedRow());
		$(window).manhuaDialog({"title":"部门提请款>提交财务部","type":"text","content":"${pageContext.request.contextPath }/jsp/business/zjgl/tqkbm-add-cwb.jsp?type=update","modal":"1"});
	});
	
	
	//按钮绑定事件（导出EXCEL）
	$("#btnExpExcel").click(function() {
	  	 $(window).manhuaDialog({"title":"导出","type":"text","content":"${pageContext.request.contextPath }/jsp/framework/print/TabListEXP.jsp?tabId=DT1","modal":"3"});
	});
	//按钮绑定事件（清空）
    $("#btnClear").click(function() {
        $("#GCPC").val("");
        $("#QKLX").val("");
        $("#TQKZT").val("");
        $("#SQDW").val("");
        
        getNd();
    });
	
  	 //TQKZT   移除
	 $("#TQKZT option[value='1']").remove();
	 $("#TQKZT option[value='2']").remove();
	 $("#TQKZT option[value='3']").remove();
});

//页面默认参数
function init(){
	getNd();
	g_bAlertWhenNoResult = false;
	//生成json串
	var data = combineQuery.getQueryCombineData(queryForm,frmPost,DT1);
	//调用ajax插入
	defaultJson.doQueryJsonList(controllername+"?query&opttype=tqkzh",data,DT1,null,true);
	g_bAlertWhenNoResult = true;
}
//默认年度
function getNd(){
	//年度信息，里修改
	var y = new Date().getFullYear();
	$("#QND option").each(function(){
		if(this.value == y){
		 	$(this).attr("selected", true);
		 	return true;
		}
	});
}

//点击获取行对象
function tr_click(obj,tabListid){
	//alert(JSON.stringify(obj));
	if(obj.TQKZT=="4"){
		if(obj.BMJLS>obj.CWJLS){
			$("#btnInsert").attr("disabled",false);
		}else{
			$("#btnInsert").attr("disabled",true);
		}
	}else if(obj.TQKZT=="5"){
		$("#btnInsert").attr("disabled",true);
	}else if(obj.TQKZT=="6"){
		$("#btnInsert").attr("disabled",true);
	}else if(obj.TQKZT=="7"){
		$("#btnInsert").attr("disabled",true);
	}
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
	$(window).manhuaDialog({"title":"部门提请款>详细信息","type":"text","content":"${pageContext.request.contextPath }/jsp/business/zjgl/tqkbm-add.jsp?type=detail","modal":"1"});
}
function rowView1(t){
	if($("#DT1").getSelectedRowIndex()==-1)
	 {
		requireSelectedOneRow();
	    return
	 }
	
	var rowValue = $("#DT1").getSelectedRow();
	var tempJson = convertJson.string2json1(rowValue);
	var idvar = tempJson.ID;
	
	$(window).manhuaDialog({"title":"部门提请款>详细信息","type":"text","content":"${pageContext.request.contextPath }/jsp/business/zjgl/tqkbm-view.jsp?type=detail&id="+idvar,"modal":"1"});
}

function doRandering(obj){
	var showHtml = "";
	showHtml = "<a href='javascript:rowView1(this);' title='查看详细信息'><i class='icon-file showXmxxkInfo'></i></a>";
	return showHtml;
}


function doRandering_bmze(obj){
	var showHtml = "";
	if(obj.BMZE!=""){
		showHtml = obj.BMZE_SV;
	}else{
		showHtml = '<div style="text-align:center">—</div>';
	}
	return showHtml;
}
function doRandering_cwze(obj){
	var showHtml = "";
	if(obj.CWZE!=""){
		showHtml = obj.CWZE_SV;
	}else{
		showHtml = '<div style="text-align:center">—</div>';
	}
	return showHtml;
}
function doRandering_jcze(obj){
	var showHtml = "";
	if(obj.JCZE!=""){
		showHtml = obj.JCZE_SV;
	}else{
		showHtml = '<div style="text-align:center">—</div>';
	}
	return showHtml;
}
function doRandering_CWJLS(obj){
	var showHtml = "";
	if(obj.CWJLS!="0"){
		showHtml = obj.CWJLS;
	}else{
		showHtml = '<div style="text-align:center">—</div>';
	}
	return showHtml;
}
function doRandering_JCJLS(obj){
	var showHtml = "";
	if(obj.JCJLS!="0"){
		showHtml = obj.JCJLS;
	}else{
		showHtml = '<div style="text-align:center">—</div>';
	}
	return showHtml;
}

//状态颜色判断
function docolor(obj)
{
	var xqzt=obj.TQKZT;
	if(xqzt=="4"){
	  	return '<span class="label label-danger">'+obj.TQKZT_SV+'</span>';
	}else if(xqzt=="5"){
		return '<span class="label label-warning">'+obj.TQKZT_SV+'</span>';
	}else if(xqzt=="6"){
	 	return '<span class="label label-success">'+obj.TQKZT_SV+'</span>';
	}else if(xqzt=="7"){
	 	return '<span class="label label-success">'+obj.TQKZT_SV+'</span>';
	}else{
		return obj.TQKZT_SV;
	}
	
}

function closeParentCloseFunction(){
	$("#btnQuery").click();
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
				部门提请款综合
				<span class="pull-right">  
					<button id="btnInsert" class="btn" type="button" style="font-family:SimYou,Microsoft YaHei;font-weight:bold;" >处理</button>
<%--					title="条件：只有待处理的提请款才可以进行处理并且部门请款情况明细大于财务审核情况明细"--%>
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
							<input type="hidden" fieldname="TQKZT" operation=">=" value="4"/>
						</TD>
					</TR>
					<!--可以再此处加入hidden域作为过滤条件 -->
					<tr>
						<th width="5%" class="right-border bottom-border text-right">年度</th>
						<td width="8%" class="right-border bottom-border">
							<select class="span12" id="QND" name="QKNF" fieldname="QKNF" operation="=" kind="dic" src="XMNF"  defaultMemo="-年度-">
						</td>
						<th width="5%" class="right-border bottom-border text-right">月份</th>
						<td width="10%" class="right-border bottom-border">
							<select  id="GCPC"   class="span12"  name="GCPC" fieldname="GCPC" operation="="  kind="dic" src="YF"  defaultMemo="-请选择-">
						</td>
						<th width="5%" class="right-border bottom-border text-right">请款类型</th>
						<td width="10%" class="right-border bottom-border">
							<select id="QKLX" class="span12"  name="QKLX" fieldname="QKLX"  operation="=" kind="dic" src="QKLX"  defaultMemo="-请选择-">
						</td>
						<th width="5%" class="right-border bottom-border text-right">状态</th>
						<td width="10%" class="right-border bottom-border">
							<select  style="width:100%;" id="TQKZT"   class="span12"  name="TQKZT" fieldname="TQKZT" operation="="  kind="dic" src="TQKZT"  defaultMemo="-请选择-">
						</td>
						<th width="5%" class="right-border bottom-border text-right">请款部门</th>
						<td width="10%" class="right-border bottom-border">
							<select type="text" fieldname="SQDW" name="SQDW" id="SQDW" kind="dic" src="T#VIEW_YW_ORG_DEPT:ROW_ID:DEPT_NAME" operation="="></select></td>
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
	            <table width="100%" class="table-hover table-activeTd B-table" id="DT1" type="single"  pageNum="18" printFileName="部门提请款综合">
	                <thead>
	                	<tr>
	                		<th rowspan="2"  name="XH" id="_XH"  colindex=1 tdalign="center">&nbsp;#&nbsp;</th>
	                		<th rowspan="2" fieldname="ID" tdalign="center" colindex=2 noprint="true" CustomFunction="doRandering">&nbsp;&nbsp;</th>
	                		<th rowspan="2" fieldname="TQKZT" colindex=3 tdalign="center" CustomFunction="docolor">&nbsp;状态&nbsp;</th>
	                		<th rowspan="2" fieldname="QKNF" colindex=4 tdalign="center" maxlength="30" >&nbsp;年份&nbsp;</th>
	                		<th rowspan="2" fieldname="GCPC" colindex=5 tdalign="center" maxlength="30" >&nbsp;月份&nbsp;</th>
	                		<th rowspan="2" fieldname="SQDW" colindex=6 tdalign="center" maxlength="30" >&nbsp;申请单位&nbsp;</th>
							<th rowspan="2" fieldname="QKLX" colindex=7 tdalign="center" maxlength="30" >&nbsp;请款类型&nbsp;</th>
							<th colspan="3">&nbsp;部门请款情况&nbsp;</th>
							<th colspan="2">&nbsp;财务审核情况&nbsp;</th>
							<th colspan="2">&nbsp;计财审定情况&nbsp;</th>
							<th rowspan="2" fieldname="BZRQ" colindex=15 tdalign="center">&nbsp;编制日期&nbsp;</th>
							<th rowspan="2" fieldname="BMBLRID" colindex=16 tdalign="center">&nbsp;申请人&nbsp;</th>
	                	</tr>
	                	<tr>
	                		<th fieldname="BMJLS" colindex=8 tdalign="center">&nbsp;明细数&nbsp;</th>
	                		<th fieldname="KYJLS" colindex=9 tdalign="center">&nbsp;可用明细数&nbsp;</th>
							<th fieldname="BMZE" colindex=10 tdalign="right" CustomFunction="doRandering_bmze">&nbsp;总额(元)&nbsp;</th>
							<th fieldname="CWJLS" colindex=11 tdalign="center" CustomFunction="doRandering_CWJLS">&nbsp;明细数&nbsp;</th>
							<th fieldname="CWZE" colindex=12 tdalign="right" CustomFunction="doRandering_cwze">&nbsp;总额(元)&nbsp;</th>
							<th fieldname="JCJLS" colindex=13 tdalign="center" CustomFunction="doRandering_JCJLS">&nbsp;明细数&nbsp;</th>
							<th fieldname="JCZE" colindex=14 tdalign="right" CustomFunction="doRandering_jcze">&nbsp;总额(元)&nbsp;</th>
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
		<input type="hidden" name="txtFilter" order="desc" fieldname="LRSJ" id="txtFilter"/>
<%--		<input type="hidden" name="txtFilter" order="desc" fieldname="ID" id="txtFilter"/>--%>
		<input type="hidden" name="resultXML" id="resultXML"/>
		<!--传递行数据用的隐藏域-->
		<input type="hidden" name="rowData"/>
		<input type="hidden" name="queryResult" id="queryResult"/>
	</FORM>
</div>
 <form method="post" id="queryFormTqkBmChange">
				<table class="B-table" width="100%">
					<!--可以再此处加入hidden域作为过滤条件 -->
					<TR style="display: none;">
						<TD class="right-border bottom-border">
							<input type="hidden" id="QID" name="ID"  fieldname="ID" >
							<input type="hidden" id="QTQKZT" name="TQKZT"  fieldname="TQKZT" >
						</TD>
					</TR>
					<!--可以再此处加入hidden域作为过滤条件 -->
				</table>
	</form>
</body>
</html>
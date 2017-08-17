<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'Myform.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    This is my JSP page. <br>
    <form name="mf" method="post"  action="http://192.168.0.3:8080/recharge/interface/Yucheck.jsp">
       UserNumber :<input type="text" name="UserNumber" value="100001"><br>
       PhoneNumber:<input type="text" name="PhoneNumber" value="15110191315"><br>
       Province   :<input type="text" name="Province" value="北京"><br>
       City       :<input type="text" name="City" value="北京"><br>
       PhoneClass :<input type="text" name="PhoneClass" value="移动"><br>
       PhoneMoney :<input type="text" name="PhoneMoney" value="100"><br>
       Time       :<input type="text" name="Time" value="2014-06-05"><br>
       RecordKey  :<input type="text" name="RecordKey" value="ASDFCVXSDGFRFCDHG5"><br>
       Remark     :<input type="text" name="PhoneNumber" value="4568"><br>
       
       <input type="submit" value="提交">
    </form>
  </body>
</html>

<%@ page language="java" import="java.sql.*" pageEncoding="utf-8"%>
<%
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
//Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
String url="jdbc:sqlserver://222.73.15.222:1433;DatabaseName=recharge";
String user="sa";
String password="QAZrfv2013";
Connection conn= DriverManager.getConnection(url,user,password);

String sql="select top 1 * from log_in";
PreparedStatement ps = conn.prepareStatement(sql);  
//ps.executeUpdate(); 
ResultSet rs=ps.executeQuery();

while(rs.next()) {%>

您的第一个字段内容为：<%=rs.getString(1)%>
<%}%>

<%out.print("数据库操作成功，恭喜你");%>

<%rs.close();

ps.close();

conn.close();

%>


<%@ page language="java" import="java.util.*,java.io.*,java.sql.*" pageEncoding="utf-8"%>
<%@ include file="/tool/functionjsp.jsp" %>
<jsp:useBean id="con" class="com.hongen.recharge.bean.DSConnGet" scope="page"></jsp:useBean>
<%
/*
充值通知接口：用于告知电商当前的手机号和金额可否充值；
充值商传过来的信息包括：用户编号，内部订单号，商家订单号，充值结果，自定义信息，签名，订单类型；
*/

 String dsid="100";  //电商在我司编号，申请充值方
 String czid="1000"; //充值商在我司的编号，充值方
 
 //相关参数的设定
 PrintWriter res=response.getWriter();
 response.setCharacterEncoding("UTF-8");
 Connection conn=null;
 PreparedStatement ps = null;
 
 //获取上家ip
 String IP=getRemortIP(request);
 out.print("IP is:"+IP+"\n");
 out.print("<br>");
 
 //获取上传参数等
 String  initialContent = getInputData(request,null);
 out.print("info is:"+initialContent+"\n");
 out.print("<br>");
   
 conn = con.getConn();
 loginfo("in",czid+"_cz_noticein",IP+"||"+initialContent,conn);    //记录日志
 
  //ip鉴权
 String IPString = "222.73.15.222,192.168.0.3";  //绑定的IP，以逗号间隔
 int JQ=IPString.indexOf(IP);
 if(JQ < 0){
   res.println("IP error ,ip = "+IP);
   out.close();
   //return;
 } 
 
 //逐一获取参数
 String UserNumber=getParastring(initialContent,"UserNumber");  //接收我司编号
 out.print("UserNumber is:"+UserNumber+"\n");
 out.print("<br>");
 
 String InOrderNumber=getParastring(initialContent,"InOrderNumber");   //接收内部订单号
 out.print("InOrderNumber is:"+InOrderNumber+"\n");
 out.print("<br>");
 
 String OutOrderNumber=getParastring(initialContent,"OutOrderNumber");  //接收商家订单号
 out.print("OutOrderNumber is:"+OutOrderNumber+"\n");
 out.print("<br>");
 
 String PayResult=getParastring(initialContent,"PayResult");  //接收充值结果
 out.print("PayResult is:"+PayResult+"\n");
 out.print("<br>");
 
 String CustomInfo=getParastring(initialContent,"CustomInfo");  //接收自定义信息
 out.print("CustomInfo is:"+CustomInfo+"\n");
 out.print("<br>");
 
 String RecordKey=getParastring(initialContent,"RecordKey");  //接收签名结果
 out.print("RecordKey is:"+RecordKey+"\n");
 out.print("<br>");
 
 String OrderType=getParastring(initialContent,"OrderType");  //接收订单类型
 out.print("OrderType is:"+OrderType+"\n");
 out.print("<br>");
 
 String date_find = getDate("yyyy-MM-dd");           //查找用时间
 String date_time = getDate("yyyy-MM-dd HH:mm:ss");  //传参用时间
 
 //存储参数
 conn = con.getConn();
 String sql_czjdata="insert into 充值结果 (czid,dsid,UserNumber,InOrderNumber,OutOrderNumber,PayResult,CustomInfo,RecordKey,OrderType) values ('"+czid+"','"+dsid+"','"+UserNumber+"','"+InOrderNumber+"','"+OutOrderNumber+"','"+PayResult+"','"+CustomInfo+"','"+RecordKey+"','"+OrderType+"')";
  try{
       ps= conn.prepareStatement(sql_czjdata);
       ps.executeUpdate(); 
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(null,ps,conn);
  }
  
  String info="";
  String PhoneNumber="";
  String Province="";
  String City="";
  String PhoneClass="";
  String PhoneMoney="";
  String RecordKey_ds="";
  String UniqueStr="";
  conn = con.getConn();
  ResultSet rs =null;
  //String sql_czjquery="select *  from 充值订单  where xjid='"+czid+"' and sjid='"+dsid+"' and uniquestr='"+OutOrderNumber+"' and time='"+date_find+"'";
  String sql_czjquery="select *  from 充值订单  where czid='"+czid+"' and dsid='"+dsid+"' and uniquestr='"+OutOrderNumber+"'";
  try{
       ps= conn.prepareStatement(sql_czjquery);
       rs = ps.executeQuery(); 
       if(rs.next()) {
         PhoneNumber=rs.getString("PhoneNumber");
         Province=rs.getString("Province");
         City=rs.getString("City");
         PhoneClass=rs.getString("PhoneClass");
         PhoneMoney=rs.getString("PhoneMoney");
         RecordKey_ds=rs.getString("RecordKey");
         UniqueStr=rs.getString("UniqueStr");
         info="1";
       }else{
         info="0";
       }
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(rs,ps,conn);
  }
  
  String str_fail="<?xml version=\"1.0\" encoding=\" GB2312\"?>";
        str_fail+="<root>";
        str_fail+="<result>fail</result>";
        str_fail+="</root>";
        
 String str_succ="<?xml version=\"1.0\" encoding=\" GB2312\"?>";
        str_succ+="<root>";
        str_succ+="<result>success</result>";
        str_succ+="</root>";
  
 str_fail = URLEncoder.encode(str_fail,"UTF-8");
 str_succ = URLEncoder.encode(str_succ,"UTF-8");
 if(initialContent.length()==0 || initialContent.equals("")|| info=="0"){
   res.println(str_fail);
   //out.close();
 }else{
   res.println(str_succ);
 }
 
  //--开始组装充值商传递的参数
  //给参数编码
  String recvEncoding = "UTF-8";
  PhoneNumber = URLEncoder.encode(PhoneNumber,recvEncoding);                          
  Province = URLEncoder.encode(Province,recvEncoding);                          
  City = URLEncoder.encode(City,recvEncoding);                          
  PhoneClass = URLEncoder.encode(PhoneClass,recvEncoding);                          
  PhoneMoney = URLEncoder.encode(PhoneMoney,recvEncoding);                          
  RecordKey_ds = URLEncoder.encode(RecordKey_ds,recvEncoding);                          
  UniqueStr = URLEncoder.encode(UniqueStr,recvEncoding);                          
  PayResult = URLEncoder.encode(PayResult,recvEncoding);                          
  String reqstr="PhoneNumber="+PhoneNumber+"&Province="+Province+"&City="+City+"&PhoneClass="+PhoneClass+"&PhoneMoney="+PhoneMoney+"&RecordKey="+RecordKey_ds+"&UniqueStr="+UniqueStr+"&PayResult="+PayResult;
  
  //查询上家预查询地址
  String dsUrl="";
  conn = con.getConn();
  String sql_dsurl="select 充值结果地址  from 电商列表  where id="+dsid;
  try{
       ps= conn.prepareStatement(sql_dsurl);
       rs = ps.executeQuery(); 
       while (rs.next()) {
         dsUrl = rs.getString("充值结果地址");
       }
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(rs,ps,conn);
  }
  
  URL DSurl = new URL(dsUrl);
  String cpresp = yuCheckInfo(DSurl,reqstr);
  
  conn = con.getConn();
  loginfo("out",dsid+"_cz_noticeout",dsUrl+"?"+reqstr+"||"+cpresp,conn);    //记录日志
%>



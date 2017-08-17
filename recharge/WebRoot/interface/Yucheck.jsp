<%@ page language="java" import="java.util.*,java.io.*,java.sql.*" pageEncoding="utf-8"%>
<%@ include file="/tool/functionjsp.jsp" %>
<jsp:useBean id="con" class="com.hongen.recharge.bean.DSConnGet" scope="page"></jsp:useBean>
<%
/*
预查询接口：用于告知电商当前的手机号和金额可否充值；
电商需要传过来的信息包括：手机号，省份，城市，运营商，金额，信息验证码，信息状态值；
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
 
 //获取上传参数，手机号，省份，城市，金额，状态值等
 String  initialContent = getInputData(request,null);
 out.print("info is:"+initialContent+"\n");
 out.print("<br>");
 
 conn = con.getConn();
 loginfo("in",dsid+"_ds_yuin",IP+"||"+initialContent,conn);    //记录预查询接收日志
 
  //ip鉴权
 String IPString = "222.73.15.222,192.168.0.3";  //绑定的IP，以逗号间隔
 int JQ=IPString.indexOf(IP);
 if(JQ < 0){
   res.println("IP error ,ip = "+IP);
   out.close();
   //return;
 } 
 
 //逐一获取参数
 String PhoneNumber=getParastring(initialContent,"PhoneNumber");  //接收手机号
 out.print("PhoneNumber is:"+PhoneNumber+"\n");
 out.print("<br>");
 
 String Province=getParastring(initialContent,"Province");   //接收归属省份
 out.print("Province is:"+Province+"\n");
 out.print("<br>");
 if (Province.equals("")||Province.equals("null")){
    Province="Auto";
 }
 
 String City=getParastring(initialContent,"City");  //接收归属市份
 out.print("City is:"+City+"\n");
 out.print("<br>");
 if (City.equals("")||City.equals("null")){
    City="Auto";
 }
 
 String PhoneClass=getParastring(initialContent,"PhoneClass");  //接收运营商信息
 out.print("PhoneClass is:"+PhoneClass+"\n");
 out.print("<br>");
  if (PhoneClass.equals("")||PhoneClass.equals("null")){
    PhoneClass="Auto";
 }
 
 String PhoneMoney=getParastring(initialContent,"PhoneMoney");  //接收充值金额
 out.print("PhoneMoney is:"+PhoneMoney+"\n");
 out.print("<br>");
 
 String RecordKey=getParastring(initialContent,"RecordKey");  //接收MD5加密信息
 out.print("RecordKey is:"+RecordKey+"\n");
 out.print("<br>");
 
 String UniqueStr=getParastring(initialContent,"UniqueStr");  //接收唯一值
 out.print("UniqueStr is:"+UniqueStr+"\n");
 out.print("<br>");
 
 String Status=getParastring(initialContent,"Status");  //接收状态值
 out.print("Status is:"+Status+"\n");
 out.print("<br>");
 if(Status.equalsIgnoreCase("error")){
   res.println("Status error ,Status = "+Status);
   out.close();
   //return;
 } 
 
 String DifferStr=getParastring(initialContent,"DifferStr");  //接收区分值
 out.print("DifferStr is:"+DifferStr+"\n");
 out.print("<br>");
 
 //存储参数
 conn = con.getConn();
 String sql_sjdata="insert into 预查询订单 (czid,dsid,PhoneNumber,Province,City,PhoneClass,RecordKey,uniquestr,status) values ('"+czid+"','"+dsid+"','"+PhoneNumber+"','"+Province+"','"+City+"','"+PhoneClass+"','"+RecordKey+"','"+UniqueStr+"','"+Status+"')";
  try{
       ps= conn.prepareStatement(sql_sjdata);
       ps.executeUpdate(); 
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(null,ps,conn);
  }
 
 String date_find = getDate("yyyy-MM-dd");           //查找用时间
 String date_time = getDate("yyyy-MM-dd HH:mm:ss");  //传参用时间
 
  //--开始组装充值商传递的参数
  //查询充值商预查询地址等相关信息
  String czNum_yuquery="";
  String czSgin_yuquery="";
  String czUrl_yuquery="";
  conn = con.getConn();
  ResultSet rs =null;
  String sql_yuquery="select 宏恩编号,验证密匙,预查询地址  from 充值商列表  where id="+czid;
  try{
       ps= conn.prepareStatement(sql_yuquery);
       rs = ps.executeQuery(); 
       while (rs.next()) {
         czNum_yuquery = rs.getString("宏恩编号");
         czSgin_yuquery = rs.getString("验证密匙");
         czUrl_yuquery = rs.getString("预查询地址");
       }
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(rs,ps,conn);
  }
  
  //获取签名
  StringBuffer sbKey = new StringBuffer();                             
  String UserNumber = czNum_yuquery;            //换为我们自己的编号
  String Sign = czSgin_yuquery;                 //数字签名，从上家获取，我方独有
  String Time = date_time;
  sbKey.append(UserNumber); 
  sbKey.append(PhoneNumber); 
  sbKey.append(Province); 
  sbKey.append(City); 
  sbKey.append(PhoneClass); 
  sbKey.append(PhoneMoney); 
  sbKey.append(Time); 
  sbKey.append(Sign); 
  String  RecordKey_xj = getMD5Str(sbKey.toString(),"GB2312");
  
  //给参数编码
  String recvEncoding = "UTF-8";
  UserNumber = URLEncoder.encode(UserNumber,recvEncoding);                          
  PhoneNumber = URLEncoder.encode(PhoneNumber,recvEncoding);                          
  Province = URLEncoder.encode(Province,recvEncoding);                          
  City = URLEncoder.encode(City,recvEncoding);                          
  PhoneClass = URLEncoder.encode(PhoneClass,recvEncoding);                          
  PhoneMoney = URLEncoder.encode(PhoneMoney,recvEncoding);                          
  RecordKey_xj = URLEncoder.encode(RecordKey_xj,recvEncoding);                          
  UniqueStr = URLEncoder.encode(UniqueStr,recvEncoding);                          
  String reqstr="UserNumber="+UserNumber+"&PhoneNumber="+PhoneNumber+"&Province="+Province+"&City="+City+"&PhoneClass="+PhoneClass+"&PhoneMoney="+PhoneMoney+"&Time="+Time+"&RecordKey="+RecordKey_xj+"&Remark"+UniqueStr;
  
  //给充值商传参并接受反馈信息
  URL czUrl = new URL(czUrl_yuquery);
  String gateresp = yuCheckInfo(czUrl,reqstr);
  
  //获取反馈信息各字段信息
  String resp_result = getXML(gateresp,"result","</result");
  String resp_info = getXML(gateresp,"info","</info");
  String resp_price = getXML(gateresp,"price","</price");
  String resp_time = getXML(gateresp,"time","</time");
  String respstr=resp_result+"+"+resp_info+"+"+resp_price+"+"+resp_time;
  
  //保存充值商反馈信息
 conn = con.getConn();
 String sql_xjdata="insert into 预查询订单 (respstr) values ('"+respstr+"')where time ='"+date_find+"' and xjid='"+czid+"' and sjid='"+dsid+"' and uniquestr='"+UniqueStr+"'" ;
  try{
     ps= conn.prepareStatement(sql_xjdata);
     ps.executeUpdate(); 
  }catch(Exception e){
     e.printStackTrace();
  }finally{
     closeData(null,ps,conn);
  }
  
  //查询电商预查询地址
  String dsUrl="";
  conn = con.getConn();
  
  String sql_dsurl="select 预查询地址  from 电商列表  where id="+dsid;
  try{
       ps= conn.prepareStatement(sql_dsurl);
       rs = ps.executeQuery(); 
       while (rs.next()) {
         dsUrl = rs.getString("预查询地址");
       }
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(rs,ps,conn);
  }
  
  String str_dsxf="<?xml version=\"1.0\" encoding=\" GB2312\"?>";   //电商下发信息
         str_dsxf +="<hongenpay>";
         str_dsxf +="<result>"+resp_result+"</result>";
         str_dsxf +="<info>"+resp_info+"</info>";
         str_dsxf +="<recordKey>"+RecordKey+"</recordKey>";
         str_dsxf +="<time>"+resp_time+"</time>";
         str_dsxf +="</hongenpay>";
  
  URL DSurl = new URL(dsUrl);
  String cpresp = yuCheckInfo(DSurl,str_dsxf);  //给下家下发信息并接受反馈信息
  res.print(cpresp);
  
  conn = con.getConn();
  loginfo("out",dsid+"_ds_yuout",dsUrl+"?"+respstr+"||"+cpresp,conn);    //记录下发日志
%>



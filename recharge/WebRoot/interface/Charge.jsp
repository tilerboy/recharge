<%@ page language="java" import="java.util.*,java.io.*,java.sql.*" pageEncoding="utf-8"%>
<%@ include file="/tool/functionjsp.jsp" %>
<jsp:useBean id="con" class="com.hongen.recharge.bean.DSConnGet" scope="page"></jsp:useBean>
<%
/*
充值接口：电商发送充值信息充值；
电商需要传过来的信息包括：手机号，省份，城市，运营商，金额，信息验证码，信息状态值；
*/

 String dsid="100";  //电商在我司编号，申请充值方
 String czid="1000"; //充值商在我司的编号，充值方
 
 //相关参数的设定
 PrintWriter res=response.getWriter();
 response.setCharacterEncoding("UTF-8");
 Connection conn=null;
 PreparedStatement ps = null;
 
 //获取电商ip
 String IP=getRemortIP(request);
 out.print("IP is:"+IP+"\n");
 out.print("<br>");
 
 //获取电商参数，手机号，省份，城市，金额，状态值等
 String  initialContent = getInputData(request,null);
 out.print("info is:"+initialContent+"\n");
 out.print("<br>");
 conn = con.getConn();
 loginfo("in",dsid+"_ds_chargein",IP+"||"+initialContent,conn);    //记录日志
 
  //ip鉴权
 String IPString = "222.73.15.222,192.168.0.3";  //绑定的IP，以逗号间隔
 int JQ=IPString.indexOf(IP);
 if(JQ < 0){
   res.println("IP error ,ip = "+IP);
   out.close();
   //return;
 } 
 
 //逐一获取参数，并存储参数
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
 
 conn = con.getConn();
 String sql_dsdata="insert into 充值订单 (czid,dsid,PhoneNumber,Province,City,PhoneClass,RecordKey,uniquestr,status) values ('"+czid+"','"+dsid+"','"+PhoneNumber+"','"+Province+"','"+City+"','"+PhoneClass+"','"+RecordKey+"','"+UniqueStr+"','"+Status+"')";
  try{
       ps= conn.prepareStatement(sql_dsdata);
       ps.executeUpdate(); 
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(null,ps,conn);
  }
 
 String date_find = getDate("yyyy-MM-dd");           //查找用时间
 String date_time = getDate("yyyy-MM-dd HH:mm:ss");  //传参用时间
 String date_order = getDate("yyyyMMddHHmmss");  //InOrderNumber参数用
 
  //--开始组装充值商传递的参数
  //查询下家预查询地址等相关信息
  String czNum_czquery="";
  String czSgin_czquery="";
  String czUrl_czquery="";
  conn = con.getConn();
  ResultSet rs =null;
  String sql_yuquery="select 宏恩编号,验证密匙,充值地址  from 充值商列表  where id="+czid;
  try{
       ps= conn.prepareStatement(sql_yuquery);
       rs = ps.executeQuery(); 
       while (rs.next()) {
         czNum_czquery = rs.getString("宏恩编号");
         czSgin_czquery = rs.getString("验证密匙");
         czUrl_czquery = rs.getString("充值地址");
       }
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(rs,ps,conn);
  }
  
  //获取签名
  StringBuffer sbKey = new StringBuffer();                             
  String UserNumber=czNum_czquery;      //换为我们自己的编号
  String ran = "";
        for (int i=0; i<4; i++)
        {
        	ran +=getRandom(0, 9);
		}
  String InOrderNumber= "IP"+ UserNumber + date_order + ran;  
  String OutOrderNumber= UniqueStr;
  String SellPrice="None";
  String TimeOut = "120";                       //两分钟，上家150秒
  String StartTime = date_time;
  String Sign = czSgin_czquery;                 //数字签名，从上家获取，我方独有
  sbKey.append(UserNumber); 
  sbKey.append(InOrderNumber); 
  sbKey.append(OutOrderNumber); 
  sbKey.append(PhoneNumber); 
  sbKey.append(Province); 
  sbKey.append(City); 
  sbKey.append(PhoneClass); 
  sbKey.append(PhoneMoney); 
  sbKey.append(SellPrice); 
  sbKey.append(StartTime); 
  sbKey.append(TimeOut); 
  sbKey.append(Sign); 
  String  RecordKey_xj = getMD5Str(sbKey.toString(),"GB2312");
  
  //给参数编码
  String recvEncoding = "UTF-8";
  UserNumber = URLEncoder.encode(UserNumber,recvEncoding);                          
  InOrderNumber = URLEncoder.encode(InOrderNumber,recvEncoding);                          
  OutOrderNumber = URLEncoder.encode(OutOrderNumber,recvEncoding);                          
  PhoneNumber = URLEncoder.encode(PhoneNumber,recvEncoding);                          
  Province = URLEncoder.encode(Province,recvEncoding);                          
  City = URLEncoder.encode(City,recvEncoding);                          
  PhoneClass = URLEncoder.encode(PhoneClass,recvEncoding);                          
  PhoneMoney = URLEncoder.encode(PhoneMoney,recvEncoding);                          
  SellPrice = URLEncoder.encode(SellPrice,recvEncoding);                          
  StartTime = URLEncoder.encode(date_time,recvEncoding);                          
  TimeOut = URLEncoder.encode(TimeOut,recvEncoding);                          
  RecordKey_xj = URLEncoder.encode(RecordKey_xj,recvEncoding);                          
  UniqueStr = URLEncoder.encode(UniqueStr,recvEncoding);                         
  String reqstr="UserNumber="+UserNumber+"&InOrderNumber="+InOrderNumber+"&OutOrderNumber="+OutOrderNumber+"&PhoneNumber="+PhoneNumber+"&Province="+Province+"&City="+City+"&PhoneClass="+PhoneClass+"&PhoneMoney="+PhoneMoney+"&SellPrice="+SellPrice+"&StartTime="+StartTime+"&TimeOut="+TimeOut+"&RecordKey="+RecordKey_xj+"&Remark"+UniqueStr;
  
  //给充值商传参并接受反馈信息
  URL url_charge = new URL(czUrl_czquery);
  String gateresp = yuCheckInfo(url_charge,reqstr);
  
  String resp_result = getXML(gateresp,"result","</result");
  String resp_inOrderNumber = getXML(gateresp,"inOrderNumber","</inOrderNumber");
  String resp_outOrderNumber = getXML(gateresp,"outOrderNumber","</outOrderNumber");
  String resp_remark = getXML(gateresp,"remark","</remark");
  String resp_recordKey = getXML(gateresp,"recordKey","</recordKey");
  String respstr=resp_result+"+"+resp_inOrderNumber+"+"+resp_outOrderNumber+"+"+resp_remark+"+"+resp_recordKey;
  
  //保存充值参数
 conn = con.getConn();
 String sql_xjdata="insert into 充值订单 (respstr) values ('"+respstr+"')where time ='"+date_find+"' and xjid='"+czid+"' and sjid='"+dsid+"' and uniquestr='"+resp_remark+"'" ;
  try{
       ps= conn.prepareStatement(sql_xjdata);
       ps.executeUpdate(); 
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(null,ps,conn);
  }
  
  //查询电商充值地址
  String dsUrl="";
  conn = con.getConn();
  String sql_dsurl="select 充值地址  from 电商列表  where id="+dsid;
  try{
       ps= conn.prepareStatement(sql_dsurl);
       rs = ps.executeQuery(); 
       while (rs.next()) {
         dsUrl = rs.getString("充值地址");
       }
  }catch(Exception e){
    e.printStackTrace();
  }finally{
    closeData(rs,ps,conn);
  }
  
  String str_dsxf="<?xml version=\"1.0\" encoding=\" GB2312\"?>";   //电商下发信息
         str_dsxf +="<hongenpay>";
         str_dsxf +="<result>"+resp_result+"</result>";
         str_dsxf +="<remark>"+UniqueStr+"</remark>";
         str_dsxf +="<recordKey>"+RecordKey+"</recordKey>";
         str_dsxf +="</hongenpay>";
  
  URL cz_dsurl = new URL(dsUrl);
  String cpresp = yuCheckInfo(cz_dsurl,str_dsxf);
  
  conn = con.getConn();
  loginfo("out",dsid+"_ds_chargeout",dsUrl+"?"+respstr+"||"+cpresp,conn);    //记录下发日志
%>



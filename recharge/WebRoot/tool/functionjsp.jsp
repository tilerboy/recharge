<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,java.net.*,java.io.*,java.security.*" pageEncoding="utf-8"%>
<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<jsp:useBean id="cg" class="com.hongen.recharge.bean.ConnGet" scope="page"></jsp:useBean>


<%!
  //获取指定格式时间
  String getDate(String format){
    java.util.Date currentTime = new java.util.Date();
	SimpleDateFormat formatter = new SimpleDateFormat(format);
	String dateString = formatter.format(currentTime);
	return dateString;
  }
%>

<%!
  //获取上家ip
  String getRemortIP(HttpServletRequest request){
    if(request.getHeader("x-forwarded-for") == null){
        return request.getRemoteAddr();
    }
        return  request.getHeader("x-forwarded-for");
  }
 %>
 <%!
  //日志记录
  void loginfo(String sign,String filename , String content,Connection conn){
    PreparedStatement ps = null;
    String sqlinfo=null;
    if(sign == "in"){
     sqlinfo="insert into log_in (filename,content) values ('"+filename+"','"+content+"')";
     // sqlinfo="insert into log_in (filename,content) values (?,?)";
    }else{
     sqlinfo="insert into log_out (filename,content) values ("+filename+","+content+")";
     //sqlinfo="insert into log_out (filename,content) values (?,?)";
    }
    try{
       ps= conn.prepareStatement(sqlinfo);
       ps.executeUpdate(); 
    }catch(Exception e){
    e.printStackTrace();
    }finally{
      try{
          ps.close();
          conn.close();
      }catch(Exception e){
          e.printStackTrace();
      }
    }
  }
  %>
  
  <%!
  //从传输的字符串中获取参数的方法
  String getParastring(String parameterString,String parameter){
     int paralength=parameter.length();
     int paraindex=parameterString.indexOf(parameter);
     if(paraindex >= 0){
     int signindex=parameterString.indexOf("&",paraindex);
     String para = parameterString.substring(paraindex+paralength+1,signindex);
     return para;
     }else{
        return null;
     }
  }
  %>
  
  <%!
  //关闭数据库资源
  void closeData(ResultSet rs,PreparedStatement ps,Connection conn){
   try{
      if(rs != null || rs.equals("")){
         rs.close();
      }
      if(ps != null || ps.equals("")){
         ps.close();
      }
      if(conn != null || conn.equals("")){
         conn.close();
      }
   }catch(Exception e){
      e.printStackTrace();
    }
   }
  %>
  
  <%!
  //预查询查询下家充值状况
   String yuCheckInfo(URL url,String transtring){
	     String respstr =null ;
	     HttpURLConnection url_con =null;
	     try {
			url_con = (HttpURLConnection)url.openConnection();
			url_con.setRequestMethod("POST");
            url_con.setConnectTimeout(5000);
            url_con.setReadTimeout(10000);
            url_con.setDoOutput(true);
            byte[] b = transtring.getBytes();
            url_con.getOutputStream().write(b, 0, b.length);//提交信息
            url_con.getOutputStream().flush();
            url_con.getOutputStream().close();
            
            respstr = getInputData(null,url_con);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
            if (url_con != null){
                url_con.disconnect();
               }
         }
	     return respstr;
	  }
   %>
   
   <%!
   //获取唯一值
   String getOnlyData(){
      String timestr = getDate("yyyyMMddhhmmsss");
      String uuidstr = UUID.randomUUID().toString().substring(0,6);
      String  onlystr=timestr+uuidstr;
     return onlystr;
   }
    %>
    
    <%!
    //获取MD5
    String getMD5Str(String plainText, String format) {
		String retStr = "";
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(plainText.getBytes(format));
			
			byte b[] = md.digest();

			int i;
			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
       	   i = b[offset];
       	   if (i < 0)
       		   i += 256;
       	   if (i < 16)
       		   buf.append("0");
       	   buf.append(Integer.toHexString(i));
			}
			retStr = buf.toString().substring(0, 16).toUpperCase();// 16位的加密
		} catch (Exception e) {
		   e.printStackTrace();
		} 
		return retStr;
    }
     %>
   
   <%!
   //获取xml中指定的参数
   String getXML(String str,String start,String end){
        int index1 = str.indexOf(start);
        int index2 = str.indexOf(end, index1);
        String strReturn="";
        if(index2>index1){
            strReturn = str.substring(index1+start.length()+1, index2);
        }
        return strReturn;
    }
    %>
    
    <%!
    //接收数据 ，并解码
    String getInputData(HttpServletRequest request,HttpURLConnection urlcon){
      String  initialContent =null;
      InputStream in=null;
      BufferedReader br = null;
      try{
        if (request != null){
          in=request.getInputStream();
        }else{
          in = urlcon.getInputStream();
        }
      br = new BufferedReader(new InputStreamReader(in,"UTF-8"));
      String tempLine=null ;
      StringBuffer tempStr = new StringBuffer();
      String crlf = System.getProperty("line.separator");
      while ((tempLine= br.readLine()) != null){
           tempStr.append(tempLine);
           tempStr.append(crlf);
           tempLine = br.readLine();
      }
         initialContent = tempStr.toString();
         initialContent=java.net.URLDecoder.decode(initialContent,"UTF-8");  //解码
         br.close();
         in.close();
      } catch (Exception e) {
		   e.printStackTrace();
	  } finally{
            if (urlcon != null){
                urlcon.disconnect();
               }
      }
      return initialContent;
    }
     %>
     
     <%!
     //获取随机数
       String getRandom(int min, int max){
   	     Random random = new Random();
   	     int ran = Math.abs(random.nextInt());
   	     int returnRan = ran%(max-min+1)+min;
   	     return String.valueOf(returnRan);
       }
     %>
  

 
 
 
 
 
 
 
 


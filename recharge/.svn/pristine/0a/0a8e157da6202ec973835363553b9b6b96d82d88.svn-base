package com.hongen.recharge.bean;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnGet {
	
	public Connection getConn(){
//		public void getConn(String sign,String filename , String content){
		Connection conn=null;
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
			String url="jdbc:sqlserver://222.73.15.222:1433;DatabaseName=recharge";
			String user="sa";
			String password="QAZrfv2013";
			conn = DriverManager.getConnection(url,user,password);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
}

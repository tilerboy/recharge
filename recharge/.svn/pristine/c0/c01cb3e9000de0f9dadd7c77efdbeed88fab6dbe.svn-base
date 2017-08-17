package com.hongen.recharge.bean;

import java.sql.*;

public class jdbc {
	
	public static void main(String[] args) {
		//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
		//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		try {
			
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		String url="jdbc:sqlserver://222.73.26.214:1433;DatabaseName=smsunion";
		String user="sms";
		String password="QAZrfv2013Lh";
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url,user,password);
			String sql="select top 1 * from log";
			PreparedStatement ps = conn.prepareStatement(sql);  
			ResultSet rs=ps.executeQuery();
			
			while(rs.next()) {
				System.out.println(rs.getString(1));	
			}
			rs.close();
			ps.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}


package com.hongen.recharge.bean;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;

public class DSConnGet {
	private static DataSource DS = null;
	private String url="jdbc:sqlserver://222.73.15.222:1433;DatabaseName=recharge";
	private String user="sa";
	private String password="QAZrfv2013"; 
	private String driverClass="com.microsoft.sqlserver.jdbc.SQLServerDriver";
	
	public Connection getConn(){
		Connection con = null;
		if(DS == null){
			initDS(url, user, password, driverClass, 2, 250, 2, 50000);
		}
		if(DS != null){
			try {
				con = DS.getConnection();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return con;
	}
	
	/**
	 *  指定所有参数连接数据源
	 * @param connURL
	 *    连接至驱动的URL
	 * @param username
	 *    用户名
	 * @param pswd
	 *    密码
	 * @param driverClass
	 *    jdbc驱动全名
	 */
	
	public static void initDS(String connURL,String username,String pswd,String driverClass,
			int initialSize,int maxActive,int maxIdle,int maxWait){
		BasicDataSource bds = new BasicDataSource();
		//连接设置
		bds.setDriverClassName(driverClass);   
		bds.setUsername(username);   
		bds.setPassword(pswd);   
		bds.setUrl(connURL);    
		//连接池设置
		bds.setInitialSize(initialSize);  //初始连接数
		bds.setMaxActive(maxActive);  //连接池在同一时刻内所提供的最大活动连接数。
		bds.setMaxIdle(maxIdle);  //最大闲置连接数
		bds.setMaxWait(maxWait);  //当发生异常时数据库等待的最大毫秒数 (当没有可用的连接时)
		bds.setDefaultAutoCommit(false);  //连接池创建的连接的默认的auto-commit状态
		//空闲连接设置
		bds.setTestOnBorrow(true); //指明是否在从池中取出连接前进行检验,如果检验失败,则从池中去除连接并尝试取出另一个.
		                           //  注意: 设置为true后如果要生效,validationQuery参数必须设置为非空字符串
		bds.setValidationQuery("select 1");
		bds.setTimeBetweenEvictionRunsMillis(20000);   //在空闲连接回收器线程运行期间休眠的时间值,以毫秒为单位. 如果设置为非正数,则不运行空闲连接回收器线程 
		bds.setNumTestsPerEvictionRun(10);  //每次空闲连接回收器线程(如果有)运行时检查的连接数量
		bds.setRemoveAbandoned(true);       //标记是否删除泄露的连接,如果他们超过了 removeAbandonedTimout的限制
		bds.setRemoveAbandonedTimeout(30);  //泄露的连接可以被删除的超时值, 单位秒
		bds.setLogAbandoned(false);    //标记当Statement或连接被泄露时是否打印程序的stack traces日志
		DS = bds;
	}
	
	/** 关闭数据源 */
	public static void shutdownDataSource() throws SQLException {
		BasicDataSource bds1 = (BasicDataSource) DS;
		bds1.close();
	}

}

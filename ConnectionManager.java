package com.org.wepark;

import java.sql.*;

public class ConnectionManager {
	
	public Connection connectDB() {
		
		String url="jdbc:oracle:thin:@ICOSAHEDRON:1521/XE";
		String userName="SYSTEM";
		String passcode="1234";
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection con=DriverManager.getConnection(url,userName,passcode);
			return con;
		}catch (Exception e) {
			// TODO: handle exception
			return null;
		}
		
	}

}

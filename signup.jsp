<%@page import="com.org.wepark.ConnectionManager"%>
<%@page import="com.sun.org.apache.bcel.internal.generic.GOTO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	
	/////Get session attributes
	Object session_name=session.getAttribute("name");
	Object session_password=session.getAttribute("password");
	Object session_email=session.getAttribute("email");
	
	//Convert to String
	String name= session_name.toString();
	String password= session_password.toString();
	String email= session_email.toString();	
	
	/////////////////ID Generation
        Random ran=new Random();
		int n=ran.nextInt((999999-100000)+1)+100000;
		String uid="WEPRKUSR"+Integer.toString(n);
        
        
	///////Login credentials for Oracle
	
	ConnectionManager connectionManager=new ConnectionManager();
	Connection con=connectionManager.connectDB();
			
	String mail=null;
	int result=0;
	
	
	
	//////////////////INSERT TO TABLE
	
			try
				{
					PreparedStatement pstmt=con.prepareStatement("INSERT INTO WEPARKUSERS (USERID,NAME, EMAIL, PASSWORD, TYPE) VALUES(?,?,?,?,?)");
					
					pstmt.setString(1, uid);
					pstmt.setString(2, name);
					pstmt.setString(3, email);
					pstmt.setString(4, password);
					pstmt.setString(5, "customer");
					
					
					int success= pstmt.executeUpdate();
					
					if (success!=0)
					{
						//out.print("Signup Successfull!");
						out.println("<script type=\"text/javascript\">");
						out.println("alert('User Successfully Registered! Login with registered credentials');");
						out.println("location='http://localhost:8088/WePark/signUpLogin.html';");
						out.println("</script>");
						
					}
					else
					{
						out.println("<script type=\"text/javascript\">");
						out.println("alert('Error Registering User! Try again later!');");
						out.println("location='http://localhost:8088/WePark/signUpLogin.html';");
						out.println("</script>");
					}
					
				}
				catch(Exception e)
				{
					out.print(e);
				}



%>
</body>
</html>
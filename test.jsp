<%@page import="com.org.wepark.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import = "java.io.*,java.util.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%

ConnectionManager connectionManager=new ConnectionManager();
Connection con=connectionManager.connectDB();

PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKUSERS");
ResultSet rs=ps.executeQuery();

while(rs.next())
{
	out.println(rs.getString("NAME"));
}		


%>
</body>
</html>
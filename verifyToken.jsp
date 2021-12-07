<%@page import="com.org.wepark.ConnectionManager"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>WePark Password Reset</title>
</head>
<body>
<%

ConnectionManager connectionManager=new ConnectionManager();
Connection con=connectionManager.connectDB();

String token=request.getParameter("token");
String mail="null";

Date date=new Date();
long time = date.getTime();

Timestamp currentTs=new Timestamp(time);
Timestamp ts=new Timestamp(time);

PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARK_PWDRESET WHERE SECRETKEY = ?");
ps.setString(1, token);

ResultSet rs=ps.executeQuery();

while(rs.next())
{
	mail=rs.getString("email");
	ts=rs.getTimestamp("STATUS");
}

if(currentTs.after(ts)){
	out.println("<script type=\"text/javascript\">");
	out.println("alert('The security token has expired!');");
	out.println("window.location.replace('http://localhost:8088/WePark/signUpLogin.html');");
	out.println("</script>");
	
}else{
	session.setAttribute("resetMail", mail);
	
	out.println("<script type=\"text/javascript\">");
	out.println("window.location.replace('http://localhost:8088/WePark/resetPassword.jsp');");
	out.println("</script>");
}


%>
</body>
</html>
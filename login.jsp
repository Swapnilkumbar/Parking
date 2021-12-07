<%@page import="com.org.wepark.ConnectionManager"%>
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
	String email=request.getParameter("Semail");
	String password=request.getParameter("Spassword");
	String usertype="",parkingSlotID="";

	ConnectionManager connectionManager=new ConnectionManager();
	Connection con=connectionManager.connectDB();

try
	{
		PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKUSERS WHERE email = ? AND password = ?");
		ps.setString(1, email);
		ps.setString(2, password);
		
		ResultSet rs=ps.executeQuery();
		while(rs.next())
		{
			usertype=rs.getString("TYPE");
			parkingSlotID=rs.getString("PARKINGSLOTID");
		}
		
		
		if(usertype.equals("customer"))		
		{
			out.println("<script type=\"text/javascript\">");
			out.println("location='http://localhost:8088/WePark/userhome.jsp';");
			out.println("</script>");
			session.setAttribute("email", email);
		}
		else if(usertype.equals("admin"))
		{
			out.println("<script type=\"text/javascript\">");
			out.println("location='http://localhost:8088/WePark/admin/admininsert.jsp';");
			out.println("</script>");
			session.setAttribute("email", email);
		}
		else if(usertype.equals("employee"))
		{
			out.println("<script type=\"text/javascript\">");
			out.println("location='http://localhost:8088/WePark/employee/empbookingtable.jsp';");
			out.println("</script>");
			session.setAttribute("email", email);
			session.setAttribute("empParkID", parkingSlotID);
			
		}
		else
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Invalid login credentials. Check your email/password.');");
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
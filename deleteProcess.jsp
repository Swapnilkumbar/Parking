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
String id="",tblName="",action="";

	id = request.getParameter("id");
	tblName = request.getParameter("tablename");
	action=request.getParameter("action");

String cmd="";

ConnectionManager connectionManager=new ConnectionManager();
Connection con=connectionManager.connectDB();

if(action.equals("DELETE"))
{
	if(tblName.equals("WEPARKUSERS"))
	{
		cmd="DELETE FROM WEPARKUSERS WHERE USERID= ? ";
		try
		{
			PreparedStatement ps=con.prepareStatement(cmd);
			ps.setString(1,id);
			
			
			int rs=ps.executeUpdate();
			
			if(rs!=0)
			{
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Operation Successfull!')");
				out.println("</script>");
				response.sendRedirect("http://localhost:8088/WePark/admin/bookingtable.jsp");
			}
			else
			{
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Error Deleting User!')");  
				out.println("history.go(-1);");          			
				out.println("</script>");
			}
		}
		catch(Exception e){
			
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error Deleting from Database!')");  
			out.println("history.go(-1);");          			
			out.println("</script>");
			System.out.println(e);
		}	
		
	}
	else if(tblName.equals("WEPARKBOOKING"))
	{
		cmd="DELETE FROM WEPARKBOOKING WHERE BOOKINGID= ? ";
		try
		{
			PreparedStatement ps=con.prepareStatement(cmd);
			ps.setString(1,id);
			
			
			int rs=ps.executeUpdate();
			
			if(rs!=0)
			{
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Operation Successfull!')");
				out.println("history.go(-1);");
				out.println("</script>");
			}
			else
			{
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Error Deleting Booking!')");  
				out.println("history.go(-1);");          			
				out.println("</script>");
			}
		}
		catch(Exception e){
			
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error Deleting from Database!')");  
			out.println("history.go(-1);");          			
			out.println("</script>");
			System.out.println(e);
		}	
	}
	else if(tblName.equals("WEPARKPARKINGSLOTS"))
	{
		cmd="DELETE FROM WEPARKPARKINGSLOTS WHERE PARKINGSLOTID= ? ";
		try
		{
			PreparedStatement ps=con.prepareStatement(cmd);
			ps.setString(1,id);
			
			
			int rs=ps.executeUpdate();
			
			if(rs!=0)
			{
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Operation Successfull!')");
				out.println("history.go(-1);");
				out.println("</script>");
			}
			else
			{
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Error Deleting Booking!')");  
				out.println("history.go(-1);");          			
				out.println("</script>");
			}
		}
		catch(Exception e){
			
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error Deleting from Database!')");  
			out.println("history.go(-1);");          			
			out.println("</script>");
			System.out.println(e);
		}	
	}
}


%>

</body>
</html>
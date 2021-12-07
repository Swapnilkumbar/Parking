<%@page import="com.org.wepark.ConnectionManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@page import="java.sql.*"%>
<%

ConnectionManager connectionManager=new ConnectionManager();
Connection con=connectionManager.connectDB();

String tbl=(String)session.getAttribute("TableNameUpdate");

if(tbl.equals("WEPARKUSERS"))
{
	String uid=request.getParameter("userid");
	String name=request.getParameter("name");
	String email=request.getParameter("email");
	String password=request.getParameter("password");
	String type=request.getParameter("type");
	
	try
	{
		PreparedStatement ps=con.prepareStatement("UPDATE WEPARKUSERS SET NAME=?, EMAIL=?, PASSWORD=?, TYPE=? WHERE USERID=?");
		ps.setString(1,name);
		ps.setString(2,email);
		ps.setString(3,password);
		ps.setString(4,type);
		ps.setString(5,uid);
		
		
		int rs=ps.executeUpdate();
		
		if(rs!=0)
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Operation Successfull!')");
			out.println("location='http://localhost:8088/WePark/admin/usertable.jsp';");
			out.println("</script>");
		}
		else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error Updating User!')");  
			out.println("location='http://localhost:8088/WePark/admin/usertable.jsp';");          			
			out.println("</script>");
		}
	}
	catch(Exception e){
		
		out.println("<script type=\"text/javascript\">");
		out.println("alert('Some error in the backend, try later!')");  
		out.println("location='http://localhost:8088/WePark/admin/usertable.jsp';");          			
		out.println("</script>");
		System.out.println(e);
	}	
	
}
else if(tbl.equals("WEPARKBOOKING"))
{
	String bookid=request.getParameter("bookid");
	String pkid=request.getParameter("pkid");
	String usrid=request.getParameter("usrid");
	String vhicleno=request.getParameter("vhicleno");
	String arrive=request.getParameter("arrive");
	String depart=request.getParameter("depart");
	int price=Integer.parseInt(request.getParameter("price"));
	
	try
	{
		PreparedStatement ps=con.prepareStatement("UPDATE WEPARKBOOKING SET PARKINGSLOTID=?, USERID=?, VEHICLENUMBER=?, FROMTIME=?, TOTIME=?, PRICE=? WHERE BOOKINGID=?");
		ps.setString(1,pkid);
		ps.setString(2,usrid);
		ps.setString(3,vhicleno);
		ps.setString(4,arrive);
		ps.setString(5,depart);
		ps.setInt(6,price);
		ps.setString(7,bookid);
		
		
		int rs=ps.executeUpdate();
		
		if(rs!=0)
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Operation Successfull!')");
			out.println("location='http://localhost:8088/WePark/admin/bookingtable.jsp';");
			out.println("</script>");
		}
		else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error Updating User!')");  
			out.println("location='http://localhost:8088/WePark/admin/bookingtable.jsp';");          			
			out.println("</script>");
		}
	}
	catch(Exception e){
		
		out.println("<script type=\"text/javascript\">");
		out.println("alert('Some error in the backend, try later!')");  
		out.println("location='http://localhost:8088/WePark/admin/bookingtable.jsp';");          			
		out.println("</script>");
		System.out.println(e);
	}	
}
else if(tbl.equals("WEPARKPARKINGSLOTS"))
{
	String pksltid=request.getParameter("pksltid");
	String name=request.getParameter("name");
	String address=request.getParameter("address");
	String phoneNo=request.getParameter("phoneNo");
	int slots=Integer.parseInt(request.getParameter("slots"));
	int price=Integer.parseInt(request.getParameter("price"));
	String map=request.getParameter("map");
	
	try
	{
		PreparedStatement ps=con.prepareStatement("UPDATE WEPARKPARKINGSLOTS SET PLACENAME=?, ADDRESS=?, PHONENO=?, AVAILABLESLOTS=?, PRICE=?, MAPS=? WHERE PARKINGSLOTID=?");
		ps.setString(1,name);
		ps.setString(2,address);
		ps.setString(3,phoneNo);
		ps.setInt(4,slots);
		ps.setInt(5,price);
		ps.setString(6,map);
		ps.setString(7,pksltid);
		
		
		int rs=ps.executeUpdate();
		
		if(rs!=0)
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Operation Successfull!')");
			out.println("location='http://localhost:8088/WePark/admin/parkingtable.jsp';");
			out.println("</script>");
		}
		else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error Updating User!')");  
			out.println("location='http://localhost:8088/WePark/admin/parkingtable.jsp';");          			
			out.println("</script>");
		}
	}
	catch(Exception e){
		
		out.println("<script type=\"text/javascript\">");
		out.println("alert('Some error in the backend, try later!')");  
		out.println("location='http://localhost:8088/WePark/admin/parkingtable.jsp';");          			
		out.println("</script>");
		System.out.println(e);
	}	
}

%>
<%@page import="com.org.wepark.ConnectionManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%
ConnectionManager connectionManager=new ConnectionManager();
Connection con=connectionManager.connectDB();

String id = request.getParameter("id");
String tbleName= request.getParameter("tablename");
String cmd="";


	cmd="SELECT * FROM WEPARKUSERS WHERE USERID= ?";
	session.setAttribute("TableNameUpdate", "WEPARKUSERS");


try
{
	PreparedStatement ps=con.prepareStatement(cmd);
	//ps.setString(1, tbleName.toString());
	ps.setString(1, id.toString());
	
	ResultSet rs=ps.executeQuery();
	
	while(rs.next())
	{
		%>
		<!DOCTYPE html>
		<html>
			<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
		<body>
		
		
		<div class="row d-flex justify-content-center">
			<div class="col-md-6" style="margin: auto;">
				 <div class="form-horizontal">
				 
					<h4>Update Information</h4>
					<form method="post" action="updateProcess.jsp">
					
						<input type="hidden" name="userid" value="<%=rs.getString(1) %>">
						<input type="text" required="required" style="width: 250px;" readonly="readonly" name="userid" value="<%=rs.getString(1) %>">
						<br>
						Name:<br>
						<input type="text" required="required" style="width: 250px;" name="name" value="<%=rs.getString(2) %>">
						<br>
						Email:<br>
						<input type="email" required="required" style="width: 250px;" name="email" value="<%=rs.getString(3) %>">
						<br>
						Password:<br>
						<input type="text" required="required" style="width: 250px;" name="password" value="<%=rs.getString(4) %>">
						<br>
						User Type:<br>
						<input type="text" required="required" style="width: 250px;" name="type" value="<%=rs.getString(5) %>">
						<br><br>
						<input type="submit" class="btn btn-primary" value="CONFIRM UPDATE">
					</form>
				</div>
				
			</div>
		</div>
		
		<%
	}
} catch (Exception e) {
e.printStackTrace();
}
%>
</body>
</html>
<%@page import="java.util.Locale"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.org.wepark.*" %>

<%
ConnectionManager connectionManager=new ConnectionManager();
Connection con=connectionManager.connectDB();

String id = request.getParameter("id");
String action=request.getParameter("action");

String cmd="",email="",userid="";

//send mail for feedback on exit
PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKBOOKING WHERE BOOKINGID = ?");
ps.setString(1, id);
ResultSet rs=ps.executeQuery();
while(rs.next())
{	
	userid=rs.getString("USERID");			
}
PreparedStatement ps2=con.prepareStatement("SELECT * FROM WEPARKUSERS WHERE USERID = ?");
ps2.setString(1, userid);
ResultSet rs2=ps2.executeQuery();
while(rs2.next())
{	
	email=rs2.getString("EMAIL");
}

/*
DateFormat dateFormat = new SimpleDateFormat("hh:mm:ss");
LocalTime now=LocalTime.now();
String current=now.toString();
Date currenttime=dateFormat.parse(current);*/

DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss", Locale.US);
LocalTime time = LocalTime.now();
String f = formatter.format(time); //Current time in HH:MM:SS

if(action.equals("ENTRY"))
{
	///Date d_arrive=dateFormat.parse(from);
	try
	{
		
		PreparedStatement pstmt=con.prepareStatement("UPDATE WEPARKBOOKING SET FROMTIME = ? WHERE BOOKINGID=?");
		pstmt.setString(1, f);
		pstmt.setString(2, id);
		int parkingslot_success=pstmt.executeUpdate();
		
		if (parkingslot_success!=0)
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Entered!');");
			out.println("location='http://localhost:8088/WePark/employee/empCurrentBooking.jsp';");
			out.println("</script>");
		}
		else
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error in execution!');");
			out.println("location='http://localhost:8088/WePark/employee/empCurrentBooking.jsp';");
			out.println("</script>");
		}
		
		
	}catch(Exception e)
	{
		out.print("entry exception "+e);
	}
	
	
}
else if(action.equals("EXIT"))
{
	int cost=0, price=0;
	
	int parkingslot_success=0;
    
	
	try{
		
		String from=request.getParameter("arive");
		price= Integer.parseInt(request.getParameter("price"));
		
		int availabelslots= Integer.parseInt((String)session.getAttribute("slotsAvailable"));
		int slotprice= Integer.parseInt((String)session.getAttribute("slotPrice"));
		
		DateFormat sdf = new SimpleDateFormat("hh:mm:ss");
		Date arriveTime = sdf.parse(from);
		Date leaveTime= sdf.parse(f);
		
		/////////////////Calculate time difference
			
		long timeDifference= leaveTime.getTime() - arriveTime.getTime();		
		final int SECOND = 1000;
		final int MINUTE = 60 * SECOND;
		final int HOUR = 60 * MINUTE;
		
		int hours=(int)timeDifference/HOUR;
		
		///CALCULATE AND COMPARE SLOT PRICES DIFFERENCE
		cost=hours*slotprice;
	}
	catch(Exception e)
	{
		out.print("exit exception1 "+e);
	}

	
	try
	{
		String prkid=session.getAttribute("empParkID").toString();

		
		if(cost==price)
		{
			PreparedStatement pstmt=con.prepareStatement("UPDATE WEPARKBOOKING SET TOTIME = ?, PRICE=?, STATUS=? WHERE BOOKINGID=?");
			pstmt.setString(1, f);
			pstmt.setInt(2, cost);
			pstmt.setString(3, "COMPLETED");
			pstmt.setString(4, id);
			
			parkingslot_success=pstmt.executeUpdate();
			
		}
		else
		{ 
			PreparedStatement pstmt=con.prepareStatement("UPDATE WEPARKBOOKING SET TOTIME = ?, STATUS = ? WHERE BOOKINGID=?");
			pstmt.setString(1, f);
			pstmt.setString(2, "COMPLETED");
			pstmt.setString(3, id);
			parkingslot_success=pstmt.executeUpdate();
		}
		
		
		
		if (parkingslot_success!=0)
		{
			CustomMail cm=new CustomMail();
			cm.sendMail(email, "WePark parking experiance","<!DOCTYPE html><html><style>body {font-family: Arial, Helvetica, sans-serif;}form { border: 3px solid #f1f1f1; font-family: Arial;}.container { padding: 20px; background-color: #f1f1f1;}a{text-decoration:none; background-color: #4CAF50; color: white; padding:20px; border: none;}a:hover { opacity: 0.8;}</style><body><h2>WePark</h2><form> <div class="+"container"+"> <h2>Have time to provide feedback?</h2> <p>Hello User. It is seen that you have used WePark. Please provide some feedback on your experiance with us as this will help us improve our system.</p> </div> <div class="+"container"+"> <a href="+"http://localhost:8088/WePark/feedback.jsp?email="+email+" target="+"_blank"+">Yes, Provide a Feedback</a> </div></form></body></html>");
			
			int slots=0;
			
			PreparedStatement pstmt=con.prepareStatement("SELECT * FROM WEPARKPARKINGSLOTS WHERE PARKINGSLOTID=?");
			pstmt.setString(1, prkid);
			ResultSet rs1=pstmt.executeQuery();
			while(rs1.next())
			{
				slots=rs1.getInt("AVAILABLESLOTS");
			}
			PreparedStatement incrementpstmt=con.prepareStatement("UPDATE WEPARKPARKINGSLOTS SET AVAILABLESLOTS=? WHERE PARKINGSLOTID=?");
			incrementpstmt.setInt(1, slots+1);
			incrementpstmt.setString(2, prkid);
			parkingslot_success=incrementpstmt.executeUpdate();
			
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Updated!');");
			out.println("location='http://localhost:8088/WePark/employee/empCurrentBooking.jsp';");
			out.println("</script>");
			
		}
		else
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Error in updating Values!');");
			out.println("location='http://localhost:8088/WePark/employee/empCurrentBooking.jsp';");
			out.println("</script>");
		}
		
		
	}catch(Exception e)
	{

		out.println("<script type=\"text/javascript\">");
		out.println("alert('Internal Error!"+e+"');");
		out.println("location='http://localhost:8088/WePark/employee/empCurrentBooking.jsp';");
		out.println("</script>");
	} 
	
	
}

%>
</body>
</html>
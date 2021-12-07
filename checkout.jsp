<%@page import="com.org.wepark.ConnectionManager"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*, java.text.*"%>
    
    
    <%
    /////////////////Generate Booking ID
    Random ran=new Random();
	int n=ran.nextInt((999999-100000)+1)+100000;
	String bkid="WEPRBK"+Integer.toString(n);
	
/////////////////Generate Payment ID
	int n2=ran.nextInt((999999-100000)+1)+100000;
	String paymentID="WEPRKORD"+Integer.toString(n2);

    
	////////////////DEclaring variables
	String address="";
	String phoneNo="";
	String userid="";
	String username="";
	String parkingslotid="";
	int availableSlots=0;
	
	
	//////////Getching session variables
    int price = (Integer)session.getAttribute("totalCost");
    String slotname=(String)session.getAttribute("place");
    String from=(String)session.getAttribute("arrive");
    String to=(String)session.getAttribute("leave");
    String email=(String)session.getAttribute("email");
    
    //get current date
    Date today;
    String dateresult;
    SimpleDateFormat formatter;
    formatter = new SimpleDateFormat("dd/MM/yyyy");
    today = new Date();
    dateresult = formatter.format(today);
    
    ////////////////The DB things
	ConnectionManager connectionManager=new ConnectionManager();
    Connection con=connectionManager.connectDB();
	
	////////////Fetch details from parking slot table
	try
	{
		
		PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKPARKINGSLOTS WHERE PLACENAME = ?");
		ps.setString(1, slotname);
		
		ResultSet rs=ps.executeQuery();
		
		while(rs.next())
		{
			
			address=rs.getString("ADDRESS");
			phoneNo=rs.getString("PHONENO");
			parkingslotid=rs.getString("PARKINGSLOTID");
			availableSlots=rs.getInt("AVAILABLESLOTS");			
		}		
	}
	catch(Exception e)
	{
		out.print(e);
	}
    
	/////////////////////////Fetch details from user table
	try
	{
		PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKUSERS WHERE EMAIL = ?");
		ps.setString(1, email);
		
		ResultSet rs=ps.executeQuery();
		
		while(rs.next())
		{
			userid=rs.getString("USERID");	
			username=rs.getString("NAME");	
			
			
		}		
		
	}
	catch(Exception e)
	{
		out.print(e);
	}
	
    %>
    
    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link>
<link rel="stylesheet" href="css/checkout.css">
</head>
<body>
<form action="checkout.jsp" method="post">
	
	<div class="container">
	  <div class="card">		
			 
			<img src="img/logo.png" style="height: 70px; margin-left: 20px">
			<br>
			<label>Name:</label>
 			<input class="input name"  value="<%out.print(username); %>" readonly="readonly">
 			<br>
 			<br>
 			<label style="float: left;">Parking Vehicle Number:</label><br>
 			<input class="input name" name="vehicleNumber" placeholder="Eg. KA 00 AA 1234" maxlength="13" pattern="^[A-Z]{2}\s[0-9]{2}\s[A-Z]{2}\s[0-9]{4}$" required="required" onkeyup="var start=this.selectionStart; var end=this.selectionEnd; this.value=this.value.toUpperCase(); this.setSelectionRange(start,end);">
 			<input type="submit" name="book" class="proceed" value="Book Slot">
			
			<%
			
			if(request.getParameter("book")!=null)
			{
				String vehicleNumber= request.getParameter("vehicleNumber");
				
				session.setAttribute("uid", userid);
				String parkingprice= Integer.toString(price);
				session.setAttribute("parkingPrice", parkingprice);
				session.setAttribute("paymentID", paymentID);

				//Insert pending into weparkbooking
				PreparedStatement pstmt=con.prepareStatement("INSERT INTO WEPARKBOOKING (BOOKINGID,PARKINGSLOTID, USERID, VEHICLENUMBER, FROMTIME,TOTIME,PRICE,PARKDATE,STATUS) VALUES(?,?,?,?,?,?,?,?,?)");
				
				pstmt.setString(1, bkid);
				pstmt.setString(2, parkingslotid);
				pstmt.setString(3, userid);
				pstmt.setString(4, vehicleNumber);
				pstmt.setString(5, from);
				pstmt.setString(6, to);
				pstmt.setInt(7, price);
				pstmt.setString(8, dateresult);
				pstmt.setString(9, "PENDING");
				
				int booking_success= pstmt.executeUpdate();
				
				//Insert pending into weparkbooking
				PreparedStatement updtpstmt=con.prepareStatement("UPDATE WEPARKPARKINGSLOTS SET AVAILABLESLOTS=? WHERE PARKINGSLOTID=?");
				updtpstmt.setInt(1,  availableSlots-1);
				updtpstmt.setString(2, parkingslotid);	
				
				int parkingslot_success=updtpstmt.executeUpdate();
				
				//Insert pending into payments
				PreparedStatement paystmt=con.prepareStatement("INSERT INTO WEPARKPAYMENT (PAYMENTID,BOOKINGID, USERID, PARKINGLOTID, PAYMENTSTATUS,PRICE) VALUES(?,?,?,?,?,?)");
				
				paystmt.setString(1, paymentID);
				paystmt.setString(2, bkid);
				paystmt.setString(3, userid);
				paystmt.setString(4, parkingslotid);
				paystmt.setString(5, "pending");
				paystmt.setInt(6, price);
				
				int success= paystmt.executeUpdate();
				
				if((booking_success!=0)&&(parkingslot_success!=0)&&(success!=0)){
		
					con.close();
					
					out.println("<script type=\"text/javascript\">");
					out.println("alert('Proceed to book the slot?');");
					out.println("location='http://localhost:8088/WePark/paytm/paytmProcessing.jsp';");
					out.println("</script>");
					
				}else{
					out.println("<script type=\"text/javascript\">");
					out.println("alert('Some internal error! Try again');");
					out.println("location='http://localhost:8088/WePark/userhome.jsp';");
					out.println("</script>");
				}
				
			}
			
			%>
			

			
	 
	  </div>
	  <div class="receipt">
	    <div class="col"><p>Total Cost:</p>
	    	<h2 class="cost" id="total_cost">&#8377;<% out.print(price); %> </h2><br>
	    	<p>Parking Location:</p>
	    	<h2 class="seller" id="location"><% out.print(slotname); %></h2>
	    </div>
	    <div class="col">
	      	<p>Booking Details:</p>
	      	<h3 class="bought-items">Booking ID: <% out.print(bkid);%></h3>
	      	<p class="bought-items description">Address: <% out.print(address); %></p>
	     	 <p class="bought-items price">Phone No: <% out.print(phoneNo); %></p><br>
	      	<h3 class="bought-items">User ID: <% out.print(userid); %></h3>
	      	<p class="bought-items description">Booking the slot from <% out.print(from); %> to <% out.print(to); %></p>
	      	<input type="text">
	    </div>
	    <p class="comprobe">The booking information will be sent to your registered mail</p>
	  </div>
	</div>
	


</form>

</body>
</html>
<%@page import="com.org.wepark.ConnectionManager"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>

    <%@ page import="java.util.*,java.text.*,java.time.*"%>
<%@page import="java.text.SimpleDateFormat"%>
	<!DOCTYPE html>
	<html lang="zxx" class="no-js">
	<head>
		<!-- Mobile Specific Meta -->

		<title>Car Rentals</title>
		
		<link href="https://fonts.googleapis.com/css?family=Poppins:100,200,400,300,500,600,700" rel="stylesheet"> 
			<!--
			CSS
			============================================= -->
			<link rel="stylesheet" href="css/index/nice-select.css">		
			<link rel="stylesheet" href="css/index/bootstrap.css">
			<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
			<link rel="stylesheet" href="css/index/main.css">
		</head>
		<body>

			  <header id="header" class="header-scrolled" id="home">
			    <div class="container">
			    	<div class="row align-items-center justify-content-between d-flex">
				      <div id="logo">
				        <a href="userhome.jsp"><img src="img/logo.png" alt="" title="" class="logo" /></a>
				      </div>
				      <nav id="nav-menu-container">
				        <ul class="nav-menu">
				        
				        <li><a style="color: #ff9900; font-style: normal; padding-right: 100px;">Welcome, <% 
				          
				          ////User name search and load
         		          
				          	String name=null, email=null;
				        	String uid="";

							ConnectionManager connectionManager=new ConnectionManager();
							Connection con=connectionManager.connectDB();
							
							if(request.getParameter("mail")!=null){
								email=request.getParameter("mail");
								PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKUSERS WHERE EMAIL = ?");
								ps.setString(1, email);
								
								ResultSet rs=ps.executeQuery();
								
								while(rs.next())
								{
									name=rs.getString("NAME");
									uid=rs.getString("USERID");
								}		
								
							}else{
								
								try
								{
									Object session_email=session.getAttribute("email");
							        email=session_email.toString();

									PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKUSERS WHERE EMAIL = ?");
									ps.setString(1, email);
									
									ResultSet rs=ps.executeQuery();
									
									while(rs.next())
									{
										name=rs.getString("NAME");
										uid=rs.getString("USERID");
									}		
								}
								catch(Exception e)
								{
									out.print(e);
									
									out.println("<script type=\"text/javascript\">");
									out.println("alert('Session has been logged out. Login again to use WePark.');");								
									out.println("location='http://localhost:8088/WePark/home.jsp';");
									out.println("</script>");
								}

								
							}
							out.print(name);
				          
				          %></a></li>
				          <li ><a href="userhome.jsp">Home</a></li>
						  <li><a href="bookings.jsp">Bookings</a></li>	
						  <li><a href="home.jsp">Logout</a></li>						  
				           		          
				        </ul>
				      </nav><!-- #nav-menu-container -->		    		
			    	</div>
			    </div>
			  </header><!-- #header -->

			<!-- start banner Area -->
			<section style="background: url('img/booking-header.jpg'); max-width:100%; max-height: 100%; display: block;" id="home">	
				<div class="overlay overlay-bg"></div>
				<div class="container">
					<div class="row d-flex align-items-center justify-content-center">
						<div class="about-content col-lg-12">
							<h1 class="text-white">
								Your Bookings	
							</h1>	
						
						</div>											
					</div>
				</div>
			</section>
			<!-- End banner Area -->	

			<!-- Start model Area -->
			
			
			<section class="model-area" style="padding: 30px;" id="cars">
				
					<div class="row d-flex justify-content-center pb-40">
						<div class="col-md-8 pb-40 header-text">
							
							<%
							
							Date todaydate= Calendar.getInstance().getTime();
							DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
							String today=formatter.format(todaydate);
							int counter=0;
							/// To Display upcoming bookings
							  try
								{
									String from="",to="",place="",slotid="";

									///SELECTING USER BOOKING DETAILS
									PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKBOOKING WHERE USERID = ? AND PARKDATE = ?");
									ps.setString(1, uid);
									ps.setString(2, today);
									
									ResultSet rs=ps.executeQuery();
									
									while(rs.next())
									{
										from=rs.getString("FROMTIME");
										to=rs.getString("TOTIME");
										slotid=rs.getString("PARKINGSLOTID");
										
										PreparedStatement ps2=con.prepareStatement("SELECT * FROM WEPARKPARKINGSLOTS WHERE PARKINGSLOTID = ?");
										ps2.setString(1, slotid);
										ResultSet rs2=ps2.executeQuery();
										
										while(rs2.next()){
											out.print("<h2>You have a booking today from "+from+ " to "+to+" at "+rs2.getString("PLACENAME")+". Have a Nice Day.</h2><br> " );
											break;
										}
										
										counter=1;
										break;
									}
									
									if(counter==0)
									{
										out.print("<h2>You have no parking slots reserved for you today.</h2><br>");
									}
									
								}
								catch(Exception e)
								{
									out.println("<script type=\"text/javascript\">");
									out.println("alert('Error Loading Info!');");								
									out.println("location='http://localhost:8088/WePark/userhome.jsp';");
									out.println("</script>");
								}
							
							%>
							<h4>Your previous bookings in WePark</h4><br>
							 <table class="table table-striped table-bordered table-hover">
							 
								  <thead>
								    <tr>
								      <th scope="col">Booking ID</th>
								      <th scope="col">Parking Lot ID</th>
								      <th scope="col">Timing</th>
								      <th scope="col">Date</th>
								      <th scope="col">Total Cost</th>
								      
								    </tr>
								  </thead>
								  <tbody>
								  
								  <% 
									
								 
								  String pid="";
								  String date="";
								  
								  
								  try
									{
										PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKBOOKING WHERE USERID = ?");
										ps.setString(1, uid);
										//ps.setString(2, today);
										
										ResultSet rs=ps.executeQuery();
										
										while(rs.next())
										{
											%><tr class="odd gradeX">
                                			<td><%out.print(rs.getString("BOOKINGID"));%></td>
                                			<td><%pid=rs.getString("PARKINGSLOTID"); out.print(pid);%></td>	
                                			<td><%out.print(rs.getString("FROMTIME")+"  to  "+(rs.getString("TOTIME")));%></td>
                                			<td><%date=rs.getString("PARKDATE"); out.print(date);%></td>	
                                			<td><%out.print(rs.getInt("PRICE"));%></td><%
										}		
									}
									catch(Exception e)
									{
										//out.print(e);
										out.println("<script type=\"text/javascript\">");
										out.println("alert('Error Loading Info!' "+e+");");								
										out.println("location='http://localhost:8088/WePark/userhome.jsp';");
										out.println("</script>");
									}
								  
								  %>
								    
								  </tbody>
								</table>
			
							<%
							
							/**
							
							Date today;
							String result;
							SimpleDateFormat formatter;
							formatter = new SimpleDateFormat("yyyy/MM/dd");
							today = new Date();
							
							Date bookdate=formatter.parse(date);
							
							
							if(today.compareTo(bookdate)==0)
							{

								String pname="";
									try{
										Class.forName("oracle.jdbc.driver.OracleDriver");
										Connection con=DriverManager.getConnection(url,userName,passcode);	
										PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKPARKINGSLOTS WHERE PARKINGSLOTID = ?");
										ps.setString(1, pid);
										
										ResultSet rs=ps.executeQuery();
										
										while(rs.next())
										{
											pname=rs.getString("PLACENAME");
										}
										
										out.print("<h3> Hello "+name+". You have a booking of a parking slot today at "+ pname +". </h3>");
										
									}catch(Exception e)
								{
										
								}
							}
							else
							{
								out.print("<h3>Hello "+name+". You have no bookings today.</h3>");
							}
							
							
							*///////
							%>
						
						</div>
						*For Cancellations, contact info@WePark.com or +91 7026661840.
					</div>						
					
					
			</section>
			<!-- End model Area -->			

			<!-- Start callaction Area -->
		
			<!-- End callaction Area -->

			<!-- Start feature Area -->
		
			<!-- End feature Area -->				
	
			<!-- start footer Area -->		
<footer class="footer-area section-gap">
				<div class="container">
					<div class="row">
						<div class="col-lg-2 col-md-6 col-sm-6" 	>
							<div class="single-footer-widget" >
								<h6>WePark</h6>
								A easy online solution for all your parking problems.								
							</div>
							
						</div>
						
						<div class="col-lg-2 col-md-6 col-sm-6" style="margin-right: 150px">
							<div class="single-footer-widget">
								<h6>Quick Links</h6>
								<ul>
									<li><a href="#">Login</a></li>
									<li><a href="#">Sign Up</a></li>									
									<li><a href="#">Home</a></li>
								</ul>								
							</div>
						</div>
						
						<div class="col-lg-2 col-md-6 col-sm-6">
							<div class="single-footer-widget">
								<h6>Contact Us</h6>
								<a href="mailto:16cs1k354@gmail.com" title="glorythemes">info@WePark.com</a>								
							</div>
							
						</div>
						<div class="col-md-12 text-center">
								<p>Copyright WePark © 2020. All rights reserved.</p>
						</div>											
																	
					</div>
				</div>
			</footer>
			<!-- End footer Area -->		

			<script src="js/vendor/jquery-2.2.4.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" ></script>
			<script src="js/vendor/bootstrap.min.js"></script>			
			<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBhOdIF3Y9382fqJYt5I_sswSrEw5eihAA"></script>
			<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>			
  			<script src="js/easing.min.js"></script>			
			<script src="js/hoverIntent.js"></script>
			<script src="js/superfish.min.js"></script>	
			<script src="js/jquery.ajaxchimp.min.js"></script>
			<script src="js/jquery.magnific-popup.min.js"></script>	
			<script src="js/owl.carousel.min.js"></script>			
			<script src="js/jquery.sticky.js"></script>
			<script src="js/jquery.nice-select.min.js"></script>	
			<script src="js/waypoints.min.js"></script>
			<script src="js/jquery.counterup.min.js"></script>					
			<script src="js/parallax.min.js"></script>		
			<script src="js/mail-script.js"></script>	
			<script src="js/main.js"></script>	
		</body>
	</html>


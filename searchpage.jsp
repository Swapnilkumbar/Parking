<%@page import="com.org.wepark.ConnectionManager"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*, java.time.*"%>
	<!DOCTYPE html>
	<html lang="zxx" class="no-js">
	<head>
		<!-- Mobile Specific Meta -->

		<title>ParkIt</title>
		
		<%		

		String place= (String)session.getAttribute("place");
		String arrive=(String)session.getAttribute("arrive");
		String leave=(String)session.getAttribute("leave");
		String parkinglotid="";
		
		int slots=0;
    	int price=0;
    	
    	
    	///////////////Time Calculation
    	
    	DateFormat dateFormat = new SimpleDateFormat("hh:mm:ss");
		LocalTime now=LocalTime.now();
		String current=now.toString();
		
		Date currenttime=dateFormat.parse(current);
		Date d_arrive=dateFormat.parse(arrive);
		Date d_leave=dateFormat.parse(leave);
		
		/////////////////Calculate time difference
		
		long timeDifference= d_leave.getTime() - d_arrive.getTime();		
		final int SECOND = 1000;
		final int MINUTE = 60 * SECOND;
		final int HOUR = 60 * MINUTE;
		
		//int hours=(int)timeDifference/HOUR;
		int minutes=(int)timeDifference/MINUTE;
		int hours=minutes/60;
		int mins=minutes%60;
		String mints="30";
		if(mins==0){
			mints="00";
		}
		
		//////DB things
		
		ConnectionManager connectionManager=new ConnectionManager();
		Connection con=connectionManager.connectDB();
		
		String maplink=null;
		
			/////////Check times
		if((d_arrive.compareTo(d_leave)>0)&&(currenttime.compareTo(d_arrive)>0))
		{
			//currenttime.compareTo(d_arrive
					
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Your Arrival time and Leaving time is not looking correct. Try Again!');");								
			out.println("location='http://localhost:8088/WePark/home.jsp';");
			out.println("</script>");
		}
		else
		{
			///////////////////Check if slots available
			try
			{		
				PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKPARKINGSLOTS WHERE PLACENAME = ?");
				ps.setString(1, place);
				
				ResultSet rs=ps.executeQuery();
				
				while(rs.next())
				{
					slots=rs.getInt("AVAILABLESLOTS");
				}		
			}
			catch(NullPointerException e)
			{
				System.out.println(e);
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Sorry! We do not provide our service in this region. Try another place instead.');");								
				out.println("location='http://localhost:8088/WePark/userhome.jsp';");
				out.println("</script>");
			}
			
			
			///////////////////////////////Show the slot or not
			if(slots>0)
			{				
				
				try
				{	
					PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKPARKINGSLOTS WHERE PLACENAME = ?");
					ps.setString(1, place);
					
					ResultSet rs=ps.executeQuery();
					
					while(rs.next())
					{
						maplink=rs.getString("MAPS");
						price=rs.getInt("PRICE");	
						parkinglotid= rs.getString("PARKINGSLOTID");
					}		
				}
				catch(Exception e)
				{
					//out.print(e);
					out.println("<script type=\"text/javascript\">");
					out.println("alert('Sorry! We do not provide our service in this region. Try another place instead.');");								
					out.println("location='http://localhost:8088/WePark/userhome.jsp';");
					out.println("</script>");
				}
			}
			else
			{
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Sorry! The WePark parking is full at this place. Try another place instead.');");								
				out.println("location='http://localhost:8088/WePark/userhome.jsp';");
				out.println("</script>");
			}
			
		}
		
		
		
		%>

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

		<form action="searchpage.jsp" method="POST">
		
			  <header id="header" class="header-scrolled" id="home">
			    <div class="container">
			    	<div class="row align-items-center justify-content-between d-flex">
				      <div id="logo">
				        <a href="userhome.jsp"><img src="img/logo.png" alt="" title="" class="logo" /></a>
				      </div>
				      <nav id="nav-menu-container">
				        <ul class="nav-menu">
				        
				        <li><a style="color: #ff9900; font-style: normal; padding-right: 100px;">Welcome, <% 
				          
				          ////User name search and load user
         		          
				          	String name=null;
				        	
							
							
							try
							{
								Object session_email=session.getAttribute("email");
						        String email=session_email.toString();
				
								PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKUSERS WHERE EMAIL = ?");
								ps.setString(1, email);
								
								ResultSet rs=ps.executeQuery();
								
								while(rs.next())
								{
									name=rs.getString("NAME");																	
									
								}		
							}
							catch(Exception e)
							{
								//out.print(e);
								name="guest";
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
			<!-- End banner Area -->	

			<!-- Start model Area -->
			<section class="model-area section-gap" id="search">
				<div class="container">
					<div class="row d-flex justify-content-center pb-40">
						<div class="col-md-8 pb-40 header-text">
							<h1 class="text-center pb-10">select a slot where you want to park</h1>						
						</div>
						
					</div>
					
					<p>Place &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
					&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
					&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Arrive at
					&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Leave by</p>
					<input type="text" style="outline: none;font-size: 150%; margin-right: 60px; height: 40px; width: 500px" value="<% out.print(place); %>" readonly="readonly">
					<input type="text" style="outline: none;font-size: 150%; float: right; margin-left: 10px; height: 40px; width: 200px" value=" <% out.print(leave);%> " readonly="readonly">
					<input type="text" style="outline: none;font-size: 150%; float: right; margin-left: 80px; height: 40px; width: 200px" value="<% out.print(arrive); %>" readonly="readonly"><br><br>
					
					<p>Slots Available &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
					&emsp;Price per hour &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
					&emsp;Total Time&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
					&emsp;&emsp;&emsp;&emsp;Price for parking</p>
					<input type="text" style="outline: none;border-style: none; font-size: 150%; margin-right: 40px; height: 40px; width: 200px" value="<% out.print(slots); %>" readonly="readonly">
					<input type="text" style="outline: none;border-style: none;font-size: 150%; margin-right: 40px; height: 40px; width: 200px" value="&#8377; <% out.print(price); %>" readonly="readonly">
					<input type="text" style="outline: none;border-style: none;font-size: 150%; margin-right: 40px; height: 40px; width: 200px" value="<% out.print(hours+":"+mints); %> hours" readonly="readonly">
					<input type="text" style="outline: none;border-style: none;font-size: 150%; margin-right: 40px; height: 40px; width: 200px" value="&#8377; <%
					int totalCost=1,extra=0;
					if(mins!=0){
						extra=price/2;
					}
					totalCost=(price*hours)+extra;
					out.print(totalCost); %>" readonly="readonly">
				
					
					<input type="submit" class="btn btn-success " name="book" value="Book Slot">
					
				</div>
											
					
			</section>
			
				
				
			<section style="margin-left: 100px; margin-bottom: 200px">
							<div >
								<iframe src="<%out.print(maplink);%>" 
								width="1150" height="800" style="border:2px solid grey;box-shadow: 0 0 10px grey;"></iframe>
							</div>
							

			</section>
			<!-- ---------------------------------------------------------------------------------------------------------------- -->
			<section class="callaction-area relative section-gap">
				<div class="overlay overlay-bg"></div>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-lg-10">
							<h1 class="text-white">Experience Great Support</h1>
							<p>
								Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore  et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.
							</p>	
						</div>
					</div>
				</div>	
			</section>
	
			<footer class="footer-area section-gap">
				<div class="container">
					<div class="row">
						<div class="col-lg-2 col-md-6 col-sm-6">
							<div class="single-footer-widget">
								<h6>Quick links</h6>
								<ul>
									<li><a href="#">Jobs</a></li>
									<li><a href="#">Brand Assets</a></li>
									<li><a href="#">Investor Relations</a></li>
									<li><a href="#">Terms of Service</a></li>
								</ul>								
							</div>
						</div>
						<div class="col-lg-2 col-md-6 col-sm-6">
							<div class="single-footer-widget">
								<h6>Features</h6>
								<ul>
									<li><a href="#">Jobs</a></li>
									<li><a href="#">Brand Assets</a></li>
									<li><a href="#">Investor Relations</a></li>
									<li><a href="#">Terms of Service</a></li>
								</ul>								
							</div>
						</div>
						<div class="col-lg-2 col-md-6 col-sm-6">
							<div class="single-footer-widget">
								<h6>Resources</h6>
								<ul>
									<li><a href="#">Jobs</a></li>
									<li><a href="#">Brand Assets</a></li>
									<li><a href="#">Investor Relations</a></li>
									<li><a href="#">Terms of Service</a></li>
								</ul>								
							</div>
						</div>												
						<div class="col-lg-2 col-md-6 col-sm-6 social-widget">
							<div class="single-footer-widget">
								<h6>Follow Us</h6>
								<p>Let us be social</p>
								<div class="footer-social d-flex align-items-center">
									<a href="#"><i class="fa fa-facebook"></i></a>
									<a href="#"><i class="fa fa-twitter"></i></a>
									<a href="#"><i class="fa fa-dribbble"></i></a>
									<a href="#"><i class="fa fa-behance"></i></a>
								</div>
							</div>
						</div>							
						
						<p class="mt-50 mx-auto footer-text col-lg-12">
							<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart-o" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
						</p>											
					</div>
				</div>
			</footer>	
			<!-- End footer Area -->		

			<script src="js/vendor/jquery-2.2.4.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
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
		</form>
		</body>
	</html>

	<%
	
	if(request.getParameter("book")!=null)
	{
		//////////////////////////// CODE TO BOOK SLOT
		if(name.equals("guest"))
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Please Log into WePark To Book a Slot.');");								
			out.println("location='http://localhost:8088/WePark/home.jsp';");
			out.println("</script>");
		}
		else
		{
			
				try{
					
					slots=slots-1;
					session.setAttribute("place", place);
					session.setAttribute("arrive", arrive);
					session.setAttribute("leave", leave);
					session.setAttribute("totalCost", totalCost);
					session.setAttribute("hours", hours);	
					session.setAttribute("parkinglotid", parkinglotid);
					session.setAttribute("availableSlots", slots);
					
					out.println("<script type=\"text/javascript\">");								
					out.println("location='http://localhost:8088/WePark/checkout.jsp';");
					out.println("</script>");
					
				}
				catch(Exception e)
				{
					out.print("Error");
					
				}

			
		}
	}
	
	%>	



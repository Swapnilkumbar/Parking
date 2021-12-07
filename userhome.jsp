<%@page import="com.org.wepark.ConnectionManager"%>
<%@page import="com.org.wepark.CompareTime"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>

<% 		
		response.setHeader("Cache-Control","no-cache"); //HTTP 1.1 
		 response.setHeader("Pragma","no-cache"); //HTTP 1.0 
		 response.setDateHeader ("Expires", 0); //prevents caching at the proxy server  
		 

 
%>

    
	<!DOCTYPE html>
	<html lang="zxx" class="no-js">
	<head>
		<title>We park</title>

			<link href="https://fonts.googleapis.com/css?family=Poppins:100,200,400,300,500,600,700" rel="stylesheet"> 
			
			<link rel="stylesheet" href="css/index/bootstrap.css">
			<link rel="stylesheet" href="css/index/nice-select.css">	
			<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
			<link rel="stylesheet" href="css/index/main.css">
			
			<script src="https://code.jquery.com/jquery-2.2.4.js"></script>
			<script src="js/jquery-1.12.4-jquery.min.js" type="text/javascript"></script>
			
			<script type="text/javascript">
			(function()
					{
					  if( window.localStorage )
					  {
					    if( !localStorage.getItem('firstLoad') )
					    {
					      localStorage['firstLoad'] = true;
					      window.location.reload();
					    }  
					    else
					      localStorage.removeItem('firstLoad');
					  }
					})();
			</script>
			
			<!-- CODE FOR AUTOCOMPLATE TO WORK -->
			<script type="text/javascript">
			        $(document).ready(function(){
			            $('#placetopark').keyup(function(){
			                var search=$('#placetopark').val();
			                if(search !=='' && search !==null)
			                {    
			                    $.ajax({ 
			                       type:'POST',
			                       url:'autocompletefetch.jsp',
			                       data:'key='+search,
			                       success:function(data)
			                       {
			                           $('#showList').html(data);
			                       }
			                    }); 
			                }
			                else
			                {
			                    $('#showList').html('');
			                }
			            });
			            $('#showList').on('click','li',function(){
			               $('#placetopark').val($(this).text());
			               $("#showList").fadeOut(100);
			            });
			        	
			            
			        });
			</script>
			
			
		</head>
		<body>

			  <header id="header" id="home">
			    <div class="container">
			    	<div class="row align-items-center justify-content-between d-flex">
				      <div id="logo">
				        <a href="userhome.jsp"><img src="img/logo.png" alt="" title="" class="logo"/></a>
				      </div>
				      <nav id="nav-menu-container">
				        <ul class="nav-menu">
				        
				          <li><a style="color: #ff9900; font-style: normal; padding-right: 100px;">Welcome, <% 
				          
				          ////User name search and load
         		          
				          	String name=null;
							
							ConnectionManager connectionManager=new ConnectionManager();
							Connection con=connectionManager.connectDB();
							
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
								out.println("<script type=\"text/javascript\">");
								out.println("alert('Session has been logged out. Login again to use WePark.');");								
								out.println("location='http://localhost:8088/WePark/home.jsp';");
								out.println("</script>");
							}
				          out.print(name);
				          
				          %></a></li>		
				          <li><a href="userhome.jsp">Home</a></li>
				          <li><a href="bookings.jsp"> Bookings</a></li>					          	          
				          <li><a href="jsp\invalidateSessionUserHome.jsp"> Logout </a></li>
				          	
				        		          
				        </ul>
				      </nav><!-- #nav-menu-container -->		    		
			    	</div>
			    </div>
			  </header><!-- #header -->


			<!-- start banner Area -->
			<section style="background: url('img/header-bg.jpg'); background-size: cover;  background-color: rgba(0,0,0,0.5)" id="home">
					
				<div class="container">
					<div class="row fullscreen d-flex align-items-center justify-content-center">
						<div class="banner-content col-lg-7 col-md-6 " style="margin-top: 100px;">
					
							<h2 class="text-white text-uppercase ">
								Find parking in seconds 				
							</h2>
							<p style="color:rgb(255, 255, 255);font-weight: normal; text-shadow: 8px 8px 8px black; font-size: medium;"> <br>Choose from hundreds of available spaces in Bangalore, 
								or reserve<br> your space in advance. <br>Join WePark and enjoying easy parking.</p>
							
						
						</div>
						<div class="col-lg-5  col-md-6 header-right">
							<h4 class="text-white pb-30">Book your parking slot for today!</h4>
							<form class="form" role="form" autocomplete="off" method="POST">
							
							    <div class="form-group">
							       	<div class="default-select" id="default-select">
										<!---
										<select>
											<option value="" disabled selected hidden>Where do you want to park?</option>
											
										</select>
										-->
										<input required="required" id="placetopark" type="text" name="placetopark" placeholder="     Where do you want to park?" style="width:375px; height: 40px; border-radius: 8px; outline: none; border: none;">
										<div id="showList" style="position: absolute; z-index: 1000">
							                <ul class="list-group">
							                </ul>
							            </div>
										
									</div>
							    </div>
							   <div class="form-group row">
							        <div class="col-md-6 wrap-left">
								       	<div class="default-select" id="default-select">
											<select name="arrive" required="required">
												<option value="" disabled selected >Ariving at</option>
												<%
												
												Date dateee = new Date();
											    String strDateFormatttt = "HH:mm";
											    DateFormat dateFormatttt = new SimpleDateFormat(strDateFormatttt);
											    String formattedDateeee= dateFormatttt.format(dateee);
											    String[] splitDate=formattedDateeee.split(":");
											    int hourr=Integer.parseInt(splitDate[0]);
											    int minn=Integer.parseInt(splitDate[1]);

											    int first=1;
											    while(hourr<=24){
											    	
											    	if(first==1){
											    		if(minn<30){
												    		out.println("<option value="+hourr+":30:00"+">"+hourr+":30"+"</option>");
												    		out.println("<option value="+hourr+":00:00"+">"+hourr+":00"+"</option>");
												    		first=30;
												    	}else if(minn>=30){
												    		hourr++;
												    		out.println("<option value="+hourr+":00:00"+">"+hourr+":00"+"</option>");
												    		out.println("<option value="+hourr+":30:00"+">"+hourr+":30"+"</option>");
												    		first=0;
												    	}
											    		hourr++;
											    		
											    	}else if(first==0){
											    		out.println("<option value="+hourr+":00:00"+">"+hourr+":00"+"</option>");
												    	out.println("<option value="+hourr+":30:00"+">"+hourr+":30"+"</option>");
												    	hourr++;
											    	}else if(first==30){
											    		out.println("<option value="+hourr+":30:00"+">"+hourr+":30"+"</option>");
												    	out.println("<option value="+hourr+":00:00"+">"+hourr+":00"+"</option>");
												    	hourr++;
											    	}
											    	
											    	
											    }    											
											    
												%>
											</select>
										</div>
							        </div>
							        <div class="col-md-6 wrap-right">
										<div class="col-md-6 wrap-right">
										<div class="input-group dates-wrap">                                          
											<input type="text" readonly="readonly" style="color: #999999;height: 40px; border-radius: 4px; outline: none; border: none;" value=" Date : <% Date date= Calendar.getInstance().getTime(); DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy"); String today=formatter.format(date); out.print(today);  %>">											
																			
										</div>
							        </div>
							        </div>
							    </div>
							    <div class="form-group row">
							        <div class="col-md-6 wrap-left">
								       	<div class="default-select" id="default-select">
											<select name="leave" required="required">
												<option value="" disabled selected >Leaving at</option>
												<%

												Date datee = new Date();
											    String strDateFormattt = "hh:mm";
											    DateFormat dateFormattt = new SimpleDateFormat(strDateFormattt);
											    String formattedDateee= dateFormatttt.format(datee);
											    String[] splitDatee=formattedDateee.split(":");
											    int hour=Integer.parseInt(splitDatee[0]);
											    int min=Integer.parseInt(splitDatee[1]);
											    
											    int second=1;
											    while(hour<=24){
											    	
											    	if(second==1){
											    		
											    		if(min<30){
												    		out.println("<option value="+hour+":30:00"+">"+hour+":30"+"</option>");
												    		second=30;
												    	}else if(min>=30){
												    		hour+=1;
												    		out.println("<option value="+hour+":00:00"+">"+hour+":00"+"</option>");
												    		out.println("<option value="+hour+":30:00"+">"+hour+":30"+"</option>");
												    		second=0;
												    	}
											    		hour++;
											    		
											    	}else if(second==0){
											    		out.println("<option value="+hour+":00:00"+">"+hour+":00"+"</option>");
												    	out.println("<option value="+hour+":30:00"+">"+hour+":30"+"</option>");
												    	hour++;
											    	}else if(second==30){
											    		out.println("<option value="+hour+":30:00"+">"+hour+":30"+"</option>");
												    	out.println("<option value="+hour+":00:00"+">"+hour+":00"+"</option>");
												    	hour++;
											    	}
											    	
											    	
											    }
											    
											    while(hour<23){
											    	if(min<30){
											    		out.println("<option value="+hour+":30:00"+">"+hour+":30"+"</option>");
											    		min=30;
											    	}else if(min>30){
											    		out.println("<option value="+hour+":00:00"+">"+hour+":00"+"</option>");
											    		min=0;
											    	}
											    	hour=hour+1;
											    	
											    }    											
											    
												%>
											</select>
										</div>
									</div>									
									
							    </div>						    
							 
							    <div class="form-group row">
							        <div class="col-md-12">
							            <button type="submit" class="btn btn-default btn-lg btn-block text-center text-uppercase" name="submit">Show parking places</button>
							        </div>
							        <%
								        try
							        	{
							        		if (request.getParameter("submit")!=null)
								        	{
							        			
								        		///////////// Code to show available parking sections
								        		String place=request.getParameter("placetopark");
								        		String arrive=request.getParameter("arrive");
								        		String leave=request.getParameter("leave");	
								        		

								        		if((arrive.equals("none"))||(leave.equals("none")))
								        		{
								        			out.println("<script type=\"text/javascript\">");
								        			out.println("alert('Please fill all fields!');");
								        			out.println("location.reload();");
									        		out.println("</script>");
								        		}
								        		if(arrive.equals(leave)){
								        			out.print("<script>alert('There is error in time');</script>");
								        		}else{
								        			
								        			CompareTime compareTime=new CompareTime();
								        			int res=compareTime.compare(arrive, leave);
								        			if(res!=1){
								        				session.setAttribute("place", place);
										        		session.setAttribute("arrive", arrive);
										        		session.setAttribute("leave", leave);								        		
										        		
										        		out.println("<script type=\"text/javascript\">");
										        		out.println("location='http://localhost:8088/WePark/searchpage.jsp';");
										        		out.println("</script>");
								        			}else{
								        				out.print("<script>alert('There is error in time');</script>");
								        			}
								        		}	
								        		
								        	}
							        	}
							        	catch(Exception e)
							        	{
							        		out.print(e);
							        	}
							        	
							        	
							        	%>
							    </div>
							</form>
						</div>											
					</div>
				</div>					
			</section>
			<!-- End banner Area -->	

			<!-- Start feature Area -->
			<section class="feature-area section-gap" id="service">
				<div class="container">
					<div class="row d-flex justify-content-center">
						<div class="col-md-8 pb-40 header-text">
							<h1>Parking made easy</h1>
							
						</div>
					</div>
					<div class="row">
						<div class="col-lg-4 col-md-6">
							<div class="single-feature">
								<h4><span class="lnr lnr-user"></span>Wherever, whenever</h4>
								<p>
									Choose from millions of spaces across the Bangalore Find your best option for every car journey
								</p>
							</div>
						</div>
						<div class="col-lg-4 col-md-6">
							<div class="single-feature">
								<h4><span class="lnr lnr-license"></span>Professional Service</h4>
								<p>
									View information on availability, price and restrictions
								</p>								
							</div>
						</div>
						<div class="col-lg-4 col-md-6">
							<div class="single-feature">
								<h4><span class="lnr lnr-phone"></span>Great Support</h4>
								<p>
									Pay for We park spaces via the app or website Follow easy directions and access instructions
							</div>
						</div>
								
							</div>
						</div>						
				
			</section>
			<!-- End feature Area -->		

			<!-- Start home-about Area -->
			<section class="home-about-area" id="about">
				<div class="container-fluid">				
					<div class="row justify-content-center align-items-center">
						<div class="col-lg-6 no-padding home-about-left">
							<img class="img-fluid" src="img/about-img.jpg" alt="">
						</div>
						<div class="col-lg-6 no-padding home-about-right">
							<h1>Rent out  <br>
							your parking places</h1>
							
							<p>
								Make easy tax free money by renting out your parking space
							</p>
							<h1 style="color: rgb(0,0,0); ">Coming Soon!</h1>
						</div>
					</div>
				</div>	
			</section>
			<!-- End home-about Area -->	

			<!-- Start model Area -->
		
			<!-- End blog Area -->


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
			<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBhOdIF3Y9382fqJYt5I_sswSrEw5eihAA"></script>
			<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>			
  			<script src="js/index/superfish.min.js"></script>	
			<script src="js/index/jquery.magnific-popup.min.js"></script>	
			<script src="js/index/owl.carousel.min.js"></script>			
			<script src="js/index/jquery.nice-select.min.js"></script>	
			<script src="js/index/main.js"></script>	
		</body>
	</html>



    
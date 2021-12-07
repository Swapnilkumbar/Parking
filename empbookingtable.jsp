<%@page import="com.org.wepark.ConnectionManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>

<% 		
		response.setHeader("Cache-Control","no-cache"); //HTTP 1.1 
		 response.setHeader("Pragma","no-cache"); //HTTP 1.0 
		 response.setDateHeader ("Expires", 0); //prevents caching at the proxy server   
	 
		 //////////////DB things
		 	String name=null;
			
			ConnectionManager connectionManager=new ConnectionManager();
			Connection con=connectionManager.connectDB();
		 
			String empParkID="";
			int availableSlots=0, price=0;
		    
			try
			{
				Object session_email=session.getAttribute("email");
		       	String email=session_email.toString();
		       
		       	Object session_parkingID=session.getAttribute("empParkID");
			    empParkID=session_parkingID.toString();
	
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
			session.setAttribute("adminName", name);
			
			try{
					
				PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKPARKINGSLOTS WHERE PARKINGSLOTID = ?");
				ps.setString(1, empParkID);
				
				ResultSet rs=ps.executeQuery();
				
				while(rs.next())
				{
					availableSlots=rs.getInt("AVAILABLESLOTS");
					price=rs.getInt("PRICE");					
				}
				session.setAttribute("slotPrice", price);
				session.setAttribute("slotsAvailable", availableSlots);
			}
			catch(Exception e)
			{
				
			}
	
%>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />

    <title>WePark Employee</title>
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <link href="assets/css/style.css" rel="stylesheet" />
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    
  



    
</head>

<body>
<form action="usertable.jsp" method="post" name="form">


    <div class="navbar navbar-inverse set-radius-zero" >
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="index.html">

                    <img src="assets/img/logo.png" style="height: 50px"/>
                </a>

            </div>

            <div class="right-div">
            <label style="margin-right: 50px;">Welcome, <%out.print((String)session.getAttribute("adminName")); %></label>
                <a class="btn btn-info pull-right" href="invalidateSessionUserHome.jsp">LOG OUT</a>
            </div>
        </div>
    </div>
    <!-- LOGO HEADER END-->		
    <section class="menu-section">
        <div class="container">
      	      <div class="row">
                <div class="col-md-12">
                    <div class="navbar-collapse collapse ">
                        <ul id="menu-top" class="nav navbar-nav navbar-right">           
                            
                            <li><a href="empCurrentBooking.jsp" >BOOKINGS TODAY</a></li>
                            <li><a href="empbookingtable.jsp" class="menu-top-active" >ALL BOOKINGS</a></li>
                            
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </section>
     <!-- MENU SECTION END-->
     
     
     
    <div class="content-wrapper">
    	
    	<input type="hidden" id="hupdate" name="hupdate" />
    	<input type="hidden" id="hdelete" name="hdelete" />

    	
         <div class="container">      
     
            <div class="row">
                <div class="col-md-12">
                    <!-- Advanced Tables -->
                    <h4 style="margin-bottom: 10px;font-weight: bold;">Table Contents</h4> 
                    <div class="panel panel-default">
                    	
                        <div class="panel-heading">
                             Bookings Table
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                                    <thead>
                                        <tr>
                                            <th>Booking ID</th>
                                            <th>Vehicle Number</th>
                                            <th>From</th>
                                            <th>To</th>
                                            <th>Price</th>
                                        </tr>
                                    </thead>
                                    <tbody>                                   
                                        
                                        <%
	                    				/////////////////Login credentials for Oracle	                                	
	                                	try
	                                	{
	                                		PreparedStatement ps=con.prepareStatement("SELECT * FROM WEPARKBOOKING WHERE PARKINGSLOTID= ?");	//Display bookingIDs based on 
	                                		ps.setString(1, empParkID);
	                                		
	                                		ResultSet rs=ps.executeQuery();
	                                		
	                                		while(rs.next())
	                                		{
	                                			%><tr class="odd gradeX">
		                                			<td><%out.print(rs.getString("BOOKINGID"));%></td>
		                                			<td><%out.print(rs.getString("VEHICLENUMBER"));%></td>
		                                			<td><%	out.print(rs.getString("PARKDATE"));
		                                					out.print(" ");
		                                					out.print(rs.getString("FROMTIME"));%></td>
		                                			<td><%	out.print(rs.getString("PARKDATE"));
		                                					out.print(" ");
		                                					out.print(rs.getString("TOTIME"));%></td>
		                                			<td><%out.print(rs.getString("PRICE"));%></td>
		                                			
	                                			</tr>
	                                			
	                                			<%
	                                		}	
	                                		con.close();                                		
	                                		
	                                	}
	                                	catch(Exception e)
	                                	{
	                                		out.print(e);
	                                	}
	                                	
	                                    %>
                                        
                                    </tbody>
                                </table>
                            </div>
                            
                        </div>
                    </div>
                    <!--End Advanced Tables -->
                </div>                
    		<a class="btn btn-info pull-right btn-sm" href="http://localhost:8088/WePark/reports/bookingReport.jsp?report=employee" target="_blank">Generate Report</a>
    
            </div>
            
            
    	</div>   	
    	
    </div>
    
     <!-- CONTENT-WRAPPER SECTION END-->
    <section class="footer-section">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    &copy; 2020 WePark | One stop parking solutions
                </div>

            </div>
        </div>
    </section>
      <!-- FOOTER SECTION END-->
    <!-- JAVASCRIPT FILES PLACED AT THE BOTTOM TO REDUCE THE LOADING TIME  -->
    <!-- CORE JQUERY  -->
    <script src="assets/js/jquery-1.10.2.js"></script>
    <!-- BOOTSTRAP SCRIPTS  -->
    <script src="assets/js/bootstrap.js"></script>
    <!-- DATATABLE SCRIPTS  -->
    <script src="assets/js/dataTables/jquery.dataTables.js"></script>
    <script src="assets/js/dataTables/dataTables.bootstrap.js"></script>
      <!-- CUSTOM SCRIPTS  -->
    <script src="assets/js/custom.js"></script>
    </form>
</body>
</html>

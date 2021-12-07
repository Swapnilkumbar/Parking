<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>
<%@page import="com.org.wepark.*"%>
<!DOCTYPE html>

<%
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1 
response.setHeader("Pragma","no-cache"); //HTTP 1.0 
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server   
	

//////////////LOAD NAME FROM SESSION TO WEBSITE
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
	session.setAttribute("adminName", name);
	
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />

    <title>WePark Admin</title>
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <link href="assets/css/style.css" rel="stylesheet" />
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />
	<script src="https://code.jquery.com/jquery-2.2.4.js"></script>
	<script src="js/jquery-1.12.4-jquery.min.js" type="text/javascript"></script>
	
	
	<!-- CODE FOR AUTOCOMPLATE TO WORK -->
			<script type="text/javascript">
			        $(document).ready(function(){
			            $('#prkid').keyup(function(){
			                var search=$('#prkid').val();
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
			               $('#prkid').val($(this).text());
			               $("#showList").fadeOut(100);
			            });
			        	
			            
			        });
			</script>
			
			<script type="text/javascript">
			function enableTxtbx()
			{
			    if (document.getElementById("usertype").value == "employee") {
			        document.getElementById("prkid").disabled='';
			    } else {
			        document.getElementById("prkid").disabled='disabled';
			    }
			}
			</script>

</head>
<body>
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
                <label style="margin-right: 50px;">Welcome, <%out.print(name); %></label>
                 <a class="btn btn-info pull-right btn-sm " href="invalidateSessionUserHome.jsp">LOG OUT</a>
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
                        
                        	<li><a href="payments.jsp" >PAYMENTS TABLE</a></li>
                            <li><a href="usertable.jsp">USER TABLE</a></li>
                            <li><a href="bookingtable.jsp">BOOKING TABLE</a></li>
                            <li><a href="parkingtable.jsp">PARKING SLOT TABLE</a></li>                            
                            <li><a href="admininsertupdate.jsp" class="menu-top-active">CREATE</a></li>

                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </section>
     <!-- MENU SECTION END-->
    <div class="content-wrapper">
         <div class="container">
        <div class="row pad-botm">
            <div class="col-md-12">
                <h4 class="header-line">CREATE</h4>
                
                <!-- ------------------  Insert new USERS   --------------------- -->
                <section>
                
                	<h5 style="font-weight: bold;">Create Users</h5>
			    	<form action="admininsert.jsp" method="post">
				    	<input type="text" style="margin-right: 30px" placeholder="Name" name="username"  required="required">
				    	<input type="email" style="margin-right: 30px" placeholder="Email" name="mail" required="required">
				    	<input type="text" style="margin-right: 30px" placeholder="Password" name="password" required="required">
				    	<select name="usertype" id="usertype" style="width: 180px; height: 33px; margin-right: 30px" onchange="enableTxtbx();">
						  <option value="customer">customer</option>
						  <option value="admin">admin</option>
						  <option value="employee">employee</option>						  
						</select>
						<input type="text" style="margin-right: 30px" placeholder="Parking Lot ID" name="prkid" id="prkid" disabled="disabled"/>
							<div id="showList" style="position: absolute; z-index: 1000;margin-left: 800px;">
							                <ul class="list-group">
							                </ul>
							</div>
						
						
						<br>
						<br>
				    	<input type="submit" class="btn btn-primary" name="createuser" value="CREATE" style="width: 100px">
			    	</form>
			    	<%
			    		if(request.getParameter("createuser")!=null)
			    		{
							//////////////////// Create Random UID
			    			Random ran=new Random();
							int n=ran.nextInt((999999-100000)+1)+100000;
							String uid="WEPRKUSR"+Integer.toString(n);
			    			
							
			    			//////////////////Insert to DB
			    			String u_name=request.getParameter("username");
			    			String mail=request.getParameter("mail");
			    			String password=request.getParameter("password");
			    			String usertype=request.getParameter("usertype");
			    			String prklotid=request.getParameter("prkid");
			    						    			
			    			try
							{
			    				int success=0;

				    			if(usertype.equals("employee"))
				    			{
				    				PreparedStatement pstmt=con.prepareStatement("INSERT INTO WEPARKUSERS (USERID,NAME, EMAIL, PASSWORD, TYPE, PARKINGSLOTID) VALUES(?,?,?,?,?,?)");
				    			
				    				pstmt.setString(1, uid);
									pstmt.setString(2, u_name);
									pstmt.setString(3, mail);
									pstmt.setString(4, password);
									pstmt.setString(5, usertype);
									pstmt.setString(6, prklotid);
									
									success= pstmt.executeUpdate();
				    			}
				    			else
				    			{
				    				PreparedStatement pstmt=con.prepareStatement("INSERT INTO WEPARKUSERS (USERID,NAME, EMAIL, PASSWORD, TYPE,PARKINGSLOTID) VALUES(?,?,?,?,?,?)");
									
									pstmt.setString(1, uid);
									pstmt.setString(2, u_name);
									pstmt.setString(3, mail);
									pstmt.setString(4, password);
									pstmt.setString(5, usertype);
									pstmt.setString(6, "null");
									
									success= pstmt.executeUpdate();
				    			}
								
								if (success!=0)
								{
									//out.print("Signup Successfull!");
									out.println("<script type=\"text/javascript\">");
									out.println("alert('User Successfully Created!');");
									out.println("</script>");
									
								}
								else
								{
									out.println("<script type=\"text/javascript\">");
									out.println("alert('Error Creating User! Try again later!');");
									out.println("</script>");
								}
								
							}
							catch(Exception e)
							{
								out.print(e);
							}
			    		}
			    	%>	
			    	
			    </section>
			    
			    <!-- ------------------  Insert new Parking Spot   --------------------- -->
			    <br>
			    <br>
			    <br>
			    
                <section>
                
                	<h5 style="font-weight: bold;">Create Parking Spots</h5>
			    	<form action="admininsert.jsp" method="post">
				    	<input type="text" style="margin-right: 30px" placeholder="Name of Place" name="placename" required="required">
				    	<input type="text" style="margin-right: 30px" placeholder="Address" name="address" required="required">
				    	<input type="text" style="margin-right: 30px" placeholder="Phone Number" name="number" required="required">
				    	<input type="text" style="margin-right: 30px" placeholder="Slots Available" name="slots" required="required">
				    	<br>
				    	<br>
				    	<input type="text" style="margin-right: 30px" placeholder="Price per slot per hour" name="price" required="required">
				    	<input type="text" style="margin-right: 30px" placeholder="Google Map Link" name="map" required="required">
				    	
				    	<input type="submit" class="btn btn-primary" name="createparking" value="CREATE" style="width: 100px">
			    	</form>
			    	<%
			    		if(request.getParameter("createparking")!=null)
			    		{
			    			/////////////////PID generation
			    			Random ran=new Random();
							int n=ran.nextInt((999999-100000)+1)+100000;
							String pid="WEPRKPLCE"+Integer.toString(n);
			    			
			    			//////////Insert to DB
			    			
			    			String placename=request.getParameter("placename");
			    			String address=request.getParameter("address");
			    			String number=request.getParameter("number");
			    			String s_slots=request.getParameter("slots");
			    			String s_price=request.getParameter("price");
			    			String map=request.getParameter("map");
			    					    				
			    			
			    			try
							{
				    			int slots=Integer.parseInt(s_slots);
				    			int price=Integer.parseInt(s_price);			    				
			    				
								PreparedStatement pstmt=con.prepareStatement("INSERT INTO WEPARKPARKINGSLOTS (PARKINGSLOTID,PLACENAME, ADDRESS, PHONENO, AVAILABLESLOTS, PRICE, MAPS) VALUES(?,?,?,?,?,?,?)");
								
								pstmt.setString(1, pid);
								pstmt.setString(2, placename);
								pstmt.setString(3, address);
								pstmt.setString(4, number);
								pstmt.setInt(5, slots);
								pstmt.setInt(6, price);
								pstmt.setString(7, map);
								
								
								
								int success= pstmt.executeUpdate();
								
								if (success!=0)
								{
									//out.print("Signup Successfull!");
									out.println("<script type=\"text/javascript\">");
									out.println("alert('Parking Slot Successfully Created!');");
									out.println("</script>");
									
								}
								else
								{
									out.println("<script type=\"text/javascript\">");
									out.println("alert('Error Creating Parking Slot! Try again later!');");
									out.println("</script>");
								}
								
							}
							catch(Exception e)
							{
								out.print(e);
							}
			    		}
			    	%>	
			    	
			    </section>
                
            </div>

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
      <!-- CUSTOM SCRIPTS  -->
    <script src="assets/js/custom.js"></script>
</body>
</html>

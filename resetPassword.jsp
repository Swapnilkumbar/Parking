<%@page import="com.org.wepark.ConnectionManager"%>
<%@page import="java.util.Base64"%>
<%@page import="javax.crypto.SecretKey"%>
<%@page import="javax.crypto.spec.PBEKeySpec"%>
<%@page import="java.security.spec.KeySpec"%>
<%@page import="javax.crypto.SecretKeyFactory"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.security.MessageDigest"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<link rel="stylesheet" type="text/css" href="css/otp.css"> 
    <title>WePark Reset Password</title>
</head>
<body>

	<div class="container" id="container">
            
        <div class="form-container ">
            <form action="resetPassword.jsp">
                <h1>WePark Password Reset</h1>
                <p>Reset your forgotten password so that you can start using WePark again</p>                
                <input type="password" placeholder="Enter new password" name="password" required="required"/><br>
                <button name="submit">Reset</button>
            </form>
        </div>
        
    </div>
    
<%

String secureToken=request.getParameter("token");

ConnectionManager connectionManager=new ConnectionManager();
Connection con=connectionManager.connectDB();

String mail="";

try{
	mail=session.getAttribute("resetMail").toString();
}catch (Exception e){
	out.println("<script type=\"text/javascript\">");
	out.println("window.location.replace('http://localhost:8088/WePark/signUpLogin.html');");
	out.println("alert('No security Tokens found!');");
	out.println("</script>");
}


if (request.getParameter("submit")!=null)
{

	String pass=request.getParameter("password");

	PreparedStatement pstmt=con.prepareStatement("Update WEPARKUSERS set PASSWORD=? where EMAIL=?");
	
	pstmt.setString(1, pass);
	pstmt.setString(2, mail);
	
	int success= pstmt.executeUpdate();
	
	if(success!=0){
		session.invalidate();
		
		out.println("<script type=\"text/javascript\">");
		out.println("alert('Password successfully updated!Login with new credentials');");
		out.println("window.location.replace('http://localhost:8088/WePark/signUpLogin.html');");
		out.println("</script>");
	
	}else{
		out.println("Some Internal Eror. Try Again");
	}

	
}

%>

</body>
</html>
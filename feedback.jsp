<%@page import="com.sun.xml.internal.ws.wsdl.writer.document.Service"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="com.org.wepark.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/otp.css"> 
  <style type="text/css">
        textarea {
		   resize: none;
		   width: 100%;
		   height: 150px;
		   border: 1px solid #d5d5d5;
		}
        </style>
        
</head>
<body>
<div class="container" id="container">
            
            <div class="form-container ">
                <form action="feedback.jsp">
                    <h1>Feedback</h1>
                    <p>Hello <%out.print(request.getParameter("email"));%>, we have found that you have used out Service. Please enter your feedback in the area provided below.</p>                
                    <textarea placeholder="Enter your feedback" name="feedback" required="required"/></textarea><br>
                    <button name="submit">Submit</button>
                </form>
            </div>
            
        </div>
<%
if(request.getParameter("submit")!=null)
{
	
	String content=request.getParameter("feedback");
	CustomMail customMail=new CustomMail();
	int res=customMail.sendMail("16cs1k354@gmail.com", "Feedback from customer : "+request.getParameter("email"), content);
	if(res!=0){
		out.print("<script>alert('Thank You for your feedback! Do choose us again!');location='http://localhost:8088/WePark/home.jsp';</script>");
	}else{
		out.print("<script>alert('Please try again!');</script>");
	}
}

%>

</body>
</html>
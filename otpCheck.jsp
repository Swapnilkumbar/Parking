<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%

Object session_otp=session.getAttribute("otp");
String otp=session_otp.toString();

//out.print(otp);

String user_otp=request.getParameter("otp");

if(user_otp.equals(otp))
{
	session.removeAttribute("otp");
	response.sendRedirect("signup.jsp");
}
else
{
	out.println("<script type=\"text/javascript\">");
	out.println("alert('Incorrect OTP! Try again');");
	out.println("location='http://localhost:8088/WePark/otp.html';");
	out.println("</script>");
}

%>
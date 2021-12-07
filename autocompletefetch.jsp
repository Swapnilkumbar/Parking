<%@page import="com.org.wepark.ConnectionManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>

<%
    if(request.getParameter("key")!=null) //get "key" variable from jquery & ajax  part this line "data:'key='+search" and check not null 
    {
        String key=request.getParameter("key"); //get "key" variable store in created new "key" variable
        String wild="%" +key+ "%"; //remove "%" for use preparedstatement in query name like, and "key" variable store in "wild" variable for further use
        
        ConnectionManager connectionManager=new ConnectionManager();
        Connection con=connectionManager.connectDB();

        try
        {

            PreparedStatement pstmt=null; //create statement

            pstmt=con.prepareStatement("SELECT PARKINGSLOTID FROM WEPARKPARKINGSLOTS WHERE PARKINGSLOTID LIKE ? "); //sql select query
            pstmt.setString(1,wild); //above created "wild" variable set in this
            ResultSet rs=pstmt.executeQuery(); //execute query and set in ResultSet object "rs".
           
            while(rs.next())
            {
                %>
                    <li class="list-group-item"><%=rs.getString("PARKINGSLOTID")%></li>
                <%
            }
                con.close(); //close connection
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
%>
 
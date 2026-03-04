<%-- 
    Document   : login
    Created on : Feb 25, 2026, 2:29:02 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        <h1>Login Page</h1>
        <%
            String alertLogout = (String)request.getAttribute("MSG_LOGOUT");// chuỗi này lấy request MSG_LOGOUT để in ra thông báo
            if(alertLogout != null){
        %>
        <h4><%= alertLogout %></h4>
        <%}%>
        
        <form action="MenuController" method="post">
            <p>UserID: <input type="text" name="userID"></p>
            <p>Password: <input type="password" name="pass"></p>
            <%
                String msg = (String) request.getAttribute("MSG");
                if(msg != null){
                
             %>
            <p style="color: red"><%= msg%></p>
             <%}%>
             <button type="submit" name="action" value="Login">Login</button>
        </form>
        
    </body>
    
</html>

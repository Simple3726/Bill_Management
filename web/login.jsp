<%-- 
    Document   : login
    Created on : Aug 7, 2024, 8:13:05 AM
    Author     : Sheep
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Login Page</h1>
        <%
            String alertLogout = (String) request.getAttribute("MSG_LOGOUT");
            if (alertLogout != null) {
        %>
        <h4><%= alertLogout %></h4>
        <% }
        %>
        <form action="MainController" method="POST">
            <p> UserID: <input type="text" name="userID"> </p>
            <p> Password: <input type="password" name="pass"> </p>
                <%
                    String msg = (String) request.getAttribute("MSG");
                    if (msg != null) {
                %>
            <p style="color: red"><%= msg%></p>
            <% }
            %> 
            <button type="submit" name="action" value="Login">Login</button>
        </form>

    </body>
</html>

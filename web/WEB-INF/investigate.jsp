<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Alert" %>

<%
    Alert alert = (Alert) request.getAttribute("alert");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Investigate Alert</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>

    <body class="p-5">

        <h2 class="mb-4">Investigate Alert</h2>

        <div class="card p-4">

            <p><b>Alert ID:</b> <%=alert.getAlertId()%></p>

            <p><b>Entity Type:</b> <%=alert.getEntityType()%></p>

            <p><b>Entity ID:</b> <%=alert.getEntityId()%></p>

            <p><b>Risk Score:</b> <%=alert.getRiskScore()%></p>

            <p><b>Status:</b> <%=alert.getStatus()%></p>
            
            <p><b>Reason:</b><%=alert.getMessage()%></p>

            <p><b>Created At:</b> <%=alert.getCreatedAt()%></p>

            <hr>

            <form action="<%=request.getContextPath()%>/AlertController" method="post">

                <input type="hidden" name="action" value="resolve">
                <input type="hidden" name="alertId" value="<%=alert.getAlertId()%>">

                <button class="btn btn-success">
                    Resolve Alert
                </button>

                <a href="<%=request.getContextPath()%>/AlertController" class="btn btn-secondary">
                    Back
                </a>

            </form>

        </div>

    </body>
</html>
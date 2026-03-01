<%-- 
    Document   : alert_list
    Created on : Feb 25, 2026, 2:29:43 PM
    Author     : admin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Alert" %>


<%
    List<Alert> alertList = (List<Alert>) request.getAttribute("alertList");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Alert Management</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 30px;
            }

            .container {
                max-width: 1100px;
                margin: auto;
            }

            .card {
                background: white;
                border-radius: 14px;
                padding: 25px 30px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.05);
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .card-header h2 {
                color: #1f6feb;
                margin: 0;
                font-weight: 600;
            }

            .badge {
                padding: 6px 14px;
                border-radius: 50px;
                font-size: 13px;
                font-weight: 500;
            }

            .badge-new {
                background-color: #ffecec;
                color: #d93025;
            }

            .badge-investigating {
                background-color: #fff4e5;
                color: #f9a825;
            }

            .badge-resolved {
                background-color: #e6f4ea;
                color: #188038;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th {
                text-align: left;
                font-weight: 500;
                padding: 14px;
                background-color: #f8f9fa;
                color: #555;
            }

            td {
                padding: 14px;
                border-top: 1px solid #eee;
                font-size: 14px;
            }

            tr:hover {
                background-color: #f9fbff;
            }

            .btn {
                padding: 6px 14px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
            }

            .btn-investigate {
                background-color: #fbbc04;
                color: white;
            }

            .btn-resolve {
                background-color: #1f6feb;
                color: white;
            }

            .btn:hover {
                opacity: 0.85;
            }

        </style>
    </head>

    <body>

        <div class="container">
            <div class="card">

                <div class="card-header">
                    <h2>🚨 Alert List</h2>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Entity Type</th>
                            <th>Entity ID</th>
                            <th>Risk Score</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            if (alertList != null && !alertList.isEmpty()) {
                                for (Alert alert : alertList) {
                        %>
                        <tr>
                            <td><%= alert.getAlertId()%></td>
                            <td><%= alert.getEntityType()%></td>
                            <td><%= alert.getEntityId()%></td>
                            <td><strong><%= alert.getRiskScore()%></strong></td>

                            <td>
                                <%
                                    String status = alert.getStatus();
                                    if ("NEW".equals(status)) {
                                %>
                                <span class="badge badge-new">NEW</span>
                                <%
                                } else if ("INVESTIGATING".equals(status)) {
                                %>
                                <span class="badge badge-investigating">INVESTIGATING</span>
                                <%
                                } else {
                                %>
                                <span class="badge badge-resolved">RESOLVED</span>
                                <%
                                    }
                                %>
                            </td>

                            <td><%= alert.getCreatedAt()%></td>

                            <td>
                                <% if ("NEW".equals(alert.getStatus())) {%>
                                <form action="alert" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="investigate">
                                    <input type="hidden" name="alertId" value="<%= alert.getAlertId()%>">
                                    <button class="btn btn-investigate">Investigate</button>
                                </form>
                                <% } else if ("INVESTIGATING".equals(alert.getStatus())) {%>
                                <form action="alert" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="resolve">
                                    <input type="hidden" name="alertId" value="<%= alert.getAlertId()%>">
                                    <button class="btn btn-resolve">Resolve</button>
                                </form>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align:center; padding:20px;">
                                No alerts available.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

            </div>
        </div>

    </body>
</html>

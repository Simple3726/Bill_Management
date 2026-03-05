<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>

<%
    List<User> userList = (List<User>) request.getAttribute("userList");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>User Management</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <style>

            body{
                font-family:'Inter',sans-serif;
                background:#f4f6f9;
                padding:30px;
            }

            .container{
                max-width:1100px;
                margin:auto;
            }

            .card{
                background:white;
                border-radius:14px;
                padding:25px 30px;
                box-shadow:0 8px 25px rgba(0,0,0,0.05);
            }

            .card-header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }

            .card-header h2{
                margin:0;
                color:#1f6feb;
            }

            .btn{
                padding:8px 16px;
                border:none;
                border-radius:8px;
                cursor:pointer;
                font-size:14px;
            }

            .btn-add{
                background:#1f6feb;
                color:white;
            }

            .btn-edit{
                background:#fbbc04;
                color:white;
            }

            .btn-delete{
                background:#d93025;
                color:white;
            }

            .badge{
                padding:6px 12px;
                border-radius:50px;
                font-size:12px;
            }

            .badge-admin{
                background:#e8f0fe;
                color:#1f6feb;
            }

            .badge-staff{
                background:#e6f4ea;
                color:#188038;
            }

            .badge-auditor{
                background:#fff4e5;
                color:#f9a825;
            }

            .badge-active{
                background:#e6f4ea;
                color:#188038;
            }

            .badge-locked{
                background:#ffecec;
                color:#d93025;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            th{
                text-align:left;
                padding:12px;
                background:#f8f9fa;
            }

            td{
                padding:12px;
                border-top:1px solid #eee;
            }

            tr:hover{
                background:#f9fbff;
            }

        </style>
    </head>

    <body>

        <div class="container">

            <div class="card">

                <div class="card-header">
                    <h2>User Management</h2>

                    <a href="<%=request.getContextPath()%>/UserController/CreateForm">
                        <button class="btn btn-add">+ Create User</button>
                    </a>

                </div>

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>

                        <%
                            if (userList != null) {
                                for (User u : userList) {
                        %>

                        <tr>

                            <td><%=u.getUserId()%></td>
                            <td><%=u.getUsername()%></td>

                            <td>
                                <%
                                    if ("ADMIN".equals(u.getRole())) {
                                %>
                                <span class="badge badge-admin">ADMIN</span>
                                <%
                                } else if ("AUDITOR".equals(u.getRole())) {
                                %>
                                <span class="badge badge-auditor">AUDITOR</span>
                                <%
                                } else {
                                %>
                                <span class="badge badge-staff">STAFF</span>
                                <%
                                    }
                                %>
                            </td>

                            <td>
                                <%
                                    if ("ACTIVE".equals(u.getStatus())) {
                                %>
                                <span class="badge badge-active">ACTIVE</span>
                                <%
                                } else {
                                %>
                                <span class="badge badge-locked">LOCKED</span>
                                <%
                                    }
                                %>
                            </td>

                            <td><%=u.getCreatedAt()%></td>

                            <td>

                                <a href="<%=request.getContextPath()%>/UserController/EditForm?id=<%=u.getUserId()%>">
                                    <button class="btn btn-edit">Edit</button>
                                </a>

                                <a href="<%=request.getContextPath()%>/UserController/Delete?id=<%=u.getUserId()%>">
                                    <button class="btn btn-delete">Delete</button>
                                </a>

                            </td>

                        </tr>

                        <%
                                }
                            }
                        %>

                    </tbody>

                </table>

            </div>
        </div>

    </body>
</html>
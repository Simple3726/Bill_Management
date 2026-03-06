<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.User" %>

<%
    User user = (User) request.getAttribute("user");
    boolean isEdit = user != null;
%>

<!DOCTYPE html>
<html>
    <head>

        <title>User Form</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <style>

            body{
                font-family:'Inter',sans-serif;
                background:#f4f6f9;
                padding:30px;
            }

            .container{
                max-width:600px;
                margin:auto;
            }

            .card{
                background:white;
                border-radius:14px;
                padding:30px;
                box-shadow:0 8px 25px rgba(0,0,0,0.05);
            }

            h2{
                margin-bottom:20px;
                color:#1f6feb;
            }

            input,select{
                width:100%;
                padding:10px;
                margin-bottom:15px;
                border-radius:8px;
                border:1px solid #ddd;
            }

            .btn{
                padding:10px 18px;
                border:none;
                border-radius:8px;
                cursor:pointer;
            }

            .btn-save{
                background:#1f6feb;
                color:white;
            }

        </style>

    </head>

    <body>

        <div class="container">

            <div class="card">

                <h2><%=isEdit ? "Edit User" : "Create User"%></h2>

                <form action="<%=request.getContextPath()%>/UserController/<%=isEdit ? "Update" : "Create"%>" method="post">

                    <% if (isEdit) {%>
                    <input type="hidden" name="id" value="<%=user.getUserId()%>">
                    <% }%>

                    <label>Username</label>
                    <input type="text" name="username"
                           value="<%=isEdit ? user.getUsername() : ""%>" required>

                    <% if (!isEdit) { %>

                    <label>Password</label>
                    <input type="password" name="password" required>

                    <% }%>

                    <label>Role</label>

                    <select name="role">

                        <option value="STAFF">STAFF</option>

                        <option value="AUDITOR"
                                <%=isEdit && "AUDITOR".equals(user.getRole()) ? "selected" : ""%>>
                            AUDITOR
                        </option>

                        <option value="ADMIN"
                                <%=isEdit && "ADMIN".equals(user.getRole()) ? "selected" : ""%>>
                            ADMIN
                        </option>

                    </select>

                    <label>Status</label>

                    <select name="status">

                        <option value="ACTIVE">ACTIVE</option>

                        <option value="LOCKED"
                                <%=isEdit && "LOCKED".equals(user.getStatus()) ? "selected" : ""%>>
                            LOCKED
                        </option>

                    </select>

                    <button class="btn btn-save">Save</button>

                </form>

            </div>
        </div>

    </body>
</html>
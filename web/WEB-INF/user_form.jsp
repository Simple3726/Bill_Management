<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.User" %>


<%
    User user = (User) request.getAttribute("user");
    String mode = (String) request.getAttribute("mode");
    boolean isEdit = "edit".equals(mode);
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
                box-sizing: border-box; /* Giúp input không bị tràn ra ngoài form */
            }

            /* --- CỤM CSS CHO NÚT BẤM --- */
            .action-buttons {
                display: flex;
                gap: 12px; /* Khoảng cách giữa 2 nút */
                margin-top: 10px;
                padding-left: 350px;
            }

            .btn{
                padding:10px 18px;
                border:none;
                border-radius:8px;
                cursor:pointer;
                font-size: 15px;
                font-weight: 500;
                text-decoration: none; /* Bỏ gạch chân nếu dùng thẻ <a> */
                text-align: center;
            }

            .btn-save{
                background:#1f6feb;
                color:white;
            }
            .btn-save:hover {
                background: #155bc2;
            }

            /* Thiết kế nút Hủy bỏ */
            .btn-cancel {
                background: #e4e6eb;
                color: #333;
            }
            .btn-cancel:hover {
                background: #d0d2d6;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="card">
                <h2><%=isEdit ? "Edit User" : "Create User"%></h2>
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div style="color:red; margin-bottom:15px;">
                    <%= error%>
                </div>
                <% }%>
                <form action="<%=request.getContextPath()%>/UserController/<%=isEdit ? "Update" : "Create"%>" method="post">

                    <% if (isEdit) {%>
                    <input type="hidden" name="id" value="<%=user.getUserId()%>">
                    <% }%>

                    <label>Username</label>
                    <input type="text" name="username" value="<%=isEdit ? user.getUsername() : ""%>" required>

                    <% if (!isEdit) { %>
                    <label>Password</label>
                    <input type="password" name="password" minlength = 4 required>
                    <% }%>

                    <label>Role</label>
                    <select name="role">
                        <option value="STAFF">STAFF</option>
                        <option value="AUDITOR" <%=isEdit && "AUDITOR".equals(user.getRole()) ? "selected" : ""%>>AUDITOR</option>
                        <option value="ADMIN" <%=isEdit && "ADMIN".equals(user.getRole()) ? "selected" : ""%>>ADMIN</option>
                    </select>

                    <label>Status</label>
                    <select name="status">
                        <option value="ACTIVE" <%=isEdit && "ACTIVE".equals(user.getStatus()) ? "selected" : ""%>>ACTIVE</option>
                        <option value="LOCKED" <%=isEdit && "LOCKED".equals(user.getStatus()) ? "selected" : ""%>>LOCKED</option>
                        <option value="OFFLINE" <%=isEdit && "OFFLINE".equals(user.getStatus()) ? "selected" : ""%>>OFFLINE</option>
                    </select>

                    <div class="action-buttons">
                        <a href="<%=request.getContextPath()%>/UserController/List" class="btn btn-cancel">Cancel</a>

                        <button type="submit" class="btn btn-save">Save</button>
                    </div>

                </form>
            </div>

        </div>
    </body>
</html>

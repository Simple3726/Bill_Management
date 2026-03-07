<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<% List<User> userList = (List<User>) request.getAttribute("userList"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body, html { height: 100%; margin: 0; font-family: 'Inter', sans-serif; background-color: #f4f6f9; overflow-x: hidden; }
        
        /* SIDEBAR STYLES */
        .sidebar { width: 260px; background-color: #212529; color: white; min-height: 100vh; position: sticky; top: 0; transition: all 0.3s ease-in-out; z-index: 1000; }
        .sidebar.collapsed { margin-left: -260px; }
        .sidebar-link { color: rgba(255, 255, 255, 0.8); text-decoration: none; padding: 10px 15px; border-radius: 6px; display: block; transition: 0.3s; white-space: nowrap; }
        .sidebar-link:hover, .sidebar-link.active { background-color: #0d6efd; color: white; }
        .user-avatar { width: 60px; height: 60px; background-color: #495057; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 10px auto; color: white; }
        #sidebarToggle { background: none; border: none; color: #212529; font-size: 24px; cursor: pointer; padding: 0 15px 0 0; transition: color 0.2s; }
        #sidebarToggle:hover { color: #0d6efd; }
        .main-content { transition: all 0.3s ease-in-out; width: 100%; }

        .btn-add { background-color: #1f6feb; color: white; padding: 10px 20px; border-radius: 8px; font-weight: 500; transition: 0.2s; border: none; }
        .btn-add:hover { background-color: #155bc2; color: white; }
        .action-btn { padding: 6px 12px; border-radius: 6px; font-size: 13px; font-weight: 500; border: none; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-edit { background-color: #fbbc04; color: white; }
        .btn-edit:hover { background-color: #e3a903; color: white; }
        .btn-delete { background-color: #d93025; color: white; }
        .btn-delete:hover { background-color: #c02a20; color: white; }
        .custom-badge { padding: 6px 12px; border-radius: 50px; font-size: 12px; font-weight: 600; display: inline-block; }
        .badge-admin { background-color: #e8f0fe; color: #1f6feb; }
        .badge-staff { background-color: #e6f4ea; color: #188038; }
        .badge-auditor { background-color: #fff4e5; color: #f9a825; }
        .badge-active { background-color: #e6f4ea; color: #188038; }
        .badge-locked { background-color: #ffecec; color: #d93025; }
    </style>
</head>
<body>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/sidebar.jsp" />

    <div class="flex-grow-1 p-4 main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center">
                <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
                <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-users me-2"></i>User Management</h2>
            </div>
            <a href="<%=request.getContextPath()%>/UserController/Add" class="text-decoration-none">
                <button class="btn btn-add shadow-sm"><i class="fa-solid fa-user-plus me-1"></i> Create User</button>
            </a>
        </div>

        <div class="card shadow border-0 rounded-4">
            <div class="card-body p-0 table-responsive">
                <table class="table table-hover align-middle mb-0 text-nowrap">
                    <thead class="table-dark">
                        <tr><th class="ps-4 py-3">ID</th><th>Username</th><th>Role</th><th>Status</th><th>Created At</th><th class="text-center pe-4">Action</th></tr>
                    </thead>
                    <tbody>
                        <% if (userList != null && !userList.isEmpty()) { for (User u : userList) { %>
                        <tr>
                            <td class="ps-4 text-muted fw-bold">#<%=u.getUserId()%></td>
                            <td><div class="d-flex align-items-center"><div class="bg-light rounded-circle d-flex justify-content-center align-items-center me-3" style="width: 35px; height: 35px;"><i class="fa-solid fa-user text-secondary"></i></div><strong><%=u.getUsername()%></strong></div></td>
                            <td>
                                <% if ("ADMIN".equals(u.getRole())) { %><span class="custom-badge badge-admin"><i class="fa-solid fa-crown me-1"></i>ADMIN</span>
                                <% } else if ("AUDITOR".equals(u.getRole())) { %><span class="custom-badge badge-auditor"><i class="fa-solid fa-eye me-1"></i>AUDITOR</span>
                                <% } else { %><span class="custom-badge badge-staff"><i class="fa-solid fa-user-pen me-1"></i>STAFF</span><% } %>
                            </td>
                            <td>
                                <% if ("ACTIVE".equals(u.getStatus())) { %><span class="custom-badge badge-active"><i class="fa-solid fa-check-circle me-1"></i>ACTIVE</span>
                                <% } else { %><span class="custom-badge badge-locked"><i class="fa-solid fa-lock me-1"></i>LOCKED</span><% } %>
                            </td>
                            <td class="text-muted"><%=u.getCreatedAt()%></td>
                            <td class="text-center pe-4">
                                <a href="<%=request.getContextPath()%>/UserController/Edit?id=<%=u.getUserId()%>" class="action-btn btn-edit me-1"><i class="fa-solid fa-pen"></i> Edit</a>
                                <a href="<%=request.getContextPath()%>/UserController/Delete?id=<%=u.getUserId()%>" class="action-btn btn-delete" onclick="return confirm('⚠️ Warning: Are you sure you want to delete this account <%=u.getUsername()%> ? This action cannot be undone!');"><i class="fa-solid fa-trash"></i> Delete</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-5"><i class="fa-solid fa-users-slash mb-3" style="font-size: 40px; color: #dee2e6;"></i><br><h5>No Data</h5><p class="mb-0">No users have been created in the system yet.</p></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const toggleBtn = document.getElementById("sidebarToggle");
        const sidebar = document.getElementById("sidebar");
        toggleBtn.addEventListener("click", function() { sidebar.classList.toggle("collapsed"); });
    });
</script>
</body>
</html>
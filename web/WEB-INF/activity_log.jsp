<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.ActivityLog" %>
<%@ page import="entity.User" %>
<%
    List<ActivityLog> logList = (List<ActivityLog>) request.getAttribute("logList");
    Long shiftId = (Long) request.getAttribute("currentShiftId");
    
    User currentUser = (User) session.getAttribute("user");
    String role = (currentUser != null) ? currentUser.getRole() : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nhật Ký Hoạt Động - BillManager</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body, html { height: 100%; margin: 0; font-family: 'Inter', sans-serif; background-color: #f4f6f9; overflow-x: hidden; }
        
        /* === SIDEBAR STYLES === */
        .sidebar { width: 260px; background-color: #212529; color: white; min-height: 100vh; position: sticky; top: 0; transition: all 0.3s ease-in-out; z-index: 1000; }
        .sidebar.collapsed { margin-left: -260px; }
        .sidebar-link { color: rgba(255, 255, 255, 0.8); text-decoration: none; padding: 10px 15px; border-radius: 6px; display: block; transition: 0.3s; white-space: nowrap; }
        .sidebar-link:hover, .sidebar-link.active { background-color: #0d6efd; color: white; }
        .user-avatar { width: 60px; height: 60px; background-color: #495057; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 10px auto; color: white; }
        #sidebarToggle { background: none; border: none; color: #212529; font-size: 24px; cursor: pointer; padding: 0 15px 0 0; transition: color 0.2s; }
        #sidebarToggle:hover { color: #0d6efd; }
        
        .main-content { transition: all 0.3s ease-in-out; width: 100%; padding: 30px; }
        
        .badge-action { padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; display: inline-block; }
        .action-open { background-color: #e6f4ea; color: #188038; border: 1px solid #188038; }
        .action-close { background-color: #ffecec; color: #d93025; border: 1px solid #d93025; }
        .action-create { background-color: #e8f0fe; color: #1f6feb; border: 1px solid #1f6feb; }
        .action-default { background-color: #f1f3f4; color: #5f6368; border: 1px solid #5f6368; }
    </style>
</head>
<body>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/sidebar.jsp" />

    <div class="flex-grow-1 main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center">
                <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
                <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-clipboard-list me-2"></i>Nhật Ký Hoạt Động (Ca #<%= shiftId %>)</h2>
            </div>
            <a href="<%=request.getContextPath()%>/ShiftController?action=list" class="btn btn-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Danh sách Ca
            </a>
        </div>

        <div class="card shadow border-0 rounded-4">
            <div class="card-body p-0 table-responsive">
                <table class="table table-hover align-middle mb-0 text-nowrap">
                    <thead class="table-dark">
                        <tr>
                            <th class="ps-4 py-3">Log ID</th>
                            <th>Thời Gian (Time)</th>
                            <th>User ID</th>
                            <th>Hành Động (Action)</th>
                            <th>Đối Tượng (Entity)</th>
                            <th>Entity ID</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (logList != null && !logList.isEmpty()) { 
                            for (ActivityLog log : logList) { 
                                String badgeClass = "action-default";
                                String actionStr = log.getActionType();
                                if(actionStr.contains("OPEN")) badgeClass = "action-open";
                                else if(actionStr.contains("CLOSE") || actionStr.contains("DELETE")) badgeClass = "action-close";
                                else if(actionStr.contains("CREATE") || actionStr.contains("INSERT")) badgeClass = "action-create";
                        %>
                        <tr>
                            <td class="ps-4 text-muted">#<%= log.getLogId() %></td>
                            <td class="fw-medium"><i class="fa-regular fa-clock me-1 text-secondary"></i> <%= log.getCreatedAt() %></td>
                            <td><strong><i class="fa-solid fa-user me-1 text-secondary"></i> <%= log.getUserId() %></strong></td>
                            <td><span class="badge-action <%= badgeClass %>"><%= log.getActionType() %></span></td>
                            <td><%= (log.getEntityType() != null) ? log.getEntityType() : "N/A" %></td>
                            <td><%= (log.getEntityId() != null) ? "#" + log.getEntityId() : "-" %></td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-5">
                                <i class="fa-solid fa-box-open mb-3" style="font-size: 40px; color: #dee2e6;"></i><br>
                                <h5>Chưa có hoạt động nào</h5>
                                <p class="mb-0">Ca làm việc này chưa có sự kiện nào được ghi nhận.</p>
                            </td>
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

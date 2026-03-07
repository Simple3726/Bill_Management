<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Alert" %>

<% List<Alert> alertList = (List<Alert>) request.getAttribute("alertList"); %>
<!DOCTYPE html>
<html>
<head>
    <title>Alert Management</title>
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
        .glow-online { color: #198754; text-shadow: 0 0 5px #198754, 0 0 10px #198754; }
        #sidebarToggle { background: none; border: none; color: #212529; font-size: 24px; cursor: pointer; padding: 0 15px 0 0; transition: color 0.2s; }
        #sidebarToggle:hover { color: #0d6efd; }
        .main-content { transition: all 0.3s ease-in-out; width: 100%; }

        .custom-badge { padding: 6px 14px; border-radius: 50px; font-size: 13px; font-weight: 600; display: inline-block; }
        .badge-new { background-color: #ffecec; color: #d93025; }
        .badge-investigating { background-color: #fff4e5; color: #f9a825; }
        .badge-resolved { background-color: #e6f4ea; color: #188038; }
        .action-btn { padding: 6px 14px; border-radius: 8px; border: none; cursor: pointer; font-size: 13px; font-weight: 500; transition: opacity 0.2s; }
        .btn-investigate { background-color: #fbbc04; color: white; }
        .btn-resolve { background-color: #1f6feb; color: white; }
        .btn-approve { background-color: #2ea44f; color: white; margin-left: 5px;}
        .action-btn:hover { opacity: 0.85; }
    </style>
</head>
<body>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/sidebar.jsp" />

    <div class="flex-grow-1 p-4 main-content">
        <div class="d-flex align-items-center mb-4">
            <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
            <h2 class="text-danger mb-0 fw-bold"><i class="fa-solid fa-triangle-exclamation me-2"></i>Alert List</h2>
        </div>

        <div class="card shadow border-0 rounded-4">
            <div class="card-body p-0 table-responsive">
                <table class="table table-hover align-middle mb-0 text-nowrap">
                    <thead class="table-dark">
                        <tr>
                            <th class="ps-4 py-3">ID</th><th>Entity Type</th><th>Entity ID</th><th>Risk Score</th><th>Status</th><th>Created At</th><th class="pe-4">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (alertList != null && !alertList.isEmpty()) { for (Alert alert : alertList) { %>
                        <tr>
                            <td class="ps-4 text-muted">#<%= alert.getAlertId()%></td>
                            <td><span class="badge bg-secondary"><%= alert.getEntityType()%></span></td>
                            <td class="fw-bold"><%= alert.getEntityId()%></td>
                            <td class="text-danger fw-bold"><%= alert.getRiskScore()%></td>
                            <td>
                                <% String status = alert.getStatus(); if ("NEW".equals(status)) { %>
                                    <span class="custom-badge badge-new"><i class="fa-solid fa-circle-exclamation me-1"></i>NEW</span>
                                <% } else if ("INVESTIGATING".equals(status)) { %>
                                    <span class="custom-badge badge-investigating"><i class="fa-solid fa-magnifying-glass me-1"></i>INVESTIGATING</span>
                                <% } else { %>
                                    <span class="custom-badge badge-resolved"><i class="fa-solid fa-check-circle me-1"></i>RESOLVED</span>
                                <% } %>
                            </td>
                            <td><%= alert.getCreatedAt()%></td>
                            <td class="pe-4">
                                <% if ("NEW".equals(alert.getStatus())) {%>
                                    <form action="AlertController" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="investigate"><input type="hidden" name="alertId" value="<%= alert.getAlertId()%>">
                                        <button class="action-btn btn-investigate"><i class="fa-solid fa-magnifying-glass"></i> Investigate</button>
                                    </form>
                                <% } else if ("INVESTIGATING".equals(alert.getStatus())) {%>
                                    <form action="AlertController" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="resolve"><input type="hidden" name="alertId" value="<%= alert.getAlertId()%>">
                                        <button class="action-btn btn-resolve"><i class="fa-solid fa-check"></i> Resolve</button>
                                    </form>
                                    <% if ("INVOICE".equals(alert.getEntityType())) {%>
                                    <form action="<%=request.getContextPath()%>/InvoiceController/Approve" method="post" style="display:inline;">
                                        <input type="hidden" name="invoiceId" value="<%= alert.getEntityId()%>">
                                        <button class="action-btn btn-approve"><i class="fa-solid fa-thumbs-up"></i> Approve</button>
                                    </form>
                                    <% } %>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">
                                <i class="fa-solid fa-shield-check mb-3" style="font-size: 40px; color: #2ea44f;"></i><br>
                                <h5>Hệ thống an toàn</h5><p class="mb-0">Không có cảnh báo (Alert) nào cần xử lý.</p>
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

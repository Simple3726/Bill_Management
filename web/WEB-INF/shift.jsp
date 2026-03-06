<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Ca làm việc - BillManager</title>
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

        .shift-card { max-width: 500px; margin: 40px auto; background: white; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); padding: 40px 30px; }
        .status-badge { display: inline-block; padding: 10px 20px; border-radius: 50px; font-weight: 600; font-size: 1.1rem; margin-bottom: 20px; }
        .badge-active { background-color: #e6f4ea; color: #188038; }
        .badge-inactive { background-color: #ffecec; color: #d93025; }
        .btn-shift { padding: 12px; font-weight: 600; font-size: 16px; border-radius: 8px; transition: 0.3s; }
        .btn-open { background-color: #198754; color: white; border: none; }
        .btn-open:hover { background-color: #146c43; color: white; transform: translateY(-2px); }
        .btn-close-shift { background-color: #d93025; color: white; border: none; }
        .btn-close-shift:hover { background-color: #b02a20; color: white; transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/sidebar.jsp" />

    <div class="flex-grow-1 p-4 main-content">
        <div class="d-flex align-items-center mb-4">
            <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
            <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-clock me-2"></i>Quản lý Ca làm việc</h2>
        </div>

        <div class="shift-card text-center">
            <h3 class="fw-bold mb-4 text-dark">Shift Status</h3>

            <%
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
                Boolean isShiftOpenObj = (Boolean) request.getAttribute("isShiftOpen");
                boolean isShiftOpen = (isShiftOpenObj != null) ? isShiftOpenObj : false;

                if (message != null && !message.trim().isEmpty()) {
            %>
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i><div><%= message %></div>
                </div>
            <% session.removeAttribute("message"); } %>

            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i><div><%= error %></div>
                </div>
            <% session.removeAttribute("error"); } %>

            <div class="mb-4">
                <p class="text-muted mb-2 fw-medium">Trạng thái hiện tại của bạn:</p>
                <% if (isShiftOpen) { %>
                    <div class="status-badge badge-active shadow-sm"><i class="fa-solid fa-spinner fa-spin me-2"></i>ĐANG TRONG CA</div>
                <% } else { %>
                    <div class="status-badge badge-inactive shadow-sm"><i class="fa-solid fa-power-off me-2"></i>CHƯA MỞ CA</div>
                <% } %>
            </div>

            <form action="<%= request.getContextPath() %>/ShiftController" method="POST">
                <% if (isShiftOpen) { %>
                    <input type="hidden" name="action" value="close">
                    <button type="submit" class="btn btn-close-shift btn-shift w-100 shadow-sm" onclick="return confirm('Bạn có chắc chắn muốn đóng ca làm việc này? Mọi hóa đơn đang làm dở cần được lưu lại!');">
                        <i class="fa-solid fa-lock me-2"></i> Đóng Ca Làm Việc
                    </button>
                <% } else { %>
                    <input type="hidden" name="action" value="open">
                    <button type="submit" class="btn btn-open btn-shift w-100 shadow-sm">
                        <i class="fa-solid fa-unlock-keyhole me-2"></i> Bắt Đầu Mở Ca
                    </button>
                <% } %>
            </form>
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
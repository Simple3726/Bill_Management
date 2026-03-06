<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Shift" %>
<% List<Shift> shiftList = (List<Shift>) request.getAttribute("shiftList"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Ca - BillManager</title>
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

        .custom-badge { padding: 6px 12px; border-radius: 50px; font-size: 12px; font-weight: 600; display: inline-block; }
        .badge-open { background-color: #e6f4ea; color: #188038; }
        .badge-closed { background-color: #f1f3f4; color: #5f6368; }
        .action-btn { padding: 6px 12px; border-radius: 6px; font-size: 13px; font-weight: 500; border: none; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-log { background-color: #0dcaf0; color: #000; }
        .btn-log:hover { background-color: #0bacce; color: #000; }
        .btn-edit { background-color: #fbbc04; color: white; }
        .btn-edit:hover { background-color: #e3a903; color: white; }
        .btn-delete { background-color: #d93025; color: white; }
        .btn-delete:hover { background-color: #c02a20; color: white; }
    </style>
</head>
<body>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/sidebar.jsp" />

    <div class="flex-grow-1 p-4 main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center">
                <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
                <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2"></i>Lịch sử Ca Làm Việc</h2>
            </div>
        </div>

        <% String msg = (String) session.getAttribute("message"); if (msg != null) { %>
            <div class="alert alert-success d-flex align-items-center" role="alert"><i class="fa-solid fa-check-circle me-2"></i><div><%= msg %></div></div>
        <% session.removeAttribute("message"); } %>
        <% String err = (String) session.getAttribute("error"); if (err != null) { %>
            <div class="alert alert-danger d-flex align-items-center" role="alert"><i class="fa-solid fa-triangle-exclamation me-2"></i><div><%= err %></div></div>
        <% session.removeAttribute("error"); } %>

        <div class="card shadow border-0 rounded-4">
            <div class="card-body p-0 table-responsive">
                <table class="table table-hover align-middle mb-0 text-nowrap">
                    <thead class="table-dark">
                        <tr><th class="ps-4 py-3">Shift ID</th><th>User ID</th><th>Start Time</th><th>End Time</th><th>Status</th><th class="text-center pe-4">Hành động</th></tr>
                    </thead>
                    <tbody>
                        <% if (shiftList != null && !shiftList.isEmpty()) { for (Shift s : shiftList) { %>
                        <tr>
                            <td class="ps-4 text-muted fw-bold">#<%=s.getShiftId()%></td>
                            <td class="fw-bold text-dark"><i class="fa-solid fa-user me-2 text-secondary"></i><%=s.getUserId()%></td>
                            <td><%=s.getStartTime()%></td>
                            <td><%= (s.getEndTime() != null) ? s.getEndTime() : "<span class='text-muted fst-italic'>Chưa kết thúc</span>" %></td>
                            <td>
                                <% if ("OPEN".equals(s.getStatus())) { %>
                                    <span class="custom-badge badge-open"><i class="fa-solid fa-spinner fa-spin me-1"></i>OPEN</span>
                                <% } else { %>
                                    <span class="custom-badge badge-closed"><i class="fa-solid fa-lock me-1"></i>CLOSED</span>
                                <% } %>
                            </td>
                            <td class="text-center pe-4">
                                <a href="<%=request.getContextPath()%>/ShiftController?action=view_log&id=<%=s.getShiftId()%>" class="action-btn btn-log me-1"><i class="fa-solid fa-clipboard-list"></i> Logs</a>
                                <a href="<%=request.getContextPath()%>/ShiftController?action=edit&id=<%=s.getShiftId()%>" class="action-btn btn-edit me-1"><i class="fa-solid fa-pen"></i> Edit</a>
                                <a href="<%=request.getContextPath()%>/ShiftController?action=delete&id=<%=s.getShiftId()%>" class="action-btn btn-delete" onclick="return confirm('Cảnh báo: Bạn có chắc chắn muốn xóa ca #<%=s.getShiftId()%> không?');"><i class="fa-solid fa-trash"></i> Delete</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-5"><i class="fa-solid fa-clock mb-3" style="font-size: 40px; color: #dee2e6;"></i><br><h5>Không có dữ liệu</h5><p class="mb-0">Hệ thống chưa ghi nhận ca làm việc nào.</p></td>
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
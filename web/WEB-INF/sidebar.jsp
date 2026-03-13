<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.User" %>
<%
    // Lấy thông tin User hiện tại từ Session cho Sidebar
    User currentUserSidebar = (User) session.getAttribute("user");
    String roleSidebar = (currentUserSidebar != null) ? currentUserSidebar.getRole() : "";
%>

<%
    String logoutAlert = (String) session.getAttribute("logoutAlert");
    if (logoutAlert != null) {
%>
<div id="globalLogoutAlert" class="alert alert-danger alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-4 shadow-lg" 
     style="z-index: 9999; min-width: 300px; text-align: center; border-radius: 10px;" role="alert">
    <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
    <strong>Action Failed!</strong> <br> <%= logoutAlert %>
</div>
    
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const logoutAlertMsg = document.getElementById("globalLogoutAlert");
        if (logoutAlertMsg) {
            setTimeout(function () {
                logoutAlertMsg.style.transition = "opacity 0.6s ease";
                logoutAlertMsg.style.opacity = "0";
                setTimeout(function () {
                    logoutAlertMsg.remove();
                }, 600); // Đợi 0.6s cho hiệu ứng mờ kết thúc rồi xóa hẳn khỏi DOM
            }, 2000); // 3000ms = 3 giây
        }
    });
</script>
<%
        session.removeAttribute("logoutAlert");
    }
%>
<div class="sidebar d-flex flex-column p-3 shadow" id="sidebar">
    <div class="text-center mb-4 mt-2 text-nowrap">
        <h4 class="fw-bold text-white"><i class="fa-solid fa-shield-halved text-primary me-2"></i>Bill Manager</h4>
    </div>
    <hr class="text-secondary mb-4">

    <div class="text-center mb-4 text-nowrap">

        <a href="<%=request.getContextPath()%>/UserController/Profile" style="text-decoration:none;color:inherit;">
            <div class="user-avatar shadow">
                <i class="fa-solid fa-user-tie"></i>
            </div>
        </a>

        <% if (currentUserSidebar != null) {%>
        <h6 class="mb-1 fw-bold"><%= currentUserSidebar.getUsername()%></h6>
        <small class="text-white-50">
            <i class="fa-solid fa-circle text-success" style="font-size: 8px;"></i>
            Online
        </small>
        <% } else { %>
        <h6 class="mb-1 fw-bold">Guest</h6>
        <% } %>

    </div>

    <div class="flex-grow-1 overflow-hidden">
        <% if ("ADMIN".equals(roleSidebar) || "AUDITOR".equals(roleSidebar)) {%>
        <a href="<%=request.getContextPath()%>/DashBoardController" class="sidebar-link mb-2">
            <i class="fa-solid fa-chart-pie me-2"></i> Dashboard
        </a>
        <% } %>

        <% if ("STAFF".equals(roleSidebar) || "ADMIN".equals(roleSidebar) || "AUDITOR".equals(roleSidebar)) {%>
        <a href="<%=request.getContextPath()%>/ShiftController" class="sidebar-link mb-2">
            <i class="fa-solid fa-clock-rotate-left me-2"></i> Shift
        </a>
        <a href="<%=request.getContextPath()%>/InvoiceController/List" class="sidebar-link mb-2">
            <i class="fa-solid fa-file-invoice-dollar me-2"></i> Invoice Management
        </a>
        <% } %>

        <% if ("AUDITOR".equals(roleSidebar) || "ADMIN".equals(roleSidebar)) {%>
        <a href="<%=request.getContextPath()%>/AlertController" class="sidebar-link mb-2">
            <i class="fa-solid fa-bell me-2"></i> Alert Management
        </a>
        <% } %>

        <% if ("ADMIN".equals(roleSidebar) || "AUDITOR".equals(roleSidebar)) {%>
        <a href="<%=request.getContextPath()%>/ProductController/List" class="sidebar-link mb-2">
            <i class="fa-solid fa-box-open me-2"></i> Product List
        </a>
        <% } %>

        <% if ("ADMIN".equals(roleSidebar)) {%>
        <a href="<%=request.getContextPath()%>/ShiftController?action=list" class="sidebar-link mb-2">
            <i class="fa-solid fa-list-check me-2"></i> Shift Management
        </a>
        <a href="<%=request.getContextPath()%>/UserController/List" class="sidebar-link mb-2">
            <i class="fa-solid fa-users-gear me-2"></i> User Management
        </a>
        <% }%>
    </div>

    <form action="<%=request.getContextPath()%>/LogOutController" method="post" class="mt-auto">
        <button type="submit" class="btn btn-danger w-100 fw-bold text-nowrap shadow-sm">
            <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
        </button>
    </form>

</div>
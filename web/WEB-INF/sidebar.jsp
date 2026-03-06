<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.User" %>
<%
    // Lấy thông tin User hiện tại từ Session cho Sidebar
    User currentUserSidebar = (User) session.getAttribute("user");
    String roleSidebar = (currentUserSidebar != null) ? currentUserSidebar.getRole() : "";
%>
<div class="sidebar d-flex flex-column p-3 shadow" id="sidebar">
    <div class="text-center mb-4 mt-2 text-nowrap">
        <h4 class="fw-bold text-white"><i class="fa-solid fa-shield-halved text-primary me-2"></i>BillManager</h4>
    </div>
    <hr class="text-secondary mb-4">

    <div class="text-center mb-4 text-nowrap">
        <div class="user-avatar shadow">
            <i class="fa-solid fa-user-tie"></i>
        </div>
        <% if (currentUserSidebar != null) { %>
            <h6 class="mb-1 fw-bold"><%= currentUserSidebar.getUsername() %></h6>
            <small class="text-white-50"><i class="fa-solid fa-circle text-success" style="font-size: 8px;"></i> Online</small>
        <% } else { %>
            <h6 class="mb-1 fw-bold">Guest</h6>
        <% } %>
    </div>

    <div class="flex-grow-1 overflow-hidden">
        <% if ("ADMIN".equals(roleSidebar) || "AUDITOR".equals(roleSidebar)) { %>
            <a href="<%=request.getContextPath()%>/DashBoardController" class="sidebar-link mb-2">
                <i class="fa-solid fa-chart-pie me-2"></i> Dashboard
            </a>
        <% } %>

        <% if ("STAFF".equals(roleSidebar) || "ADMIN".equals(roleSidebar) || "AUDITOR".equals(roleSidebar)) { %>
            <a href="<%=request.getContextPath()%>/ShiftController" class="sidebar-link mb-2">
                <i class="fa-solid fa-clock-rotate-left me-2"></i> Quản lý Ca
            </a>
            <a href="<%=request.getContextPath()%>/InvoiceController/List" class="sidebar-link mb-2">
                <i class="fa-solid fa-file-invoice-dollar me-2"></i> Invoice Management
            </a>
        <% } %>

        <% if ("AUDITOR".equals(roleSidebar) || "ADMIN".equals(roleSidebar)) { %>
            <a href="<%=request.getContextPath()%>/AlertController" class="sidebar-link mb-2">
                <i class="fa-solid fa-bell me-2"></i> Alert Management
            </a>
        <% } %>

        <% if ("ADMIN".equals(roleSidebar)) { %>
            <a href="<%=request.getContextPath()%>/UserController/List" class="sidebar-link mb-2 text-warning">
                <i class="fa-solid fa-users-gear me-2"></i> Quản lý User
            </a>
            <a href="<%=request.getContextPath()%>/ShiftController?action=list" class="sidebar-link mb-2">
                <i class="fa-solid fa-list-check me-2"></i> Lịch sử Ca (Admin)
            </a>
        <% } %>
    </div>

    <div class="mt-auto pt-3 border-top border-secondary overflow-hidden">
        <a href="<%=request.getContextPath()%>/MenuController?action=Logout" class="btn btn-danger w-100 fw-bold text-nowrap">
            <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
        </a>
    </div>
</div>

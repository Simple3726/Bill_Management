<%-- 
    Document   : invoice_list
    Created on : Feb 25, 2026, 2:29:29 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Invoice" %>
<%@ page import="entity.User" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    User currentUser = (User) session.getAttribute("user");
    String role = (currentUser != null) ? currentUser.getRole() : "";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Hóa đơn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            body, html {
                height: 100%;
                margin: 0;
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                overflow-x: hidden;
            }

            /* === SIDEBAR STYLES === */
            .sidebar {
                width: 260px;
                background-color: #212529;
                color: white;
                min-height: 100vh;
                position: sticky;
                top: 0;
                transition: all 0.3s ease-in-out; /* Hiệu ứng trượt mượt mà */
                z-index: 1000;
            }

            /* Class này sẽ được JS thêm vào để giấu Sidebar */
            .sidebar.collapsed {
                margin-left: -260px;
            }

            .sidebar-link {
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                padding: 10px 15px;
                border-radius: 6px;
                display: block;
                transition: 0.3s;
                white-space: nowrap; /* Ngăn chữ bị rớt dòng khi đóng */
            }

            .sidebar-link:hover, .sidebar-link.active {
                background-color: #0d6efd;
                color: white;
            }

            .user-avatar {
                width: 60px;
                height: 60px;
                background-color: #495057;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                margin: 0 auto 10px auto;
                color: white;
            }
            .glow-online {
                color: #198754;
                text-shadow: 0 0 5px #198754, 0 0 10px #198754;
            }

            /* === NÚT TOGGLE (ĐÓNG/MỞ) === */
            #sidebarToggle {
                background: none;
                border: none;
                color: #212529;
                font-size: 24px;
                cursor: pointer;
                padding: 0 15px 0 0;
                transition: color 0.2s;
            }
            #sidebarToggle:hover {
                color: #0d6efd;
            }

            /* === BUTTON STYLES === */
            .btn-create-new {
                display: inline-block;
                padding: 10px 25px;
                background-color: #212529;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-weight: 500;
                transition: 0.3s;
            }
            .btn-create-new:hover {
                background-color: #495057;
                color: white;
            }

            .btn-update {
                background-color: #f59f00;
                color: #fff;
                padding: 6px 12px;
                font-size: 0.875rem;
                border-radius: 6px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease-in-out;
            }
            .btn-update i {
                margin-right: 5px;
            }
            .btn-update:hover {
                background-color: #e67e22;
                box-shadow: 0 4px 8px rgba(245, 159, 0, 0.3);
                color: #fff;
            }

            /* Vùng chứa nội dung chính */
            .main-content {
                transition: all 0.3s ease-in-out;
                width: 100%;
            }
        </style>
    </head>
    <body>

        <div class="d-flex min-vh-100">

            <div class="sidebar d-flex flex-column p-3 shadow" id="sidebar">
                <div class="text-center mb-4 mt-2 text-nowrap">
                    <h4 class="fw-bold text-white"><i class="fa-solid fa-file-invoice-dollar text-primary me-2"></i>Bill Manager</h4>
                </div>
                <hr class="text-secondary mb-4">

                <div class="text-center mb-4 text-nowrap">
                    <div class="user-avatar shadow">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <% if (currentUser != null) {%>
                    <h6 class="mb-1 fw-bold"><%= currentUser.getUsername()%></h6>
                    <small class="text-white-50"><i class="fa-solid fa-circle glow-online" style="font-size: 8px;"></i> Online</small>
                    <% } else { %>
                    <h6 class="mb-1 fw-bold">Guest</h6>
                    <% } %>
                </div>

                <div class="flex-grow-1 overflow-hidden">
                    <% if ("ADMIN".equals(role) || "AUDITOR".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/DashBoardController" class="sidebar-link mb-2">
                        <i class="fa-solid fa-file-invoice-dollar me-2"></i> Dashboard
                    </a>
                    <% } %>
                    <% if ("STAFF".equals(role) || "ADMIN".equals(role) || "AUDITOR".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/InvoiceController/List" class="sidebar-link mb-2">
                        <i class="fa-solid fa-file-invoice-dollar me-2"></i> Invoice Management
                    </a>
                    <% } %>

                    <% if ("AUDITOR".equals(role) || "ADMIN".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/AlertController" class="sidebar-link mb-2">
                        <i class="fa-solid fa-bell me-2"></i> Alert Management
                    </a>
                    <% } %>

                    <% if ("ADMIN".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/UserController/List" class="sidebar-link mb-2 text-warning">
                        <i class="fa-solid fa-users-gear me-2"></i> Quản lý User
                    </a>
                    <% }%>
                </div>

                <div class="mt-auto pt-3 border-top border-secondary overflow-hidden">
                    <a href="<%=request.getContextPath()%>/MenuController?action=Logout" class="btn btn-danger w-100 fw-bold text-nowrap">
                        <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                    </a>
                </div>
            </div>
            <div class="flex-grow-1 p-4 bg-light main-content">

                <div class="d-flex align-items-center mb-4">
                    <button id="sidebarToggle" title="Đóng/Mở thanh công cụ">
                        <i class="fa-solid fa-bars"></i>
                    </button>
                    <h2 class="text-primary mb-0"><i ></i>Danh sách Hóa đơn</h2>
                </div>

                <div style="margin-bottom: 20px;">
                    <a href="<%=request.getContextPath()%>/InvoiceController/Form" class="btn-create-new">
                        <i class="fa-solid fa-plus me-1"></i> New Invoice
                    </a>
                </div>

                <div class="card shadow border-0">
                    <div class="card-body p-0 table-responsive">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4 py-3">ID</th>
                                    <th>Mã Hóa Đơn</th>
                                    <th>Số Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th>Ngày Tạo</th>
                                    <th class="text-center pe-4">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Invoice> list = (List<Invoice>) request.getAttribute("invoiceList");
                                    DecimalFormat formatter = new DecimalFormat("#,### VNĐ");

                                    if (list != null && !list.isEmpty()) {
                                        for (Invoice item : list) {
                                %>
                                <tr>
                                    <td class="ps-4"><%= item.getInvoiceId()%></td>
                                    <td><strong class="text-primary"><%= (item.getInvoiceCode() != null) ? item.getInvoiceCode() : ""%></strong></td>
                                    <td class="fw-bold"><%= (item.getAmount() != null) ? formatter.format(item.getAmount()) : "0 VNĐ"%></td>
                                    <td><span class="badge bg-secondary px-2 py-1"><%= (item.getStatus() != null) ? item.getStatus() : "N/A"%></span></td>
                                    <td><%= (item.getCreatedAt() != null) ? item.getCreatedAt() : ""%></td>
                                    <td class="text-center pe-4">
                                        <a href="<%=request.getContextPath()%>/InvoiceController/Form?invoiceId=<%= item.getInvoiceId()%>" class="btn-update">
                                            <i class="fa-solid fa-pen-to-square"></i> Update
                                        </a>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-5">
                                        <i class="fa-solid fa-folder-open mb-3" style="font-size: 40px; color: #dee2e6;"></i><br>
                                        <h5>Chưa có hóa đơn nào</h5>
                                        <p class="mb-0">Bấm "New Invoice" để tạo mới.</p>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar");

                toggleBtn.addEventListener("click", function () {
                    // Thêm hoặc xóa class 'collapsed' mỗi khi bấm nút
                    sidebar.classList.toggle("collapsed");
                });
            });
        </script>

    </body>
</html>
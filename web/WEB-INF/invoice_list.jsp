<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Invoice" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body, html { height: 100%; margin: 0; background-color: #f8f9fa; overflow-x: hidden; }
        
        /* SIDEBAR STYLES */
        .sidebar { width: 260px; background-color: #212529; color: white; min-height: 100vh; position: sticky; top: 0; transition: all 0.3s ease-in-out; z-index: 1000; }
        .sidebar.collapsed { margin-left: -260px; }
        .sidebar-link { color: rgba(255, 255, 255, 0.8); text-decoration: none; padding: 10px 15px; border-radius: 6px; display: block; transition: 0.3s; white-space: nowrap; }
        .sidebar-link:hover, .sidebar-link.active { background-color: #0d6efd; color: white; }
        .user-avatar { width: 60px; height: 60px; background-color: #495057; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 10px auto; color: white; }
        #sidebarToggle { background: none; border: none; color: #212529; font-size: 24px; cursor: pointer; padding: 0 15px 0 0; transition: color 0.2s; }
        #sidebarToggle:hover { color: #0d6efd; }
        .main-content { transition: all 0.3s ease-in-out; width: 100%; }

        .btn-create-new { display: inline-block; padding: 10px 25px; background-color: #212529; color: white; text-decoration: none; border-radius: 4px; font-weight: 500; transition: 0.3s; }
        .btn-create-new:hover { background-color: #495057; color: white; }
        .btn-update { background-color: #f59f00; color: #fff; padding: 6px 12px; font-size: 0.875rem; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; border: none; cursor: pointer; transition: all 0.2s ease-in-out; }
        .btn-update i { margin-right: 5px; }
        .btn-update:hover { background-color: #e67e22; box-shadow: 0 4px 8px rgba(245, 159, 0, 0.3); color: #fff; }
    </style>
</head>
<body>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/sidebar.jsp" />

    <div class="flex-grow-1 p-4 bg-light main-content">
        <div class="d-flex align-items-center mb-4">
            <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
            <h2 class="text-primary mb-0">Invoice List</h2>
        </div>
        
        <div style="margin-bottom: 20px;">
            <a href="<%=request.getContextPath()%>/InvoiceController/Form" class="btn-create-new"><i class="fa-solid fa-plus me-1"></i> New Invoice</a>
        </div>

        <div class="card shadow border-0">
            <div class="card-body p-0 table-responsive">
                <table class="table table-hover align-middle mb-0 text-nowrap">
                    <thead class="table-dark">
                        <tr>
                            <th class="ps-4 py-3">ID</th>
                            <th>Invoice ID</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Create At</th>
                            <th class="text-center pe-4">Action</th>
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
                                <td class="ps-4"><%= item.getInvoiceId() %></td>
                                <td><strong class="text-primary"><%= (item.getInvoiceCode() != null) ? item.getInvoiceCode() : "" %></strong></td>
                                <td class="fw-bold"><%= (item.getAmount() != null) ? formatter.format(item.getAmount()) : "0 VNĐ" %></td>
                                <td><span class="badge bg-secondary px-2 py-1"><%= (item.getStatus() != null) ? item.getStatus() : "N/A" %></span></td>
                                <td><%= (item.getCreatedAt() != null) ? item.getCreatedAt() : "" %></td>
                                <td class="text-center pe-4">
                                    <a href="<%=request.getContextPath()%>/InvoiceController/Form?invoiceId=<%= item.getInvoiceId() %>" class="btn-update"><i class="fa-solid fa-pen-to-square"></i> Update</a>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-5">
                                    <i class="fa-solid fa-folder-open mb-3" style="font-size: 40px; color: #dee2e6;"></i><br>
                                    <h5>No Data</h5>
                                    <p class="mb-0">Create new with "New Invoice".</p>
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

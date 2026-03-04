<%-- 
    Document   : invoice_list
    Created on : Feb 25, 2026, 2:29:29 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Invoice" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4 text-primary">Danh sách Hóa đơn</h2>
    <div style="margin-bottom: 20px;">
        <form action="MenuController" method="POST">
            <button type="submit" name="action" value="CreateForm"
                style="
                display: inline-block;
                padding: 10px 25px;
                background-color: #212529; /* Màu tối để hợp với Header của bảng */
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-weight: 500;
                transition: 0.3s;
           "
           onmouseover="this.style.backgroundColor='#495057'"
           onmouseout="this.style.backgroundColor='#212529'">+NewInvoice</button>
        </form>
        
    </div>
    <div class="card shadow">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Mã Hóa Đơn</th>
                        <th>Số Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Ngày Tạo</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Lấy dữ liệu từ request attribute (ép kiểu về List<Invoice>)
                        List<Invoice> list = (List<Invoice>) request.getAttribute("invoiceList");
                        
                        if (list != null && !list.isEmpty()) {
                            for (Invoice item : list) {
                    %>
                        <tr>
                            <td><%= item.getInvoiceId() %></td>
                            <td><strong><%= item.getInvoiceCode() %></strong></td>
                            <td>
                                <%-- Định dạng tiền tệ thủ công thay cho <fmt:formatNumber> --%>
                                <%= String.format("%,.0f VNĐ", item.getAmount()) %>
                            </td>
                            <td>
                                <span class="badge bg-secondary"><%= item.getStatus() %></span>
                            </td>
                            <td><%= item.getCreatedAt() %></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="5" class="text-center text-muted">Không có dữ liệu để hiển thị.</td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
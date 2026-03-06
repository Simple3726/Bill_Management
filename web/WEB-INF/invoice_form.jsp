<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Invoice" %>
<%
    // Lấy đối tượng invoice từ request
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    
    // Kiểm tra xem là form tạo mới hay form sửa
    boolean isEdit = (invoice != null && invoice.getInvoiceId() != null);
    
    // Kiểm tra xem hóa đơn đã có ngày tạo chưa (để hiển thị phần người tạo/ngày tạo)
    boolean hasCreatedAt = (isEdit && invoice.getCreatedAt() != null);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hóa đơn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* CSS Reset & Cơ bản */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            color: #212529;
            line-height: 1.5;
        }

        /* Layout Container */
        .container {
            width: 100%;
            max-width: 800px;
            margin: 3rem auto; 
            padding: 0 15px;
        }

        /* Card (Khung hóa đơn) */
        .invoice-card { 
            background-color: #fff;
            border-radius: 15px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); 
            padding: 2rem; 
        }

        /* Header của form */
        .card-header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem; 
        }
        .header-title {
            font-size: 2rem;
            font-weight: bold;
            color: #0d6efd; 
        }
        .header-title i {
            margin-right: 0.5rem; 
        }
        .badge {
            background-color: #0dcaf0; 
            color: #000; 
            padding: 0.4em 0.8em;
            border-radius: 50rem;
            font-size: 0.9em;
            font-weight: 700;
        }

        /* Lưới Form (Grid System) */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin-left: -10px;
            margin-right: -10px;
            row-gap: 1rem; 
        }
        .col-6 {
            width: 50%;
            padding: 0 10px;
        }
        .col-12 {
            width: 100%;
            padding: 0 10px;
        }

        /* Các phần tử Form */
        .form-label { 
            display: inline-block;
            margin-bottom: 0.5rem;
            font-weight: 600; 
            color: #495057; 
        }
        .form-control {
            display: block;
            width: 100%;
            padding: 0.6rem 0.75rem;
            font-size: 1rem;
            font-family: inherit;
            color: #212529;
            background-color: #fff;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        .form-control:focus {
            border-color: #86b7fe;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        .form-control-lg {
            padding: 0.75rem 1rem;
            font-size: 1.25rem;
        }
        .text-end {
            text-align: right;
        }

        /* Input Group (ô nhập tiền + chữ VND) */
        .input-group {
            display: flex;
            align-items: stretch;
            width: 100%;
        }
        .input-group .form-control {
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
            flex: 1 1 auto;
        }
        .input-group-text { 
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            color: #495057;
            text-align: center;
            white-space: nowrap;
            background-color: #e9ecef; 
            border: 1px solid #ced4da; 
            border-left: 0;
            border-top-right-radius: 0.375rem;
            border-bottom-right-radius: 0.375rem;
        }
        .form-text {
            display: block;
            margin-top: 0.25rem;
            font-size: 0.875em;
            color: #6c757d; 
        }

        /* Thông tin Meta (Ngày tạo, người tạo) */
        .meta-text small {
            display: block;
            font-size: 0.875em;
            color: #6c757d;
        }
        .mt-4 { margin-top: 1.5rem; }

        /* Đường kẻ ngang */
        hr {
            margin: 2rem 0;
            color: inherit;
            background-color: transparent;
            border: 0;
            border-top: 1px solid rgba(0,0,0,0.1);
        }

        /* Cụm nút bấm */
        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
        }
        .btn {
            display: inline-block;
            font-weight: 400;
            line-height: 1.5;
            text-align: center;
            text-decoration: none;
            vertical-align: middle;
            cursor: pointer;
            border: 1px solid transparent;
            font-size: 1rem;
            transition: color 0.15s, background-color 0.15s, border-color 0.15s, box-shadow 0.15s;
        }
        .btn-light {
            color: #000;
            background-color: #f8f9fa;
            border-color: #f8f9fa;
            padding: 0.375rem 1.5rem; 
            border-radius: 0.375rem;
        }
        .btn-light:hover {
            background-color: #e2e6ea;
            border-color: #dae0e5;
        }
        .btn-save { 
            background-color: #0d6efd; 
            color: white;
            padding: 10px 25px; 
            border-radius: 8px; 
        }
        .btn-save:hover { 
            background-color: #0b5ed7; 
        }
    </style>
</head>
<body>

<div class="container">
    <div class="invoice-card">
        
        <div class="card-header-flex">
            <h2 class="header-title"><i class="fa-solid fa-file-invoice-dollar"></i>Thông tin Hóa đơn</h2>
            <span class="badge">
                ID: <%= (isEdit && invoice.getInvoiceId() != null) ? invoice.getInvoiceId() : "Mới" %>
            </span>
        </div>

        <form action="<%=request.getContextPath()%>/InvoiceController/<%=isEdit?"Update":"Create"%>" method="get">
            
            <% if(isEdit && invoice.getInvoiceId() != null){ %>
                <input type="hidden" name="invoiceId" value="<%=invoice.getInvoiceId()%>">
            <% } %>

            <div class="row">
                <div class="col-6">
                    <label class="form-label">Mã hóa đơn</label>
                    <input type="text" name="invoiceCode" class="form-control" 
                           placeholder="INV-2024-001" 
                           value="<%= invoice.getInvoiceCode() %>" readonly>
                </div>

                <div class="col-12 mt-4">
                    <label class="form-label">Tổng tiền (VNĐ)</label>
                    <div class="input-group">
                        <input type="number" name="amount" class="form-control form-control-lg text-end" 
                               step="0.01" min="0" placeholder="0.00" 
                               value="<%= (isEdit && invoice.getAmount() != null) ? invoice.getAmount() : "" %>" required>
                        <span class="input-group-text">VND</span>
                    </div>
                    <span class="form-text">Sử dụng dấu chấm (.) cho phần thập phân.</span>
                </div>

                <% if(hasCreatedAt) { %>
                    <div class="col-6 mt-4 meta-text">
                        <small>Người tạo: <strong><%= invoice.getCreatedBy() %></strong></small>
                        <small>Ngày tạo: <%= invoice.getCreatedAt() %></small>
                    </div>
                    <div class="col-6 mt-4 meta-text text-end">
                        <small>Cập nhật cuối: <%= (invoice.getUpdatedAt() != null) ? invoice.getUpdatedAt() : "" %></small>
                    </div>
                <% } %>
            </div>

            <hr>

            <div class="actions">
                <a href="<%=request.getContextPath()%>/InvoiceController/List" class="btn btn-light">Hủy bỏ</a>
                <button type="submit" class="btn btn-save">
                    <i class="fa-solid fa-save me-2"></i> Lưu hóa đơn
                </button>
            </div>
            
        </form>
    </div>
</div>

</body>
</html>
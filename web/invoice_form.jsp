<%-- 
    Document   : invoice_form
    Created on : Feb 25, 2026, 2:29:36 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .invoice-card { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; color: #495057; }
        .input-group-text { background-color: #e9ecef; border: none; }
        .btn-save { background-color: #0d6efd; border: none; padding: 10px 25px; border-radius: 8px; }
        .btn-save:hover { background-color: #0b5ed7; }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card invoice-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold text-primary"><i class="fa-solid fa-file-invoice-dollar me-2"></i>Thông tin Hóa đơn</h2>
                    <span class="badge bg-info text-dark">ID: ${invoice.invoiceId != null ? invoice.invoiceId : 'Mới'}</span>
                </div>

                <form action="saveInvoice" method="GET">
                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Mã hóa đơn</label>
                            <input type="text" name="invoiceCode" class="form-control" 
                                   placeholder="VD: INV-2024-001" value="${invoice.invoiceCode}" required>
                        </div>


                        <div class="col-md-12">
                            <label class="form-label">Tổng tiền (VNĐ)</label>
                            <div class="input-group">
                                <input type="number" name="amount" class="form-control form-control-lg text-end" 
                                       step="0.01" min="0" placeholder="0.00" value="${invoice.amount}" required>
                                <span class="input-group-text">VND</span>
                            </div>
                            <div class="form-text text-muted">Sử dụng dấu chấm (.) cho phần thập phân.</div>
                        </div>

                        <c:if test="${invoice.createdAt != null}">
                        <div class="col-md-6 mt-4">
                            <small class="text-muted d-block">Người tạo: <strong>${invoice.createdBy}</strong></small>
                            <small class="text-muted">Ngày tạo: ${invoice.createdAt}</small>
                        </div>
                        <div class="col-md-6 mt-4 text-end">
                            <small class="text-muted d-block">Cập nhật cuối: ${invoice.updatedAt}</small>
                        </div>
                        </c:if>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-end gap-2">
                        <a href="invoices" class="btn btn-light px-4">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary btn-save text-white">
                            <i class="fa-solid fa-save me-2"></i>Lưu hóa đơn
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
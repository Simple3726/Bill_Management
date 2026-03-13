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
        <title>Bill Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            /* [Giữ nguyên toàn bộ CSS cũ của bạn ở đây] */
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
            .container {
                width: 100%;
                max-width: 900px;
                margin: 3rem auto;
                padding: 0 15px;
            } /* Mở rộng max-width một chút cho bảng đẹp hơn */
            .invoice-card {
                background-color: #fff;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                padding: 2rem;
            }
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
            .row {
                display: flex;
                flex-wrap: wrap;
                margin-left: -10px;
                margin-right: -10px;
                row-gap: 1rem;
            }
            .col-4 {
                width: 33.33%;
                padding: 0 10px;
            }
            .col-6 {
                width: 50%;
                padding: 0 10px;
            }
            .col-8 {
                width: 66.66%;
                padding: 0 10px;
            }
            .col-12 {
                width: 100%;
                padding: 0 10px;
            }
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
                font-weight: bold;
                color: #0d6efd;
            }
            .text-end {
                text-align: right;
            }
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
            .meta-text small {
                display: block;
                font-size: 0.875em;
                color: #6c757d;
            }
            .mt-4 {
                margin-top: 1.5rem;
            }
            hr {
                margin: 2rem 0;
                color: inherit;
                background-color: transparent;
                border: 0;
                border-top: 1px solid rgba(0,0,0,0.1);
            }
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
                transition: all 0.15s;
                border-radius: 0.375rem;
            }
            .btn-light {
                color: #000;
                background-color: #f8f9fa;
                border-color: #f8f9fa;
                padding: 0.6rem 1.5rem;
            }
            .btn-light:hover {
                background-color: #e2e6ea;
                border-color: #dae0e5;
            }
            .btn-save {
                background-color: #0d6efd;
                color: white;
                padding: 0.6rem 1.5rem;
            }
            .btn-save:hover {
                background-color: #0b5ed7;
            }
            .btn-add {
                background-color: #198754;
                color: white;
                padding: 0.6rem 1rem;
                width: 100%;
                height: 100%;
            }
            .btn-add:hover {
                background-color: #157347;
            }
            .btn-delete {
                color: #dc3545;
                background: none;
                border: none;
                cursor: pointer;
                font-size: 1.2rem;
            }
            .btn-delete:hover {
                color: #a52834;
            }

            /* Style cho bảng giỏ hàng */
            .cart-section {
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 1.5rem;
                margin-top: 1.5rem;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 1rem;
                background: #fff;
            }
            .table th, .table td {
                padding: 1rem;
                border-bottom: 1px solid #dee2e6;
                text-align: left;
            }
            .table th {
                background-color: #f1f3f5;
                font-weight: 600;
                color: #495057;
            }
            .table td {
                vertical-align: middle;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <div class="invoice-card">

                <div class="card-header-flex">
                    <h2 class="header-title"><i class="fa-solid fa-file-invoice-dollar"></i>Create Invoice</h2>
                    <span class="badge">
                        ID: <%= (isEdit && invoice.getInvoiceId() != null) ? invoice.getInvoiceId() : "New"%>
                    </span>
                </div>

                <form action="<%=request.getContextPath()%>/InvoiceController/<%=isEdit ? "Update" : "Create"%>" method="POST" id="invoiceForm">

                    <% if (isEdit && invoice.getInvoiceId() != null) {%>
                    <input type="hidden" name="invoiceId" value="<%=invoice.getInvoiceId()%>">
                    <% }%>

                    <input type="hidden" name="cartData" id="cartDataInput">

                    <div class="row">
                        <div class="col-6">
                            <label class="form-label">Invoice ID</label>
                            <input type="text" name="invoiceCode" class="form-control" 
                                   value="<%= invoice.getInvoiceCode()%>" readonly>
                            <input type="hidden" name="status" value="<%=invoice.getStatus()%>">
                        </div>
                    </div>

                    <div class="cart-section">
                        <h4 style="margin-bottom: 1rem; color: #495057;"><i class="fa-solid fa-cart-plus"></i> Item Details</h4>

                        <div class="row">
                            <div class="col-6">
                                <label class="form-label">Choose Item</label>
                                <select id="productSelect" class="form-control">
                                    <option value="" disabled selected>-- Choose Item --</option>
                                    <option value="1" data-name="Cà phê đen đá" data-price="25000">Cà phê đen đá - 25,000đ</option>
                                    <option value="2" data-name="Bạc xỉu" data-price="35000">Bạc xỉu - 35,000đ</option>
                                    <option value="3" data-name="Trà đào cam sả" data-price="45000">Trà đào cam sả - 45,000đ</option>
                                </select>
                            </div>
                            <div class="col-4">
                                <label class="form-label">Amount</label>
                                <input type="number" id="quantityInput" class="form-control" value="1" min="1">
                            </div>
                            <div class="col-12 mt-4" style="width: 100%; padding-top: 1.8rem;">
                                <button type="button" class="btn btn-add" onclick="addToCart()">
                                    <i class="fa-solid fa-plus"></i> Add
                                </button>
                            </div>
                        </div>

                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th style="text-align: center;">Amount</th>
                                    <th style="text-align: right;">Price</th>
                                    <th style="text-align: right;">Total</th>
                                    <th style="text-align: center;">Delete</th>
                                </tr>
                            </thead>
                            <tbody id="cartTableBody">
                                <tr id="emptyRow">
                                    <td colspan="5" style="text-align: center; color: #6c757d; font-style: italic;">No data.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="row mt-4">
                        <div class="col-12">
                            <label class="form-label" style="font-size: 1.2rem; color: #dc3545;">TOTAL</label>
                            <div class="input-group">
                                <input type="number" name="amount" id="totalAmountInput" class="form-control form-control-lg text-end" 
                                       step="0.01" value="0" readonly style="background-color: #fff3f3; color: #dc3545;">
                                <span class="input-group-text">VNĐ</span>

                                <% if (isEdit && invoice.getAmount() != null) {%>
                                <input type="hidden" name="oldAmount" value="<%= invoice.getAmount()%>">
                                <%}%>
                            </div>
                        </div>

                        <% if (hasCreatedAt) {%>
                        <div class="col-6 mt-4 meta-text">
                            <small>Create By: <strong><%= invoice.getCreatedBy()%></strong></small>
                            <small>Create At: <%= invoice.getCreatedAt()%></small>
                        </div>
                        <div class="col-6 mt-4 meta-text text-end">
                            <small>Last Update: <%= (invoice.getUpdatedAt() != null) ? invoice.getUpdatedAt() : ""%></small>
                        </div>
                        <% }%>
                    </div>

                    <hr>

                    <div class="actions">
                        <a href="<%=request.getContextPath()%>/InvoiceController/List" class="btn btn-light">Cancel</a>
                        <button type="submit" class="btn btn-save" onclick="return validateBeforeSubmit()">
                            <i class="fa-solid fa-save me-2"></i> Save
                        </button>
                    </div>

                </form>
            </div>
        </div>

        <script>
            // Mảng lưu trữ các mặt hàng đã chọn
            let cart = [];

            // Hàm định dạng tiền tệ (Ví dụ: 35000 -> 35,000)
            function formatCurrency(number) {
                return new Intl.NumberFormat('vi-VN').format(number);
            }

            // Hành động: Bấm nút "Thêm vào hóa đơn"
            function addToCart() {
                const selectBox = document.getElementById('productSelect');
                const quantityInput = document.getElementById('quantityInput');

                if (selectBox.selectedIndex === 0 || selectBox.value === "") {
                    alert("Vui lòng chọn một mặt hàng!");
                    return;
                }

                const selectedOption = selectBox.options[selectBox.selectedIndex];
                const productId = selectedOption.value;
                const productName = selectedOption.getAttribute('data-name');
                const price = parseFloat(selectedOption.getAttribute('data-price'));
                const quantity = parseInt(quantityInput.value);

                if (quantity <= 0) {
                    alert("Số lượng phải lớn hơn 0!");
                    return;
                }

                // Kiểm tra xem sản phẩm đã có trong giỏ chưa
                let existingItem = cart.find(item => item.productId === productId);
                if (existingItem) {
                    existingItem.quantity += quantity; // Nếu có rồi thì cộng dồn số lượng
                } else {
                    // Nếu chưa có thì thêm mới vào mảng
                    cart.push({
                        productId: productId,
                        productName: productName,
                        price: price,
                        quantity: quantity
                    });
                }

                // Reset ô số lượng về 1 sau khi thêm
                quantityInput.value = 1;
                selectBox.selectedIndex = 0;

                // Cập nhật lại giao diện
                updateCartUI();
            }

            // Hành động: Xóa 1 dòng trong giỏ
            function removeCartItem(index) {
                cart.splice(index, 1);
                updateCartUI();
            }

            // Cập nhật giao diện (Vẽ lại bảng, tính tiền, đẩy JSON vào thẻ input ẩn)
            function updateCartUI() {
                const tbody = document.getElementById('cartTableBody');
                const totalAmountInput = document.getElementById('totalAmountInput');
                const cartDataInput = document.getElementById('cartDataInput');

                tbody.innerHTML = ''; // Xóa sạch bảng cũ
                let totalAmount = 0;

                if (cart.length === 0) {
                    tbody.innerHTML = '<tr id="emptyRow"><td colspan="5" style="text-align: center; color: #6c757d; font-style: italic;">Chưa có mặt hàng nào trong hóa đơn.</td></tr>';
                } else {
                    cart.forEach((item, index) => {
                        const itemTotal = item.price * item.quantity;
                        totalAmount += itemTotal;

                        const tr = document.createElement('tr');
                        tr.innerHTML = `
                            <td><strong>\${item.productName}</strong></td>
                            <td style="text-align: center;">\${item.quantity}</td>
                            <td style="text-align: right;">\${formatCurrency(item.price)}đ</td>
                            <td style="text-align: right; color: #0d6efd; font-weight: bold;">\${formatCurrency(itemTotal)}đ</td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-delete" onclick="removeCartItem(\${index})" title="Xóa">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </td>
                        `;
                        tbody.appendChild(tr);
                    });
                }

                // Ghi tổng tiền vào ô Total
                totalAmountInput.value = totalAmount;

                // **QUAN TRỌNG NHẤT**: Biến mảng JS thành chuỗi JSON và nhét vào thẻ <input type="hidden">
                cartDataInput.value = JSON.stringify(cart);
            }

            // Chặn submit nếu giỏ hàng trống
            function validateBeforeSubmit() {
                if (cart.length === 0) {
                    alert("Không thể lưu hóa đơn! Vui lòng thêm ít nhất 1 mặt hàng vào hóa đơn.");
                    return false;
                }
                return true;
            }

            // (Dành cho chức năng Edit) Nếu đang Edit, bạn có thể truyền chuỗi JSON từ Java vào mảng `cart` tại đây
            // Ví dụ: cart = <%= (isEdit) ? "gọi_hàm_Java_trả_về_chuỗi_json" : "[]"%>;
            // updateCartUI();
        </script>

    </body>
</html>
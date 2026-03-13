<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Invoice" %>
<%@ page import="entity.Product" %>
<%@ page import="java.util.List" %>
<%
    // Get invoice object from request
    Invoice invoice = (Invoice) request.getAttribute("invoice");

    // Check if this is an edit form or create form
    boolean isEdit = (invoice != null && invoice.getInvoiceId() != null);

    // Check if invoice has a creation date
    boolean hasCreatedAt = (isEdit && invoice.getCreatedAt() != null);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Invoice Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
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
            } 
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
            .col-4 { width: 33.33%; padding: 0 10px; }
            .col-6 { width: 50%; padding: 0 10px; }
            .col-8 { width: 66.66%; padding: 0 10px; }
            .col-12 { width: 100%; padding: 0 10px; }
            
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
            .text-end { text-align: right; }
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
            .mt-4 { margin-top: 1.5rem; }
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
            .btn-save:hover { background-color: #0b5ed7; }
            .btn-add {
                background-color: #198754;
                color: white;
                padding: 0.6rem 1rem;
                width: 100%;
                height: 100%;
            }
            .btn-add:hover { background-color: #157347; }
            .btn-delete {
                color: #dc3545;
                background: none;
                border: none;
                cursor: pointer;
                font-size: 1.2rem;
            }
            .btn-delete:hover { color: #a52834; }

            /* Style for cart section */
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
                    <h2 class="header-title">
                        <i class="fa-solid fa-file-invoice-dollar"></i> 
                        <%= isEdit ? "Update Invoice" : "Create New Invoice" %>
                    </h2>
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
                            <label class="form-label">Invoice Code</label>
                            <input type="text" name="invoiceCode" class="form-control" 
                                   value="<%= (invoice != null && invoice.getInvoiceCode() != null) ? invoice.getInvoiceCode() : ""%>" readonly>
                            <input type="hidden" name="status" value="<%= (invoice != null && invoice.getStatus() != null) ? invoice.getStatus() : ""%>">
                        </div>
                    </div>

                    <div class="cart-section">
                        <h4 style="margin-bottom: 1rem; color: #495057;"><i class="fa-solid fa-cart-plus"></i> Item Details</h4>

                        <div class="row">
                            <div class="col-6">
                                <label class="form-label">Select Product</label>
                                <select id="productSelect" class="form-control">
                                    <option value="" disabled selected>-- Select a product --</option>
                                    <%
                                        // Load dynamic products from the request attribute
                                        List<Product> pList = (List<Product>) request.getAttribute("productList");
                                        if (pList != null && !pList.isEmpty()) {
                                            for (Product p : pList) {
                                    %>
                                                <option value="<%= p.getProductId() %>" 
                                                        data-name="<%= p.getProductName() %>" 
                                                        data-price="<%= p.getPrice() %>">
                                                    <%= p.getProductName() %> - <%= String.format("%,.0f", p.getPrice()) %> VND
                                                </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="col-4">
                                <label class="form-label">Quantity</label>
                                <input type="number" id="quantityInput" class="form-control" value="1" min="1">
                            </div>
                            <div class="col-12 mt-4" style="width: 100%; padding-top: 1.8rem;">
                                <button type="button" class="btn btn-add" onclick="addToCart()">
                                    <i class="fa-solid fa-plus"></i> Add to Invoice
                                </button>
                            </div>
                        </div>

                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Product Name</th>
                                    <th style="text-align: center;">Quantity</th>
                                    <th style="text-align: right;">Unit Price</th>
                                    <th style="text-align: right;">Total Price</th>
                                    <th style="text-align: center;">Action</th>
                                </tr>
                            </thead>
                            <tbody id="cartTableBody">
                                <tr id="emptyRow">
                                    <td colspan="5" style="text-align: center; color: #6c757d; font-style: italic;">No items in the invoice yet.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-12">
                            <label class="form-label" style="font-size: 1.2rem; color: #dc3545;">TOTAL AMOUNT</label>
                            <div class="input-group">
                                <input type="number" name="amount" id="totalAmountInput" class="form-control form-control-lg text-end" 
                                       step="0.01" value="0" readonly style="background-color: #fff3f3; color: #dc3545;">
                                <span class="input-group-text">VND</span>

                                <% if (isEdit && invoice.getAmount() != null) {%>
                                <input type="hidden" name="oldAmount" value="<%= invoice.getAmount()%>">
                                <%}%>
                            </div>
                        </div>

                        <% if (hasCreatedAt) {%>
                        <div class="col-6 mt-4 meta-text">
                            <small>Created By: <strong><%= invoice.getCreatedBy()%></strong></small>
                            <small>Created At: <%= invoice.getCreatedAt()%></small>
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
                            <i class="fa-solid fa-save me-2"></i> Save Invoice
                        </button>
                    </div>

                </form>
            </div>
        </div>

        <script>
            // Array to store selected items
            let cart = [];

            // Function to format currency (e.g., 35000 -> 35,000)
            function formatCurrency(number) {
                return new Intl.NumberFormat('en-US').format(number);
            }

            // Action: Click "Add to Invoice"
            function addToCart() {
                const selectBox = document.getElementById('productSelect');
                const quantityInput = document.getElementById('quantityInput');

                if (selectBox.selectedIndex === 0 || selectBox.value === "") {
                    alert("Please select a product!");
                    return;
                }

                const selectedOption = selectBox.options[selectBox.selectedIndex];
                const productId = selectedOption.value;
                const productName = selectedOption.getAttribute('data-name');
                const price = parseFloat(selectedOption.getAttribute('data-price'));
                const quantity = parseInt(quantityInput.value);

                if (quantity <= 0) {
                    alert("Quantity must be greater than 0!");
                    return;
                }

                // Check if the product is already in the cart
                let existingItem = cart.find(item => item.productId === productId);
                if (existingItem) {
                    existingItem.quantity += quantity; // Accumulate quantity if already exists
                } else {
                    // Add new item to the array
                    cart.push({
                        productId: productId,
                        productName: productName,
                        price: price,
                        quantity: quantity
                    });
                }

                // Reset quantity field to 1 after adding
                quantityInput.value = 1;
                selectBox.selectedIndex = 0;

                // Update UI
                updateCartUI();
            }

            // Action: Remove 1 row from the cart
            function removeCartItem(index) {
                cart.splice(index, 1);
                updateCartUI();
            }

            // Update UI (Redraw table, calculate total, push JSON to hidden input)
            function updateCartUI() {
                const tbody = document.getElementById('cartTableBody');
                const totalAmountInput = document.getElementById('totalAmountInput');
                const cartDataInput = document.getElementById('cartDataInput');

                tbody.innerHTML = ''; // Clear old table content
                let totalAmount = 0;

                if (cart.length === 0) {
                    tbody.innerHTML = '<tr id="emptyRow"><td colspan="5" style="text-align: center; color: #6c757d; font-style: italic;">No items in the invoice yet.</td></tr>';
                } else {
                    cart.forEach((item, index) => {
                        const itemTotal = item.price * item.quantity;
                        totalAmount += itemTotal;

                        const tr = document.createElement('tr');
                        // IMPORTANT: Escaping the $ sign for JS template literals to prevent JSP EL conflicts
                        tr.innerHTML = `
                            <td><strong>\${item.productName}</strong></td>
                            <td style="text-align: center;">\${item.quantity}</td>
                            <td style="text-align: right;">\${formatCurrency(item.price)} VND</td>
                            <td style="text-align: right; color: #0d6efd; font-weight: bold;">\${formatCurrency(itemTotal)} VND</td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-delete" onclick="removeCartItem(\${index})" title="Remove">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </td>
                        `;
                        tbody.appendChild(tr);
                    });
                }

                // Write total amount to the Total input
                totalAmountInput.value = totalAmount;

                // **MOST IMPORTANT**: Convert JS array to JSON string and insert into the hidden input
                cartDataInput.value = JSON.stringify(cart);
            }

            // Block submit if the cart is empty
            function validateBeforeSubmit() {
                if (cart.length === 0) {
                    alert("Cannot save the invoice! Please add at least 1 item to the invoice.");
                    return false;
                }
                return true;
            }

            // (For Edit Function) If editing, you can pass JSON string from Java into the `cart` array here
            // Example: cart = <%= (isEdit) ? "call_java_function_returning_json_string" : "[]"%>;
            // updateCartUI();
        </script>

    </body>
</html>
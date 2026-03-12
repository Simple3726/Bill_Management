<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Product" %>
<%
    // Get product object from request
    Product product = (Product) request.getAttribute("product");

    // Check if this is an edit form or create form
    boolean isEdit = (product != null && product.getProductId() != null);

    // Check if product has a creation date
    boolean hasCreatedAt = (isEdit && product.getCreatedAt() != null);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product Management</title>
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
                max-width: 700px;
                margin: 3rem auto;
                padding: 0 15px;
            } 
            .product-card {
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
            .text-end { text-align: right; }
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
        </style>
    </head>
    <body>

        <div class="container">
            <div class="product-card">

                <div class="card-header-flex">
                    <h2 class="header-title">
                        <i class="fa-solid <%= isEdit ? "fa-pen-to-square" : "fa-box-open" %>"></i> 
                        <%= isEdit ? "Update Product" : "Add New Product" %>
                    </h2>
                    <span class="badge">
                        ID: <%= (isEdit && product.getProductId() != null) ? product.getProductId() : "New"%>
                    </span>
                </div>

                <form action="<%=request.getContextPath()%>/ProductController/<%=isEdit ? "Update" : "Create"%>" method="GET">

                    <% if (isEdit && product.getProductId() != null) {%>
                    <input type="hidden" name="productId" value="<%=product.getProductId()%>">
                    <% }%>

                    <div class="row">
                        <div class="col-8">
                            <label class="form-label">Product Name <span style="color:red;">*</span></label>
                            <input type="text" name="productName" class="form-control" 
                                   placeholder="e.g., Black Coffee..." required
                                   value="<%= (product != null && product.getProductName() != null) ? product.getProductName() : ""%>">
                        </div>

                        <div class="col-4">
                            <label class="form-label">Status</label>
                            <select name="status" class="form-control">
                                <% String currentStatus = (product != null && product.getStatus() != null) ? product.getStatus() : "ACTIVE"; %>
                                <option value="ACTIVE" <%= "ACTIVE".equals(currentStatus) ? "selected" : "" %>>Active</option>
                                <option value="INACTIVE" <%= "INACTIVE".equals(currentStatus) ? "selected" : "" %>>Inactive</option>
                            </select>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-6">
                            <label class="form-label">Price <span style="color:red;">*</span></label>
                            <div class="input-group">
                                <input type="number" name="price" class="form-control text-end" 
                                       step="0.01" min="0" placeholder="0.00" required
                                       value="<%= (product != null && product.getPrice() != null) ? product.getPrice() : ""%>">
                                <span class="input-group-text">VND</span>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <% if (hasCreatedAt) {%>
                        <div class="col-6 meta-text">
                            <small>Create At: <strong><%= product.getCreatedAt()%></strong></small>
                        </div>
                        <div class="col-6 meta-text text-end">
                            <small>Last Update: <strong><%= (product.getUpdatedAt() != null) ? product.getUpdatedAt() : ""%></strong></small>
                        </div>
                        <% }%>
                    </div>

                    <hr>

                    <div class="actions">
                        <a href="<%=request.getContextPath()%>/ProductController/List" class="btn btn-light">Cancel</a>
                        <button type="submit" class="btn btn-save">
                            <i class="fa-solid fa-save me-2"></i> <%= isEdit ? "Save Changes" : "Create Product" %>
                        </button>
                    </div>

                </form>
            </div>
        </div>

    </body>
</html>
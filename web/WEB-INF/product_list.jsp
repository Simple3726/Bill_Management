<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Product" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            body, html {
                height: 100vh;
                margin: 0;
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                overflow: hidden;
            }

            /* --- SIDEBAR STYLES (Nguyên bản 100% của bạn) --- */
            .sidebar {
                width: 260px;
                background-color: #212529;
                color: white;
                min-height: 100vh;
                position: sticky;
                top: 0;
                transition: all 0.3s ease-in-out;
                z-index: 1000;
            }
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
                white-space: nowrap;
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
            /* --- END SIDEBAR STYLES --- */

            /* Main Content Flexbox Layout */
            .main-content {
                transition: all 0.3s ease-in-out;
                width: 100%;
                height: 100vh;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            /* BẢNG & THANH CUỘN (SCROLLBAR) */
            .table-container {
                flex-grow: 1; 
                overflow-y: auto; 
                max-height: calc(100vh - 160px);
            }
            .table-container::-webkit-scrollbar {
                width: 8px;
                height: 8px;
            }
            .table-container::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 8px;
            }
            .table-container::-webkit-scrollbar-thumb {
                background: #c1c1c1;
                border-radius: 8px;
            }
            .table-container::-webkit-scrollbar-thumb:hover {
                background: #a8a8a8;
            }

            /* Sticky Header */
            .table-dark th {
                position: sticky;
                top: 0;
                z-index: 2;
                background-color: #212529;
                box-shadow: 0 2px 2px -1px rgba(0, 0, 0, 0.4);
            }

            /* BUTTONS & BADGES */
            .btn-create-new {
                display: inline-block;
                padding: 10px 25px;
                background-color: #1f6feb;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-weight: 500;
                transition: 0.3s;
            }
            .btn-create-new:hover {
                background-color: #155bc2;
                color: white;
            }

            .action-btn {
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 500;
                border: none;
                transition: 0.2s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
            }
            .btn-update { background-color: #f59f00; color: white; }
            .btn-update:hover { background-color: #e67e22; box-shadow: 0 4px 8px rgba(245, 159, 0, 0.3); color: white; }
            .btn-delete { background-color: #d93025; color: white; }
            .btn-delete:hover { background-color: #c02a20; color: white; }

            .custom-badge {
                padding: 6px 12px;
                border-radius: 50px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .badge-active { background-color: #e6f4ea; color: #188038; }
            .badge-inactive { background-color: #ffecec; color: #d93025; }

            .search-box { min-width: 250px; }
        </style>
    </head>
    <body>

        <div class="d-flex w-100 vh-100 overflow-hidden">
            <jsp:include page="/WEB-INF/sidebar.jsp" />

            <div class="p-4 main-content">

                <div class="d-flex justify-content-between align-items-center mb-4 flex-shrink-0">
                    <div class="d-flex align-items-center">
                        <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
                        <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-box-open me-2"></i>Product List</h2>
                    </div>
                    <a href="<%=request.getContextPath()%>/ProductController/Form" class="btn-create-new shadow-sm">
                        <i class="fa-solid fa-plus me-1"></i> New Product
                    </a>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3 flex-shrink-0">
                    <div class="input-group search-box shadow-sm w-auto">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" id="productSearch" class="form-control border-start-0 ps-0" placeholder="Search Product Name...">
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <label for="statusFilter" class="fw-semibold text-secondary mb-0">Filter by Status:</label>
                        <select id="statusFilter" class="form-select w-auto shadow-sm border-0">
                            <option value="ALL">All Status</option>
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="card shadow border-0 rounded-4 flex-grow-1 overflow-hidden">
                    <div class="card-body p-0 table-container">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4 py-3">ID</th>
                                    <th>Product Name</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                    <th>Create At</th>
                                    <th class="text-center pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody id="productTableBody">
                                <%
                                    List<Product> list = (List<Product>) request.getAttribute("productList");
                                    DecimalFormat formatter = new DecimalFormat("#,### VNĐ");

                                    if (list != null && !list.isEmpty()) {
                                        for (Product item : list) {
                                            String status = item.getStatus() != null ? item.getStatus().toUpperCase() : "INACTIVE";
                                %>
                                <tr class="product-row" data-status="<%= status%>">
                                    <td class="ps-4 text-muted fw-bold">#<%= item.getProductId()%></td>

                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-light rounded d-flex justify-content-center align-items-center me-3" style="width: 40px; height: 40px;">
                                                <i class="fa-solid fa-cube text-secondary"></i>
                                            </div>
                                            <strong class="text-primary product-name"><%= (item.getProductName() != null) ? item.getProductName() : ""%></strong>
                                        </div>
                                    </td>

                                    <td class="fw-bold text-success"><%= (item.getPrice() != null) ? formatter.format(item.getPrice()) : "0 VNĐ"%></td>

                                    <td>
                                        <% if ("ACTIVE".equals(status)) { %>
                                        <span class="custom-badge badge-active"><i class="fa-solid fa-check-circle me-1"></i>ACTIVE</span>
                                        <% } else {%>
                                        <span class="custom-badge badge-inactive"><i class="fa-solid fa-ban me-1"></i><%= status%></span>
                                        <% }%>
                                    </td>

                                    <td class="text-muted"><%= (item.getCreatedAt() != null) ? item.getCreatedAt() : ""%></td>

                                    <td class="text-center pe-4">
                                        <a href="<%=request.getContextPath()%>/ProductController/Form?productId=<%= item.getProductId()%>" class="action-btn btn-update me-1"><i class="fa-solid fa-pen-to-square me-1"></i> Update</a>
                                        <a href="<%=request.getContextPath()%>/ProductController/Delete?productId=<%= item.getProductId()%>" class="action-btn btn-delete" onclick="return confirm('Are you sure want to delete product: <%= item.getProductName()%>? This action cannot be undone!')"><i class="fa-solid fa-trash me-1"></i> Delete</a>
                                    </td>
                                </tr>
                                <%      }
                                } else {
                                %>
                                <tr id="noDataRow">
                                    <td colspan="6" class="text-center text-muted py-5">
                                        <i class="fa-solid fa-box-open mb-3" style="font-size: 40px; color: #dee2e6;"></i><br>
                                        <h5>No products have been created yet!</h5>
                                        <p class="mb-0">Create a new product by clicking "New Product".</p>
                                    </td>
                                </tr>
                                <%  }%>
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
                if (toggleBtn && sidebar) {
                    toggleBtn.addEventListener("click", function () {
                        sidebar.classList.toggle("collapsed");
                    });
                }

                const searchInput = document.getElementById("productSearch");
                const statusFilter = document.getElementById("statusFilter");
                const productRows = document.querySelectorAll(".product-row");

                function filterTable() {
                    const searchTerm = searchInput.value.toLowerCase().trim();
                    const selectedStatus = statusFilter.value;

                    productRows.forEach(row => {
                        const rowStatus = row.getAttribute("data-status");
                        const productName = row.querySelector(".product-name").innerText.toLowerCase();

                        const matchStatus = (selectedStatus === "ALL" || rowStatus === selectedStatus);
                        const matchSearch = productName.includes(searchTerm);

                        if (matchStatus && matchSearch) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                }

                if (searchInput) searchInput.addEventListener("keyup", filterTable);
                if (statusFilter) statusFilter.addEventListener("change", filterTable);
            });
        </script>
    </body>
</html>
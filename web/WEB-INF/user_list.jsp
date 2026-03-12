<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<% List<User> userList = (List<User>) request.getAttribute("userList");%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User Management</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body, html {
                height: 100vh; /* Khóa cuộn toàn trang */
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
                overflow: hidden; /* Tránh sinh ra thanh cuộn phụ ở nội dung */
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
            .btn-add {
                display: inline-block;
                padding: 10px 25px;
                background-color: #1f6feb;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-weight: 500;
                transition: 0.3s;
            }
            .btn-add:hover {
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
                display: inline-block;
            }
            .btn-edit { background-color: #fbbc04; color: white; }
            .btn-edit:hover { background-color: #e3a903; color: white; }
            .btn-delete { background-color: #d93025; color: white; }
            .btn-delete:hover { background-color: #c02a20; color: white; }

            .custom-badge {
                padding: 6px 12px;
                border-radius: 50px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .badge-admin { background-color: #e8f0fe; color: #1f6feb; }
            .badge-staff { background-color: #e6f4ea; color: #188038; }
            .badge-auditor { background-color: #fff4e5; color: #f9a825; }
            .badge-active { background-color: #e6f4ea; color: #188038; }
            .badge-locked { background-color: #ffecec; color: #d93025; }

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
                        <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-users me-2"></i>User Management</h2>
                    </div>
                    <a href="<%=request.getContextPath()%>/UserController/Add" class="text-decoration-none">
                        <button class="btn btn-add shadow-sm"><i class="fa-solid fa-user-plus me-1"></i> Create User</button>
                    </a>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3 flex-shrink-0">
                    <div class="input-group search-box shadow-sm w-auto">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" id="userSearch" class="form-control border-start-0 ps-0" placeholder="Search Username...">
                    </div>

                    <div class="d-flex align-items-center gap-3">
                        <div class="d-flex align-items-center gap-2">
                            <label for="roleFilter" class="fw-semibold text-secondary mb-0">Role:</label>
                            <select id="roleFilter" class="form-select w-auto shadow-sm border-0">
                                <option value="ALL">All Roles</option>
                                <option value="ADMIN">Admin</option>
                                <option value="AUDITOR">Auditor</option>
                                <option value="STAFF">Staff</option>
                            </select>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <label for="statusFilter" class="fw-semibold text-secondary mb-0">Status:</label>
                            <select id="statusFilter" class="form-select w-auto shadow-sm border-0">
                                <option value="ALL">All Status</option>
                                <option value="ACTIVE">Active</option>
                                <option value="LOCKED">Locked</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="card shadow border-0 rounded-4 flex-grow-1 overflow-hidden">
                    <div class="card-body p-0 table-container">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4 py-3">ID</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th class="text-center pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody id="userTableBody">
                                <% if (userList != null && !userList.isEmpty()) {
                                        for (User u : userList) {
                                            String role = u.getRole() != null ? u.getRole().toUpperCase() : "STAFF";
                                            String status = u.getStatus() != null ? u.getStatus().toUpperCase() : "LOCKED";
                                %>
                                <tr class="user-row" data-role="<%= role%>" data-status="<%= status%>">
                                    <td class="ps-4 text-muted fw-bold">#<%=u.getUserId()%></td>

                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-light rounded-circle d-flex justify-content-center align-items-center me-3" style="width: 35px; height: 35px;">
                                                <i class="fa-solid fa-user text-secondary"></i>
                                            </div>
                                            <strong class="username-text"><%=u.getUsername()%></strong>
                                        </div>
                                    </td>

                                    <td>
                                        <% if ("ADMIN".equals(role)) { %><span class="custom-badge badge-admin"><i class="fa-solid fa-crown me-1"></i>ADMIN</span>
                                        <% } else if ("AUDITOR".equals(role)) { %><span class="custom-badge badge-auditor"><i class="fa-solid fa-eye me-1"></i>AUDITOR</span>
                                        <% } else { %><span class="custom-badge badge-staff"><i class="fa-solid fa-user-pen me-1"></i>STAFF</span><% } %>
                                    </td>

                                    <td>
                                        <% if ("ACTIVE".equals(status)) { %><span class="custom-badge badge-active"><i class="fa-solid fa-check-circle me-1"></i>ACTIVE</span>
                                        <% } else { %><span class="custom-badge badge-locked"><i class="fa-solid fa-lock me-1"></i>LOCKED</span><% }%>
                                    </td>

                                    <td class="text-muted"><%=u.getCreatedAt()%></td>

                                    <td class="text-center pe-4">
                                        <a href="<%=request.getContextPath()%>/UserController/Edit?id=<%=u.getUserId()%>" class="action-btn btn-edit me-1"><i class="fa-solid fa-pen"></i> Edit</a>
                                        <a href="<%=request.getContextPath()%>/UserController/Delete?id=<%=u.getUserId()%>" class="action-btn btn-delete" onclick="return confirm('⚠️ Warning: Are you sure you want to delete this account: <%=u.getUsername()%>? This action cannot be undone!');"><i class="fa-solid fa-trash"></i> Delete</a>
                                    </td>
                                </tr>
                                <% }
                                } else { %>
                                <tr id="noDataRow">
                                    <td colspan="6" class="text-center text-muted py-5">
                                        <i class="fa-solid fa-users-slash mb-3" style="font-size: 40px; color: #dee2e6;"></i><br>
                                        <h5>No Data</h5>
                                        <p class="mb-0">No users have been created in the system yet.</p>
                                    </td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Đóng mở Sidebar
                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar");
                if (toggleBtn && sidebar) {
                    toggleBtn.addEventListener("click", function () {
                        sidebar.classList.toggle("collapsed");
                    });
                }

                // Elements cho Filter và Search
                const roleFilter = document.getElementById("roleFilter");
                const statusFilter = document.getElementById("statusFilter");
                const searchInput = document.getElementById("userSearch");
                const userRows = document.querySelectorAll(".user-row");

                // Hàm thực thi bộ lọc 3 lớp (Role + Status + Search Username)
                function filterTable() {
                    const selectedRole = roleFilter.value;
                    const selectedStatus = statusFilter.value;
                    const searchTerm = searchInput.value.toLowerCase().trim();

                    userRows.forEach(row => {
                        const rowRole = row.getAttribute("data-role");
                        const rowStatus = row.getAttribute("data-status");
                        const username = row.querySelector(".username-text").innerText.toLowerCase();

                        // Kiểm tra điều kiện
                        const matchRole = (selectedRole === "ALL" || rowRole === selectedRole);
                        const matchStatus = (selectedStatus === "ALL" || rowStatus === selectedStatus);
                        const matchSearch = username.includes(searchTerm);

                        // Chỉ hiện dòng khi thỏa mãn cả 3 điều kiện
                        if (matchRole && matchStatus && matchSearch) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                }

                // Lắng nghe sự kiện
                if (roleFilter)
                    roleFilter.addEventListener("change", filterTable);
                if (statusFilter)
                    statusFilter.addEventListener("change", filterTable);
                if (searchInput)
                    searchInput.addEventListener("keyup", filterTable);
            });
        </script>
    </body>
</html>
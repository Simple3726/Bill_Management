<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Shift" %>
<% List<Shift> shiftList = (List<Shift>) request.getAttribute("shiftList");%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Shift List - Bill Manager</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body, html {
                height: 100vh; /* Khóa cuộn toàn trang */
                margin: 0;
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                overflow: hidden; /* Ẩn thanh cuộn mặc định */
            }

            /* SIDEBAR STYLES */
            .sidebar {
                width: 260px;
                background-color: #212529;
                color: white;
                height: 100vh;
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

            /* Main Content Flexbox Layout */
            .main-content {
                transition: all 0.3s ease-in-out;
                width: 100%;
                height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* BẢNG & THANH CUỘN (SCROLLBAR) */
            .table-container {
                flex-grow: 1; /* Choán hết không gian còn lại */
                overflow-y: auto; /* Cuộn dọc */
                max-height: calc(100vh - 200px); /* Giới hạn chiều cao */
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

            /* BADGES & BUTTONS */
            .custom-badge {
                padding: 6px 12px;
                border-radius: 50px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .badge-open {
                background-color: #e6f4ea;
                color: #188038;
            }
            .badge-closed {
                background-color: #f1f3f4;
                color: #5f6368;
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
            .btn-log {
                background-color: #0dcaf0;
                color: #000;
            }
            .btn-log:hover {
                background-color: #0bacce;
                color: #000;
            }
            .btn-edit {
                background-color: #fbbc04;
                color: white;
            }
            .btn-edit:hover {
                background-color: #e3a903;
                color: white;
            }

            .search-box {
                min-width: 220px;
            }
        </style>
    </head>
    <body>

        <div class="d-flex w-100">
            <jsp:include page="/WEB-INF/sidebar.jsp" />

            <div class="p-4 main-content">

                <div class="d-flex justify-content-between align-items-center mb-4 flex-shrink-0">
                    <div class="d-flex align-items-center">
                        <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
                        <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2"></i>Shift History</h2>
                    </div>
                </div>

                <div class="card shadow-sm border-0 mb-3 p-3 rounded-4 bg-white flex-shrink-0">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">

                        <form action="<%=request.getContextPath()%>/ShiftController" method="GET" class="row g-2 align-items-center m-0">
                            <input type="hidden" name="action" value="list">
                            <div class="col-auto">
                                <label class="col-form-label fw-bold text-secondary"><i class="fa-regular fa-calendar-days me-1"></i> From:</label>
                            </div>
                            <div class="col-auto">
                                <input type="date" name="startDate" class="form-control" 
                                       value="<%= request.getAttribute("startDate") != null ? request.getAttribute("startDate") : ""%>" required>
                            </div>
                            <div class="col-auto">
                                <label class="col-form-label fw-bold text-secondary ms-2">To:</label>
                            </div>
                            <div class="col-auto">
                                <input type="date" name="endDate" class="form-control" 
                                       value="<%= request.getAttribute("endDate") != null ? request.getAttribute("endDate") : ""%>" required>
                            </div>
                            <div class="col-auto ms-2">
                                <button type="submit" class="btn btn-primary fw-bold px-3"><i class="fa-solid fa-filter"></i> Date Filter</button>
                                <a href="<%=request.getContextPath()%>/ShiftController?action=list" class="btn btn-light border px-3" title="Clear Date Filter">
                                    <i class="fa-solid fa-rotate-right"></i>
                                </a>
                            </div>
                        </form>

                        <div class="d-flex align-items-center gap-2">
                            <div class="input-group search-box shadow-sm">
                                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                <input type="text" id="shiftSearch" class="form-control border-start-0 ps-0" placeholder="User ID or Shift ID...">
                            </div>
                            <select id="statusFilter" class="form-select w-auto shadow-sm border-0">
                                <option value="ALL">All Status</option>
                                <option value="OPEN">Open</option>
                                <option value="CLOSED">Closed</option>
                            </select>
                        </div>

                    </div>
                </div>

                <% String msg = (String) session.getAttribute("message");
                    if (msg != null) {%>
                <div class="alert alert-success d-flex align-items-center flex-shrink-0 shadow-sm" role="alert">
                    <i class="fa-solid fa-check-circle me-2"></i><div><%= msg%></div>
                </div>
                <% session.removeAttribute("message");
                    } %>

                <% String err = (String) session.getAttribute("error");
                    if (err != null) {%>
                <div class="alert alert-danger d-flex align-items-center flex-shrink-0 shadow-sm" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i><div><%= err%></div>
                </div>
                <% session.removeAttribute("error");
                    } %>

                <div class="card shadow border-0 rounded-4 flex-grow-1 overflow-hidden">
                    <div class="card-body p-0 table-container">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4 py-3">Shift ID</th>
                                    <th>User ID</th>
                                    <th>Start Time</th>
                                    <th>End Time</th>
                                    <th>Status</th>
                                    <th class="text-center pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody id="shiftTableBody">
                                <% if (shiftList != null && !shiftList.isEmpty()) {
                                        for (Shift s : shiftList) {
                                            String status = s.getStatus() != null ? s.getStatus().toUpperCase() : "CLOSED";
                                %>
                                <tr class="shift-row" data-status="<%= status%>">
                                    <td class="ps-4 text-muted fw-bold search-id">#<%=s.getShiftId()%></td>
                                    <td class="fw-bold text-dark search-user"><i class="fa-solid fa-user me-2 text-secondary"></i><%=s.getUserId()%></td>
                                    <td><%=s.getStartTime()%></td>
                                    <td><%= (s.getEndTime() != null) ? s.getEndTime() : "<span class='text-muted fst-italic'>On going</span>"%></td>
                                    <td>
                                        <% if ("OPEN".equals(status)) { %>
                                        <span class="custom-badge badge-open"><i class="fa-solid fa-spinner fa-spin me-1"></i>OPEN</span>
                                        <% } else { %>
                                        <span class="custom-badge badge-closed"><i class="fa-solid fa-lock me-1"></i>CLOSED</span>
                                        <% }%>
                                    </td>
                                    <td class="text-center pe-4">
                                        <a href="<%=request.getContextPath()%>/ShiftController?action=view_log&id=<%=s.getShiftId()%>" class="action-btn btn-log me-1"><i class="fa-solid fa-clipboard-list"></i> Logs</a>
                                        <a href="<%=request.getContextPath()%>/ShiftController?action=edit&id=<%=s.getShiftId()%>" class="action-btn btn-edit me-1"><i class="fa-solid fa-pen"></i> Edit</a>
                                    </td>
                                </tr>
                                <% }
                                } else { %>
                                <tr id="noDataRow">
                                    <td colspan="6" class="text-center text-muted py-5">
                                        <i class="fa-solid fa-clock mb-3" style="font-size: 40px; color: #dee2e6;"></i><br>
                                        <h5>No Data</h5><p class="mb-0">No work shift has been recorded yet.</p>
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

                // Xử lý bộ lọc tìm kiếm nhanh Client-side
                const searchInput = document.getElementById("shiftSearch");
                const statusFilter = document.getElementById("statusFilter");
                const shiftRows = document.querySelectorAll(".shift-row");

                function filterTable() {
                    const searchTerm = searchInput.value.toLowerCase().trim();
                    const selectedStatus = statusFilter.value;

                    shiftRows.forEach(row => {
                        // Lấy dữ liệu để so sánh
                        const rowStatus = row.getAttribute("data-status");
                        const shiftId = row.querySelector(".search-id").innerText.toLowerCase();
                        const userId = row.querySelector(".search-user").innerText.toLowerCase();

                        // Match điều kiện
                        const matchStatus = (selectedStatus === "ALL" || rowStatus === selectedStatus);
                        const matchSearch = shiftId.includes(searchTerm) || userId.includes(searchTerm);

                        // Hiển thị hoặc ẩn
                        if (matchStatus && matchSearch) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                }

                if (searchInput)
                    searchInput.addEventListener("keyup", filterTable);
                if (statusFilter)
                    statusFilter.addEventListener("change", filterTable);
            });
        </script>
    </body>
</html>
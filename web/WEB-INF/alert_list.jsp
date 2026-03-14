<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Alert" %>

<% List<Alert> alertList = (List<Alert>) request.getAttribute("alertList"); %>
<!DOCTYPE html>
<html>
    <head>
        <title>Alert Management</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body, html {
                height: 100vh; /* Khóa cứng chiều cao trang 100% màn hình */
                margin: 0;
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                overflow: hidden; /* Ẩn hoàn toàn thanh cuộn của toàn trang */
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

            /* Main Content chia layout dọc để ép bảng cuộn */
            .main-content {
                transition: all 0.3s ease-in-out;
                width: 100%;
                height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* BẢNG & THANH CUỘN (SCROLLBAR) */
            .table-container {
                flex-grow: 1; /* Tự động lấp đầy khoảng trống còn lại */
                overflow-y: auto; /* Bật cuộn dọc cho riêng bảng */
                max-height: calc(100vh - 160px); /* Trừ đi phần Header và Margin */
            }

            /* Làm đẹp thanh cuộn */
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

            /* Cố định Header của bảng (Sticky Header) */
            .table-dark th {
                position: sticky;
                top: 0;
                z-index: 2;
                background-color: #212529; /* Tránh bị trong suốt khi cuộn */
                box-shadow: 0 2px 2px -1px rgba(0, 0, 0, 0.4);
            }

            /* BADGE & BUTTON STYLES */
            .custom-badge {
                padding: 6px 14px;
                border-radius: 50px;
                font-size: 13px;
                font-weight: 600;
                display: inline-block;
            }
            .badge-new {
                background-color: #ffecec;
                color: #d93025;
            }
            .badge-investigating {
                background-color: #fff4e5;
                color: #f9a825;
            }
            .badge-resolved {
                background-color: #e6f4ea;
                color: #188038;
            }

            .action-btn {
                padding: 6px 14px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                text-decoration: none;
                transition: opacity 0.2s;
                display: inline-block;
            }
            .btn-investigate {
                background-color: #fbbc04;
                color: white;
            }
            .btn-investigate:hover {
                opacity: 0.85;
                color: white;
            }

            .search-box {
                min-width: 230px;
            }
        </style>
    </head>
    <body>

        <div class="d-flex w-100">
            <jsp:include page="/WEB-INF/sidebar.jsp" />

            <div class="p-4 main-content">
                <div class="d-flex align-items-center mb-4 flex-shrink-0">
                    <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
                    <h2 class="text-danger mb-0 fw-bold"><i class="fa-solid fa-triangle-exclamation me-2"></i>Alert List</h2>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3 flex-shrink-0">
                    <div class="input-group search-box shadow-sm">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" id="alertSearch" class="form-control border-start-0 ps-0" placeholder="Search Entity ID...">
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <label for="alertStatusFilter" class="fw-semibold text-secondary mb-0 px-2">Filter by Status:</label>
                        <select id="alertStatusFilter" class="form-select w-auto shadow-sm border-0">
                            <option value="ALL">All Alerts</option>
                            <option value="NEW">New</option>
                            <option value="RESOLVED">Resolved</option>
                        </select>
                    </div>
                </div>

                <div class="card shadow border-0 rounded-4 flex-grow-1 overflow-hidden">
                    <div class="card-body p-0 table-container">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4 py-3">ID</th>
                                    <th>Entity Type</th>
                                    <th>Entity ID</th>
                                    <th>Risk Score</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th class="pe-4 text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody id="alertTableBody">
                                <% if (alertList != null && !alertList.isEmpty()) {
                                        for (Alert alert : alertList) {
                                            String status = alert.getStatus() != null ? alert.getStatus().toUpperCase() : "UNKNOWN";

                                            double riskScore = 0;
                                            try {
                                                riskScore = Double.parseDouble(String.valueOf(alert.getRiskScore()));
                                            } catch (Exception e) {
                                            }

                                            String scoreColor = "text-success";
                                            if (riskScore >= 80)
                                                scoreColor = "text-danger";
                                            else if (riskScore >= 50)
                                                scoreColor = "text-warning text-dark";
                                %>
                                <tr class="alert-row" data-status="<%= status%>">
                                    <td class="ps-4 text-muted">#<%= alert.getAlertId()%></td>
                                    <td><span class="badge bg-secondary"><%= alert.getEntityType()%></span></td>
                                    <td class="fw-bold entity-id"><%= alert.getEntityId()%></td>
                                    <td class="<%= scoreColor%> fw-bold"><%= alert.getRiskScore()%></td>
                                    <td>
                                        <% if ("NEW".equals(status)) { %>
                                        <span class="custom-badge badge-new"><i class="fa-solid fa-circle-exclamation me-1"></i>NEW</span>
                                        <% } else if ("INVESTIGATING".equals(status)) { %>
                                        <span class="custom-badge badge-investigating"><i class="fa-solid fa-magnifying-glass me-1"></i>INVESTIGATING</span>
                                        <% } else if ("RESOLVED".equals(status)) { %>
                                        <span class="custom-badge badge-resolved"><i class="fa-solid fa-check-circle me-1"></i>RESOLVED</span>
                                        <% } else {%>
                                        <span class="custom-badge bg-secondary text-white"><%= status%></span>
                                        <% }%>
                                    </td>
                                    <td><%= alert.getCreatedAt()%></td>
                                    <td class="pe-4 text-center">
                                        <% if ("NEW".equals(status) || "INVESTIGATING".equals(status)) {%>
                                        <a href="<%=request.getContextPath()%>/AlertController?action=investigate&alertId=<%=alert.getAlertId()%>" class="action-btn btn-investigate">
                                            <i class="fa-solid fa-magnifying-glass"></i> Investigate
                                        </a>
                                        <% } else { %>
                                        <span class="text-muted small"><i class="fa-solid fa-check"></i> Done</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <%      }
                                } else { %>
                                <tr id="noDataRow">
                                    <td colspan="7" class="text-center text-muted py-5">
                                        <i class="fa-solid fa-shield-check mb-3" style="font-size: 40px; color: #2ea44f;"></i><br>
                                        <h5>The system is secure</h5>
                                        <p class="mb-0">No alerts need to be investigated.</p>
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
                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar");
                if (toggleBtn && sidebar) {
                    toggleBtn.addEventListener("click", function () {
                        sidebar.classList.toggle("collapsed");
                    });
                }

                const statusFilter = document.getElementById("alertStatusFilter");
                const searchInput = document.getElementById("alertSearch");
                const alertRows = document.querySelectorAll(".alert-row");

                function filterTable() {
                    const selectedStatus = statusFilter.value;
                    const searchTerm = searchInput.value.toLowerCase().trim();

                    alertRows.forEach(row => {
                        const rowStatus = row.getAttribute("data-status");
                        const entityId = row.querySelector(".entity-id").innerText.toLowerCase();

                        const matchStatus = (selectedStatus === "ALL" || rowStatus === selectedStatus);
                        const matchSearch = entityId.includes(searchTerm);

                        if (matchStatus && matchSearch) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                }

                if (statusFilter)
                    statusFilter.addEventListener("change", filterTable);
                if (searchInput)
                    searchInput.addEventListener("keyup", filterTable);
            });
        </script>
    </body>
</html>
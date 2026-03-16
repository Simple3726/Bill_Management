<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="entity.Alert"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Map<String, Object>> results
            = (List<Map<String, Object>>) request.getAttribute("fraudResults");

    List<Alert> alertList
            = (List<Alert>) request.getAttribute("alertList");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Alert Management</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>

            body, html{
                height:100vh;
                margin:0;
                font-family:'Inter',sans-serif;
                background:#f4f6f9;
                overflow:hidden;
            }

            /* SIDEBAR */

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

            /* MAIN */

            .main-content{
                height:100vh;
                display:flex;
                flex-direction:column;
                width:100%;
            }

            .table-container{
                flex-grow:1;
                overflow-y:auto;
            }

            .table-dark th{
                position:sticky;
                top:0;
                z-index:2;
                background:#212529;
            }

            /* BADGES */

            .custom-badge{
                padding:6px 14px;
                border-radius:50px;
                font-size:13px;
                font-weight:600;
            }

            .badge-new{
                background:#ffecec;
                color:#d93025;
            }

            .badge-investigating{
                background:#fff4e5;
                color:#f9a825;
            }

            .badge-resolved{
                background:#e6f4ea;
                color:#188038;
            }

            /* BUTTON */

            .action-btn{
                padding:6px 14px;
                border-radius:8px;
                border:none;
                font-size:13px;
                font-weight:500;
                text-decoration:none;
            }

            .btn-investigate{
                background:#fbbc04;
                color:white;
            }

            .search-box{
                min-width:230px;
            }

            #sidebarToggle{
                background:none;
                border:none;
                font-size:22px;
                cursor:pointer;
                padding-right:15px;
            }

        </style>
    </head>

    <body>

        <div class="d-flex w-100">

            <jsp:include page="/WEB-INF/sidebar.jsp" />

            <div class="p-4 main-content">

                <!-- HEADER -->

                <div class="d-flex align-items-center mb-4">
                    <button id="sidebarToggle">
                        <i class="fa-solid fa-bars"></i>
                    </button>

                    <h2 class="text-danger fw-bold mb-0">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>
                        Fraud Alert Management
                    </h2>
                </div>

                <!-- CHECK FRAUD -->

                <div class="mb-4">

                    <form action="AlertController" method="post">

                        <input type="hidden" name="action" value="checkFraud">

                        <button class="btn btn-danger px-4 fw-bold shadow-sm">

                            <i class="fa-solid fa-magnifying-glass-chart me-2"></i>

                            Check Fraud By RandomForest model

                        </button>

                    </form>

                </div>

                <!-- FRAUD RESULT -->

                <% if (results != null && !results.isEmpty()) { %>
                <div class="card shadow border-0 rounded-4 mb-4">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h5 class="text-danger fw-bold mb-0">
                            <i class="fa-solid fa-shield-virus me-2"></i>
                            Fraud Detection Results
                        </h5>
                        <button class="btn btn-sm btn-outline-secondary rounded-circle toggleFraudBtn"
                                type="button"
                                data-bs-toggle="collapse"
                                data-bs-target="#collapseFraudTable"
                                aria-expanded="true">
                            <i class="fa-solid fa-chevron-up"></i>
                        </button>
                    </div>

                    <div class="collapse show" id="collapseFraudTable">
                        <div class="card-body pt-0">
                            <table class="table table-hover align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th style="width: 50%;">Invoice ID</th>
                                        <th>Fraud Risk Score (Prediction)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> item : results) {
                                            String fullScore = String.valueOf(item.get("score")).toLowerCase().trim();
                                            String displayColor = fullScore.contains("yes") ? "text-danger" : "text-primary";

                                            String finalDisplay = fullScore;
                                            if (fullScore.contains("/")) {
                                                String[] parts = fullScore.split("/");
                                                String label = parts[0].trim();
                                                try {
                                                    double val = Double.parseDouble(parts[1].trim());
                                                    finalDisplay = label.toUpperCase() + " / " + String.format("%.2f", val);
                                                } catch (Exception e) {
                                                    finalDisplay = fullScore;
                                                }
                                            }
                                    %>
                                    <tr>
                                        <td>#<%= item.get("id")%></td>
                                        <td class="<%= displayColor%> fw-bold text-uppercase">
                                            <i class="fa-solid <%= fullScore.contains("yes") ? "fa-circle-exclamation" : "fa-circle-check"%> me-1"></i>
                                            <%= finalDisplay%>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- FILTER + SEARCH -->

                <div class="d-flex justify-content-between align-items-center mb-3">

                    <div class="input-group search-box shadow-sm">

                        <span class="input-group-text bg-white border-end-0">
                            <i class="fa-solid fa-magnifying-glass text-muted"></i>
                        </span>

                        <input type="text"
                               id="alertSearch"
                               class="form-control border-start-0 ps-0"
                               placeholder="Search Entity ID...">

                    </div>

                    <div class="d-flex align-items-center gap-2">

                        <label class="fw-semibold text-secondary mb-0 px-2">

                            Filter by Status:

                        </label>

                        <select id="alertStatusFilter"
                                class="form-select w-auto shadow-sm border-0">

                            <option value="ALL">All Alerts</option>
                            <option value="NEW">New</option>
                            <option value="RESOLVED">Resolved</option>

                        </select>

                    </div>

                </div>

                <!-- ALERT TABLE -->

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

                                            String status = alert.getStatus().toUpperCase();

                                            double riskScore = 0;

                                            try {
                                                riskScore = Double.parseDouble(String.valueOf(alert.getRiskScore()));
                                            } catch (Exception e) {
                                            }

                                            String scoreColor = "text-success";

                                            if (riskScore >= 80) {
                                                scoreColor = "text-danger";
                                            } else if (riskScore >= 50) {
                                                scoreColor = "text-warning";
                                            }

                                %>

                                <tr class="alert-row" data-status="<%=status%>">

                                    <td class="ps-4 text-muted">#<%=alert.getAlertId()%></td>

                                    <td>
                                        <span class="badge bg-secondary">
                                            <%=alert.getEntityType()%>
                                        </span>
                                    </td>

                                    <td class="fw-bold entity-id">
                                        <%=alert.getEntityId()%>
                                    </td>

                                    <td class="<%=scoreColor%> fw-bold">
                                        <%=alert.getRiskScore()%>
                                    </td>

                                    <td>

                                        <% if ("NEW".equals(status)) { %>

                                        <span class="custom-badge badge-new">
                                            NEW
                                        </span>

                                        <% } else if ("INVESTIGATING".equals(status)) { %>

                                        <span class="custom-badge badge-investigating">
                                            INVESTIGATING
                                        </span>

                                        <% } else if ("RESOLVED".equals(status)) { %>

                                        <span class="custom-badge badge-resolved">
                                            RESOLVED
                                        </span>

                                        <% }%>

                                    </td>

                                    <td><%=alert.getCreatedAt()%></td>

                                    <td class="pe-4 text-center">

                                        <% if ("NEW".equals(status) || "INVESTIGATING".equals(status)) {%>

                                        <a href="<%=request.getContextPath()%>/AlertController?action=investigate&alertId=<%=alert.getAlertId()%>"
                                           class="action-btn btn-investigate">

                                            <i class="fa-solid fa-magnifying-glass"></i>
                                            Investigate

                                        </a>

                                        <% } else { %>

                                        <span class="text-muted small">
                                            Done
                                        </span>

                                        <% } %>

                                    </td>

                                </tr>

                                <% }
                                } else { %>

                                <tr>

                                    <td colspan="7" class="text-center text-muted py-5">

                                        <i class="fa-solid fa-shield-check mb-3"
                                           style="font-size:40px;color:#2ea44f;"></i>

                                        <h5>The system is secure</h5>

                                        <p>No alerts need investigation</p>

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

                const collapseElement = document.getElementById("collapseFraudTable");
                const toggleBtn = document.querySelector(".toggleFraudBtn i");

                if (collapseElement && toggleBtn) {

                    collapseElement.addEventListener("show.bs.collapse", function () {
                        toggleBtn.classList.remove("fa-chevron-down");
                        toggleBtn.classList.add("fa-chevron-up");
                    });

                    collapseElement.addEventListener("hide.bs.collapse", function () {
                        toggleBtn.classList.remove("fa-chevron-up");
                        toggleBtn.classList.add("fa-chevron-down");
                    });

                }

            });
            document.addEventListener("DOMContentLoaded", function () {

                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar");

                if (toggleBtn && sidebar) {
                    toggleBtn.onclick = () => sidebar.classList.toggle("collapsed");
                }

                const statusFilter = document.getElementById("alertStatusFilter");
                const searchInput = document.getElementById("alertSearch");
                const alertRows = document.querySelectorAll(".alert-row");

                function filterTable() {

                    const status = statusFilter.value;
                    const search = searchInput.value.toLowerCase();

                    alertRows.forEach(row => {

                        const rowStatus = row.dataset.status;
                        const entity = row.querySelector(".entity-id").innerText.toLowerCase();

                        const matchStatus = (status === "ALL" || rowStatus === status);
                        const matchSearch = entity.includes(search);

                        row.style.display = (matchStatus && matchSearch) ? "" : "none";

                    });

                }

                statusFilter.addEventListener("change", filterTable);
                searchInput.addEventListener("keyup", filterTable);

            });

        </script>

    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</html>
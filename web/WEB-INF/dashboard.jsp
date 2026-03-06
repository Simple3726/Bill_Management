<%-- 
    Document   : dashboard
    Created on : Feb 25, 2026, 2:29:09 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="entity.User" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // Lấy dữ liệu Dashboard
    Map<String, Object> data = (Map<String, Object>) request.getAttribute("dashboardData");
    String period = (String) request.getAttribute("period");
    if (period == null) {
        period = "today";
    }

    // Lấy thông tin User hiện tại từ Session
    User currentUser = (User) session.getAttribute("user");
    String role = (currentUser != null) ? currentUser.getRole() : "";
%>
<%
    DecimalFormat formatter = new DecimalFormat("#,###");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>System Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            body, html {
                height: 100%;
                margin: 0;
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                overflow-x: hidden;
            }

            /* === SIDEBAR STYLES (Đồng bộ với List) === */
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

            .main-content {
                transition: all 0.3s ease-in-out;
                width: 100%;
            }

            /* === DASHBOARD CUSTOM STYLES === */
            .filter-select {
                padding: 8px 16px;
                border-radius: 8px;
                border: 1px solid #ced4da;
                font-weight: 500;
                color: #495057;
                outline: none;
                cursor: pointer;
            }

            /* Thẻ Summary Box */
            .summary-box {
                background: #ffffff;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.03);
                position: relative;
                overflow: hidden;
                border: 1px solid rgba(0,0,0,0.05);
                height: 100%;
            }
            .summary-box h4 {
                font-size: 14px;
                color: #6c757d;
                font-weight: 600;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .summary-box h3 {
                font-size: 26px;
                font-weight: 700;
                color: #212529;
                margin: 0;
            }
            /* Icon mờ làm background cho thẻ Summary */
            .summary-box .bg-icon {
                position: absolute;
                right: -10px;
                bottom: -10px;
                font-size: 80px;
                color: rgba(0,0,0,0.03);
                transform: rotate(-15deg);
            }

            /* Chart Container */
            .chart-container {
                background: white;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.03);
                border: 1px solid rgba(0,0,0,0.05);
                height: 100%;
            }
            .chart-title {
                font-size: 16px;
                font-weight: 600;
                color: #495057;
                margin-bottom: 20px;
                text-align: center;
            }
        </style>
    </head>
    <body>

        <div class="d-flex min-vh-100">

            <div class="sidebar d-flex flex-column p-3 shadow" id="sidebar">
                <div class="text-center mb-4 mt-2 text-nowrap">
                    <h4 class="fw-bold text-white"><i class="fa-solid fa-chart-pie text-primary me-2"></i>Bill Manager</h4>
                </div>
                <hr class="text-secondary mb-4">

                <div class="text-center mb-4 text-nowrap">
                    <div class="user-avatar shadow">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <% if (currentUser != null) {%>
                    <h6 class="mb-1 fw-bold"><%= currentUser.getUsername()%></h6>
                    <small class="text-white-50"><i class="fa-solid fa-circle glow-online" style="font-size: 8px;"></i> Online</small>
                    <% } else { %>
                    <h6 class="mb-1 fw-bold">Guest</h6>
                    <% } %>
                </div>



                <div class="flex-grow-1 overflow-hidden">
                    <% if ("ADMIN".equals(role) || "AUDITOR".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/DashBoardController" class="sidebar-link mb-2">
                        <i class="fa-solid fa-file-invoice-dollar me-2"></i> Dashboard
                    </a>
                    <% } %>
                    <% if ("STAFF".equals(role) || "ADMIN".equals(role) || "AUDITOR".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/InvoiceController/List" class="sidebar-link mb-2">
                        <i class="fa-solid fa-file-invoice-dollar me-2"></i> Invoice Management
                    </a>
                    <% } %>

                    <% if ("AUDITOR".equals(role) || "ADMIN".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/AlertController" class="sidebar-link mb-2">
                        <i class="fa-solid fa-bell me-2"></i> Alert Management
                    </a>
                    <% } %>

                    <% if ("ADMIN".equals(role)) {%>
                    <a href="<%=request.getContextPath()%>/UserController/List" class="sidebar-link mb-2 text-warning">
                        <i class="fa-solid fa-users-gear me-2"></i> Quản lý User
                    </a>
                    <% }%>
                    <div class="mt-auto pt-3 border-top border-secondary overflow-hidden">
                    <a href="<%=request.getContextPath()%>/MenuController?action=Logout" class="btn btn-danger w-100 fw-bold text-nowrap">
                        <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                    </a>
                </div>
                </div>

                <div class="mt-auto pt-3 border-top border-secondary overflow-hidden">
                    <a href="<%=request.getContextPath()%>/MenuController?action=Logout" class="btn btn-danger w-100 fw-bold text-nowrap">
                        <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                    </a>
                </div>
            </div>
            <div class="flex-grow-1 p-4 main-content">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="d-flex align-items-center">
                        <button id="sidebarToggle" title="Đóng/Mở thanh công cụ">
                            <i class="fa-solid fa-bars"></i>
                        </button>
                        <h2 class="text-primary mb-0 fw-bold"><i class="fa-solid fa-chart-simple me-2"></i>System Dashboard</h2>
                    </div>

                    <div>
                        <form method="get" action="<%=request.getContextPath()%>/DashBoardController" class="m-0">
                            <select name="period" class="filter-select shadow-sm" onchange="this.form.submit()">
                                <option value="today" <%= period.equals("today") ? "selected" : ""%>>📅 Today</option>
                                <option value="week" <%= period.equals("week") ? "selected" : ""%>>📅 This Week</option>
                                <option value="month" <%= period.equals("month") ? "selected" : ""%>>📅 This Month</option>
                            </select>
                        </form>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>Total Revenue</h4>
                            <h3 class="text-success">$<%= formatter.format(data.get("TOTAL_REVENUE")) %></h3>
                            <i class="fa-solid fa-sack-dollar bg-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>Total Invoices</h4>
                            <h3 class="text-primary"><%= formatter.format(data.get("TOTAL_INVOICE")) %></h3>
                            <i class="fa-solid fa-file-invoice-dollar bg-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>Average Invoice</h4>
                            <h3>$<%= formatter.format(data.get("AVG_INVOICE")) %></h3>
                            <i class="fa-solid fa-chart-line bg-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>Risk Rate</h4>
                            <h3 class="text-danger"><%= String.format("%.2f", data.get("RISK_RATE"))%>%</h3>
                            <i class="fa-solid fa-triangle-exclamation bg-icon"></i>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>Total Alerts</h4>
                            <h3 class="text-warning"><%= data.get("TOTAL_ALERT")%></h3>
                            <i class="fa-solid fa-bell bg-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>New Alerts</h4>
                            <h3 class="text-danger"><%= data.get("NEW_ALERT")%></h3>
                            <i class="fa-solid fa-circle-exclamation bg-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>Total Shifts</h4>
                            <h3><%= data.get("TOTAL_SHIFT")%></h3>
                            <i class="fa-solid fa-clock bg-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="summary-box">
                            <h4>Active Staff</h4>
                            <h3 class="text-info"><%= data.get("ACTIVE_STAFF")%> <span class="text-muted fs-5">/ <%= data.get("TOTAL_STAFF")%></span></h3>
                            <i class="fa-solid fa-users bg-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="chart-container">
                            <div class="chart-title">Alert Status Distribution</div>
                            <canvas id="alertChart"></canvas>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="chart-container">
                            <div class="chart-title">Risk Analysis</div>
                            <canvas id="riskChart"></canvas>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="chart-container">
                            <div class="chart-title">Staff Activity</div>
                            <canvas id="staffChart"></canvas>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="chart-container">
                            <div class="chart-title">Invoice Alert Ratio</div>
                            <canvas id="invoiceChart"></canvas>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script>
            // Xử lý Sidebar Toggle
            document.addEventListener("DOMContentLoaded", function () {
                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar");

                toggleBtn.addEventListener("click", function () {
                    sidebar.classList.toggle("collapsed");
                });

                // ================= BIỂU ĐỒ CHART.JS =================

                new Chart(document.getElementById('alertChart'), {
                    type: 'pie',
                    data: {
                        labels: ['New', 'Investigating', 'Resolved'],
                        datasets: [{
                                data: [
            <%= data.get("NEW_ALERT")%>,
            <%= data.get("INVESTIGATING_ALERT")%>,
            <%= data.get("RESOLVED_ALERT")%>
                                ],
                                backgroundColor: ['#d93025', '#f9a825', '#188038']
                            }]
                    }
                });

                new Chart(document.getElementById('riskChart'), {
                    type: 'bar',
                    data: {
                        labels: ['Risk Rate'],
                        datasets: [{
                                label: 'Risk %',
                                data: [<%= data.get("RISK_RATE")%>],
                                backgroundColor: '#d93025'
                            }]
                    },
                    options: {scales: {y: {beginAtZero: true, max: 100}}}
                });

                new Chart(document.getElementById('staffChart'), {
                    type: 'doughnut',
                    data: {
                        labels: ['Active', 'Inactive'],
                        datasets: [{
                                data: [
            <%= data.get("ACTIVE_STAFF")%>,
            <%= (int) data.get("TOTAL_STAFF") - (int) data.get("ACTIVE_STAFF")%>
                                ],
                                backgroundColor: ['#188038', '#e9ecef']
                            }]
                    }
                });

                new Chart(document.getElementById('invoiceChart'), {
                    type: 'bar',
                    data: {
                        labels: ['Invoices', 'With Alert'],
                        datasets: [{
                                label: 'Count',
                                data: [
            <%= data.get("TOTAL_INVOICE")%>,
            <%= data.get("INVOICE_WITH_ALERT")%>
                                ],
                                backgroundColor: ['#1f6feb', '#d93025']
                            }]
                    },
                    options: {scales: {y: {beginAtZero: true}}}
                });
            });
        </script>

    </body>
</html>
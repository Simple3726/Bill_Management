<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Alert Management</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

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
        </style>
    </head>

    <body>
        <div class="d-flex min-vh-100">
            <jsp:include page="/WEB-INF/sidebar.jsp" />

            <div class="flex-grow-1 p-4 main-content">
                <div class="d-flex align-items-center mb-4">
                    <button id="sidebarToggle" title="Toggle Sidebar">
                        <i class="fa-solid fa-bars"></i>
                    </button>
                    <h2 class="text-danger mb-0 fw-bold">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>Fraud Alert List
                    </h2>
                </div>

                <div class="table-card">
                    <form action="AlertController" method="post" class="mb-4">
                        <input type="hidden" name="action" value="checkFraud">
                        <button class="btn btn-danger px-4 fw-bold shadow-sm">
                            <i class="fa-solid fa-magnifying-glass-chart me-2"></i>Check Fraud
                        </button>
                    </form>

                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th style="width: 40%">Invoice ID</th>
                                <th>Fraud Risk Score</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String, Object>> results = (List<Map<String, Object>>) request.getAttribute("fraudResults");
                                if (results != null && !results.isEmpty()) {
                                    for (Map<String, Object> item : results) {
                            %>
                            <tr>
                                <td class="fw-medium text-secondary">#<%= item.get("id")%></td>
                                <td>
                                    <span class="badge bg-danger p-2" style="font-size: 0.9rem;">
                                        <i class="fa-solid fa-shield-virus me-1"></i> <%= item.get("score")%>
                                    </span>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="2" class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-inbox fa-2x mb-2 d-block"></i>
                                    No fraud data returned. Click "Check Fraud" to analyze.
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar"); // ID 'sidebar' này nằm trong file sidebar.jsp

                if (toggleBtn && sidebar) {
                    toggleBtn.addEventListener("click", function () {
                        sidebar.classList.toggle("collapsed");
                    });
                }
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
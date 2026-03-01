<%-- 
    Document   : dashboard
    Created on : Feb 25, 2026, 2:29:09 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>

<%
    Map<String, Object> data = (Map<String, Object>) request.getAttribute("dashboardData");
    String period = (String) request.getAttribute("period");
    if (period == null)
        period = "today";
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 30px;
            }

            .container {
                max-width: 1200px;
                margin: auto;
            }

            .card {
                background: white;
                border-radius: 14px;
                padding: 25px 30px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.05);
                margin-bottom: 30px;
            }

            h2 {
                color: #1f6feb;
                margin-bottom: 20px;
            }

            .filter-bar {
                margin-bottom: 25px;
            }

            select {
                padding: 8px 14px;
                border-radius: 8px;
                border: 1px solid #ddd;
            }

            .summary-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }

            .summary-box {
                background: #ffffff;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            }

            .summary-box h4 {
                margin: 0;
                font-size: 14px;
                color: #777;
            }

            .summary-box h3 {
                margin-top: 10px;
                font-size: 22px;
                font-weight: 600;
            }

            .chart-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 25px;
                margin-top: 30px;
            }

            canvas {
                background: white;
                padding: 15px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            }

        </style>
    </head>

    <body>

        <div class="container">

            <div class="card">
                <h2>📊 System Dashboard</h2>

                <div class="filter-bar">
                    <form method="get" action="dashboard">
                        <select name="period" onchange="this.form.submit()">
                            <option value="today" <%= period.equals("today") ? "selected" : ""%>>Today</option>
                            <option value="week" <%= period.equals("week") ? "selected" : ""%>>This Week</option>
                            <option value="month" <%= period.equals("month") ? "selected" : ""%>>This Month</option>
                        </select>
                    </form>
                </div>

                <!-- Summary -->
                <div class="summary-grid">

                    <div class="summary-box">
                        <h4>Total Revenue</h4>
                        <h3>$<%= data.get("TOTAL_REVENUE")%></h3>
                    </div>

                    <div class="summary-box">
                        <h4>Total Invoices</h4>
                        <h3><%= data.get("TOTAL_INVOICE")%></h3>
                    </div>

                    <div class="summary-box">
                        <h4>Average Invoice</h4>
                        <h3>$<%= data.get("AVG_INVOICE")%></h3>
                    </div>

                    <div class="summary-box">
                        <h4>Risk Rate</h4>
                        <h3><%= String.format("%.2f", data.get("RISK_RATE"))%>%</h3>
                    </div>

                    <div class="summary-box">
                        <h4>Total Alerts</h4>
                        <h3><%= data.get("TOTAL_ALERT")%></h3>
                    </div>

                    <div class="summary-box">
                        <h4>New Alerts</h4>
                        <h3><%= data.get("NEW_ALERT")%></h3>
                    </div>

                    <div class="summary-box">
                        <h4>Total Shifts</h4>
                        <h3><%= data.get("TOTAL_SHIFT")%></h3>
                    </div>

                    <div class="summary-box">
                        <h4>Active Staff</h4>
                        <h3><%= data.get("ACTIVE_STAFF")%> / <%= data.get("TOTAL_STAFF")%></h3>
                    </div>

                </div>

                <!-- Charts -->
                <div class="chart-grid">

                    <canvas id="alertChart"></canvas>
                    <canvas id="riskChart"></canvas>
                    <canvas id="staffChart"></canvas>
                    <canvas id="invoiceChart"></canvas>

                </div>

            </div>

        </div>

        <script>

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
                            data: [<%= data.get("RISK_RATE")%>],
                            backgroundColor: '#d93025'
                        }]
                }
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
                            backgroundColor: ['#188038', '#ccc']
                        }]
                }
            });

            new Chart(document.getElementById('invoiceChart'), {
                type: 'bar',
                data: {
                    labels: ['Invoices', 'With Alert'],
                    datasets: [{
                            data: [
            <%= data.get("TOTAL_INVOICE")%>,
            <%= data.get("INVOICE_WITH_ALERT")%>
                            ],
                            backgroundColor: ['#1f6feb', '#d93025']
                        }]
                }
            });

        </script>

    </body>
</html>
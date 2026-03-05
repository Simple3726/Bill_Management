<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Shift Management</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body { background-color: #f8f9fa; }
        .shift-container { 
            max-width: 500px; 
            margin: 80px auto; 
            padding: 30px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); 
            border-radius: 10px; 
            background-color: #ffffff;
        }
        .status-open { color: #198754; font-weight: bold; font-size: 1.2rem; }
        .status-closed { color: #dc3545; font-weight: bold; font-size: 1.2rem; }
    </style>
</head>
<body>
    <div class="container">
        <div class="shift-container">
            <h2 class="text-center mb-4">Shift Management</h2>

            <%
                // 1. Retrieve attributes from Session and Request
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
                
                Boolean isShiftOpenObj = (Boolean) request.getAttribute("isShiftOpen");
                boolean isShiftOpen = (isShiftOpenObj != null) ? isShiftOpenObj : false;

                // 2. Display success message
                if (message != null && !message.trim().isEmpty()) {
            %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                    session.removeAttribute("message"); // Clear after displaying
                }

                // 3. Display error message
                if (error != null && !error.trim().isEmpty()) {
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                    session.removeAttribute("error"); // Clear after displaying
                }
            %>

            <div class="text-center mb-4">
                <p class="mb-1 text-muted">Current Status:</p>
                <% if (isShiftOpen) { %>
                    <span class="status-open">🟢 ACTIVE SHIFT</span>
                <% } else { %>
                    <span class="status-closed">🔴 NO ACTIVE SHIFT</span>
                <% } %>
            </div>

            <form action="<%= request.getContextPath() %>/ShiftController" method="POST">
                <% if (isShiftOpen) { %>
                    <input type="hidden" name="action" value="close">
                    <button type="submit" class="btn btn-danger btn-lg w-100" onclick="return confirm('Are you sure you want to end this shift?');">
                        End Shift
                    </button>
                <% } else { %>
                    <input type="hidden" name="action" value="open">
                    <button type="submit" class="btn btn-success btn-lg w-100">
                        Start Shift
                    </button>
                <% } %>
            </form>

            <div class="mt-4 text-center">
                <a href="<%= request.getContextPath() %>/dashboard.jsp" class="btn btn-outline-secondary btn-sm">Back to Dashboard</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
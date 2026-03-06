<%-- 
    Document   : login
    Created on : Feb 25, 2026, 2:29:02 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - BillManager</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f6f9;
        }
        
        /* Căn chỉnh và đổ bóng cho khung Login */
        .login-card {
            width: 100%;
            max-width: 420px;
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            background: #fff;
            padding: 40px 30px;
        }

        .brand-icon {
            font-size: 48px;
            color: #0d6efd;
            margin-bottom: 15px;
        }

        /* Tùy chỉnh ô nhập liệu có icon */
        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
            color: #6c757d;
        }
        .form-control {
            border-left: none;
            background-color: #f8f9fa;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #dee2e6;
            background-color: #fff;
        }
        .input-group:focus-within .form-control,
        .input-group:focus-within .input-group-text {
            background-color: #fff;
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        /* Nút đăng nhập */
        .btn-login {
            background-color: #0d6efd;
            color: white;
            padding: 12px;
            font-weight: 600;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
        }
    </style>
</head>

<body class="d-flex align-items-center justify-content-center min-vh-100">

    <div class="login-card">
        <div class="text-center mb-4">
            <i class="fa-solid fa-shield-halved brand-icon"></i>
            <h3 class="fw-bold text-dark">Welcome Back!</h3>
            <p class="text-muted">Login into bill management</p>
        </div>

        <%
            String alertLogout = (String)request.getAttribute("MSG_LOGOUT");
            if(alertLogout != null && !alertLogout.trim().isEmpty()){
        %>
            <div class="alert alert-success d-flex align-items-center" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>
                <div><%= alertLogout %></div>
            </div>
        <% } %>

        <%
            String msg = (String) request.getAttribute("MSG");
            if(msg != null && !msg.trim().isEmpty()){
        %>
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                <div><%= msg %></div>
            </div>
        <% } %>

        <form action="MenuController" method="POST">
            
            <div class="mb-3">
                <label class="form-label fw-medium text-dark">Username</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                    <input type="text" name="userID" class="form-control form-control-lg" placeholder="Enter your Username" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-medium text-dark">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" name="pass" class="form-control form-control-lg" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" name="action" value="Login" class="btn btn-login w-100">
                <i class="fa-solid fa-right-to-bracket me-2"></i> Login
            </button>

        </form>
        
        <div class="text-center mt-4">
            <small class="text-muted">© 2026 Bill Manager System. All rights reserved.</small>
        </div>
    </div>

</body>
</html>
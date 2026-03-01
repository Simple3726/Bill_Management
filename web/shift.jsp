<%-- 
    Document   : shift
    Created on : Feb 25, 2026, 2:29:15 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý Ca Làm Việc - Play 4 Health</title>
    
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
            <h2 class="text-center mb-4">Quản Lý Ca Làm Việc</h2>

            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="message" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <div class="text-center mb-4">
                <p class="mb-1 text-muted">Trạng thái hiện tại:</p>
                <c:choose>
                    <c:when test="${isShiftOpen}">
                        <span class="status-open">🟢 ĐANG TRONG CA</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-closed">🔴 CHƯA MỞ CA</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <form action="${pageContext.request.contextPath}/ShiftController" method="POST">
                <c:choose>
                    <c:when test="${isShiftOpen}">
                        <input type="hidden" name="action" value="close">
                        <button type="submit" class="btn btn-danger btn-lg w-100" onclick="return confirm('Bạn có chắc chắn muốn kết thúc ca làm việc này không?');">
                            Đóng Ca Làm Việc
                        </button>
                    </c:when>
                    
                    <c:otherwise>
                        <input type="hidden" name="action" value="open">
                        <button type="submit" class="btn btn-success btn-lg w-100">
                            Bắt Đầu Mở Ca
                        </button>
                    </c:otherwise>
                </c:choose>
            </form>

            <div class="mt-4 text-center">
                <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-outline-secondary btn-sm">Quay lại Dashboard</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

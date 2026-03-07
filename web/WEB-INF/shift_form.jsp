<%-- 
    Document   : shift_form
    Created on : Mar 6, 2026, 6:00:55 PM
    Author     : NAM ANH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Shift" %>
<%
    Shift s = (Shift) request.getAttribute("shiftToEdit");
    boolean isEdit = (s != null);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Shift - Bill Manager</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f4f6f9;
            padding: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .container { width: 100%; max-width: 500px; }
        .card {
            background: white;
            border-radius: 16px;
            padding: 40px 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: none;
        }
        h2 { margin-bottom: 25px; color: #1f6feb; font-weight: 700; text-align: center; }
        
        label { font-weight: 600; color: #495057; margin-bottom: 8px; display: block; font-size: 14px; }
        input, select {
            width: 100%; padding: 12px 15px; margin-bottom: 20px;
            border-radius: 8px; border: 1px solid #ced4da; box-sizing: border-box;
            font-family: 'Inter', sans-serif; font-size: 15px; transition: 0.3s;
        }
        input:focus, select:focus { border-color: #86b7fe; outline: none; box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25); }
        input:disabled { background-color: #e9ecef; cursor: not-allowed; }

        .action-buttons { display: flex; gap: 12px; margin-top: 10px; }
        .btn {
            padding: 12px 18px; border: none; border-radius: 8px; cursor: pointer;
            font-size: 15px; font-weight: 600; text-decoration: none; text-align: center; flex: 1; transition: 0.2s;
        }
        .btn-save { background: #1f6feb; color: white; }
        .btn-save:hover { background: #155bc2; transform: translateY(-1px); }
        .btn-cancel { background: #e4e6eb; color: #333; }
        .btn-cancel:hover { background: #d0d2d6; }
    </style>
</head>

<body>
    <div class="container">
        <div class="card">
            <h2><i class="fa-solid fa-pen-to-square me-2"></i>Edit Shift Status</h2>
            
            <form action="<%=request.getContextPath()%>/ShiftController" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="shiftId" value="<%= (isEdit) ? s.getShiftId() : "" %>">

                <label>Mã Ca (Shift ID)</label>
                <input type="text" value="#<%= (isEdit) ? s.getShiftId() : "" %>" disabled>

                <label>Bắt đầu lúc</label>
                <input type="text" value="<%= (isEdit) ? s.getStartTime() : "" %>" disabled>

                <label>Trạng Thái</label>
                <select name="status">
                    <option value="OPEN" <%= (isEdit && "OPEN".equals(s.getStatus())) ? "selected" : "" %>>🟢 OPEN</option>
                    <option value="CLOSED" <%= (isEdit && "CLOSED".equals(s.getStatus())) ? "selected" : "" %>>🔴 CLOSED</option>
                </select>

                <div class="action-buttons">
                    <a href="<%=request.getContextPath()%>/ShiftController?action=list" class="btn btn-cancel">Cancel</a>
                    <button type="submit" class="btn btn-save">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
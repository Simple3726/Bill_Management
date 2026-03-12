<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="entity.User" %>

<%
    User user = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>My Account</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            body, html {
                height: 100vh; /* Khóa cuộn toàn trang */
                margin: 0;
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                overflow: hidden;
            }

            /* --- SIDEBAR STYLES (Giữ nguyên bản) --- */
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
            .sidebar.collapsed { margin-left: -260px; }
            .sidebar-link {
                color: rgba(255, 255, 255, 0.8); text-decoration: none;
                padding: 10px 15px; border-radius: 6px; display: block;
                transition: 0.3s; white-space: nowrap;
            }
            .sidebar-link:hover, .sidebar-link.active { background-color: #0d6efd; color: white; }
            .user-avatar {
                width: 60px; height: 60px; background-color: #495057; border-radius: 50%;
                display: flex; align-items: center; justify-content: center;
                font-size: 24px; margin: 0 auto 10px auto; color: white;
            }
            .glow-online { color: #198754; text-shadow: 0 0 5px #198754, 0 0 10px #198754; }
            #sidebarToggle {
                background: none; border: none; color: #212529; font-size: 24px;
                cursor: pointer; padding: 0 15px 0 0; transition: color 0.2s;
            }
            #sidebarToggle:hover { color: #0d6efd; }
            /* --- END SIDEBAR STYLES --- */

            /* Main Content Flexbox Layout */
            .main-content {
                transition: all 0.3s ease-in-out;
                width: 100%;
                height: 100vh;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            /* THANH CUỘN (SCROLLBAR) RIÊNG CHO NỘI DUNG */
            .scrollable-container {
                flex-grow: 1;
                overflow-y: auto;
                max-height: calc(100vh - 100px);
                padding-right: 5px; /* Tránh cấn scrollbar */
            }
            .scrollable-container::-webkit-scrollbar { width: 8px; height: 8px; }
            .scrollable-container::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 8px; }
            .scrollable-container::-webkit-scrollbar-thumb { background: #c1c1c1; border-radius: 8px; }
            .scrollable-container::-webkit-scrollbar-thumb:hover { background: #a8a8a8; }

            /* PROFILE CUSTOM STYLES */
            .profile-card {
                border: none;
                border-radius: 16px;
                padding: 30px;
                text-align: center;
                background: white;
            }
            .profile-icon-wrapper {
                width: 120px;
                height: 120px;
                background: #e8f0fe;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px auto;
            }
            .profile-icon { font-size: 60px; color: #0d6efd; }
            
            /* BADGES (Đồng bộ với bảng User) */
            .custom-badge {
                padding: 6px 14px; border-radius: 50px; font-size: 13px;
                font-weight: 600; display: inline-flex; align-items: center;
            }
            .badge-admin { background-color: #e8f0fe; color: #1f6feb; }
            .badge-staff { background-color: #e6f4ea; color: #188038; }
            .badge-auditor { background-color: #fff4e5; color: #f9a825; }
            .badge-active { background-color: #e6f4ea; color: #188038; }
            .badge-locked { background-color: #ffecec; color: #d93025; }

            /* FORM STYLES */
            .update-card {
                border: none;
                border-radius: 16px;
                padding: 30px;
                background: white;
            }
            .form-control {
                padding: 10px 15px;
                border-radius: 8px;
            }
            .form-control:focus {
                box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
            }
            .section-title {
                font-size: 1.1rem;
                font-weight: 600;
                color: #212529;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #f4f6f9;
            }
        </style>
    </head>

    <body>

        <div class="d-flex w-100 vh-100 overflow-hidden">

            <jsp:include page="/WEB-INF/sidebar.jsp"/>

            <div class="p-4 main-content">

                <div class="d-flex align-items-center mb-4 flex-shrink-0">
                    <button id="sidebarToggle" title="Đóng/Mở thanh công cụ"><i class="fa-solid fa-bars"></i></button>
                    <h2 class="fw-bold text-primary mb-0"><i class="fa-solid fa-user-circle me-2"></i>My Account</h2>
                </div>

                <div class="alert-container flex-shrink-0">
                    <% String msg = (String) session.getAttribute("message");
                        if (msg != null) {%>
                    <div class="alert alert-success d-flex align-items-center shadow-sm" role="alert">
                        <i class="fa-solid fa-check-circle me-2 fs-5"></i>
                        <div><%= msg%></div>
                    </div>
                    <% session.removeAttribute("message"); } %>

                    <% String err = (String) session.getAttribute("error");
                        if (err != null) {%>
                    <div class="alert alert-danger d-flex align-items-center shadow-sm" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                        <div><%= err%></div>
                    </div>
                    <% session.removeAttribute("error"); }%>
                </div>

                <div class="scrollable-container">
                    <div class="row g-4">
                        
                        <div class="col-lg-4">
                            <div class="card profile-card shadow-sm">
                                <div class="profile-icon-wrapper shadow-sm">
                                    <i class="fa-solid fa-user profile-icon"></i>
                                </div>
                                
                                <h3 class="fw-bold mb-1 text-dark"><%=user.getUsername()%></h3>
                                <p class="text-muted mb-4">#<%=user.getUserId()%></p>

                                <div class="d-flex flex-column gap-3 text-start">
                                    <div class="d-flex justify-content-between align-items-center p-3 bg-light rounded-3">
                                        <span class="text-secondary fw-semibold"><i class="fa-solid fa-id-badge me-2"></i>Role</span>
                                        <% if ("ADMIN".equals(user.getRole())) { %>
                                            <span class="custom-badge badge-admin"><i class="fa-solid fa-crown me-1"></i>ADMIN</span>
                                        <% } else if ("AUDITOR".equals(user.getRole())) { %>
                                            <span class="custom-badge badge-auditor"><i class="fa-solid fa-eye me-1"></i>AUDITOR</span>
                                        <% } else { %>
                                            <span class="custom-badge badge-staff"><i class="fa-solid fa-user-pen me-1"></i>STAFF</span>
                                        <% } %>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center p-3 bg-light rounded-3">
                                        <span class="text-secondary fw-semibold"><i class="fa-solid fa-shield-halved me-2"></i>Status</span>
                                        <% if ("ACTIVE".equals(user.getStatus())) { %>
                                            <span class="custom-badge badge-active"><i class="fa-solid fa-check-circle me-1"></i>ACTIVE</span>
                                        <% } else { %>
                                            <span class="custom-badge badge-locked"><i class="fa-solid fa-lock me-1"></i>LOCKED</span>
                                        <% }%>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center p-3 bg-light rounded-3">
                                        <span class="text-secondary fw-semibold"><i class="fa-solid fa-calendar-days me-2"></i>Joined Date</span>
                                        <span class="fw-bold text-dark"><%=user.getCreatedAt()%></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-8">
                            <div class="card update-card shadow-sm">
                                <form action="<%=request.getContextPath()%>/UserController/UpdateProfile" method="post">
                                    <input type="hidden" name="id" value="<%=user.getUserId()%>">

                                    <div class="section-title">
                                        <i class="fa-solid fa-user-pen me-2 text-primary"></i>General Information
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="form-label fw-semibold text-secondary">Username</label>
                                        <input type="text" name="username" class="form-control bg-light" value="<%=user.getUsername()%>" required>
                                    </div>

                                    <div class="section-title mt-5">
                                        <i class="fa-solid fa-key me-2 text-warning"></i>Change Password <span class="text-muted fs-6 fw-normal">(Leave blank if not changing)</span>
                                    </div>

                                    <div class="row g-3 mb-4">
                                        <div class="col-md-12">
                                            <label class="form-label fw-semibold text-secondary">Current Password</label>
                                            <input type="password" name="currentPassword" class="form-control" placeholder="Enter current password">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold text-secondary">New Password</label>
                                            <input type="password" name="newPassword" class="form-control" placeholder="Enter new password">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold text-secondary">Confirm New Password</label>
                                            <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm new password">
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                                        <button type="reset" class="btn btn-light px-4 me-2 border">Reset</button>
                                        <button type="submit" class="btn btn-primary px-4 shadow-sm">
                                            <i class="fa-solid fa-floppy-disk me-1"></i> Save Changes
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>

                    </div>
                </div> </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Xử lý Sidebar Toggle
                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar");
                if (toggleBtn && sidebar) {
                    toggleBtn.addEventListener("click", function () {
                        sidebar.classList.toggle("collapsed");
                    });
                }

                // Xử lý tự động ẩn thông báo (Alert Fade-out)
                const alerts = document.querySelectorAll(".alert");
                alerts.forEach(function(alert) {
                    // Chờ 3 giây rồi mới bắt đầu mờ dần
                    setTimeout(function () {
                        alert.style.transition = "opacity 0.6s ease";
                        alert.style.opacity = "0";
                        // Xoá hẳn thẻ div sau khi mờ xong (0.6s)
                        setTimeout(function () {
                            alert.remove();
                        }, 600);
                    }, 3000);
                });
            });
        </script>

    </body>
</html>
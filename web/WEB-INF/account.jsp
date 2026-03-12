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

            body{
                font-family:'Inter',sans-serif;
                background:#f4f6f9;
            }

            /* SIDEBAR giống shift.jsp */

            .sidebar{
                width:260px;
                background:#212529;
                color:white;
                min-height:100vh;
                position:sticky;
                top:0;
                transition:0.3s;
            }

            .sidebar.collapsed{
                margin-left:-260px;
            }

            .sidebar-link{
                color:rgba(255,255,255,0.8);
                padding:10px 15px;
                display:block;
                text-decoration:none;
                border-radius:6px;
            }

            .sidebar-link:hover{
                background:#0d6efd;
                color:white;
            }

            .user-avatar{
                width:60px;
                height:60px;
                background:#495057;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:24px;
                margin:auto;
                color:white;
            }

            /* PROFILE */

            .profile-card{
                border:none;
                border-radius:16px;
                padding:40px;
                text-align:center;
            }

            .profile-icon{
                font-size:100px;
                color:#0d6efd;
            }

            .info-row{
                font-size:18px;
                margin-bottom:8px;
            }

        </style>

    </head>

    <body>

        <div class="d-flex min-vh-100">

            <jsp:include page="/WEB-INF/sidebar.jsp"/>

            <div class="flex-grow-1 p-4 main-content">

                <!-- HEADER + SIDEBAR BUTTON -->

                <div class="d-flex align-items-center mb-4">

                    <button id="sidebarToggle"
                            style="border:none;background:none;font-size:24px;margin-right:15px">

                        <i class="fa-solid fa-bars"></i>

                    </button>

                    <h2 class="fw-bold text-primary mb-0">

                        <i class="fa-solid fa-user me-2"></i>
                        My Account

                    </h2>
                    <% String msg = (String) session.getAttribute("message");
                        if (msg != null) {%>

                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="fa-solid fa-check-circle me-2"></i>
                        <div><%= msg%></div>
                    </div>

                    <% session.removeAttribute("message");
                        } %>


                    <% String err = (String) session.getAttribute("error");
                        if (err != null) {%>

                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>
                        <div><%= err%></div>
                    </div>

                    <% session.removeAttribute("error");
                        }%>

                </div>


                <!-- ACCOUNT INFORMATION -->
                <div id="infoSection">
                    <div class="card shadow profile-card mb-4">

                        <i class="fa-solid fa-circle-user profile-icon mb-3"></i>

                        <h3 class="fw-bold mb-3"><%=user.getUsername()%></h3>

                        <div class="info-row">
                            <b>Role:</b> <%=user.getRole()%>
                        </div>

                        <div class="info-row">
                            <b>Status:</b> <%=user.getStatus()%>
                        </div>

                        <div class="info-row text-muted">
                            <b>Created:</b> <%=user.getCreatedAt()%>
                        </div>

                        <button class="btn btn-primary mt-3"
                                onclick="showUpdate()">

                            <i class="fa-solid fa-pen"></i>
                            Update Account

                        </button>
                    </div>
                </div>


                <!-- UPDATE FORM  -->

                <div id="updateSection" style="display:none;">

                    <div class="card shadow p-4">

                        <h5 class="fw-bold mb-3">
                            <i class="fa-solid fa-user-pen me-2"></i>
                            Update Information
                        </h5>

                        <form action="<%=request.getContextPath()%>/UserController/UpdateProfile" method="post">

                            <input type="hidden" name="id" value="<%=user.getUserId()%>">

                            <div class="mb-3">
                                <label class="form-label">Username</label>
                                <input type="text"
                                       name="username"
                                       class="form-control"
                                       value="<%=user.getUsername()%>">
                            </div>

                            <hr>

                            <h6 class="fw-bold mb-3">
                                <i class="fa-solid fa-key me-2"></i>
                                Change Password
                            </h6>

                            <div class="mb-3">
                                <label class="form-label">Current Password</label>
                                <input type="password" name="currentPassword" class="form-control">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">New Password</label>
                                <input type="password" name="newPassword" class="form-control">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Confirm Password</label>
                                <input type="password" name="confirmPassword" class="form-control">
                            </div>

                            <button class="btn btn-success me-2">
                                Save Changes
                            </button>

                            <button type="button"
                                    class="btn btn-secondary"
                                    onclick="hideUpdate()">
                                Cancel
                            </button>

                        </form>

                    </div>

                </div>

            </div>

        </div>


        <script>
            function showUpdate() {

                document.getElementById("infoSection").style.display = "none";
                document.getElementById("updateSection").style.display = "block";
            }

            function hideUpdate() {

                document.getElementById("infoSection").style.display = "block";
                document.getElementById("updateSection").style.display = "none";
            }
            /* TOGGLE FORM */

            function toggleUpdate() {

                let form = document.getElementById("updateForm");
                if (form.style.display === "none") {
                    form.style.display = "block";
                } else {
                    form.style.display = "none";
                }

            }

            /* TOGGLE SIDEBAR */

            document.addEventListener("DOMContentLoaded", function () {

                const toggleBtn = document.getElementById("sidebarToggle");
                const sidebar = document.getElementById("sidebar");
                toggleBtn.addEventListener("click", function () {
                    sidebar.classList.toggle("collapsed");
                });
            });
            document.addEventListener("DOMContentLoaded", function () {

                const alert = document.querySelector(".alert");
                if (alert) {
                    setTimeout(function () {
                        alert.style.transition = "opacity 0.5s";
                        alert.style.opacity = "0";
                        setTimeout(function () {
                            alert.remove();
                        }, 500);
                    }, 1000);
                }

            }
            );
        </script>

    </body>
</html>
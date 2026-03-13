package controller;

import entity.User;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.UserService;

/**
 *
 * @author admin
 */
@WebServlet(name = "UserController", urlPatterns = {"/UserController/*"})
public class UserController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private UserService service = new UserService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            action = "/List";
        }

        switch (action) {

            case "/List":
                listUser(request, response);
                break;

            case "/Add":
                showCreateForm(request, response);
                break;

            case "/Create":
                createUser(request, response);
                break;

            case "/Edit":
                showEditForm(request, response);
                break;

            case "/Update":
                updateUser(request, response);
                break;

            case "/Lock":
                lockUser(request, response);
                break;

            case "/Unlock":
                unlockUser(request, response);
                break;

            case "/Delete":
                deleteUser(request, response);
                break;
            case "/Profile":
                showProfile(request, response);
                break;

            case "/UpdateProfile":
                updateProfile(request, response);
                break;

            case "/ChangePassword":
                changePassword(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ======================================
    // LIST USERS
    // ======================================
    private void listUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = service.getAllUsers();

        request.setAttribute("userList", users);

        request.getRequestDispatcher("/WEB-INF/user_list.jsp")
                .forward(request, response);
    }

    // ======================================
    // SHOW CREATE FORM
    // ======================================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("mode", "create");

        request.getRequestDispatcher("/WEB-INF/user_form.jsp")
                .forward(request, response);
    }

    // ======================================
    // CREATE USER
    // ======================================
    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);
            user.setStatus(status);

            service.createUser(user);

            response.sendRedirect(request.getContextPath() + "/UserController/List");

        } catch (Exception e) {

            request.setAttribute("error", e.getMessage());
            request.setAttribute("mode", "create");

            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setPassword(request.getParameter("password"));
            user.setRole(request.getParameter("role"));
            user.setStatus(request.getParameter("status"));

            request.setAttribute("user", user);

            request.getRequestDispatcher("/WEB-INF/user_form.jsp")
                    .forward(request, response);
        }
    }

    // ======================================
    // SHOW EDIT FORM
    // ======================================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long id = Long.parseLong(request.getParameter("id"));

        User user = service.getUserById(id);

        request.setAttribute("user", user);
        request.setAttribute("mode", "edit");

        request.getRequestDispatcher("/WEB-INF/user_form.jsp")
                .forward(request, response);
    }

    // ======================================
    // UPDATE USER
    // ======================================
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException, Exception {

        long id = Long.parseLong(request.getParameter("id"));
        String username = request.getParameter("username");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        User user = new User();
        user.setUserId(id);
        user.setUsername(username);
        user.setRole(role);
        user.setStatus(status);

        service.updateUser(user);

        response.sendRedirect(request.getContextPath() + "/UserController/List");
    }

    // ======================================
    // LOCK USER
    // ======================================
    private void lockUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        long id = Long.parseLong(request.getParameter("id"));

        service.lockUser(id);

        response.sendRedirect(request.getContextPath() + "/UserController/List");
    }

    // ======================================
    // UNLOCK USER
    // ======================================
    private void unlockUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        long id = Long.parseLong(request.getParameter("id"));

        service.activateUser(id);

        response.sendRedirect(request.getContextPath() + "/UserController/List");
    }

    // ======================================
    // DELETE USER
    // ======================================
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        long id = Long.parseLong(request.getParameter("id"));

        service.deleteUser(id);

        response.sendRedirect(request.getContextPath() + "/UserController/List");
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) request.getSession().getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = service.getUserById(sessionUser.getUserId());

        request.setAttribute("user", user);

        request.getRequestDispatcher("/WEB-INF/account.jsp")
                .forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        try {

            User sessionUser = (User) session.getAttribute("user");

            if (sessionUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String username = request.getParameter("username");

            User user = new User();
            user.setUserId(sessionUser.getUserId());
            user.setUsername(username);
            user.setRole(sessionUser.getRole());
            user.setStatus(sessionUser.getStatus());

            service.updateUser(user);

            session.setAttribute("message", "Account updated successfully");

        } catch (Exception e) {

            session.setAttribute("error", e.getMessage());

        }

        response.sendRedirect(request.getContextPath() + "/UserController/Profile");
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        try {

            User sessionUser = (User) session.getAttribute("user");

            if (sessionUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!sessionUser.getPassword().equals(currentPassword)) {
                throw new Exception("Current password incorrect");
            }

            if (!newPassword.equals(confirmPassword)) {
                throw new Exception("Password confirmation does not match");
            }

            service.changePassword(sessionUser.getUserId(), newPassword);

            session.setAttribute("message", "Password changed successfully");

        } catch (Exception e) {

            session.setAttribute("error", e.getMessage());

        }

        response.sendRedirect(request.getContextPath() + "/UserController/Profile");
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(UserController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            processRequest(request, response);

        } catch (Exception ex) {

            Logger.getLogger(UserController.class.getName()).log(Level.SEVERE, null, ex);

        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

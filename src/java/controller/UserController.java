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

        request.getRequestDispatcher("/WEB-INF/user_form.jsp")
                .forward(request, response);
    }

    // ======================================
    // CREATE USER
    // ======================================
    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException, Exception, Exception, Exception, Exception {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);
        user.setStatus("ACTIVE");

        service.createUser(user);

        response.sendRedirect(request.getContextPath() + "/UserController/List");
    }

    // ======================================
    // SHOW EDIT FORM
    // ======================================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long id = Long.parseLong(request.getParameter("id"));

        User user = service.getUserById(id);

        request.setAttribute("user", user);

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

package controller;

import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import repository.UserDAO;

/**
 *
 * @author admin
 */
@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    private UserDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new UserDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        String userID = request.getParameter("userID");
        String pass = request.getParameter("pass");

        // 1. Nếu bị "đá" từ trang khác về đây (bắt được tín hiệu required)
        if ("required".equals(action)) {
            request.setAttribute("MSG", "Session Time Out! Please log in to continue.");
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
            return; // Dừng lại, không chạy code login bên dưới nữa
        }

        // 2. Nếu người dùng chỉ vừa mới gõ URL hoặc click Menu để mở trang Login (chưa submit form)
        if (userID == null && pass == null) {
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
            return;
        }
        User user = dao.login(userID, pass);
        if (user != null) {

            if ("LOCKED".equals(user.getStatus())) {
                request.setAttribute("MSG", "This account had been Locked");
                request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            // khi login sẽ set status trạng thái ở đây "Online"
            dao.updateStatus(user.getUserId(), "ONLINE");
            switch (user.getRole()) {
                case "STAFF":
                    response.sendRedirect(request.getContextPath() + "/InvoiceController/List");
                    break;

                case "ADMIN":
                    request.getRequestDispatcher("DashBoardController").forward(request, response);
                    break;

                case "AUDITOR":
                    request.getRequestDispatcher("AlertController").forward(request, response);
                    break;
            }

        } else {
            request.setAttribute("MSG", "Incorrect UserID or Password");
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
        }
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
            // Ép xuất lỗi ra màn hình trình duyệt
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print("<h3 style='color:red;'>Lỗi Database tại LoginController: " + ex.getMessage() + "</h3>");
            ex.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            // Ép xuất lỗi ra màn hình trình duyệt
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print("<h3 style='color:red;'>Lỗi Database tại LoginController: " + ex.getMessage() + "</h3>");
            ex.printStackTrace();
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

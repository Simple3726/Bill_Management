package controller;

import entity.Invoice;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.InvoiceService;

/**
 *
 * @author admin
 */
@WebServlet(name = "InvoiceController", urlPatterns = {"/InvoiceController/*"})
public class InvoiceController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private InvoiceService service;

    @Override
    public void init() throws ServletException {
        service = new InvoiceService();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getPathInfo();

        // Nếu action là null hoặc chỉ có "/" thì mặc định là List
        if (action == null || action.equals("/")) {
            action = "/List";
        }

        // Sử dụng switch-case với dấu gạch chéo
        switch (action) {
            case "/List":
                listInvoice(request, response);
                break;
            case "/Add":
                showCreateForm(request, response);
                break;
            case "/Create":
                createInvoice(request, response);
                break;
            case "/Approve":
                approveInvoice(request, response);
            default:
                // Nên có một trang 404 hoặc báo lỗi ở đây thay vì để trắng
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void listInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("invoiceList", service.getAllInvoice());
        request.getRequestDispatcher("/WEB-INF/invoice_list.jsp").forward(request, response);
    }

    private void createInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession currentSession = request.getSession(false); //false de web khong tu tao moi session khi ko co session san
            if (currentSession != null && currentSession.getAttribute("user") != null) {
                User currentUser = (User) currentSession.getAttribute("user");
                Invoice invoice = new Invoice();
                invoice.setCreatedBy(currentUser.getUserId());
                request.setAttribute("Create_MSG", service.createInvoice(invoice));
            } else {
                request.getRequestDispatcher("LogOutController");
            }
        } catch (Exception e) {

        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra login trước khi cho xem form
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            request.getRequestDispatcher("/WEB-INF/invoice_form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    private void approveInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User currentUser = (User) session.getAttribute("user");

            Long invoiceId = Long.parseLong(request.getParameter("invoiceId"));

            service.approveInvoice(invoiceId, currentUser);

            response.sendRedirect(request.getContextPath() + "/InvoiceController/List");

        } catch (Exception e) {

            request.setAttribute("ERROR", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);

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
        processRequest(request, response);
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
        processRequest(request, response);
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

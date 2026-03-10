package controller;

import entity.Invoice;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
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
    private InvoiceService service = new InvoiceService();

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
            case "/Form":
                showForm(request, response);
                break;
            case "/Create":
                createInvoice(request, response);
                break;
            case "/Update":
                updateInvoice(request, response);
                break;
            case "/Approve":
                approveInvoice(request, response);
                break;
            case "/Delete":
                deleteInvoice(request, response);
                break;
            default:
                // Nên có một trang 404 hoặc báo lỗi ở đây thay vì để trắng
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void listInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if(session != null && session.getAttribute("user") != null){
                request.setAttribute("invoiceList", service.getInvoiceByUserId((User) session.getAttribute("user")));
                request.getRequestDispatcher("/WEB-INF/invoice_list.jsp").forward(request, response);
            }
            else{
                response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }

    private void createInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession currentSession = request.getSession(false); //false de web khong tu tao moi session khi ko co session san
            if (currentSession != null && currentSession.getAttribute("user") != null) {
                User currentUser = (User) currentSession.getAttribute("user");
                Invoice invoice = new Invoice();
                invoice.setInvoiceCode(request.getParameter("invoiceCode"));
                invoice.setAmount(new BigDecimal(request.getParameter("amount")));
                invoice.setCreatedBy(currentUser.getUserId());
                service.createInvoice(invoice);
                response.sendRedirect(request.getContextPath()+"/InvoiceController/List");
            } else {
                response.sendRedirect(request.getContextPath()+ "/LoginController?action=required");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace(); // In ra console của Netbeans/Eclipse
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print("<h2 style='color:red;'>Sever Error: " + e.getMessage() + "</h2>");
        response.getWriter().print("<p>Error detail: " + e.toString() + "</p>");
        }
    }

    public void updateInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try {
            HttpSession currentSession = request.getSession(false); //false de web khong tu tao moi session khi ko co session san
            if (currentSession != null && currentSession.getAttribute("user") != null) {
                User user = (User) currentSession.getAttribute("user");
                Long invoiceId = Long.parseLong(request.getParameter("invoiceId"));
                BigDecimal newAmount = new BigDecimal(request.getParameter("amount"));
                BigDecimal oldAmount = new BigDecimal(request.getParameter("oldAmount"));
                Long modified_by = user.getUserId();
                service.updateInvoice(invoiceId, newAmount, oldAmount, modified_by);
                response.sendRedirect(request.getContextPath()+"/InvoiceController/List");
            } else {
                response.sendRedirect(request.getContextPath()+ "/LoginController?action=required");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace(); // In ra console của Netbeans/Eclipse
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print("<h2 style='color:red;'>Server bị lỗi: " + e.getMessage() + "</h2>");
        response.getWriter().print("<p>Chi tiết lỗi (Xem kỹ dòng này): " + e.toString() + "</p>");
        }
    }
    
    private void deleteInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("user") == null){
            response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
            return;
        }
        Long invoiceId = Long.parseLong(request.getParameter("invoiceId"));
        User curUser  = (User) session.getAttribute("user");
        service.delete(invoiceId, curUser.getUserId());
        
        response.sendRedirect(request.getContextPath()+"/InvoiceController/List");
    }
    
    private void showForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
        HttpSession session = request.getSession(false);

        // LỖI 1 ĐÃ SỬA: Phải dùng DẤU HOẶC (||) thay vì DẤU VÀ (&&). 
        // Nếu session == null mà dùng && thì nó gọi tiếp .getAttribute sẽ bị NullPointerException ngay tại Controller.
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
            return; // Đừng quên return để dừng luồng chạy
        }

        String idParam = request.getParameter("invoiceId");
        Invoice invoice = null;

        try {
            if (idParam != null && !idParam.trim().isEmpty()) {
                Long invoiceId = Long.parseLong(idParam);
                invoice = service.getInvoiceById(invoiceId);

                // LỖI 2 ĐÃ SỬA: Lỡ ID không có thật thì đá về trang danh sách, không cho mở Form
                if (invoice == null) {
                    response.sendRedirect(request.getContextPath() + "/InvoiceController/List");
                    return;
                }
            } else {
                invoice = new Invoice();
                invoice.setInvoiceCode(invoice.generateInvoiceCode());
            }

            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/WEB-INF/invoice_form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/InvoiceController/List");
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

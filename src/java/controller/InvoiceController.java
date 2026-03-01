package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
            break; // Đừng quên break để tránh trôi code
        default:
            // Nên có một trang 404 hoặc báo lỗi ở đây thay vì để trắng
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            break;
    }
}
    
    private void listInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        request.setAttribute("invoiceList", service.getAllInvoice());
        request.getRequestDispatcher("/WEB-INF/invoice_list.jsp").forward(request, response);
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

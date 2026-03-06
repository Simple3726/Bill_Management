package controller;

import entity.Invoice;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name = "MenuController", urlPatterns = {"/MenuController"})
public class MenuController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final String LOGIN = "Login";
    private static final String LOGIN_CONTROLLER = "LoginController";
    private static final String LOGOUT = "Logout";
    private static final String LOGOUT_CONTROLLER = "LogOutController";
    private static final String UPDATE = "Update";
    private static final String UPDATE_INVOICE_CONTROLLER = "InvoiceController/Update";
    private static final String DELETE = "Delete";
    private static final String DELETE_INVOICE_CONTROLLER = "InvoiceController/Delete";
    private static final String CREATE = "Create";
    private static final String CREATE_INVOICE_CONTROLLER = "InvoiceController/Create";
    private static final String CREATE_PAGE = "Form";
    private static final String CREATE_PAGE_INV_CONTROLLER = "InvoiceController/Form";
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
       String url= "login.jsp";
        try {
            String action= request.getParameter("action");
            if(LOGIN.equals(action)){
                url= LOGIN_CONTROLLER;
               }
            else if(LOGOUT.equals(action)) {
                url = LOGOUT_CONTROLLER;
            }
            else if(UPDATE.equals(action)) {
                url = UPDATE_INVOICE_CONTROLLER;
            }
            else if(DELETE.equals(action)){
                url = DELETE_INVOICE_CONTROLLER;
            }
            else if(CREATE.equals(action)){
                url = CREATE_INVOICE_CONTROLLER;
            }
            else if(CREATE_PAGE.equals(action)){
                url = CREATE_PAGE_INV_CONTROLLER;
            }
            else{
                request.setAttribute("ERROR", "Your action not support");
            }
        } catch (Exception e) {
            log("Error at MenuController: "+ e.toString());
        }finally{
            request.getRequestDispatcher(url).forward(request, response);
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

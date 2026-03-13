package controller;

import entity.Alert;
import repository.AlertDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import repository.InvoiceDAO;
import service.InvoiceService;

@WebServlet(name = "AlertController", urlPatterns = {"/AlertController"})
public class AlertController extends HttpServlet {

    AlertDAO alertDAO = new AlertDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            AlertDAO alertDAO = new AlertDAO();

            String action = request.getParameter("action");

            // nếu bấm investigate
            if ("investigate".equals(action)) {

                Long alertId = Long.parseLong(request.getParameter("alertId"));

                Alert alert = alertDAO.findById(alertId);

                request.setAttribute("alert", alert);

                request.getRequestDispatcher("/WEB-INF/investigate.jsp")
                        .forward(request, response);

                return;
            }

            // nếu bấm resolve
            if ("resolve".equals(action)) {

                InvoiceDAO invoiceDAO = new InvoiceDAO();

                Long alertId = Long.parseLong(request.getParameter("alertId"));
                Long invoiceId = Long.parseLong(request.getParameter("invoiceId"));

                alertDAO.updateStatus(alertId, "RESOLVED");
                invoiceDAO.updateStatus(invoiceId, "APPROVED");

                response.sendRedirect(request.getContextPath() + "/AlertController");

                return;
            }
            if ("reject".equals(action)) {

                InvoiceDAO invoiceDAO = new InvoiceDAO();

                Long alertId = Long.parseLong(request.getParameter("alertId"));
                Long invoiceId = Long.parseLong(request.getParameter("invoiceId"));

                alertDAO.updateStatus(alertId, "RESOLVED");
                invoiceDAO.updateStatus(invoiceId, "REJECTED");

                response.sendRedirect(request.getContextPath() + "/AlertController");

                return;
            }

            // mặc định load alert list
            List<Alert> alertList = alertDAO.findAll();

            request.setAttribute("alertList", alertList);

            request.getRequestDispatcher("/WEB-INF/alert_list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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

        String action = request.getParameter("action");

        AlertDAO alertDAO = new AlertDAO();

        try {

            if ("investigate".equals(action)) {

                Long alertId = Long.parseLong(request.getParameter("alertId"));

                Alert alert = alertDAO.findById(alertId);

                request.setAttribute("alert", alert);

                request.getRequestDispatcher("/WEB-INF/investigate.jsp")
                        .forward(request, response);

            } else {

                List<Alert> alertList = alertDAO.findAll();

                request.setAttribute("alertList", alertList);

                request.getRequestDispatcher("/WEB-INF/alert_list.jsp")
                        .forward(request, response);

            }

        } catch (Exception e) {
            e.printStackTrace();
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

package controller;

import ai.PredictFraud;
import entity.Alert;
import entity.User;
import repository.AlertDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import repository.ActivityLogDAO;
import repository.InvoiceDAO;
import repository.ShiftDAO;
import service.InvoiceService;
import service.ShiftService;
import weka.classifiers.Classifier;
import weka.core.Instances;
import weka.core.SerializationHelper;
import weka.core.converters.ConverterUtils;

@WebServlet(name = "AlertController", urlPatterns = {"/AlertController"})
public class AlertController extends HttpServlet {

    private AlertDAO alertDAO;
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() throws ServletException {
        alertDAO = new AlertDAO();
        invoiceDAO = new InvoiceDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

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
            //===================================Xử Lý AI=========================================
            if ("checkFraud".equals(action)) {
                try {

                    // 1. Load model và dataset 1 lần duy nhất
                    String arffPath = getServletContext().getRealPath("/WEB-INF/invoice_dataset.arff");
                    String modelPath = getServletContext().getRealPath("/WEB-INF/risk_logistic.model");

                    ConverterUtils.DataSource source = new ConverterUtils.DataSource(arffPath);
                    Instances dataset = source.getDataSet();
                    dataset.setClassIndex(dataset.numAttributes() - 1);
                    Classifier model = (Classifier) SerializationHelper.read(modelPath);

                    // 2. Lấy danh sách ID và dự đoán luôn
                    HttpSession session = request.getSession();
                    User currentUser = (User) session.getAttribute("user");
                    List<Long> ids = invoiceDAO.getInvoiceIdsByUserId(currentUser.getUserId());

                    List<Map<String, Object>> finalResults = new ArrayList<>();
                    for (Long id : ids) {
                        String score = PredictFraud.predictInvoice(id, model, dataset);
                        Map<String, Object> map = new HashMap<>();
                        map.put("id", id);
                        map.put("score", score);
                        finalResults.add(map);
                    }
                    // mặc định load alert list
                    List<Alert> alertList = alertDAO.findAll();
                    request.setAttribute("alertList", alertList);
                    // 3. Gửi danh sách kết quả cuối cùng sang JSP
                    request.setAttribute("fraudResults", finalResults);
                    request.getRequestDispatcher("/WEB-INF/alert_list.jsp").forward(request, response);

                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().write("error");
                    return;
                }
            }
            //=================================================================================

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

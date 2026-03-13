/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import detection.DetectionEngine;
import entity.Product;
import entity.Shift;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.eclipse.jdt.internal.compiler.impl.Constant;
import service.AlertService;
import service.LogService;
import service.ProductService;
import service.ShiftService;
import utils.Constants;

/**
 *
 * @author Nguyen Xuan Tan
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController/*"})
public class ProductController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private ProductService service = new ProductService();
    private DetectionEngine engine = new DetectionEngine();
    private ShiftService shiftService = new ShiftService();
    private LogService logService = new LogService();
    private AlertService alertService = new AlertService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            action = "/List";
        }

        switch (action) {
            case "/List":
                showList(request, response);
                break;
            case "/Form":
                showForm(request, response);
                break;
            case "/Create":
                createProduct(request, response);
                break;
            case "/Update":
                updateProduct(request, response);
                break;
            case "/Delete":
                deleteProduct(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }

    }

    private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession currSession = request.getSession(false);
            if (currSession == null || currSession.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
                return;
            }

            request.setAttribute("productList", service.listActive());
            request.getRequestDispatcher("/WEB-INF/product_list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy ID từ URL (nếu nhân viên bấm nút Update)
        String idParam = request.getParameter("productId");
        Product product = null;
        
        try {
            if (idParam != null && !idParam.trim().isEmpty()) {
                // TRƯỜNG HỢP UPDATE: Tìm sản phẩm trong DB
                Long productId = Long.parseLong(idParam);
                product = service.getProductById(productId); // Giả sử bạn đã khởi tạo productDAO ở đầu class
                
                // Bọc thép: Nếu ID xảo trá không có trong DB thì đá về List
                if (product == null) {
                    response.sendRedirect(request.getContextPath() + "/ProductManagement/List");
                    return;
                }
            } else {
                // TRƯỜNG HỢP CREATE: Tạo mới đối tượng rỗng
                
                product = new Product();
                product.setStatus("ACTIVE"); // Set mặc định trạng thái đang bán
            }
            
            // 2. Gửi đối tượng sang trang JSP
            request.setAttribute("product", product);
            request.getRequestDispatcher("/WEB-INF/product_form.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ProductManagement/List");
        }
    }

    private void createProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession currSession = request.getSession(false);
            if (currSession == null || currSession.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
                return;
            }
            
            Product product = new Product();
            product.setProductName(request.getParameter("productName"));
            product.setPrice(new BigDecimal(request.getParameter("price")));
            product.setStatus(request.getParameter("status"));
            Product newProduct = service.createProduct(product);
            //checking does product add completed? If not send notice and switch back to List page
            if(newProduct == null){
                currSession.setAttribute("actionAlert", "Cannot add:" + product.getProductName() + " is already active in system!");
                response.sendRedirect(request.getContextPath() + "/ProductController/List");
                return;
            }
            User currUser = (User)currSession.getAttribute("user");
            Shift currShift = shiftService.getCurrentShift(currUser.getUserId());
            if(currShift != null){
                logService.addLog(currUser.getUserId(), currShift.getShiftId(), "CREATE_PRODUCT", "PRODUCT", newProduct.getProductId(), newProduct.getCreatedAt());
            }
            response.sendRedirect(request.getContextPath() + "/ProductController/List");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession currSession = request.getSession(false);
            if (currSession == null || currSession.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
                return;
            }
            Long productId = Long.parseLong(request.getParameter("productId"));
            String productName = request.getParameter("productName");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String status = request.getParameter("status");
            Product updatedProduct = service.updateProduct(productId, productName, price, status);
            if(updatedProduct == null){
                currSession.setAttribute("actionAlert", "Cannot add:" + productName + " is already active in system!");
                response.sendRedirect(request.getContextPath() + "/ProductController/List");
                return;
            }
            User currUser = (User)currSession.getAttribute("user");
            Shift currShift = shiftService.getCurrentShift(currUser.getUserId());
            if(currShift != null){
                logService.addLog(currUser.getUserId(), currShift.getShiftId(), "UPDATE_PRODUCT", "PRODUCT", updatedProduct.getProductId(), updatedProduct.getUpdatedAt());
            }
            response.sendRedirect(request.getContextPath() + "/ProductController/List");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession currSession = request.getSession(false);
            if (currSession == null || currSession.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
                return;
            }
            Long productId = Long.parseLong(request.getParameter("productId"));
            
            LocalDateTime updateAt = service.deleteProduct(productId);
            
            User currUser = (User)currSession.getAttribute("user");
            Shift currShift = shiftService.getCurrentShift(currUser.getUserId());
            if(currShift != null){
                logService.addLog(currUser.getUserId(), currShift.getShiftId(), "UPDATE_PRODUCT", "PRODUCT", productId, updateAt);
            }
            response.sendRedirect(request.getContextPath() + "/ProductController/List");
        } catch (Exception e) {
            e.printStackTrace();
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

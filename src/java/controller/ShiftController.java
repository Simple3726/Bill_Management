package controller;

import entity.ActivityLog;
import entity.Shift;
import repository.ActivityLogDAO;
import repository.ShiftDAO;
import service.ShiftService;

import java.io.IOException;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ShiftController", urlPatterns = {"/ShiftController"})
public class ShiftController extends HttpServlet {
private ShiftService shiftService;
    private ShiftDAO shiftDAO;
    private ActivityLogDAO activityLogDAO;

    @Override
    public void init() throws ServletException {
        shiftService = new ShiftService();
        shiftDAO = new ShiftDAO();
        activityLogDAO = new ActivityLogDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // GIẢ LẬP ID User (Chờ module Login làm xong)
        Long userId = 1L; 

        try {
            // TRƯỜNG HỢP 1: Tải giao diện
            if (action == null || action.isEmpty()) {
                boolean isShiftOpen = false;
                try {
                    Shift currentShift = shiftService.getCurrentShift(userId); 
                    isShiftOpen = true;
                    session.setAttribute("CURRENT_SHIFT_ID", currentShift.getShiftId());
                } catch (RuntimeException e) {
                    isShiftOpen = false;
                    session.removeAttribute("CURRENT_SHIFT_ID");
                }
                request.setAttribute("isShiftOpen", isShiftOpen);
                request.getRequestDispatcher("/shift.jsp").forward(request, response);
                return; // Phải có return để dừng xử lý, không chạy tiếp xuống dưới
            }

            // TRƯỜNG HỢP 2: Xử lý các hành động
            if ("open".equals(action)) {
                try {
                    shiftService.getCurrentShift(userId);
                    session.setAttribute("error", "Bạn đang có một ca làm việc chưa đóng!");
                } catch (RuntimeException e) {
                    Shift newShift = new Shift();
                    newShift.setUserId(userId);
                    newShift.setStartTime(LocalDateTime.now());
                    newShift.setStatus("OPEN");

                    Long newShiftId = shiftDAO.insert(newShift);
                    
                    if (newShiftId != null) {
                        session.setAttribute("CURRENT_SHIFT_ID", newShiftId);
                        ghiLog(userId, newShiftId, "OPEN_SHIFT", "SHIFT", newShiftId);
                        session.setAttribute("message", "Mở ca thành công!");
                    } else {
                        session.setAttribute("error", "Lỗi hệ thống khi mở ca!");
                    }
                }
            } else if ("close".equals(action)) {
                try {
                    Shift currentShift = shiftService.getCurrentShift(userId);
                    currentShift.setEndTime(LocalDateTime.now());
                    currentShift.setStatus("CLOSED");
                    
                    boolean isClosed = shiftDAO.update(currentShift);
                    
                    if (isClosed) {
                        session.removeAttribute("CURRENT_SHIFT_ID");
                        ghiLog(userId, currentShift.getShiftId(), "CLOSE_SHIFT", "SHIFT", currentShift.getShiftId());
                        session.setAttribute("message", "Đóng ca thành công!");
                    } else {
                        session.setAttribute("error", "Lỗi hệ thống khi đóng ca!");
                    }
                } catch (RuntimeException e) {
                    session.setAttribute("error", "Không tìm thấy ca nào đang mở để đóng!");
                }
            }

            // Sau khi xử lý action xong thì redirect lại chính Controller này để tải lại trang
            response.sendRedirect(request.getContextPath() + "/ShiftController");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi server: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ShiftController");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ cần gọi processRequest
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ cần gọi processRequest
        processRequest(request, response);
    }

    // Hàm hỗ trợ ghi log
    private void ghiLog(Long userId, Long shiftId, String action, String entityType, Long entityId) {
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setShiftId(shiftId);
        log.setActionType(action);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setCreatedAt(LocalDateTime.now());
        
        activityLogDAO.insert(log);
    }
}
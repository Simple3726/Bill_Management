package controller;

import entity.ActivityLog;
import entity.Shift;
import repository.ActivityLogDAO;
import repository.ShiftDAO;
import service.ShiftService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
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
        
        // GIẢ LẬP: Fix cứng ID người dùng
        Long userId = 1L; 
        
        try {
            // 1. HIỂN THỊ GIAO DIỆN
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
                // GỌI FILE TỪ WEB-INF
                request.getRequestDispatcher("/WEB-INF/shift.jsp").forward(request, response);
                return; 
            }

            // 2. MỞ CA
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
                response.sendRedirect(request.getContextPath() + "/ShiftController");

            // 3. ĐÓNG CA
            } else if ("close".equals(action)) {
                try {
                    Shift currentShift = shiftService.getCurrentShift(userId);
                    currentShift.setEndTime(LocalDateTime.now());
                    currentShift.setStatus("CLOSED");
                    if (shiftDAO.update(currentShift)) {
                        session.removeAttribute("CURRENT_SHIFT_ID");
                        ghiLog(userId, currentShift.getShiftId(), "CLOSE_SHIFT", "SHIFT", currentShift.getShiftId());
                        session.setAttribute("message", "Đóng ca thành công!");
                    } else {
                        session.setAttribute("error", "Lỗi hệ thống khi đóng ca!");
                    }
                } catch (RuntimeException e) {
                    session.setAttribute("error", "Không tìm thấy ca nào đang mở để đóng!");
                }
                response.sendRedirect(request.getContextPath() + "/ShiftController");

            // 4. DANH SÁCH CA
            } else if ("list".equals(action)) {
                List<Shift> shiftList = shiftService.getAllShifts();
                request.setAttribute("shiftList", shiftList);
                // GỌI FILE TỪ WEB-INF
                request.getRequestDispatcher("/WEB-INF/shift_list.jsp").forward(request, response);
                return;

            // 5. XÓA CA
            } else if ("delete".equals(action)) {
                Long idToDelete = Long.parseLong(request.getParameter("id"));
                if (shiftService.deleteShift(idToDelete)) {
                    session.setAttribute("message", "Xóa ca thành công!");
                } else {
                    session.setAttribute("error", "Lỗi khi xóa ca!");
                }
                response.sendRedirect(request.getContextPath() + "/ShiftController?action=list");
                return;

            // 6. FORM SỬA CA
            } else if ("edit".equals(action)) {
                Long idToEdit = Long.parseLong(request.getParameter("id"));
                Shift shiftToEdit = shiftService.getShiftById(idToEdit);
                request.setAttribute("shiftToEdit", shiftToEdit);
                // GỌI FILE TỪ WEB-INF
                request.getRequestDispatcher("/WEB-INF/shift_form.jsp").forward(request, response);
                return;

            // 7. CẬP NHẬT CA
            } else if ("update".equals(action)) {
                Long idToUpdate = Long.parseLong(request.getParameter("shiftId"));
                String newStatus = request.getParameter("status");
                Shift shiftToUpdate = shiftService.getShiftById(idToUpdate);
                if(shiftToUpdate != null) {
                    shiftToUpdate.setStatus(newStatus);
                    shiftService.updateShiftInfo(shiftToUpdate);
                    session.setAttribute("message", "Cập nhật ca thành công!");
                }
                response.sendRedirect(request.getContextPath() + "/ShiftController?action=list");
                return;

            // 8. NHẬT KÝ HOẠT ĐỘNG
            } else if ("view_log".equals(action)) {
                Long shiftId = Long.parseLong(request.getParameter("id"));
                List<ActivityLog> logList = activityLogDAO.findByShift(shiftId);
                request.setAttribute("logList", logList);
                request.setAttribute("currentShiftId", shiftId); 
                // GỌI FILE TỪ WEB-INF
                request.getRequestDispatcher("/WEB-INF/activity_log.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi server: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ShiftController");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

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
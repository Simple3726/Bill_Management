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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // GIẢ LẬP ID User (Chờ Hiếu làm xong Login sẽ lấy từ session)
        Long userId = 1L; 

        boolean isShiftOpen = false;
        try {
            // Hàm này của bạn sẽ ném lỗi nếu không có ca
            Shift currentShift = shiftService.getCurrentShift(userId); 
            isShiftOpen = true;
            // Cập nhật lại session cho chắc chắn
            session.setAttribute("CURRENT_SHIFT_ID", currentShift.getShiftId());
        } catch (RuntimeException e) {
            // Bắt lỗi tức là không có ca nào đang mở
            isShiftOpen = false;
            session.removeAttribute("CURRENT_SHIFT_ID");
        }

        request.setAttribute("isShiftOpen", isShiftOpen);
        request.getRequestDispatcher("/shift.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Long userId = 1L; // GIẢ LẬP ID User

        try {
            if ("open".equals(action)) {
                try {
                    // Kiểm tra xem có ca nào đang mở không
                    shiftService.getCurrentShift(userId);
                    // Nếu chạy qua dòng trên mà không sinh lỗi -> Đã có ca
                    session.setAttribute("error", "Bạn đang có một ca làm việc chưa đóng!");
                } catch (RuntimeException e) {
                    // Không có ca nào -> Tiến hành mở ca mới
                    Shift newShift = new Shift();
                    newShift.setUserId(userId);
                    newShift.setStartTime(LocalDateTime.now());
                    newShift.setStatus("OPEN");

                    Long newShiftId = shiftDAO.insert(newShift); // Gọi DAO tạo ca
                    
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
                    // Lấy ca hiện tại ra
                    Shift currentShift = shiftService.getCurrentShift(userId);
                    
                    // Cập nhật trạng thái đóng ca
                    currentShift.setEndTime(LocalDateTime.now());
                    currentShift.setStatus("CLOSED");
                    
                    boolean isClosed = shiftDAO.update(currentShift); // Gọi DAO cập nhật
                    
                    if (isClosed) {
                        session.removeAttribute("CURRENT_SHIFT_ID");
                        ghiLog(userId, currentShift.getShiftId(), "CLOSE_SHIFT", "SHIFT", currentShift.getShiftId());
                        session.setAttribute("message", "Đóng ca thành công!");
                    } else {
                        session.setAttribute("error", "Lỗi hệ thống khi đóng ca!");
                    }
                } catch (RuntimeException e) {
                    // Bắt lỗi không có ca
                    session.setAttribute("error", "Không tìm thấy ca nào đang mở để đóng!");
                }
            }

            response.sendRedirect(request.getContextPath() + "/ShiftController");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi server: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ShiftController");
        }
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
package controller;

import entity.ActivityLog;
import entity.Shift;
import entity.User;
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
        
        // LẤY THÔNG TIN USER TỪ SESSION (Đã xóa dòng giả lập ID)
        User currentUser = (User) session.getAttribute("user");
        
        // Nếu chưa đăng nhập thì đẩy về trang Login
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/LoginController?action=required");
            return;
        }
        
        // Lấy ID thật của người đang thao tác
        Long currentUserId = currentUser.getUserId();
        
        try {
            // ================== 1. GIAO DIỆN CHÍNH (MỞ/ĐÓNG CA) ==================
            if (action == null || action.isEmpty()) {
                boolean isShiftOpen = false;
                try {
                    Shift currentShift = shiftService.getCurrentShift(currentUserId); 
                    isShiftOpen = true;
                    session.setAttribute("CURRENT_SHIFT_ID", currentShift.getShiftId());
                } catch (RuntimeException e) {
                    isShiftOpen = false;
                    session.removeAttribute("CURRENT_SHIFT_ID");
                }
                request.setAttribute("isShiftOpen", isShiftOpen);
                request.getRequestDispatcher("/WEB-INF/shift.jsp").forward(request, response);
                return; 
            }

            // ================== 2. NHÂN VIÊN TỰ MỞ CA ==================
            if ("open".equals(action)) {
                // Gọi hàm (đã sửa để trả về null nếu không có ca)
                Shift existingShift = shiftService.getCurrentShift(currentUserId);

                if (existingShift != null) {
                    // Đã có ca đang mở -> Báo lỗi
                    session.setAttribute("error", "Bạn đang có một ca làm việc chưa đóng!");
                } else {
                    // Không có ca nào -> Tạo mới hoàn toàn bình thường (Không dùng catch)
                    Shift newShift = new Shift();
                    newShift.setUserId(currentUserId);

                    // BỔ SUNG QUAN TRỌNG: Lúc nãy DB của bạn có cột shift_date, đừng quên set nó nhé!
                    // newShift.setShiftDate(java.time.LocalDate.now()); 

                    newShift.setStartTime(LocalDateTime.now());
                    newShift.setStatus("OPEN");

                    Long newShiftId = shiftDAO.insert(newShift);
                    if (newShiftId != null) {
                        session.setAttribute("CURRENT_SHIFT_ID", newShiftId);
                        addLog(currentUserId, newShiftId, "OPEN_SHIFT", "SHIFT", newShiftId);
                        session.setAttribute("message", "Mở ca thành công!");
                    } else {
                        session.setAttribute("error", "Lỗi trong quá trình mở ca mới!");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/ShiftController");

            // ================== 3. NHÂN VIÊN TỰ ĐÓNG CA ==================
            } else if ("close".equals(action)) {
                Shift currentShift = shiftService.getCurrentShift(currentUserId);

                if (currentShift != null) {
                    // Tìm thấy ca đang mở -> Cập nhật giờ kết thúc
                    currentShift.setEndTime(LocalDateTime.now());
                    currentShift.setStatus("CLOSED");

                    if (shiftDAO.update(currentShift)) {
                        session.removeAttribute("CURRENT_SHIFT_ID");
                        addLog(currentUserId, currentShift.getShiftId(), "CLOSE_SHIFT", "SHIFT", currentShift.getShiftId());
                        session.setAttribute("message", "Đóng ca thành công!");
                    } else {
                        session.setAttribute("error", "Lỗi: Không thể lưu thông tin đóng ca vào Database!");
                    }
                } else {
                    // Trả về null -> Không có ca nào để đóng
                    session.setAttribute("error", "Hệ thống không tìm thấy ca làm việc nào đang mở để đóng!");
                }
                response.sendRedirect(request.getContextPath() + "/ShiftController");

            // ================== 4. DANH SÁCH CA (ADMIN) ==================
            } else if ("list".equals(action)) {
               String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                List<Shift> shiftList;

                if (startDateStr != null && !startDateStr.isEmpty() && endDateStr != null && !endDateStr.isEmpty()) {
                    try {
                        java.time.LocalDate startDate = java.time.LocalDate.parse(startDateStr);
                        java.time.LocalDate endDate = java.time.LocalDate.parse(endDateStr);
                        
                        shiftList = shiftService.filterShiftsByDate(startDate, endDate);
                        
                        request.setAttribute("startDate", startDateStr);
                        request.setAttribute("endDate", endDateStr);
                    } catch (Exception e) {
                        shiftList = shiftService.getAllShifts(); // Nếu lỗi format thì lấy tất cả
                        session.setAttribute("error", "Định dạng ngày không hợp lệ!");
                    }
                } else {
                    // Nếu không lọc, mặc định lấy tất cả
                    shiftList = shiftService.getAllShifts();
                }

                request.setAttribute("shiftList", shiftList);
                request.getRequestDispatcher("/WEB-INF/shift_list.jsp").forward(request, response);
                return;
              
            // ================== 5. ADMIN ÉP ĐÓNG CA ==================
            } else if ("admin_force_close".equals(action)) {
                if ("ADMIN".equals(currentUser.getRole())) {
                    Long shiftIdToClose = Long.parseLong(request.getParameter("id"));
                    Shift shiftToClose = shiftService.getShiftById(shiftIdToClose);
                    if(shiftToClose != null && "OPEN".equals(shiftToClose.getStatus())) {
                        shiftToClose.setEndTime(LocalDateTime.now());
                        shiftToClose.setStatus("CLOSED");
                        shiftService.updateShiftInfo(shiftToClose);
                        
                        addLog(currentUserId, shiftToClose.getShiftId(), "ADMIN_FORCE_CLOSE", "SHIFT", shiftToClose.getShiftId());
                        session.setAttribute("message", "Đã ép đóng ca #" + shiftIdToClose + " thành công!");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/ShiftController?action=list");
                return;

            // ================== 6. ADMIN MỞ CA HỘ NHÂN VIÊN ==================
            } else if ("admin_open_shift".equals(action)) {
                if ("ADMIN".equals(currentUser.getRole())) {
                    Long targetUserId = Long.parseLong(request.getParameter("targetUserId"));
                    try {
                        shiftService.getCurrentShift(targetUserId);
                        session.setAttribute("error", "Nhân viên ID " + targetUserId + " hiện đang có một ca làm việc mở rồi!");
                    } catch (RuntimeException e) {
                        Shift newShift = new Shift();
                        newShift.setUserId(targetUserId);
                        newShift.setStartTime(LocalDateTime.now());
                        newShift.setStatus("OPEN");
                        Long newId = shiftDAO.insert(newShift);
                        
                        addLog(currentUserId, newId, "ADMIN_OPEN_FOR_USER", "SHIFT", newId);
                        session.setAttribute("message", "Đã mở ca thành công cho Nhân viên ID " + targetUserId);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/ShiftController?action=list");
                return;
            // ================== 8. FORM SỬA CA ==================
            } else if ("edit".equals(action)) {
                Long idToEdit = Long.parseLong(request.getParameter("id"));
                Shift shiftToEdit = shiftService.getShiftById(idToEdit);
                request.setAttribute("shiftToEdit", shiftToEdit);
                request.getRequestDispatcher("/WEB-INF/shift_form.jsp").forward(request, response);
                return;

            // ================== 9. CẬP NHẬT CA TỪ FORM ==================
            } else if ("update".equals(action)) {
                Long idToUpdate = Long.parseLong(request.getParameter("shiftId"));
                String newStatus = request.getParameter("status");
                Shift shiftToUpdate = shiftService.getShiftById(idToUpdate);
                
                if(shiftToUpdate != null) {
                    // LOGIC THÊM VÀO: Nếu đổi từ OPEN sang CLOSED -> Ghi nhận giờ kết thúc
                    if ("CLOSED".equals(newStatus) && "OPEN".equals(shiftToUpdate.getStatus())) {
                        shiftToUpdate.setEndTime(LocalDateTime.now());
                    } 
                    // LOGIC THÊM VÀO: Nếu Admin lỡ tay đóng nhầm, muốn mở lại (từ CLOSED sang OPEN) -> Xóa giờ kết thúc
                    else if ("OPEN".equals(newStatus) && "CLOSED".equals(shiftToUpdate.getStatus())) {
                        shiftToUpdate.setEndTime(null);
                    }
                    
                    shiftToUpdate.setStatus(newStatus);
                    shiftService.updateShiftInfo(shiftToUpdate);
                    
                    // Ghi lại Log cho thao tác sửa từ Form
                    addLog(currentUserId, shiftToUpdate.getShiftId(), "ADMIN_EDIT_SHIFT_STATUS", "SHIFT", shiftToUpdate.getShiftId());
                    
                    session.setAttribute("message", "Cập nhật ca thành công!");
                    session.setAttribute("message", "Update shift successfully!");
                }
   
                response.sendRedirect(request.getContextPath() + "/ShiftController?action=list");
                return;

            // ================== 10. XEM NHẬT KÝ HOẠT ĐỘNG ==================
            } else if ("view_log".equals(action)) {
                Long shiftId = Long.parseLong(request.getParameter("id"));
                List<ActivityLog> logList = activityLogDAO.findByShift(shiftId);
                request.setAttribute("logList", logList);
                request.setAttribute("currentShiftId", shiftId); 
                request.getRequestDispatcher("/WEB-INF/activity_log.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Server error: " + e.getMessage());
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

    private void addLog(Long userId, Long shiftId, String action, String entityType, Long entityId) {
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
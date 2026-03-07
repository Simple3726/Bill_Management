package service;

import entity.ActivityLog;
import java.time.LocalDateTime;
import repository.ActivityLogDAO;

/**
 *
 * @author admin
 */
public class LogService {

    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    // Hàm addLog nhận vào 6 tham số đúng như InvoiceService đang gọi
<<<<<<< HEAD
    public void addLog(Long userId, Long shiftId, String actionType, String entityType, Long entityId, String createAt) {
=======
    public void addLog(Long userId, Long shiftId, String actionType, String entityType, Long entityId, LocalDateTime created_at) {
>>>>>>> c819ad54835d2f223cab0e056051a9cadcc0fd0e
        
        // Tạo một đối tượng log mới
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setShiftId(shiftId);
        log.setActionType(actionType);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
<<<<<<< HEAD
        log.setCreatedAt(LocalDateTime.now());
=======
        log.setCreatedAt(created_at);
>>>>>>> c819ad54835d2f223cab0e056051a9cadcc0fd0e
        
        // Gọi DAO để lưu vào database
        activityLogDAO.insert(log);
    }
}

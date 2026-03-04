package service;

import entity.ActivityLog;
import repository.ActivityLogDAO;

/**
 *
 * @author admin
 */
public class LogService {

    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    // Hàm addLog nhận vào 6 tham số đúng như InvoiceService đang gọi
    public void addLog(Long userId, Long shiftId, String actionType, String entityType, Long entityId, String description) {
        
        // Tạo một đối tượng log mới
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setShiftId(shiftId);
        log.setActionType(actionType);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setDescription(description);
        
        // Gọi DAO để lưu vào database
        activityLogDAO.insert(log);
    }
}

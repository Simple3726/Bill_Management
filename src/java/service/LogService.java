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

    public void addLog(Long userId, Long shiftId, String actionType, String entityType, Long entityId, LocalDateTime created_at) {
        
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setShiftId(shiftId);
        log.setActionType(actionType);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setCreatedAt(created_at);
        
        activityLogDAO.insert(log);
    }
}

package repository;

import entity.ActivityLog;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO {

    public void insert(ActivityLog log) {
        
        String sql = "INSERT INTO Activity_Logs(user_id, shift_id, action_type, entity_type, entity_id, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, log.getUserId());
            
            // Xử lý an toàn nếu shift_id bị null (Dành cho Admin)
            if (log.getShiftId() != null) ps.setLong(2, log.getShiftId());
            else ps.setNull(2, Types.BIGINT);

            ps.setString(3, log.getActionType());
            ps.setString(4, log.getEntityType());

            if (log.getEntityId() != null) ps.setLong(5, log.getEntityId());
            else ps.setNull(5, Types.BIGINT);

            ps.setTimestamp(6, Timestamp.valueOf(log.getCreatedAt()));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ActivityLog> findByShift(Long shiftId) {
        List<ActivityLog> list = new ArrayList<>();
        // ĐÃ SỬA: Đổi tên bảng thành Activity_Logs
        String sql = "SELECT * FROM Activity_Logs WHERE shift_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shiftId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { 
                list.add(mapResultSet(rs)); 
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    private ActivityLog mapResultSet(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setLogId(rs.getLong("log_id"));
        log.setUserId(rs.getLong("user_id"));
        log.setShiftId(rs.getLong("shift_id"));
        
        // ĐÃ SỬA: Lấy từ cột action_type thay vì action
        log.setActionType(rs.getString("action_type")); 
        
        log.setEntityType(rs.getString("entity_type"));
        log.setEntityId(rs.getLong("entity_id"));
        log.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return log;
    }
}
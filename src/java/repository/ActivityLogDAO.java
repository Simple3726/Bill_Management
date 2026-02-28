package repository;

import entity.ActivityLog;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO {

    public void insert(ActivityLog log) {
        String sql = "INSERT INTO ActivityLogs(user_id, shift_id, action, entity_type, entity_id, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, log.getUserId());
            if (log.getShiftId() != null){
                ps.setLong(2, log.getShiftId());
            } else {
                    ps.setNull(2, java.sql.Types.BIGINT);
                    }
            ps.setString(3, log.getActionType());
            ps.setString(4, log.getEntityType());
            ps.setLong(5, log.getEntityId());
            ps.setTimestamp(6, Timestamp.valueOf(log.getCreatedAt()));

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ActivityLog> findByUser(Long userId) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT * FROM ActivityLogs WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<ActivityLog> findByShift(Long shiftId){
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT * FROM ActivityLogs WHERE shift_id = ? ORDER BY created_at DESC";
        
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
        log.setActionType(rs.getString("action"));
        log.setEntityType(rs.getString("entity_type"));
        log.setEntityId(rs.getLong("entity_id"));
        log.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return log;
    }
}
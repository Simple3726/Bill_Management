package repository;

import entity.ActivityLog;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO {

    public Long insert(ActivityLog log) {
        String sql = "INSERT INTO ActivityLogs " +
                "(user_id, shift_id, action_type, entity_type, entity_id, description, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, log.getUserId());
            
            // Xử lý ShiftId có thể null
            if (log.getShiftId() != null) {
                ps.setLong(2, log.getShiftId());
            } else {
                ps.setNull(2, java.sql.Types.BIGINT);
            }

            ps.setString(3, log.getActionType());
            ps.setString(4, log.getEntityType());
            ps.setLong(5, log.getEntityId());
            ps.setString(6, log.getDescription());

            if (log.getCreatedAt() != null) {
                ps.setTimestamp(7, Timestamp.valueOf(log.getCreatedAt()));
            } else {
                ps.setTimestamp(7, Timestamp.valueOf(java.time.LocalDateTime.now()));
            }

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<ActivityLog> findByUser(Long userId) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT * FROM ActivityLogs WHERE user_id = ? ORDER BY created_at DESC";

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

    // Giữ lại hàm findByShift từ nhánh Task2 của bạn
    public List<ActivityLog> findByShift(Long shiftId) {
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

    // Giữ lại hàm findByEntity mới cập nhật từ master
    public List<ActivityLog> findByEntity(String entityType, Long entityId) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT * FROM ActivityLogs WHERE entity_type = ? AND entity_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, entityType);
            ps.setLong(2, entityId);

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

        long shiftId = rs.getLong("shift_id");
        if (!rs.wasNull()) {
            log.setShiftId(shiftId);
        }

        log.setActionType(rs.getString("action_type"));
        log.setEntityType(rs.getString("entity_type"));
        log.setEntityId(rs.getLong("entity_id"));
        log.setDescription(rs.getString("description"));
        log.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

        return log;
    }
}
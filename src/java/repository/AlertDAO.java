package repository;

import entity.Alert;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class AlertDAO {

    // =================================
    // INSERT ALERT
    // =================================
    public boolean insert(Alert alert) {

        String sql = "INSERT INTO Alerts "
                + "(entity_type, entity_id, risk_score, message, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, alert.getEntityType());
            ps.setLong(2, alert.getEntityId());
            ps.setInt(3, alert.getRiskScore());
            ps.setString(4, alert.getMessage());
            ps.setString(5, alert.getStatus());
            ps.setTimestamp(6, Timestamp.valueOf(alert.getCreatedAt())); // LocalDateTime

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =================================
    // FIND BY ID
    // =================================
    public Alert findById(Long id) {

        String sql = "SELECT * FROM Alerts WHERE alert_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSet(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =================================
    // FIND ALL
    // =================================
    public List<Alert> findAll() {

        List<Alert> list = new ArrayList<>();
        String sql = "SELECT * FROM Alerts ORDER BY created_at DESC";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =================================
    // FIND BY ENTITY
    // =================================
    public List<Alert> findByEntity(String entityType, Long entityId) {

        List<Alert> list = new ArrayList<>();
        String sql = "SELECT * FROM Alerts WHERE entity_type = ? AND entity_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // =================================
    // UPDATE STATUS
    // =================================
    public boolean updateStatus(Long alertId, String status) {

        String sql = "UPDATE Alerts SET status = ? WHERE alert_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setLong(2, alertId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =================================
    // COUNT ALL ALERT
    // =================================
    public int countAll() {

        String sql = "SELECT COUNT(*) FROM Alerts";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =================================
    // CHECK EXISTING ALERT (NEW)
    // =================================
    public boolean existsNewAlert(String entityType, Long entityId) {

        String sql = "SELECT COUNT(*) FROM Alerts "
                + "WHERE entity_type = ? AND entity_id = ? AND status = 'NEW'";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, entityType);
            ps.setLong(2, entityId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =================================
    // COUNT BY STATUS
    // =================================
    public int countByStatus(String status) {

        String sql = "SELECT COUNT(*) FROM Alerts WHERE status = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =================================
    // DELETE
    // =================================
    public boolean delete(Long id) {

        String sql = "DELETE FROM Alerts WHERE alert_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    // =================================
    // FIND BY STATUS
    // =================================

    public List<Alert> findByStatus(String status) {

        List<Alert> list = new ArrayList<>();
        String sql = "SELECT * FROM Alerts WHERE status = ? ORDER BY created_at DESC";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =================================
    // MAP RESULT SET
    // =================================
    private Alert mapResultSet(ResultSet rs) throws SQLException {

        Alert alert = new Alert();

        alert.setAlertId(rs.getLong("alert_id"));
        alert.setEntityType(rs.getString("entity_type"));
        alert.setEntityId(rs.getLong("entity_id"));
        alert.setRiskScore(rs.getInt("risk_score"));
        alert.setMessage(rs.getString("message"));
        alert.setStatus(rs.getString("status"));

        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) {
            alert.setCreatedAt(created.toLocalDateTime());
        }

        return alert;
    }

    // ========================================
    // Count number of alert in range of time
    // ========================================
    public int countAlertBetween(LocalDate start, LocalDate end) {

        String sql = "SELECT COUNT(*) FROM Alerts "
                + "WHERE CAST(created_at AS DATE) BETWEEN ? AND ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(start));
            ps.setDate(2, java.sql.Date.valueOf(end));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    // ====================================================
    // Count number of alert by status in range of time
    // ====================================================
    public int countAlertByStatusBetween(String status,
            LocalDate start,
            LocalDate end) {

        String sql = "SELECT COUNT(*) FROM Alerts "
                + "WHERE status = ? "
                + "AND CAST(created_at AS DATE) BETWEEN ? AND ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setDate(2, java.sql.Date.valueOf(start));
            ps.setDate(3, java.sql.Date.valueOf(end));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}

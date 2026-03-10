package repository;

import entity.Shift;
import utils.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ShiftDAO {

    public Long insert(Shift shift) {
        // ĐÃ SỬA: Thêm cột shift_date vào câu lệnh SQL
        String sql = "INSERT INTO Shifts(user_id, shift_date, start_time, end_time, status) VALUES (?, ?, ?, ?, ?)";
        Long generatedId = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, shift.getUserId());
            
            // ĐÃ SỬA: Tự động trích xuất ngày từ start_time để lưu vào shift_date
            ps.setDate(2, java.sql.Date.valueOf(shift.getStartTime().toLocalDate())); 
            
            ps.setTimestamp(3, Timestamp.valueOf(shift.getStartTime()));
            
            if (shift.getEndTime() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(shift.getEndTime()));
            } else {
                ps.setNull(4, Types.TIMESTAMP);
            }
            ps.setString(5, shift.getStatus());
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) generatedId = rs.getLong(1);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return generatedId;
    }

    public boolean update(Shift shift) {
        String sql = "UPDATE Shifts SET end_time = ?, status = ? WHERE shift_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (shift.getEndTime() != null) ps.setTimestamp(1, Timestamp.valueOf(shift.getEndTime()));
            else ps.setNull(1, Types.TIMESTAMP);
            ps.setString(2, shift.getStatus());
            ps.setLong(3, shift.getShiftId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<Shift> findAll() {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT * FROM Shifts ORDER BY start_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Shift s = new Shift();
                s.setShiftId(rs.getLong("shift_id"));
                s.setUserId(rs.getLong("user_id"));
                s.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                if (rs.getTimestamp("end_time") != null) s.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                s.setStatus(rs.getString("status"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Shift findById(Long shiftId) {
        String sql = "SELECT * FROM Shifts WHERE shift_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shiftId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Shift s = new Shift();
                s.setShiftId(rs.getLong("shift_id"));
                s.setUserId(rs.getLong("user_id"));
                s.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                if (rs.getTimestamp("end_time") != null) s.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                s.setStatus(rs.getString("status"));
                return s;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }


    public int countShiftBetween(LocalDate start, LocalDate end) {
        String sql = "SELECT COUNT(*) FROM Shifts WHERE CAST(start_time AS DATE) >= ? AND CAST(start_time AS DATE) <= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(start));
            ps.setDate(2, java.sql.Date.valueOf(end));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    
    public List<Shift> filterByDate(LocalDate startDate, LocalDate endDate) {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT * FROM Shifts WHERE CAST(start_time AS DATE) >= ? AND CAST(start_time AS DATE) <= ? ORDER BY start_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, java.sql.Date.valueOf(startDate));
            ps.setDate(2, java.sql.Date.valueOf(endDate));
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Shift s = new Shift();
                s.setShiftId(rs.getLong("shift_id"));
                s.setUserId(rs.getLong("user_id"));
                s.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                if (rs.getTimestamp("end_time") != null) {
                    s.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                }
                s.setStatus(rs.getString("status"));
                list.add(s);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
}
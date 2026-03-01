package repository;

import entity.Shift;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ShiftDAO {

    public Long insert(Shift shift) {
        String sql = "INSERT INTO Shifts(user_id, start_time, end_time, status) VALUES (?, ?, ?, ?)";
        Long generatedId = null;
        
        try ( Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, shift.getUserId());
            ps.setTimestamp(2, Timestamp.valueOf(shift.getStartTime()));
            
            if (shift.getEndTime() != null){
                ps.setTimestamp(3, Timestamp.valueOf(shift.getEndTime()));
            } else {
                ps.setNull(3, java.sql.Types.TIMESTAMP);
            }
            
            ps.setString(4, shift.getStatus());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if(rs.next()){
                    generatedId = rs.getLong(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
    }
    
    public boolean update(Shift shift){
        String sql = "UPDATE Shifts SET end_time = ?, status = ? WHERE shift_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (shift.getEndTime() != null) {
                ps.setTimestamp(1, Timestamp.valueOf(shift.getEndTime()));
            } else {
                ps.setNull(1, java.sql.Types.TIMESTAMP);
            }
            ps.setString(2, shift.getStatus());
            ps.setLong(3, shift.getShiftId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Shift findById(Long shiftId){
        String sql = "SELECT * FROM Shifts WHERE shift_id = ?";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            
            ps.setLong(1, shiftId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                return mapResultSet(rs);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
    
    public Shift findActiveShiftByUserId(Long userId) {
        String sql = "SELECT * FROM Shifts WHERE user_id = ? AND status = 'OPEN'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Shift> findByUser(Long userId) {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT * FROM Shifts WHERE user_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // ========================================
    // MAP RESULT
    // ========================================
    private Shift mapResultSet(ResultSet rs) throws SQLException {
        Shift s = new Shift();
        s.setShiftId(rs.getLong("shift_id"));
        s.setUserId(rs.getLong("user_id"));
        
        if (rs.getTimestamp("start_time") != null) {
            s.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
        }
        
        if (rs.getTimestamp("end_time") != null) {
            s.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
        }
        s.setStatus(rs.getString("status"));
        return s;
    }

    // ========================================
    // Count Number of Shifts (Giữ lại từ master)
    // ========================================
     public int countShiftBetween(LocalDate start, LocalDate end) {
        String sql = "SELECT COUNT(*) FROM Shifts WHERE shift_date BETWEEN ? AND ?";

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
    }

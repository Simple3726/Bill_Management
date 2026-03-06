package repository;

import entity.Shift;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ShiftDAO {

    // [C] - CREATE: Thêm một ca làm việc mới vào database (dùng khi Mở ca)
    public Long insert(Shift shift) {
        String sql = "INSERT INTO Shifts(user_id, start_time, end_time, status) VALUES (?, ?, ?, ?)";
        Long generatedId = null;
        try (Connection conn = DBConnection.getConnection();
             // Statement.RETURN_GENERATED_KEYS giúp lấy lại ID của ca vừa tạo
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, shift.getUserId());
            ps.setTimestamp(2, Timestamp.valueOf(shift.getStartTime()));
            
            // Xử lý null: Khi mới mở ca thì end_time chưa có
            if (shift.getEndTime() != null) {
                ps.setTimestamp(3, Timestamp.valueOf(shift.getEndTime()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }
            ps.setString(4, shift.getStatus());
            ps.executeUpdate();
            
            // Lấy ID tự tăng từ SQL Server trả về
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) generatedId = rs.getLong(1);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return generatedId;
    }

    // [U] - UPDATE: Cập nhật thông tin ca (dùng khi Đóng ca hoặc Admin sửa trạng thái)
    public boolean update(Shift shift) {
        String sql = "UPDATE Shifts SET end_time = ?, status = ? WHERE shift_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            if (shift.getEndTime() != null) {
                ps.setTimestamp(1, Timestamp.valueOf(shift.getEndTime()));
            } else {
                ps.setNull(1, Types.TIMESTAMP);
            }
            ps.setString(2, shift.getStatus());
            ps.setLong(3, shift.getShiftId());
            
            // executeUpdate trả về số dòng bị ảnh hưởng. Nếu > 0 tức là update thành công
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    // [R] - READ ALL: Lấy danh sách tất cả các ca làm việc để hiển thị lên bảng
    public List<Shift> findAll() {
        List<Shift> list = new ArrayList<>();
        // ORDER BY start_time DESC: Sắp xếp ca mới nhất lên đầu tiên
        String sql = "SELECT * FROM Shifts ORDER BY start_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
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
                list.add(s); // Thêm từng ca vào danh sách
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // [R] - READ ONE: Lấy thông tin chi tiết của đúng 1 ca (dùng khi bấm nút Edit)
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
                if (rs.getTimestamp("end_time") != null) {
                    s.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                }
                s.setStatus(rs.getString("status"));
                return s; // Trả về đối tượng Shift vừa tìm được
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return null;
    }

    // [D] - DELETE: Xóa một ca làm việc khỏi hệ thống (Dành cho Admin)
    public boolean delete(Long shiftId) {
        String sql = "DELETE FROM Shifts WHERE shift_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shiftId);
            return ps.executeUpdate() > 0; // Trả về true nếu xóa thành công
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }
    
    public int countShiftBetween(LocalDate start, LocalDate end) {
        String sql = "SELECT COUNT(*) FROM Shifts WHERE CAST(start_time AS DATE) >= ? AND CAST(start_time AS DATE) <= ?";
        try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

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

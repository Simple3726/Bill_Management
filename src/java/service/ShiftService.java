package service;

import entity.Shift;
import repository.ShiftDAO;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import utils.DBConnection;

/**
 *
 * @author admin
 */
public class ShiftService {

    // Khởi tạo DAO để xài
    private ShiftDAO shiftDAO = new ShiftDAO();

    // Fix lỗi cannot find symbol getCurrentShift ở InvoiceService và ShiftController
    public Shift getCurrentShift(Long userId) {
        String sql = "SELECT TOP 1 * FROM Shifts WHERE user_id = ? AND status = 'OPEN' ORDER BY start_time DESC";
        try (Connection conn = DBConnection.getConnection();  
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Shift shift = new Shift();
                shift.setShiftId(rs.getLong("shift_id"));
                shift.setUserId(rs.getLong("user_id"));
                shift.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                Timestamp endTs = rs.getTimestamp("end_time");
                if (endTs != null) shift.setEndTime(endTs.toLocalDateTime());
                shift.setStatus(rs.getString("status"));
                return shift;
            }
        } catch (Exception e) { e.printStackTrace(); }
        throw new RuntimeException("No active shift found!");
    }

    // --- CÁC HÀM BỔ SUNG CHO CRUD ---

    // Gọi DAO lấy toàn bộ danh sách
    public List<Shift> getAllShifts() { 
        return shiftDAO.findAll(); 
    }

    // Gọi DAO lấy 1 ca theo ID để đưa lên form Sửa
    public Shift getShiftById(Long shiftId) { 
        return shiftDAO.findById(shiftId); 
    }

    // Gọi DAO để update dữ liệu từ form Sửa xuống DB
    public boolean updateShiftInfo(Shift shift) { 
        return shiftDAO.update(shift); 
    }

    // Gọi DAO xóa 1 ca
    public boolean deleteShift(Long shiftId) { 
        return shiftDAO.delete(shiftId); 
    }
}

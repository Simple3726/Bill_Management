package repository;

import entity.Shift;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ShiftDAO {

    public void insert(Shift shift) {
        String sql = "INSERT INTO Shifts(user_id, start_time, end_time, status) VALUES (?, ?, ?, ?)";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, shift.getUserId());
            ps.setTimestamp(2, Timestamp.valueOf(shift.getStartTime()));
            ps.setTimestamp(3, Timestamp.valueOf(shift.getEndTime()));
            ps.setString(4, shift.getStatus());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
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
        s.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
        s.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
        s.setStatus(rs.getString("status"));
        return s;
    }
    // ========================================
    // Count Number of Shifts
    // ========================================
     public int countShiftBetween(LocalDate start, LocalDate end) {

        String sql = "SELECT COUNT(*) FROM Shifts "
                + "WHERE shift_date BETWEEN ? AND ?";

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

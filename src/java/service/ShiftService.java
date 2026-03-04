package service;

import entity.Shift;
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

    public Shift getCurrentShift(Long userId) {

        String sql = "SELECT TOP 1 * FROM Shifts "
                + "WHERE user_id = ? AND status = 'OPEN' "
                + "ORDER BY start_time DESC";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Shift shift = new Shift();

                shift.setShiftId(rs.getLong("shift_id"));
                shift.setUserId(rs.getLong("user_id"));
                shift.setStartTime(
                        rs.getTimestamp("start_time").toLocalDateTime()
                );

                Timestamp endTs = rs.getTimestamp("end_time");
                if (endTs != null) {
                    shift.setEndTime(endTs.toLocalDateTime());
                }

                shift.setStatus(rs.getString("status"));

                return shift;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        throw new RuntimeException("No active shift found!");
    }

}

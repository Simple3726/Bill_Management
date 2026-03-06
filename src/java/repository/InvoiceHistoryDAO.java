package repository;

import entity.InvoiceHistory;
import java.math.BigDecimal;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;

public class InvoiceHistoryDAO {

    // =========================================
    // Pick the final Invoice (for InvoiceService)
    // =========================================
    public InvoiceHistory getLastByInvoiceId(Long invoiceId) {

        String sql = "SELECT TOP 1 * FROM Invoice_History " +
                     "WHERE invoice_id = ? " +
                     "ORDER BY modified_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, invoiceId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                InvoiceHistory history = new InvoiceHistory();

                history.setHistoryId(rs.getLong("history_id"));
                history.setInvoiceId(rs.getLong("invoice_id"));
                history.setOldAmount(rs.getBigDecimal("old_amount"));
                history.setNewAmount(rs.getBigDecimal("new_amount"));
                history.setModifiedBy(rs.getLong("modified_by"));
                history.setShiftId(rs.getLong("shift_id"));
                history.setReason(rs.getString("reason"));
                history.setModifiedAt(
                        rs.getTimestamp("modified_at").toLocalDateTime()
                );

                return history;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    public void addHistory(Long invoiceId, BigDecimal oldAmount, BigDecimal newAmount, Long modified_by, Long shift_id, String reason, LocalDateTime modified_at){
        String sql = "INSERT INTO Invoice_History(invoice_id, old_Amount, new_Amount, modified_by, shift_id, reason, modified_at) VALUES(?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setLong(1, invoiceId);
            ps.setBigDecimal(2, oldAmount);
            ps.setBigDecimal(3, newAmount);
            ps.setLong(4, modified_by);
            ps.setLong(5, shift_id);
            ps.setString(6, reason);
            ps.setTimestamp(7, Timestamp.valueOf(modified_at));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    // =========================================
    // Count number of edited shift
    // =========================================
    public int countEditInShift(Long invoiceId, Long shiftId) {

        String sql = "SELECT COUNT(*) FROM Invoice_History " +
                     "WHERE invoice_id = ? AND shift_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, invoiceId);
            ps.setLong(2, shiftId);

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
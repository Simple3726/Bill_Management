package repository;

import entity.InvoiceHistory;
import utils.DBConnection;

import java.sql.*;

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
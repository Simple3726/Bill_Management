package repository;

import entity.Invoice;
import java.math.BigDecimal;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    // =========================
    // INSERT
    // =========================
    public void insert(Invoice invoice) {
        String sql = "INSERT INTO Invoices(invoice_code, amount, status, created_by, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoice.getInvoiceCode());
            ps.setBigDecimal(2, invoice.getAmount()); // BigDecimal chuẩn tài chính
            ps.setString(3, invoice.getStatus());
            ps.setLong(4, invoice.getCreatedBy());
            ps.setTimestamp(5, Timestamp.valueOf(invoice.getCreatedAt()));

            if (invoice.getUpdatedAt() != null) {
                ps.setTimestamp(6, Timestamp.valueOf(invoice.getUpdatedAt()));
            } else {
                ps.setNull(6, Types.TIMESTAMP);
            }

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // FIND BY ID
    // =========================
    public Invoice findById(Long id) {
        String sql = "SELECT * FROM Invoices WHERE invoice_id = ?";

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

    // =========================
    // FIND BY CODE
    // =========================
    public Invoice findByCode(String code) {
        String sql = "SELECT * FROM Invoices WHERE invoice_code = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSet(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // UPDATE (amount + status)
    // =========================
    public void update(Invoice invoice) {
        String sql = "UPDATE Invoices SET amount = ?, status = ?, updated_at = ? "
                + "WHERE invoice_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBigDecimal(1, invoice.getAmount());
            ps.setString(2, invoice.getStatus());
            ps.setTimestamp(3, Timestamp.valueOf(invoice.getUpdatedAt()));
            ps.setLong(4, invoice.getInvoiceId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // DELETE
    // =========================
    public void delete(Long id) {
        String sql = "DELETE FROM Invoices WHERE invoice_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // FIND ALL
    // =========================
    public List<Invoice> findAll() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM Invoices";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // Count Date
    // =========================
    public int countByDate(LocalDate date) {

        String sql = "SELECT COUNT(*) FROM Invoices WHERE CAST(created_at AS DATE) = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(date));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =====================================
    // Count how many Invoices had Alerted
    // =====================================
    public int countInvoiceHaveAlert(LocalDate date) {

        String sql
                = "SELECT COUNT(DISTINCT i.invoice_id) "
                + "FROM Invoices i "
                + "JOIN Alerts a ON a.entity_id = i.invoice_id "
                + "WHERE a.entity_type = 'INVOICE' "
                + "AND CAST(i.created_at AS DATE) = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(date));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ============
    // MAP RESULT
    // ============
    private Invoice mapResultSet(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        
        invoice.setInvoiceId(rs.getLong("invoice_id"));
        invoice.setInvoiceCode(rs.getString("invoice_code"));
        invoice.setAmount(rs.getBigDecimal("amount")); // BigDecimal đúng
        invoice.setStatus(rs.getString("status"));
        invoice.setCreatedBy(rs.getLong("created_by"));

        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            invoice.setCreatedAt(createdTs.toLocalDateTime());
        }

        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            invoice.setUpdatedAt(updatedTs.toLocalDateTime());
        }

        return invoice;
    }

    // =====================================
    // Get Revenue in range of time
    // =====================================
    public BigDecimal getRevenueBetween(LocalDate start, LocalDate end) {

        String sql = "SELECT ISNULL(SUM(amount),0) "
                + "FROM Invoices "
                + "WHERE CAST(created_at AS DATE) BETWEEN ? AND ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(start));
            ps.setDate(2, java.sql.Date.valueOf(end));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =====================================
    // Count Invoice in range of time
    // =====================================
    public int countInvoiceBetween(LocalDate start, LocalDate end) {

        String sql = "SELECT COUNT(*) FROM Invoices "
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

    // =================================================
    // Count Invoice had been Alerted in range of time
    // =================================================
    public int countInvoiceWithAlertBetween(LocalDate start, LocalDate end) {

        String sql
                = "SELECT COUNT(DISTINCT i.invoice_id) "
                + "FROM Invoices i "
                + "JOIN Alerts a ON a.entity_id = i.invoice_id "
                + "WHERE a.entity_type = 'INVOICE' "
                + "AND CAST(i.created_at AS DATE) BETWEEN ? AND ?";

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
    // =====================================
    // get Average invoice in range of time
    // =====================================
    public BigDecimal getAverageInvoiceBetween(LocalDate start, LocalDate end) {

        String sql = "SELECT ISNULL(AVG(amount),0) "
                + "FROM Invoices "
                + "WHERE CAST(created_at AS DATE) BETWEEN ? AND ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(start));
            ps.setDate(2, java.sql.Date.valueOf(end));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }
}

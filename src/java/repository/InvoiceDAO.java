package repository;

import entity.Invoice;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    // =========================
    // INSERT
    // =========================
    public void insert(Invoice invoice) {
        String sql = "INSERT INTO Invoices(invoice_code, amount, status, created_by, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
        String sql = "UPDATE Invoices SET amount = ?, status = ?, updated_at = ? " +
                     "WHERE invoice_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // MAP RESULT
    // =========================
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
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package repository;

import entity.InvoiceDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBConnection;

public class InvoiceDetailDAO {

    // Thêm 1 dòng chi tiết hóa đơn vào DB
    public void insert(InvoiceDetail detail) {
        String sql = "INSERT INTO Invoice_Details (invoice_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, detail.getInvoiceId());
            ps.setLong(2, detail.getProductId());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getUnitPrice());
            ps.setBigDecimal(5, detail.getTotalPrice());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy chi tiết của 1 hóa đơn 
    // join thêm bảng Products để lấy ra tên sản phẩm luôn cho tiện hiển thị
    public List<InvoiceDetail> findByInvoiceId(Long invoiceId) {
        List<InvoiceDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, p.product_name FROM Invoice_Details d "
                + "JOIN Products p ON d.product_id = p.product_id "
                + "WHERE d.invoice_id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                InvoiceDetail d = new InvoiceDetail();
                d.setDetailId(rs.getLong("detail_id"));
                d.setInvoiceId(rs.getLong("invoice_id"));
                d.setProductId(rs.getLong("product_id"));
                d.setQuantity(rs.getInt("quantity"));
                d.setUnitPrice(rs.getBigDecimal("unit_price"));
                d.setTotalPrice(rs.getBigDecimal("total_price"));
                d.setProductName(rs.getString("product_name"));

                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Xóa toàn bộ chi tiết của 1 hóa đơn (Dùng khi Edit hóa đơn: Xóa hết cái cũ, insert lại cái mới)
    public void deleteByInvoiceId(Long invoiceId) {
        String sql = "DELETE FROM Invoice_Details WHERE invoice_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, invoiceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

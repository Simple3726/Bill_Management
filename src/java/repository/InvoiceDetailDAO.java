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
        String sql = "INSERT INTO Invoice_Details (invoice_id, product_id, product_name, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, detail.getInvoiceId());
            ps.setLong(2, detail.getProductId());
            ps.setString(3, detail.getProductName());
            ps.setInt(4, detail.getQuantity());
            ps.setBigDecimal(5, detail.getUnitPrice());
            ps.setBigDecimal(6, detail.getTotalPrice());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    // Lấy chi tiết của 1 hóa đơn 
    // join thêm bảng Products để lấy ra tên sản phẩm luôn cho tiện hiển thị
    // Lấy chi tiết của 1 hóa đơn (Dùng cho lúc bấm Xem/Sửa Hóa đơn)
    public List<InvoiceDetail> findByInvoiceId(Long invoiceId) {
        List<InvoiceDetail> list = new ArrayList<>();
        
        String sql = "SELECT * FROM Invoice_Details WHERE invoice_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                InvoiceDetail d = new InvoiceDetail();
                d.setDetailId(rs.getLong("detail_id"));
                d.setInvoiceId(rs.getLong("invoice_id"));
                d.setProductId(rs.getLong("product_id"));
                d.setProductName(rs.getString("product_name")); 
                d.setQuantity(rs.getInt("quantity"));
                d.setUnitPrice(rs.getBigDecimal("unit_price"));
                d.setTotalPrice(rs.getBigDecimal("total_price"));
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

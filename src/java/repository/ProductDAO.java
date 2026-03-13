/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package repository;

import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import utils.DBConnection;

/**
 *
 * @author Nguyen Xuan Tan
 */
public class ProductDAO {

    public void insert(Product product) {
        String sql = "INSERT INTO Products (product_name, price, status, created_at)"
                + "VALUES(?, ?, ?, ?)";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setBigDecimal(2, product.getPrice());
            ps.setString(3, product.getStatus());
            ps.setTimestamp(4, Timestamp.valueOf(product.getCreatedAt()));

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void update(Product product) {
        String sql = "UPDATE Products SET product_name = ?, price = ?, status = ?, updated_at = ? WHERE product_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setBigDecimal(2, product.getPrice());
            ps.setString(3, product.getStatus());
            ps.setTimestamp(4, Timestamp.valueOf(product.getUpdatedAt()));
            ps.setLong(5, product.getProductId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void delete(Long productId, LocalDateTime updateAt){
        String sql = "UPDATE Products SET status = 'DELETED' , updated_at = ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setTimestamp(1, Timestamp.valueOf(updateAt));
            ps.setLong(2, productId);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public boolean checkExistProduct(String productName, Long excludeProductId){
        String sql = "SELECT COUNT(*) FROM Products WHERE product_name = ? AND status != 'DELETED' ";
        if(excludeProductId != null){
            sql += "AND product_id != ?";
        }
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1, productName);
            if(excludeProductId != null){
                ps.setLong(2, excludeProductId);
            }
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()){
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Product> findAllProduct() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE status != 'DELETED' ORDER BY product_name ASC";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product findById(Long id) {
        String sql = "SELECT * FROM Products WHERE product_id = ?";
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

    public Product findProductByName(String productName) {
        String sql = "SELECT * FROM Products WHERE product_name = ? AND status != 'DELETED'";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productName);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Product mapResultSet(ResultSet rs) throws SQLException{
        Product p = new Product();
        p.setProductId(rs.getLong("product_id"));
        p.setProductName(rs.getString("product_name"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStatus(rs.getString("status"));
        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            p.setCreatedAt(createdTs.toLocalDateTime());
        }
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            p.setUpdatedAt(updatedTs.toLocalDateTime());
        }
        return p;
    }
}

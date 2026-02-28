package repository;

import entity.User;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public User login(String userID, String password) throws SQLException, ClassNotFoundException {
        String sql = "";
        User acc = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, userID);
            ps.setString(2, password);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                String username = rs.getString("username");
                acc = new User(Long.MIN_VALUE, username, password, sql, sql, LocalDateTime.MAX);
            }
        }finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        return acc;
    }

    // ===============================
    // CREATE
    // ===============================
    public boolean insert(User user) {
        String sql = "INSERT INTO Users(username, password_hash, role, status, created_at) " +
                     "VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===============================
    // READ BY ID
    // ===============================
    public User findById(long id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // READ BY USERNAME (LOGIN)
    // ===============================
    public User findByUsername(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // GET ALL
    // ===============================
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===============================
    // UPDATE USER INFO
    // ===============================
    public boolean update(User user) {
        String sql = "UPDATE Users SET username=?, role=?, status=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getRole());
            ps.setString(3, user.getStatus());
            ps.setLong(4, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===============================
    // UPDATE PASSWORD
    // ===============================
    public boolean updatePassword(long userId, String newHash) {
        String sql = "UPDATE Users SET password_hash=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHash);
            ps.setLong(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===============================
    // UPDATE STATUS (LOCK / ACTIVE)
    // ===============================
    public boolean updateStatus(long userId, String status) {
        String sql = "UPDATE Users SET status=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setLong(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===============================
    // DELETE
    // ===============================
    public boolean delete(long userId) {
        String sql = "DELETE FROM Users WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===============================
    // HELPER: Map ResultSet -> User
    // ===============================
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getLong("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            user.setCreatedAt(ts.toLocalDateTime());
        }   
        return user;
    }
}
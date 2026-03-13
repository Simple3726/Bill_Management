package entity;

import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class User {

    private Long userId;
    private String username;
    private String password;
    private String role;      // ADMIN / STAFF / AUDITOR
    private String status;    // ACTIVE / LOCKED/ OFFLINE
    private LocalDateTime createdAt;

    public User() {
    }

    public User(Long userId, String username, String password, String role, String status, LocalDateTime createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }                                                                                         

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
}

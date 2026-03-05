package service;

import entity.User;
import java.util.List;
import repository.UserDAO;

public class UserService {

    private UserDAO userDAO = new UserDAO();

    // ================================
    // CREATE USER
    // ================================
    public boolean createUser(User user) throws Exception {

        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new Exception("Username cannot be empty");
        }

        if (user.getPassword() == null || user.getPassword().length() < 4) {
            throw new Exception("Password must be at least 4 characters");
        }

        if (user.getRole() == null) {
            throw new Exception("Role is required");
        }

        // Check duplicate username
        User existUser = userDAO.findByUsername(user.getUsername());

        if (existUser != null) {
            throw new Exception("Username already exists");
        }

        // Default status
        if (user.getStatus() == null) {
            user.setStatus("ACTIVE");
        }

        return userDAO.insert(user);
    }

    // ================================
    // GET ALL USERS
    // ================================
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    // ================================
    // GET USER BY ID
    // ================================
    public User getUserById(long id) {
        return userDAO.findById(id);
    }

    // ================================
    // UPDATE USER INFO
    // ================================
    public boolean updateUser(User user) throws Exception {

        if (user.getUserId() == null) {
            throw new Exception("User ID is required");
        }

        User existing = userDAO.findById(user.getUserId());

        if (existing == null) {
            throw new Exception("User not found");
        }

        return userDAO.update(user);
    }

    // ================================
    // CHANGE PASSWORD
    // ================================
    public boolean changePassword(long userId, String newPassword) throws Exception {

        if (newPassword == null || newPassword.length() < 4) {
            throw new Exception("Password must be at least 4 characters");
        }

        return userDAO.updatePassword(userId, newPassword);
    }

    // ================================
    // LOCK USER
    // ================================
    public boolean lockUser(long userId) {
        return userDAO.updateStatus(userId, "LOCKED");
    }

    // ================================
    // ACTIVATE USER
    // ================================
    public boolean activateUser(long userId) {
        return userDAO.updateStatus(userId, "ACTIVE");
    }

    // ================================
    // DELETE USER
    // ================================
    public boolean deleteUser(long userId) {
        return userDAO.delete(userId);
    }

    // ================================
    // STAFF METRICS
    // ================================
    public int countAllStaff() {
        return userDAO.countAllStaff();
    }

    public int countActiveStaff() {
        return userDAO.countActiveStaff();
    }
}

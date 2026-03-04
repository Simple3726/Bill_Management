package service;

import entity.Alert;
import repository.AlertDAO;

import java.time.LocalDateTime;
import java.util.List;

public class AlertService {

    private AlertDAO alertDAO = new AlertDAO();

    // =========================================
    // Create Alert
    // =========================================
    public void createAlert(String entityType,
                            Long entityId,
                            int riskScore,
                            String message) {

        Alert alert = new Alert();
        alert.setEntityType(entityType);
        alert.setEntityId(entityId);
        alert.setRiskScore(riskScore);
        alert.setMessage(message);
        alert.setStatus("NEW");
        alert.setCreatedAt(LocalDateTime.now());

        alertDAO.insert(alert);
    }

    // =========================================
    // Get all Alert
    // =========================================
    public List<Alert> getAllAlerts() {
        return alertDAO.findAll();
    }

    // =========================================
    // Get Alert by Status
    // =========================================
    public List<Alert> getAlertsByStatus(String status) {
        return alertDAO.findByStatus(status);
    }

    // =========================================
    // INVESTIGATING
    // =========================================
    public void investigateAlert(Long alertId) {
        alertDAO.updateStatus(alertId, "INVESTIGATING");
    }

    // =========================================
    // Resolve Alert
    // =========================================
    public void resolveAlert(Long alertId) {
        alertDAO.updateStatus(alertId, "RESOLVED");
    }
}
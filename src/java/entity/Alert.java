package entity;

import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class Alert {

    private Long alertId;
    private String entityType; // USER / INVOICE / SHIFT
    private Long entityId;
    private Integer riskScore;
    private String message;
    private String status; // NEW / INVESTIGATING / RESOLVED
    private LocalDateTime createdAt;
    private String fraud;
    public Alert() {
    }

    public Alert(Long alertId, String entityType, Long entityId, Integer riskScore, String message, String status, LocalDateTime createdAt, String fraud) {
        this.alertId = alertId;
        this.entityType = entityType;
        this.entityId = entityId;
        this.riskScore = riskScore;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
        this.fraud = fraud;
    }

    public Long getAlertId() {
        return alertId;
    }

    public void setAlertId(Long alertId) {
        this.alertId = alertId;
    }

    public String getEntityType() {
        return entityType;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public Long getEntityId() {
        return entityId;
    }

    public void setEntityId(Long entityId) {
        this.entityId = entityId;
    }

    public Integer getRiskScore() {
        return riskScore;
    }

    public void setRiskScore(Integer riskScore) {
        this.riskScore = riskScore;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
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

    public String getFraud() {
        return fraud;
    }

    public void setFraud(String fraud) {
        this.fraud = fraud;
    }
    
}

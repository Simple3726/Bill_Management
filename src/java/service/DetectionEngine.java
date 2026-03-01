package service;

import entity.Invoice;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class DetectionEngine {

    public static class RiskResult {
        private int score;
        private String level;
        private String message;

        public RiskResult(int score, String level, String message) {
            this.score = score;
            this.level = level;
            this.message = message;
        }

        public int getScore() {
            return score;
        }

        public String getLevel() {
            return level;
        }

        public String getMessage() {
            return message;
        }
    }

    public RiskResult analyze(
            BigDecimal oldAmount,
            BigDecimal newAmount,
            int editCount,
            LocalDateTime actionTime,
            LocalTime shiftStart,
            LocalTime shiftEnd
    ) {

        int score = 0;
        StringBuilder reason = new StringBuilder();

        // ==============================
        // RULE 1: Amount Change %
        // ==============================
        if (oldAmount != null && oldAmount.compareTo(BigDecimal.ZERO) > 0) {

            BigDecimal diff = newAmount.subtract(oldAmount).abs();
            BigDecimal percent = diff.divide(oldAmount, 2, RoundingMode.HALF_UP);

            if (percent.compareTo(new BigDecimal("0.5")) > 0) {
                score += 60;
                reason.append("Amount changed > 50%. ");
            } else if (percent.compareTo(new BigDecimal("0.3")) > 0) {
                score += 40;
                reason.append("Amount changed 30-50%. ");
            } else if (percent.compareTo(new BigDecimal("0.1")) > 0) {
                score += 20;
                reason.append("Amount changed 10-30%. ");
            }
        }

        // ==============================
        // RULE 2: Out of Shift
        // ==============================
        if (shiftStart != null && shiftEnd != null) {
            LocalTime actionLocalTime = actionTime.toLocalTime();

            if (actionLocalTime.isBefore(shiftStart)
                    || actionLocalTime.isAfter(shiftEnd)) {

                score += 30;
                reason.append("Action performed outside shift time. ");
            }
        }

        // ==============================
        // RULE 3: Multiple Edits
        // ==============================
        if (editCount >= 5) {
            score += 40;
            reason.append("Invoice edited more than 5 times in a shift. ");
        } else if (editCount >= 3) {
            score += 20;
            reason.append("Invoice edited 3-4 times in a shift. ");
        }

        // ==============================
        // RULE 4: High Amount
        // ==============================
        if (newAmount.compareTo(new BigDecimal("200000000")) > 0) {
            score += 40;
            reason.append("High value invoice (>200M). ");
        } else if (newAmount.compareTo(new BigDecimal("50000000")) > 0) {
            score += 20;
            reason.append("Medium-high value invoice (>50M). ");
        }

        // ==============================
        // CAP SCORE
        // ==============================
        if (score > 100) {
            score = 100;
        }

        // ==============================
        // DETERMINE LEVEL
        // ==============================
        String level;
        if (score >= 70) {
            level = "HIGH";
        } else if (score >= 40) {
            level = "MEDIUM";
        } else {
            level = "LOW";
        }

        if (reason.length() == 0) {
            reason.append("No abnormal behavior detected.");
        }

        return new RiskResult(score, level, reason.toString());
    }
}
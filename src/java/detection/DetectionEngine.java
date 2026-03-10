package detection;

import entity.Shift;
import utils.Constants;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class DetectionEngine {

    public static class RiskResult {

        private final int score;
        private final String level;
        private final String message;

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
            Shift currShift
    ) {

        int score = 0;
        StringBuilder reason = new StringBuilder();

        // =========================================
        // RULE 1: Amount Change Percentage
        // =========================================
        score += calculateAmountChangeRisk(
                oldAmount, newAmount, reason);

        // =========================================
        // RULE 2: Action Outside Shift
        // =========================================
        score += calculateShiftRisk(
                currShift, reason);

        // =========================================
        // RULE 3: Multiple Edits
        // =========================================
        score += calculateEditRisk(
                editCount, reason);

        // =========================================
        // RULE 4: High Invoice Value
        // =========================================
        score += calculateHighValueRisk(
                newAmount, reason);

        // =========================================
        // CAP SCORE
        // =========================================
        if (score > Constants.MAX_SCORE) {
            score = Constants.MAX_SCORE;
        }

        // =========================================
        // DETERMINE LEVEL
        // =========================================
        String level;

        if (score >= Constants.RISK_HIGH_THRESHOLD) {
            level = "HIGH";
        } else if (score >= Constants.RISK_MEDIUM_THRESHOLD) {
            level = "MEDIUM";
        } else {
            level = "LOW";
        }

        if (reason.length() == 0) {
            reason.append("No abnormal behavior detected.");
        }

        return new RiskResult(score, level, reason.toString());
    }
    
    public RiskResult analyzeCreate(
            BigDecimal amount,
            Shift currShifft
    ){
        int score = 0;
        StringBuilder reason = new StringBuilder();
        
        //gia nam ngoai outlier

        score+=calculateHighValueRisk(amount, reason);
        
        //Ngoai ca lam viec
            score+=calculateShiftRisk(currShifft, reason);
        
        String level;
        if (score >= Constants.RISK_HIGH_THRESHOLD) {
            level = "HIGH";
        } else if (score >= Constants.RISK_MEDIUM_THRESHOLD) {
            level = "MEDIUM";
        } else {
            level = "LOW";
        }

        if (reason.length() == 0) {
            reason.append("No abnormal behavior detected.");
        }
        return new RiskResult(score, level, reason.toString());
    }
    
    public RiskResult analyzeDelete(Shift currShift){
        StringBuilder reason = new StringBuilder();
        
        int score = 0;
        score += calculateShiftRisk(currShift, reason);
        
        String level;
        if (score >= Constants.RISK_HIGH_THRESHOLD) {
            level = "HIGH";
        } else if (score >= Constants.RISK_MEDIUM_THRESHOLD) {
            level = "MEDIUM";
        } else {
            level = "LOW";
        }
        
        return new RiskResult(score, level, reason.toString());
    }
    
    // ==================================================
    // PRIVATE RULE METHODS
    // ==================================================
    private int calculateAmountChangeRisk(
            BigDecimal oldAmount,
            BigDecimal newAmount,
            StringBuilder reason) {

        if (oldAmount == null || oldAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }

        BigDecimal diff = newAmount.subtract(oldAmount).abs();
        BigDecimal percent = diff.divide(oldAmount, 2, RoundingMode.HALF_UP);

        if (percent.compareTo(Constants.AMOUNT_DIFF_HIGH) > 0) {
            reason.append("Amount changed > 50%. ");
            return Constants.SCORE_AMOUNT_HIGH;

        } else if (percent.compareTo(Constants.AMOUNT_DIFF_MEDIUM) > 0) {
            reason.append("Amount changed 30-50%. ");
            return Constants.SCORE_AMOUNT_MEDIUM;

        } else if (percent.compareTo(Constants.AMOUNT_DIFF_LOW) > 0) {
            reason.append("Amount changed 10-30%. ");
            return Constants.SCORE_AMOUNT_LOW;
        }

        return 0;
    }

    private int calculateShiftRisk(
            Shift currShift,
            StringBuilder reason) {

        if (currShift == null) {
            reason.append("Action performed outside shift time. ");
            return Constants.SCORE_OUTSIDE_SHIFT;
        }

        return 0;
    }

    private int calculateEditRisk(
            int editCount,
            StringBuilder reason) {

        if (editCount >= Constants.EDIT_COUNT_HIGH) {
            reason.append("Invoice edited more than 5 times in a shift. ");
            return Constants.SCORE_EDIT_HIGH;

        } else if (editCount >= Constants.EDIT_COUNT_MEDIUM) {
            reason.append("Invoice edited 3-4 times in a shift. ");
            return Constants.SCORE_EDIT_MEDIUM;
        }

        return 0;
    }

    private int calculateHighValueRisk(
            BigDecimal newAmount,
            StringBuilder reason) {

        if (newAmount.compareTo(Constants.HIGH_VALUE_INVOICE) > 0) {
            reason.append("High value invoice (>200M). ");
            return Constants.SCORE_HIGH_VALUE;

        } else if (newAmount.compareTo(Constants.MEDIUM_VALUE_INVOICE) > 0) {
            reason.append("Medium-high value invoice (>50M). ");
            return Constants.SCORE_MEDIUM_VALUE;
        }

        return 0;
    }
}

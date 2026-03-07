package utils;

import java.math.BigDecimal;

public class Constants {

    // ================================
    // AMOUNT CHANGE THRESHOLDS
    // ================================
    public static final BigDecimal AMOUNT_DIFF_HIGH = new BigDecimal("0.5");   // Edit price diff >50%
    public static final BigDecimal AMOUNT_DIFF_MEDIUM = new BigDecimal("0.3"); // >30%
    public static final BigDecimal AMOUNT_DIFF_LOW = new BigDecimal("0.1");    // >10%

    public static final int SCORE_AMOUNT_HIGH = 60;
    public static final int SCORE_AMOUNT_MEDIUM = 40;
    public static final int SCORE_AMOUNT_LOW = 20;

    // ================================
    // SHIFT RULE
    // ================================
    public static final int SCORE_OUTSIDE_SHIFT = 40;

    // ================================
    // EDIT RULE
    // ================================
    public static final int EDIT_COUNT_HIGH = 5;
    public static final int EDIT_COUNT_MEDIUM = 3;

    public static final int SCORE_EDIT_HIGH = 40;
    public static final int SCORE_EDIT_MEDIUM = 20;

    // ================================
    // HIGH AMOUNT RULE
    // ================================
    public static final BigDecimal HIGH_VALUE_INVOICE
            = new BigDecimal("200000000");

    public static final BigDecimal MEDIUM_VALUE_INVOICE
            = new BigDecimal("50000000");

    public static final int SCORE_HIGH_VALUE = 40;
    public static final int SCORE_MEDIUM_VALUE = 20;

    // ================================
    // RISK LEVEL
    // ================================
    public static final int MAX_SCORE = 100;
    public static final int RISK_HIGH_THRESHOLD = 70;
    public static final int RISK_MEDIUM_THRESHOLD = 40;

}

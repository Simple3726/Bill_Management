package service;

import repository.AlertDAO;
import repository.InvoiceDAO;
import repository.ShiftDAO;
import repository.UserDAO;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class DashBoardService {

    private AlertDAO alertDAO = new AlertDAO();
    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private ShiftDAO shiftDAO = new ShiftDAO();
    private UserDAO userDAO = new UserDAO();

    // ==========================================================
    // MAIN DASHBOARD METHOD (Today / Week / Month)
    // ==========================================================
    public Map<String, Object> getDashboardData(String period) {

        Map<String, Object> data = new HashMap<>();

        if (period == null) {
            period = "today";
        }

        // ------------------------------------------------------
        // 1️⃣ Calculate Date Range
        // ------------------------------------------------------

        LocalDate start;
        LocalDate end = LocalDate.now();

        switch (period.toLowerCase()) {
            case "week":
                start = LocalDate.now().with(DayOfWeek.MONDAY);
                break;

            case "month":
                start = LocalDate.now().withDayOfMonth(1);
                break;

            default:
                start = LocalDate.now();
        }

        // ------------------------------------------------------
        // 2️⃣ BUSINESS METRICS
        // ------------------------------------------------------

        BigDecimal totalRevenue =
                invoiceDAO.getRevenueBetween(start, end);

        int totalInvoice =
                invoiceDAO.countInvoiceBetween(start, end);

        BigDecimal avgInvoice =
                invoiceDAO.getAverageInvoiceBetween(start, end);

        int invoiceWithAlert =
                invoiceDAO.countInvoiceWithAlertBetween(start, end);

        double riskRate = 0;
        if (totalInvoice > 0) {
            riskRate = (double) invoiceWithAlert / totalInvoice * 100;
        }

        // ------------------------------------------------------
        // 3️⃣ ALERT METRICS
        // ------------------------------------------------------

        int totalAlert =
                alertDAO.countAlertBetween(start, end);

        int newAlert =
                alertDAO.countAlertByStatusBetween("NEW", start, end);

        int investigatingAlert =
                alertDAO.countAlertByStatusBetween("INVESTIGATING", start, end);

        int resolvedAlert =
                alertDAO.countAlertByStatusBetween("RESOLVED", start, end);

        // ------------------------------------------------------
        // 4️⃣ OPERATION METRICS
        // ------------------------------------------------------

        int totalShift =
                shiftDAO.countShiftBetween(start, end);

        int totalStaff =
                userDAO.countAllStaff();

        int activeStaff =
                userDAO.countActiveStaff();

        // ------------------------------------------------------
        // 5️⃣ Put all into Map
        // ------------------------------------------------------

        data.put("START_DATE", start);
        data.put("END_DATE", end);

        data.put("TOTAL_REVENUE", totalRevenue);
        data.put("TOTAL_INVOICE", totalInvoice);
        data.put("AVG_INVOICE", avgInvoice);
        data.put("INVOICE_WITH_ALERT", invoiceWithAlert);
        data.put("RISK_RATE", riskRate);

        data.put("TOTAL_ALERT", totalAlert);
        data.put("NEW_ALERT", newAlert);
        data.put("INVESTIGATING_ALERT", investigatingAlert);
        data.put("RESOLVED_ALERT", resolvedAlert);

        data.put("TOTAL_SHIFT", totalShift);
        data.put("TOTAL_STAFF", totalStaff);
        data.put("ACTIVE_STAFF", activeStaff);

        return data;
    }
}
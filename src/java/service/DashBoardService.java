package service;

import repository.AlertDAO;
import repository.InvoiceDAO;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class DashBoardService {

    private AlertDAO alertDAO = new AlertDAO();
    private InvoiceDAO invoiceDAO = new InvoiceDAO();

    // =========================================
    // Alert Summary
    // =========================================
    public Map<String, Integer> getAlertSummary() {

        Map<String, Integer> summary = new HashMap<>();

        summary.put("TOTAL", alertDAO.countAll());
        summary.put("NEW", alertDAO.countByStatus("NEW"));
        summary.put("INVESTIGATING", alertDAO.countByStatus("INVESTIGATING"));
        summary.put("RESOLVED", alertDAO.countByStatus("RESOLVED"));

        return summary;
    }

    // =========================================
    // Risk Overview (Today)
    // =========================================
    public Map<String, Object> getTodayRiskOverview() {

        Map<String, Object> data = new HashMap<>();

        LocalDate today = LocalDate.now();

        int totalInvoice = invoiceDAO.countByDate(today);
        int totalAlertToday = invoiceDAO.countInvoiceHaveAlert(today);

        double riskRate = 0;

        if (totalInvoice > 0) {
            riskRate = (double) totalAlertToday / totalInvoice * 100;
        }

        data.put("TOTAL_INVOICE", totalInvoice);
        data.put("TOTAL_ALERT_INVOICE", totalAlertToday);
        data.put("RISK_RATE", riskRate);

        return data;
    }
}
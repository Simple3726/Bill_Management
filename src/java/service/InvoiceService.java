package service;

import entity.Invoice;
import entity.InvoiceHistory;
import entity.Shift;
import entity.User;

import repository.InvoiceDAO;
import repository.InvoiceHistoryDAO;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class InvoiceService {

    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private InvoiceHistoryDAO historyDAO = new InvoiceHistoryDAO();
    private ShiftService shiftService = new ShiftService();
    private LogService logService = new LogService();
    private AlertService alertService = new AlertService();
    private DetectionEngine engine = new DetectionEngine();

    public void approveInvoice(Long invoiceId, User currentUser) {

        // =========================
        // 1. Check Role
        // =========================
        if (!currentUser.getRole().equalsIgnoreCase("AUDITOR")
                && !currentUser.getRole().equalsIgnoreCase("ADMIN")) {
            throw new RuntimeException("No permission!");
        }

        // =========================
        // 2. Get Invoice
        // =========================
        Invoice invoice = invoiceDAO.findById(invoiceId);

        if (invoice == null) {
            throw new RuntimeException("Invoice not found");
        }

        if (!invoice.getStatus().equalsIgnoreCase("PENDING")) {
            throw new RuntimeException("Only pending invoice can be approved");
        }

        // =========================
        // 3. Get last history (old amount)
        // =========================
        InvoiceHistory lastHistory = historyDAO.getLastByInvoiceId(invoiceId);

        BigDecimal oldAmount;

        if (lastHistory != null) {
            oldAmount = lastHistory.getOldAmount();
        } else {
            oldAmount = invoice.getAmount();
        }

        BigDecimal newAmount = invoice.getAmount();

        // =========================
        // 4. Count edit in current shift
        // =========================    
        Shift shift = shiftService.getCurrentShift(currentUser.getUserId());

        int editCount = historyDAO.countEditInShift(invoiceId, shift.getShiftId());

        // =========================
        // 5. Approve invoice
        // =========================
        invoice.setStatus("APPROVED");
        invoiceDAO.update(invoice);

        // =========================
        // 6. Log activity
        // =========================
        logService.addLog(
                currentUser.getUserId(),
                shift.getShiftId(),
                "APPROVE_INVOICE",
                "INVOICE",
                invoiceId,
                "Invoice approved"
        );

        // =========================
        // 7. Run Detection
        // =========================
        DetectionEngine.RiskResult result
                = engine.analyze(
                        oldAmount,
                        newAmount,
                        editCount,
                        LocalDateTime.now(),
                        shift.getStartTime().toLocalTime(),
                        shift.getEndTime().toLocalTime()
                );

        int riskScore = result.getScore();
        String message = result.getMessage();

        // =========================
        // 8. Create Alert if HIGH risk
        // =========================
        if (riskScore >= 70) {

            alertService.createAlert(
                    "INVOICE",
                    invoiceId,
                    riskScore,
                    message
            );
        }
    }
}

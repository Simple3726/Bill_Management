package service;

import detection.DetectionEngine;
import entity.Invoice;
import entity.InvoiceHistory;
import entity.Shift;
import entity.User;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import repository.InvoiceDAO;
import repository.InvoiceHistoryDAO;
import utils.Constants;

/**
 *
 * @author admin
 */
public class InvoiceService {

    /**
     * Holding the CRUD function of Invoice
     */
    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private InvoiceHistoryDAO historyDAO = new InvoiceHistoryDAO();
    private ShiftService shiftService = new ShiftService();
    private LogService logService = new LogService();
    private AlertService alertService = new AlertService();
    private DetectionEngine engine = new DetectionEngine();


    public boolean createInvoice(Invoice invoice) throws Exception {
        boolean checkCreate = false;
        //khi create can truyen vao status, createBy

        if (invoice.getAmount().compareTo(new BigDecimal(0)) <= 0) {
            throw new Exception("Amount must be larger than 0");
        }
        
        Shift currentShift = shiftService.getCurrentShift(invoice.getCreatedBy());
        invoice.setCreatedAt(LocalDateTime.now());
        DetectionEngine.RiskResult rs = engine.analyzeCreate(invoice.getAmount(), invoice.getCreatedAt(), currentShift.getStartTime().toLocalTime(), currentShift.getEndTime().toLocalTime());
        int riskScore =rs.getScore();
        String message = rs.getMessage();
        if(riskScore > Constants.RISK_MEDIUM_THRESHOLD){
            invoice.setStatus("PENDING");
            invoiceDAO.insert(invoice);
            Invoice invCheck = invoiceDAO.findByCode(invoice.getInvoiceCode());
            alertService.createAlert("INVOICE", invCheck.getInvoiceId(), riskScore, message);
        }
        else{
            invoice.setStatus("COMPLETED");
            invoiceDAO.insert(invoice);
        }
        
        return checkCreate;
    }

    public List<Invoice> getAllInvoice() {
        List<Invoice> rs = invoiceDAO.findAll();
        return rs;
    }
    
    public List<Invoice> getInvoiceByUserId(User user){
        return invoiceDAO.findInvoiceByUserId(user.getUserId());
    }
    public Invoice getInvoiceById(Long invoiceId){
        Invoice invoice = invoiceDAO.findById(invoiceId);
        return invoice;
    }
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

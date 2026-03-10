package service;

import detection.DetectionEngine;
import entity.Invoice;
import entity.InvoiceHistory;
import entity.Shift;
import entity.User;
import java.math.BigDecimal;
import java.time.LocalDateTime;
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


    public void createInvoice(Invoice invoice) throws Exception {
        boolean checkCreate = false;
        //khi create can truyen vao status, createBy
            
        if (invoice.getAmount().compareTo(new BigDecimal(0)) <= 0) {
            throw new Exception("Amount must be larger than 0");
        }
        
        Shift currentShift = shiftService.getCurrentShift(invoice.getCreatedBy());
        invoice.setCreatedAt(LocalDateTime.now());
        DetectionEngine.RiskResult rs = engine.analyzeCreate(invoice.getAmount(), currentShift);
        int riskScore =rs.getScore();
        String message = rs.getMessage();
        if(riskScore >= Constants.RISK_MEDIUM_THRESHOLD){
            invoice.setStatus("PENDING");
        } else {
            invoice.setStatus("COMPLETED");
        }
        
        // 1. Thực hiện Insert
        invoiceDAO.insert(invoice);
        
        // 2. Query lại để lấy Invoice_ID do DB tự sinh ra
        Invoice invCheck = invoiceDAO.findByCode(invoice.getInvoiceCode());
        
        // 3. CHỐT CHẶN BẢO VỆ: Nếu insert xịt, ném lỗi ra trình duyệt ngay!
        if (invCheck == null) {
            throw new Exception("Cannot save invoice into Database! Invoice Id: '" + invoice.getInvoiceCode() + "' can be duplicated. Please check console.");
        }
        
        // 4. Đảo ngược chuỗi để chống NullPointerException (Yoda Condition)
        if("PENDING".equals(invCheck.getStatus())){
            alertService.createAlert("INVOICE", invCheck.getInvoiceId(), riskScore, message);
        }
        logService.addLog(invoice.getCreatedBy(), currentShift != null ? currentShift.getShiftId() : null , "Create Invoice", "INVOICE", invoice.getInvoiceId(), LocalDateTime.now());
    }
    
    public void updateInvoice(Long invoiceId, BigDecimal newAmount, BigDecimal oldAmount, Long modified_by){
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(invoiceId);
        invoice.setAmount(newAmount);
        invoice.setStatus("PENDING");
        invoice.setUpdatedAt(LocalDateTime.now());
        Shift currentShift = shiftService.getCurrentShift(modified_by);
        int editCount = 0;
        if(currentShift != null){
            editCount = historyDAO.countEditInShift(invoiceId, currentShift.getShiftId());
        }
        DetectionEngine.RiskResult rs = engine.analyze(oldAmount, newAmount, editCount, currentShift);
        
        int riskScore = rs.getScore();
        String message = rs.getMessage();
        
        alertService.createAlert("INVOICE", invoiceId, riskScore, message);
        
        historyDAO.addHistory(invoiceId, oldAmount, newAmount, modified_by, currentShift != null ? currentShift.getShiftId() : null
                , "UPDATE", invoice.getUpdatedAt());
        invoiceDAO.update(invoice);
    }
    
    public void delete(Long invoiceId, Long user){
        Invoice invoice = invoiceDAO.findById(invoiceId);
        invoice.setStatus("DELETED");
        invoice.setUpdatedAt(LocalDateTime.now());
        Shift currShift = shiftService.getCurrentShift(user);
        invoiceDAO.cancel(invoice);
        historyDAO.addHistory(invoiceId, invoice.getAmount(), invoice.getAmount(), user, currShift != null ? currShift.getShiftId() : null, "DELETE", invoice.getUpdatedAt());
        int editCount = 0;
        if(currShift != null){
            editCount = historyDAO.countEditInShift(invoiceId, currShift.getShiftId());
        }
        DetectionEngine.RiskResult rs = engine.analyzeDelete(currShift);
        int riskScore = rs.getScore();
        String message = rs.getMessage();
        if(riskScore > Constants.RISK_MEDIUM_THRESHOLD){
            alertService.createAlert("INVOICE", invoiceId, riskScore, message);
        }
        logService.addLog(user, currShift != null ? currShift.getShiftId() : null, "DELETE_INVOICE", "INVOICE", invoiceId, invoice.getUpdatedAt());
    }
    
    public List<Invoice> getAllInvoice() {
        List<Invoice> rs = invoiceDAO.findAll();
        return rs;
    }
    
    public List<Invoice> getInvoiceByUserId(User user){
        return invoiceDAO.findInvoiceByUserIdAndStatus(user.getUserId());
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
                shift != null ? shift.getShiftId() : null,
                "APPROVE_INVOICE",
                "INVOICE",
                invoiceId,
                LocalDateTime.now()
        );

        // =========================
        // 7. Run Detection
        // =========================
        DetectionEngine.RiskResult result
                = engine.analyze(
                        oldAmount,
                        newAmount,
                        editCount,
                        shift
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

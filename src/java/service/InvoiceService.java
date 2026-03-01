package service;

import entity.ActivityLog;
import entity.Invoice;
import entity.User;
import repository.InvoiceDAO;


public class InvoiceService {
    
    public void approveInvoice(Long invoiceId,User currentUser){
        if(!currentUser.getRole().equalsIgnoreCase("AUDITOR")){
            throw new RuntimeException("No permision!");
        }
        
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice invoice = invoiceDAO.findById(invoiceId);
        
        if(!invoice.getStatus().equalsIgnoreCase("PENDING")){
            throw new RuntimeException("Only peding invoice can be approved");
        }
        invoice.setStatus("APPROVED");
        invoiceDAO.update(invoice);
       
        ShiftService shiftService = new ShiftService();
        
        ActivityLog log = new ActivityLog();
        log.setUserId(currentUser.getUserId());
        log.setShiftId(shiftService.getShiftByInvoice(invoiceId, invoice.getCreatedAt()));
        log.setActionType(invoice.getStatus());
        log.setEntityId(invoiceId);
        log.setCreatedAt(invoice.getCreatedAt());
    }
}

package service;

import entity.ActivityLog;
import entity.Invoice;
import entity.Shift;
import entity.User;
import java.util.List;
import repository.ActivityLogDAO;
import repository.InvoiceDAO;
import repository.ShiftDAO;

/**
 *
 * @author admin
 */
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
        //ghi log
        
    }
}

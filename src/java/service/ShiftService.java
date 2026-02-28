package service;

import entity.Invoice;
import entity.Shift;
import java.time.LocalDateTime;
import java.util.List;
import repository.InvoiceDAO;
import repository.ShiftDAO;

/**
 *
 * @author admin
 */
public class ShiftService {

    public Long getShiftByInvoice(Long invoiceId, LocalDateTime createdAt){
        long shiftId=0;
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice invoice = invoiceDAO.findById(invoiceId);
        
        Long userId = invoice.getCreatedBy();
        ShiftDAO shiftDAO = new ShiftDAO();
        List<Shift> shiftList =  shiftDAO.findByUser(userId);
        for(Shift s: shiftList){
            if(s.getStartTime().isBefore(createdAt) && s.getEndTime().isAfter(createdAt)){
                shiftId = s.getShiftId();
            }
        }
        return shiftId;
    }
    
}

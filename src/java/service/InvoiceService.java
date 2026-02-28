package service;

import entity.Invoice;
import entity.Shift;
import entity.User;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import repository.ShiftDAO;

/**
 *
 * @author admin
 */
public class InvoiceService {

    /**
     * Holding the CRUD function of Invoice
     */
    
    public void CreateInvoice(Invoice invoice) throws Exception{
        //khi create can truyen vao InvoiceCode, amount, status, createBy
        if(invoice.getAmount().compareTo(new BigDecimal(0)) <=0){
            throw new Exception("Amount must be larger than 0");
        }
        invoice.setInvoiceCode(invoice.generateInvoiceCode());
        invoice.setStatus("APPROVED");
        
//        if(invoice.getAmount().compareTo(new BigDecimal(5000000)) >= 0){
//            
//        }
//         Call alertDAO to make an outlier alert


    }
}

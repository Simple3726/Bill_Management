package service;

import entity.Invoice;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import javax.servlet.ServletException;
import repository.InvoiceDAO;

/**
 *
 * @author admin
 */
public class InvoiceService {

    /**
     * Holding the CRUD function of Invoice
     */
    
    private InvoiceDAO dao = new InvoiceDAO();
    
    public boolean createInvoice(Invoice invoice) throws Exception{
        boolean checkCreate = false;
        //khi create can truyen vao InvoiceCode, amount, status, createBy
        
        if(invoice.getAmount().compareTo(new BigDecimal(0)) <=0){
            throw new Exception("Amount must be larger than 0");
        }
        invoice.setInvoiceCode(invoice.generateInvoiceCode());
        invoice.setCreatedAt(LocalDateTime.now());
        invoice.setStatus("COMPLETED");
        
//        if(invoice.getAmount().compareTo(new BigDecimal(5000000)) >= 0){
//            
//        }
//         Call alertDAO to make an outlier alert
        dao.insert(invoice);
        checkCreate=true;
        return checkCreate;
    }
    
    public List<Invoice> getAllInvoice(){
        List<Invoice> rs = dao.findAll();
        return rs;
    }
}

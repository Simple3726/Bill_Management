/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import detection.DetectionEngine;
import entity.Product;
import java.time.LocalDateTime;
import java.util.List;
import repository.ProductDAO;

/**
 *
 * @author Nguyen Xuan Tan
 */
public class ProductService {
    private ProductDAO productDAO = new ProductDAO();
    private DetectionEngine engine = new DetectionEngine();
    private ShiftService shiftService = new ShiftService();
    private LogService logService = new LogService();
    private AlertService alertService = new AlertService();
    
    public List<Product> listActive(){
        List<Product> result = productDAO.findAllActive();
        
        return result;
    }
    
    public Product getProductById(Long productId){
        return productDAO.findById(productId);
    }
    
    public Product createProduct(Product product) throws Exception{
        product.setCreatedAt(LocalDateTime.now());
        
        productDAO.insert(product);
        
        Product productCheck = productDAO.findProductByName(product.getProductName());
        if(productCheck == null){
            throw new Exception("Cannot save invoice into Database! Product Name: '" + product.getProductName() + "' can be duplicated. Please check console.");
        }
        return productCheck;
    }
}

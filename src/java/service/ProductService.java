/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import detection.DetectionEngine;
import entity.Product;
import java.math.BigDecimal;
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
        List<Product> result = productDAO.findAllProduct();
        
        return result;
    }
    
    public Product getProductById(Long productId){
        return productDAO.findById(productId);
    }
    
    public Product createProduct(Product product) throws Exception{
        Product productCheck = null;
        product.setCreatedAt(LocalDateTime.now());
        
        //checking does any product with the same name is !=DELETED
        if(!productDAO.checkExistProduct(product.getProductName(), null)){
            productDAO.insert(product);
            productCheck = productDAO.findProductByName(product.getProductName());
        }
        
        return productCheck;
    }
    
    public Product updateProduct(Long productId, String productName, BigDecimal price, String status){
        Product product = new Product();
        product.setProductId(productId);
        product.setProductName(productName);
        product.setPrice(price);
        product.setStatus(status);
        product.setUpdatedAt(LocalDateTime.now());
        
        
        if(productDAO.checkExistProduct(product.getProductName(), productId)){
            return null;
        }
        
        productDAO.update(product);
        product = productDAO.findById(productId);
        
        return product;
    }
    
    public LocalDateTime deleteProduct(Long productId){
        LocalDateTime updateAt = LocalDateTime.now();
        productDAO.delete(productId, updateAt);
        return updateAt;
    }
}

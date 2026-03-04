/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author The following has evaluated to null or missing:
==> h1dra1710  [in template "Templates/Classes/Class.java" at line 12, column 14]

----
Tip: If the failing expression is known to legally refer to something that's sometimes null or missing, either specify a default value like myOptionalVar!myDefault, or use <#if myOptionalVar??>when-present<#else>when-missing</#if>. (These only cover the last step of the expression; to cover the whole expression, use parenthesis: (myOptionalVar.foo)!myDefault, (myOptionalVar.foo)??
----

----
FTL stack trace ("~" means nesting-related):
	- Failed at: ${h1dra1710}  [in template "Templates/Classes/Class.java" at line 12, column 12]
----
 */
public class MenuController extends HttpServlet{
    private static final String LOGIN = "Login";
    private static final String LOGIN_CONTROLLER = "LoginController";
 
    private static final String LOGOUT = "Logout";
    private static final String LOGOUT_CONTROLLER = "LogoutController";
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)throws  ServletException, IOException{
        response.setContentType("text/html;charset=UTF-8");
        String url = "login.jsp";
        try{
            String action = request.getParameter("action");
            if(LOGIN.equals(action)){
                url = LOGIN_CONTROLLER;
            }else if(LOGOUT.equals(action)){
                url = LOGOUT_CONTROLLER;
            }
            else{
                request.setAttribute("ERROR", "Your action not support");
            }
        }catch(Exception e){
            log("Error at MainController: " + e.toString());
        }finally{
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}

package com.kny.crm.web.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class JspFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("过滤器===");
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        if(req.getSession(false) == null || req.getSession(false).getAttribute("user") == null){
            System.out.println(req.getServletPath());
            if(!"/login.jsp".equals(req.getServletPath())){
                ((HttpServletResponse)servletResponse).sendRedirect(req.getContextPath() + "/index.html");
                return;
            }
        }
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }
}

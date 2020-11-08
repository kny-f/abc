package com.kny.crm.web.listener;

import com.kny.crm.settings.domain.DicType;
import com.kny.crm.settings.domain.DicValue;
import com.kny.crm.settings.service.DicService;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class DicListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext application = servletContextEvent.getServletContext();
        WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(application);
        DicService dicService = (DicService) wac.getBean("dicServiceImp");

        Map<String,List<DicValue>> dicMap = dicService.queryDicMap();
        Set<String> set = dicMap.keySet();
        for(String key : set){
            application.setAttribute(key, dicMap.get(key));
        }

        /*Set<Map.Entry<String, List<DicValue>>> set = dicMap.entrySet();
        for(Map.Entry<String,List<DicValue>> l : set){
            System.out.println(l.getKey());
            List<DicValue> list = l.getValue();
            for(DicValue dicValue : list){
                System.out.println("文本 ："+dicValue.getText());
                System.out.println("值   ："+dicValue.getValue());
            }
        }*/

        //============================以上是数据字典     下面是阶段所对应的可能性
        ResourceBundle r = ResourceBundle.getBundle("config/possibility");
        Enumeration<String> keys = r.getKeys();
        String json="{";
        while (keys.hasMoreElements()){
            String key = keys.nextElement();
            String value = r.getString(key);
            json += "'"+key+"'" + ":" + "'"+value+"'";
            if(keys.hasMoreElements()){
                json += ",";
            }
        }
        json += "}";
        application.setAttribute("possibility",json);
        System.out.println("=========="+json);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}

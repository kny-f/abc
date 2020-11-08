package com.kny.crm.settings.controller;

import com.kny.crm.settings.domain.User;
import com.kny.crm.settings.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @RequestMapping(value = "/query-exist.do",method = RequestMethod.POST)
    @ResponseBody
    public Map login(HttpServletRequest request, @RequestParam("loginAct")String loginAct, @RequestParam("loginPwd")String loginPwd){

        Map map = new HashMap();
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        UserService userService = (UserService) wc.getBean("userServiceImp");
        try{
            User user = userService.queryUser(loginAct,loginPwd,request.getRemoteAddr());
            request.getSession().setAttribute("user",user);
        }catch (Exception e){
            map.put("success",false);
            map.put("msg",e.getMessage());
            return map;
        }
        map.put("success",true);
        return map;
    }


}

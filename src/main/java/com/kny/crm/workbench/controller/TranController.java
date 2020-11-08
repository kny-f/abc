package com.kny.crm.workbench.controller;

import com.kny.crm.settings.domain.User;
import com.kny.crm.utils.DateTimeUtil;
import com.kny.crm.workbench.domain.Tran;
import com.kny.crm.workbench.domain.TranHistory;
import com.kny.crm.workbench.service.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/tran")
public class TranController {
    @RequestMapping(value = "/query-allUser.do",method = RequestMethod.GET)
    @ResponseBody
    public List queryAllName(HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        List userList = activityService.queryAllUser();
        return userList;
    }

    @RequestMapping(value = "/getCustomerName.do",method = RequestMethod.GET)
    @ResponseBody
    public List getCustomerName(@RequestParam("name") String name, HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        CustomerService customerService = (CustomerService) wc.getBean("customerServiceImp");
        List<String> userList = customerService.getCustomerName(name);
        return userList;
    }

    @RequestMapping(value = "/query-activity.do",method = RequestMethod.GET)
    @ResponseBody
    public List queryActivity(@RequestParam("name") String name, HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueServiceImp = (ClueService) wc.getBean("clueServiceImp");
        List actList = clueServiceImp.queryLikeAct(name);
        return actList;
    }

    @RequestMapping(value = "/query-contacts.do",method = RequestMethod.GET)
    @ResponseBody
    public List queryContacts(@RequestParam("name") String name, HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ContactsService contactsService = (ContactsService) wc.getBean("contactsServiceImp");
        List conList = contactsService.queryLikeCon(name);
        return conList;
    }

    @RequestMapping(value = "/save-tran.do",method = RequestMethod.POST)
    public String saveTran(Tran tran,String customerName, HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        TranService tranService = (TranService) wc.getBean("tranServiceImp");
        tran.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        try{
            tranService.saveTran(tran,customerName);
        }catch (Exception e){
            e.printStackTrace();
            //保存失败应跳转到一个失败提示信息页面
        }
        return "redirect:/workbench/transaction/index.jsp";
    }

    @RequestMapping(value = "/detail.do",method = RequestMethod.GET)
    public ModelAndView detail(@RequestParam("id") String id, HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        TranService tranService = (TranService) wc.getBean("tranServiceImp");
        Tran tran = tranService.getTran(id);
        List<TranHistory> list = tranService.getTranHisList(id);
        ModelAndView mav = new ModelAndView();
        mav.addObject("tran",tran);
        mav.addObject("tranHisList",list);
        mav.setViewName("forward:/workbench/transaction/detail.jsp");
        return mav;
    }

    @RequestMapping(value = "/changeStage.do",method = RequestMethod.GET)
    @ResponseBody
    public Map changeStage(Tran tran, HttpServletRequest request){
        //接收tran中只包含id,阶段,预计成交日期，金额
        tran.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        tran.setEditTime(DateTimeUtil.getSysTime());
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        TranService tranService = (TranService) wc.getBean("tranServiceImp");
        Map map = new HashMap();
        boolean success = true;
        try{
            tranService.changeStage(tran);
            map.put("editTime",tran.getEditTime());
        }catch (Exception e){
            e.printStackTrace();
            success = false;
        }
        map.put("success",success);
        return map;
    }
}

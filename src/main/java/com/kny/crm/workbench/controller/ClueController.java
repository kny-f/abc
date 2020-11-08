package com.kny.crm.workbench.controller;

import com.kny.crm.settings.domain.User;
import com.kny.crm.workbench.domain.Activity;
import com.kny.crm.workbench.domain.Clue;
import com.kny.crm.workbench.service.ActivityService;
import com.kny.crm.workbench.service.ClueService;
import com.kny.crm.workbench.vo.ClueConvert;
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
@RequestMapping("/clue")
public class ClueController {

    @RequestMapping(value = "/query-allUser.do",method = RequestMethod.GET)
    @ResponseBody
    public List queryAllName(HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        List userList = activityService.queryAllUser();
        return userList;
    }

    @RequestMapping(value = "/save-clue.do",method = RequestMethod.POST)
    @ResponseBody
    public boolean saveClue(HttpServletRequest request, Clue clue){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");

        User user = (User) request.getSession().getAttribute("user");
        boolean flag = clueService.saveClue(clue,user);
        return flag;
    }

    @RequestMapping(value = "/detail.do",method = RequestMethod.GET)
    public ModelAndView detail(HttpServletRequest request, @RequestParam("id") String id){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");

        Clue clue = clueService.queryClue(id);
        ModelAndView mav = new ModelAndView();
        mav.addObject("clue",clue);
        mav.setViewName("forward:/workbench/clue/detail.jsp");
        return mav;
    }

    @RequestMapping(value = "/query-clueActivity.do",method = RequestMethod.GET)
    @ResponseBody
    public List clueActivity(HttpServletRequest request, @RequestParam("id") String id){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");
        List<Activity> list = clueService.queryClueActivity(id);

        return list;
    }

    @RequestMapping(value = "/del-clueActivity.do",method = RequestMethod.GET)
    @ResponseBody
    public boolean delActivity(HttpServletRequest request, @RequestParam("id") String id){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");
        boolean flag = false;
        flag = clueService.delClueActivity(id);

        return flag;
    }

    @RequestMapping(value = "/query-actByName.do",method = RequestMethod.GET)
    @ResponseBody
    public List queryActByName(HttpServletRequest request, @RequestParam("clueId") String clueId,@RequestParam("name") String likeName){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");
        Map map = new HashMap();
        map.put("clueId",clueId);
        map.put("name",likeName);

        List activityList = clueService.queryActByName(map);

        return activityList;
    }

    @RequestMapping(value = "/save-bindAct.do",method = RequestMethod.GET)
    @ResponseBody
    public boolean saveBindAct(@RequestParam("clueId") String clueId,@RequestParam("actId") String[] actIds,HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");
        boolean flag = clueService.saveBindAct(clueId,actIds);
        return flag;
    }

    @RequestMapping(value = "/query-actByCId.do",method = RequestMethod.GET)
    @ResponseBody
    public List queryActCId(@RequestParam("name") String name,HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");
        List list = clueService.queryLikeAct(name);
        return list;
    }

    @RequestMapping(value = "/convert.do")
    public String convert(ClueConvert clueConvert,HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ClueService clueService = (ClueService) wc.getBean("clueServiceImp");
        clueConvert.setFlag("POST".equals(request.getMethod()));   //=====为真表示需要创建交易
        clueConvert.setUserName(((User)request.getSession().getAttribute("user")).getName());
        try {
            clueService.convert(clueConvert);
        }catch (Exception e){
            System.out.println(e.getMessage());
            return "redirect:/clue/detail.do?id="+clueConvert.getClueId();
        }
        //转换成功跳转到线索页 失败跳转到该条线索详情页
        return "redirect:/workbench/clue/index.jsp";
    }
}

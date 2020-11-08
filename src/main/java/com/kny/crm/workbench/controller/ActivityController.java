package com.kny.crm.workbench.controller;

import com.kny.crm.settings.domain.User;
import com.kny.crm.workbench.domain.Activity;
import com.kny.crm.workbench.domain.ActivityRemark;
import com.kny.crm.workbench.vo.PageRequestPram;
import com.kny.crm.workbench.service.ActivityService;
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
@RequestMapping("/activity")
public class ActivityController {

    @RequestMapping(value = "/save-activity.do",method = RequestMethod.POST)
    @ResponseBody
    public Map saveActivity(HttpServletRequest request, Activity activity){

        WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wac.getBean("activityServiceImp");
        Map map = new HashMap();

        try{
            activityService.saveActivity(activity,(User)request.getSession(false).getAttribute("user"));
        }catch (Exception e){
            map.put("success", false);
            if(e.getMessage() == null){
                map.put("msg","服务器繁忙，请稍后再试");
            }else {
                map.put("msg",e.getMessage());
            }

            return map;
        }
        map.put("success",true);
        return map;
    }

    @RequestMapping(value = "/del-activityList.do",method = RequestMethod.POST)
    @ResponseBody
    public Map delActivityList(HttpServletRequest request, @RequestParam("id") String[] id){
        WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wac.getBean("activityServiceImp");
        Map map = activityService.delActivityList(id);
        return map;
    }

    @RequestMapping(value = "/update-activity.do",method = RequestMethod.POST)
    @ResponseBody
    public Map updateActivity(HttpServletRequest request, Activity activity){
        WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wac.getBean("activityServiceImp");

        System.out.println("控制器====更新");
        Map map = new HashMap();
        try{
                activityService.updateActivity(activity,(User)request.getSession(false).getAttribute("user"));
        }catch (Exception e){
            map.put("success", false);
            if(e.getMessage() == null){
                map.put("msg","服务器繁忙，请稍后再试");
            }else {
                map.put("msg",e.getMessage());
            }
            return map;
        }
        map.put("success",true);
        return map;
    }

    @RequestMapping(value = "/query-activity.do", method = RequestMethod.GET)
    @ResponseBody
    public Map queryActivity(HttpServletRequest request, @RequestParam("id") String id){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        Map<String,Object> map = activityService.queryActivity(id);
        return map;
    }

    @RequestMapping(value = "/query-allUser.do",method = RequestMethod.GET)
    @ResponseBody
    public List queryAllName(HttpServletRequest request){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        List userList = activityService.queryAllUser();
        return userList;
    }

    @RequestMapping(value = "/query-showActivity.do", method = RequestMethod.GET)
    @ResponseBody
    public Activity query_showActivity(HttpServletRequest request, @RequestParam("id") String id){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        Activity activity = activityService.query_showActivity(id);
        return activity;
    }

    @RequestMapping(value = "query-pageList.do",method = RequestMethod.GET)
    @ResponseBody
    public Map pageList(HttpServletRequest request, PageRequestPram prp) {
        WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wac.getBean("activityServiceImp");

        Map map = activityService.pageList(prp);

        return map;
    }

    @RequestMapping(value = "query_showRemark.do",method = RequestMethod.GET)
    @ResponseBody
    public List query_showRemark(HttpServletRequest request, @RequestParam("activityId") String activityId){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        List remarkList = activityService.query_showRemark(activityId);

        return remarkList;
    }

    @RequestMapping(value = "save-remark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map save_remark(HttpServletRequest request, ActivityRemark activityRemark){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        String createBy = ((User)request.getSession(false).getAttribute("user")).getName();
        activityRemark.setCreateBy(createBy);
        Map map = activityService.saveRemark(activityRemark);

        return map;
    }

    @RequestMapping(value = "del-remark.do",method = RequestMethod.POST)
    @ResponseBody
    public Boolean del_remark(HttpServletRequest request, @RequestParam("id")String id){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        Boolean flag = activityService.delRemark(id);

        return flag;
    }

    @RequestMapping(value = "update-remark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map update_remark(HttpServletRequest request, ActivityRemark activityRemark){
        WebApplicationContext wc = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
        ActivityService activityService = (ActivityService) wc.getBean("activityServiceImp");
        String editBy = ((User)request.getSession(false).getAttribute("user")).getName();
        activityRemark.setEditBy(editBy);
        Map map = activityService.updateRemark(activityRemark);

        return map;
    }
}

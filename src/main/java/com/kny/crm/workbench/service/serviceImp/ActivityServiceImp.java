package com.kny.crm.workbench.service.serviceImp;

import com.github.pagehelper.PageHelper;
import com.kny.crm.exception.SaveException;
import com.kny.crm.exception.UpdateException;
import com.kny.crm.settings.dao.UserDao;
import com.kny.crm.settings.domain.User;
import com.kny.crm.utils.DateTimeUtil;
import com.kny.crm.utils.UUIDUtil;
import com.kny.crm.workbench.dao.ActivityDao;
import com.kny.crm.workbench.dao.ActivityRemarkDao;
import com.kny.crm.workbench.domain.Activity;
import com.kny.crm.workbench.domain.ActivityRemark;
import com.kny.crm.workbench.vo.PageRequestPram;
import com.kny.crm.workbench.service.ActivityService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImp implements ActivityService {

    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private ActivityRemarkDao activityRemarkDao;
    @Autowired
    private UserDao userDao;

    @Override
    public List queryAllUser() {
        List userList = userDao.queryAllUser();
        return userList;
    }

    @Override
    public void saveActivity(Activity activity, User user) {
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activity.setCreateBy(user.getName());

        try {
            activityDao.saveActivity(activity);
        } catch (Exception e) {
            System.out.println("(com.kny.crm.workbench.service.serviceImp.ActivityServiceImp    )保存失败 输出异常信息到日志文件");
            throw new SaveException("保存失败 请稍后重试");
        }
    }

    @Override
    public Map delActivityList(String[] id) {
        /**
         * 首先删除活动信息表记录（外表）
         * 再删除活动表记录
         */
        Map map = new HashMap();
        try {
            activityRemarkDao.delActivityRemark(id);
            activityDao.delActivityList(id);
        } catch (Exception e) {
            map.put("success", false);
            return map;
        }
        map.put("success", true);
        return map;
    }

    @Override
    public void updateActivity(Activity activity, User user) {
        activity.setEditBy(user.getName());
        activity.setEditTime(DateTimeUtil.getSysTime());

        try {
            activityDao.updateActivity(activity);
        } catch (Exception e) {
            System.out.println("(com.kny.crm.workbench.service.serviceImp.ActivityServiceImp)更新失败 输出异常信息到日志文件");
            throw new UpdateException("更新失败 请稍后重试");
        }
    }

    @Override
    public Map queryActivity( String id) {
        Map map = new HashMap();
        List userList = userDao.queryAllUser();
        Activity activity = activityDao.queryActivity(id);

        map.put("userList", userList);
        map.put("activity", activity);
        return map;
    }

    @Override
    public Activity query_showActivity(String id) {
        Map map = new HashMap();
        Activity activity = activityDao.queryActivity(id);

        return activity;
    }
    @Override
    public Map pageList(PageRequestPram prp) {
        Map map = new HashMap();

        PageHelper.startPage(Integer.parseInt(prp.getPageNo()), Integer.parseInt(prp.getPageSize()));
        List list = activityDao.pageList(prp);

        int total = activityDao.totalConditionActivity(prp);

        map.put("total", total);
        map.put("list", list);

        return map;
    }

    @Override
    public List query_showRemark(String activityId) {
        List remarkList = activityRemarkDao.queryRemark(activityId);
        return remarkList;
    }

    @Override
    public Map saveRemark(ActivityRemark activityRemark) {
        activityRemark.setId(UUIDUtil.getUUID());
        String createTime = DateTimeUtil.getSysTime();
        activityRemark.setCreateTime(createTime);
        activityRemark.setEditFlag("0");
        Map map = new HashMap();

        try {
            activityRemarkDao.saveRemark(activityRemark);
        }catch (Exception e){
            e.printStackTrace();
            map.put("success",false);
            return map;
        }

        map.put("success",true);
        map.put("remark",activityRemark);

        return map;
    }

    @Override
    public boolean delRemark(String id) {
        try{
            activityRemarkDao.delRemark(id);
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
        return true;
    }

    @Override
    public Map updateRemark(ActivityRemark activityRemark) {
        Map map = new HashMap();
        activityRemark.setEditFlag("1");
        activityRemark.setEditTime(DateTimeUtil.getSysTime());

        try{
            activityRemarkDao.updateRemark(activityRemark);
        }catch (Exception e){
            e.printStackTrace();
            map.put("success",false);
            return map;
        }

        map.put("success",true);
        map.put("editTime",activityRemark.getEditTime());
        map.put("editBy",activityRemark.getEditBy());
        return map;
    }
}

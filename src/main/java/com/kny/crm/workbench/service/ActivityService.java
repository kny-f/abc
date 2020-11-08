package com.kny.crm.workbench.service;

import com.kny.crm.settings.domain.User;
import com.kny.crm.workbench.domain.Activity;
import com.kny.crm.workbench.domain.ActivityRemark;
import com.kny.crm.workbench.vo.PageRequestPram;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    void saveActivity(Activity activity, User user);

    Map delActivityList(String[] id);

    void updateActivity(Activity activity, User user);

    Map queryActivity(String id);

    List queryAllUser();

    Activity query_showActivity(String id);

    Map pageList(PageRequestPram prp);

    List query_showRemark(String activityId);

    Map saveRemark(ActivityRemark activityRemark);

    boolean delRemark(String id);

    Map updateRemark(ActivityRemark activityRemark);
}

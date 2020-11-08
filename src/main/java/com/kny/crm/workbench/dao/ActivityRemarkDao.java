package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    int delActivityRemark(String[] activityId);

    List queryRemark(String activityId);

    int saveRemark(ActivityRemark activityRemark);

    int delRemark(String id);

    int updateRemark(ActivityRemark activityRemark);
}

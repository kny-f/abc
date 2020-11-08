package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.Activity;
import com.kny.crm.workbench.vo.PageRequestPram;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int saveActivity(Activity activity);

    int delActivityList(String[] id);

    int updateActivity(Activity activity);

    Activity queryActivity(@Param("id") String id);

    List pageList(PageRequestPram prp);
    int totalConditionActivity(PageRequestPram prp);

    List queryActByName(Map<String, String> map);

    List<Activity> queryLikeAct(@Param("name")String name);
}

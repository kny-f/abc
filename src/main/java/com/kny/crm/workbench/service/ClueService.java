package com.kny.crm.workbench.service;

import com.kny.crm.settings.domain.User;
import com.kny.crm.workbench.domain.Activity;
import com.kny.crm.workbench.domain.Clue;
import com.kny.crm.workbench.vo.ClueConvert;

import java.util.List;
import java.util.Map;

public interface ClueService {

    boolean saveClue(Clue clue, User user);

    Clue queryClue(String id);

    List<Activity> queryClueActivity(String id);

    boolean delClueActivity(String id);

    List queryActByName(Map<String,String> map);

    boolean saveBindAct(String clueId, String[] actIds);

    List queryLikeAct(String name);

    void convert(ClueConvert clueConvert);
}

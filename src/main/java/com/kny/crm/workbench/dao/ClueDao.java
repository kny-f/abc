package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.Clue;
import org.apache.ibatis.annotations.Param;

public interface ClueDao {


    int saveClue(Clue clue);

    Clue queryClueById(@Param("id")String id);

    void delClue(@Param("id") String id);

    Clue queryClue(String clueId);
}

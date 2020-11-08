package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.ClueActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueActivityRelationDao {

    List queryClueActivity(@Param("clueId") String clueId);

    int delClueActivity(@Param("id") String id);

    int saveBindAct(ClueActivityRelation car);

    void delRelationByClueId(@Param("clueId") String id);
}

package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.ClueRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> queryRemarkList(@Param("id") String id);
}

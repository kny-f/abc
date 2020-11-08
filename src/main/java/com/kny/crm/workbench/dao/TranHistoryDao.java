package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    void saveHistory(TranHistory tranHistory);

    List<TranHistory> queryTranHis(String tranId);
}

package com.kny.crm.workbench.service;

import com.kny.crm.workbench.domain.Tran;
import com.kny.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    void saveTran(Tran tran, String customerName);

    Tran getTran(String id);

    List<TranHistory> getTranHisList(String id);

    void changeStage(Tran tran);
}

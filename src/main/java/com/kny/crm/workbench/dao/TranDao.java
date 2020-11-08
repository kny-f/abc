package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.Tran;

public interface TranDao {

    void saveTran(Tran tran);

    Tran queryTran(String id);

    void updateTran(Tran tran);
}

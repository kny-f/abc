package com.kny.crm.settings.dao;

import com.kny.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> queryDicValue(String typeCode);
}

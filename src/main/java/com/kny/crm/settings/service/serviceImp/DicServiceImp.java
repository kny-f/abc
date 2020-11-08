package com.kny.crm.settings.service.serviceImp;

import com.kny.crm.settings.dao.DicTypeDao;
import com.kny.crm.settings.dao.DicValueDao;
import com.kny.crm.settings.domain.DicType;
import com.kny.crm.settings.domain.DicValue;
import com.kny.crm.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

//业务层均使用注解
@org.springframework.stereotype.Service
public class DicServiceImp implements DicService {
    @Autowired
    private DicTypeDao dicTypeDao;
    @Autowired
    private DicValueDao dicValueDao;

    @Override
    public  Map<String,List<DicValue>> queryDicMap() {
        List<DicType> dicTypes = dicTypeDao.queryDicType();
        Map<String,List<DicValue>> dicMap = new HashMap<>();

        for(DicType dicType : dicTypes){
            List<DicValue> list = dicValueDao.queryDicValue(dicType.getCode());
            dicMap.put(dicType.getCode()+"List", list);
        }

        return dicMap;
    }

}

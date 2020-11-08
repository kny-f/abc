package com.kny.crm.workbench.service.serviceImp;

import com.kny.crm.workbench.dao.ContactsDao;
import com.kny.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsServiceImp implements ContactsService {
    @Autowired
    private ContactsDao contactsDao;

    @Override
    public List queryLikeCon(String name) {
        List list = contactsDao.queryLikeCon(name);
        return list;
    }
}

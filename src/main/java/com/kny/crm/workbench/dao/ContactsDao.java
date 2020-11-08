package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    void saveContacts(Contacts contacts);

    List queryLikeCon(String name);
}

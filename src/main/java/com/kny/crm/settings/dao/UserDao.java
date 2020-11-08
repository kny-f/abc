package com.kny.crm.settings.dao;

import com.kny.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User queryUser(Map map);

    List queryAllUser();
}

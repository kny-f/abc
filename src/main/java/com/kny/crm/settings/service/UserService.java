package com.kny.crm.settings.service;

import com.kny.crm.settings.domain.User;

public interface UserService {
    User queryUser(String userAct, String userPwd, String remoteAddr);
}
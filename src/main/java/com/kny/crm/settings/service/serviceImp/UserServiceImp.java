package com.kny.crm.settings.service.serviceImp;

import com.kny.crm.exception.LoginException;
import com.kny.crm.settings.dao.UserDao;
import com.kny.crm.settings.domain.User;
import com.kny.crm.utils.DateTimeUtil;
import com.kny.crm.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

//业务层均使用注解
@org.springframework.stereotype.Service
public class UserServiceImp implements com.kny.crm.settings.service.UserService {

    @Autowired
    public UserDao userDao;
    public User queryUser(String loginAct , String loginPwd , String remoteAddr){
        loginPwd = MD5Util.getMD5(loginPwd);         //数据库中存储的密码是加密过后的 所以要把用户输入的密码也加密 在进行比较
        Map map = new HashMap();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.queryUser(map);

        //!loginAct.equals(user.getLoginAct())作用：数据库查询忽略大小写  比如数据库中存放的值是  zs  ， 查询 ZS 也可以匹配到
        if(user == null || !loginAct.equals(user.getLoginAct())){
            throw new LoginException("账号或密码错误");
        }
        if(!user.getAllowIps().contains(remoteAddr)){
            throw new LoginException("IP地址受限制");
        }
        if(user.getExpireTime().compareTo(DateTimeUtil.getSysTime()) < 0){
            throw new LoginException("账号已失效");
        }
        if(!"1".equals(user.getLockState())){
            throw new LoginException("账号已锁定");
        }


        return user;
    }
}

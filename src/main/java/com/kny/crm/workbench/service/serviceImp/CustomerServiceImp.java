package com.kny.crm.workbench.service.serviceImp;

import com.kny.crm.workbench.dao.CustomerDao;
import com.kny.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerServiceImp implements CustomerService {
    @Autowired
    private CustomerDao customerDao;

    @Override
    public List<String> getCustomerName(String name) {
        List<String> list = customerDao.queryLikeName(name);
        return list;
    }
}

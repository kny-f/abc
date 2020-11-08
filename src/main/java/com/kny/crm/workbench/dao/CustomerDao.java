package com.kny.crm.workbench.dao;

import com.kny.crm.workbench.domain.Customer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CustomerDao {


    Customer queryByName(@Param("name") String company);

    void saveCustomer(Customer customer);

    List<String> queryLikeName(String name);
}

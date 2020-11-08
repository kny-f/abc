package com.kny.crm.workbench.service.serviceImp;

import com.kny.crm.utils.DateTimeUtil;
import com.kny.crm.utils.UUIDUtil;
import com.kny.crm.workbench.dao.CustomerDao;
import com.kny.crm.workbench.dao.TranDao;
import com.kny.crm.workbench.dao.TranHistoryDao;
import com.kny.crm.workbench.domain.Customer;
import com.kny.crm.workbench.domain.Tran;
import com.kny.crm.workbench.domain.TranHistory;
import com.kny.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImp implements TranService {
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public void saveTran(Tran tran, String customerName) {
        //首先先对客户表动手
        Customer customer = customerDao.queryByName(customerName);
        if(customer == null){
            //说明当前客户表中没有 需要咱们给他new一个
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setDescription(tran.getDescription());

            customerDao.saveCustomer(customer);
        }

        //ok 现在客户表中肯定有该客户了。 我赌一百万
        tran.setId(UUIDUtil.getUUID());
        tran.setCustomerId(customer.getId());
        //给交易安排--上
        tranDao.saveTran(tran);

        //在给交易历史安排一手
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(tran.getId());
        th.setMoney(tran.getMoney());
        th.setStage(tran.getStage());
        th.setExpectedDate(tran.getExpectedDate());
        th.setCreateBy(tran.getCreateBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        tranHistoryDao.saveHistory(th);

        //温馨提示 配置事务回滚
        //throw new RuntimeException("回滚测试");
    }

    @Override
    public Tran getTran(String id) {
        Tran tran = tranDao.queryTran(id);
        return tran;
    }

    @Override
    public List<TranHistory> getTranHisList(String tranId) {
        List<TranHistory> list = tranHistoryDao.queryTranHis(tranId);
        return list;
    }

    @Override
    public void changeStage(Tran tran) {
        tranDao.updateTran(tran);

        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(tran.getId());
        th.setStage(tran.getStage());
        th.setCreateBy(tran.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(tran.getExpectedDate());
        th.setMoney(tran.getMoney());

        tranHistoryDao.saveHistory(th);
    }
}

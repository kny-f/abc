package com.kny.crm.workbench.service.serviceImp;

import com.kny.crm.settings.domain.User;
import com.kny.crm.utils.DateTimeUtil;
import com.kny.crm.utils.UUIDUtil;
import com.kny.crm.workbench.dao.*;
import com.kny.crm.workbench.domain.*;
import com.kny.crm.workbench.service.ClueService;
import com.kny.crm.workbench.vo.ClueConvert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImp implements ClueService {
    @Autowired
    private ClueDao clueDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;
    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;
    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public boolean saveClue(Clue clue, User user) {
        boolean flag = true;
        clue.setCreateBy(user.getName());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        clue.setId(UUIDUtil.getUUID());
        try {
            clueDao.saveClue(clue);
        }catch (Exception e){
            e.printStackTrace();
            flag = false;
        }finally {
            return flag;
        }
    }

    @Override
    public Clue queryClue(String id) {
        Clue clue = clueDao.queryClueById(id);
        return clue;
    }

    @Override
    public List<Activity> queryClueActivity(String id) {
        List list = clueActivityRelationDao.queryClueActivity(id);
        return list;
    }

    @Override
    public boolean delClueActivity(String id) {
        int flag;
        flag = clueActivityRelationDao.delClueActivity(id);
        return flag == 1 ? true : false;
    }

    @Override
    public List queryActByName(Map<String, String> map) {
        List activityList = activityDao.queryActByName(map);
        return activityList;
    }

    @Override
    public boolean saveBindAct(String clueId, String[] actIds) {
        int num = 0;
        for(int i = 0; i < actIds.length; i++){
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setClueId(clueId);
            car.setActivityId(actIds[i]);
            num += clueActivityRelationDao.saveBindAct(car);
        }
        if(num != actIds.length){
            return false;
        }
        return true;
    }

    @Override
    public List queryLikeAct(String name) {

        List<Activity> list = activityDao.queryLikeAct(name);
        return list;
    }

    //线索转换 核心 整个项目下来对业务逻辑还是不熟悉 总觉得这样业务哪里有问题  你想想使用这个crm库的甲方应该是什么样的人。销售公司的销售？
    @Override
    public void convert(ClueConvert clueConvert) {
        String curTime = DateTimeUtil.getSysTime();
        Clue clue = clueDao.queryClue(clueConvert.getClueId());
        Customer customer = customerDao.queryByName(clue.getCompany());
        //等于null说明该客户不存在 需要创建
        if(customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(clue.getCompany());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(clueConvert.getUserName());
            customer.setCreateTime(curTime);
            customer.setAddress(clue.getAddress());
            customerDao.saveCustomer(customer);
        }
        //创建联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCustomerId(customer.getId());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(clueConvert.getUserName());
        contacts.setCreateTime(curTime);
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contactsDao.saveContacts(contacts);

        //线索备注转换到客户备注以及联系人备注  因线索备注的增删改没写 所以略
        /**List<ClueRemark> remarkList = clueRemarkDao.queryRemarkList(clue.getId());
        for(ClueRemark remark : remarkList){
            略
        }*/

        //如果有创建交易需求，创建一条交易  为真表示需要创建交易
        if(clueConvert.isFlag()){
            Tran tran = new Tran();
            tran.setId(UUIDUtil.getUUID());
            tran.setOwner(clue.getOwner());
            tran.setMoney(clueConvert.getMoney());
            tran.setName(clueConvert.getName());
            tran.setExpectedDate(clueConvert.getExpectedDate());
            tran.setCustomerId(customer.getId());
            tran.setStage(clueConvert.getStage());
            tran.setSource(clue.getSource());
            tran.setActivityId(clueConvert.getActivityId());
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(clueConvert.getUserName());
            tran.setCreateTime(curTime);
            tran.setDescription(clue.getDescription());
            tranDao.saveTran(tran);
            //如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(clueConvert.getStage());
            tranHistory.setMoney(clueConvert.getMoney());
            tranHistory.setExpectedDate(clueConvert.getExpectedDate());
            tranHistory.setCreateBy(clueConvert.getUserName());
            tranHistory.setCreateTime(curTime);
            tranHistory.setTranId(tran.getId());
            tranHistoryDao.saveHistory(tranHistory);
        }

        /**删除线索备注 略*/

        //删除线索和市场活动的关系
        clueActivityRelationDao.delRelationByClueId(clue.getId());
        //删除线索
        clueDao.delClue(clue.getId());
        //throw new RuntimeException("查看是否回滚");
    }
}

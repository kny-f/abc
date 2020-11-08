import com.kny.crm.utils.DateTimeUtil;
import com.kny.crm.workbench.domain.Activity;
import com.kny.crm.workbench.service.ClueService;
import com.kny.crm.workbench.service.serviceImp.ClueServiceImp;
import com.kny.crm.workbench.vo.PageRequestPram;
import com.kny.crm.workbench.service.ActivityService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class Test {
    @org.junit.Test
    public void testUserDao(){
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        com.kny.crm.settings.service.serviceImp.UserServiceImp userDao = (com.kny.crm.settings.service.serviceImp.UserServiceImp) ac.getBean("userServiceImp");
        System.out.println(userDao);
        System.out.println(userDao.userDao);
    }

    @org.junit.Test
    public void testQueryAllName(){
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService activityService = (ActivityService) ac.getBean("activityServiceImp");
        List<String> list = activityService.queryAllUser();
        list.forEach(n -> System.out.println(n));
    }

    @org.junit.Test
    public void testGetYMDTime(){
        System.out.println(DateTimeUtil.getYMDTime());
    }

    @org.junit.Test
    public void testPageList(){
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService activityService = (ActivityService) ac.getBean("activityServiceImp");
        PageRequestPram prp = new PageRequestPram();
        prp.setPageNo("1");
        prp.setPageSize("5");
        prp.setOwner("三");
        //prp.setStartTime("2019-10-10");
        Map map = activityService.pageList(prp);
        Iterator iterator = map.keySet().iterator();
        while (iterator.hasNext()){
            String k = (String) iterator.next();
            System.out.println(map.get(k));

        }
    }

    @org.junit.Test
    public void delActivityList() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService activityService = (ActivityService) ac.getBean("activityServiceImp");
        String[] id = {"64f9402642ca4d118fc4285cab50f877"};
        Map map = activityService.delActivityList(id);

        System.out.println("结果: "+ map.get("success"));
    }

    @org.junit.Test
    public void queryClueActivity() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        ClueService clueServiceImp = (ClueService) ac.getBean("clueServiceImp");
        String id = "6cba9819850644cc829c9ff4b3775424";
        List<Activity> list = clueServiceImp.queryClueActivity(id);

        list.forEach(a -> System.out.println(a.toString()));
    }
}

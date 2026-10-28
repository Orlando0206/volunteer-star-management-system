package com.volunteerstar.service;

import com.volunteerstar.pojo.Activity;
import com.volunteerstar.pojo.ActivitySign;
import com.volunteerstar.pojo.Registration;
import com.volunteerstar.pojo.ServiceHourChange;
import com.volunteerstar.pojo.ServiceHourSummary;

import java.util.List;
import java.util.Map;

public interface AdminService {

    // ==================== 活动管理 ====================

    List<Activity> getActivities(String keyword, Integer status);

    // 用户端活动中心查询：自动排除已被管理员取消/删除的活动（activity_status_id = 4）
    List<Activity> getUserActivities(String keyword);

    Activity getActivityById(Integer id);

    boolean addActivity(Activity activity);

    boolean updateActivity(Activity activity);

    boolean deleteActivity(Integer id);

    // ==================== 报名审核管理 ====================

    List<Registration> getRegistrations(Integer activityId, Integer status, String keyword);

    boolean approveRegistration(Integer id, String remark);

    boolean rejectRegistration(Integer id, String remark);

    boolean batchApprove(List<Integer> ids);

    // ==================== 签到签退管理 ====================

    List<ActivitySign> getCheckInList(Integer signStatus);

    boolean checkIn(Integer registrationId);

    boolean checkOut(Integer registrationId, Double hours, Integer adminId);

    // ==================== 时长管理 ====================

    ServiceHourSummary getUserHourSummary(Integer userId);

    List<ServiceHourChange> getUserHourChanges(Integer userId);

    // ==================== 数据统计 ====================

    Map<String, Object> getDashboardStats();

    // ==================== 用户端活动浏览/报名 ====================

    Registration getUserRegistration(Integer activityId, Integer userId);

    List<Registration> getMyRegistrations(Integer userId);

    boolean registerActivity(Integer activityId, Integer userId, String remark);

    boolean cancelRegistration(Integer activityId, Integer userId);
}

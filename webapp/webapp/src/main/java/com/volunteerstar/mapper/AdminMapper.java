package com.volunteerstar.mapper;

import com.volunteerstar.pojo.Activity;
import com.volunteerstar.pojo.ActivitySign;
import com.volunteerstar.pojo.Registration;
import com.volunteerstar.pojo.ServiceHourChange;
import com.volunteerstar.pojo.ServiceHourSummary;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface AdminMapper {

    // ==================== 活动管理 ====================

    List<Activity> selectActivities(@Param("keyword") String keyword,
                                    @Param("status") Integer status);

    // 用户端活动中心查询：自动排除 activity_status_id = 4（已取消/软删除）
    List<Activity> selectUserActivities(@Param("keyword") String keyword);

    Activity selectActivityById(Integer id);

    int insertActivity(Activity activity);

    int updateActivity(Activity activity);

    int deleteActivity(Integer id);

    int updateEnrolledCount(@Param("activityId") Integer activityId,
                            @Param("delta") Integer delta);

    // ==================== 报名审核管理 ====================

    List<Registration> selectRegistrations(@Param("activityId") Integer activityId,
                                           @Param("status") Integer status,
                                           @Param("keyword") String keyword);

    Registration selectRegistrationById(Integer id);

    int updateRegistrationStatus(@Param("id") Integer id,
                                 @Param("status") Integer status,
                                 @Param("remark") String remark);

    int batchUpdateStatus(@Param("ids") List<Integer> ids,
                          @Param("status") Integer status);

    // ==================== 用户端活动浏览/报名 ====================

    Registration selectUserRegistration(@Param("activityId") Integer activityId,
                                        @Param("userId") Integer userId);

    int insertRegistration(@Param("activityId") Integer activityId,
                           @Param("userId") Integer userId,
                           @Param("remark") String remark);

    int cancelUserRegistration(@Param("activityId") Integer activityId,
                               @Param("userId") Integer userId);

    List<Registration> selectMyRegistrations(@Param("userId") Integer userId);

    // ==================== 签到签退管理 ====================

    ActivitySign selectActivitySignByEnrollmentId(@Param("enrollmentId") Integer enrollmentId);

    List<ActivitySign> selectActivitySignList(@Param("signStatus") Integer signStatus);

    int insertActivitySign(@Param("enrollmentId") Integer enrollmentId);

    int updateSignIn(@Param("enrollmentId") Integer enrollmentId);

    int updateSignOut(@Param("enrollmentId") Integer enrollmentId,
                      @Param("hours") BigDecimal hours,
                      @Param("adminId") Integer adminId);

    int updateEnrollmentCompleted(@Param("enrollmentId") Integer enrollmentId,
                                  @Param("remark") String remark);

    // ==================== 时长管理 ====================

    int insertServiceHourChange(@Param("userId") Integer userId,
                                @Param("activityId") Integer activityId,
                                @Param("activitySignId") Integer activitySignId,
                                @Param("changeType") String changeType,
                                @Param("changeSource") String changeSource,
                                @Param("changeHour") BigDecimal changeHour,
                                @Param("changeReason") String changeReason,
                                @Param("operateUserId") Integer operateUserId);

    ServiceHourSummary selectServiceHourSummaryByUserId(@Param("userId") Integer userId);

    BigDecimal selectMonthServiceHourByUserId(@Param("userId") Integer userId);

    void insertServiceHourSummary(@Param("userId") Integer userId,
                                  @Param("totalHour") BigDecimal totalHour,
                                  @Param("activityCount") Integer activityCount);

    int updateServiceHourSummary(@Param("userId") Integer userId,
                                 @Param("deltaHour") BigDecimal deltaHour,
                                 @Param("deltaCount") Integer deltaCount);

    List<ServiceHourChange> selectServiceHourChangesByUserId(@Param("userId") Integer userId);

    // ==================== 数据统计 ====================

    int countActivityByStatus(Integer status);

    int countRegistrationByStatus(Integer status);

    int countTodayCheckIn();

    String selectLatestSnapshotDate();

    List<Map<String, Object>> selectLatestSummaryStats();

    Map<String, Object> selectDashboardOperations();

    List<Map<String, Object>> selectMonthlyStats();

    List<Map<String, Object>> selectLatestCategoryStats();

    List<Map<String, Object>> selectLatestRegionStats();
}

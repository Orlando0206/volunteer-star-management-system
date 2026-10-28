package com.volunteerstar.service.impl;

import com.volunteerstar.mapper.AdminMapper;
import com.volunteerstar.pojo.Activity;
import com.volunteerstar.pojo.ActivitySign;
import com.volunteerstar.pojo.Registration;
import com.volunteerstar.pojo.ServiceHourChange;
import com.volunteerstar.pojo.ServiceHourSummary;
import com.volunteerstar.service.AdminService;
import com.volunteerstar.utils.MyBatisUtils;
import org.apache.ibatis.session.SqlSession;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AdminServiceImpl implements AdminService {

    @Override
    public List<Activity> getActivities(String keyword, Integer status) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectActivities(keyword, status);
        }
    }

    @Override
    public List<Activity> getUserActivities(String keyword) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectUserActivities(keyword);
        }
    }

    @Override
    public Activity getActivityById(Integer id) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectActivityById(id);
        }
    }

    @Override
    public boolean addActivity(Activity activity) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);

            if (activity.getStatus() == null) {
                activity.setStatus(Activity.STATUS_RECRUITING);
            }
            if (activity.getImage() == null || activity.getImage().trim().isEmpty()) {
                activity.setImage("assets/images/activity-1.jpg");
            }

            int result = mapper.insertActivity(activity);
            session.commit();
            return result > 0;
        }
    }

    @Override
    public boolean updateActivity(Activity activity) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            int result = mapper.updateActivity(activity);
            session.commit();
            return result > 0;
        }
    }

    @Override
    public boolean deleteActivity(Integer id) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            int result = mapper.deleteActivity(id);
            session.commit();
            return result > 0;
        }
    }

    @Override
    public List<Registration> getRegistrations(Integer activityId, Integer status, String keyword) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectRegistrations(activityId, status, keyword);
        }
    }

    @Override
    public boolean approveRegistration(Integer id, String remark) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);

            Registration reg = mapper.selectRegistrationById(id);
            if (reg == null || reg.getStatus() == null || reg.getStatus() != Registration.STATUS_PENDING) {
                return false;
            }

            int result = mapper.updateRegistrationStatus(id, Registration.STATUS_APPROVED, remark);

            if (result > 0) {
                mapper.updateEnrolledCount(reg.getActivityId(), 1);
                mapper.insertActivitySign(id);
            }

            session.commit();
            return result > 0;
        }
    }

    @Override
    public boolean rejectRegistration(Integer id, String remark) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);

            Registration reg = mapper.selectRegistrationById(id);
            if (reg == null || reg.getStatus() == null || reg.getStatus() != Registration.STATUS_PENDING) {
                return false;
            }

            int result = mapper.updateRegistrationStatus(id, Registration.STATUS_REJECTED, remark);
            session.commit();
            return result > 0;
        }
    }

    @Override
    public boolean batchApprove(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return false;
        }

        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            int result = mapper.batchUpdateStatus(ids, Registration.STATUS_APPROVED);
            session.commit();
            return result > 0;
        }
    }

    @Override
    public List<ActivitySign> getCheckInList(Integer signStatus) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectActivitySignList(signStatus);
        }
    }

    @Override
    public boolean checkIn(Integer registrationId) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            Registration reg = mapper.selectRegistrationById(registrationId);
            if (reg == null || reg.getStatus() == null || reg.getStatus() != Registration.STATUS_APPROVED) {
                return false;
            }

            ActivitySign sign = mapper.selectActivitySignByEnrollmentId(registrationId);
            if (sign == null) {
                mapper.insertActivitySign(registrationId);
            }

            int result = mapper.updateSignIn(registrationId);
            session.commit();
            return result > 0;
        }
    }

    @Override
    public boolean checkOut(Integer registrationId, Double hours, Integer adminId) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);

            Registration reg = mapper.selectRegistrationById(registrationId);
            if (reg == null) {
                return false;
            }

            ActivitySign sign = mapper.selectActivitySignByEnrollmentId(registrationId);
            if (sign == null || sign.getSignStatus() == null || sign.getSignStatus() != ActivitySign.SIGN_STATUS_SIGNED_IN) {
                return false;
            }

            BigDecimal actualHours = hours != null && hours > 0
                    ? BigDecimal.valueOf(hours) : BigDecimal.ZERO;
            int result = mapper.updateSignOut(registrationId, actualHours, adminId);

            if (result > 0) {
                ActivitySign updatedSign = mapper.selectActivitySignByEnrollmentId(registrationId);
                String remark = "签退完成，服务时长：" + actualHours + " 小时";
                mapper.updateEnrollmentCompleted(registrationId, remark);
                mapper.insertServiceHourChange(
                    reg.getUserId(),
                    reg.getActivityId(),
                    updatedSign.getId(),
                    ServiceHourChange.CHANGE_TYPE_ADD,
                    ServiceHourChange.SOURCE_SIGN_AUTO,
                    actualHours,
                    remark,
                    adminId
                );

                ServiceHourSummary summary = mapper.selectServiceHourSummaryByUserId(reg.getUserId());
                if (summary == null) {
                    mapper.insertServiceHourSummary(reg.getUserId(), actualHours, 1);
                } else {
                    mapper.updateServiceHourSummary(reg.getUserId(), actualHours, 1);
                }
            }

            session.commit();
            return result > 0;
        }
    }

    @Override
    public ServiceHourSummary getUserHourSummary(Integer userId) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            ServiceHourSummary summary = mapper.selectServiceHourSummaryByUserId(userId);
            if (summary != null) {
                BigDecimal monthHour = mapper.selectMonthServiceHourByUserId(userId);
                summary.setMonthServiceHour(monthHour != null ? monthHour : BigDecimal.ZERO);
            }
            return summary;
        }
    }

    @Override
    public List<ServiceHourChange> getUserHourChanges(Integer userId) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectServiceHourChangesByUserId(userId);
        }
    }

    @Override
    public Map<String, Object> getDashboardStats() {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);

            Map<String, Object> stats = new LinkedHashMap<>();
            stats.put("generatedAt", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            stats.put("snapshotDate", mapper.selectLatestSnapshotDate());
            stats.put("summary", defaultList(mapper.selectLatestSummaryStats()));
            stats.put("operations", defaultMap(mapper.selectDashboardOperations()));
            stats.put("monthly", defaultList(mapper.selectMonthlyStats()));
            stats.put("categories", defaultList(mapper.selectLatestCategoryStats()));
            stats.put("regions", defaultList(mapper.selectLatestRegionStats()));
            return stats;
        }
    }

    private List<Map<String, Object>> defaultList(List<Map<String, Object>> value) {
        return value == null ? Collections.emptyList() : value;
    }

    private Map<String, Object> defaultMap(Map<String, Object> value) {
        return value == null ? Collections.emptyMap() : value;
    }

    @Override
    public Registration getUserRegistration(Integer activityId, Integer userId) {
        if (activityId == null || userId == null) {
            return null;
        }

        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectUserRegistration(activityId, userId);
        }
    }

    @Override
    public List<Registration> getMyRegistrations(Integer userId) {
        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);
            return mapper.selectMyRegistrations(userId);
        }
    }

    @Override
    public boolean registerActivity(Integer activityId, Integer userId, String remark) {
        if (activityId == null || userId == null) {
            return false;
        }

        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);

            Activity activity = mapper.selectActivityById(activityId);
            if (activity == null || activity.getStatus() == null || activity.getStatus() != Activity.STATUS_RECRUITING) {
                return false;
            }

            if (activity.getCapacity() != null && activity.getEnrolled() != null
                    && activity.getEnrolled() >= activity.getCapacity()) {
                return false;
            }

            Registration old = mapper.selectUserRegistration(activityId, userId);
            if (isActiveRegistration(old)) {
                return false;
            }

            int result = mapper.insertRegistration(activityId, userId, remark);
            session.commit();
            return result > 0;
        }
    }

    @Override
    public boolean cancelRegistration(Integer activityId, Integer userId) {
        if (activityId == null || userId == null) {
            return false;
        }

        try (SqlSession session = MyBatisUtils.openSession()) {
            AdminMapper mapper = session.getMapper(AdminMapper.class);

            Registration old = mapper.selectUserRegistration(activityId, userId);
            if (old == null || old.getStatus() == null) {
                return false;
            }

            if (old.getStatus() != Registration.STATUS_PENDING
                    && old.getStatus() != Registration.STATUS_APPROVED) {
                return false;
            }

            int result = mapper.cancelUserRegistration(activityId, userId);

            if (result > 0 && old.getStatus() == Registration.STATUS_APPROVED) {
                mapper.updateEnrolledCount(activityId, -1);
            }

            session.commit();
            return result > 0;
        }
    }

    private boolean isActiveRegistration(Registration registration) {
        if (registration == null || registration.getStatus() == null) {
            return false;
        }
        int status = registration.getStatus();
        return status == Registration.STATUS_PENDING
                || status == Registration.STATUS_APPROVED
                || status == Registration.STATUS_COMPLETED;
    }
}

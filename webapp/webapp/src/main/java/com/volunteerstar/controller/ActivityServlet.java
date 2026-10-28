package com.volunteerstar.controller;

import com.alibaba.fastjson2.JSON;
import com.volunteerstar.pojo.Activity;
import com.volunteerstar.pojo.Registration;
import com.volunteerstar.pojo.ServiceHourChange;
import com.volunteerstar.pojo.ServiceHourSummary;
import com.volunteerstar.pojo.User;
import com.volunteerstar.service.AdminService;
import com.volunteerstar.service.impl.AdminServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/activity/api/*")
public class ActivityServlet extends HttpServlet {

    private final AdminService adminService = new AdminServiceImpl();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    private final SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");

        String path = req.getPathInfo();
        if (path == null) {
            path = "/list";
        }

        try {
            switch (path) {
                case "/list":
                    handleList(req, resp);
                    break;
                case "/register":
                    handleRegister(req, resp);
                    break;
                case "/cancel":
                    handleCancel(req, resp);
                    break;
                case "/mine":
                    handleMine(req, resp);
                    break;
                case "/hours/summary":
                    handleHourSummary(req, resp);
                    break;
                case "/hours/list":
                    handleHourList(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            getServletContext().log("活动接口处理失败", e);
            writeJson(resp, result(false, e.getMessage()));
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");

        User loginUser = (User) req.getSession().getAttribute("loginUser");

        List<Activity> activities = adminService.getUserActivities(keyword);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", activities.stream().map(activity -> activityToMap(activity, loginUser)).toList());

        writeJson(resp, result);
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = requireLogin(req, resp);
        if (loginUser == null) {
            return;
        }

        Integer activityId = Integer.parseInt(req.getParameter("activityId"));
        String remark = req.getParameter("remark");

        boolean success = adminService.registerActivity(activityId, loginUser.getId(), remark);

        writeJson(resp, success
                ? result(true, "报名成功，等待管理员审核")
                : result(false, "报名失败，可能已报名、名额已满或活动不可报名"));
    }

    private void handleCancel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = requireLogin(req, resp);
        if (loginUser == null) {
            return;
        }

        Integer activityId = Integer.parseInt(req.getParameter("activityId"));

        boolean success = adminService.cancelRegistration(activityId, loginUser.getId());

        writeJson(resp, success
                ? result(true, "已取消报名")
                : result(false, "取消失败，仅待审核或已通过的报名可取消"));
    }

    private void handleMine(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = requireLogin(req, resp);
        if (loginUser == null) {
            return;
        }

        List<Registration> registrations = adminService.getMyRegistrations(loginUser.getId());

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", registrations.stream().map(this::registrationToMap).toList());

        writeJson(resp, result);
    }

    private void handleHourSummary(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = requireLogin(req, resp);
        if (loginUser == null) {
            return;
        }

        ServiceHourSummary summary = adminService.getUserHourSummary(loginUser.getId());

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", summaryToMap(summary));

        writeJson(resp, result);
    }

    private void handleHourList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = requireLogin(req, resp);
        if (loginUser == null) {
            return;
        }

        List<ServiceHourChange> changes = adminService.getUserHourChanges(loginUser.getId());

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", changes.stream().map(this::hourChangeToMap).toList());

        writeJson(resp, result);
    }

    private User requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = (User) req.getSession().getAttribute("loginUser");

        if (loginUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeJson(resp, result(false, "请先登录"));
            return null;
        }

        return loginUser;
    }

    private Map<String, Object> activityToMap(Activity activity, User loginUser) {
        Map<String, Object> map = new HashMap<>();

        map.put("id", activity.getId());
        map.put("title", activity.getTitle());
        map.put("category", activity.getCategory());
        map.put("categoryColor", activity.getCategoryColor());
        map.put("description", activity.getDescription());
        map.put("location", activity.getLocation());
        map.put("date", activity.getStartTime() == null ? "" : dateFormat.format(activity.getStartTime()));
        map.put("startTime", activity.getStartTime() == null ? "" : dateFormat.format(activity.getStartTime()));
        map.put("endTime", activity.getEndTime() == null ? "" : dateFormat.format(activity.getEndTime()));
        map.put("capacity", activity.getCapacity());
        map.put("enrolled", activity.getEnrolled());
        map.put("status", activity.getStatus());
        map.put("statusLabel", Activity.getStatusLabel(activity.getStatus() == null ? -1 : activity.getStatus()));
        map.put("image", activity.getImage());

        if (loginUser != null) {
            Registration registration = adminService.getUserRegistration(activity.getId(), loginUser.getId());

            if (registration != null) {
                map.put("myRegistrationStatus", registration.getStatus());
                map.put("myRegistrationLabel", Registration.getStatusLabel(registration.getStatus()));
            }
        }

        return map;
    }

    private Map<String, Object> registrationToMap(Registration registration) {
        Map<String, Object> map = new HashMap<>();

        map.put("id", registration.getId());
        map.put("activityId", registration.getActivityId());
        map.put("activityTitle", registration.getActivityTitle());
        map.put("activityLocation", registration.getActivityLocation());
        map.put("status", registration.getStatus());
        map.put("statusLabel", Registration.getStatusLabel(registration.getStatus()));
        map.put("registerTime", registration.getRegisterTime() == null ? "" : dateFormat.format(registration.getRegisterTime()));
        map.put("checkInTime", registration.getCheckInTime() == null ? "" : dateFormat.format(registration.getCheckInTime()));
        map.put("checkOutTime", registration.getCheckOutTime() == null ? "" : dateFormat.format(registration.getCheckOutTime()));
        map.put("hours", registration.getHours());
        map.put("remark", registration.getRemark());

        return map;
    }

    private Map<String, Object> summaryToMap(ServiceHourSummary summary) {
        Map<String, Object> map = new HashMap<>();

        if (summary == null) {
            map.put("totalServiceHour", 0);
            map.put("monthServiceHour", 0);
            map.put("totalActivityCount", 0);
            map.put("rankingNo", null);
            map.put("lastCalculateTime", "");
        } else {
            map.put("totalServiceHour", summary.getTotalServiceHour() != null ? summary.getTotalServiceHour().doubleValue() : 0);
            map.put("monthServiceHour", summary.getMonthServiceHour() != null ? summary.getMonthServiceHour().doubleValue() : 0);
            map.put("totalActivityCount", summary.getTotalActivityCount() != null ? summary.getTotalActivityCount() : 0);
            map.put("rankingNo", summary.getRankingNo());
            map.put("lastCalculateTime", summary.getLastCalculateTime() != null ? dateFormat.format(summary.getLastCalculateTime()) : "");
        }

        return map;
    }

    private Map<String, Object> hourChangeToMap(ServiceHourChange change) {
        Map<String, Object> map = new HashMap<>();

        map.put("id", change.getId());
        map.put("activityId", change.getActivityId());
        map.put("activityTitle", change.getActivityTitle() != null ? change.getActivityTitle() : "管理员录入");
        map.put("changeType", change.getChangeType());
        map.put("changeTypeLabel", ServiceHourChange.getChangeTypeLabel(change.getChangeType()));
        map.put("changeSource", change.getChangeSource());
        map.put("changeSourceLabel", ServiceHourChange.getChangeSourceLabel(change.getChangeSource()));
        map.put("changeHour", change.getChangeHour() != null ? change.getChangeHour().doubleValue() : 0);
        map.put("changeReason", change.getChangeReason());
        map.put("createTime", change.getCreateTime() != null ? dateOnlyFormat.format(change.getCreateTime()) : "");

        return map;
    }

    private Map<String, Object> result(boolean success, String message) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", success);
        map.put("message", message);
        return map;
    }

    private void writeJson(HttpServletResponse resp, Object data) throws IOException {
        resp.getWriter().write(JSON.toJSONString(data));
    }
}

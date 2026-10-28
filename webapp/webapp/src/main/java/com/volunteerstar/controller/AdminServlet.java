package com.volunteerstar.controller;

import com.volunteerstar.pojo.Activity;
import com.volunteerstar.pojo.ActivitySign;
import com.volunteerstar.pojo.Registration;
import com.volunteerstar.pojo.User;
import com.volunteerstar.service.AdminService;
import com.volunteerstar.service.impl.AdminServiceImpl;
import com.volunteerstar.utils.StringUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.alibaba.fastjson2.JSON;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/*")
public class AdminServlet extends HttpServlet {

    private final AdminService adminService = new AdminServiceImpl();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        if (loginUser == null || !"1".equals(loginUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "需要管理员权限");
            return;
        }

        String path = req.getPathInfo();
        if (path == null) path = "/";

        resp.setContentType("application/json;charset=UTF-8");

        try {
            switch (path) {
                case "/activities":
                    handleActivities(req, resp);
                    break;
                case "/activity/add":
                    handleAddActivity(req, resp, loginUser);
                    break;
                case "/activity/update":
                    handleUpdateActivity(req, resp);
                    break;
                case "/activity/delete":
                    handleDeleteActivity(req, resp);
                    break;
                case "/activity/detail":
                    handleActivityDetail(req, resp);
                    break;

                case "/registrations":
                    handleRegistrations(req, resp);
                    break;
                case "/registration/approve":
                    handleApprove(req, resp);
                    break;
                case "/registration/reject":
                    handleReject(req, resp);
                    break;
                case "/registration/batch-approve":
                    handleBatchApprove(req, resp);
                    break;

                case "/checkin/list":
                case "/registration/checkinlist":
                    handleCheckInList(req, resp);
                    break;
                case "/checkin/signin":
                case "/registration/checkin":
                    handleSignIn(req, resp);
                    break;
                case "/checkin/signout":
                case "/registration/checkout":
                    handleSignOut(req, resp, loginUser);
                    break;

                case "/stats":
                    handleStats(resp);
                    break;

                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            getServletContext().log("后台接口处理失败", e);
            writeJson(resp, errorResult(e.getMessage()));
        }
    }

    private void handleActivities(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String statusStr = req.getParameter("status");
        Integer status = StringUtils.isBlank(statusStr) ? null : Integer.parseInt(statusStr);

        List<Activity> list = adminService.getActivities(keyword, status);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", list.stream().map(this::activityToMap).toList());
        writeJson(resp, result);
    }

    private void handleAddActivity(HttpServletRequest req, HttpServletResponse resp, User admin) throws Exception {
        Activity activity = new Activity();
        activity.setTitle(req.getParameter("title"));
        activity.setCategory(req.getParameter("category"));
        activity.setCategoryColor(req.getParameter("categoryColor"));
        activity.setDescription(req.getParameter("description"));
        activity.setLocation(req.getParameter("location"));
        activity.setStartTime(parseDate(req.getParameter("startTime")));
        activity.setEndTime(parseDate(req.getParameter("endTime")));
        activity.setCapacity(Integer.parseInt(req.getParameter("capacity")));
        activity.setStatus(Integer.parseInt(req.getParameter("status")));
        activity.setImage(req.getParameter("image"));
        activity.setAdminId(admin.getId());

        boolean success = adminService.addActivity(activity);
        writeJson(resp, success ? successResult("活动发布成功") : errorResult("发布失败"));
    }

    private void handleUpdateActivity(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Activity activity = new Activity();
        activity.setId(Integer.parseInt(req.getParameter("id")));
        activity.setTitle(req.getParameter("title"));
        activity.setCategory(req.getParameter("category"));
        activity.setCategoryColor(req.getParameter("categoryColor"));
        activity.setDescription(req.getParameter("description"));
        activity.setLocation(req.getParameter("location"));

        String startTime = req.getParameter("startTime");
        if (!StringUtils.isBlank(startTime)) {
            activity.setStartTime(dateFormat.parse(startTime));
        }
        String endTime = req.getParameter("endTime");
        if (!StringUtils.isBlank(endTime)) {
            activity.setEndTime(dateFormat.parse(endTime));
        }

        String capacity = req.getParameter("capacity");
        if (!StringUtils.isBlank(capacity)) {
            activity.setCapacity(Integer.parseInt(capacity));
        }
        String status = req.getParameter("status");
        if (!StringUtils.isBlank(status)) {
            activity.setStatus(Integer.parseInt(status));
        }
        activity.setImage(req.getParameter("image"));

        boolean success = adminService.updateActivity(activity);
        writeJson(resp, success ? successResult("更新成功") : errorResult("更新失败"));
    }

    private void handleDeleteActivity(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        boolean success = adminService.deleteActivity(id);
        writeJson(resp, success ? successResult("删除成功") : errorResult("删除失败"));
    }

    private void handleActivityDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        Activity activity = adminService.getActivityById(id);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", activityToMap(activity));
        writeJson(resp, result);
    }

    private void handleRegistrations(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String activityIdStr = req.getParameter("activityId");
        Integer activityId = StringUtils.isBlank(activityIdStr) ? null : Integer.parseInt(activityIdStr);
        String statusStr = req.getParameter("status");
        Integer status = StringUtils.isBlank(statusStr) ? null : Integer.parseInt(statusStr);
        String keyword = req.getParameter("keyword");

        List<Registration> list = adminService.getRegistrations(activityId, status, keyword);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", list.stream().map(this::registrationToMap).toList());
        writeJson(resp, result);
    }

    private void handleApprove(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        String remark = req.getParameter("remark");
        boolean success = adminService.approveRegistration(id, remark);
        writeJson(resp, success ? successResult("审核通过") : errorResult("操作失败"));
    }

    private void handleReject(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        String remark = req.getParameter("remark");
        boolean success = adminService.rejectRegistration(id, remark);
        writeJson(resp, success ? successResult("已拒绝") : errorResult("操作失败"));
    }

    private void handleBatchApprove(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idsStr = req.getParameter("ids");
        List<Integer> ids = Arrays.stream(idsStr.split(","))
                .map(Integer::parseInt)
                .toList();
        boolean success = adminService.batchApprove(ids);
        writeJson(resp, success ? successResult("批量审核成功") : errorResult("操作失败"));
    }

    private void handleCheckInList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String statusStr = req.getParameter("status");
        Integer signStatus = parseOptionalInt(statusStr);

        List<ActivitySign> list = adminService.getCheckInList(signStatus);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", list.stream().map(this::activitySignToMap).toList());
        writeJson(resp, result);
    }

    private void handleSignIn(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        boolean success = adminService.checkIn(id);
        writeJson(resp, success ? successResult("签到成功") : errorResult("签到失败，请确认已通过审核"));
    }

    private void handleSignOut(HttpServletRequest req, HttpServletResponse resp, User admin) throws IOException {
        Integer id = Integer.parseInt(req.getParameter("id"));
        String hoursStr = req.getParameter("hours");
        Double hours = StringUtils.isBlank(hoursStr) ? 0.0 : Double.parseDouble(hoursStr);

        boolean success = adminService.checkOut(id, hours, admin.getId());
        writeJson(resp, success ? successResult("签退成功，时长已记录") : errorResult("签退失败，请确认已签到"));
    }

    private void handleStats(HttpServletResponse resp) throws IOException {
        Map<String, Object> stats = adminService.getDashboardStats();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", stats);
        writeJson(resp, result);
    }

    private java.util.Date parseDate(String value) throws Exception {
        try {
            return dateFormat.parse(value);
        } catch (Exception e) {
            return new SimpleDateFormat("yyyy/MM/dd HH:mm").parse(value);
        }
    }

    private Integer parseOptionalInt(String value) {
        if (StringUtils.isBlank(value) || "null".equals(value) || "undefined".equals(value)) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Map<String, Object> activityToMap(Activity a) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", a.getId());
        map.put("title", a.getTitle());
        map.put("category", a.getCategory());
        map.put("categoryColor", a.getCategoryColor());
        map.put("description", a.getDescription());
        map.put("location", a.getLocation());
        map.put("startTime", a.getStartTime() != null ? dateFormat.format(a.getStartTime()) : "");
        map.put("endTime", a.getEndTime() != null ? dateFormat.format(a.getEndTime()) : "");
        map.put("capacity", a.getCapacity());
        map.put("enrolled", a.getEnrolled());
        map.put("status", a.getStatus());
        map.put("statusLabel", Activity.getStatusLabel(a.getStatus()));
        map.put("image", a.getImage());
        map.put("createTime", a.getCreateTime() != null ? dateFormat.format(a.getCreateTime()) : "");
        return map;
    }

    private Map<String, Object> registrationToMap(Registration r) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", r.getId());
        map.put("activityId", r.getActivityId());
        map.put("activityTitle", r.getActivityTitle());
        map.put("activityLocation", r.getActivityLocation());
        map.put("userId", r.getUserId());
        map.put("userName", r.getUserName());
        map.put("userPhone", r.getUserPhone());
        map.put("status", r.getStatus());
        map.put("statusLabel", Registration.getStatusLabel(r.getStatus()));
        map.put("registerTime", r.getRegisterTime() != null ? dateFormat.format(r.getRegisterTime()) : "");
        map.put("checkInTime", r.getCheckInTime() != null ? dateFormat.format(r.getCheckInTime()) : "");
        map.put("checkOutTime", r.getCheckOutTime() != null ? dateFormat.format(r.getCheckOutTime()) : "");
        map.put("hours", r.getHours());
        map.put("remark", r.getRemark());
        return map;
    }

    private Map<String, Object> activitySignToMap(ActivitySign s) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", s.getId());
        map.put("activityEnrollmentId", s.getActivityEnrollmentId());
        map.put("signInTime", s.getSignInTime() != null ? dateFormat.format(s.getSignInTime()) : "");
        map.put("signOutTime", s.getSignOutTime() != null ? dateFormat.format(s.getSignOutTime()) : "");
        map.put("signStatus", s.getSignStatus());
        map.put("signStatusLabel", ActivitySign.getSignStatusLabel(s.getSignStatus()));
        map.put("serviceHourActual", s.getServiceHourActual());
        map.put("userName", s.getUserName());
        map.put("userPhone", s.getUserPhone());
        map.put("activityTitle", s.getActivityTitle());
        map.put("activityLocation", s.getActivityLocation());
        map.put("userId", s.getUserId());
        map.put("activityId", s.getActivityId());
        return map;
    }

    private Map<String, Object> successResult(String message) {
        return result(true, message);
    }

    private Map<String, Object> errorResult(String message) {
        return result(false, message);
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

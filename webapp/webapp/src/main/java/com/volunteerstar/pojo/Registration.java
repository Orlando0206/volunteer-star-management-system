package com.volunteerstar.pojo;

import java.io.Serializable;
import java.util.Date;

public class Registration implements Serializable {
    private Integer id;
    private Integer activityId;
    private Integer userId;
    private Integer status;
    private Date registerTime;
    private Date checkInTime;
    private Date checkOutTime;
    private Double hours;
    private String remark;

    // 关联查询字段
    private String userName;
    private String userPhone;
    private String activityTitle;
    private String activityLocation;

    // 状态常量
    public static final int STATUS_PENDING = 0;
    public static final int STATUS_APPROVED = 1;
    public static final int STATUS_REJECTED = 2;
    public static final int STATUS_CANCELLED = 3;
    public static final int STATUS_COMPLETED = 4;

    public static String getStatusLabel(int status) {
        if (status == STATUS_PENDING) return "待审核";
        if (status == STATUS_APPROVED) return "已通过";
        if (status == STATUS_REJECTED) return "已拒绝";
        if (status == STATUS_CANCELLED) return "已取消";
        if (status == STATUS_COMPLETED) return "已完成";
        return "未知";
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getActivityId() { return activityId; }
    public void setActivityId(Integer activityId) { this.activityId = activityId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Date getRegisterTime() { return registerTime; }
    public void setRegisterTime(Date registerTime) { this.registerTime = registerTime; }
    public Date getCheckInTime() { return checkInTime; }
    public void setCheckInTime(Date checkInTime) { this.checkInTime = checkInTime; }
    public Date getCheckOutTime() { return checkOutTime; }
    public void setCheckOutTime(Date checkOutTime) { this.checkOutTime = checkOutTime; }
    public Double getHours() { return hours; }
    public void setHours(Double hours) { this.hours = hours; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }
    public String getActivityTitle() { return activityTitle; }
    public void setActivityTitle(String activityTitle) { this.activityTitle = activityTitle; }
    public String getActivityLocation() { return activityLocation; }
    public void setActivityLocation(String activityLocation) { this.activityLocation = activityLocation; }
}
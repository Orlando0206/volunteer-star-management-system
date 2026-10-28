package com.volunteerstar.pojo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 签到签退记录实体类 - 对应 volunteer_activity_sign 表
 */
public class ActivitySign implements Serializable {
    private Integer id;
    private Integer activityEnrollmentId;  // 报名记录ID
    private Date signInTime;                // 签到时间
    private Date signOutTime;               // 签退时间
    private Integer signStatus;             // 签到状态：0未签到，1已签到，2已签退
    private BigDecimal serviceHourActual;   // 实际服务时长
    private Integer confirmUserId;          // 确认用户ID
    private String qrCodeToken;             // 签到码令牌
    private Date createTime;
    private Date updateTime;

    // 关联查询字段
    private String userName;                // 用户姓名
    private String userPhone;               // 用户手机
    private String activityTitle;           // 活动标题
    private String activityLocation;        // 活动地点
    private Integer userId;                 // 用户ID
    private Integer activityId;             // 活动ID

    // 状态常量
    public static final int SIGN_STATUS_NOT_SIGNED = 0;
    public static final int SIGN_STATUS_SIGNED_IN = 1;
    public static final int SIGN_STATUS_SIGNED_OUT = 2;

    public static String getSignStatusLabel(int status) {
        if (status == SIGN_STATUS_NOT_SIGNED) {
            return "未签到";
        }
        if (status == SIGN_STATUS_SIGNED_IN) {
            return "已签到";
        }
        if (status == SIGN_STATUS_SIGNED_OUT) {
            return "已签退";
        }
        return "未知";
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getActivityEnrollmentId() { return activityEnrollmentId; }
    public void setActivityEnrollmentId(Integer activityEnrollmentId) { this.activityEnrollmentId = activityEnrollmentId; }
    public Date getSignInTime() { return signInTime; }
    public void setSignInTime(Date signInTime) { this.signInTime = signInTime; }
    public Date getSignOutTime() { return signOutTime; }
    public void setSignOutTime(Date signOutTime) { this.signOutTime = signOutTime; }
    public Integer getSignStatus() { return signStatus; }
    public void setSignStatus(Integer signStatus) { this.signStatus = signStatus; }
    public BigDecimal getServiceHourActual() { return serviceHourActual; }
    public void setServiceHourActual(BigDecimal serviceHourActual) { this.serviceHourActual = serviceHourActual; }
    public Integer getConfirmUserId() { return confirmUserId; }
    public void setConfirmUserId(Integer confirmUserId) { this.confirmUserId = confirmUserId; }
    public String getQrCodeToken() { return qrCodeToken; }
    public void setQrCodeToken(String qrCodeToken) { this.qrCodeToken = qrCodeToken; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }
    public String getActivityTitle() { return activityTitle; }
    public void setActivityTitle(String activityTitle) { this.activityTitle = activityTitle; }
    public String getActivityLocation() { return activityLocation; }
    public void setActivityLocation(String activityLocation) { this.activityLocation = activityLocation; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getActivityId() { return activityId; }
    public void setActivityId(Integer activityId) { this.activityId = activityId; }
}
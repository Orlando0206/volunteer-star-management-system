package com.volunteerstar.pojo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 时长明细实体类 - 对应 volunteer_service_hour_change 表
 */
public class ServiceHourChange implements Serializable {
    private Integer id;
    private Integer userId;                 // 用户ID
    private Integer activityId;             // 活动ID
    private Integer activitySignId;         // 签到记录ID
    private String changeType;              // 变更类型：1增加，2扣减
    private String changeSource;            // 时长来源：sign_auto签到自动、admin_manual管理员录入、user_apply自主申请
    private BigDecimal changeHour;          // 变更时长
    private String changeReason;            // 变更原因
    private Integer operateUserId;          // 操作用户ID
    private Date createTime;
    private Date updateTime;

    // 关联查询字段
    private String activityTitle;           // 活动标题
    private String userName;                // 用户姓名

    // 变更类型常量
    public static final String CHANGE_TYPE_ADD = "1";
    public static final String CHANGE_TYPE_SUBTRACT = "2";

    // 变更来源常量
    public static final String SOURCE_SIGN_AUTO = "sign_auto";
    public static final String SOURCE_ADMIN_MANUAL = "admin_manual";
    public static final String SOURCE_USER_APPLY = "user_apply";

    public static String getChangeTypeLabel(String type) {
        if (CHANGE_TYPE_ADD.equals(type)) {
            return "增加";
        }
        if (CHANGE_TYPE_SUBTRACT.equals(type)) {
            return "扣减";
        }
        return "未知";
    }

    public static String getChangeSourceLabel(String source) {
        if (SOURCE_SIGN_AUTO.equals(source)) {
            return "签到自动结算";
        }
        if (SOURCE_ADMIN_MANUAL.equals(source)) {
            return "管理员录入";
        }
        if (SOURCE_USER_APPLY.equals(source)) {
            return "自主申请";
        }
        return "未知";
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getActivityId() { return activityId; }
    public void setActivityId(Integer activityId) { this.activityId = activityId; }
    public Integer getActivitySignId() { return activitySignId; }
    public void setActivitySignId(Integer activitySignId) { this.activitySignId = activitySignId; }
    public String getChangeType() { return changeType; }
    public void setChangeType(String changeType) { this.changeType = changeType; }
    public String getChangeSource() { return changeSource; }
    public void setChangeSource(String changeSource) { this.changeSource = changeSource; }
    public BigDecimal getChangeHour() { return changeHour; }
    public void setChangeHour(BigDecimal changeHour) { this.changeHour = changeHour; }
    public String getChangeReason() { return changeReason; }
    public void setChangeReason(String changeReason) { this.changeReason = changeReason; }
    public Integer getOperateUserId() { return operateUserId; }
    public void setOperateUserId(Integer operateUserId) { this.operateUserId = operateUserId; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    public String getActivityTitle() { return activityTitle; }
    public void setActivityTitle(String activityTitle) { this.activityTitle = activityTitle; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
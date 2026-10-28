package com.volunteerstar.pojo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 时长汇总实体类 - 对应 volunteer_service_hour_summary 表
 */
public class ServiceHourSummary implements Serializable {
    private Integer id;
    private Integer userId;                 // 用户ID
    private BigDecimal totalServiceHour;    // 累计志愿时长
    private BigDecimal monthServiceHour;    // 本月志愿时长
    private Integer totalActivityCount;     // 累计完成活动数
    private Integer rankingNo;              // 排行名次
    private Date lastCalculateTime;         // 最后结算时间
    private Date createTime;
    private Date updateTime;

    // 关联查询字段
    private String userName;                // 用户姓名
    private String userPhone;               // 用户手机

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public BigDecimal getTotalServiceHour() { return totalServiceHour; }
    public void setTotalServiceHour(BigDecimal totalServiceHour) { this.totalServiceHour = totalServiceHour; }
    public BigDecimal getMonthServiceHour() { return monthServiceHour; }
    public void setMonthServiceHour(BigDecimal monthServiceHour) { this.monthServiceHour = monthServiceHour; }
    public Integer getTotalActivityCount() { return totalActivityCount; }
    public void setTotalActivityCount(Integer totalActivityCount) { this.totalActivityCount = totalActivityCount; }
    public Integer getRankingNo() { return rankingNo; }
    public void setRankingNo(Integer rankingNo) { this.rankingNo = rankingNo; }
    public Date getLastCalculateTime() { return lastCalculateTime; }
    public void setLastCalculateTime(Date lastCalculateTime) { this.lastCalculateTime = lastCalculateTime; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }
}
package com.volunteerstar.pojo;

import java.io.Serializable;
import java.util.Date;

public class Activity implements Serializable {
    private Integer id;
    private String title;
    private String category;
    private String categoryColor;
    private String description;
    private String location;
    private Date startTime;
    private Date endTime;
    private Integer capacity;
    private Integer enrolled;
    private Integer status;
    private String image;
    private Date createTime;
    private Date updateTime;
    private Integer adminId;

    // 状态常量
    public static final int STATUS_RECRUITING = 0;
    public static final int STATUS_ONGOING = 1;
    public static final int STATUS_FINISHED = 2;
    public static final int STATUS_CANCELLED = 3;

    // 状态文字
    public static String getStatusLabel(int status) {
        if (status == STATUS_RECRUITING) return "招募中";
        if (status == STATUS_ONGOING) return "进行中";
        if (status == STATUS_FINISHED) return "已结束";
        if (status == STATUS_CANCELLED) return "已取消";
        return "未知";
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getCategoryColor() { return categoryColor; }
    public void setCategoryColor(String categoryColor) { this.categoryColor = categoryColor; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public Integer getEnrolled() { return enrolled; }
    public void setEnrolled(Integer enrolled) { this.enrolled = enrolled; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    public Integer getAdminId() { return adminId; }
    public void setAdminId(Integer adminId) { this.adminId = adminId; }
}

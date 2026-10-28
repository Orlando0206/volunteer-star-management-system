-- 志愿星河数据库：14张核心表
-- 执行前请先备份现有数据库。

CREATE DATABASE IF NOT EXISTS volunteer_star DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

USE volunteer_star;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS volunteer_project_phase;
DROP TABLE IF EXISTS volunteer_testimonial;
DROP TABLE IF EXISTS volunteer_system_setting;
DROP TABLE IF EXISTS volunteer_admin_operation_log;
DROP TABLE IF EXISTS volunteer_timeline_event;
DROP TABLE IF EXISTS volunteer_user_badge;
DROP TABLE IF EXISTS volunteer_badge;
DROP TABLE IF EXISTS volunteer_discover_action_log;
DROP TABLE IF EXISTS volunteer_activity_share_log;
DROP TABLE IF EXISTS volunteer_activity_favorite;
DROP TABLE IF EXISTS volunteer_message_read;
DROP TABLE IF EXISTS volunteer_message;
DROP TABLE IF EXISTS volunteer_activity_tag_rel;
DROP TABLE IF EXISTS volunteer_activity_image;
DROP TABLE IF EXISTS volunteer_org_admin_rel;
DROP TABLE IF EXISTS volunteer_service_hour_change;
DROP TABLE IF EXISTS volunteer_service_hour_summary;
DROP TABLE IF EXISTS volunteer_activity_sign;
DROP TABLE IF EXISTS volunteer_activity_enrollment;
DROP TABLE IF EXISTS volunteer_category_stat_snapshot;
DROP TABLE IF EXISTS volunteer_region_stat_snapshot;
DROP TABLE IF EXISTS volunteer_monthly_stat_snapshot;
DROP TABLE IF EXISTS volunteer_home_stat_snapshot;
DROP TABLE IF EXISTS volunteer_activity;
DROP TABLE IF EXISTS volunteer_activity_status;
DROP TABLE IF EXISTS volunteer_tag;
DROP TABLE IF EXISTS volunteer_organization;
DROP TABLE IF EXISTS volunteer_region;
DROP TABLE IF EXISTS volunteer_user;

CREATE TABLE volunteer_user (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID，当前登录注册代码 UserMapper/AuthServlet 直接依赖此字段',
  username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录用户名，前端 login.jsp 登录表单和注册表单使用',
  password VARCHAR(100) NOT NULL COMMENT '登录密码，前端 login.jsp 登录提交时校验；当前项目仍使用明文示例以兼容 PasswordUtils',
  nickname VARCHAR(50) NOT NULL COMMENT '昵称，前端 header.jspf 右上角用户名、dashboard.jsp 个人中心姓名展示使用',
  phone VARCHAR(20) DEFAULT NULL COMMENT '手机号，前端 login.jsp 注册表单填写；后续 admin.jsp 用户管理列表和 dashboard.jsp 个人设置展示使用',
  email VARCHAR(100) DEFAULT NULL COMMENT '邮箱，当前注册页不展示不必填；预留给 dashboard.jsp 个人设置中的资料完善功能',
  avatar_url VARCHAR(255) DEFAULT NULL COMMENT '头像路径，前端 dashboard.jsp 头像区、admin.jsp 用户头像列表展示使用',
  real_name VARCHAR(50) DEFAULT NULL COMMENT '真实姓名，前端 admin.jsp 用户管理、报名审核名单和操作日志展示真实姓名使用',
  gender CHAR(1) DEFAULT NULL COMMENT '性别：M男，F女，U未知；预留给 dashboard.jsp 个人设置资料项',
  birthday DATE DEFAULT NULL COMMENT '出生日期，预留给 dashboard.jsp 个人设置资料项',
  region_id INT DEFAULT NULL COMMENT '所属区域ID，关联 volunteer_region.id；用于 heatmap.jsp 区域统计和 admin.jsp 用户归属区域展示',
  register_source VARCHAR(30) NOT NULL DEFAULT 'web' COMMENT '注册来源，当前记录为 web；后续可用于 admin.jsp 用户来源统计',
  account_status CHAR(1) NOT NULL DEFAULT '1' COMMENT '账号状态：0停用，1正常；前端 admin.jsp 用户管理中的状态展示和禁用操作使用',
  role CHAR(1) NOT NULL DEFAULT '0' COMMENT '角色：0普通用户，1管理员；前端 header.jspf 和 admin.jsp 通过角色控制入口展示',
  last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间，后续用于 admin.jsp 用户活跃度查看',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间，前端 admin.jsp 用户管理可查看注册时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，前端 admin.jsp 用户管理和 dashboard.jsp 资料修改后可追踪'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户主表：当前用于 login.jsp 登录注册、dashboard.jsp 个人资料展示、admin.jsp 用户管理列表，同时为报名、消息、时长、徽章等功能提供用户主体。';

CREATE TABLE volunteer_region (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  region_name VARCHAR(50) NOT NULL UNIQUE COMMENT '区域名称，前端 heatmap.jsp 区域热力点、区域排行列表展示使用',
  parent_region_id INT DEFAULT NULL COMMENT '上级区域ID，关联 volunteer_region.id；用于区域树形结构扩展',
  region_level TINYINT NOT NULL DEFAULT 1 COMMENT '区域层级：1地市，2区县，3街道；前端 heatmap.jsp 可按层级统计',
  region_code VARCHAR(20) DEFAULT NULL COMMENT '区域编码，便于后台和地图扩展对接',
  center_x DECIMAL(6,2) DEFAULT NULL COMMENT '热力地图横向坐标，当前对应 data.js 中 coords.x',
  center_y DECIMAL(6,2) DEFAULT NULL COMMENT '热力地图纵向坐标，当前对应 data.js 中 coords.y',
  sort_no INT NOT NULL DEFAULT 0 COMMENT '排序号，前端 heatmap.jsp 排名列表展示顺序控制',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  CONSTRAINT fk_region_parent_region_id__ref_volunteer_region FOREIGN KEY (parent_region_id) REFERENCES volunteer_region(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='区域表：用于 heatmap.jsp 热力地图坐标展示、区域活跃度排行、区域活动数量/参与人数/总时长统计，也供 activities.jsp 活动归属区域和 admin.jsp 组织归属区域使用。';

CREATE TABLE volunteer_organization (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  region_id INT NOT NULL COMMENT '所属区域ID，关联 volunteer_region.id；前端 admin.jsp 组织归属区域展示使用',
  organization_name VARCHAR(100) NOT NULL COMMENT '组织名称，前端 activities.jsp 活动发布方、admin.jsp 活动管理和组织管理使用',
  organization_type VARCHAR(30) NOT NULL DEFAULT 'social' COMMENT '组织类型：social社会组织，school学校，community社区等；用于 admin.jsp 组织筛选',
  contact_name VARCHAR(50) DEFAULT NULL COMMENT '联系人姓名，前端 admin.jsp 组织管理联系方式展示使用',
  contact_phone VARCHAR(20) DEFAULT NULL COMMENT '联系人电话，前端 admin.jsp 组织管理联系方式展示使用',
  address VARCHAR(255) DEFAULT NULL COMMENT '组织地址，前端 admin.jsp 组织管理详情展示使用',
  description VARCHAR(500) DEFAULT NULL COMMENT '组织简介，后续可用于 index.jsp 组织介绍或 admin.jsp 组织详情展示',
  status CHAR(1) NOT NULL DEFAULT '1' COMMENT '组织状态：0停用，1启用；前端 admin.jsp 组织管理状态列使用',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  CONSTRAINT fk_organization_region_id__ref_volunteer_region FOREIGN KEY (region_id) REFERENCES volunteer_region(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='组织表：用于 admin.jsp 组织管理、activities.jsp 活动发布主体信息展示、index.jsp 首页平台合作组织统计基础数据。';

CREATE TABLE volunteer_tag (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  tag_name VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名称，前端 activities.jsp 分类筛选按钮、heatmap.jsp 类型分布列表展示使用',
  tag_type VARCHAR(30) NOT NULL COMMENT '标签类型，当前主要为 activity_type；便于前端区分活动分类、主题标签等',
  color_code VARCHAR(20) DEFAULT NULL COMMENT '颜色编码，当前对应 data.js 中不同活动类型颜色展示',
  description VARCHAR(255) DEFAULT NULL COMMENT '标签说明，后续可用于 admin.jsp 标签管理详情',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动标签表：用于 activities.jsp 活动分类筛选、heatmap.jsp 活动类型分布、admin.jsp 活动标签维护。';

CREATE TABLE volunteer_activity_status (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  status_code VARCHAR(30) NOT NULL UNIQUE COMMENT '状态编码，如 recruiting、completed、cancelled；便于前后端统一状态值',
  status_name VARCHAR(50) NOT NULL COMMENT '状态名称，前端 activities.jsp 活动卡片状态文案、admin.jsp 活动状态列展示使用',
  sort_no INT NOT NULL DEFAULT 0 COMMENT '排序号，前端 admin.jsp 状态筛选下拉顺序使用',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动状态字典表：用于 activities.jsp 招募中/已完成等状态展示、discover.jsp 卡片状态展示、admin.jsp 活动管理状态筛选。';

CREATE TABLE volunteer_activity (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID，对应前端 data.js activities 数组中的活动ID',
  organization_id INT NOT NULL COMMENT '发布组织ID，关联 volunteer_organization.id；前端活动发布主体展示使用',
  region_id INT NOT NULL COMMENT '活动区域ID，关联 volunteer_region.id；用于 heatmap.jsp 区域统计和活动定位',
  activity_status_id INT NOT NULL COMMENT '活动状态ID，关联 volunteer_activity_status.id；用于 activities.jsp 和 discover.jsp 状态展示',
  publish_user_id INT NOT NULL COMMENT '发布用户ID，关联 volunteer_user.id；用于 admin.jsp 活动管理中的发布人展示',
  title VARCHAR(150) NOT NULL COMMENT '活动标题，前端 activities.jsp 活动卡片标题、discover.jsp 推荐卡片、dashboard.jsp 报名记录和时长明细均使用',
  activity_type VARCHAR(50) NOT NULL COMMENT '活动类型名称，前端 activities.jsp 分类展示、heatmap.jsp 类型分布展示使用',
  activity_cover_url VARCHAR(255) DEFAULT NULL COMMENT '活动封面图路径，供首页、活动中心和发现页展示',
  description TEXT NOT NULL COMMENT '活动描述，前端 discover.jsp 活动详情文案、后续活动详情页正文展示使用',
  address VARCHAR(255) NOT NULL COMMENT '活动地点，前端 activities.jsp、discover.jsp、timeline3d.jsp 地点展示使用',
  start_time DATETIME NOT NULL COMMENT '活动开始时间，前端 activities.jsp 时间展示、admin.jsp 活动管理使用',
  end_time DATETIME NOT NULL COMMENT '活动结束时间，前端 admin.jsp 活动管理和时长核算使用',
  sign_in_start_time DATETIME DEFAULT NULL COMMENT '签到开始时间，前端 admin.jsp 签到管理和未来活动详情签到规则提示使用',
  sign_out_end_time DATETIME DEFAULT NULL COMMENT '签退截止时间，前端 admin.jsp 签到管理和未来活动详情签退规则提示使用',
  recruit_count INT NOT NULL DEFAULT 0 COMMENT '招募人数，前端 activities.jsp 活动卡片容量展示使用',
  applied_count INT NOT NULL DEFAULT 0 COMMENT '已报名人数，前端 activities.jsp 卡片已报名人数、discover.jsp 热度信息和 admin.jsp 活动报名概览使用',
  favorite_count INT NOT NULL DEFAULT 0 COMMENT '收藏人数，前端 discover.jsp 收藏动作统计和后续活动热度排行使用',
  share_count INT NOT NULL DEFAULT 0 COMMENT '分享次数，前端 discover.jsp 下滑分享统计和 admin.jsp 活动传播效果查看使用',
  service_hour DECIMAL(6,2) NOT NULL DEFAULT 0 COMMENT '标准志愿时长，前端 dashboard.jsp 时长明细和 admin.jsp 时长管理使用',
  heat_value INT NOT NULL DEFAULT 0 COMMENT '热度值，前端 heatmap.jsp 热力图和 discover.jsp 推荐排序使用',
  publish_time DATETIME DEFAULT NULL COMMENT '发布时间，前端 activities.jsp 最新排序和 admin.jsp 发布时间展示使用',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  CONSTRAINT fk_activity_organization_id__ref_volunteer_organization FOREIGN KEY (organization_id) REFERENCES volunteer_organization(id),
  CONSTRAINT fk_activity_region_id__ref_volunteer_region FOREIGN KEY (region_id) REFERENCES volunteer_region(id),
  CONSTRAINT fk_activity_activity_status_id__ref_volunteer_activity_status FOREIGN KEY (activity_status_id) REFERENCES volunteer_activity_status(id),
  CONSTRAINT fk_activity_publish_user_id__ref_volunteer_user FOREIGN KEY (publish_user_id) REFERENCES volunteer_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动主表：用于 activities.jsp 活动列表、discover.jsp 推荐活动、index.jsp 首页推荐、admin.jsp 活动管理；存活动标题、地点、报名人数、状态、发布时间等核心信息。';

CREATE TABLE volunteer_activity_enrollment (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  activity_id INT NOT NULL COMMENT '活动ID，关联 volunteer_activity.id；前端 dashboard.jsp 我的报名、admin.jsp 报名审核依赖',
  user_id INT NOT NULL COMMENT '报名用户ID，关联 volunteer_user.id；记录是谁报了名',
  enroll_status CHAR(1) NOT NULL DEFAULT '0' COMMENT '报名状态：0待审核，1通过，2拒绝，3取消，4已完成；前端 dashboard.jsp 我的报名状态标签和 admin.jsp 审核列表使用',
  enroll_remark VARCHAR(255) DEFAULT NULL COMMENT '报名备注，后续 discover.jsp 报名说明填写和 admin.jsp 审核查看使用',
  enroll_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间，前端 dashboard.jsp 我的报名时间、admin.jsp 审核时间展示使用',
  audit_user_id INT DEFAULT NULL COMMENT '审核用户ID，关联 volunteer_user.id；前端 admin.jsp 报名审核记录使用',
  audit_time DATETIME DEFAULT NULL COMMENT '审核时间，前端 admin.jsp 报名审核结果展示使用',
  audit_remark VARCHAR(255) DEFAULT NULL COMMENT '审核备注，前端 admin.jsp 审核意见查看使用',
  cancel_time DATETIME DEFAULT NULL COMMENT '取消报名时间，前端 dashboard.jsp 取消报名记录展示使用',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  CONSTRAINT uk_activity_enrollment UNIQUE (activity_id, user_id),
  CONSTRAINT fk_activity_enrollment_activity_id__ref_volunteer_activity FOREIGN KEY (activity_id) REFERENCES volunteer_activity(id),
  CONSTRAINT fk_activity_enrollment_user_id__ref_volunteer_user FOREIGN KEY (user_id) REFERENCES volunteer_user(id),
  CONSTRAINT fk_activity_enrollment_audit_user_id__ref_volunteer_user FOREIGN KEY (audit_user_id) REFERENCES volunteer_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动报名表：用于 dashboard.jsp 我的报名、admin.jsp 报名审核、discover.jsp 右滑报名动作落库；支撑报名状态、审核结果、取消报名记录。';

CREATE TABLE volunteer_activity_sign (
                                         id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
                                         activity_enrollment_id INT NOT NULL COMMENT '报名记录ID，关联 volunteer_activity_enrollment.id；签到签退与报名记录一一对应',
                                         sign_in_time DATETIME DEFAULT NULL COMMENT '签到时间，前端 admin.jsp 签到管理、dashboard.jsp 活动参与状态展示使用',
                                         sign_out_time DATETIME DEFAULT NULL COMMENT '签退时间，前端 admin.jsp 签到管理、时长结算使用',
                                         sign_status CHAR(1) NOT NULL DEFAULT '0' COMMENT '签到状态：0未签到，1已签到，2已签退；前端 admin.jsp 签到状态列和 dashboard.jsp 参与状态展示使用',
                                         service_hour_actual DECIMAL(6,2) NOT NULL DEFAULT 0 COMMENT '实际服务时长，前端 dashboard.jsp 时长明细、admin.jsp 时长核算展示使用',
                                         confirm_user_id INT DEFAULT NULL COMMENT '确认用户ID，关联 volunteer_user.id；前端 admin.jsp 确认人展示使用',
                                         qr_code_token VARCHAR(64) DEFAULT NULL COMMENT '签到码令牌，后续活动签到二维码功能扩展使用',
                                         create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                         update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                         CONSTRAINT uk_activity_sign UNIQUE (activity_enrollment_id),
                                         CONSTRAINT fk_sign_enroll FOREIGN KEY (activity_enrollment_id) REFERENCES volunteer_activity_enrollment(id),
                                         CONSTRAINT fk_sign_confirm_user FOREIGN KEY (confirm_user_id) REFERENCES volunteer_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动签到签退表：用于 admin.jsp 签到管理、dashboard.jsp 活动参与状态和时长结算来源展示，也是 volunteer_service_hour_change 自动记时的重要依据。';

CREATE TABLE volunteer_service_hour_summary (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  user_id INT NOT NULL COMMENT '用户ID，关联 volunteer_user.id；每个用户一条累计时长汇总',
  total_service_hour DECIMAL(8,2) NOT NULL DEFAULT 0 COMMENT '累计志愿时长，前端 dashboard.jsp 概览卡片和 admin.jsp 志愿者排行展示使用',
  total_activity_count INT NOT NULL DEFAULT 0 COMMENT '累计完成活动数，前端 dashboard.jsp 概览和 admin.jsp 用户统计展示使用',
  ranking_no INT DEFAULT NULL COMMENT '排行名次，前端 admin.jsp topVolunteers 榜单展示使用',
  last_calculate_time DATETIME DEFAULT NULL COMMENT '最后结算时间，后续 admin.jsp 时长管理刷新记录使用',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  CONSTRAINT uk_service_hour_summary UNIQUE (user_id),
  CONSTRAINT fk_service_hour_summary_user_id__ref_volunteer_user FOREIGN KEY (user_id) REFERENCES volunteer_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户志愿时长汇总表：用于 dashboard.jsp 个人累计时长、admin.jsp 志愿者排行、首页总体统计基础数据。';

CREATE TABLE volunteer_service_hour_change (
                                               id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
                                               user_id INT NOT NULL COMMENT '用户ID，关联 volunteer_user.id；说明哪位志愿者的时长发生变更',
                                               activity_id INT DEFAULT NULL COMMENT '活动ID，关联 volunteer_activity.id；前端 dashboard.jsp 时长明细展示来源活动名称使用',
                                               activity_sign_id INT DEFAULT NULL COMMENT '签到记录ID，关联 volunteer_activity_sign.id；用于标记该时长是否来自自动签到',
                                               change_type CHAR(1) NOT NULL COMMENT '变更类型：1增加，2扣减；前端 admin.jsp 时长管理和 dashboard.jsp 明细标签使用',
                                               change_source VARCHAR(30) NOT NULL COMMENT '时长来源：sign_auto签到自动、admin_manual管理员录入、user_apply自主申请；前端 dashboard.jsp 时长来源分布图使用',
                                               change_hour DECIMAL(6,2) NOT NULL COMMENT '变更时长，前端 dashboard.jsp 时长明细数值展示使用',
                                               change_reason VARCHAR(255) NOT NULL COMMENT '变更原因，前端 dashboard.jsp 明细备注、admin.jsp 时长审核说明使用',
                                               operate_user_id INT DEFAULT NULL COMMENT '操作用户ID，关联 volunteer_user.id；前端 admin.jsp 时长管理操作人展示使用',
                                               create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间，对应 dashboard.jsp 时长明细日期展示',
                                               update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                               CONSTRAINT fk_hour_change_user FOREIGN KEY (user_id) REFERENCES volunteer_user(id),
                                               CONSTRAINT fk_hour_change_activity FOREIGN KEY (activity_id) REFERENCES volunteer_activity(id),
                                               CONSTRAINT fk_hour_change_sign FOREIGN KEY (activity_sign_id) REFERENCES volunteer_activity_sign(id),
                                               CONSTRAINT fk_hour_change_operator FOREIGN KEY (operate_user_id) REFERENCES volunteer_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='志愿时长明细表：用于 dashboard.jsp 时长明细和时长来源分布，也用于 admin.jsp 时长管理中的补录、审核、扣减记录展示。';

CREATE TABLE volunteer_home_stat_snapshot (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  stat_code VARCHAR(30) NOT NULL UNIQUE COMMENT '统计编码，如 total_hours、total_users；前端 index.jsp 首页统计卡片读取时可按编码区分',
  stat_label VARCHAR(50) NOT NULL COMMENT '统计标题，前端 index.jsp 首页四个统计卡片标题展示使用',
  stat_value INT NOT NULL COMMENT '统计值，前端 index.jsp 首页统计卡片主数值展示使用',
  stat_suffix VARCHAR(20) DEFAULT NULL COMMENT '统计单位，如 小时、人、场、个；前端 index.jsp 首页统计卡片单位展示使用',
  stat_change_text VARCHAR(100) DEFAULT NULL COMMENT '变化说明，如 ↑ 23% 本月新增；前端 index.jsp 首页统计卡片副文案展示使用',
  color_code VARCHAR(20) DEFAULT NULL COMMENT '配色值，当前对应 data.js stats 中 color 字段',
  snapshot_date DATE NOT NULL COMMENT '快照日期，说明该统计对应哪一天的数据',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='首页统计快照表：用于 index.jsp 首页四个统计卡片展示，让 Navicat 中能直接看到首页统计数据来源。';

CREATE TABLE volunteer_region_stat_snapshot (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  region_id INT NOT NULL COMMENT '区域ID，关联 volunteer_region.id；前端 heatmap.jsp 区域排行和点击区域详情依赖',
  activity_count INT NOT NULL DEFAULT 0 COMMENT '活动数量，前端 heatmap.jsp 区域活跃度排行和区域详情展示使用',
  participant_count INT NOT NULL DEFAULT 0 COMMENT '参与人数，前端 heatmap.jsp 区域详情展示使用',
  total_hours DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT '总服务时长，前端 heatmap.jsp 区域详情展示使用',
  heat_score INT NOT NULL DEFAULT 0 COMMENT '热度分值，前端 heatmap.jsp 热力点大小和排行使用',
  snapshot_date DATE NOT NULL COMMENT '快照日期，说明该统计对应哪一天的数据',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  CONSTRAINT uk_region_stat_snapshot UNIQUE (region_id, snapshot_date),
  CONSTRAINT fk_region_stat_snapshot_region_id__ref_volunteer_region FOREIGN KEY (region_id) REFERENCES volunteer_region(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='区域统计快照表：用于 heatmap.jsp 热力地图区域活跃度排行、点击区域后的活动数/参与人数/总时长展示。';

CREATE TABLE volunteer_category_stat_snapshot (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  tag_id INT NOT NULL COMMENT '标签ID，关联 volunteer_tag.id；说明统计的是哪一类活动',
  activity_count INT NOT NULL DEFAULT 0 COMMENT '活动数量，前端 heatmap.jsp 活动类型分布列表展示使用',
  percent_text VARCHAR(10) NOT NULL COMMENT '占比文本，如 28%；当前直接对应 data.js activityTypes.percent',
  snapshot_date DATE NOT NULL COMMENT '快照日期，说明该统计对应哪一天的数据',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  CONSTRAINT uk_category_stat_snapshot UNIQUE (tag_id, snapshot_date),
  CONSTRAINT fk_category_stat_snapshot_tag_id__ref_volunteer_tag FOREIGN KEY (tag_id) REFERENCES volunteer_tag(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动类型统计快照表：用于 heatmap.jsp 活动类型分布图和右侧类型列表展示。';

CREATE TABLE volunteer_monthly_stat_snapshot (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  stat_month VARCHAR(20) NOT NULL UNIQUE COMMENT '统计月份，如 1月、2月；前端 heatmap.jsp 趋势图横轴展示使用',
  activity_count INT NOT NULL DEFAULT 0 COMMENT '当月活动数量，前端 heatmap.jsp 趋势图使用',
  participant_count INT NOT NULL DEFAULT 0 COMMENT '当月参与人次，前端 heatmap.jsp 趋势图使用',
  total_hours DECIMAL(8,2) NOT NULL DEFAULT 0 COMMENT '当月服务时长，前端 heatmap.jsp 趋势图使用',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='月度趋势快照表：用于 heatmap.jsp 志愿活动趋势图展示每月活动数、参与人次和时长变化。';

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO volunteer_region (id, region_name, parent_region_id, region_level, region_code, center_x, center_y, sort_no) VALUES
(1, '银川市', NULL, 1, '640100', NULL, NULL, 1),
(2, '金凤区', 1, 2, '640106', 51.00, 26.00, 1),
(3, '兴庆区', 1, 2, '640104', 54.00, 24.00, 2),
(4, '西夏区', 1, 2, '640105', 45.00, 20.00, 3),
(5, '贺兰县', 1, 2, '640122', 57.00, 8.00, 4),
(6, '永宁县', 1, 2, '640121', 51.00, 61.00, 5),
(7, '灵武市', 1, 2, '640181', 56.00, 93.00, 6),
(8, '宁东镇', 1, 2, '64018101', 72.00, 82.00, 7)
;

INSERT INTO volunteer_user (
  id, username, password, nickname, phone, email, avatar_url, real_name, gender, birthday,
  region_id, register_source, account_status, role, last_login_time
) VALUES
(1, 'admin', 'admin123', '系统管理员', '17703206273', 'admin@volunteerstar.local', NULL, '系统管理员', 'U', NULL, 2, 'web', '1', '1', '2025-06-21 10:35:00'),
(2, 'testuser', '123456', '测试用户', '13900000000', NULL, 'assets/images/avatar-1.jpg', '李明', 'M', '2003-05-16', 2, 'web', '1', '0', '2025-06-20 18:30:00'),
(3, 'zhangfang', '123456', '张芳', '13900005678', 'zhangfang@example.com', 'assets/images/avatar-2.jpg', '张芳', 'F', '1997-08-10', 2, 'web', '1', '0', '2025-06-19 09:00:00'),
(4, 'wanglei', '123456', '王磊', '13700009012', 'wanglei@example.com', 'assets/images/avatar-3.jpg', '王磊', 'M', '1998-03-20', 3, 'web', '1', '0', '2025-06-19 08:00:00'),
(5, 'zhaowei', '123456', '赵伟', '13600003456', NULL, NULL, '赵伟', 'M', '1999-11-12', 4, 'web', '1', '0', '2025-06-18 20:00:00'),
(6, 'sunli', '123456', '孙丽', '13500007890', NULL, NULL, '孙丽', 'F', '2000-01-01', 5, 'web', '1', '0', '2025-06-18 18:00:00'),
(7, 'liuting', '123456', '刘婷', '13688883456', NULL, NULL, '刘婷', 'F', '2001-02-14', 2, 'web', '1', '0', '2025-06-17 16:00:00'),
(8, 'zhoujie', '123456', '周杰', '13788884567', NULL, NULL, '周杰', 'M', '1998-06-18', 3, 'web', '1', '0', '2025-06-16 14:00:00'),
(9, 'wujing', '123456', '吴静', '13888885678', NULL, NULL, '吴静', 'F', '1999-09-09', 4, 'web', '1', '0', '2025-06-16 10:00:00'),
(10, 'zhenghao', '123456', '郑浩', '13988886789', NULL, NULL, '郑浩', 'M', '1997-12-21', 5, 'web', '1', '0', '2025-06-15 12:00:00'),
(11, 'chenxue', '123456', '陈雪', '15088887890', NULL, NULL, '陈雪', 'F', '2002-04-05', 6, 'web', '1', '0', '2025-06-15 08:20:00'),
(12, 'zhangming', '123456', '张明', '13811111234', NULL, NULL, '张明', 'M', '2000-07-22', 2, 'web', '1', '0', '2025-06-20 10:00:00'),
(13, 'lihua', '123456', '李华', '13911115678', NULL, NULL, '李华', 'F', '2001-09-01', 2, 'web', '1', '0', '2025-06-20 09:00:00'),
(14, 'wangqiang', '123456', '王强', '13711119012', NULL, NULL, '王强', 'M', '1999-12-12', 3, 'web', '1', '0', '2025-06-19 19:00:00'),
(15, 'zhaomin', '123456', '赵敏', '13611113456', NULL, NULL, '赵敏', 'F', '2002-10-03', 4, 'web', '0', '0', '2025-06-14 16:00:00'),
(16, 'suntao', '123456', '孙涛', '13511117890', NULL, NULL, '孙涛', 'M', '1998-01-08', 7, 'web', '1', '0', '2025-06-13 11:00:00');

INSERT INTO volunteer_organization (
  id, region_id, organization_name, organization_type, contact_name, contact_phone, address, description, status
) VALUES
(1, 2, '银川青年志愿者协会', 'social', '张老师', '13800001111', '银川市金凤区文化街 88 号', '面向城市公益活动的综合志愿服务组织。', '1'),
(2, 4, '西夏区文化志愿服务中心', 'community', '李主任', '13800002222', '西夏区文化中心南楼 3 层', '负责文化惠民和社区文化志愿服务。', '1'),
(3, 7, '灵武市儿童关爱服务站', 'social', '王老师', '13800003333', '灵武市福利路 18 号', '聚焦留守儿童和困境儿童陪伴服务。', '1');

INSERT INTO volunteer_tag (id, tag_name, tag_type, color_code, description) VALUES
(1, '社区服务', 'activity_type', '#27AE60', '用于社区敬老、社区关爱类活动'),
(2, '环境保护', 'activity_type', '#2C3E50', '用于环保徒步、绿化养护类活动'),
(3, '教育帮扶', 'activity_type', '#5B9BD5', '用于支教、图书整理、儿童辅导类活动'),
(4, '文明创建', 'activity_type', '#F0C14B', '用于文明交通、城市秩序引导类活动'),
(5, '助残扶弱', 'activity_type', '#E8634B', '用于盲道清理、特殊群体服务类活动'),
(6, '文化惠民', 'activity_type', '#9B7ED9', '用于非遗文化、社区文艺类活动');

INSERT INTO volunteer_activity_status (id, status_code, status_name, sort_no) VALUES
(1, 'recruiting', '招募中', 1),
(2, 'completed', '已完成', 2),
(3, 'pending_review', '待审核', 3),
(4, 'cancelled', '已取消', 4);

INSERT IGNORE INTO volunteer_region (id, region_name, parent_region_id, region_level, region_code, center_x, center_y, sort_no) VALUES
                                                                                                                                    (9, '备用区域9', 1, 2, '640199', NULL, NULL, 8),
                                                                                                                                    (10, '备用区域10', 1, 2, '640200', NULL, NULL, 9);

INSERT IGNORE INTO volunteer_activity (
    id, organization_id, region_id, activity_status_id, publish_user_id, title, activity_type, activity_cover_url,
    description, address, start_time, end_time, sign_in_start_time, sign_out_end_time, recruit_count,
    applied_count, favorite_count, share_count, service_hour, heat_value, publish_time
) VALUES
      (1, 1, 2, 1, 1, '社区敬老志愿服务', '社区服务', 'assets/images/activity-1.jpg', '本次活动旨在服务社区老人，提供陪伴、咨询和秩序维护。', '银川市金凤区老年活动中心', '2025-06-15 09:00:00', '2025-06-15 15:00:00', '2025-06-15 08:30:00', '2025-06-15 15:30:00', 50, 32, 18, 12, 6.00, 92, '2025-06-01 09:00:00'),
      (2, 1, 5, 1, 1, '环保公益徒步活动', '环境保护', 'assets/images/activity-2.jpg', '组织志愿者在贺兰山国家森林公园开展徒步巡护和垃圾清理。', '贺兰山国家森林公园', '2025-06-20 07:30:00', '2025-06-20 12:00:00', '2025-06-20 07:00:00', '2025-06-20 12:30:00', 100, 78, 24, 16, 4.50, 98, '2025-06-02 08:00:00'),
      (3, 1, 2, 1, 1, '爱心图书捐赠整理', '教育帮扶', 'assets/images/activity-3.jpg', '对捐赠图书进行分类、整理和打包，支援乡村学校阅读角建设。', '宁夏大学图书馆', '2025-06-22 14:00:00', '2025-06-22 17:00:00', '2025-06-22 13:30:00', '2025-06-22 17:30:00', 30, 15, 14, 6, 3.00, 76, '2025-06-03 14:00:00'),
      (4, 1, 3, 1, 1, '城市文明交通引导', '文明创建', 'assets/images/activity-4.jpg', '在主干道和学校周边开展文明交通引导与安全宣传。', '银川市主要路口', '2025-06-25 08:00:00', '2025-06-25 10:00:00', '2025-06-25 07:40:00', '2025-06-25 10:20:00', 60, 45, 10, 8, 2.00, 73, '2025-06-05 08:30:00'),
      (5, 1, 3, 1, 1, '盲道清理志愿服务', '助残扶弱', 'assets/images/activity-5.jpg', '清理盲道沿线障碍物并开展文明宣传，改善无障碍出行环境。', '银川市兴庆区盲道沿线', '2025-06-28 09:00:00', '2025-06-28 12:00:00', '2025-06-28 08:30:00', '2025-06-28 12:20:00', 40, 22, 9, 5, 3.00, 68, '2025-06-06 09:00:00'),
      (6, 3, 7, 1, 1, '乡村支教夏令营', '教育帮扶', 'assets/images/activity-6.jpg', '面向乡村儿童开展阅读辅导、科学启蒙与陪伴活动。', '固原市原州区希望小学', '2025-07-01 09:00:00', '2025-07-15 17:00:00', '2025-07-01 08:30:00', '2025-07-15 17:30:00', 20, 8, 20, 9, 8.00, 88, '2025-06-08 10:00:00'),
      (7, 1, 9, 1, 1, '城市公园绿化养护', '环境保护', 'assets/images/activity-7.jpg', '对中山公园绿植开展养护、垃圾分类宣传与巡查。', '银川市中山公园', '2025-07-05 07:00:00', '2025-07-05 12:00:00', '2025-07-05 06:40:00', '2025-07-05 12:20:00', 80, 56, 13, 7, 5.00, 85, '2025-06-10 07:00:00'),
      (8, 2, 10, 1, 1, '非遗文化进社区', '文化惠民', 'assets/images/activity-8.jpg', '邀请非遗传承人走进社区开展体验教学与文化展演。', '西夏区文化中心', '2025-07-08 15:00:00', '2025-07-08 18:00:00', '2025-07-08 14:30:00', '2025-07-08 18:20:00', 50, 29, 17, 11, 3.00, 80, '2025-06-12 15:00:00'),
      (9, 3, 7, 1, 1, '关爱留守儿童心理辅导', '教育帮扶', 'assets/images/activity-9.jpg', '在儿童福利院开展绘画陪伴、情绪疏导和小游戏互动。', '灵武市儿童福利院', '2025-07-10 09:00:00', '2025-07-10 12:00:00', '2025-07-10 08:30:00', '2025-07-10 12:20:00', 25, 11, 19, 10, 3.00, 82, '2025-06-14 09:00:00');

INSERT IGNORE INTO volunteer_activity_enrollment (
    id, activity_id, user_id, enroll_status, enroll_remark, enroll_time, audit_user_id, audit_time, audit_remark, cancel_time
) VALUES
      (1, 1, 2, '1', '我想参与社区服务', '2025-06-10 10:00:00', 1, '2025-06-10 12:00:00', '审核通过', NULL),
      (2, 2, 2, '0', '想参加环保徒步', '2025-06-08 09:00:00', NULL, NULL, NULL, NULL),
      (3, 3, 2, '4', '愿意整理图书', '2025-06-05 14:00:00', 1, '2025-06-05 16:00:00', '审核通过并已完成', NULL),
      (4, 4, 2, '4', '交通引导有经验', '2025-06-01 08:30:00', 1, '2025-06-01 09:00:00', '审核通过并已完成', NULL),
      (5, 5, 2, '3', '临时有事取消', '2025-05-28 10:00:00', 1, '2025-05-28 12:00:00', '已记录取消', '2025-05-29 08:00:00'),
      (6, 2, 12, '0', '刚好周末有空', '2025-06-20 09:00:00', NULL, NULL, NULL, NULL),
      (7, 1, 13, '0', '想服务社区老人', '2025-06-19 15:00:00', NULL, NULL, NULL, NULL),
      (8, 3, 14, '0', '愿意参与图书整理', '2025-06-19 16:00:00', NULL, NULL, NULL, NULL),
      (9, 4, 7, '0', '可以参加路口引导', '2025-06-18 11:00:00', NULL, NULL, NULL, NULL),
      (10, 5, 5, '0', '了解无障碍宣传', '2025-06-18 12:00:00', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO volunteer_activity_sign (
    id, activity_enrollment_id, sign_in_time, sign_out_time, sign_status, service_hour_actual, confirm_user_id, qr_code_token
) VALUES
      (1, 1, '2025-06-15 08:55:00', '2025-06-15 15:02:00', '2', 6.00, 1, 'SIGN-ACT-001'),
      (2, 3, '2025-06-05 13:58:00', '2025-06-05 17:01:00', '2', 3.00, 1, 'SIGN-ACT-003'),
      (3, 4, '2025-06-01 07:58:00', '2025-06-01 10:01:00', '2', 2.00, 1, 'SIGN-ACT-004');

INSERT IGNORE INTO volunteer_service_hour_summary (
    id, user_id, total_service_hour, total_activity_count, ranking_no, last_calculate_time
) VALUES
      (1, 2, 38.00, 12, 2, '2025-06-15 15:10:00'),
      (2, 4, 8.50, 3, 1, '2025-06-15 15:10:00'),
      (3, 3, 6.50, 2, 3, '2025-06-15 15:10:00'),
      (4, 5, 6.00, 2, 4, '2025-06-15 15:10:00'),
      (5, 6, 5.50, 2, 5, '2025-06-15 15:10:00'),
      (6, 7, 5.00, 2, 6, '2025-06-15 15:10:00'),
      (7, 8, 4.50, 2, 7, '2025-06-15 15:10:00'),
      (8, 9, 4.00, 2, 8, '2025-06-15 15:10:00'),
      (9, 10, 3.50, 1, 9, '2025-06-15 15:10:00'),
      (10, 11, 3.00, 1, 10, '2025-06-15 15:10:00'),
      (11, 16, 156.00, 24, NULL, '2025-06-15 15:10:00'),
      (12, 15, 45.00, 8, NULL, '2025-06-15 15:10:00');

INSERT IGNORE INTO volunteer_service_hour_change (
    id, user_id, activity_id, activity_sign_id, change_type, change_source, change_hour, change_reason, operate_user_id, create_time
) VALUES
      (1, 2, 1, 1, '1', 'sign_auto', 6.00, '社区敬老志愿服务签到签退自动结算', 1, '2025-06-15 15:05:00'),
      (2, 2, 2, NULL, '1', 'sign_auto', 4.50, '环保公益徒步活动自动签到结算', 1, '2025-06-10 12:00:00'),
      (3, 2, 3, 2, '1', 'sign_auto', 3.00, '爱心图书捐赠整理自动结算', 1, '2025-06-05 17:05:00'),
      (4, 2, 4, 3, '1', 'sign_auto', 2.00, '城市文明交通引导自动结算', 1, '2025-06-01 10:05:00'),
      (5, 2, NULL, NULL, '1', 'admin_manual', 8.00, '社区新春联欢特别活动补录', 1, '2025-01-20 18:00:00'),
      (6, 2, 3, NULL, '1', 'user_apply', 3.00, '补录申请已通过', 1, '2025-03-15 17:00:00');

INSERT IGNORE INTO volunteer_home_stat_snapshot (
    id, stat_code, stat_label, stat_value, stat_suffix, stat_change_text, color_code, snapshot_date
) VALUES
      (1, 'total_hours', '服务时长累计', 12580, '小时', '↑ 23% 本月新增', '#27AE60', '2025-06-21'),
      (2, 'total_users', '平台注册志愿者', 2847, '人', '↑ 156 本月新增', '#5B9BD5', '2025-06-21'),
      (3, 'total_activities', '累计公益活动', 186, '场', '↑ 12 本月新增', '#F0C14B', '2025-06-21'),
      (4, 'total_communities', '覆盖社区数量', 42, '个', '↑ 5 本月新增', '#E8634B', '2025-06-21');

INSERT IGNORE INTO volunteer_region_stat_snapshot (
    id, region_id, activity_count, participant_count, total_hours, heat_score, snapshot_date
) VALUES
      (1, 2, 68, 2340, 5280.00, 95, '2025-06-21'),
      (2, 3, 52, 1890, 4120.00, 88, '2025-06-21'),
      (3, 4, 35, 980, 2450.00, 76, '2025-06-21'),
      (4, 5, 18, 420, 1080.00, 62, '2025-06-21'),
      (5, 6, 12, 310, 780.00, 55, '2025-06-21'),
      (6, 7, 8, 156, 420.00, 49, '2025-06-21'),
      (7, 8, 5, 89, 260.00, 38, '2025-06-21');

INSERT IGNORE INTO volunteer_category_stat_snapshot (
    id, tag_id, activity_count, percent_text, snapshot_date
) VALUES
      (1, 1, 52, '28%', '2025-06-21'),
      (2, 2, 38, '20%', '2025-06-21'),
      (3, 3, 35, '19%', '2025-06-21'),
      (4, 4, 28, '15%', '2025-06-21'),
      (5, 5, 18, '10%', '2025-06-21'),
      (6, 6, 15, '8%', '2025-06-21');

INSERT IGNORE INTO volunteer_monthly_stat_snapshot (
    id, stat_month, activity_count, participant_count, total_hours
) VALUES
      (1, '1月', 18, 420, 18.00),
      (2, '2月', 25, 680, 24.00),
      (3, '3月', 35, 1020, 32.00),
      (4, '4月', 42, 1340, 45.00),
      (5, '5月', 38, 1180, 38.00),
      (6, '6月', 28, 890, 36.50);

INSERT IGNORE INTO volunteer_activity (
  id, organization_id, region_id, activity_status_id, publish_user_id,
  title, activity_type, activity_cover_url, description,
  address, start_time, end_time, sign_in_start_time, sign_out_end_time,
  recruit_count, applied_count, favorite_count, share_count,
  service_hour, heat_value, publish_time
) VALUES
(10, 1, 3, 1, 1, '盲道清理志愿服务', '社区服务', 'assets/images/activity-1.jpg', '参与盲道清理志愿服务，为社区居民提供贴心服务，共建美好家园。', '银川市兴庆区盲道沿线', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', 20, 6, 0, 0, 3.00, 50, '2026-07-10 10:00:00'),
(11, 1, 2, 1, 1, '社区敬老志愿服务', '社区服务', 'assets/images/activity-2.jpg', '参与社区敬老志愿服务，为社区居民提供贴心服务，共建美好家园。', '银川市金凤区老年活动中心', '2026-07-22 09:00:00', '2026-07-22 09:00:00', '2026-07-22 09:00:00', '2026-07-22 09:00:00', 21, 6, 0, 0, 3.00, 50, '2026-07-17 10:00:00'),
(12, 1, 2, 1, 1, '爱心义诊进社区', '社区服务', 'assets/images/activity-3.jpg', '参与爱心义诊进社区，为社区居民提供贴心服务，共建美好家园。', '银川市金凤区社区服务站', '2026-07-29 09:00:00', '2026-07-29 09:00:00', '2026-07-29 09:00:00', '2026-07-29 09:00:00', 22, 7, 0, 0, 3.00, 50, '2026-07-24 10:00:00'),
(13, 1, 7, 1, 1, '血站义务献血宣传', '社区服务', 'assets/images/activity-1.jpg', '参与血站义务献血宣传，为社区居民提供贴心服务，共建美好家园。', '银川市灵武市体育馆', '2026-08-06 09:00:00', '2026-08-06 09:00:00', '2026-08-06 09:00:00', '2026-08-06 09:00:00', 23, 8, 0, 0, 3.00, 50, '2026-08-01 10:00:00'),
(14, 1, 4, 1, 1, '社区老年人免费理发', '社区服务', 'assets/images/activity-2.jpg', '参与社区老年人免费理发，为社区居民提供贴心服务，共建美好家园。', '银川市西夏区敬老院', '2026-08-13 09:00:00', '2026-08-13 09:00:00', '2026-08-13 09:00:00', '2026-08-13 09:00:00', 25, 9, 0, 0, 3.00, 50, '2026-08-08 10:00:00'),
(15, 1, 2, 1, 1, '爱心衣物捐赠与分发', '社区服务', 'assets/images/activity-3.jpg', '参与爱心衣物捐赠与分发，为社区居民提供贴心服务，共建美好家园。', '银川市金凤区慈善超市', '2026-08-20 09:00:00', '2026-08-20 09:00:00', '2026-08-20 09:00:00', '2026-08-20 09:00:00', 26, 10, 0, 0, 3.00, 50, '2026-08-15 10:00:00'),
(16, 1, 8, 1, 1, '宁东产业工人志愿日', '社区服务', 'assets/images/activity-1.jpg', '参与宁东产业工人志愿日，为社区居民提供贴心服务，共建美好家园。', '银川市宁东镇能源化工基地', '2026-08-28 09:00:00', '2026-08-28 09:00:00', '2026-08-28 09:00:00', '2026-08-28 09:00:00', 27, 11, 0, 0, 3.00, 50, '2026-08-23 10:00:00'),
(17, 1, 4, 1, 1, '社区义诊健康宣传', '社区服务', 'assets/images/activity-2.jpg', '参与社区义诊健康宣传，为社区居民提供贴心服务，共建美好家园。', '银川市西夏区社区卫生服务中心', '2026-09-04 09:00:00', '2026-09-04 09:00:00', '2026-09-04 09:00:00', '2026-09-04 09:00:00', 29, 13, 0, 0, 3.00, 50, '2026-08-30 10:00:00'),
(18, 1, 6, 1, 1, '社区消防安全巡检', '社区服务', 'assets/images/activity-3.jpg', '参与社区消防安全巡检，为社区居民提供贴心服务，共建美好家园。', '银川市永宁县志愿服务站', '2026-09-11 09:00:00', '2026-09-11 09:00:00', '2026-09-11 09:00:00', '2026-09-11 09:00:00', 30, 14, 0, 0, 3.00, 50, '2026-09-06 10:00:00'),
(19, 1, 2, 1, 1, '志愿者景区服务日', '社区服务', 'assets/images/activity-1.jpg', '参与志愿者景区服务日，为社区居民提供贴心服务，共建美好家园。', '银川市金凤区西夏风情园', '2026-09-19 09:00:00', '2026-09-19 09:00:00', '2026-09-19 09:00:00', '2026-09-19 09:00:00', 31, 15, 0, 0, 3.00, 50, '2026-09-14 10:00:00'),
(20, 1, 5, 1, 1, '冬季送温暖行动', '社区服务', 'assets/images/activity-2.jpg', '参与冬季送温暖行动，为社区居民提供贴心服务，共建美好家园。', '银川市贺兰县社区服务站', '2026-09-26 09:00:00', '2026-09-26 09:00:00', '2026-09-26 09:00:00', '2026-09-26 09:00:00', 33, 17, 0, 0, 3.00, 50, '2026-09-21 10:00:00'),
(21, 1, 2, 1, 1, '社区紧急救护培训', '社区服务', 'assets/images/activity-3.jpg', '参与社区紧急救护培训，为社区居民提供贴心服务，共建美好家园。', '银川市金凤区红十字会培训基地', '2026-10-03 09:00:00', '2026-10-03 09:00:00', '2026-10-03 09:00:00', '2026-10-03 09:00:00', 34, 18, 0, 0, 3.00, 50, '2026-09-28 10:00:00'),
(22, 1, 8, 1, 1, '公益法律咨询服务', '社区服务', 'assets/images/activity-1.jpg', '参与公益法律咨询服务，为社区居民提供贴心服务，共建美好家园。', '银川市宁东镇街道办', '2026-10-11 09:00:00', '2026-10-11 09:00:00', '2026-10-11 09:00:00', '2026-10-11 09:00:00', 35, 19, 0, 0, 3.00, 50, '2026-10-06 10:00:00'),
(23, 1, 6, 1, 1, '社区家电义务维修', '社区服务', 'assets/images/activity-2.jpg', '参与社区家电义务维修，为社区居民提供贴心服务，共建美好家园。', '银川市永宁县图书馆', '2026-10-18 09:00:00', '2026-10-18 09:00:00', '2026-10-18 09:00:00', '2026-10-18 09:00:00', 36, 20, 0, 0, 3.00, 50, '2026-10-13 10:00:00'),
(24, 1, 2, 1, 1, '春运志愿暖冬行动', '社区服务', 'assets/images/activity-3.jpg', '参与春运志愿暖冬行动，为社区居民提供贴心服务，共建美好家园。', '银川市金凤区志愿服务站', '2026-10-25 09:00:00', '2026-10-25 09:00:00', '2026-10-25 09:00:00', '2026-10-25 09:00:00', 38, 22, 0, 0, 3.00, 50, '2026-10-20 10:00:00'),
(25, 1, 6, 1, 1, '农村留守老人关爱', '社区服务', 'assets/images/activity-1.jpg', '参与农村留守老人关爱，为社区居民提供贴心服务，共建美好家园。', '银川市永宁县学校操场', '2026-11-02 09:00:00', '2026-11-02 09:00:00', '2026-11-02 09:00:00', '2026-11-02 09:00:00', 39, 24, 0, 0, 3.00, 50, '2026-10-28 10:00:00'),
(26, 1, 4, 1, 1, '社区楼道杂物清理', '社区服务', 'assets/images/activity-2.jpg', '参与社区楼道杂物清理，为社区居民提供贴心服务，共建美好家园。', '银川市西夏区图书馆', '2026-11-09 09:00:00', '2026-11-09 09:00:00', '2026-11-09 09:00:00', '2026-11-09 09:00:00', 40, 25, 0, 0, 3.00, 50, '2026-11-04 10:00:00'),
(27, 1, 7, 1, 1, '爱心义诊进社区', '社区服务', 'assets/images/activity-3.jpg', '参与爱心义诊进社区，为社区居民提供贴心服务，共建美好家园。', '银川市灵武市人民路社区', '2026-11-16 09:00:00', '2026-11-16 09:00:00', '2026-11-16 09:00:00', '2026-11-16 09:00:00', 42, 28, 0, 0, 3.00, 50, '2026-11-11 10:00:00'),
(28, 1, 7, 1, 1, '社区养老服务需求调研', '社区服务', 'assets/images/activity-1.jpg', '参与社区养老服务需求调研，为社区居民提供贴心服务，共建美好家园。', '银川市灵武市老年活动中心', '2026-11-24 09:00:00', '2026-11-24 09:00:00', '2026-11-24 09:00:00', '2026-11-24 09:00:00', 43, 29, 0, 0, 3.00, 50, '2026-11-19 10:00:00'),
(29, 1, 2, 1, 1, '社区防诈骗宣传活动', '社区服务', 'assets/images/activity-2.jpg', '参与社区防诈骗宣传活动，为社区居民提供贴心服务，共建美好家园。', '银川市金凤区万达广场', '2026-12-01 09:00:00', '2026-12-01 09:00:00', '2026-12-01 09:00:00', '2026-12-01 09:00:00', 44, 31, 0, 0, 3.00, 50, '2026-11-26 10:00:00'),
(30, 1, 3, 1, 1, '孤寡老人暖心陪伴', '社区服务', 'assets/images/activity-3.jpg', '参与孤寡老人暖心陪伴，为社区居民提供贴心服务，共建美好家园。', '银川市兴庆区社区服务站', '2026-12-08 09:00:00', '2026-12-08 09:00:00', '2026-12-08 09:00:00', '2026-12-08 09:00:00', 46, 33, 0, 0, 3.00, 50, '2026-12-03 10:00:00'),
(31, 1, 6, 1, 1, '老年人健康检查志愿行', '社区服务', 'assets/images/activity-1.jpg', '参与老年人健康检查志愿行，为社区居民提供贴心服务，共建美好家园。', '银川市永宁县各社区卫生站', '2026-12-16 09:00:00', '2026-12-16 09:00:00', '2026-12-16 09:00:00', '2026-12-16 09:00:00', 47, 35, 0, 0, 3.00, 50, '2026-12-11 10:00:00'),
(32, 1, 4, 1, 1, '社区疫苗志愿协助', '社区服务', 'assets/images/activity-2.jpg', '参与社区疫苗志愿协助，为社区居民提供贴心服务，共建美好家园。', '银川市西夏区方舱接种点', '2026-12-23 09:00:00', '2026-12-23 09:00:00', '2026-12-23 09:00:00', '2026-12-23 09:00:00', 48, 37, 0, 0, 3.00, 50, '2026-12-18 10:00:00'),
(33, 1, 7, 1, 1, '盐池环境保护行动', '环境保护', 'assets/images/activity-4.jpg', '参与盐池环境保护行动，用行动守护绿水青山，共建生态文明。', '银川市灵武市盐池景区', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', 30, 9, 0, 0, 3.00, 50, '2026-07-10 10:00:00'),
(34, 1, 7, 1, 1, '湿地候鸟监测保护', '环境保护', 'assets/images/activity-5.jpg', '参与湿地候鸟监测保护，用行动守护绿水青山，共建生态文明。', '银川市灵武市公园北门', '2026-07-22 09:00:00', '2026-07-22 09:00:00', '2026-07-22 09:00:00', '2026-07-22 09:00:00', 32, 10, 0, 0, 3.00, 50, '2026-07-17 10:00:00'),
(35, 1, 7, 1, 1, '大湖环保志愿行', '环境保护', 'assets/images/activity-6.jpg', '参与大湖环保志愿行，用行动守护绿水青山，共建生态文明。', '银川市灵武市学校操场', '2026-07-30 09:00:00', '2026-07-30 09:00:00', '2026-07-30 09:00:00', '2026-07-30 09:00:00', 34, 11, 0, 0, 3.00, 50, '2026-07-25 10:00:00'),
(36, 1, 2, 1, 1, '活动废弃物回收日', '环境保护', 'assets/images/activity-4.jpg', '参与活动废弃物回收日，用行动守护绿水青山，共建生态文明。', '银川市金凤区各社区回收点', '2026-08-07 09:00:00', '2026-08-07 09:00:00', '2026-08-07 09:00:00', '2026-08-07 09:00:00', 36, 13, 0, 0, 3.00, 50, '2026-08-02 10:00:00'),
(37, 1, 4, 1, 1, '废旧电池回收日', '环境保护', 'assets/images/activity-5.jpg', '参与废旧电池回收日，用行动守护绿水青山，共建生态文明。', '银川市西夏区市民广场', '2026-08-14 09:00:00', '2026-08-14 09:00:00', '2026-08-14 09:00:00', '2026-08-14 09:00:00', 39, 15, 0, 0, 3.00, 50, '2026-08-09 10:00:00'),
(38, 1, 6, 1, 1, '黄河湿地保护行动', '环境保护', 'assets/images/activity-6.jpg', '参与黄河湿地保护行动，用行动守护绿水青山，共建生态文明。', '银川市永宁县黄河湿地公园', '2026-08-22 09:00:00', '2026-08-22 09:00:00', '2026-08-22 09:00:00', '2026-08-22 09:00:00', 41, 16, 0, 0, 3.00, 50, '2026-08-17 10:00:00'),
(39, 1, 2, 1, 1, '湖泊志愿清洁行动', '环境保护', 'assets/images/activity-4.jpg', '参与湖泊志愿清洁行动，用行动守护绿水青山，共建生态文明。', '银川市金凤区典农河沿岸', '2026-08-30 09:00:00', '2026-08-30 09:00:00', '2026-08-30 09:00:00', '2026-08-30 09:00:00', 43, 18, 0, 0, 3.00, 50, '2026-08-25 10:00:00'),
(40, 1, 5, 1, 1, '贺兰山生态修复植树', '环境保护', 'assets/images/activity-5.jpg', '参与贺兰山生态修复植树，用行动守护绿水青山，共建生态文明。', '银川市贺兰县贺兰山沿线', '2026-09-06 09:00:00', '2026-09-06 09:00:00', '2026-09-06 09:00:00', '2026-09-06 09:00:00', 45, 20, 0, 0, 3.00, 50, '2026-09-01 10:00:00'),
(41, 1, 5, 1, 1, '贺兰山防火巡查', '环境保护', 'assets/images/activity-6.jpg', '参与贺兰山防火巡查，用行动守护绿水青山，共建生态文明。', '银川市贺兰县公园北门', '2026-09-14 09:00:00', '2026-09-14 09:00:00', '2026-09-14 09:00:00', '2026-09-14 09:00:00', 48, 23, 0, 0, 3.00, 50, '2026-09-09 10:00:00'),
(42, 1, 8, 1, 1, '宁东工业园区绿植', '环境保护', 'assets/images/activity-4.jpg', '参与宁东工业园区绿植，用行动守护绿水青山，共建生态文明。', '银川市宁东镇学校操场', '2026-09-22 09:00:00', '2026-09-22 09:00:00', '2026-09-22 09:00:00', '2026-09-22 09:00:00', 50, 25, 0, 0, 3.00, 50, '2026-09-17 10:00:00'),
(43, 1, 2, 1, 1, '禁塑环保志愿宣传', '环境保护', 'assets/images/activity-5.jpg', '参与禁塑环保志愿宣传，用行动守护绿水青山，共建生态文明。', '银川市金凤区村委会广场', '2026-09-29 09:00:00', '2026-09-29 09:00:00', '2026-09-29 09:00:00', '2026-09-29 09:00:00', 52, 27, 0, 0, 3.00, 50, '2026-09-24 10:00:00'),
(44, 1, 2, 1, 1, '湖泊水质监测行动', '环境保护', 'assets/images/activity-6.jpg', '参与湖泊水质监测行动，用行动守护绿水青山，共建生态文明。', '银川市金凤区体育馆', '2026-10-07 09:00:00', '2026-10-07 09:00:00', '2026-10-07 09:00:00', '2026-10-07 09:00:00', 55, 30, 0, 0, 3.00, 50, '2026-10-02 10:00:00'),
(45, 1, 2, 1, 1, '社区垃圾分类宣传日', '环境保护', 'assets/images/activity-4.jpg', '参与社区垃圾分类宣传日，用行动守护绿水青山，共建生态文明。', '银川市金凤区垃圾分类站', '2026-10-15 09:00:00', '2026-10-15 09:00:00', '2026-10-15 09:00:00', '2026-10-15 09:00:00', 57, 32, 0, 0, 3.00, 50, '2026-10-10 10:00:00'),
(46, 1, 8, 1, 1, '企业垃圾分类培训', '环境保护', 'assets/images/activity-5.jpg', '参与企业垃圾分类培训，用行动守护绿水青山，共建生态文明。', '银川市宁东镇湿地保护区', '2026-10-22 09:00:00', '2026-10-22 09:00:00', '2026-10-22 09:00:00', '2026-10-22 09:00:00', 59, 35, 0, 0, 3.00, 50, '2026-10-17 10:00:00'),
(47, 1, 7, 1, 1, '黄河岸边植绿护绿', '环境保护', 'assets/images/activity-6.jpg', '参与黄河岸边植绿护绿，用行动守护绿水青山，共建生态文明。', '银川市灵武市生态园', '2026-10-30 09:00:00', '2026-10-30 09:00:00', '2026-10-30 09:00:00', '2026-10-30 09:00:00', 61, 37, 0, 0, 3.00, 50, '2026-10-25 10:00:00'),
(48, 1, 4, 1, 1, '城市公园绿化养护', '环境保护', 'assets/images/activity-4.jpg', '参与城市公园绿化养护，用行动守护绿水青山，共建生态文明。', '银川市西夏区中山公园', '2026-11-07 09:00:00', '2026-11-07 09:00:00', '2026-11-07 09:00:00', '2026-11-07 09:00:00', 64, 41, 0, 0, 3.00, 50, '2026-11-02 10:00:00'),
(49, 1, 2, 1, 1, '社区绿化角落认养计划', '环境保护', 'assets/images/activity-5.jpg', '参与社区绿化角落认养计划，用行动守护绿水青山，共建生态文明。', '银川市金凤区各社区绿化带', '2026-11-14 09:00:00', '2026-11-14 09:00:00', '2026-11-14 09:00:00', '2026-11-14 09:00:00', 66, 43, 0, 0, 3.00, 50, '2026-11-09 10:00:00'),
(50, 1, 3, 1, 1, '城市河道垃圾打捞', '环境保护', 'assets/images/activity-6.jpg', '参与城市河道垃圾打捞，用行动守护绿水青山，共建生态文明。', '银川市兴庆区商业街广场', '2026-11-22 09:00:00', '2026-11-22 09:00:00', '2026-11-22 09:00:00', '2026-11-22 09:00:00', 68, 46, 0, 0, 3.00, 50, '2026-11-17 10:00:00'),
(51, 1, 2, 1, 1, '绿色出行骑行宣传', '环境保护', 'assets/images/activity-4.jpg', '参与绿色出行骑行宣传，用行动守护绿水青山，共建生态文明。', '银川市金凤区北京中路', '2026-11-30 09:00:00', '2026-11-30 09:00:00', '2026-11-30 09:00:00', '2026-11-30 09:00:00', 70, 49, 0, 0, 3.00, 50, '2026-11-25 10:00:00'),
(52, 1, 4, 1, 1, '社区共享花园建设', '环境保护', 'assets/images/activity-5.jpg', '参与社区共享花园建设，用行动守护绿水青山，共建生态文明。', '银川市西夏区生态园', '2026-12-07 09:00:00', '2026-12-07 09:00:00', '2026-12-07 09:00:00', '2026-12-07 09:00:00', 73, 53, 0, 0, 3.00, 50, '2026-12-02 10:00:00'),
(53, 1, 5, 1, 1, '环保科普进社区讲座', '环境保护', 'assets/images/activity-6.jpg', '参与环保科普进社区讲座，用行动守护绿水青山，共建生态文明。', '银川市贺兰县社区中心', '2026-12-15 09:00:00', '2026-12-15 09:00:00', '2026-12-15 09:00:00', '2026-12-15 09:00:00', 75, 56, 0, 0, 3.00, 50, '2026-12-10 10:00:00'),
(54, 1, 5, 1, 1, '贺兰山徒步清扫', '环境保护', 'assets/images/activity-4.jpg', '参与贺兰山徒步清扫，用行动守护绿水青山，共建生态文明。', '银川市贺兰县市民广场', '2026-12-23 09:00:00', '2026-12-23 09:00:00', '2026-12-23 09:00:00', '2026-12-23 09:00:00', 77, 59, 0, 0, 3.00, 50, '2026-12-18 10:00:00'),
(55, 1, 4, 1, 1, '暑期托管志愿服务班', '教育帮扶', 'assets/images/activity-7.jpg', '参与暑期托管志愿服务班，用知识传递希望，助力成长梦想。', '银川市西夏区青少年活动中心', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', 15, 4, 0, 0, 3.00, 50, '2026-07-10 10:00:00'),
(56, 1, 8, 1, 1, '宁东工人子女托管', '教育帮扶', 'assets/images/activity-8.jpg', '参与宁东工人子女托管，用知识传递希望，助力成长梦想。', '银川市宁东镇工业园区', '2026-07-24 09:00:00', '2026-07-24 09:00:00', '2026-07-24 09:00:00', '2026-07-24 09:00:00', 16, 5, 0, 0, 3.00, 50, '2026-07-19 10:00:00'),
(57, 1, 5, 1, 1, '图书流动车下乡村', '教育帮扶', 'assets/images/activity-9.jpg', '参与图书流动车下乡村，用知识传递希望，助力成长梦想。', '银川市贺兰县各乡镇小学', '2026-08-02 09:00:00', '2026-08-02 09:00:00', '2026-08-02 09:00:00', '2026-08-02 09:00:00', 17, 6, 0, 0, 3.00, 50, '2026-07-28 10:00:00'),
(58, 1, 2, 1, 1, '助老智能手机培训', '教育帮扶', 'assets/images/activity-7.jpg', '参与助老智能手机培训，用知识传递希望，助力成长梦想。', '银川市金凤区社区活动室', '2026-08-12 09:00:00', '2026-08-12 09:00:00', '2026-08-12 09:00:00', '2026-08-12 09:00:00', 19, 7, 0, 0, 3.00, 50, '2026-08-07 10:00:00'),
(59, 1, 2, 1, 1, '青少年读书分享会', '教育帮扶', 'assets/images/activity-8.jpg', '参与青少年读书分享会，用知识传递希望，助力成长梦想。', '银川市金凤区市图书馆', '2026-08-21 09:00:00', '2026-08-21 09:00:00', '2026-08-21 09:00:00', '2026-08-21 09:00:00', 20, 8, 0, 0, 3.00, 50, '2026-08-16 10:00:00'),
(60, 1, 2, 1, 1, '青少年科技体验营', '教育帮扶', 'assets/images/activity-9.jpg', '参与青少年科技体验营，用知识传递希望，助力成长梦想。', '银川市金凤区科技馆', '2026-08-30 09:00:00', '2026-08-30 09:00:00', '2026-08-30 09:00:00', '2026-08-30 09:00:00', 21, 9, 0, 0, 3.00, 50, '2026-08-25 10:00:00'),
(61, 1, 7, 1, 1, '校园反欺凌志愿宣讲', '教育帮扶', 'assets/images/activity-7.jpg', '参与校园反欺凌志愿宣讲，用知识传递希望，助力成长梦想。', '银川市灵武市第二中学', '2026-09-09 09:00:00', '2026-09-09 09:00:00', '2026-09-09 09:00:00', '2026-09-09 09:00:00', 23, 10, 0, 0, 3.00, 50, '2026-09-04 10:00:00'),
(62, 1, 2, 1, 1, '幼童绘本阅读辅导', '教育帮扶', 'assets/images/activity-8.jpg', '参与幼童绘本阅读辅导，用知识传递希望，助力成长梦想。', '银川市金凤区图书馆', '2026-09-18 09:00:00', '2026-09-18 09:00:00', '2026-09-18 09:00:00', '2026-09-18 09:00:00', 24, 11, 0, 0, 3.00, 50, '2026-09-13 10:00:00'),
(63, 1, 5, 1, 1, '中小学科普讲座', '教育帮扶', 'assets/images/activity-9.jpg', '参与中小学科普讲座，用知识传递希望，助力成长梦想。', '银川市贺兰县商业街广场', '2026-09-28 09:00:00', '2026-09-28 09:00:00', '2026-09-28 09:00:00', '2026-09-28 09:00:00', 26, 13, 0, 0, 3.00, 50, '2026-09-23 10:00:00'),
(64, 1, 3, 1, 1, '社区儿童安全教育', '教育帮扶', 'assets/images/activity-7.jpg', '参与社区儿童安全教育，用知识传递希望，助力成长梦想。', '银川市兴庆区儿童之家', '2026-10-07 09:00:00', '2026-10-07 09:00:00', '2026-10-07 09:00:00', '2026-10-07 09:00:00', 27, 14, 0, 0, 3.00, 50, '2026-10-02 10:00:00'),
(65, 1, 7, 1, 1, '老年人智能机教学', '教育帮扶', 'assets/images/activity-8.jpg', '参与老年人智能机教学，用知识传递希望，助力成长梦想。', '银川市灵武市农贸市场', '2026-10-16 09:00:00', '2026-10-16 09:00:00', '2026-10-16 09:00:00', '2026-10-16 09:00:00', 28, 16, 0, 0, 3.00, 50, '2026-10-11 10:00:00'),
(66, 1, 3, 1, 1, '流动儿童课后辅导', '教育帮扶', 'assets/images/activity-9.jpg', '参与流动儿童课后辅导，用知识传递希望，助力成长梦想。', '银川市兴庆区外来务工子女学校', '2026-10-26 09:00:00', '2026-10-26 09:00:00', '2026-10-26 09:00:00', '2026-10-26 09:00:00', 30, 18, 0, 0, 3.00, 50, '2026-10-21 10:00:00'),
(67, 1, 1, 1, 1, '乡村支教夏令营', '教育帮扶', 'assets/images/activity-7.jpg', '参与乡村支教夏令营，用知识传递希望，助力成长梦想。', '固原市原州区希望小学', '2026-11-04 09:00:00', '2026-11-04 09:00:00', '2026-11-04 09:00:00', '2026-11-04 09:00:00', 31, 19, 0, 0, 3.00, 50, '2026-10-30 10:00:00'),
(68, 1, 2, 1, 1, '爱心图书捐赠整理', '教育帮扶', 'assets/images/activity-8.jpg', '参与爱心图书捐赠整理，用知识传递希望，助力成长梦想。', '宁夏大学图书馆', '2026-11-14 09:00:00', '2026-11-14 09:00:00', '2026-11-14 09:00:00', '2026-11-14 09:00:00', 33, 21, 0, 0, 3.00, 50, '2026-11-09 10:00:00'),
(69, 1, 5, 1, 1, '大学生支教乡村行', '教育帮扶', 'assets/images/activity-9.jpg', '参与大学生支教乡村行，用知识传递希望，助力成长梦想。', '银川市贺兰县村委会广场', '2026-11-23 09:00:00', '2026-11-23 09:00:00', '2026-11-23 09:00:00', '2026-11-23 09:00:00', 34, 23, 0, 0, 3.00, 50, '2026-11-18 10:00:00'),
(70, 1, 2, 1, 1, '少儿编程公益课堂', '教育帮扶', 'assets/images/activity-7.jpg', '参与少儿编程公益课堂，用知识传递希望，助力成长梦想。', '银川市金凤区街道办', '2026-12-02 09:00:00', '2026-12-02 09:00:00', '2026-12-02 09:00:00', '2026-12-02 09:00:00', 35, 25, 0, 0, 3.00, 50, '2026-11-27 10:00:00'),
(71, 1, 4, 1, 1, '外语角志愿教学', '教育帮扶', 'assets/images/activity-8.jpg', '参与外语角志愿教学，用知识传递希望，助力成长梦想。', '银川市西夏区工业园区', '2026-12-12 09:00:00', '2026-12-12 09:00:00', '2026-12-12 09:00:00', '2026-12-12 09:00:00', 37, 27, 0, 0, 3.00, 50, '2026-12-07 10:00:00'),
(72, 1, 7, 1, 1, '关爱留守儿童心理辅导', '教育帮扶', 'assets/images/activity-9.jpg', '参与关爱留守儿童心理辅导，用知识传递希望，助力成长梦想。', '灵武市儿童福利院', '2026-12-21 09:00:00', '2026-12-21 09:00:00', '2026-12-21 09:00:00', '2026-12-21 09:00:00', 38, 29, 0, 0, 3.00, 50, '2026-12-16 10:00:00'),
(73, 1, 4, 1, 1, '文明餐桌志愿推广', '文明创建', 'assets/images/activity-1.jpg', '参与文明餐桌志愿推广，传播文明理念，共建和谐社会。', '银川市西夏区大学城美食街', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', 20, 6, 0, 0, 3.00, 50, '2026-07-10 10:00:00'),
(74, 1, 6, 1, 1, '社区文明公约宣传', '文明创建', 'assets/images/activity-2.jpg', '参与社区文明公约宣传，传播文明理念，共建和谐社会。', '银川市永宁县志愿服务站', '2026-07-27 09:00:00', '2026-07-27 09:00:00', '2026-07-27 09:00:00', '2026-07-27 09:00:00', 21, 7, 0, 0, 3.00, 50, '2026-07-22 10:00:00'),
(75, 1, 4, 1, 1, '文明交通劝导行动', '文明创建', 'assets/images/activity-3.jpg', '参与文明交通劝导行动，传播文明理念，共建和谐社会。', '银川市西夏区志愿服务站', '2026-08-08 09:00:00', '2026-08-08 09:00:00', '2026-08-08 09:00:00', '2026-08-08 09:00:00', 23, 8, 0, 0, 3.00, 50, '2026-08-03 10:00:00'),
(76, 1, 2, 1, 1, '文明养宠志愿宣传', '文明创建', 'assets/images/activity-1.jpg', '参与文明养宠志愿宣传，传播文明理念，共建和谐社会。', '银川市金凤区宝湖公园', '2026-08-20 09:00:00', '2026-08-20 09:00:00', '2026-08-20 09:00:00', '2026-08-20 09:00:00', 25, 10, 0, 0, 3.00, 50, '2026-08-15 10:00:00'),
(77, 1, 4, 1, 1, '文明养宠宣传周', '文明创建', 'assets/images/activity-2.jpg', '参与文明养宠宣传周，传播文明理念，共建和谐社会。', '银川市西夏区农贸市场', '2026-09-01 09:00:00', '2026-09-01 09:00:00', '2026-09-01 09:00:00', '2026-09-01 09:00:00', 27, 11, 0, 0, 3.00, 50, '2026-08-27 10:00:00'),
(78, 1, 3, 1, 1, '社区墙体彩绘活动', '文明创建', 'assets/images/activity-3.jpg', '参与社区墙体彩绘活动，传播文明理念，共建和谐社会。', '银川市兴庆区文明社区小巷', '2026-09-13 09:00:00', '2026-09-13 09:00:00', '2026-09-13 09:00:00', '2026-09-13 09:00:00', 28, 13, 0, 0, 3.00, 50, '2026-09-08 10:00:00'),
(79, 1, 2, 1, 1, '热力地图数据采集志愿行', '文明创建', 'assets/images/activity-1.jpg', '参与热力地图数据采集志愿行，传播文明理念，共建和谐社会。', '银川市各区域社区服务站', '2026-09-25 09:00:00', '2026-09-25 09:00:00', '2026-09-25 09:00:00', '2026-09-25 09:00:00', 30, 15, 0, 0, 3.00, 50, '2026-09-20 10:00:00'),
(80, 1, 6, 1, 1, '社区安全隐患排查', '文明创建', 'assets/images/activity-2.jpg', '参与社区安全隐患排查，传播文明理念，共建和谐社会。', '银川市永宁县望远社区', '2026-10-07 09:00:00', '2026-10-07 09:00:00', '2026-10-07 09:00:00', '2026-10-07 09:00:00', 32, 17, 0, 0, 3.00, 50, '2026-10-02 10:00:00'),
(81, 1, 2, 1, 1, '车窗抛物文明劝导', '文明创建', 'assets/images/activity-3.jpg', '参与车窗抛物文明劝导，传播文明理念，共建和谐社会。', '银川市金凤区图书馆', '2026-10-19 09:00:00', '2026-10-19 09:00:00', '2026-10-19 09:00:00', '2026-10-19 09:00:00', 34, 19, 0, 0, 3.00, 50, '2026-10-14 10:00:00'),
(82, 1, 4, 1, 1, '城市小广告清除日', '文明创建', 'assets/images/activity-1.jpg', '参与城市小广告清除日，传播文明理念，共建和谐社会。', '银川市西夏区老年活动中心', '2026-10-31 09:00:00', '2026-10-31 09:00:00', '2026-10-31 09:00:00', '2026-10-31 09:00:00', 36, 22, 0, 0, 3.00, 50, '2026-10-26 10:00:00'),
(83, 1, 8, 1, 1, '宁东夜市文明督导', '文明创建', 'assets/images/activity-2.jpg', '参与宁东夜市文明督导，传播文明理念，共建和谐社会。', '银川市宁东镇文化中心', '2026-11-12 09:00:00', '2026-11-12 09:00:00', '2026-11-12 09:00:00', '2026-11-12 09:00:00', 37, 24, 0, 0, 3.00, 50, '2026-11-07 10:00:00'),
(84, 1, 4, 1, 1, '农贸市场文明管理', '文明创建', 'assets/images/activity-3.jpg', '参与农贸市场文明管理，传播文明理念，共建和谐社会。', '银川市西夏区老年活动中心', '2026-11-24 09:00:00', '2026-11-24 09:00:00', '2026-11-24 09:00:00', '2026-11-24 09:00:00', 39, 27, 0, 0, 3.00, 50, '2026-11-19 10:00:00'),
(85, 1, 3, 1, 1, '城市文明交通劝导', '文明创建', 'assets/images/activity-1.jpg', '参与城市文明交通劝导，传播文明理念，共建和谐社会。', '银川市兴庆区主要路口', '2026-12-06 09:00:00', '2026-12-06 09:00:00', '2026-12-06 09:00:00', '2026-12-06 09:00:00', 41, 29, 0, 0, 3.00, 50, '2026-12-01 10:00:00'),
(86, 1, 3, 1, 1, '公共区域烟头清零', '文明创建', 'assets/images/activity-2.jpg', '参与公共区域烟头清零，传播文明理念，共建和谐社会。', '银川市兴庆区社区服务站', '2026-12-18 09:00:00', '2026-12-18 09:00:00', '2026-12-18 09:00:00', '2026-12-18 09:00:00', 43, 32, 0, 0, 3.00, 50, '2026-12-13 10:00:00'),
(87, 1, 2, 1, 1, '助残手工艺品义卖', '助残扶弱', 'assets/images/activity-4.jpg', '参与助残手工艺品义卖，传递关爱温暖，共建包容社会。', '银川市金凤区村委会广场', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', 10, 3, 0, 0, 3.00, 50, '2026-07-10 10:00:00'),
(88, 1, 8, 1, 1, '听障人士手语翻译', '助残扶弱', 'assets/images/activity-5.jpg', '参与听障人士手语翻译，传递关爱温暖，共建包容社会。', '银川市宁东镇公园北门', '2026-08-02 09:00:00', '2026-08-02 09:00:00', '2026-08-02 09:00:00', '2026-08-02 09:00:00', 12, 4, 0, 0, 3.00, 50, '2026-07-28 10:00:00'),
(89, 1, 3, 1, 1, '盲人阅读陪伴计划', '助残扶弱', 'assets/images/activity-6.jpg', '参与盲人阅读陪伴计划，传递关爱温暖，共建包容社会。', '银川市兴庆区体育馆', '2026-08-21 09:00:00', '2026-08-21 09:00:00', '2026-08-21 09:00:00', '2026-08-21 09:00:00', 14, 5, 0, 0, 3.00, 50, '2026-08-16 10:00:00'),
(90, 1, 5, 1, 1, '康复辅助免费租赁', '助残扶弱', 'assets/images/activity-4.jpg', '参与康复辅助免费租赁，传递关爱温暖，共建包容社会。', '银川市贺兰县市民广场', '2026-09-09 09:00:00', '2026-09-09 09:00:00', '2026-09-09 09:00:00', '2026-09-09 09:00:00', 16, 7, 0, 0, 3.00, 50, '2026-09-04 10:00:00'),
(91, 1, 2, 1, 1, '残疾人就业技能培训', '助残扶弱', 'assets/images/activity-5.jpg', '参与残疾人就业技能培训，传递关爱温暖，共建包容社会。', '银川市金凤区残联培训中心', '2026-09-28 09:00:00', '2026-09-28 09:00:00', '2026-09-28 09:00:00', '2026-09-28 09:00:00', 18, 9, 0, 0, 3.00, 50, '2026-09-23 10:00:00'),
(92, 1, 4, 1, 1, '助残日爱心义卖', '助残扶弱', 'assets/images/activity-6.jpg', '参与助残日爱心义卖，传递关爱温暖，共建包容社会。', '银川市西夏区步行街', '2026-10-16 09:00:00', '2026-10-16 09:00:00', '2026-10-16 09:00:00', '2026-10-16 09:00:00', 21, 12, 0, 0, 3.00, 50, '2026-10-11 10:00:00'),
(93, 1, 6, 1, 1, '残障人士康复陪伴', '助残扶弱', 'assets/images/activity-4.jpg', '参与残障人士康复陪伴，传递关爱温暖，共建包容社会。', '银川市永宁县公园北门', '2026-11-04 09:00:00', '2026-11-04 09:00:00', '2026-11-04 09:00:00', '2026-11-04 09:00:00', 23, 14, 0, 0, 3.00, 50, '2026-10-30 10:00:00'),
(94, 1, 5, 1, 1, '轮椅出行无障碍日', '助残扶弱', 'assets/images/activity-5.jpg', '参与轮椅出行无障碍日，传递关爱温暖，共建包容社会。', '银川市贺兰县学校操场', '2026-11-23 09:00:00', '2026-11-23 09:00:00', '2026-11-23 09:00:00', '2026-11-23 09:00:00', 25, 17, 0, 0, 3.00, 50, '2026-11-18 10:00:00'),
(95, 1, 2, 1, 1, '盲人图书馆志愿者', '助残扶弱', 'assets/images/activity-6.jpg', '参与盲人图书馆志愿者，传递关爱温暖，共建包容社会。', '银川市金凤区视障者服务中心', '2026-12-12 09:00:00', '2026-12-12 09:00:00', '2026-12-12 09:00:00', '2026-12-12 09:00:00', 27, 20, 0, 0, 3.00, 50, '2026-12-07 10:00:00'),
(96, 1, 8, 1, 1, '古建筑保护志愿行', '文化惠民', 'assets/images/activity-7.jpg', '参与古建筑保护志愿行，传承文化薪火，丰富群众生活。', '银川市宁东镇湿地保护区', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', 25, 7, 0, 0, 3.00, 50, '2026-07-10 10:00:00'),
(97, 1, 4, 1, 1, '重阳敬老文化演出', '文化惠民', 'assets/images/activity-8.jpg', '参与重阳敬老文化演出，传承文化薪火，丰富群众生活。', '银川市西夏区老年大学', '2026-07-28 09:00:00', '2026-07-28 09:00:00', '2026-07-28 09:00:00', '2026-07-28 09:00:00', 27, 9, 0, 0, 3.00, 50, '2026-07-23 10:00:00'),
(98, 1, 6, 1, 1, '新年春联送万家', '文化惠民', 'assets/images/activity-9.jpg', '参与新年春联送万家，传承文化薪火，丰富群众生活。', '银川市永宁县文化中心', '2026-08-10 09:00:00', '2026-08-10 09:00:00', '2026-08-10 09:00:00', '2026-08-10 09:00:00', 30, 11, 0, 0, 3.00, 50, '2026-08-05 10:00:00'),
(99, 1, 2, 1, 1, '社区书画艺术展', '文化惠民', 'assets/images/activity-7.jpg', '参与社区书画艺术展，传承文化薪火，丰富群众生活。', '银川市金凤区市民广场', '2026-08-23 09:00:00', '2026-08-23 09:00:00', '2026-08-23 09:00:00', '2026-08-23 09:00:00', 33, 13, 0, 0, 3.00, 50, '2026-08-18 10:00:00'),
(100, 1, 3, 1, 1, '中秋节社区联欢志愿者', '文化惠民', 'assets/images/activity-8.jpg', '参与中秋节社区联欢志愿者，传承文化薪火，丰富群众生活。', '银川市兴庆区社区文化广场', '2026-09-05 09:00:00', '2026-09-05 09:00:00', '2026-09-05 09:00:00', '2026-09-05 09:00:00', 35, 15, 0, 0, 3.00, 50, '2026-08-31 10:00:00'),
(101, 1, 2, 1, 1, '周末公益电影放映', '文化惠民', 'assets/images/activity-9.jpg', '参与周末公益电影放映，传承文化薪火，丰富群众生活。', '银川市金凤区街道办', '2026-09-18 09:00:00', '2026-09-18 09:00:00', '2026-09-18 09:00:00', '2026-09-18 09:00:00', 38, 18, 0, 0, 3.00, 50, '2026-09-13 10:00:00'),
(102, 1, 6, 1, 1, '传统戏曲进乡村', '文化惠民', 'assets/images/activity-7.jpg', '参与传统戏曲进乡村，传承文化薪火，丰富群众生活。', '银川市永宁县湿地保护区', '2026-10-01 09:00:00', '2026-10-01 09:00:00', '2026-10-01 09:00:00', '2026-10-01 09:00:00', 41, 21, 0, 0, 3.00, 50, '2026-09-26 10:00:00'),
(103, 1, 3, 1, 1, '社区美食节志愿服务', '文化惠民', 'assets/images/activity-8.jpg', '参与社区美食节志愿服务，传承文化薪火，丰富群众生活。', '银川市兴庆区社区广场', '2026-10-14 09:00:00', '2026-10-14 09:00:00', '2026-10-14 09:00:00', '2026-10-14 09:00:00', 43, 24, 0, 0, 3.00, 50, '2026-10-09 10:00:00'),
(104, 1, 3, 1, 1, '非遗文化传承体验', '文化惠民', 'assets/images/activity-9.jpg', '参与非遗文化传承体验，传承文化薪火，丰富群众生活。', '银川市兴庆区商业街广场', '2026-10-27 09:00:00', '2026-10-27 09:00:00', '2026-10-27 09:00:00', '2026-10-27 09:00:00', 46, 27, 0, 0, 3.00, 50, '2026-10-22 10:00:00'),
(105, 1, 7, 1, 1, '社区读书分享会', '文化惠民', 'assets/images/activity-7.jpg', '参与社区读书分享会，传承文化薪火，丰富群众生活。', '银川市灵武市农贸市场', '2026-11-09 09:00:00', '2026-11-09 09:00:00', '2026-11-09 09:00:00', '2026-11-09 09:00:00', 49, 31, 0, 0, 3.00, 50, '2026-11-04 10:00:00'),
(106, 1, 4, 1, 1, '非遗文化进社区', '文化惠民', 'assets/images/activity-8.jpg', '参与非遗文化进社区，传承文化薪火，丰富群众生活。', '西夏区文化中心', '2026-11-22 09:00:00', '2026-11-22 09:00:00', '2026-11-22 09:00:00', '2026-11-22 09:00:00', 51, 34, 0, 0, 3.00, 50, '2026-11-17 10:00:00'),
(107, 1, 6, 1, 1, '乡村文化大院巡演', '文化惠民', 'assets/images/activity-9.jpg', '参与乡村文化大院巡演，传承文化薪火，丰富群众生活。', '银川市永宁县湿地保护区', '2026-12-05 09:00:00', '2026-12-05 09:00:00', '2026-12-05 09:00:00', '2026-12-05 09:00:00', 54, 39, 0, 0, 3.00, 50, '2026-11-30 10:00:00'),
(108, 1, 2, 1, 1, '迎春文艺汇演', '文化惠民', 'assets/images/activity-7.jpg', '参与迎春文艺汇演，传承文化薪火，丰富群众生活。', '银川市金凤区街道办', '2026-12-18 09:00:00', '2026-12-18 09:00:00', '2026-12-18 09:00:00', '2026-12-18 09:00:00', 57, 43, 0, 0, 3.00, 50, '2026-12-13 10:00:00');

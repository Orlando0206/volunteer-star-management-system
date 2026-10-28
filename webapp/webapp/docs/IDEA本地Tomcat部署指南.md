S# IDEA 本地 Tomcat 部署指南

## 1. 环境准备

- JDK：建议 `JDK 17`
- Maven：IDEA 自带 Maven 即可
- Tomcat：建议 `Tomcat 11`
- MySQL：建议 `MySQL 8.x`

## 2. 导入项目

1. 打开 IDEA
2. 选择 `Open`
3. 选中项目目录：
   `C:\Users\30631\Desktop\作业\web0528\webapp(1)\webapp`
4. 等待 IDEA 识别为 Maven 项目并下载依赖

## 3. 创建数据库

1. 打开 MySQL
2. 执行文件：
   `sql/volunteer_star.sql`
3. 确认数据库名为：
   `volunteer_star`

## 4. 检查数据库连接配置

配置文件位置：

`src/main/resources/jdbc.properties`

当前配置为：

```properties
driverClassName=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/volunteer_star?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=UTF-8
username=root
password=3377515aA.
```

如果你的 MySQL 端口、用户名或密码不同，就改这里。

注意：

- 这个项目现在已经适配 `Tomcat 11`
- 所以 IDEA 里请优先使用 `JDK 17 + Tomcat 11`

## 5. 配置 Tomcat

1. IDEA 顶部选择 `Run` -> `Edit Configurations`
2. 点击左上角 `+`
3. 选择 `Tomcat Server` -> `Local`
4. 在 `Application Server` 里选择你的本地 Tomcat
5. 如果还没配置，就点 `Configure...` 指向 Tomcat 安装目录

## 6. 配置 Deployment

1. 打开刚创建的 Tomcat 运行配置
2. 切到 `Deployment`
3. 点击右侧 `+`
4. 选择 `Artifact`
5. 选择：
   `volunteer-star:war exploded`
6. `Application context` 建议填写：
   `/volunteer-star`

最终访问地址一般是：

[http://localhost:8080/volunteer-star/login.jsp](http://localhost:8080/volunteer-star/login.jsp)

## 7. 启动项目

1. 先启动 MySQL
2. 再启动 Tomcat
3. 浏览器打开：
   [http://localhost:8080/volunteer-star/login.jsp](http://localhost:8080/volunteer-star/login.jsp)

## 8. 测试账号

可以直接用 SQL 里内置的测试账号：

- 管理员
  - 用户名：`admin`
  - 密码：`admin123`
- 普通用户
  - 用户名：`testuser`
  - 密码：`123456`

也可以直接在注册页面新建账号。

说明：

- 当前版本按你的要求，数据库密码保存为明文
- 如果你重新执行 `sql/volunteer_star.sql`，测试账号密码会直接按 SQL 中的明文值生效

## 9. 当前已实现功能

- 登录
- 注册
- 登录拦截
- 退出登录
- JSP 页面整体迁移
- MyBatis 连接 MySQL

## 10. 当前未实现功能

下面这些页面目前是前端展示，后端业务暂未接入：

- 活动报名
- 活动管理
- 用户管理
- 时长管理
- 审核管理
- 图表数据落库

## 11. 常见问题排查

### 11.1 页面能打开但样式丢失

检查：

- 是否通过 Tomcat 访问，而不是直接双击文件
- `Application context` 是否是 `/volunteer-star`
- 浏览器地址是否带了正确项目名

### 11.2 启动时报数据库连接失败

检查：

- MySQL 是否启动
- `jdbc.properties` 用户名密码是否正确
- `volunteer_star` 数据库是否创建成功

### 11.3 登录后又跳回登录页

检查：

- Tomcat 是否正常支持 Session
- 浏览器是否禁用了 Cookie
- 是否访问的是项目真实路径，例如：
  [http://localhost:8080/volunteer-star/index.jsp](http://localhost:8080/volunteer-star/index.jsp)

### 11.4 Maven 依赖下载失败

可以在 IDEA 的 Maven 面板里点击刷新，或者执行：

```powershell
mvn clean package
```

## 12. 项目主要结构

```text
src
├─ main
│  ├─ java
│  │  └─ com.volunteerstar
│  │     ├─ controller
│  │     ├─ filter
│  │     ├─ listener
│  │     ├─ mapper
│  │     ├─ pojo
│  │     ├─ service
│  │     └─ utils
│  ├─ resources
│  │  ├─ mapper
│  │  ├─ jdbc.properties
│  │  └─ mybatis-config.xml
│  └─ webapp
│     ├─ assets
│     ├─ WEB-INF
│     ├─ login.jsp
│     ├─ index.jsp
│     ├─ activities.jsp
│     ├─ heatmap.jsp
│     ├─ dashboard.jsp
│     ├─ discover.jsp
│     ├─ timeline3d.jsp
│     └─ admin.jsp
sql
└─ volunteer_star.sql
docs
└─ IDEA本地Tomcat部署指南.md
```

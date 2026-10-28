<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>数据库初始化 - 志愿星河</title>
    <style>
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 40px; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
        h1 { color: #27AE60; margin-top: 0; }
        .success { color: #27AE60; padding: 10px; background: #f0f9f0; border-radius: 6px; margin: 10px 0; }
        .error { color: #E8634B; padding: 10px; background: #fdf0ee; border-radius: 6px; margin: 10px 0; }
        .info { color: #2C3E50; padding: 10px; background: #f0f2f5; border-radius: 6px; margin: 10px 0; }
        pre { background: #2C3E50; color: #fff; padding: 15px; border-radius: 6px; overflow-x: auto; }
        .back-link { display: inline-block; margin-top: 20px; color: #27AE60; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h1>数据库表初始化</h1>
<%
    String driver = application.getInitParameter("driverClassName");
    String url = application.getInitParameter("url");
    String username = application.getInitParameter("username");
    String password = application.getInitParameter("password");

    if (driver == null) {
        driver = "com.mysql.cj.jdbc.Driver";
        url = "jdbc:mysql://localhost:3306/volunteer_star?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=UTF-8";
        username = "root";
        password = "3377515aA.";
    }

    String[] createTableSQLs = {
        // 签到签退表
        "CREATE TABLE IF NOT EXISTS volunteer_activity_sign (" +
        "  id INT PRIMARY KEY AUTO_INCREMENT," +
        "  activity_enrollment_id INT NOT NULL," +
        "  sign_in_time DATETIME DEFAULT NULL," +
        "  sign_out_time DATETIME DEFAULT NULL," +
        "  sign_status CHAR(1) NOT NULL DEFAULT '0'," +
        "  service_hour_actual DECIMAL(6,2) NOT NULL DEFAULT 0," +
        "  confirm_user_id INT DEFAULT NULL," +
        "  qr_code_token VARCHAR(64) DEFAULT NULL," +
        "  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
        "  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
        "  CONSTRAINT uk_activity_sign UNIQUE (activity_enrollment_id)" +
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",

        // 时长汇总表
        "CREATE TABLE IF NOT EXISTS volunteer_service_hour_summary (" +
        "  id INT PRIMARY KEY AUTO_INCREMENT," +
        "  user_id INT NOT NULL," +
        "  total_service_hour DECIMAL(8,2) NOT NULL DEFAULT 0," +
        "  total_activity_count INT NOT NULL DEFAULT 0," +
        "  ranking_no INT DEFAULT NULL," +
        "  last_calculate_time DATETIME DEFAULT NULL," +
        "  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
        "  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
        "  CONSTRAINT uk_service_hour_summary UNIQUE (user_id)" +
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",

        // 时长明细表
        "CREATE TABLE IF NOT EXISTS volunteer_service_hour_change (" +
        "  id INT PRIMARY KEY AUTO_INCREMENT," +
        "  user_id INT NOT NULL," +
        "  activity_id INT DEFAULT NULL," +
        "  activity_sign_id INT DEFAULT NULL," +
        "  change_type CHAR(1) NOT NULL," +
        "  change_source VARCHAR(30) NOT NULL," +
        "  change_hour DECIMAL(6,2) NOT NULL," +
        "  change_reason VARCHAR(255) NOT NULL," +
        "  operate_user_id INT DEFAULT NULL," +
        "  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
        "  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    };

    String[] tableNames = {
        "volunteer_activity_sign",
        "volunteer_service_hour_summary",
        "volunteer_service_hour_change"
    };

    Connection conn = null;
    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);
        out.println("<div class='success'>✓ 数据库连接成功</div>");

        for (int i = 0; i < createTableSQLs.length; i++) {
            Statement stmt = null;
            try {
                stmt = conn.createStatement();
                stmt.execute(createTableSQLs[i]);
                out.println("<div class='success'>✓ 表 " + tableNames[i] + " 创建成功（或已存在）</div>");
            } catch (SQLException e) {
                out.println("<div class='error'>✗ 表 " + tableNames[i] + " 创建失败：" + e.getMessage() + "</div>");
            } finally {
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            }
        }

        // 检查已有的报名记录，为已通过的记录补充签到记录
        out.println("<div class='info'>正在检查是否需要为已有报名记录补充签到记录...</div>");
        Statement checkStmt = conn.createStatement();
        ResultSet rs = checkStmt.executeQuery(
            "SELECT e.id FROM volunteer_activity_enrollment e " +
            "LEFT JOIN volunteer_activity_sign s ON s.activity_enrollment_id = e.id " +
            "WHERE e.enroll_status = '1' AND s.id IS NULL"
        );

        int count = 0;
        while (rs.next()) {
            int enrollId = rs.getInt("id");
            Statement insertStmt = conn.createStatement();
            insertStmt.execute(
                "INSERT IGNORE INTO volunteer_activity_sign (activity_enrollment_id, sign_status, service_hour_actual) " +
                "VALUES (" + enrollId + ", '0', 0)"
            );
            insertStmt.close();
            count++;
        }
        rs.close();
        checkStmt.close();

        if (count > 0) {
            out.println("<div class='success'>✓ 已为 " + count + " 条已通过的报名记录补充了签到记录</div>");
        } else {
            out.println("<div class='info'>无需补充，所有已通过的报名记录都已有签到记录</div>");
        }

        out.println("<h3 style='margin-top:30px;'>初始化完成！</h3>");
        out.println("<p>所有必要的数据表已创建完成，现在你可以使用以下新功能：</p>");
        out.println("<ul>");
        out.println("<li>管理员审核报名后自动创建签到记录</li>");
        out.println("<li>管理员可以签到、签退</li>");
        out.println("<li>签退后自动计算志愿时长</li>");
        out.println("<li>个人中心 - 概览显示真实累计时长</li>");
        out.println("<li>个人中心 - 时长明细显示真实时长记录</li>");
        out.println("</ul>");

    } catch (Exception e) {
        out.println("<div class='error'>数据库连接或操作失败：" + e.getMessage() + "</div>");
        out.println("<div class='info'>请检查数据库配置，或手动执行以下 SQL 语句：</div>");
        out.println("<pre>");
        for (String sql : createTableSQLs) {
            out.println(sql + ";\n");
        }
        out.println("</pre>");
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
    <a href="<%= request.getContextPath() %>/dashboard.jsp" class="back-link">← 返回个人中心</a>
</div>
</body>
</html>

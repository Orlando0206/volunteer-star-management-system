<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.time.LocalDate, java.time.LocalDateTime, java.time.LocalTime, java.time.format.DateTimeFormatter, java.util.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>批量导入志愿活动</title>
    <style>
        body { font-family: "Microsoft YaHei", Arial, sans-serif; margin: 40px; background: #f5f6fa; }
        .container { max-width: 960px; margin: 0 auto; background: #fff; padding: 30px 40px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        h1 { text-align: center; color: #333; margin-bottom: 10px; }
        .subtitle { text-align: center; color: #888; margin-bottom: 30px; font-size: 14px; }
        .stats { display: flex; gap: 20px; margin-bottom: 25px; }
        .stat-card { flex: 1; text-align: center; padding: 18px; border-radius: 6px; font-size: 15px; }
        .stat-card.success { background: #e8f5e9; color: #2e7d32; }
        .stat-card.skip { background: #fff3e0; color: #ef6c00; }
        .stat-card.fail { background: #ffebee; color: #c62828; }
        .stat-card .num { font-size: 32px; font-weight: bold; display: block; margin-bottom: 4px; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; margin-top: 10px; }
        th, td { padding: 8px 10px; border: 1px solid #e0e0e0; text-align: left; }
        th { background: #f8f9fa; color: #555; font-weight: 600; }
        tr:nth-child(even) { background: #fafafa; }
        .status-success { color: #2e7d32; font-weight: bold; }
        .status-skip { color: #ef6c00; font-weight: bold; }
        .status-fail { color: #c62828; font-weight: bold; }
        .btn { display: inline-block; padding: 10px 28px; background: #4a90d9; color: #fff; text-decoration: none; border-radius: 4px; font-size: 14px; border: none; cursor: pointer; }
        .btn:hover { background: #357abd; }
        .actions { text-align: center; margin-top: 25px; }
    </style>
</head>
<body>
<div class="container">
    <h1>批量导入志愿活动</h1>
    <p class="subtitle">数据来源：Excel 截图提取（共 99 条记录）</p>

<%
    // 数据库连接信息（请根据实际环境修改）
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPass = application.getInitParameter("dbPass");

    // 若 web.xml 未配置，使用默认值
    if (dbUrl == null || dbUrl.isEmpty()) {
        dbUrl = "jdbc:mysql://localhost:3306/volunteer_star?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=UTF-8";
    }
    if (dbUser == null || dbUser.isEmpty()) {
        dbUser = "root";
    }
    if (dbPass == null) {
        dbPass = "3377515aA.";
    }

    // 类别定义
    class CategoryDef {
        String name;
        String template;
        int recruitMin, recruitMax;
        String[] images;
        CategoryDef(String name, String template, int recruitMin, int recruitMax, String[] images) {
            this.name = name;
            this.template = template;
            this.recruitMin = recruitMin;
            this.recruitMax = recruitMax;
            this.images = images;
        }
    }

    CategoryDef[] categories = new CategoryDef[] {
        new CategoryDef("社区服务", "参与%s，为社区居民提供贴心服务，共建美好家园。", 20, 50,
            new String[]{"activity-1.jpg","activity-2.jpg","activity-3.jpg"}),
        new CategoryDef("环境保护", "参与%s，用行动守护绿水青山，共建生态文明。", 30, 80,
            new String[]{"activity-4.jpg","activity-5.jpg","activity-6.jpg"}),
        new CategoryDef("教育帮扶", "参与%s，用知识传递希望，助力成长梦想。", 15, 40,
            new String[]{"activity-7.jpg","activity-8.jpg","activity-9.jpg"}),
        new CategoryDef("文明创建", "参与%s，传播文明理念，共建和谐社会。", 20, 45,
            new String[]{"activity-1.jpg","activity-2.jpg","activity-3.jpg"}),
        new CategoryDef("助残扶弱", "参与%s，传递关爱温暖，共建包容社会。", 10, 30,
            new String[]{"activity-4.jpg","activity-5.jpg","activity-6.jpg"}),
        new CategoryDef("文化惠民", "参与%s，传承文化薪火，丰富群众生活。", 25, 60,
            new String[]{"activity-7.jpg","activity-8.jpg","activity-9.jpg"})
    };

    // 活动数据：[类别索引, 标题, 地址, 经度, 纬度]
    String[][] rawActivities = new String[][] {
        // 社区服务类（23个）
        {"0","盲道清理志愿服务","银川市兴庆区盲道沿线","106.285","38.469"},
        {"0","社区敬老志愿服务","银川市金凤区老年活动中心","106.24","38.478"},
        {"0","爱心义诊进社区","银川市金凤区社区服务站","106.242","38.475"},
        {"0","血站义务献血宣传","银川市灵武市体育馆","106.34","38.102"},
        {"0","社区老年人免费理发","银川市西夏区敬老院","106.158","38.497"},
        {"0","爱心衣物捐赠与分发","银川市金凤区慈善超市","106.242","38.475"},
        {"0","宁东产业工人志愿日","银川市宁东镇能源化工基地","106.598","38.158"},
        {"0","社区义诊健康宣传","银川市西夏区社区卫生服务中心","106.16","38.494"},
        {"0","社区消防安全巡检","银川市永宁县志愿服务站","106.255","38.272"},
        {"0","志愿者景区服务日","银川市金凤区西夏风情园","106.22","38.488"},
        {"0","冬季送温暖行动","银川市贺兰县社区服务站","106.325","38.56"},
        {"0","社区紧急救护培训","银川市金凤区红十字会培训基地","106.243","38.479"},
        {"0","公益法律咨询服务","银川市宁东镇街道办","106.56","38.15"},
        {"0","社区家电义务维修","银川市永宁县图书馆","106.255","38.272"},
        {"0","春运志愿暖冬行动","银川市金凤区志愿服务站","106.242","38.475"},
        {"0","农村留守老人关爱","银川市永宁县学校操场","106.255","38.272"},
        {"0","社区楼道杂物清理","银川市西夏区图书馆","106.152","38.495"},
        {"0","爱心义诊进社区","银川市灵武市人民路社区","106.29","38.47"},
        {"0","社区养老服务需求调研","银川市灵武市老年活动中心","106.34","38.102"},
        {"0","社区防诈骗宣传活动","银川市金凤区万达广场","106.248","38.477"},
        {"0","孤寡老人暖心陪伴","银川市兴庆区社区服务站","106.29","38.47"},
        {"0","老年人健康检查志愿行","银川市永宁县各社区卫生站","106.275","38.254"},
        {"0","社区疫苗志愿协助","银川市西夏区方舱接种点","106.157","38.491"},
        // 环境保护类（22个）
        {"1","盐池环境保护行动","银川市灵武市盐池景区","106.345","38.105"},
        {"1","湿地候鸟监测保护","银川市灵武市公园北门","106.34","38.102"},
        {"1","大湖环保志愿行","银川市灵武市学校操场","106.34","38.102"},
        {"1","活动废弃物回收日","银川市金凤区各社区回收点","106.246","38.481"},
        {"1","废旧电池回收日","银川市西夏区市民广场","106.152","38.495"},
        {"1","黄河湿地保护行动","银川市永宁县黄河湿地公园","106.258","38.27"},
        {"1","湖泊志愿清洁行动","银川市金凤区典农河沿岸","106.25","38.482"},
        {"1","贺兰山生态修复植树","银川市贺兰县贺兰山沿线","106.32","38.565"},
        {"1","贺兰山防火巡查","银川市贺兰县公园北门","106.325","38.56"},
        {"1","宁东工业园区绿植","银川市宁东镇学校操场","106.56","38.15"},
        {"1","禁塑环保志愿宣传","银川市金凤区村委会广场","106.242","38.475"},
        {"1","湖泊水质监测行动","银川市金凤区体育馆","106.242","38.475"},
        {"1","社区垃圾分类宣传日","银川市金凤区垃圾分类站","106.235","38.485"},
        {"1","企业垃圾分类培训","银川市宁东镇湿地保护区","106.56","38.15"},
        {"1","黄河岸边植绿护绿","银川市灵武市生态园","106.34","38.102"},
        {"1","城市公园绿化养护","银川市西夏区中山公园","106.162","38.498"},
        {"1","社区绿化角落认养计划","银川市金凤区各社区绿化带","106.238","38.473"},
        {"1","城市河道垃圾打捞","银川市兴庆区商业街广场","106.29","38.47"},
        {"1","绿色出行骑行宣传","银川市金凤区北京中路","106.249","38.475"},
        {"1","社区共享花园建设","银川市西夏区生态园","106.152","38.495"},
        {"1","环保科普进社区讲座","银川市贺兰县社区中心","106.348","38.552"},
        {"1","贺兰山徒步清扫","银川市贺兰县市民广场","106.325","38.56"},
        // 教育帮扶类（18个）
        {"2","暑期托管志愿服务班","银川市西夏区青少年活动中心","106.163","38.496"},
        {"2","宁东工人子女托管","银川市宁东镇工业园区","106.56","38.15"},
        {"2","图书流动车下乡村","银川市贺兰县各乡镇小学","106.345","38.558"},
        {"2","助老智能手机培训","银川市金凤区社区活动室","106.245","38.481"},
        {"2","青少年读书分享会","银川市金凤区市图书馆","106.242","38.474"},
        {"2","青少年科技体验营","银川市金凤区科技馆","106.239","38.478"},
        {"2","校园反欺凌志愿宣讲","银川市灵武市第二中学","106.338","38.098"},
        {"2","孤童绘本阅读辅导","银川市金凤区图书馆","106.242","38.475"},
        {"2","中小学科普讲座","银川市贺兰县商业街广场","106.325","38.56"},
        {"2","社区儿童安全教育","银川市兴庆区儿童之家","106.288","38.472"},
        {"2","老年人智能机教学","银川市灵武市农贸市场","106.34","38.102"},
        {"2","流动儿童课后辅导","银川市兴庆区外来务工子女学校","106.293","38.464"},
        {"2","乡村支教夏令营","固原市原州区希望小学","106.28","38.56"},
        {"2","爱心图书捐赠整理","宁夏大学图书馆","106.155","38.5"},
        {"2","大学生支教乡村行","银川市贺兰县村委会广场","106.325","38.56"},
        {"2","少儿编程公益课堂","银川市金凤区街道办","106.242","38.475"},
        {"2","外语角志愿教学","银川市西夏区工业园区","106.152","38.495"},
        {"2","关爱留守儿童心理辅导","灵武市儿童福利院","106.335","38.1"},
        // 文明创建类（14个）
        {"3","文明餐桌志愿推广","银川市西夏区大学城美食街","106.148","38.5"},
        {"3","社区文明公约宣传","银川市永宁县志愿服务站","106.255","38.272"},
        {"3","文明交通劝导行动","银川市西夏区志愿服务站","106.152","38.495"},
        {"3","文明养宠志愿宣传","银川市金凤区宝湖公园","106.23","38.472"},
        {"3","文明养宠宣传周","银川市西夏区农贸市场","106.152","38.495"},
        {"3","社区墙体彩绘活动","银川市兴庆区文明社区小巷","106.28","38.466"},
        {"3","热力地图数据采集志愿行","银川市各区域社区服务站","106.27","38.46"},
        {"3","社区安全隐患排查","银川市永宁县望远社区","106.256","38.28"},
        {"3","车窗抛物物文明劝导","银川市金凤区图书馆","106.242","38.475"},
        {"3","城市小广告清除日","银川市西夏区老年活动中心","106.152","38.495"},
        {"3","宁东夜市文明督导","银川市宁东镇文化中心","106.56","38.15"},
        {"3","农贸市场文明管理","银川市西夏区老年活动中心","106.152","38.495"},
        {"3","城市文明交通劝导","银川市兴庆区主要路口","106.29","38.472"},
        {"3","公共区域烟头清零","银川市兴庆区社区服务站","106.29","38.47"},
        // 助残扶弱类（9个）
        {"4","助残手工艺品义卖","银川市金凤区村委会广场","106.242","38.475"},
        {"4","听障人士手语翻译","银川市宁东镇公园北门","106.56","38.15"},
        {"4","盲人阅读陪伴计划","银川市兴庆区体育馆","106.29","38.47"},
        {"4","康复辅助免费租赁","银川市贺兰县市民广场","106.325","38.56"},
        {"4","残疾人就业技能培训","银川市金凤区残联培训中心","106.236","38.476"},
        {"4","助残日爱心义卖","银川市西夏区步行街","106.152","38.493"},
        {"4","残障人士康复陪伴","银川市永宁县公园北门","106.255","38.272"},
        {"4","轮椅出行无障碍日","银川市贺兰县学校操场","106.325","38.56"},
        {"4","盲人图书馆志愿者","银川市金凤区视障者服务中心","106.241","38.48"},
        // 文化惠民类（13个）
        {"5","古建筑保护志愿行","银川市宁东镇湿地保护区","106.56","38.15"},
        {"5","重阳敬老文化演出","银川市西夏区老年大学","106.154","38.498"},
        {"5","新年春联送万家","银川市永宁县文化中心","106.255","38.272"},
        {"5","社区书画艺术展","银川市金凤区市民广场","106.242","38.475"},
        {"5","中秋节社区联欢志愿者","银川市兴庆区社区文化广场","106.292","38.468"},
        {"5","周末公益电影放映","银川市金凤区街道办","106.242","38.475"},
        {"5","传统戏曲进乡村","银川市永宁县湿地保护区","106.255","38.272"},
        {"5","社区美食节志愿服务","银川市兴庆区社区广场","106.295","38.465"},
        {"5","非遗文化传承体验","银川市兴庆区商业街广场","106.29","38.47"},
        {"5","社区读书分享会","银川市灵武市农贸市场","106.34","38.102"},
        {"5","非遗文化进社区","西夏区文化中心","106.15","38.493"},
        {"5","乡村文化大院巡演","银川市永宁县湿地保护区","106.255","38.272"},
        {"5","迎春文艺汇演","银川市金凤区街道办","106.242","38.475"}
    };

    // 统计计数
    int successCount = 0;
    int skipCount = 0;
    int failCount = 0;

    // 结果列表：[标题, 类别, 日期, 状态, 信息]
    List<String[]> results = new ArrayList<>();

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    Random rand = new Random(42); // 固定种子保证可复现

    LocalDate startDate = LocalDate.of(2026, 7, 15);
    LocalDate endDate = LocalDate.of(2026, 12, 31);
    long totalDays = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate);

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // 准备 INSERT IGNORE 语句（id 自增，由数据库生成）
        String sql = "INSERT IGNORE INTO volunteer_activity (" +
            "organization_id, region_id, activity_status_id, publish_user_id, " +
            "title, activity_type, activity_cover_url, description, " +
            "address, start_time, end_time, sign_in_start_time, sign_out_end_time, " +
            "recruit_count, applied_count, favorite_count, share_count, " +
            "service_hour, heat_value, publish_time, longitude, latitude" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?)";
        ps = conn.prepareStatement(sql);

        // 按类别分组计数（用于均匀分布日期）
        int[] catIndices = new int[categories.length];
        int[] catCounts = new int[categories.length];
        for (String[] act : rawActivities) {
            catCounts[Integer.parseInt(act[0])]++;
        }

        for (String[] act : rawActivities) {
            int catIdx = Integer.parseInt(act[0]);
            CategoryDef cat = categories[catIdx];
            String title = act[1];
            String address = act[2];
            double lng = Double.parseDouble(act[3]);
            double lat = Double.parseDouble(act[4]);

            // 生成日期：在类别内均匀分布
            int idxInCat = catIndices[catIdx]++;
            int countInCat = catCounts[catIdx];
            long dayOffset;
            if (countInCat <= 1) {
                dayOffset = 0;
            } else {
                dayOffset = Math.round((double) totalDays * idxInCat / (countInCat - 1));
            }
            LocalDate actDate = startDate.plusDays(dayOffset);
            LocalDateTime dateTime = LocalDateTime.of(actDate, LocalTime.of(9, 0, 0));
            String timeStr = dateTime.format(dtf);

            // 简介
            String description = String.format(cat.template, title);

            // 配图
            String coverUrl = cat.images[idxInCat % cat.images.length];

            // 招募人数
            int recruitCount = cat.recruitMin + rand.nextInt(cat.recruitMax - cat.recruitMin + 1);
            // applied_count 为招募人数的 30%-80%
            int appliedCount = (int) Math.round(recruitCount * (0.30 + rand.nextDouble() * 0.50));

            ps.setInt(1, 1);          // organization_id
            ps.setInt(2, 2);          // region_id
            ps.setInt(3, 1);          // activity_status_id
            ps.setInt(4, 1);          // publish_user_id
            ps.setString(5, title);   // title
            ps.setString(6, cat.name); // activity_type
            ps.setString(7, coverUrl); // activity_cover_url
            ps.setString(8, description); // description
            ps.setString(9, address); // address
            ps.setString(10, timeStr); // start_time
            ps.setString(11, timeStr); // end_time
            ps.setString(12, timeStr); // sign_in_start_time
            ps.setString(13, timeStr); // sign_out_end_time
            ps.setInt(14, recruitCount); // recruit_count
            ps.setInt(15, appliedCount); // applied_count
            ps.setInt(16, 0);         // favorite_count
            ps.setInt(17, 0);         // share_count
            ps.setBigDecimal(18, new java.math.BigDecimal("3.00")); // service_hour
            ps.setInt(19, 50);        // heat_value
            ps.setDouble(20, lng);    // longitude
            ps.setDouble(21, lat);    // latitude

            int affected = ps.executeUpdate();
            if (affected > 0) {
                successCount++;
                results.add(new String[]{title, cat.name, timeStr, "成功", "已插入"});
            } else {
                skipCount++;
                results.add(new String[]{title, cat.name, timeStr, "跳过", "记录已存在"});
            }
        }
    } catch (Exception e) {
        failCount++;
        results.add(new String[]{"-", "-", "-", "失败", e.getMessage()});
        out.println("<p style='color:red;'>导入过程中发生错误：" + e.getMessage() + "</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

    <div class="stats">
        <div class="stat-card success">
            <span class="num"><%= successCount %></span>
            导入成功
        </div>
        <div class="stat-card skip">
            <span class="num"><%= skipCount %></span>
            跳过（已存在）
        </div>
        <div class="stat-card fail">
            <span class="num"><%= failCount %></span>
            导入失败
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width:5%">序号</th>
                <th style="width:22%">活动名称</th>
                <th style="width:10%">类别</th>
                <th style="width:16%">活动时间</th>
                <th style="width:8%">状态</th>
                <th style="width:12%">说明</th>
            </tr>
        </thead>
        <tbody>
        <% for (int i = 0; i < results.size(); i++) {
            String[] r = results.get(i);
            String statusClass = "status-skip";
            if ("成功".equals(r[3])) statusClass = "status-success";
            else if ("失败".equals(r[3])) statusClass = "status-fail";
        %>
            <tr>
                <td><%= i + 1 %></td>
                <td><%= r[0] %></td>
                <td><%= r[1] %></td>
                <td><%= r[2] %></td>
                <td class="<%= statusClass %>"><%= r[3] %></td>
                <td><%= r[4] %></td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <div class="actions">
        <a class="btn" href="activities.jsp">查看活动列表</a>
        <a class="btn" href="admin.jsp" style="margin-left:12px;background:#6c757d;">返回管理后台</a>
    </div>
</div>
</body>
</html>

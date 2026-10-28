<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.alibaba.fastjson2.JSON, com.alibaba.fastjson2.JSONObject, com.alibaba.fastjson2.JSONArray" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>导入静态活动数据 - 志愿星河</title>
<style>
body{font-family:"Microsoft YaHei",sans-serif;background:#f5f5f5;padding:40px;}
.container{max-width:900px;margin:0 auto;background:#fff;padding:30px;border-radius:12px;box-shadow:0 2px 12px rgba(0,0,0,0.1);}
h1{color:#27AE60;margin-top:0;}
.success{color:#27AE60;padding:10px;background:#f0f9f0;border-radius:6px;margin:10px 0;}
.error{color:#E8634B;padding:10px;background:#fdf0ee;border-radius:6px;margin:10px 0;}
.info{color:#2C3E50;padding:10px;background:#f0f2f5;border-radius:6px;margin:10px 0;}
pre{background:#2C3E50;color:#fff;padding:15px;border-radius:6px;overflow-x:auto;max-height:300px;overflow-y:auto;}
.back-link{display:inline-block;margin-top:20px;color:#27AE60;text-decoration:none;}
</style>
</head>
<body>
<div class="container">
<h1>导入静态活动数据到数据库</h1>

<%
// 数据库连接配置
String driver = "com.mysql.cj.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/volunteer_star?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=UTF-8";
String username = "root";
String password = "3377515aA.";

// 定义要导入的活动数据（从 data.js 提取）
// 格式: id, title, category, categoryColor, date, location, enrolled, capacity, image, status
String[][] activities = {
    {"10","湖泊志愿清洁行动","环境保护","#2C3E50","2026-08-02 06:30","银川市金凤区典农河沿岸","34","60","assets/images/activity-1.jpg","recruiting"},
    {"11","社区义诊健康宣传","社区服务","#27AE60","2026-08-05 08:30","银川市西夏区社区卫生服务中心","18","30","assets/images/activity-2.jpg","upcoming"},
    {"12","残疾人就业技能培训","助残扶弱","#E8634B","2026-08-08 14:00","银川市金凤区残联培训中心","6","20","assets/images/activity-3.jpg","recruiting"},
    {"13","少儿编程公益课堂","教育帮扶","#5B9BD5","2026-08-10 10:00","银川市兴庆区青少年宫","15","25","assets/images/activity-4.jpg","upcoming"},
    {"14","兔年非遗手工体验","文化惠民","#9B7ED9","2026-08-12 09:30","银川市永宁县文化馆","12","35","assets/images/activity-5.jpg","recruiting"},
    {"15","助老智能手机培训","社区服务","#27AE60","2026-08-15 15:00","银川市金凤区社区活动室","20","20","assets/images/activity-6.jpg","full"},
    {"16","废旧物品创意改造工作坊","环境保护","#2C3E50","2026-08-18 14:30","银川市兴庆区创客空间","9","25","assets/images/activity-7.jpg","recruiting"},
    {"17","社区防诈骗宣传活动","文明创建","#F0C14B","2026-08-20 09:00","银川市金凤区万达广场","38","50","assets/images/activity-8.jpg","recruiting"},
    {"18","牵手牵爱残健亲子运动会","助残扶弱","#E8634B","2026-08-22 08:00","银川市西夏区体育馆","27","40","assets/images/activity-9.jpg","upcoming"},
    {"19","社区美食节志愿服务","社区服务","#27AE60","2026-08-25 17:00","银川市兴庆区社区广场","41","60","assets/images/activity-1.jpg","recruiting"},
    {"20","图书流动车下乡村","教育帮扶","#5B9BD5","2026-08-28 07:30","银川市贺兰县各乡镇小学","5","15","assets/images/activity-2.jpg","recruiting"},
    {"21","社区绿化角落认养计划","环境保护","#2C3E50","2026-09-01 09:00","银川市金凤区各社区绿化带","62","100","assets/images/activity-3.jpg","upcoming"},
    {"22","青少年法治教育进校园","文明创建","#F0C14B","2026-09-03 14:00","银川市永宁县第一中学","10","30","assets/images/activity-4.jpg","recruiting"},
    {"23","爱心衣物捐赠与分拣","助残扶弱","#E8634B","2026-09-05 10:00","银川市金凤区慈善超市","19","30","assets/images/activity-5.jpg","recruiting"},
    {"24","社区老年人免费理发","社区服务","#27AE60","2026-09-08 09:00","银川市西夏区敬老院","16","20","assets/images/activity-6.jpg","recruiting"},
    {"25","中秋节社区联欢志愿者","文化惠民","#9B7ED9","2026-09-12 18:00","银川市兴庆区社区文化广场","25","40","assets/images/activity-7.jpg","upcoming"},
    {"26","环保科普进社区讲座","环境保护","#2C3E50","2026-09-15 15:00","银川市贺兰县社区中心","7","30","assets/images/activity-8.jpg","recruiting"},
    {"27","校园反欺凌志愿宣讲","文明创建","#F0C14B","2026-09-18 14:30","银川市灵武市第二中学","22","35","assets/images/activity-9.jpg","recruiting"},
    {"28","社区紧急救护培训","社区服务","#27AE60","2026-09-20 08:30","银川市金凤区红十字会培训基地","33","45","assets/images/activity-1.jpg","recruiting"},
    {"29","老年人健康检查志愿行","助残扶弱","#E8634B","2026-09-22 07:00","银川市永宁县各社区卫生站","14","25","assets/images/activity-2.jpg","recruiting"},
    {"30","青少年读书分享会","教育帮扶","#5B9BD5","2026-09-25 10:00","银川市金凤区市图书馆","40","40","assets/images/activity-3.jpg","full"},
    {"31","社区墙体彩绘活动","文化惠民","#9B7ED9","2026-09-28 09:00","银川市兴庆区文明社区小巷","17","30","assets/images/activity-4.jpg","recruiting"},
    {"32","活动废弃物回收日","环境保护","#2C3E50","2026-10-06 09:00","银川市金凤区各社区回收点","48","80","assets/images/activity-5.jpg","upcoming"},
    {"33","国庆社区文艺汇演志愿者","社区服务","#27AE60","2026-10-01 15:00","银川市金凤区市民广场","36","60","assets/images/activity-6.jpg","upcoming"},
    {"34","互联网反诈志愿宣传队","文明创建","#F0C14B","2026-10-10 10:00","银川市西夏区网信办","8","20","assets/images/activity-7.jpg","recruiting"},
    {"35","孤寡老人节日探望","助残扶弱","#E8634B","2026-10-15 09:30","银川市贺兰县敬老院","13","25","assets/images/activity-8.jpg","recruiting"},
    {"36","热力地图数据采集志愿行","文化惠民","#9B7ED9","2026-10-20 14:00","银川市各区域社区服务站","4","12","assets/images/activity-9.jpg","recruiting"},
    {"37","社区垃圾分类宣传日","环境保护","#2C3E50","2026-10-25 09:00","银川市金凤区垃圾分类站","28","40","assets/images/activity-1.jpg","upcoming"},
    {"38","爱心午餐志愿服务","助残扶弱","#E8634B","2026-07-16 11:00","银川市兴庆区爱心餐厅","15","20","assets/images/activity-2.jpg","recruiting"},
    {"39","暑期托管志愿服务班","教育帮扶","#5B9BD5","2026-08-03 09:00","银川市西夏区青少年活动中心","12","20","assets/images/activity-3.jpg","recruiting"},
    {"40","公园文明劝导志愿岗","文明创建","#F0C14B","2026-08-10 07:30","银川市金凤区阅海公园","18","30","assets/images/activity-4.jpg","recruiting"},
    {"41","公益书法教学课堂","文化惠民","#9B7ED9","2026-08-15 14:00","银川市兴庆区书画院","9","25","assets/images/activity-5.jpg","recruiting"},
    {"42","志愿者景区服务日","社区服务","#27AE60","2026-08-20 08:00","银川市金凤区西夏风情园","24","35","assets/images/activity-6.jpg","upcoming"},
    {"43","助残日爱心义卖","助残扶弱","#E8634B","2026-08-25 09:00","银川市西夏区步行街","16","25","assets/images/activity-7.jpg","recruiting"},
    {"44","社区儿童安全教育","教育帮扶","#5B9BD5","2026-09-02 10:00","银川市兴庆区儿童之家","20","30","assets/images/activity-8.jpg","upcoming"},
    {"45","文明养宠志愿宣传","文明创建","#F0C14B","2026-09-05 09:00","银川市金凤区宝湖公园","13","25","assets/images/activity-9.jpg","recruiting"},
    {"46","绿色出行骑行宣传","环境保护","#2C3E50","2026-09-10 07:00","银川市金凤区北京中路","42","60","assets/images/activity-1.jpg","recruiting"},
    {"47","重阳敬老文化演出","文化惠民","#9B7ED9","2026-10-10 14:00","银川市西夏区老年大学","8","30","assets/images/activity-2.jpg","upcoming"},
    {"48","社区安全隐患排查","社区服务","#27AE60","2026-09-12 09:00","银川市永宁县望远社区","22","35","assets/images/activity-3.jpg","recruiting"},
    {"49","流动儿童课后辅导","教育帮扶","#5B9BD5","2026-09-15 08:00","银川市兴庆区外来务工子女学校","7","15","assets/images/activity-4.jpg","recruiting"},
    {"50","宁东产业工人志愿日","社区服务","#27AE60","2026-09-20 08:00","银川市宁东镇能源化工基地","12","25","assets/images/activity-5.jpg","recruiting"},
    {"51","贺兰山生态修复植树","环境保护","#2C3E50","2026-10-03 07:00","银川市贺兰县贺兰山东麓","55","80","assets/images/activity-6.jpg","upcoming"},
    {"52","爱心缝补志愿服务站","助残扶弱","#E8634B","2026-10-08 14:00","银川市灵武市人民路社区","6","15","assets/images/activity-7.jpg","recruiting"},
    {"53","文明餐桌志愿推广","文明创建","#F0C14B","2026-10-12 11:30","银川市西夏区大学城美食街","26","40","assets/images/activity-8.jpg","recruiting"},
    {"54","民俗文化节志愿服务","文化惠民","#9B7ED9","2026-10-16 09:00","银川市兴庆区鼓楼广场","31","50","assets/images/activity-9.jpg","upcoming"},
    {"55","社区疫苗志愿协助","社区服务","#27AE60","2026-10-18 08:00","银川市西夏区方舱接种点","19","25","assets/images/activity-1.jpg","recruiting"},
    {"56","青少年科技体验营","教育帮扶","#5B9BD5","2026-10-22 09:00","银川市金凤区科技馆","23","30","assets/images/activity-2.jpg","upcoming"},
    {"57","沙湖环境清洁行动","环境保护","#2C3E50","2026-10-25 06:30","银川市灵武市沙湖景区","18","40","assets/images/activity-3.jpg","recruiting"},
    {"58","盲人图书馆志愿者","助残扶弱","#E8634B","2026-11-03 14:00","银川市金凤区视障者服务中心","5","12","assets/images/activity-4.jpg","upcoming"},
    {"59","黄河湿地保护行动","环境保护","#2C3E50","2026-11-08 07:00","银川市永宁县黄河湿地公园","30","55","assets/images/activity-5.jpg","upcoming"},
    {"60","社区诚信文明宣讲","文明创建","#F0C14B","2026-11-12 15:00","银川市金凤区市民大厅","11","25","assets/images/activity-6.jpg","recruiting"},
    {"61","爱心义诊进社区","社区服务","#27AE60","2026-07-03 09:30","银川市金凤区社区服务站","10","30","assets/images/activity-1.jpg","recruiting"},
    {"62","贺兰山徒步清捡","环境保护","#2C3E50","2026-07-06 15:00","银川市贺兰县市民广场","37","40","assets/images/activity-2.jpg","recruiting"},
    {"63","留守儿童课业辅导","教育帮扶","#5B9BD5","2026-07-09 14:00","银川市兴庆区文化中心","19","20","assets/images/activity-3.jpg","upcoming"},
    {"64","文明交通劝导行动","文明创建","#F0C14B","2026-07-12 10:00","银川市西夏区志愿服务站","21","35","assets/images/activity-4.jpg","recruiting"},
    {"65","残疾人康复陪伴","助残扶弱","#E8634B","2026-07-15 08:00","银川市永宁县公园北门","3","10","assets/images/activity-5.jpg","recruiting"},
    {"66","周末公益电影放映","文化惠民","#9B7ED9","2026-07-18 07:00","银川市金凤区街道办","50","60","assets/images/activity-6.jpg","upcoming"},
    {"67","邻里守望助老服务","社区服务","#27AE60","2026-07-21 13:30","银川市灵武市老年活动中心","11","15","assets/images/activity-7.jpg","recruiting"},
    {"68","宁东工业园区绿植","环境保护","#2C3E50","2026-07-24 09:30","银川市宁东镇学校操场","25","25","assets/images/activity-8.jpg","full"},
    {"69","暑期科普夏令营","教育帮扶","#5B9BD5","2026-07-27 15:00","银川市贺兰县商业街广场","22","35","assets/images/activity-9.jpg","recruiting"},
    {"70","社区楼道杂物清理","文明创建","#F0C14B","2026-07-30 14:00","银川市西夏区图书馆","16","20","assets/images/activity-1.jpg","recruiting"},
    {"71","盲人阅读陪伴计划","助残扶弱","#E8634B","2026-08-03 15:00","银川市兴庆区体育馆","8","12","assets/images/activity-2.jpg","upcoming"},
    {"72","传统戏曲进乡村","文化惠民","#9B7ED9","2026-08-06 14:00","银川市永宁县湿地保护区","14","45","assets/images/activity-3.jpg","recruiting"},
    {"73","社区义务理发日","社区服务","#27AE60","2026-08-09 10:00","银川市金凤区工业园区","20","20","assets/images/activity-4.jpg","full"},
    {"74","黄河岸边植绿护绿","环境保护","#2C3E50","2026-08-12 08:00","银川市灵武市生态园","34","50","assets/images/activity-5.jpg","recruiting"},
    {"75","大学生支教乡村行","教育帮扶","#5B9BD5","2026-08-15 07:00","银川市贺兰县村委会广场","35","40","assets/images/activity-6.jpg","recruiting"},
    {"76","文明养宠宣传周","文明创建","#F0C14B","2026-08-18 13:30","银川市西夏区农贸市场","20","25","assets/images/activity-7.jpg","recruiting"},
    {"77","孤寡老人暖心陪伴","助残扶弱","#E8634B","2026-08-21 09:30","银川市兴庆区社区服务站","9","15","assets/images/activity-8.jpg","upcoming"},
    {"78","社区书画艺术展","文化惠民","#9B7ED9","2026-08-24 15:00","银川市金凤区市民广场","17","35","assets/images/activity-9.jpg","recruiting"},
    {"79","宁东夜市文明督导","文明创建","#F0C14B","2026-08-27 14:00","银川市宁东镇文化中心","9","20","assets/images/activity-1.jpg","recruiting"},
    {"80","社区消防安全巡查","社区服务","#27AE60","2026-08-30 10:00","银川市永宁县志愿服务站","8","18","assets/images/activity-2.jpg","recruiting"},
    {"81","湿地候鸟监测保护","环境保护","#2C3E50","2026-09-03 14:00","银川市灵武市公园北门","30","30","assets/images/activity-3.jpg","full"},
    {"82","少儿编程公益课堂二期","教育帮扶","#5B9BD5","2026-09-06 10:00","银川市金凤区街道办","15","22","assets/images/activity-4.jpg","upcoming"},
    {"83","城市小广告清除日","文明创建","#F0C14B","2026-09-09 08:00","银川市西夏区老年活动中心","29","30","assets/images/activity-5.jpg","recruiting"},
    {"84","轮椅畅行无障碍日","助残扶弱","#E8634B","2026-09-13 10:00","银川市贺兰县学校操场","11","12","assets/images/activity-6.jpg","recruiting"},
    {"85","非遗文化传承体验","文化惠民","#9B7ED9","2026-09-17 14:00","银川市兴庆区商业街广场","31","40","assets/images/activity-7.jpg","recruiting"},
    {"86","社区家电义务维修","社区服务","#27AE60","2026-09-21 15:00","银川市永宁县图书馆","8","15","assets/images/activity-8.jpg","recruiting"},
    {"87","湖泊水质监测行动","环境保护","#2C3E50","2026-09-25 09:30","银川市金凤区体育馆","22","30","assets/images/activity-9.jpg","upcoming"},
    {"88","企业垃圾分类培训","环境保护","#2C3E50","2026-09-29 13:30","银川市宁东镇湿地保护区","14","25","assets/images/activity-1.jpg","recruiting"},
    {"89","外语角志愿教学","教育帮扶","#5B9BD5","2026-10-03 07:00","银川市西夏区工业园区","15","18","assets/images/activity-2.jpg","recruiting"},
    {"90","电动车上牌志愿站","社区服务","#27AE60","2026-10-07 08:00","银川市兴庆区生态园","20","20","assets/images/activity-3.jpg","full"},
    {"91","助残手工艺品义卖","助残扶弱","#E8634B","2026-10-11 10:00","银川市金凤区村委会广场","8","15","assets/images/activity-4.jpg","recruiting"},
    {"92","社区读书分享会","文化惠民","#9B7ED9","2026-10-15 14:00","银川市灵武市农贸市场","21","25","assets/images/activity-5.jpg","upcoming"},
    {"93","冬季送温暖行动","社区服务","#27AE60","2026-10-19 15:00","银川市贺兰县社区服务站","24","30","assets/images/activity-6.jpg","recruiting"},
    {"94","废旧电池回收日","环境保护","#2C3E50","2026-10-22 14:00","银川市西夏区市民广场","12","20","assets/images/activity-7.jpg","recruiting"},
    {"95","青少年心理辅导","教育帮扶","#5B9BD5","2026-10-25 10:00","银川市兴庆区文化中心","15","15","assets/images/activity-8.jpg","upcoming"},
    {"96","社区文明公约宣传","文明创建","#F0C14B","2026-10-28 08:00","银川市永宁县志愿服务站","20","25","assets/images/activity-9.jpg","recruiting"},
    {"97","听障人士手语翻译","助残扶弱","#E8634B","2026-10-31 07:00","银川市宁东镇公园北门","7","10","assets/images/activity-1.jpg","recruiting"},
    {"98","迎新春文艺汇演","文化惠民","#9B7ED9","2026-11-04 08:00","银川市金凤区街道办","40","50","assets/images/activity-2.jpg","recruiting"},
    {"99","社区养老服务需求调研","社区服务","#27AE60","2026-11-07 07:00","银川市灵武市老年活动中心","7","18","assets/images/activity-3.jpg","recruiting"},
    {"100","大漠环保志愿行","环境保护","#2C3E50","2026-11-11 08:00","银川市灵武市学校操场","25","25","assets/images/activity-4.jpg","full"},
    {"101","中小学科普讲座","教育帮扶","#5B9BD5","2026-11-15 10:00","银川市贺兰县商业街广场","14","20","assets/images/activity-5.jpg","recruiting"},
    {"102","车窗抛物文明劝导","文明创建","#F0C14B","2026-11-19 14:00","银川市金凤区图书馆","14","25","assets/images/activity-6.jpg","upcoming"},
    {"103","残障儿童艺术课堂","助残扶弱","#E8634B","2026-11-23 15:00","银川市兴庆区体育馆","5","10","assets/images/activity-7.jpg","recruiting"},
    {"104","乡村文化大院巡演","文化惠民","#9B7ED9","2026-11-26 14:00","银川市永宁县湿地保护区","27","40","assets/images/activity-8.jpg","recruiting"},
    {"105","宁东工人子女托管","教育帮扶","#5B9BD5","2026-11-30 15:00","银川市宁东镇工业园区","11","15","assets/images/activity-9.jpg","recruiting"},
    {"106","社区共享花园建设","社区服务","#27AE60","2026-12-04 09:30","银川市西夏区生态园","19","25","assets/images/activity-1.jpg","recruiting"},
    {"107","禁塑环保志愿宣传","环境保护","#2C3E50","2026-12-08 13:30","银川市金凤区村委会广场","29","30","assets/images/activity-2.jpg","recruiting"},
    {"108","老年人智能机教学","教育帮扶","#5B9BD5","2026-12-11 09:30","银川市灵武市农贸市场","12","12","assets/images/activity-3.jpg","full"},
    {"109","公共区域烟头清零","文明创建","#F0C14B","2026-12-15 13:30","银川市兴庆区社区服务站","18","22","assets/images/activity-4.jpg","recruiting"},
    {"110","康复辅具免费租赁","助残扶弱","#E8634B","2026-12-19 07:00","银川市贺兰县市民广场","7","10","assets/images/activity-5.jpg","upcoming"},
    {"111","新年春联送万家","文化惠民","#9B7ED9","2026-12-23 08:00","银川市永宁县文化中心","39","50","assets/images/activity-6.jpg","recruiting"},
    {"112","春运志愿暖冬行动","社区服务","#27AE60","2026-12-27 10:00","银川市金凤区志愿服务站","30","35","assets/images/activity-7.jpg","recruiting"},
    {"113","贺兰山防火巡查","环境保护","#2C3E50","2026-12-31 14:00","银川市贺兰县公园北门","7","20","assets/images/activity-8.jpg","recruiting"},
    {"114","公益法律咨询服务","教育帮扶","#5B9BD5","2027-01-04 15:00","银川市宁东镇街道办","12","12","assets/images/activity-9.jpg","upcoming"},
    {"115","农贸市场文明管理","文明创建","#F0C14B","2027-01-08 09:30","银川市西夏区老年活动中心","15","18","assets/images/activity-1.jpg","recruiting"},
    {"116","农村留守老人关爱","社区服务","#27AE60","2027-01-11 15:00","银川市永宁县学校操场","14","20","assets/images/activity-2.jpg","recruiting"},
    {"117","城市河道垃圾打捞","环境保护","#2C3E50","2027-01-15 09:30","银川市兴庆区商业街广场","20","30","assets/images/activity-3.jpg","recruiting"},
    {"118","幼儿绘本阅读辅导","教育帮扶","#5B9BD5","2027-01-18 15:00","银川市金凤区图书馆","15","15","assets/images/activity-4.jpg","full"},
    {"119","血站义务献血宣传","社区服务","#27AE60","2027-01-22 09:30","银川市灵武市体育馆","13","30","assets/images/activity-5.jpg","recruiting"},
    {"120","古建筑保护志愿行","文化惠民","#9B7ED9","2027-01-25 15:00","银川市宁东镇湿地保护区","12","15","assets/images/activity-6.jpg","recruiting"}
};

Connection conn = null;
int inserted = 0;
int skipped = 0;
int failed = 0;

// 状态映射：recruiting->1, upcoming->2, full->1(但已报名人数>=容量)
// 数据库 activity_status_id: 1=招募中, 2=进行中, 4=已取消
// 这里 full 也视为招募中，只是人数满了

StringBuilder log = new StringBuilder();

try {
    Class.forName(driver);
    conn = DriverManager.getConnection(url, username, password);
    out.println("<div class='success'>✓ 数据库连接成功</div>");
    
    // 先查询当前最大ID
    Statement stmtMax = conn.createStatement();
    ResultSet rsMax = stmtMax.executeQuery("SELECT MAX(id) as maxId FROM volunteer_activity");
    int maxId = 0;
    if (rsMax.next()) {
        maxId = rsMax.getInt("maxId");
    }
    rsMax.close();
    stmtMax.close();
    out.println("<div class='info'>当前数据库最大活动ID: " + maxId + "</div>");
    
    String insertSQL = "INSERT IGNORE INTO volunteer_activity (" +
        "id, organization_id, region_id, activity_status_id, publish_user_id, title, activity_type, " +
        "activity_cover_url, description, address, start_time, end_time, sign_in_start_time, " +
        "sign_out_end_time, recruit_count, applied_count, favorite_count, share_count, " +
        "service_hour, heat_value, publish_time" +
        ") VALUES (?, 1, 2, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 3.00, 50, NOW())";
    
    PreparedStatement pstmt = conn.prepareStatement(insertSQL);
    
    for (int i = 0; i < activities.length; i++) {
        String[] act = activities[i];
        int id = Integer.parseInt(act[0]);
        String title = act[1];
        String category = act[2];
        // String categoryColor = act[3]; // 数据库中没有这个字段，通过 volunteer_tag 关联
        String dateStr = act[4];
        String location = act[5];
        int enrolled = Integer.parseInt(act[6]);
        int capacity = Integer.parseInt(act[7]);
        String image = act[8];
        String status = act[9];
        
        // 状态映射
        int statusId = 1; // 默认招募中
        if ("upcoming".equals(status)) statusId = 2; // 即将开始 -> 进行中
        // "full" 和 "recruiting" 都用 1（招募中），full 只是人数满了
        
        // 解析日期
        String startTime = dateStr + ":00";
        String endTime = dateStr + ":00";
        
        // 简单处理：如果日期中有范围（如 "-"），取开始日期
        if (dateStr.contains(" - ")) {
            startTime = dateStr.split(" - ")[0].trim() + ":00";
            endTime = dateStr.split(" - ")[1].trim().substring(0, 10) + " 17:00:00";
        }
        
        // 填充参数
        pstmt.setInt(1, id);
        pstmt.setInt(2, statusId);
        pstmt.setString(3, title);
        pstmt.setString(4, category);
        pstmt.setString(5, image);
        pstmt.setString(6, "参与" + title + "，为社区贡献力量。");
        pstmt.setString(7, location);
        pstmt.setString(8, startTime);
        pstmt.setString(9, endTime);
        pstmt.setString(10, startTime);
        pstmt.setString(11, endTime);
        pstmt.setInt(12, capacity);
        pstmt.setInt(13, enrolled);
        
        try {
            int result = pstmt.executeUpdate();
            if (result > 0) {
                inserted++;
                log.append("✓ 导入: ID=").append(id).append(" ").append(title).append("\n");
            } else {
                skipped++;
                log.append("○ 跳过: ID=").append(id).append(" ").append(title).append(" (已存在)\n");
            }
        } catch (SQLException e) {
            failed++;
            log.append("✗ 失败: ID=").append(id).append(" ").append(title).append(" - ").append(e.getMessage()).append("\n");
        }
    }
    
    pstmt.close();
    
    out.println("<div class='success'>导入完成！</div>");
    out.println("<div class='info'>");
    out.println("<strong>统计：</strong><br>");
    out.println("✓ 成功导入: " + inserted + " 条<br>");
    out.println("○ 跳过(已存在): " + skipped + " 条<br>");
    out.println("✗ 失败: " + failed + " 条<br>");
    out.println("</div>");
    
    out.println("<h3>导入日志</h3>");
    out.println("<pre>" + log.toString().replace("<", "&lt;").replace(">", "&gt;") + "</pre>");
    
} catch (Exception e) {
    out.println("<div class='error'>导入失败: " + e.getMessage() + "</div>");
    e.printStackTrace();
} finally {
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>
<a href="<%= request.getContextPath() %>/activities.jsp" class="back-link">← 返回活动中心</a>
</div>
</body>
</html>

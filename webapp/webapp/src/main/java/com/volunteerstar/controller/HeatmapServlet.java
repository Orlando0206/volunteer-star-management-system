package com.volunteerstar.controller;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/heatmap/api/*")
public class HeatmapServlet extends HttpServlet {

    private static JSONArray allActivities = null;

    @Override
    public void init() throws ServletException {
        loadActivities();
    }

    private synchronized void loadActivities() {
        if (allActivities != null) return;
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("activities.json")) {
            if (is == null) {
                throw new RuntimeException("activities.json 未找到");
            }
            String content = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            allActivities = JSON.parseArray(content);
        } catch (IOException e) {
            throw new RuntimeException("加载 activities.json 失败", e);
        }
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (allActivities == null) loadActivities();

        String path = req.getPathInfo();
        if (path == null) path = "/";

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        switch (path) {
            case "/activities":
                handleActivities(req, resp);
                break;
            case "/regions":
                handleRegions(req, resp);
                break;
            case "/search":
                handleSearch(req, resp);
                break;
            default:
                Map<String, Object> info = new HashMap<>();
                info.put("code", 0);
                info.put("total", allActivities != null ? allActivities.size() : 0);
                info.put("endpoints", new String[]{"/heatmap/api/activities", "/heatmap/api/regions", "/heatmap/api/search"});
                resp.getWriter().write(JSON.toJSONString(info));
        }
    }

    private void handleActivities(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String time = req.getParameter("time");
        if (time == null) time = "all";
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");

        List<JSONObject> filtered = new ArrayList<>();
        LocalDate today = LocalDate.now();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (int i = 0; i < allActivities.size(); i++) {
            JSONObject act = allActivities.getJSONObject(i);
            String sortDateStr = act.getString("sortDate");
            if (sortDateStr == null || sortDateStr.isEmpty()) continue;

            LocalDate actDate;
            try {
                actDate = LocalDate.parse(sortDateStr, fmt);
            } catch (Exception e) {
                continue;
            }

            boolean include = true;

            if ("month".equals(time)) {
                LocalDate monthStart = today.withDayOfMonth(1);
                LocalDate monthEnd = today.withDayOfMonth(today.lengthOfMonth());
                include = !actDate.isBefore(monthStart) && !actDate.isAfter(monthEnd);
            } else if ("3months".equals(time)) {
                LocalDate threeMonthsAgo = today.minusMonths(3).withDayOfMonth(1);
                include = !actDate.isBefore(threeMonthsAgo);
            } else if ("6months".equals(time)) {
                LocalDate sixMonthsAgo = today.minusMonths(6).withDayOfMonth(1);
                include = !actDate.isBefore(sixMonthsAgo);
            }

            if (include && keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim().toLowerCase();
                String title = act.getString("title");
                String location = act.getString("location");
                String cat = act.getString("category");
                include = (title != null && title.toLowerCase().contains(kw))
                        || (location != null && location.toLowerCase().contains(kw))
                        || (cat != null && cat.toLowerCase().contains(kw));
            }

            if (include && category != null && !category.trim().isEmpty() && !"全部".equals(category)) {
                String cat = act.getString("category");
                include = category.equals(cat);
            }

            if (include) {
                filtered.add(act);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("code", 0);
        result.put("total", filtered.size());
        result.put("data", filtered);
        result.put("time", time);

        resp.getWriter().write(JSON.toJSONString(result));
    }

    private void handleRegions(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String time = req.getParameter("time");
        if (time == null) time = "all";

        Map<String, JSONObject> regionMap = new HashMap<>();
        LocalDate today = LocalDate.now();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (int i = 0; i < allActivities.size(); i++) {
            JSONObject act = allActivities.getJSONObject(i);
            String sortDateStr = act.getString("sortDate");

            boolean include = true;
            if (!"all".equals(time) && sortDateStr != null) {
                try {
                    LocalDate actDate = LocalDate.parse(sortDateStr, fmt);
                    if ("month".equals(time)) {
                        LocalDate monthStart = today.withDayOfMonth(1);
                        include = !actDate.isBefore(monthStart);
                    } else if ("3months".equals(time)) {
                        include = !actDate.isBefore(today.minusMonths(3).withDayOfMonth(1));
                    } else if ("6months".equals(time)) {
                        include = !actDate.isBefore(today.minusMonths(6).withDayOfMonth(1));
                    }
                } catch (Exception ignored) {}
            }

            if (!include) continue;

            String location = act.getString("location");
            String region = detectRegion(location);
            regionMap.putIfAbsent(region, new JSONObject());
            JSONObject r = regionMap.get(region);
            r.putIfAbsent("name", region);
            r.putIfAbsent("count", 0);
            r.putIfAbsent("participants", 0);
            r.putIfAbsent("hours", 0);
            r.put("count", r.getIntValue("count") + 1);
            r.put("participants", r.getIntValue("participants") + act.getIntValue("enrolled"));
            r.put("hours", r.getIntValue("hours") + Math.round(act.getIntValue("enrolled") * 2.5));
        }

        List<JSONObject> regionList = new ArrayList<>(regionMap.values());
        regionList.sort((a, b) -> b.getIntValue("count") - a.getIntValue("count"));

        Map<String, Object> result = new HashMap<>();
        result.put("code", 0);
        result.put("data", regionList);
        resp.getWriter().write(JSON.toJSONString(result));
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("q");
        if (keyword == null || keyword.trim().isEmpty()) {
            resp.getWriter().write("{\"code\":0,\"data\":[]}");
            return;
        }

        List<JSONObject> results = new ArrayList<>();
        String kw = keyword.trim().toLowerCase();

        for (int i = 0; i < allActivities.size(); i++) {
            JSONObject act = allActivities.getJSONObject(i);
            String title = act.getString("title");
            String location = act.getString("location");
            if ((title != null && title.toLowerCase().contains(kw))
                    || (location != null && location.toLowerCase().contains(kw))) {
                results.add(act);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("code", 0);
        result.put("total", results.size());
        result.put("data", results);
        resp.getWriter().write(JSON.toJSONString(result));
    }

    private String detectRegion(String location) {
        if (location == null) return "金凤区";
        String[][] regions = {
                {"金凤区", "金凤"},
                {"兴庆区", "兴庆"},
                {"西夏区", "西夏"},
                {"贺兰县", "贺兰"},
                {"永宁县", "永宁"},
                {"灵武市", "灵武"},
                {"宁东镇", "宁东"}
        };
        for (String[] r : regions) {
            if (location.contains(r[1])) return r[0];
        }
        return "金凤区";
    }
}

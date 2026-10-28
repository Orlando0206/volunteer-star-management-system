package com.volunteerstar.controller;

import com.alibaba.fastjson2.JSON;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/api/coze/config")
public class CozeConfigServlet extends HttpServlet {
    private static final String DEFAULT_BOT_ID = "7662652685367738411";
    private static final Path USER_CONFIG_PATH = Path.of(
            System.getProperty("user.home"), ".volunteer-star", "coze.properties");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        resp.setHeader("Pragma", "no-cache");

        String token = readConfig("COZE_WEB_SDK_TOKEN");
        String botId = readConfig("COZE_BOT_ID");
        if (botId == null) {
            botId = DEFAULT_BOT_ID;
        }

        Map<String, Object> result = new LinkedHashMap<>();
        if (token == null) {
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            result.put("success", false);
            result.put("message", "扣子智能体尚未配置访问令牌，请设置环境变量 COZE_WEB_SDK_TOKEN 后重启服务。");
        } else {
            result.put("success", true);
            result.put("botId", botId);
            result.put("token", token);
        }
        resp.getWriter().write(JSON.toJSONString(result));
    }

    private String readConfig(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            value = System.getProperty(name);
        }
        if (value == null || value.isBlank()) {
            value = readUserConfig(name);
        }
        return value == null || value.isBlank() ? null : value.trim();
    }

    private String readUserConfig(String name) {
        if (!Files.isRegularFile(USER_CONFIG_PATH)) {
            return null;
        }
        Properties properties = new Properties();
        try (InputStream inputStream = Files.newInputStream(USER_CONFIG_PATH)) {
            properties.load(inputStream);
            return properties.getProperty(name);
        } catch (IOException exception) {
            getServletContext().log("读取扣子本地配置失败: " + USER_CONFIG_PATH, exception);
            return null;
        }
    }
}

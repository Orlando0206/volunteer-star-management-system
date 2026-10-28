package com.volunteerstar.controller;

import com.volunteerstar.pojo.User;
import com.volunteerstar.service.UserService;
import com.volunteerstar.service.impl.UserServiceImpl;
import com.volunteerstar.utils.StringUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = StringUtils.safeTrim(req.getParameter("action"));
        if (StringUtils.isBlank(action)) {
            action = "GET".equalsIgnoreCase(req.getMethod()) ? "viewLogin" : "login";
        }

        try {
            Method method = this.getClass().getDeclaredMethod(action, HttpServletRequest.class, HttpServletResponse.class);
            method.setAccessible(true);
            method.invoke(this, req, resp);
        } catch (NoSuchMethodException exception) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } catch (InvocationTargetException exception) {
            Throwable targetException = exception.getTargetException();
            if (targetException instanceof ServletException servletException) {
                throw servletException;
            }

            if (targetException instanceof IOException ioException) {
                throw ioException;
            }
            throw new ServletException("AuthServlet 反射分发执行失败", targetException);
        } catch (IllegalAccessException exception) {
            throw new ServletException("AuthServlet 无法访问目标方法", exception);
        }
    }

    private void viewLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().invalidate();
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        User user = userService.login(username, password);
        if (user == null) {
            req.setAttribute("activeTab", "login");
            req.setAttribute("message", "用户名或密码错误");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        req.getSession().setAttribute("loginUser", user);
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    private void sendCode(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String phone = req.getParameter("phone");
        resp.setContentType("application/json;charset=UTF-8");

        if (phone == null || !phone.matches("^1\\d{10}$")) {
            resp.getWriter().write("{\"ok\":false,\"msg\":\"手机号格式不正确\"}");
            return;
        }

        int code = (int) (Math.random() * 900000) + 100000;
        String codeStr = String.valueOf(code);

        // 验证码保留5分钟，方便本地演示。
        req.getSession().setAttribute("phoneCode_" + phone, codeStr);
        req.getSession().setAttribute("phoneCodeTime_" + phone, System.currentTimeMillis());
        System.out.println("验证码 " + codeStr + "，手机号 " + phone + "，5分钟内有效");

        resp.getWriter().write("{\"ok\":true}");
    }

    private void phoneCodeLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String phone = req.getParameter("phone");
        String inputCode = req.getParameter("code");

        if (phone == null || !phone.matches("^1\\d{10}$")) {
            req.setAttribute("activeTab", "phone");
            req.setAttribute("message", "请输入正确的手机号");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 验证验证码
        String savedCode = (String) req.getSession().getAttribute("phoneCode_" + phone);
        Long savedTime = (Long) req.getSession().getAttribute("phoneCodeTime_" + phone);

        if (savedCode == null || savedTime == null) {
            req.setAttribute("activeTab", "phone");
            req.setAttribute("message", "请先获取验证码");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 5分钟过期
        if (System.currentTimeMillis() - savedTime > 5 * 60 * 1000) {
            req.getSession().removeAttribute("phoneCode_" + phone);
            req.getSession().removeAttribute("phoneCodeTime_" + phone);
            req.setAttribute("activeTab", "phone");
            req.setAttribute("message", "验证码已过期，请重新获取");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if (!savedCode.equals(inputCode)) {
            req.setAttribute("activeTab", "phone");
            req.setAttribute("message", "验证码错误");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 验证通过，查找用户
        User user = userService.findByPhone(phone);
        if (user == null) {
            // 手机号未注册 → 自动注册
            String nick = "志愿者" + phone.substring(phone.length() - 4);
            String err = userService.register(phone, phone.substring(phone.length() - 6), phone.substring(phone.length() - 6), nick, phone);
            if (err != null) {
                req.setAttribute("activeTab", "phone");
                req.setAttribute("message", "自动注册失败: " + err);
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }
            user = userService.login(phone, phone.substring(phone.length() - 6));
        }

        if (user == null) {
            req.setAttribute("activeTab", "phone");
            req.setAttribute("message", "登录失败，请重试");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 清除验证码
        req.getSession().removeAttribute("phoneCode_" + phone);
        req.getSession().removeAttribute("phoneCodeTime_" + phone);

        req.getSession().setAttribute("loginUser", user);
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    private void register(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String username = req.getParameter("registerUsername");
        String password = req.getParameter("registerPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        String nickname = req.getParameter("nickname");
        String phone = req.getParameter("phone");
        String errorMessage = userService.register(username, password, confirmPassword, nickname, phone);
        if (errorMessage != null) {
            req.setAttribute("activeTab", "register");
            req.setAttribute("message", errorMessage);
            req.setAttribute("registerUsername", username);
            req.setAttribute("nickname", nickname);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("activeTab", "login");
        req.setAttribute("successMessage", "注册成功，请登录");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    private void checkUsername(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        boolean exists = userService.existsByUsername(username);
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"exists\":" + exists + "}");
    }
}

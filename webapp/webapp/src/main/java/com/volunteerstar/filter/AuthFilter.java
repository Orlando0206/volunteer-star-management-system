package com.volunteerstar.filter;

import com.volunteerstar.pojo.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        if (isAllowedPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User loginUser = session == null ? null : (User) session.getAttribute("loginUser");
        if (loginUser != null) {
            if ("/admin.jsp".equals(path) && !"1".equals(loginUser.getRole())) {
                resp.sendRedirect(contextPath + "/index.jsp");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        resp.sendRedirect(contextPath + "/login.jsp");
    }

    private boolean isAllowedPath(String path) {
        return "/".equals(path)
                || "/login.jsp".equals(path)
                || "/auth".equals(path)
                || path.startsWith("/assets/")
                || path.startsWith("/favicon")
                || path.startsWith("/error")
                || path.startsWith("/heatmap/");
    }
}

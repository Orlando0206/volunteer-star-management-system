package com.volunteerstar.service.impl;

import com.volunteerstar.mapper.UserMapper;
import com.volunteerstar.pojo.User;
import com.volunteerstar.service.UserService;
import com.volunteerstar.utils.MyBatisUtils;
import com.volunteerstar.utils.PasswordUtils;
import com.volunteerstar.utils.StringUtils;
import org.apache.ibatis.session.SqlSession;

public class UserServiceImpl implements UserService {
    @Override
    public User login(String username, String plainPassword) {
        if (StringUtils.isBlank(username) || StringUtils.isBlank(plainPassword)) {
            return null;
        }
        try (SqlSession sqlSession = MyBatisUtils.openSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            User user = userMapper.selectByUsername(username.trim());
            if (user == null) {
                return null;
            }
            return PasswordUtils.matches(plainPassword, user.getPassword()) ? user : null;
        }
    }

    @Override
    public User loginByPhone(String phone, String plainPassword) {
        if (StringUtils.isBlank(phone) || StringUtils.isBlank(plainPassword)) {
            return null;
        }
        if (!phone.matches("^1\\d{10}$")) {
            return null;
        }
        try (SqlSession sqlSession = MyBatisUtils.openSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            User user = userMapper.selectByPhone(phone.trim());
            if (user == null) {
                return null;
            }
            // 验证码登录模式：plainPassword为null时跳过密码校验
            if (plainPassword == null) {
                return user;
            }
            return PasswordUtils.matches(plainPassword, user.getPassword()) ? user : null;
        }
    }

    @Override
    public User findByPhone(String phone) {
        if (StringUtils.isBlank(phone) || !phone.matches("^1\\d{10}$")) {
            return null;
        }
        try (SqlSession sqlSession = MyBatisUtils.openSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            return userMapper.selectByPhone(phone.trim());
        }
    }

    @Override
    public String register(String username, String plainPassword, String confirmPassword, String nickname, String phone) {
        username = StringUtils.safeTrim(username);
        plainPassword = StringUtils.safeTrim(plainPassword);
        confirmPassword = StringUtils.safeTrim(confirmPassword);
        nickname = StringUtils.safeTrim(nickname);
        phone = StringUtils.safeTrim(phone);

        if (StringUtils.isBlank(username) || StringUtils.isBlank(plainPassword) || StringUtils.isBlank(nickname)) {
            return "用户名、密码、昵称不能为空";
        }
        if (!plainPassword.equals(confirmPassword)) {
            return "两次输入的密码不一致";
        }
        if (username.length() < 4 || username.length() > 20) {
            return "用户名长度应为4到20位";
        }
        if (plainPassword.length() < 6 || plainPassword.length() > 20) {
            return "密码长度应为6到20位";
        }
        if (!StringUtils.isBlank(phone) && !phone.matches("^1\\d{10}$")) {
            return "手机号格式不正确";
        }

        try (SqlSession sqlSession = MyBatisUtils.openSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            User existUser = userMapper.selectByUsername(username);
            if (existUser != null) {
                return "用户名已存在，请换一个";
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(PasswordUtils.encode(plainPassword));
            user.setNickname(nickname);
            user.setPhone(phone);
            user.setRole("0");
            userMapper.insertUser(user);
            sqlSession.commit();
            return null;
        } catch (Exception exception) {
            return "注册失败，请检查数据库连接后重试";
        }
    }

    @Override
    public boolean existsByUsername(String username) {
        username = StringUtils.safeTrim(username);
        if (StringUtils.isBlank(username)) {
            return false;
        }
        try (SqlSession sqlSession = MyBatisUtils.openSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            return userMapper.selectByUsername(username) != null;
        }
    }
}

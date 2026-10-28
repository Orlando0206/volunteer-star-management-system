package com.volunteerstar.service;

import com.volunteerstar.pojo.User;

public interface UserService {
    User login(String username, String plainPassword);

    User loginByPhone(String phone, String plainPassword);

    User findByPhone(String phone);

    String register(String username, String plainPassword, String confirmPassword, String nickname, String phone);

    boolean existsByUsername(String username);
}

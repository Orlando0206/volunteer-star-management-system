package com.volunteerstar.mapper;

import com.volunteerstar.pojo.User;

public interface UserMapper {
    User selectByUsername(String username);

    User selectByPhone(String phone);

    int insertUser(User user);
}

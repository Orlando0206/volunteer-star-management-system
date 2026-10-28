package com.volunteerstar.utils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

public class MyBatisUtils {
    private static SqlSessionFactory sqlSessionFactory;

    private MyBatisUtils() {
    }

    public static void init() {
        if (sqlSessionFactory != null) {
            return;
        }
        try (InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml")) {
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            throw new RuntimeException("初始化 MyBatis 失败", e);
        }
    }

    public static SqlSession openSession() {
        if (sqlSessionFactory == null) {
            init();
        }

        return sqlSessionFactory.openSession(false);
    }
}

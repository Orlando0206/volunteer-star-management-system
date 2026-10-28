package com.volunteerstar.utils;

public class PasswordUtils {
    private PasswordUtils() {
    }

    public static String encode(String plainPassword) {
        return plainPassword;
    }

    public static boolean matches(String plainPassword, String hashedPassword) {
        if (StringUtils.isBlank(plainPassword) || StringUtils.isBlank(hashedPassword)) {
            return false;
        }
        return plainPassword.equals(hashedPassword);
    }
}

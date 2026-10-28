package com.volunteerstar.utils;

public class StringUtils {
    private StringUtils() {
    }

    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  String displayRole = loginUser == null ? "" : loginUser.getRole();
  String displayName = loginUser == null ? "" : loginUser.getNickname();
  request.setAttribute("currentPage", "home");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>志愿星河 - 首页</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
  <style>
    /* ===== 首页高级增强样式 ===== */

    /* --- 渐变光晕球（全局装饰） --- */
    .home-orb {
      position: absolute;
      border-radius: 50%;
      filter: blur(100px);
      pointer-events: none;
      z-index: 0;
    }
    .home-orb--green-top {
      width: 500px; height: 500px;
      background: rgba(39,174,96,0.12);
      top: -200px; right: -150px;
    }
    .home-orb--blue-mid {
      width: 400px; height: 400px;
      background: rgba(91,155,213,0.10);
      top: 40%; left: -150px;
    }
    .home-orb--gold-low {
      width: 350px; height: 350px;
      background: rgba(240,193,75,0.10);
      bottom: -100px; right: -100px;
    }

    /* --- Hero增强 --- */
    .hero-enhanced {
      position: relative;
      min-height: calc(100vh - var(--nav-height));
      overflow: hidden;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .hero-enhanced__bg {
      position: absolute;
      inset: 0;
    }

    .hero-enhanced__bg img {
      width: 100%; height: 100%;
      object-fit: cover;
    }

    .hero-enhanced__bg::after {
      content: "";
      position: absolute;
      inset: 0;
      background:
        linear-gradient(180deg, rgba(13,17,23,0.3) 0%, rgba(13,17,23,0.55) 40%, rgba(13,17,23,0.88) 100%);
    }

    .hero-enhanced__particles {
      position: absolute;
      inset: 0;
      z-index: 2;
      pointer-events: none;
    }

    .hero-enhanced__content {
      position: relative;
      z-index: 5;
      text-align: center;
      color: #fff;
      padding: 120px 20px 80px;
      max-width: 900px;
    }

    .hero-badge {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 8px 20px;
      border-radius: 999px;
      background: rgba(255,255,255,0.12);
      backdrop-filter: blur(12px);
      border: 1px solid rgba(255,255,255,0.2);
      font-size: 0.88rem;
      color: rgba(255,255,255,0.9);
      letter-spacing: 0.06em;
      margin-bottom: 32px;
      animation: badge-enter 0.8s ease both;
    }

    .hero-badge__dot {
      width: 8px; height: 8px;
      border-radius: 50%;
      background: #27ae60;
      box-shadow: 0 0 12px rgba(39,174,96,0.6);
      animation: dot-blink 2s ease-in-out infinite;
    }

    @keyframes badge-enter {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes dot-blink {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.3; }
    }

    .hero-main-title {
      font-family: "Noto Serif SC", serif;
      font-size: clamp(2.8rem, 6vw, 5rem);
      font-weight: 700;
      line-height: 1.15;
      margin: 0 0 22px;
      animation: title-enter 0.8s 0.15s ease both;
      background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.82) 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    @keyframes title-enter {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .hero-sub-desc {
      max-width: 620px;
      margin: 0 auto 36px;
      color: rgba(255,255,255,0.72);
      font-size: 1.08rem;
      line-height: 1.8;
      animation: title-enter 0.8s 0.3s ease both;
    }

    .hero-actions {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 16px;
      flex-wrap: wrap;
      animation: title-enter 0.8s 0.45s ease both;
    }

    .hero-btn {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      min-height: 52px;
      padding: 0 28px;
      border-radius: 14px;
      font-size: 1rem;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      letter-spacing: 0.03em;
    }

    .hero-btn--primary {
      background: linear-gradient(135deg, #27ae60, #2ecc71);
      color: #fff;
      box-shadow: 0 8px 30px rgba(39,174,96,0.4);
    }

    .hero-btn--primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 12px 36px rgba(39,174,96,0.5);
    }

    .hero-btn--outline {
      border: 2px solid rgba(255,255,255,0.4);
      color: #fff;
      background: rgba(255,255,255,0.06);
      backdrop-filter: blur(8px);
    }

    .hero-btn--outline:hover {
      background: rgba(255,255,255,0.15);
      border-color: rgba(255,255,255,0.6);
      transform: translateY(-2px);
    }

    .hero-stats-row {
      display: flex;
      justify-content: center;
      gap: 48px;
      margin-top: 56px;
      animation: title-enter 0.8s 0.6s ease both;
    }

    .hero-stat-item {
      text-align: center;
    }

    .hero-stat-num {
      font-family: "Roboto Mono", monospace;
      font-size: 2rem;
      font-weight: 600;
      color: #fff;
    }

    .hero-stat-label {
      font-size: 0.82rem;
      color: rgba(255,255,255,0.6);
      margin-top: 4px;
    }

    .hero-scroll-indicator {
      position: absolute;
      bottom: 32px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 5;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      color: rgba(255,255,255,0.5);
      animation: float 2.5s ease-in-out infinite;
    }

    .hero-scroll-indicator span {
      font-size: 0.72rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
    }

    .hero-scroll-line {
      width: 1px;
      height: 32px;
      background: linear-gradient(180deg, rgba(255,255,255,0.5), transparent);
    }

    /* --- 核心功能卡片 --- */
    .features-section {
      position: relative;
      padding: 100px 0;
      background: #f8fafd;
      overflow: hidden;
    }

    .feature-card {
      position: relative;
      padding: 36px 28px;
      border-radius: 24px;
      background: #fff;
      border: 1px solid #e8ecf1;
      box-shadow: 0 4px 16px rgba(0,0,0,0.04);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      overflow: hidden;
    }

    .feature-card::before {
      content: "";
      position: absolute;
      inset: 0;
      opacity: 0;
      background: radial-gradient(circle at var(--mx,50%) var(--my,50%), rgba(39,174,96,0.06), transparent 60%);
      transition: opacity 0.4s ease;
    }

    .feature-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 16px 40px rgba(39,174,96,0.12);
      border-color: rgba(39,174,96,0.2);
    }

    .feature-card:hover::before {
      opacity: 1;
    }

    .feature-icon-ring {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 56px; height: 56px;
      border-radius: 16px;
      margin-bottom: 18px;
      font-size: 1.5rem;
      position: relative;
      z-index: 1;
    }

    .feature-card h3 {
      margin: 0 0 10px;
      font-family: "Noto Serif SC", serif;
      font-size: 1.15rem;
      font-weight: 600;
      color: #1a1d23;
      position: relative;
      z-index: 1;
    }

    .feature-card p {
      margin: 0;
      font-size: 0.9rem;
      color: #64748b;
      line-height: 1.7;
      position: relative;
      z-index: 1;
    }

    /* --- 平台优势 --- */
    .advantages-section {
      padding: 100px 0;
      background: linear-gradient(180deg, #fff 0%, #f0f9f4 100%);
      position: relative;
      overflow: hidden;
    }

    .advantage-card {
      display: flex;
      gap: 24px;
      padding: 28px;
      border-radius: 20px;
      background: #fff;
      border: 1px solid #e8ecf1;
      box-shadow: 0 4px 16px rgba(0,0,0,0.03);
      transition: all 0.35s ease;
      align-items: flex-start;
    }

    .advantage-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 32px rgba(0,0,0,0.08);
      border-color: rgba(39,174,96,0.15);
    }

    .advantage-icon {
      flex-shrink: 0;
      width: 48px; height: 48px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 14px;
      font-size: 1.4rem;
    }

    .advantage-card h4 {
      margin: 0 0 6px;
      font-size: 1.05rem;
      font-weight: 600;
      color: #1a1d23;
    }

    .advantage-card p {
      margin: 0;
      font-size: 0.88rem;
      color: #64748b;
      line-height: 1.6;
    }

    /* --- 实时数据看板 --- */
    .live-dashboard {
      padding: 80px 0;
      background: #0d1117;
      color: #fff;
      position: relative;
      overflow: hidden;
    }

    .live-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 6px 16px;
      border-radius: 999px;
      background: rgba(239,68,68,0.2);
      border: 1px solid rgba(239,68,68,0.3);
      font-size: 0.82rem;
      color: #fca5a5;
      margin-bottom: 16px;
    }

    .live-badge__dot {
      width: 8px; height: 8px;
      border-radius: 50%;
      background: #ef4444;
      animation: dot-blink 1.5s ease-in-out infinite;
    }

    .counter-cards {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 24px;
    }

    .counter-card {
      padding: 32px 24px;
      border-radius: 22px;
      background: rgba(255,255,255,0.04);
      border: 1px solid rgba(255,255,255,0.08);
      backdrop-filter: blur(8px);
      text-align: center;
      transition: all 0.35s ease;
      position: relative;
      overflow: hidden;
    }

    .counter-card::after {
      content: "";
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: var(--accent-color, #27ae60);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.6s ease;
    }

    .counter-card:hover::after {
      transform: scaleX(1);
    }

    .counter-card:hover {
      transform: translateY(-4px);
      border-color: rgba(255,255,255,0.15);
    }

    .counter-value {
      font-family: "Roboto Mono", monospace;
      font-size: 2.6rem;
      font-weight: 700;
      margin-bottom: 6px;
    }

    .counter-label {
      font-size: 0.9rem;
      color: rgba(255,255,255,0.6);
    }

    .counter-change {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      margin-top: 10px;
      font-size: 0.82rem;
      padding: 4px 12px;
      border-radius: 999px;
    }

    .counter-change--up {
      background: rgba(39,174,96,0.2);
      color: #4ade80;
    }

    /* --- 活动卡片增强 --- */
    .activity-card-advanced {
      position: relative;
      border-radius: 22px;
      overflow: hidden;
      background: #fff;
      border: 1px solid #e8ecf1;
      box-shadow: 0 4px 20px rgba(0,0,0,0.05);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      cursor: pointer;
    }

    .activity-card-advanced:hover {
      transform: translateY(-8px);
      box-shadow: 0 20px 48px rgba(39,174,96,0.15);
    }

    .activity-card-advanced__media {
      position: relative;
      aspect-ratio: 16 / 10;
      overflow: hidden;
    }

    .activity-card-advanced__media img {
      width: 100%; height: 100%;
      object-fit: cover;
      transition: transform 0.6s ease;
    }

    .activity-card-advanced:hover .activity-card-advanced__media img {
      transform: scale(1.08);
    }

    .activity-card-advanced__badge {
      position: absolute;
      top: 14px; left: 14px;
      padding: 5px 14px;
      border-radius: 999px;
      background: rgba(0,0,0,0.65);
      backdrop-filter: blur(8px);
      color: #fff;
      font-size: 0.76rem;
      font-weight: 500;
      letter-spacing: 0.04em;
    }

    .activity-card-advanced__status {
      position: absolute;
      top: 14px; right: 14px;
      padding: 5px 14px;
      border-radius: 999px;
      font-size: 0.74rem;
      font-weight: 600;
    }

    .activity-card-advanced__body {
      padding: 20px;
    }

    .activity-card-advanced__title {
      font-family: "Noto Serif SC", serif;
      font-size: 1.05rem;
      font-weight: 600;
      margin: 0 0 8px;
      color: #1a1d23;
    }

    .activity-card-advanced__meta {
      display: flex;
      flex-direction: column;
      gap: 6px;
      font-size: 0.84rem;
      color: #94a3b8;
    }

    .activity-card-advanced__meta span {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .activity-progress {
      margin-top: 14px;
    }

    .activity-progress__info {
      display: flex;
      justify-content: space-between;
      font-size: 0.76rem;
      color: #94a3b8;
      margin-bottom: 6px;
    }

    .activity-progress__bar {
      height: 6px;
      border-radius: 999px;
      background: #e2e8f0;
      overflow: hidden;
    }

    .activity-progress__fill {
      height: 100%;
      border-radius: 999px;
      background: linear-gradient(90deg, #27ae60, #2ecc71);
      transition: width 1s ease;
    }

    /* --- 快速入门 --- */
    .quickstart-section {
      padding: 80px 0;
      background: #fff;
      position: relative;
    }

    .qs-steps {
      display: flex;
      align-items: flex-start;
      justify-content: center;
      gap: 0;
      max-width: 960px;
      margin: 0 auto;
    }

    .qs-card {
      flex: 1;
      text-align: center;
      padding: 40px 28px 32px;
      border-radius: 20px;
      background: #f8fafd;
      border: 1px solid #e8ecf1;
      transition: all 0.35s ease;
      position: relative;
    }

    .qs-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 12px 36px rgba(39,174,96,0.12);
      border-color: rgba(39,174,96,0.25);
      background: #fff;
    }

    .qs-number {
      font-family: "Roboto Mono", monospace;
      font-size: 3rem;
      font-weight: 700;
      color: rgba(39,174,96,0.15);
      line-height: 1;
      margin-bottom: 8px;
    }

    .qs-icon {
      font-size: 2.2rem;
      margin-bottom: 14px;
    }

    .qs-title {
      font-family: "Noto Serif SC", serif;
      font-size: 1.1rem;
      font-weight: 600;
      color: #1a1d23;
      margin: 0 0 10px;
    }

    .qs-desc {
      font-size: 0.88rem;
      color: #64748b;
      line-height: 1.7;
      margin: 0;
    }

    .qs-arrow {
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.8rem;
      color: #27ae60;
      padding: 0 8px;
      margin-top: 80px;
      flex-shrink: 0;
    }

    /* --- 本月数据简报 --- */
    .monthly-section {
      padding: 80px 0;
      background: linear-gradient(180deg, #f0f9f4 0%, #fff 100%);
      position: relative;
    }

    .monthly-cards {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 24px;
      max-width: 960px;
      margin: 0 auto;
    }

    .monthly-card {
      text-align: center;
      padding: 36px 20px;
      border-radius: 20px;
      background: #fff;
      border: 1px solid #e8ecf1;
      box-shadow: 0 4px 16px rgba(0,0,0,0.03);
      transition: all 0.35s ease;
    }

    .monthly-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 32px rgba(39,174,96,0.1);
      border-color: rgba(39,174,96,0.2);
    }

    .monthly-value {
      font-family: "Roboto Mono", monospace;
      font-size: 2.4rem;
      font-weight: 700;
      color: #27ae60;
      margin-bottom: 8px;
    }

    .monthly-change {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      font-size: 0.88rem;
      color: #16a34a;
      font-weight: 600;
      margin-bottom: 10px;
      padding: 3px 12px;
      border-radius: 999px;
      background: rgba(39,174,96,0.08);
    }

    .monthly-change span {
      font-size: 1rem;
    }

    .monthly-label {
      font-size: 0.86rem;
      color: #64748b;
    }

    /* --- 最新公告 --- */
    .announce-section {
      padding: 80px 0;
      background: #f8fafd;
      position: relative;
    }

    .announce-list {
      display: flex;
      flex-direction: column;
      gap: 20px;
      max-width: 800px;
      margin: 0 auto;
    }

    .announce-card {
      padding: 24px 28px;
      border-radius: 16px;
      background: #fff;
      border-left: 4px solid #27ae60;
      box-shadow: 0 2px 12px rgba(0,0,0,0.04);
      transition: all 0.3s ease;
    }

    .announce-card:hover {
      box-shadow: 0 8px 24px rgba(0,0,0,0.08);
      transform: translateX(4px);
    }

    .announce-date {
      display: inline-block;
      font-family: "Roboto Mono", monospace;
      font-size: 0.78rem;
      color: #27ae60;
      background: rgba(39,174,96,0.08);
      padding: 3px 12px;
      border-radius: 999px;
      margin-bottom: 10px;
    }

    .announce-title {
      font-family: "Noto Serif SC", serif;
      font-size: 1.05rem;
      font-weight: 600;
      color: #1a1d23;
      margin: 0 0 8px;
      line-height: 1.4;
    }

    .announce-desc {
      font-size: 0.88rem;
      color: #64748b;
      line-height: 1.8;
      margin: 0;
    }

    /* 响应式 */
    @media (max-width: 960px) {
      .counter-cards {
        grid-template-columns: repeat(2, 1fr);
      }
      .hero-stats-row {
        gap: 28px;
        flex-wrap: wrap;
      }
      .qs-steps {
        flex-direction: column;
        align-items: center;
      }
      .qs-arrow {
        transform: rotate(90deg);
        margin-top: 0;
        padding: 8px 0;
      }
      .monthly-cards {
        grid-template-columns: repeat(2, 1fr);
      }
    }

    @media (max-width: 640px) {
      .counter-cards {
        grid-template-columns: 1fr;
      }
      .hero-stats-row {
        gap: 16px;
      }
      .hero-stat-num {
        font-size: 1.5rem;
      }
      .monthly-cards {
        grid-template-columns: 1fr;
      }
    }

    /* ===== 每日签到浮动按钮 ===== */
    .checkin-fab {
      position: fixed;
      bottom: 28px;
      right: 104px;
      z-index: 999;
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 14px 22px;
      border-radius: 999px;
      background: linear-gradient(135deg, #7c3aed, #a855f7);
      color: #fff;
      font-size: 0.95rem;
      font-weight: 600;
      cursor: pointer;
      border: none;
      box-shadow: 0 8px 28px rgba(124,58,237,0.4);
      transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
      letter-spacing: 0.03em;
      user-select: none;
    }
    .checkin-fab:hover {
      transform: translateY(-3px);
      box-shadow: 0 12px 36px rgba(124,58,237,0.55);
      background: linear-gradient(135deg, #8b5cf6, #c084fc);
    }
    .checkin-fab:active {
      transform: translateY(-1px);
      box-shadow: 0 6px 20px rgba(124,58,237,0.35);
    }
    .checkin-fab--checked {
      background: linear-gradient(135deg, #27ae60, #2ecc71);
      box-shadow: 0 8px 28px rgba(39,174,96,0.4);
      cursor: default;
    }
    .checkin-fab--checked:hover {
      background: linear-gradient(135deg, #27ae60, #2ecc71);
      box-shadow: 0 8px 28px rgba(39,174,96,0.4);
      transform: none;
    }
    .checkin-fab__icon {
      font-size: 1.35rem;
      line-height: 1;
    }
    .checkin-fab__text {
      white-space: nowrap;
    }

    /* ===== 扣子智能体悬浮入口 ===== */
    .coze-assistant {
      position: fixed;
      right: 28px;
      bottom: 94px;
      z-index: 9997;
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      pointer-events: none;
    }
    .coze-assistant__launcher {
      position: relative;
      display: grid;
      place-items: center;
      width: 62px;
      height: 62px;
      border: 0;
      border-radius: 50%;
      background: linear-gradient(145deg, #31c778, #1f9d5a);
      color: #fff;
      cursor: pointer;
      box-shadow: 0 14px 36px rgba(31,157,90,.36), 0 0 0 7px rgba(39,174,96,.1);
      pointer-events: auto;
      transition: transform .22s ease, box-shadow .22s ease, background .22s ease;
    }
    .coze-assistant__launcher:hover { transform: translateY(-3px); box-shadow: 0 18px 44px rgba(31,157,90,.45), 0 0 0 8px rgba(39,174,96,.12); }
    .coze-assistant__launcher:focus-visible,
    .coze-assistant__close:focus-visible,
    .coze-assistant__retry:focus-visible { outline: 3px solid rgba(39,174,96,.32); outline-offset: 3px; }
    .coze-assistant__launcher svg { width: 29px; height: 29px; transition: transform .22s ease, opacity .18s ease; }
    .coze-assistant__launcher .coze-assistant__icon-close { position: absolute; opacity: 0; transform: rotate(-45deg) scale(.72); }
    .coze-assistant.is-open .coze-assistant__launcher { background: #263640; }
    .coze-assistant.is-open .coze-assistant__icon-chat { opacity: 0; transform: rotate(45deg) scale(.72); }
    .coze-assistant.is-open .coze-assistant__icon-close { opacity: 1; transform: rotate(0) scale(1); }
    .coze-assistant__pulse { position: absolute; inset: -7px; border: 1px solid rgba(39,174,96,.38); border-radius: 50%; animation: coze-pulse 2.4s ease-out infinite; pointer-events: none; }
    .coze-assistant.is-open .coze-assistant__pulse { display: none; }

    .coze-assistant__panel {
      position: absolute;
      right: 0;
      bottom: 78px;
      display: flex;
      flex-direction: column;
      width: min(390px, calc(100vw - 40px));
      height: min(610px, calc(100dvh - 150px));
      min-height: 430px;
      border: 1px solid rgba(30,55,43,.12);
      border-radius: 22px;
      background: #fff;
      box-shadow: 0 28px 80px rgba(26,45,36,.24);
      opacity: 0;
      overflow: hidden;
      pointer-events: none;
      transform: translateY(14px) scale(.97);
      transform-origin: bottom right;
      transition: opacity .22s ease, transform .26s cubic-bezier(.2,.8,.2,1);
    }
    .coze-assistant.is-open .coze-assistant__panel { opacity: 1; pointer-events: auto; transform: translateY(0) scale(1); }
    .coze-assistant__header { display: flex; align-items: center; gap: 12px; min-height: 68px; border-bottom: 1px solid #e8eee9; background: linear-gradient(135deg,#f4fbf7,#fff); padding: 12px 14px 12px 16px; }
    .coze-assistant__avatar { display: grid; flex: 0 0 auto; place-items: center; width: 40px; height: 40px; border-radius: 13px; background: #27ae60; color: #fff; box-shadow: 0 8px 18px rgba(39,174,96,.24); }
    .coze-assistant__avatar svg { width: 21px; height: 21px; }
    .coze-assistant__heading { min-width: 0; flex: 1; }
    .coze-assistant__title { margin: 0; color: #1c2b24; font-size: .98rem; font-weight: 700; }
    .coze-assistant__status { display: flex; align-items: center; gap: 6px; margin-top: 3px; color: #6d7d74; font-size: .75rem; }
    .coze-assistant__status::before { width: 7px; height: 7px; border-radius: 50%; background: #27ae60; content: ""; }
    .coze-assistant__close { display: grid; flex: 0 0 auto; place-items: center; width: 44px; height: 44px; border: 0; border-radius: 12px; background: transparent; color: #64736b; cursor: pointer; transition: background-color .18s ease, color .18s ease; }
    .coze-assistant__close:hover { background: #eaf5ee; color: #238d52; }
    .coze-assistant__close svg { width: 20px; height: 20px; }
    .coze-assistant__body { position: relative; flex: 1; min-height: 0; background: #f8faf9; }
    .coze-assistant__mount { position: absolute; inset: 0; overflow: hidden; background: #fff; }
    .coze-assistant__mount > * { width: 100% !important; height: 100% !important; min-height: 100% !important; border: 0 !important; }
    .coze-assistant__state { position: absolute; inset: 0; z-index: 2; display: grid; place-items: center; background: linear-gradient(180deg,#f9fcfa,#f4f8f5); color: #627168; padding: 30px; text-align: center; }
    .coze-assistant__state[hidden] { display: none; }
    .coze-assistant__state-icon { display: grid; place-items: center; width: 54px; height: 54px; margin: 0 auto 16px; border-radius: 17px; background: #e7f5ec; color: #238d52; }
    .coze-assistant__state-icon svg { width: 26px; height: 26px; }
    .coze-assistant__state h3 { margin: 0 0 8px; color: #1f3027; font-size: 1rem; }
    .coze-assistant__state p { max-width: 280px; margin: 0; font-size: .82rem; line-height: 1.75; }
    .coze-assistant__loader { width: 28px; height: 28px; margin: 0 auto 16px; border: 3px solid #cfe8d8; border-top-color: #27ae60; border-radius: 50%; animation: coze-spin .8s linear infinite; }
    .coze-assistant__retry { min-height: 42px; margin-top: 18px; border: 0; border-radius: 11px; background: #27ae60; color: #fff; padding: 0 18px; font-weight: 600; cursor: pointer; }
    .coze-assistant__hint { margin-right: 10px; margin-bottom: 10px; border: 1px solid rgba(39,174,96,.15); border-radius: 999px; background: rgba(255,255,255,.96); color: #315543; padding: 8px 13px; box-shadow: 0 8px 24px rgba(31,78,54,.12); font-size: .78rem; opacity: 1; pointer-events: none; transform: translateY(0); transition: opacity .2s ease, transform .2s ease; }
    .coze-assistant.is-open .coze-assistant__hint,
    .coze-assistant.has-opened .coze-assistant__hint { opacity: 0; transform: translateY(6px); }
    @keyframes coze-pulse { 0% { opacity: .7; transform: scale(.88); } 80%,100% { opacity: 0; transform: scale(1.35); } }
    @keyframes coze-spin { to { transform: rotate(360deg); } }

    @media (max-width: 768px) {
      .checkin-fab {
        bottom: 20px;
        right: 20px;
        padding: 12px 18px;
        font-size: 0.85rem;
        gap: 6px;
      }
      .checkin-fab__icon {
        font-size: 1.2rem;
      }
      .coze-assistant { right: 20px; bottom: 84px; }
      .coze-assistant__launcher { width: 56px; height: 56px; }
      .coze-assistant__panel { bottom: 70px; width: calc(100vw - 32px); height: min(640px, calc(100dvh - 124px)); }
      .coze-assistant__hint { display: none; }
      .home-region-layout { grid-template-columns: 1fr !important; }
    }
    @media (max-width: 480px) {
      .coze-assistant__panel { position: fixed; inset: 76px 16px 84px; width: auto; height: auto; min-height: 0; transform-origin: bottom right; }
    }
    @media (prefers-reduced-motion: reduce) {
      .coze-assistant__launcher,
      .coze-assistant__panel,
      .coze-assistant__launcher svg,
      .coze-assistant__hint { transition: none; }
      .coze-assistant__pulse,
      .coze-assistant__loader { animation: none; }
    }
  </style>
</head>
<body data-page="home">
  <div class="page-shell">
    <%@ include file="/WEB-INF/jspf/header.jspf" %>
    <main class="page-main">

      <!-- ===== 1. Hero区域（增强版） ===== -->
      <section class="hero-enhanced">
        <div class="hero-enhanced__bg">
          <img src="${pageContext.request.contextPath}/assets/images/hero-bg.jpg" alt="公益志愿服务">
        </div>
        <canvas class="hero-enhanced__particles" id="heroParticles"></canvas>
        <div class="hero-enhanced__content">
          <div class="hero-badge">
            <span class="hero-badge__dot"></span>
            宁夏大学 · 求是书院 · 信息工程学院 · 软件工程2024
          </div>
          <h1 class="hero-main-title">让每一份善意，<br>都有迹可循</h1>
          <p class="hero-sub-desc">
            城市公益活动报名与志愿时长管理平台 —— 为志愿者与组织者搭建高效、透明、温暖的数字化桥梁
          </p>
          <div class="hero-actions">
            <a class="hero-btn hero-btn--primary" href="${pageContext.request.contextPath}/activities.jsp">
              <span>🚀</span> 探索活动
            </a>
            <a class="hero-btn hero-btn--outline" href="#features">
              <span>📖</span> 了解更多
            </a>
          </div>
          <div class="hero-stats-row">
            <div class="hero-stat-item">
              <div class="hero-stat-num">2,847+</div>
              <div class="hero-stat-label">注册志愿者</div>
            </div>
            <div class="hero-stat-item">
              <div class="hero-stat-num">186+</div>
              <div class="hero-stat-label">公益活动</div>
            </div>
            <div class="hero-stat-item">
              <div class="hero-stat-num">12,580</div>
              <div class="hero-stat-label">服务时长(小时)</div>
            </div>
            <div class="hero-stat-item">
              <div class="hero-stat-num">42</div>
              <div class="hero-stat-label">覆盖社区</div>
            </div>
          </div>
        </div>
        <div class="hero-scroll-indicator">
          <span>Scroll</span>
          <div class="hero-scroll-line"></div>
        </div>
      </section>

      <!-- ===== 1.5. 通知跑马灯 ===== -->
      <section style="background:linear-gradient(90deg,#27ae60,#2ecc71,#27ae60);padding:14px 0;overflow:hidden;position:relative;z-index:1;">
        <div class="container" style="display:flex;align-items:center;gap:16px;justify-content:center;flex-wrap:wrap;">
          <span style="background:rgba(255,255,255,0.2);color:#fff;padding:4px 14px;border-radius:999px;font-size:0.76rem;font-weight:600;white-space:nowrap;">📢 最新动态</span>
          <div style="overflow:hidden;flex:1;min-width:260px;position:relative;height:24px;">
            <div id="homeNewsTicker" style="position:absolute;white-space:nowrap;color:rgba(255,255,255,0.95);font-size:0.88rem;animation:homeTicker 18s linear infinite;">
              🎉「社区绿化角落认养计划」已有62人报名，成为本月最热活动 &nbsp;&nbsp;|&nbsp;&nbsp; 🏅 恭喜用户"王磊"服务时长突破30小时，解锁中级志愿者称号 &nbsp;&nbsp;|&nbsp;&nbsp; 🗺️ 热力地图新上线银川市7大区域志愿热度分布 &nbsp;&nbsp;|&nbsp;&nbsp; 📊 平台本月新增志愿者156人，累计注册2,847人
            </div>
          </div>
        </div>
      </section>
      <style>
        @keyframes homeTicker { 0%{transform:translateX(100%);} 100%{transform:translateX(-100%);} }
      </style>

      <!-- ===== 1.8. 快速入门 ===== -->
      <section class="quickstart-section">
        <div class="container">
          <div class="text-center mb-5 reveal">
            <p class="eyebrow">快速入门</p>
            <h2 class="headline headline-lg">三步开启你的公益之旅</h2>
            <p class="copy-soft" style="max-width:560px;margin:12px auto 0;">只需简单三步，即可成为志愿星河的一员</p>
          </div>
          <div class="qs-steps">
            <div class="qs-card">
              <div class="qs-number">01</div>
              <div class="qs-icon">📝</div>
              <h3 class="qs-title">注册账号</h3>
              <p class="qs-desc">填写基本信息，选择你的志愿服务偏好，完成身份认证。</p>
            </div>
            <div class="qs-arrow">&rarr;</div>
            <div class="qs-card">
              <div class="qs-number">02</div>
              <div class="qs-icon">🔍</div>
              <h3 class="qs-title">浏览活动</h3>
              <p class="qs-desc">按分类、区域、时间筛选感兴趣的公益活动，了解活动详情。</p>
            </div>
            <div class="qs-arrow">&rarr;</div>
            <div class="qs-card">
              <div class="qs-number">03</div>
              <div class="qs-icon">✅</div>
              <h3 class="qs-title">报名参与</h3>
              <p class="qs-desc">一键报名，现场签到签退，自动记录服务时长，积累公益足迹。</p>
            </div>
          </div>
        </div>
      </section>

      <!-- ===== 2. 核心功能 ===== -->
      <section class="features-section" id="features">
        <div class="home-orb home-orb--green-top"></div>
        <div class="container" style="position:relative;z-index:1;">
          <div class="text-center mb-5 reveal">
            <p class="eyebrow">核心功能</p>
            <h2 class="headline headline-lg">一站式志愿管理，让公益更简单</h2>
            <p class="copy-soft" style="max-width:600px;margin:14px auto 0;">覆盖从活动发布、在线报名、签到签退到时长认证的完整业务流程</p>
          </div>
          <div class="grid grid--3 stagger-list">
            <!-- 功能1 -->
            <div class="feature-card" data-feature-card>
              <div class="feature-icon-ring" style="background:rgba(39,174,96,0.1);">📋</div>
              <h3>活动发布与管理</h3>
              <p>管理员一键发布公益活动，支持活动详情编辑、状态管理、签到二维码生成，全程数字化运营。</p>
            </div>
            <!-- 功能2 -->
            <div class="feature-card" data-feature-card>
              <div class="feature-icon-ring" style="background:rgba(91,155,213,0.1);">✅</div>
              <h3>在线报名与审核</h3>
              <p>志愿者浏览活动列表，一键报名。管理员在线审核申请，支持批量操作与报名数据导出。</p>
            </div>
            <!-- 功能3 -->
            <div class="feature-card" data-feature-card>
              <div class="feature-icon-ring" style="background:rgba(240,193,75,0.12);">📱</div>
              <h3>签到签退系统</h3>
              <p>动态签到码 + 地理位置校验，确保出勤真实有效。自动计算服务时长，杜绝人工统计误差。</p>
            </div>
            <!-- 功能4 -->
            <div class="feature-card" data-feature-card>
              <div class="feature-icon-ring" style="background:rgba(232,99,75,0.1);">⏱</div>
              <h3>志愿时长认证</h3>
              <p>多源时长汇总：签到自动记录 + 管理员录入 + 自主申请审核。区块链式溯源，防篡改可信。</p>
            </div>
            <!-- 功能5 -->
            <div class="feature-card" data-feature-card>
              <div class="feature-icon-ring" style="background:rgba(155,126,217,0.1);">📊</div>
              <h3>数据可视化看板</h3>
              <p>热力地图展示区域志愿热度，3D时间轴回顾公益历程，多维度图表呈现服务数据。</p>
            </div>
            <!-- 功能6 -->
            <div class="feature-card" data-feature-card>
              <div class="feature-icon-ring" style="background:rgba(39,174,96,0.1);">🏅</div>
              <h3>成就徽章系统</h3>
              <p>累积服务时长解锁专属徽章，从初级志愿者到公益之星，每一步成长都有荣誉见证。</p>
            </div>
          </div>
        </div>
      </section>

      <!-- ===== 3. 实时数据看板 ===== -->
      <section class="live-dashboard">
        <canvas class="story-particles" data-story-particles></canvas>
        <div class="container" style="position:relative;z-index:2;">
          <div class="text-center mb-5">
            <div class="live-badge" style="margin:0 auto 12px;width:fit-content;">
              <span class="live-badge__dot"></span> LIVE
            </div>
            <h2 class="headline headline-lg" style="color:#fff;">志愿星河 · 实时数据</h2>
            <p style="color:rgba(255,255,255,0.6);max-width:560px;margin:12px auto 0;">每一次签到，都在点亮一颗星。每一份善意，都汇入数据的星河。</p>
          </div>
          <div class="counter-cards" data-counter-section>
            <div class="counter-card" style="--accent-color:#27ae60;">
              <div class="counter-value" data-counter="12580" style="color:#27ae60;">0</div>
              <div class="counter-label">服务时长累计（小时）</div>
              <div class="counter-change counter-change--up">↑ 23% 本月新增</div>
            </div>
            <div class="counter-card" style="--accent-color:#5b9bd5;">
              <div class="counter-value" data-counter="2847" style="color:#5b9bd5;">0</div>
              <div class="counter-label">平台注册志愿者（人）</div>
              <div class="counter-change counter-change--up">↑ 156 本月新增</div>
            </div>
            <div class="counter-card" style="--accent-color:#f0c14b;">
              <div class="counter-value" data-counter="186" style="color:#f0c14b;">0</div>
              <div class="counter-label">累计公益活动（场）</div>
              <div class="counter-change counter-change--up">↑ 12 本月新增</div>
            </div>
            <div class="counter-card" style="--accent-color:#e8634b;">
              <div class="counter-value" data-counter="42" style="color:#e8634b;">0</div>
              <div class="counter-label">覆盖社区数量（个）</div>
              <div class="counter-change counter-change--up">↑ 5 本月新增</div>
            </div>
          </div>
        </div>
      </section>

      <!-- ===== 3.5. 区域热力图预览 + 活动倒计时 ===== -->
      <section class="section" style="background:#fff;">
        <div class="container">
          <div class="home-region-layout" style="display:grid;grid-template-columns:1fr 1fr;gap:32px;align-items:start;">
            <!-- 区域数据卡片 -->
            <div>
              <p class="eyebrow">覆盖区域</p>
              <h2 class="headline headline-md" style="margin-bottom:20px;">银川市七区联动，公益全覆盖</h2>
              <div id="homeRegionList" style="display:flex;flex-direction:column;gap:10px;"></div>
            </div>
            <!-- 活动倒计时 -->
            <div class="panel" style="padding:28px;border-radius:20px;background:linear-gradient(135deg,#f0fdf4,#fff);border:1px solid rgba(39,174,96,0.15);">
              <p class="eyebrow">即将开始</p>
              <h3 class="headline headline-md" style="margin-bottom:4px;">⏰ 倒计时提醒</h3>
              <p class="copy-soft" style="font-size:0.86rem;margin-bottom:20px;">最近的即将开始活动，不要错过</p>
              <div id="homeCountdownList" style="display:flex;flex-direction:column;gap:14px;"></div>
              <a class="button button--primary" href="${pageContext.request.contextPath}/activities.jsp" style="width:100%;margin-top:20px;">查看所有即将开始的活动 →</a>
            </div>
          </div>
        </div>
      </section>

      <!-- ===== 4. 项目缘起时间轴 ===== -->
      <section id="timeline" class="section" style="background:#f8f8f8;position:relative;overflow:hidden;">
        <div style="position:absolute;inset:0;pointer-events:none;background-image:linear-gradient(rgba(39,174,96,.025) 1px, transparent 1px),linear-gradient(90deg,rgba(39,174,96,.025) 1px, transparent 1px);background-size:60px 60px;"></div>
        <div style="position:absolute;top:-80px;left:10%;width:200px;height:200px;border-radius:50%;background:radial-gradient(circle,rgba(240,193,75,.1),transparent 70%);filter:blur(50px);pointer-events:none;"></div>
        <div class="container">
          <div class="text-center mb-5 reveal">
            <p class="eyebrow">项目缘起</p>
            <h2 class="headline headline-lg">五个人的团队，一座城市的温度</h2>
            <p class="copy-soft" style="max-width:560px;margin:12px auto 0;">从需求调研到最终交付，50天全流程记录</p>
          </div>
          <div class="timeline" data-home-timeline></div>
        </div>
      </section>

      <!-- ===== 5. 平台优势 ===== -->
      <section class="advantages-section">
        <div class="home-orb home-orb--blue-mid"></div>
        <div class="container" style="position:relative;z-index:1;">
          <div class="text-center mb-5 reveal">
            <p class="eyebrow">平台优势</p>
            <h2 class="headline headline-lg">为什么选择志愿星河？</h2>
          </div>
          <div class="grid grid--2 stagger-list">
            <div class="advantage-card">
              <div class="advantage-icon" style="background:rgba(39,174,96,0.1);">🔐</div>
              <div>
                <h4>安全可靠</h4>
                <p>BCrypt密码加密、防SQL注入、防XSS攻击，多重安全防护体系保障用户数据安全。</p>
              </div>
            </div>
            <div class="advantage-card">
              <div class="advantage-icon" style="background:rgba(91,155,213,0.1);">⚡</div>
              <div>
                <h4>高效便捷</h4>
                <p>在线报名一键提交，动态签到码即扫即签，自动计算服务时长，省去繁琐的人工流程。</p>
              </div>
            </div>
            <div class="advantage-card">
              <div class="advantage-icon" style="background:rgba(240,193,75,0.12);">📈</div>
              <div>
                <h4>数据驱动</h4>
                <p>多维度可视化报表，热力地图、趋势图表、时长排名，让公益数据说话。</p>
              </div>
            </div>
            <div class="advantage-card">
              <div class="advantage-icon" style="background:rgba(155,126,217,0.1);">🌐</div>
              <div>
                <h4>开放互联</h4>
                <p>标准RESTful API接口，支持与其他公益平台数据互通，构建开放的志愿服务生态。</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ===== 5.5. 本月数据简报 ===== -->
      <section class="monthly-section">
        <div class="container">
          <div class="text-center mb-5 reveal">
            <p class="eyebrow">数据简报</p>
            <h2 class="headline headline-lg">本月志愿服务数据一览</h2>
            <p class="copy-soft" style="max-width:500px;margin:12px auto 0;">实时追踪平台志愿服务动态，让数据见证每一份善意</p>
          </div>
          <div class="monthly-cards">
            <div class="monthly-card">
              <div class="monthly-value">+156</div>
              <div class="monthly-change"><span>&uarr;</span> 12.5%</div>
              <div class="monthly-label">本月新增志愿者</div>
            </div>
            <div class="monthly-card">
              <div class="monthly-value">+12</div>
              <div class="monthly-change"><span>&uarr;</span> 8.3%</div>
              <div class="monthly-label">本月活动场次</div>
            </div>
            <div class="monthly-card">
              <div class="monthly-value">2,340h</div>
              <div class="monthly-change"><span>&uarr;</span> 23.1%</div>
              <div class="monthly-label">本月服务时长</div>
            </div>
            <div class="monthly-card">
              <div class="monthly-value">+5</div>
              <div class="monthly-change"><span>&uarr;</span> 13.5%</div>
              <div class="monthly-label">本月新增社区</div>
            </div>
          </div>
        </div>
      </section>

      <!-- ===== 6. 近期活动 ===== -->
      <section class="section" style="background:#fff;">
        <div class="container">
          <div class="text-center mb-5 reveal">
            <p class="eyebrow">正在进行</p>
            <h2 class="headline headline-lg">近期公益活动</h2>
            <p class="copy-soft" style="max-width:500px;margin:12px auto 0;">加入一场活动，开启你的公益之旅</p>
          </div>
          <div class="grid grid--4 stagger-list" data-home-activities-advanced></div>
          <div class="text-center mt-5">
            <a class="hero-btn hero-btn--primary" href="${pageContext.request.contextPath}/activities.jsp" style="display:inline-flex;text-decoration:none;">
              查看更多活动 →
            </a>
          </div>
        </div>
      </section>

      <!-- ===== 7. 用户评价 ===== -->
      <section class="section section--dark section--grain">
        <div class="home-orb home-orb--gold-low" style="opacity:0.3;"></div>
        <div class="container" style="position:relative;z-index:1;">
          <div class="text-center mb-5 reveal">
            <p class="copy-light" style="letter-spacing:.08em;">他们这样说</p>
            <h2 class="headline headline-lg" style="color:#fff;">志愿星河里的微光</h2>
          </div>
          <div class="grid grid--3 stagger-list" data-home-testimonials></div>
        </div>
      </section>

      <!-- ===== 7.5. 最新公告 ===== -->
      <section class="announce-section">
        <div class="container">
          <div class="text-center mb-5 reveal">
            <p class="eyebrow">平台公告</p>
            <h2 class="headline headline-lg">最新通知与动态</h2>
          </div>
          <div class="announce-list">
            <div class="announce-card">
              <span class="announce-date">2026-07-10</span>
              <h3 class="announce-title">【系统维护通知】7月15日凌晨服务器升级公告</h3>
              <p class="announce-desc">为提升平台服务稳定性，计划于7月15日（周三）凌晨2:00至5:00进行服务器维护升级，届时平台将暂停访问。请各位志愿者与组织者提前做好安排，维护完成后所有功能将恢复正常。如有紧急活动管理需求，请提前处理。感谢您的理解与配合。</p>
            </div>
            <div class="announce-card">
              <span class="announce-date">2026-07-08</span>
              <h3 class="announce-title">【活动变更】"银川湿地保护行动"时间调整通知</h3>
              <p class="announce-desc">原定于7月18日的"银川湿地保护行动"因天气原因调整至7月25日（周六）举行，活动地点及内容不变。已报名志愿者无需重新报名，届时将自动更新报名信息。如需取消报名，可在活动详情页自助操作。给您带来不便，敬请谅解。</p>
            </div>
            <div class="announce-card">
              <span class="announce-date">2026-07-05</span>
              <h3 class="announce-title">【新功能上线】智能活动匹配与志愿者活跃榜正式发布</h3>
              <p class="announce-desc">志愿星河平台全新上线两大功能：智能活动匹配（通过问答精准推荐适合您的公益活动）与志愿者活跃榜（实时展示服务时长排行）。访问活动中心页面即可体验，点击右下角悬浮按钮启动。我们将持续优化平台体验，欢迎反馈意见。</p>
            </div>
          </div>
        </div>
      </section>

      <!-- ===== 8. 加入号召 ===== -->
      <section class="section bg-primary" style="position:relative;overflow:hidden;">
        <canvas class="story-particles" data-story-particles-cta></canvas>
        <div class="container" style="position:relative;z-index:1;max-width:720px;text-align:center;">
          <h2 class="headline headline-lg" style="color:#fff;">加入我们，让善意有迹可循</h2>
          <p class="copy-light" style="margin:18px 0 30px;">
            无论你是想参与公益的志愿者，还是需要管理工具的组织者<br>志愿星河都在这里等你
          </p>
          <a class="hero-btn hero-btn--outline" href="${pageContext.request.contextPath}/activities.jsp" style="border-color:rgba(255,255,255,0.6);color:#fff;display:inline-flex;text-decoration:none;">
            立即加入 →
          </a>
        </div>
      </section>

    </main>
    <%@ include file="/WEB-INF/jspf/footer.jspf" %>
  </div>

  <script>
    window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
    window.APP_USER_ROLE = "<%= displayRole %>";
    window.APP_USER_NAME = "<%= displayName %>";
  </script>
  <script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/data.js"></script>
  <script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/points.js"></script>
  <script>
  (function () {
    /* ===== Hero粒子动画 ===== */
    var heroCanvas = document.getElementById('heroParticles');
    if (heroCanvas) {
      var hctx = heroCanvas.getContext('2d');
      var hParticles = [];

      function resizeHeroCanvas() {
        var section = heroCanvas.closest('.hero-enhanced');
        if (!section) return;
        heroCanvas.width = section.offsetWidth;
        heroCanvas.height = section.offsetHeight;
      }
      resizeHeroCanvas();
      window.addEventListener('resize', resizeHeroCanvas);

      for (var i = 0; i < 35; i++) {
        hParticles.push({
          x: Math.random() * heroCanvas.width,
          y: Math.random() * heroCanvas.height,
          vx: (Math.random() - 0.5) * 0.3,
          vy: (Math.random() - 0.5) * 0.3 - 0.2,
          r: Math.random() * 2 + 0.5,
          alpha: Math.random() * 0.4 + 0.15
        });
      }

      function drawHero() {
        if (!heroCanvas || heroCanvas.width === 0) return;
        hctx.clearRect(0, 0, heroCanvas.width, heroCanvas.height);
        for (var i = 0; i < hParticles.length; i++) {
          var p = hParticles[i];
          hctx.beginPath();
          hctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
          hctx.fillStyle = 'rgba(255,255,255,' + p.alpha + ')';
          hctx.fill();
          p.x += p.vx;
          p.y += p.vy;
          if (p.y < -10) { p.y = heroCanvas.height + 10; p.x = Math.random() * heroCanvas.width; }
          if (p.x < -10) p.x = heroCanvas.width + 10;
          if (p.x > heroCanvas.width + 10) p.x = -10;
        }
        requestAnimationFrame(drawHero);
      }
      drawHero();
    }

    /* ===== 滚动计数动画 ===== */
    var counterSection = document.querySelector('[data-counter-section]');
    var counters = document.querySelectorAll('[data-counter]');
    var countersAnimated = false;

    function animateCounter(el) {
      var target = parseInt(el.getAttribute('data-counter'));
      if (isNaN(target)) return;
      var current = 0;
      var duration = 2000;
      var step = Math.max(1, Math.floor(target / (duration / 16)));
      var timer = setInterval(function () {
        current += step;
        if (current >= target) {
          current = target;
          clearInterval(timer);
        }
        el.textContent = current.toLocaleString();
      }, 16);
    }

    function checkCounters() {
      if (!counterSection || countersAnimated) return;
      var rect = counterSection.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.8 && rect.bottom > 0) {
        countersAnimated = true;
        counters.forEach(animateCounter);
      }
    }
    window.addEventListener('scroll', checkCounters);
    checkCounters();

    /* ===== 功能卡片鼠标光效 ===== */
    document.querySelectorAll('[data-feature-card]').forEach(function (card) {
      card.addEventListener('mousemove', function (e) {
        var rect = card.getBoundingClientRect();
        var x = ((e.clientX - rect.left) / rect.width) * 100;
        var y = ((e.clientY - rect.top) / rect.height) * 100;
        card.style.setProperty('--mx', x + '%');
        card.style.setProperty('--my', y + '%');
      });
    });

    /* ===== 活动卡片增强渲染 ===== */
    var activitiesWrap = document.querySelector('[data-home-activities-advanced]');
    if (activitiesWrap && window.VolunteerStarData && window.VolunteerStarData.activities) {
      var acts = window.VolunteerStarData.activities.slice(0, 8);
      var ctxPath = window.APP_CONTEXT_PATH || '';
      acts.forEach(function (a) {
        var card = document.createElement('div');
        card.className = 'activity-card-advanced';
        var enrolled = a.enrolled || 0;
        var capacity = a.capacity || 1;
        var pct = Math.round((enrolled / capacity) * 100);
        card.innerHTML =
          '<div class="activity-card-advanced__media">' +
            '<img src="' + ctxPath + '/' + a.image + '" alt="' + a.title + '" loading="lazy">' +
            '<span class="activity-card-advanced__badge" style="background:' + (a.categoryColor || '#27ae60') + ';">' + (a.category || '') + '</span>' +
            '<span class="activity-card-advanced__status" style="background:rgba(39,174,96,0.9);color:#fff;">' + (a.statusLabel || '招募中') + '</span>' +
          '</div>' +
          '<div class="activity-card-advanced__body">' +
            '<h3 class="activity-card-advanced__title">' + a.title + '</h3>' +
            '<div class="activity-card-advanced__meta">' +
              '<span>📅 ' + a.date + '</span>' +
              '<span>📍 ' + a.location + '</span>' +
            '</div>' +
            '<div class="activity-progress">' +
              '<div class="activity-progress__info"><span>已报名 ' + enrolled + '/' + capacity + '</span><span>' + pct + '%</span></div>' +
              '<div class="activity-progress__bar"><div class="activity-progress__fill" style="width:' + pct + '%;"></div></div>' +
            '</div>' +
          '</div>';
        card.addEventListener('click', function () {
          window.location.href = ctxPath + '/activities.jsp?id=' + encodeURIComponent(a.id);
        });
        activitiesWrap.appendChild(card);
      });
    }

    /* ===== 原有数据区域渲染（兼容） ===== */
    // 时间轴
    var timelineWrap = document.querySelector('[data-home-timeline]');
    if (timelineWrap && window.VolunteerStarData && window.VolunteerStarData.timelineData) {
      window.VolunteerStarData.timelineData.forEach(function (item) {
        var div = document.createElement('div');
        div.className = 'timeline__item reveal';
        div.innerHTML =
          '<div class="timeline__dot"></div>' +
          '<div class="timeline__card">' +
            '<div class="mono" style="color:#27ae60;font-size:0.85rem;">Phase ' + item.phase + '</div>' +
            '<h3 style="margin:8px 0 4px;font-family:var(--font-serif);">' + item.title + '</h3>' +
            '<p style="color:var(--color-text-soft);font-size:0.88rem;">' + item.subtitle + '</p>' +
            '<p style="margin-top:10px;line-height:1.7;font-size:0.9rem;">' + item.description + '</p>' +
            '<span style="font-size:0.76rem;color:#94a3b8;">' + item.dayRange + '</span>' +
          '</div>';
        timelineWrap.appendChild(div);
      });
    }

    // 评价
    var testWrap = document.querySelector('[data-home-testimonials]');
    if (testWrap && window.VolunteerStarData && window.VolunteerStarData.testimonials) {
      var ctxPath = window.APP_CONTEXT_PATH || '';
      testWrap.innerHTML = '';
      window.VolunteerStarData.testimonials.forEach(function (t) {
        var div = document.createElement('div');
        div.className = 'panel panel--dark';
        div.style.cssText = 'padding:28px;border-radius:24px;';
        div.innerHTML =
          '<div style="display:flex;align-items:center;gap:14px;margin-bottom:16px;">' +
            '<img src="' + ctxPath + '/' + t.avatar + '" alt="' + t.name + '" style="width:48px;height:48px;border-radius:50%;object-fit:cover;border:2px solid rgba(255,255,255,0.2);" loading="lazy">' +
            '<div><div style="font-weight:600;">' + t.name + '</div><div style="font-size:0.82rem;color:rgba(255,255,255,0.6);">' + t.role + '</div></div>' +
          '</div>' +
          '<p style="color:rgba(255,255,255,0.85);line-height:1.8;font-size:0.94rem;">"' + t.content + '"</p>';
        testWrap.appendChild(div);
      });
    }

    /* ===== 滚动显示动画 ===== */
    var revealItems = document.querySelectorAll('.reveal, .stagger-list');
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
        }
      });
    }, { threshold: 0.15 });
    revealItems.forEach(function (el) { observer.observe(el); });

    setTimeout(function () {
      revealItems.forEach(function (el) {
        var rect = el.getBoundingClientRect();
        if (rect.top < window.innerHeight) {
          el.classList.add('is-visible');
        }
      });
    }, 100);

    /* ===== 区域覆盖列表 ===== */
    var regionList = document.getElementById('homeRegionList');
    if (regionList && window.VolunteerStarData && window.VolunteerStarData.regionData) {
      var regData = window.VolunteerStarData.regionData;
      var maxR = Math.max.apply(null, regData.map(function(r){return r.activityCount;}));
      var colors = ['#ef4444','#f97316','#facc15','#22c55e','#22c55e','#22c55e','#22c55e'];
      regData.forEach(function(r, idx){
        var pct = Math.round((r.activityCount/maxR)*100);
        regionList.innerHTML +=
          '<div style="display:flex;align-items:center;gap:14px;padding:12px 16px;border-radius:12px;background:#f8fafc;border:1px solid #e8ecf1;cursor:pointer;transition:all 0.25s;" onclick="location.href=\''+(window.APP_CONTEXT_PATH||'')+'/heatmap.jsp\'">' +
            '<span style="width:36px;height:36px;border-radius:10px;background:'+(colors[idx]||'#22c55e')+';display:flex;align-items:center;justify-content:center;color:#fff;font-family:Roboto Mono;font-weight:700;font-size:0.85rem;">'+(idx+1)+'</span>' +
            '<div style="flex:1;"><div style="font-weight:600;font-size:0.92rem;">'+r.name+'</div>' +
              '<div style="font-size:0.76rem;color:#94a3b8;">'+r.activityCount+'场活动 · '+r.participants+'人次 · '+r.totalHours+'小时</div></div>' +
            '<div style="width:80px;height:5px;border-radius:999px;background:#e8ecf1;"><div style="height:100%;border-radius:999px;background:'+(colors[idx]||'#22c55e')+';width:'+pct+'%;"></div></div>' +
          '</div>';
      });
    }

    /* ===== 活动倒计时 ===== */
    var cdList = document.getElementById('homeCountdownList');
    if (cdList && window.VolunteerStarData && window.VolunteerStarData.activities) {
      var upcoming = window.VolunteerStarData.activities.filter(function(a){return a.status==='upcoming';}).slice(0,4);
      upcoming.forEach(function(a, i){
        var daysLeft = 3 + i * 3 + Math.floor(Math.random()*5);
        var urgencyColor = daysLeft <= 3 ? '#ef4444' : daysLeft <= 7 ? '#f97316' : '#22c55e';
        cdList.innerHTML +=
          '<div style="display:flex;align-items:center;gap:12px;padding:10px 14px;border-radius:10px;background:#fff;border:1px solid #e8ecf1;">' +
            '<div style="width:44px;height:44px;border-radius:12px;background:'+urgencyColor+'15;display:flex;align-items:center;justify-content:center;flex-direction:column;flex-shrink:0;">' +
              '<span style="font-family:Roboto Mono;font-weight:700;font-size:1.1rem;color:'+urgencyColor+';">'+daysLeft+'</span>' +
              '<span style="font-size:0.6rem;color:'+urgencyColor+';">天后</span>' +
            '</div>' +
            '<div style="flex:1;min-width:0;">' +
              '<div style="font-weight:500;font-size:0.9rem;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'+a.title+'</div>' +
              '<div style="font-size:0.74rem;color:#94a3b8;">'+a.date+' · '+a.location+'</div>' +
            '</div>' +
            '<span style="background:'+(a.categoryColor||'#27ae60')+';color:#fff;padding:3px 10px;border-radius:999px;font-size:0.7rem;white-space:nowrap;">'+a.statusLabel+'</span>' +
          '</div>';
      });
    }
  })();
  </script>

  <!-- ===== 扣子 AI 智能体：官方悬浮聊天组件 ===== -->
  <script src="https://lf-cdn.coze.cn/obj/unpkg/flow-platform/chat-app-sdk/1.2.0-beta.19/libs/cn/index.js"></script>
  <script>
  (function () {
    function fetchCozeConfig() {
      return fetch((window.APP_CONTEXT_PATH || '') + '/api/coze/config', {
        cache: 'no-store',
        headers: { 'Accept': 'application/json' }
      }).then(function (response) {
        return response.json().then(function (data) {
          if (!response.ok || !data.success) {
            throw new Error(data.message || '无法获取扣子智能体配置');
          }
          return data;
        });
      });
    }

    if (!window.CozeWebSDK || !window.CozeWebSDK.WebChatClient) {
      console.error('扣子 Chat App SDK 加载失败');
      return;
    }

    fetchCozeConfig().then(function (config) {
      new window.CozeWebSDK.WebChatClient({
        config: {
          bot_id: config.botId
        },
        componentProps: {
          title: '星河 AI 助手'
        },
        auth: {
          type: 'token',
          token: config.token,
          onRefreshToken: function () {
            return fetchCozeConfig().then(function (latest) {
              return latest.token;
            });
          }
        }
      });
    }).catch(function (error) {
      console.error('扣子智能体初始化失败:', error.message);
    });
  })();
  </script>

  <!-- ===== 每日签到大按钮 ===== -->
  <button id="checkinFab" class="checkin-fab" onclick="window.doCheckin(); updateCheckinButton();" title="每日签到获取积分">
    <span class="checkin-fab__icon">&#11088;</span>
    <span class="checkin-fab__text" id="checkinFabText">签到 +5</span>
  </button>
  <script>
  (function(){
    var btn = document.getElementById('checkinFab');
    var textEl = document.getElementById('checkinFabText');
    if(!btn || !textEl) return;

    window.updateCheckinButton = function(){
      if(window.canCheckin && window.canCheckin()){
        btn.classList.remove('checkin-fab--checked');
        btn.style.cursor = 'pointer';
        textEl.textContent = '签到 +5';
      } else {
        btn.classList.add('checkin-fab--checked');
        btn.style.cursor = 'default';
        textEl.textContent = '已签到 \u2713';
      }
    };

    if(window.canCheckin){
      updateCheckinButton();
    }

    window.addEventListener('pointsUpdated', function(){
      updateCheckinButton();
    });
  })();
  </script>
</body>
</html>

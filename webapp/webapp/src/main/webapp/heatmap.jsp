<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  request.setAttribute("currentPage", "heatmap");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>志愿星河 · 活动可视化分析</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.5.3/dist/MarkerCluster.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.5.3/dist/MarkerCluster.Default.css">
  <style>
    :root {
      --hm-green: #27AE60; --hm-dark: #2C3E50; --hm-gold: #F0C14B;
      --hm-blue: #5B9BD5; --hm-red: #E8634B; --hm-purple: #9B7ED9;
    }

    /* ===== HERO ===== */
    .hm-hero {
      position: relative; padding: 48px 0 32px; overflow: hidden;
      background: linear-gradient(165deg, #0a1628 0%, #132240 40%, #0d1f35 100%);
    }
    .hm-hero::before {
      content: ''; position: absolute; top: -180px; right: -100px;
      width: 500px; height: 500px; border-radius: 50%;
      background: radial-gradient(circle, rgba(39,174,96,.12), transparent 70%);
    }
    .hm-hero::after {
      content: ''; position: absolute; bottom: -120px; left: -80px;
      width: 400px; height: 400px; border-radius: 50%;
      background: radial-gradient(circle, rgba(91,155,213,.08), transparent 70%);
    }
    .hm-hero-grid {
      display: flex; align-items: flex-end; justify-content: space-between;
      gap: 32px; flex-wrap: wrap; position: relative; z-index: 1;
    }
    .hm-hero-title h1 {
      color: #fff; font-family: var(--font-serif); font-size: clamp(1.7rem,3vw,2.3rem);
      font-weight: 700; margin: 0 0 6px; letter-spacing: .04em;
    }
    .hm-hero-title p {
      color: rgba(255,255,255,.5); font-size: .86rem; margin: 0; max-width: 560px; line-height: 1.6;
    }
    .hm-hero-stats {
      display: flex; gap: 28px;
    }
    .hm-hero-stat {
      text-align: center; min-width: 72px;
    }
    .hm-hero-stat__val {
      font-family: var(--font-mono); font-size: 1.7rem; font-weight: 700; color: #fff; line-height: 1;
    }
    .hm-hero-stat__lbl {
      font-size: .7rem; color: rgba(255,255,255,.42); margin-top: 5px; letter-spacing: .06em;
    }
    .hm-hero-stat__divider {
      width: 1px; background: rgba(255,255,255,.1); align-self: stretch;
    }
    .hm-hero-filters {
      display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
      position: relative; z-index: 1; margin-top: 22px; padding-top: 18px;
      border-top: 1px solid rgba(255,255,255,.06);
    }
    .hm-hero-filters__lbl {
      font-size: .78rem; color: rgba(255,255,255,.4); margin-right: 6px; letter-spacing: .05em;
    }
    .hm-filter-chip {
      padding: 7px 20px; border-radius: 999px; font-size: .82rem; cursor: pointer;
      border: 1px solid rgba(255,255,255,.16); background: rgba(255,255,255,.05);
      color: rgba(255,255,255,.62); transition: all .25s; font-family: inherit;
      white-space: nowrap; backdrop-filter: blur(8px);
    }
    .hm-filter-chip:hover { border-color: var(--hm-green); color: var(--hm-green); }
    .hm-filter-chip.active { background: var(--hm-green); color: #fff; border-color: var(--hm-green); }

    /* ===== SECTION TITLES ===== */
    .hm-section {
      padding: 0; position: relative;
    }
    .hm-section__head {
      display: flex; align-items: center; gap: 10px; margin-bottom: 16px;
    }
    .hm-section__head h2 {
      font-family: var(--font-serif); font-size: 1.15rem; font-weight: 700;
      color: var(--color-text); margin: 0;
    }
    .hm-section__head .hm-section__badge {
      padding: 3px 10px; border-radius: 999px; font-size: .68rem;
      font-weight: 600; letter-spacing: .04em;
    }
    .hm-section__head p { color: var(--color-text-soft); font-size: .8rem; margin: 0; }

    /* ===== MAP 1: HEATMAP ===== */
    .hm-heat-section {
      background: #1a2d3d; padding: 24px 0 16px; position: relative;
    }
    .hm-heat-section::before {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 1px;
      background: linear-gradient(90deg, transparent, rgba(39,174,96,.3), rgba(91,155,213,.2), transparent);
    }
    .hm-map-card {
      width: min(1200px, calc(100% - 32px)); margin: 0 auto;
      height: 440px; border-radius: 18px; overflow: hidden;
      border: 1px solid rgba(255,255,255,.08);
      box-shadow: 0 8px 40px rgba(0,0,0,.35); background: #19202d;
    }
    .hm-map-card .leaflet-control-zoom { border: none!important; box-shadow: 0 2px 12px rgba(0,0,0,.35)!important; border-radius: 10px!important; }
    .hm-map-card .leaflet-control-zoom a {
      background: rgba(20,30,46,.94)!important; color: rgba(255,255,255,.65)!important;
      border: none!important; width: 34px!important; height: 34px!important;
      line-height: 34px!important; border-bottom: 1px solid rgba(255,255,255,.06)!important;
    }
    .hm-map-card .leaflet-control-zoom a:hover { background: var(--hm-green)!important; color: #fff!important; }
    .hm-map-card .leaflet-control-attribution {
      background: rgba(10,18,30,.7)!important; color: rgba(255,255,255,.28)!important; font-size: .52rem!important;
    }

    .hm-locate-row {
      display: flex; align-items: center; justify-content: center; gap: 8px;
      margin-top: 14px; flex-wrap: wrap;
    }
    .hm-locate-lbl { font-size: .74rem; color: rgba(255,255,255,.42); margin-right: 2px; letter-spacing: .04em; }
    .hm-locate-btn {
      padding: 5px 14px; border-radius: 999px; font-size: .75rem; cursor: pointer;
      border: 1px solid rgba(255,255,255,.12); background: rgba(255,255,255,.04);
      color: rgba(255,255,255,.55); transition: all .2s; font-family: inherit;
    }
    .hm-locate-btn:hover { background: rgba(39,174,96,.14); border-color: var(--hm-green); color: var(--hm-green); }
    .hm-locate-btn--reset { border-color: rgba(232,99,75,.25); color: var(--hm-red); }
    .hm-locate-btn--reset:hover { background: rgba(232,99,75,.1); border-color: var(--hm-red); }

    .hm-density-legend {
      display: flex; flex-direction: column; align-items: center; margin-top: 14px; gap: 5px;
    }
    .hm-density-legend__bar {
      display: flex; align-items: center; gap: 12px; color: rgba(255,255,255,.42); font-size: .7rem;
    }
    .hm-density-legend__gradient {
      width: 360px; height: 10px; border-radius: 5px;
      background: linear-gradient(90deg, #4B0082, #0000FF, #00FFFF, #00FF00, #FFFF00, #FFA500, #FF0000);
    }
    .hm-density-legend__labels {
      display: flex; justify-content: space-between; width: 360px;
      font-size: .6rem; color: rgba(255,255,255,.28);
    }
    .hm-density-legend__labels span { text-align: center; }

    /* ===== MAP 2: CLUSTER ===== */
    .hm-cluster-section {
      background: var(--color-bg); padding: 36px 0; position: relative;
    }
    .hm-cluster-section::before {
      content: ''; position: absolute; top: -40px; right: -30px;
      width: 200px; height: 200px; border-radius: 50%;
      background: radial-gradient(circle, rgba(39,174,96,.04), transparent 70%);
      pointer-events: none;
    }
    .hm-cluster-toolbar {
      display: flex; align-items: center; gap: 12px; flex-wrap: wrap; margin-bottom: 16px;
    }
    .hm-search-box {
      position: relative; flex: 1; max-width: 380px;
    }
    .hm-search-box input {
      width: 100%; height: 42px; padding: 0 44px 0 16px; border-radius: 10px;
      border: 1px solid #d1d5db; background: #fff;
      color: var(--color-text); font-size: .88rem; outline: none; transition: all .25s;
    }
    .hm-search-box input:focus { border-color: var(--hm-green); box-shadow: 0 0 0 3px rgba(39,174,96,.08); }
    .hm-search-box input::placeholder { color: #9ca3af; }
    .hm-search-box__clear {
      position: absolute; right: 36px; top: 50%; transform: translateY(-50%);
      color: #9ca3af; cursor: pointer; font-size: .8rem; display: none; z-index: 2;
    }
    .hm-search-box__icon {
      position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
      color: #9ca3af; font-size: .92rem; pointer-events: none;
    }

    .hm-cluster-map {
      width: min(1200px, calc(100% - 32px)); margin: 0 auto;
      height: 460px; border-radius: 18px; overflow: hidden;
      border: 1px solid #e2e8f0;
      box-shadow: 0 2px 20px rgba(0,0,0,.06); background: #f0f3f5;
    }
    .hm-cluster-map .leaflet-control-zoom { border: none!important; box-shadow: 0 2px 8px rgba(0,0,0,.06)!important; border-radius: 10px!important; }
    .hm-cluster-map .leaflet-control-zoom a {
      background: #fff!important; color: #374151!important;
      border: none!important; width: 32px!important; height: 32px!important; line-height: 32px!important;
      border-bottom: 1px solid #f1f5f9!important;
    }
    .hm-cluster-map .leaflet-control-zoom a:hover { background: #f0fdf4!important; color: var(--hm-green)!important; }
    .hm-cluster-map .leaflet-control-attribution {
      background: rgba(255,255,255,.75)!important; color: #9ca3af!important; font-size: .55rem!important;
    }

    .hm-cat-legend {
      display: flex; align-items: center; justify-content: center; gap: 16px;
      margin-top: 14px; flex-wrap: wrap;
    }
    .hm-cat-legend__item {
      display: inline-flex; align-items: center; gap: 5px;
      font-size: .72rem; color: var(--color-text-soft);
    }
    .hm-cat-legend__dot { width: 9px; height: 9px; border-radius: 2px; display: inline-block; }

    /* ===== DETAIL SHEET ===== */
    .hm-detail-sheet {
      width: min(1200px, calc(100% - 32px)); margin: 16px auto 0;
      border-radius: 16px; background: #fff; border: 1px solid #e2e8f0;
      box-shadow: 0 4px 24px rgba(0,0,0,.07);
      padding: 0; opacity: 0; max-height: 0; overflow: hidden;
      transition: all .4s cubic-bezier(.4,0,.2,1);
    }
    .hm-detail-sheet.open { opacity: 1; max-height: 700px; padding: 26px; }
    .hm-detail-sheet__head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
    .hm-detail-sheet__title { font-family: var(--font-serif); font-size: 1.1rem; font-weight: 700; color: var(--color-text); }
    .hm-detail-sheet__close {
      width: 34px; height: 34px; border-radius: 8px; border: 1px solid #e2e8f0;
      background: #f8fafc; color: #64748b; cursor: pointer;
      display: flex; align-items: center; justify-content: center; font-size: .95rem;
      transition: all .2s;
    }
    .hm-detail-sheet__close:hover { background: #fef2f2; border-color: #fca5a5; color: #ef4444; }
    .hm-detail-sheet__kpi { display: grid; grid-template-columns: repeat(4,1fr); gap: 12px; margin-bottom: 16px; }
    .hm-kpi-box {
      padding: 15px; border-radius: 12px; background: #f8fafc;
      border: 1px solid #e8ecf1; text-align: center; transition: transform .2s;
    }
    .hm-kpi-box:hover { transform: translateY(-2px); }
    .hm-kpi-box__val { font-family: var(--font-mono); font-size: 1.5rem; font-weight: 700; }
    .hm-kpi-box__lbl { font-size: .72rem; color: #94a3b8; margin-top: 2px; }
    .hm-detail-sheet__acts {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(270px,1fr));
      gap: 8px; max-height: 340px; overflow-y: auto;
    }
    .hm-detail-act {
      padding: 12px 14px; border-radius: 10px; background: #fff;
      border: 1px solid #e8ecf1; transition: all .2s; cursor: default;
    }
    .hm-detail-act:hover { border-color: rgba(39,174,96,.2); background: #f0fdf4; }
    .hm-detail-act__title { font-weight: 600; font-size: .86rem; color: var(--color-text); margin-bottom: 5px; }
    .hm-detail-act__tags { display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 5px; }
    .hm-detail-act__tag {
      padding: 1px 7px; border-radius: 4px; font-size: .66rem; font-weight: 500;
    }
    .hm-detail-act__meta {
      font-size: .71rem; color: #94a3b8; display: flex; gap: 12px; flex-wrap: wrap;
    }

    /* ===== DASHBOARD ===== */
    .hm-dash-section {
      padding: 56px 0; background: #f8fafc; border-top: 1px solid #f1f5f9;
      position: relative; overflow: hidden;
    }
    .hm-dash-section::before {
      content: ''; position: absolute; top: -70px; right: -50px;
      width: 280px; height: 280px; border-radius: 50%;
      background: radial-gradient(circle, rgba(39,174,96,.04), transparent 70%);
      pointer-events: none;
    }
    .hm-metrics-row {
      display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 32px;
    }
    .hm-metric-card {
      background: #fff; border: 1px solid #e8ecf1; border-radius: 16px;
      padding: 22px 18px; text-align: center; transition: all .3s;
      position: relative; overflow: hidden;
    }
    .hm-metric-card::after {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
    }
    .hm-metric-card:nth-child(1)::after { background: var(--hm-green); }
    .hm-metric-card:nth-child(2)::after { background: var(--hm-blue); }
    .hm-metric-card:nth-child(3)::after { background: var(--hm-gold); }
    .hm-metric-card:nth-child(4)::after { background: var(--hm-red); }
    .hm-metric-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-hover); }
    .hm-metric-card__icon { font-size: 1.5rem; margin-bottom: 8px; }
    .hm-metric-card__val { font-family: var(--font-mono); font-size: 1.7rem; font-weight: 700; }
    .hm-metric-card__lbl { font-size: .76rem; color: var(--color-text-soft); margin-top: 2px; }
    .hm-metric-card__sub { font-size: .7rem; margin-top: 6px; }

    .hm-dash-grid { display: grid; grid-template-columns: 1.6fr 1fr; gap: 24px; align-items: start; margin-bottom: 28px; }

    .hm-rank-list { display: flex; flex-direction: column; gap: 8px; }
    .hm-rank-item {
      display: flex; align-items: center; gap: 14px; padding: 14px 18px;
      border-radius: 14px; background: #fff; border: 1px solid #e8ecf1;
      cursor: pointer; transition: all .25s;
    }
    .hm-rank-item:hover { transform: translateX(4px); border-color: rgba(39,174,96,.3); box-shadow: var(--shadow-soft); }
    .hm-rank-item.active { border-color: var(--hm-green); background: #f0fdf4; box-shadow: 0 2px 14px rgba(39,174,96,.1); }
    .hm-rank-idx {
      width: 34px; height: 34px; border-radius: 10px; display: flex; align-items: center;
      justify-content: center; font-family: var(--font-mono); font-size: 1rem; font-weight: 700;
      color: #fff; flex-shrink: 0;
    }
    .hm-rank-body { flex: 1; min-width: 0; }
    .hm-rank-name { font-weight: 600; font-size: .9rem; color: var(--color-text); }
    .hm-rank-sub { font-size: .73rem; color: var(--color-text-soft); margin-top: 2px; }
    .hm-rank-bar-wrap { margin-top: 6px; }
    .hm-rank-bar { height: 6px; border-radius: 999px; background: #e8ecf1; overflow: hidden; }
    .hm-rank-bar__fill { height: 100%; border-radius: 999px; transition: width .8s; }

    .hm-chart-card {
      background: #fff; border: 1px solid #e8ecf1; border-radius: 16px;
      padding: 22px; margin-bottom: 16px; transition: all .25s;
    }
    .hm-chart-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-soft); }
    .hm-chart-card h4 { margin: 0 0 14px; font-size: .94rem; font-weight: 700; color: #374151; }

    .hm-bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }

    .hm-time-cols {
      display: flex; align-items: flex-end; justify-content: center; gap: 32px;
      padding: 12px 8px; min-height: 190px;
    }
    .hm-time-col {
      display: flex; flex-direction: column; align-items: center; gap: 8px; flex: 0 0 90px;
    }
    .hm-time-col__val { font-family: var(--font-mono); font-size: 1.15rem; font-weight: 700; }
    .hm-time-col__bar {
      width: 80%; border-radius: 8px 8px 0 0; min-height: 22px;
      transition: height .8s cubic-bezier(.34,1.56,.64,1);
    }
    .hm-time-col__lbl { font-size: .8rem; font-weight: 600; color: #374151; margin-top: 2px; }
    .hm-time-col__tm { font-size: .68rem; color: var(--color-text-soft); }

    .hm-cat-bars { display: flex; flex-direction: column; gap: 10px; }
    .hm-cat-row { display: flex; align-items: center; gap: 10px; }
    .hm-cat-row__lbl { width: 66px; font-size: .74rem; color: #374151; text-align: right; flex-shrink: 0; }
    .hm-cat-row__track { flex: 1; height: 28px; border-radius: 6px; background: #f1f5f9; overflow: hidden; }
    .hm-cat-row__fill {
      height: 100%; border-radius: 6px; transition: width 1s ease;
      display: flex; align-items: center; padding-left: 10px;
      font-size: .7rem; font-weight: 700; color: #fff;
    }
    .hm-cat-row__val {
      width: 64px; font-size: .73rem; color: var(--color-text-soft);
      font-family: var(--font-mono); flex-shrink: 0; text-align: right;
    }

    .hm-empty-state {
      text-align: center; padding: 40px; color: #9ca3af; font-size: .88rem;
    }

    @media (max-width: 960px) {
      .hm-map-card { height: 340px; }
      .hm-cluster-map { height: 360px; }
    }
    @media (max-width: 768px) {
      .hm-dash-grid { grid-template-columns: 1fr; }
      .hm-metrics-row { grid-template-columns: 1fr 1fr; }
      .hm-detail-sheet__kpi { grid-template-columns: 1fr 1fr; }
      .hm-bottom-grid { grid-template-columns: 1fr; }
      .hm-time-cols { gap: 16px; }
      .hm-time-col { flex: 0 0 68px; }
    }
    @media (max-width: 480px) {
      .hm-metrics-row { grid-template-columns: 1fr; }
      .hm-hero-stats { gap: 14px; }
      .hm-hero-stat__val { font-size: 1.3rem; }
    }
  </style>
</head>
<body data-page="heatmap">
<div class="page-shell">
  <%@ include file="/WEB-INF/jspf/header.jspf" %>
  <main class="page-main" style="padding-top:0;">

    <!-- ============ HERO ============ -->
    <section class="hm-hero">
      <div class="container" style="position:relative;z-index:1;">
        <div class="hm-hero-grid">
          <div class="hm-hero-title">
            <p style="color:rgba(255,255,255,.38);font-size:.8rem;margin:0 0 6px;letter-spacing:.06em;">活动可视化分析</p>
            <h1>银川志愿活动热力分析平台</h1>
            <p>基于 IDW 空间插值算法 + MarkerCluster 聚合引擎，双图联动呈现全市 120 个志愿活动的空间密度与点位分布</p>
          </div>
          <div class="hm-hero-stats" id="hmHeroStats">
            <div class="hm-hero-stat"><div class="hm-hero-stat__val" style="color:#27AE60;">--</div><div class="hm-hero-stat__lbl">当前活动</div></div>
            <div class="hm-hero-stat__divider"></div>
            <div class="hm-hero-stat"><div class="hm-hero-stat__val" style="color:#5B9BD5;">--</div><div class="hm-hero-stat__lbl">参与人次</div></div>
            <div class="hm-hero-stat__divider"></div>
            <div class="hm-hero-stat"><div class="hm-hero-stat__val" style="color:#F0C14B;">--</div><div class="hm-hero-stat__lbl">覆盖区域</div></div>
          </div>
        </div>
        <div class="hm-hero-filters">
          <span class="hm-hero-filters__lbl">时间筛选</span>
          <button class="hm-filter-chip active" data-t="all">全部活动</button>
          <button class="hm-filter-chip" data-t="month">本月</button>
          <button class="hm-filter-chip" data-t="3months">近三月</button>
          <button class="hm-filter-chip" data-t="6months">近半年</button>
        </div>
      </div>
    </section>

    <!-- ============ MAP 1: 热力分布图 ============ -->
    <section class="hm-heat-section">
      <div class="container">
        <div class="hm-section__head">
          <h2 style="color:#fff;">&#127754; 活动热力分布图</h2>
          <span class="hm-section__badge" style="background:rgba(39,174,96,.18);color:#27ae60;">IDW 插值算法</span>
          <p style="color:rgba(255,255,255,.45);">热力图反映活动密度 — 颜色越红表示活动越集中</p>
        </div>
        <div class="hm-map-card" id="hmHeatmap"></div>

        <div class="hm-locate-row">
          <span class="hm-locate-lbl">&#128205; 快速导航</span>
          <button class="hm-locate-btn" data-r="金凤区">金凤区</button>
          <button class="hm-locate-btn" data-r="兴庆区">兴庆区</button>
          <button class="hm-locate-btn" data-r="西夏区">西夏区</button>
          <button class="hm-locate-btn" data-r="贺兰县">贺兰县</button>
          <button class="hm-locate-btn" data-r="永宁县">永宁县</button>
          <button class="hm-locate-btn" data-r="灵武市">灵武市</button>
          <button class="hm-locate-btn" data-r="宁东镇">宁东镇</button>
          <button class="hm-locate-btn hm-locate-btn--reset" data-reset>&#8634; 复位</button>
        </div>

        <div class="hm-density-legend">
          <div class="hm-density-legend__bar">
            <span>&#9632; 低密度</span>
            <div class="hm-density-legend__gradient"></div>
            <span>高密度 &#9632;</span>
          </div>
          <div class="hm-density-legend__labels">
            <span>紫 0~0.14</span><span>蓝 0.14~0.28</span><span>青 0.28~0.42</span><span>绿 0.42~0.57</span><span>黄 0.57~0.71</span><span>橙 0.71~0.85</span><span>红 &gt;0.85</span>
          </div>
        </div>
      </div>
    </section>

    <!-- ============ MAP 2: 活动点聚合地图 ============ -->
    <section class="hm-cluster-section">
      <div class="container">
        <div class="hm-section__head">
          <h2>&#128205; 活动点聚合地图</h2>
          <span class="hm-section__badge" style="background:rgba(124,58,237,.1);color:#7c3aed;">MarkerCluster</span>
          <p>缩放地图查看聚合 — 点击标记查看活动详情</p>
        </div>
        <div class="hm-cluster-toolbar">
          <div class="hm-search-box">
            <input type="text" id="hmSearch" placeholder="搜索活动名称、地址或类别...">
            <span class="hm-search-box__clear" id="hmSearchClear">&#10005;</span>
            <span class="hm-search-box__icon">&#128269;</span>
          </div>
        </div>
        <div class="hm-cluster-map" id="hmClusterMap"></div>

        <div class="hm-cat-legend">
          <span class="hm-cat-legend__item"><span class="hm-cat-legend__dot" style="background:#27AE60;"></span> 社区服务</span>
          <span class="hm-cat-legend__item"><span class="hm-cat-legend__dot" style="background:#2C3E50;"></span> 环境保护</span>
          <span class="hm-cat-legend__item"><span class="hm-cat-legend__dot" style="background:#5B9BD5;"></span> 教育帮扶</span>
          <span class="hm-cat-legend__item"><span class="hm-cat-legend__dot" style="background:#F0C14B;"></span> 文明创建</span>
          <span class="hm-cat-legend__item"><span class="hm-cat-legend__dot" style="background:#E8634B;"></span> 助残扶弱</span>
          <span class="hm-cat-legend__item"><span class="hm-cat-legend__dot" style="background:#9B7ED9;"></span> 文化惠民</span>
        </div>

        <div class="hm-detail-sheet" id="hmDetail">
          <div class="hm-detail-sheet__head">
            <h3 class="hm-detail-sheet__title" id="hmDetailTitle">&#128204; 区域详情</h3>
            <button class="hm-detail-sheet__close" id="hmDetailClose">&#10005;</button>
          </div>
          <div class="hm-detail-sheet__kpi" id="hmDetailKpi"></div>
          <p style="color:#94a3b8;font-size:.76rem;margin:0 0 8px;">该区域活动列表</p>
          <div class="hm-detail-sheet__acts" id="hmDetailActs"></div>
        </div>
      </div>
    </section>

    <!-- ============ DATA DASHBOARD ============ -->
    <section class="hm-dash-section">
      <div class="container">
        <div class="hm-section__head">
          <h2>&#128202; 数据洞察仪表盘</h2>
          <p>实时统计 · 趋势一目了然</p>
        </div>

        <div class="hm-metrics-row" id="hmMetrics"></div>

        <div class="hm-dash-grid">
          <div>
            <div class="hm-section__head" style="margin-bottom:14px;">
              <h2 style="font-size:1.08rem;">&#127942; 区域活跃度排行</h2>
              <p>点击排名项直接定位到聚合地图</p>
            </div>
            <div class="hm-rank-list" id="hmRankList"></div>
          </div>
          <div>
            <div class="hm-chart-card">
              <h4>&#128201; 区域活动占比</h4>
              <div id="hmDonut"></div>
            </div>
            <div class="hm-chart-card">
              <h4>&#128200; 月度参与人次趋势</h4>
              <div id="hmTrendChart"></div>
            </div>
          </div>
        </div>

        <div class="hm-bottom-grid">
          <div class="hm-chart-card" style="margin-bottom:0;">
            <h4>&#9200; 活动时段分布统计</h4>
            <div class="hm-time-cols" id="hmTimeBars"></div>
          </div>
          <div class="hm-chart-card" style="margin-bottom:0;">
            <h4>&#128230; 活动类别分布</h4>
            <div class="hm-cat-bars" id="hmCatBars"></div>
          </div>
        </div>
      </div>
    </section>

  </main>
  <%@ include file="/WEB-INF/jspf/footer.jspf" %>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster@1.5.3/dist/leaflet.markercluster.js"></script>
<script>
window.APP_CTX = "${pageContext.request.contextPath}";
</script>
<script>
(function(){
var ctx=window.APP_CTX||'',API=ctx+'/heatmap/api/activities';

var RC={
  "金凤区":[38.474,106.242],"兴庆区":[38.474,106.288],
  "西夏区":[38.496,106.158],"贺兰县":[38.555,106.349],
  "永宁县":[38.277,106.253],"灵武市":[38.102,106.340],
  "宁东镇":[38.157,106.597]
};
var CATCOL={
  '社区服务':'#27AE60','环境保护':'#2C3E50','教育帮扶':'#5B9BD5',
  '文明创建':'#F0C14B','助残扶弱':'#E8634B','文化惠民':'#9B7ED9'
};

var curTime='all',curActs=[],selRegion=null;

/* ===== Heat Map (direct render with debounce) ===== */
var heatMap=null,heatLayer=null;

function initHeatMap(){
  heatMap=L.map('hmHeatmap',{center:[38.45,106.27],zoom:12,maxBounds:[[37.7,105.7],[38.9,106.9]],minZoom:10,maxZoom:18,zoomControl:true,attributionControl:true});
  L.tileLayer('https://webst0{s}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}',{subdomains:'1234',maxZoom:18}).addTo(heatMap);
  heatLayer=makeCanvasOverlay(heatMap);
  heatMap.addLayer(heatLayer);
}

function heatColor(d){
  d=Math.max(0,Math.min(1,d));
  var r,g,b;
  if(d<=.14){var t=d/.14;r=Math.round(75);g=Math.round(0);b=Math.round(130+t*(255-130));}
  else if(d<=.28){var t=(d-.14)/.14;r=Math.round(75-t*75);g=Math.round(0);b=Math.round(255);}
  else if(d<=.42){var t=(d-.28)/.14;r=Math.round(0);g=Math.round(t*255);b=Math.round(255-t*255);}
  else if(d<=.57){var t=(d-.42)/.15;r=Math.round(t*255);g=Math.round(255);b=Math.round(0);}
  else if(d<=.71){var t=(d-.57)/.14;r=Math.round(255);g=Math.round(255-t*255);b=Math.round(0);}
  else if(d<=.85){var t=(d-.71)/.14;r=Math.round(255);g=Math.round(t*165);b=Math.round(0);}
  else{var t=Math.min(1,(d-.85)/.15);r=Math.round(255);g=Math.round(165);b=Math.round(0);}
  return{r:r,g:g,b:b};
}

function makeCanvasOverlay(m){
  var o=L.Layer.extend({
    initialize:function(){this._cv=null;this._ctx=null;this._sz={w:0,h:0};this._pending=false;this._debounce=null;},
    onAdd:function(map){
      var s=this;s._cv=L.DomUtil.create('canvas','');
      s._cv.style.cssText='position:absolute;pointer-events:none;z-index:200;';
      map.getPanes().tilePane.appendChild(s._cv);
      s._ctx=s._cv.getContext('2d');
      var render=function(){
        if(s._debounce)clearTimeout(s._debounce);
        s._debounce=setTimeout(function(){
          s._debounce=null;
          if(s._pending)return;
          s._pending=true;
          requestAnimationFrame(function(){s._pending=false;s._render();});
        },16);
      };
      map.on('moveend',render);map.on('zoomend',render);map.on('resize',render);
      s._render();
    },
    onRemove:function(){if(this._cv){this._cv.remove();this._cv=null;}if(this._debounce)clearTimeout(this._debounce);},
    _render:function(){
      var sz=this._map.getSize(),w=sz.x,h=sz.y;
      var cv=this._cv,ctx=this._ctx;
      this._sz={w:w,h:h};cv.style.width=w+'px';cv.style.height=h+'px';cv.width=Math.min(w,2048);cv.height=Math.min(h,2048);
      ctx.clearRect(0,0,w,h);
      if(!curActs||curActs.length===0)return;

      var po=heatMap.getPixelOrigin();
      var zs=heatMap.options.zoomSnap||1;
      var zl=Math.round(heatMap.getZoom()/zs)*zs;
      var z=heatMap.getZoom();

      var b=heatMap.getBounds(),pad=.08;
      var bS=b.getSouth()-pad,bN=b.getNorth()+pad;
      var bW=b.getWest()-pad,bE=b.getEast()+pad;

      var RADIUS=Math.max(20,50-(z-10)*3);

      var maxE=0;
      for(var i=0;i<curActs.length;i++){var e=curActs[i].enrolled||0;if(e>maxE)maxE=e;}
      if(maxE<=0)maxE=1;

      var prefix={};
      for(var i=0;i<curActs.length;i++){
        var a=curActs[i],lat=parseFloat(a.lat),lng=parseFloat(a.lng);
        if(!lat||!lng)continue;
        if(lat<bS||lat>bN||lng<bW||lng>bE)continue;
        var pxPt=heatMap.project([lat,lng],zl);
        var sx=pxPt.x-po.x,sy=pxPt.y-po.y;
        if(sx<-RADIUS||sx>w+RADIUS||sy<-RADIUS||sy>h+RADIUS)continue;

        var intensity=(a.enrolled||0)/maxE;
        intensity=Math.max(.15,Math.min(1,intensity));
        var col=heatColor(intensity);
        var outerR=RADIUS*(.7+intensity*.6);
        var key=Math.round(intensity*10);

        if(!prefix[key]){
          ctx.save();
          ctx.globalCompositeOperation='lighter';
          prefix[key]=true;
        }
        var grad=ctx.createRadialGradient(sx,sy,0,sx,sy,outerR);
        var cstr=col.r+','+col.g+','+col.b;
        grad.addColorStop(0,'rgba('+cstr+','+(.7+intensity*.3).toFixed(2)+')');
        grad.addColorStop(.35,'rgba('+cstr+','+(.45+intensity*.2).toFixed(2)+')');
        grad.addColorStop(.7,'rgba('+cstr+',.08)');
        grad.addColorStop(1,'rgba('+cstr+',0)');
        ctx.fillStyle=grad;
        ctx.beginPath();ctx.arc(sx,sy,outerR,0,Math.PI*2);ctx.fill();
        ctx.restore();
      }
    },
    redraw:function(){this._render();}
  });
  return new o();
}

/* ===== Cluster Map ===== */
var clMap=null,clGrp=null;
function initClusterMap(){
  clMap=L.map('hmClusterMap',{center:[38.45,106.27],zoom:12,maxBounds:[[37.7,105.7],[38.9,106.9]],minZoom:10,maxZoom:18});
  L.tileLayer('https://webst0{s}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}',{subdomains:'1234',maxZoom:18}).addTo(clMap);
  clGrp=L.markerClusterGroup({
    chunkedLoading:true,maxClusterRadius:55,spiderfyOnMaxZoom:true,showCoverageOnHover:false,zoomToBoundsOnClick:true,
    iconCreateFunction:function(c){
      var n=c.getChildCount(),col=n<12?'#27AE60':n<35?'#f59e0b':'#ef4444',sz=n<12?38:n<35?44:50;
      return L.divIcon({
        html:'<div style="display:flex;align-items:center;justify-content:center;width:'+sz+'px;height:'+sz+'px;border-radius:50%;background:'+col+';color:#fff;font-weight:700;font-size:'+(n<100?'14px':'12px')+';box-shadow:0 3px 16px '+col+'55;border:3px solid rgba(255,255,255,.9);">'+n+'</div>',
        className:'marker-cluster',iconSize:L.point(sz,sz)
      });
    }
  });
  clMap.addLayer(clGrp);
  clMap.on('click',function(e){
    if(e.originalEvent&&e.originalEvent.target&&e.originalEvent.target.closest&&e.originalEvent.target.closest('.leaflet-popup'))return;
    closeDetail();
  });
}
function statusColor(s){if(s==='已满员')return'#ef4444';if(s==='即将开始')return'#f59e0b';return'#27AE60';}
function drawClusters(){
  clGrp.clearLayers();
  curActs.forEach(function(a){
    var lat=parseFloat(a.lat),lng=parseFloat(a.lng);
    if(!lat||!lng)return;
    var col=CATCOL[a.category]||'#27AE60',sc=statusColor(a.status);
    var icon=L.divIcon({className:'',
      html:'<div style="position:relative;width:30px;height:30px;">'+
        '<div style="position:absolute;inset:-6px;border-radius:50%;background:'+col+';opacity:.2;animation:hmDotPulse 2s ease-in-out infinite;"></div>'+
        '<div style="position:absolute;inset:0;border-radius:50%;background:'+col+';border:2.5px solid #fff;box-shadow:0 2px 10px rgba(0,0,0,.3);display:flex;align-items:center;justify-content:center;color:#fff;font-size:11px;font-weight:700;">1</div>'+
        '<div style="position:absolute;top:-3px;right:-3px;width:12px;height:12px;border-radius:50%;background:'+sc+';border:2.5px solid #fff;"></div>'+
        '</div>',
      iconSize:[30,30],iconAnchor:[15,15]
    });
    var mk=L.marker([lat,lng],{icon:icon});
    var pop='<div style="min-width:230px;font-family:inherit;">'+
      '<div style="font-weight:700;font-size:.9rem;color:#1a1d23;margin-bottom:5px;">'+(a.title||'')+'</div>'+
      '<div style="display:flex;gap:5px;flex-wrap:wrap;margin-bottom:5px;">'+
        '<span style="background:'+col+'16;color:'+col+';padding:2px 8px;border-radius:4px;font-size:.68rem;font-weight:600;">'+(a.category||'')+'</span>'+
        '<span style="background:'+sc+'16;color:'+sc+';padding:2px 8px;border-radius:4px;font-size:.68rem;font-weight:600;">'+(a.status||'')+'</span>'+
      '</div>'+
      '<div style="font-size:.74rem;color:#9ca3af;margin-bottom:3px;">&#128205; '+(a.location||'')+'</div>'+
      '<div style="font-size:.74rem;color:#9ca3af;margin-bottom:3px;">&#128197; '+(a.date||'')+'</div>'+
      '<div style="font-size:.75rem;font-weight:600;color:#374151;">&#128101; 报名 '+(a.enrolled||0)+'/'+(a.capacity||0)+' 人</div>'+
      '</div>';
    mk.bindPopup(pop,{maxWidth:280});clGrp.addLayer(mk);
  });
}

/* ===== Data ===== */
function detectRegion(loc){
  if(!loc)return'金凤区';
  var ks=['金凤区','兴庆区','西夏区','贺兰县','永宁县','灵武市','宁东镇'],ss=['金凤','兴庆','西夏','贺兰','永宁','灵武','宁东'];
  for(var i=0;i<ss.length;i++)if(loc.indexOf(ss[i])>=0)return ks[i];
  return'金凤区';
}
function regionStats(){
  var m={};
  curActs.forEach(function(a){
    var r=detectRegion(a.location||'');
    if(!m[r])m[r]={name:r,count:0,parts:0,hours:0,acts:[]};
    m[r].count++;m[r].parts+=(a.enrolled||0);m[r].hours+=Math.round((a.enrolled||0)*2.5);m[r].acts.push(a);
  });
  return Object.values(m).sort(function(a,b){return b.count-a.count;});
}
function selectRegion(n){
  var c=RC[n];if(!c)return;
  var z=clMap.getZoom();if(z<14)z=14;
  clMap.flyTo(c,z,{duration:.9});selRegion=n;showDetail();
}
function showDetail(){
  if(!selRegion){closeDetail();return;}
  var rs=regionStats(),r=rs.find(function(x){return x.name===selRegion;});if(!r){closeDetail();return;}
  document.getElementById('hmDetailTitle').innerHTML='&#128204; '+r.name;
  document.getElementById('hmDetailKpi').innerHTML=
    '<div class="hm-kpi-box"><div class="hm-kpi-box__val" style="color:#22c55e;">'+r.count+'</div><div class="hm-kpi-box__lbl">活动总数</div></div>'+
    '<div class="hm-kpi-box"><div class="hm-kpi-box__val" style="color:#3b82f6;">'+r.parts+'</div><div class="hm-kpi-box__lbl">参与人次</div></div>'+
    '<div class="hm-kpi-box"><div class="hm-kpi-box__val" style="color:#f59e0b;">'+r.hours+'</div><div class="hm-kpi-box__lbl">服务时长(h)</div></div>'+
    '<div class="hm-kpi-box"><div class="hm-kpi-box__val" style="color:#8b5cf6;">'+(r.parts>0?Math.round(r.hours/r.parts*10)/10:'--')+'</div><div class="hm-kpi-box__lbl">人均时长(h)</div></div>';
  document.getElementById('hmDetailActs').innerHTML=r.acts.slice(0,15).map(function(a){
    var sc=statusColor(a.status),col=CATCOL[a.category]||'#27AE60';
    return'<div class="hm-detail-act"><div class="hm-detail-act__title">'+(a.title||'')+'</div>'+
      '<div class="hm-detail-act__tags"><span class="hm-detail-act__tag" style="background:'+col+'16;color:'+col+';">'+(a.category||'')+'</span>'+
      '<span class="hm-detail-act__tag" style="background:'+sc+'16;color:'+sc+';">'+(a.status||'')+'</span></div>'+
      '<div class="hm-detail-act__meta"><span>&#128205;'+(a.location||'')+'</span><span>&#128101;'+(a.enrolled||0)+'/'+(a.capacity||0)+'</span><span>&#128197;'+(a.date||'')+'</span></div></div>';
  }).join('')+(r.acts.length>15?'<div style="text-align:center;padding:10px;color:#9ca3af;font-size:.78rem;">还有 '+(r.acts.length-15)+' 个活动…</div>':'');
  document.getElementById('hmDetail').classList.add('open');
}
function closeDetail(){selRegion=null;document.getElementById('hmDetail').classList.remove('open');}

/* ===== Ranking ===== */
function renderRanking(){
  var rs=regionStats(),mc=Math.max.apply(null,rs.map(function(r){return r.count;})),cols=['#ef4444','#f97316','#facc15'];
  document.getElementById('hmRankList').innerHTML=rs.map(function(r,i){
    var col=i<3?cols[i]:'#22c55e',bw=(r.count/(mc||1))*100;
    return'<div class="hm-rank-item" data-r="'+r.name+'"><div class="hm-rank-idx" style="background:'+col+';">'+(i+1)+'</div>'+
      '<div class="hm-rank-body"><div class="hm-rank-name">'+r.name+'</div>'+
      '<div class="hm-rank-sub">'+r.count+' 场活动 · '+r.parts+' 人次 · '+r.hours+' 小时</div>'+
      '<div class="hm-rank-bar-wrap"><div class="hm-rank-bar"><div class="hm-rank-bar__fill" style="width:'+bw+'%;background:'+col+';"></div></div></div></div></div>';
  }).join('');
  document.getElementById('hmRankList').querySelectorAll('[data-r]').forEach(function(e){
    e.addEventListener('click',function(){selectRegion(e.getAttribute('data-r'));});
  });
}

/* ===== Donut ===== */
function renderDonut(){
  var rs=regionStats(),t=rs.reduce(function(s,r){return s+r.count;},0);
  var cs=['#ef4444','#f97316','#facc15','#22c55e','#3b82f6','#8b5cf6','#ec4899'],c=0;
  var stops=rs.map(function(r,i){var s=c,p=(r.count/(t||1))*100;c+=p;return cs[i]+' '+s.toFixed(1)+'% '+c.toFixed(1)+'%';}).join(',');
  document.getElementById('hmDonut').innerHTML='<div style="text-align:center;">'+
    '<div style="width:150px;height:150px;border-radius:50%;margin:0 auto 14px;background:conic-gradient('+stops+');position:relative;">'+
      '<div style="position:absolute;inset:26%;border-radius:50%;background:#fff;"></div>'+
      '<div style="position:absolute;inset:0;display:flex;align-items:center;justify-content:center;z-index:1;"><div style="text-align:center;">'+
      '<div style="font-size:.66rem;color:#9ca3af;">总计</div><div style="font-family:\'Roboto Mono\',monospace;font-size:1.25rem;font-weight:700;">'+t+'</div></div></div></div>'+
    '<div style="display:flex;flex-wrap:wrap;gap:6px;justify-content:center;">'+
      rs.map(function(r,i){return'<span style="display:inline-flex;align-items:center;gap:4px;font-size:.67rem;color:#6b7280;">'+
        '<span style="width:7px;height:7px;border-radius:2px;background:'+(cs[i]||'#22c55e')+';display:inline-block;"></span>'+r.name+':'+r.count+'</span>';}).join('')+'</div></div>';
}

/* ===== Trend SVG ===== */
function renderTrend(){
  var vals=[18,25,35,42,38,28,22,30,25,20,15,12],labs=['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'];
  var w=300,h=140,pl=22,pr=10,pt=18,pb=24,mx=Math.max.apply(null,vals)*1.2,ch=h-pt-pb,cw=w-pl-pr;
  var pts=vals.map(function(v,i){var x=pl+(i/(vals.length-1))*cw,y=pt+ch-((v-0)/(mx-0||1))*ch;return x.toFixed(1)+','+y.toFixed(1);}).join(' ');
  var grid='';for(var i=0;i<4;i++){var y=pt+(i/3)*ch;grid+='<line x1="'+pl+'" y1="'+y.toFixed(0)+'" x2="'+(w-pr)+'" y2="'+y.toFixed(0)+'" stroke="#e8ecf1" stroke-width=".5"/>';}
  var dots=vals.map(function(v,i){var x=pl+(i/(vals.length-1))*cw,y=pt+ch-((v-0)/(mx-0||1))*ch;return'<circle cx="'+x.toFixed(1)+'" cy="'+y.toFixed(1)+'" r="4" fill="#7c3aed" stroke="#fff" stroke-width="2.5"/>';}).join('');
  var lbls=labs.map(function(l,i){var x=pl+(i/(vals.length-1))*cw;return'<text x="'+x.toFixed(1)+'" y="'+(h-6)+'" text-anchor="middle" font-size="9" fill="#9ca3af">'+l+'</text>';}).join('');
  document.getElementById('hmTrendChart').innerHTML='<svg viewBox="0 0 '+w+' '+h+'" style="width:100%;">'+grid+
    '<polygon points="'+pl+','+(pt+ch)+' '+pts+' '+(w-pr)+','+(pt+ch)+'" fill="#7c3aed14"/>'+
    '<polyline points="'+pts+'" fill="none" stroke="#7c3aed" stroke-width="2.5" stroke-linecap="round"/>'+dots+lbls+'</svg>';
}

/* ===== Metrics ===== */
function renderMetrics(){
  var acts=curActs,nm=7,ny=2026,pm=6,py=2026,tmc=0,lmc=0,te=0,sl={m:0,f:0,a:0,e:0},dns=['周日','周一','周二','周三','周四','周五','周六'],dc=[0,0,0,0,0,0,0];
  acts.forEach(function(a){
    var m=(a.date||'').match(/(\d{4})年(\d{1,2})月(\d{1,2})日/);if(!m)return;
    var y=parseInt(m[1]),mo=parseInt(m[2]);te+=(a.enrolled||0);
    if(y===ny&&mo===nm)tmc++;if(y===py&&mo===pm)lmc++;
    var h=parseInt(((a.date||'').match(/(\d{1,2}):(\d{2})/)||['','9'])[1])||9;
    if(h>=6&&h<9)sl.m++;else if(h>=9&&h<12)sl.f++;else if(h>=12&&h<18)sl.a++;else if(h>=18&&h<22)sl.e++;else sl.f++;
  });
  var ae=acts.length>0?Math.round(te/acts.length):0,mk='f',mv=0;for(var k in sl)if(sl[k]>mv){mv=sl[k];mk=k;}
  var sn={m:'早晨(6-9时)',f:'上午(9-12时)',a:'下午(12-18时)',e:'晚上(18-22时)'};
  var hot=dns[0]?(sn[mk]?sn[mk].replace(/\(.*\)/,''):''):'上午';
  var gv=lmc>0?Math.round(((tmc-lmc)/lmc)*100):null,gt=gv!==null?(gv>=0?'+'+gv+'%':gv+'%'):'--',gc=gv!==null&&gv>=0?'#16a34a':'#ef4444';
  var ms=[
    {ic:'📅',v:tmc,l:'本月新增活动',sub:'场',c:'#16a34a'},
    {ic:'👥',v:ae,l:'场均报名人数',sub:'人/场',c:'#3b82f6'},
    {ic:'⏰',v:hot,l:'最热活动时段',sub:mv+'场',c:'#f59e0b',isStr:true},
    {ic:'📈',v:gt,l:'环比增长率',sub:'vs上月',c:gc}
  ];
  document.getElementById('hmMetrics').innerHTML=ms.map(function(m){
    return'<div class="hm-metric-card"><div class="hm-metric-card__icon">'+m.ic+'</div>'+
      '<div class="hm-metric-card__val" style="color:'+m.c+';'+(m.isStr?'font-size:1rem;':'')+'">'+m.v+'</div>'+
      '<div class="hm-metric-card__lbl">'+m.l+'</div>'+
      '<div class="hm-metric-card__sub" style="color:'+(m.c)+';">'+m.sub+'</div></div>';
  }).join('');
}

/* ===== Time bars ===== */
function renderTimeBars(){
  var sl=[{id:'m',l:'早晨',t:'6-9时',c:'#22c55e',n:0},{id:'f',l:'上午',t:'9-12时',c:'#3b82f6',n:0},{id:'a',l:'下午',t:'12-18时',c:'#f59e0b',n:0},{id:'e',l:'晚上',t:'18-22时',c:'#8b5cf6',n:0}];
  curActs.forEach(function(a){var h=parseInt(((a.date||'').match(/(\d{1,2}):(\d{2})/)||['','9'])[1])||9;
    if(h>=6&&h<9)sl[0].n++;else if(h>=9&&h<12)sl[1].n++;else if(h>=12&&h<18)sl[2].n++;else if(h>=18&&h<22)sl[3].n++;else sl[1].n++;});
  var mc=Math.max.apply(null,sl.map(function(s){return s.n;}));
  document.getElementById('hmTimeBars').innerHTML=sl.map(function(s){
    var bh=mc>0?Math.max(24,(s.n/mc)*140):24;
    return'<div class="hm-time-col"><div class="hm-time-col__val" style="color:'+s.c+';">'+s.n+'</div>'+
      '<div class="hm-time-col__bar" style="height:'+Math.round(bh)+'px;background:linear-gradient(180deg,'+s.c+','+s.c+'88);"></div>'+
      '<div class="hm-time-col__lbl">'+s.l+'</div><div class="hm-time-col__tm">'+s.t+'</div></div>';
  }).join('');
}

/* ===== Cat bars ===== */
function renderCatBars(){
  var co=['社区服务','环境保护','教育帮扶','文明创建','助残扶弱','文化惠民'],cm={};co.forEach(function(c){cm[c]=0;});
  curActs.forEach(function(a){if(cm.hasOwnProperty(a.category))cm[a.category]++;});
  var t=curActs.length,mx=Math.max.apply(null,co.map(function(c){return cm[c]||0;}));
  document.getElementById('hmCatBars').innerHTML=co.map(function(cat){
    var n=cm[cat]||0,p=t>0?((n/t)*100).toFixed(1):'0.0',bp=mx>0?((n/mx)*100).toFixed(0):0,col=CATCOL[cat]||'#94a3b8';
    return'<div class="hm-cat-row"><span class="hm-cat-row__lbl">'+cat+'</span>'+
      '<div class="hm-cat-row__track"><div class="hm-cat-row__fill" style="width:'+bp+'%;background:'+col+';">'+(n>0?n+'':'')+'</div></div>'+
      '<span class="hm-cat-row__val">'+p+'%</span></div>';
  }).join('');
}

/* ===== Update ===== */
function updateHeroStats(){
  var rs=regionStats(),tc=curActs.length,tp=rs.reduce(function(s,r){return s+r.parts;},0);
  var tr=rs.filter(function(r){return r.count>0;}).length;
  document.getElementById('hmHeroStats').innerHTML=
    '<div class="hm-hero-stat"><div class="hm-hero-stat__val" style="color:#27AE60;">'+tc+'</div><div class="hm-hero-stat__lbl">当前活动</div></div>'+
    '<div class="hm-hero-stat__divider"></div>'+
    '<div class="hm-hero-stat"><div class="hm-hero-stat__val" style="color:#5B9BD5;">'+tp+'</div><div class="hm-hero-stat__lbl">参与人次</div></div>'+
    '<div class="hm-hero-stat__divider"></div>'+
    '<div class="hm-hero-stat"><div class="hm-hero-stat__val" style="color:#F0C14B;">'+tr+'</div><div class="hm-hero-stat__lbl">覆盖区域</div></div>';
}

function refreshPanels(){
  updateHeroStats();
  if(heatLayer&&heatLayer.redraw)heatLayer.redraw();
  drawClusters();
  renderRanking();renderDonut();renderTrend();renderMetrics();renderTimeBars();renderCatBars();
}

function loadData(time,kw){
  var url=API+'?time='+(time||'all');if(kw)url+='&keyword='+encodeURIComponent(kw);
  fetch(url).then(function(r){return r.json();}).then(function(res){
    curActs=(res.data||[]).map(function(a){return{
      id:a.id,title:a.title,category:a.category,lat:a.lat,lng:a.lng,
      location:a.location,enrolled:a.enrolled,capacity:a.capacity,
      status:a.status,date:a.date,color:a.color,sortDate:a.sortDate
    };});
    selRegion=null;closeDetail();refreshPanels();
  }).catch(function(){});
}

/* ===== Events ===== */
document.querySelector('.hm-hero-filters').addEventListener('click',function(e){
  var b=e.target.closest('.hm-filter-chip');if(!b)return;
  this.querySelectorAll('.hm-filter-chip').forEach(function(p){p.classList.remove('active');});
  b.classList.add('active');curTime=b.dataset.t;loadData(curTime);
});
document.querySelector('.hm-locate-row').addEventListener('click',function(e){
  var b=e.target.closest('.hm-locate-btn');if(!b||!heatMap)return;
  if(b.hasAttribute('data-reset')){heatMap.flyTo([38.45,106.27],12,{duration:.8});clMap.flyTo([38.45,106.27],12,{duration:.8});return;}
  var n=b.dataset.r,c=RC[n];if(c){heatMap.flyTo(c,14,{duration:.9});clMap.flyTo(c,14,{duration:.9});selectRegion(n);}
});
var st;document.getElementById('hmSearch').addEventListener('input',function(){
  var v=this.value.trim();document.getElementById('hmSearchClear').style.display=v?'block':'none';
  clearTimeout(st);st=setTimeout(function(){loadData(curTime,v);},350);
});
document.getElementById('hmSearchClear').addEventListener('click',function(){
  document.getElementById('hmSearch').value='';this.style.display='none';loadData(curTime,'');
});
document.getElementById('hmSearch').addEventListener('keydown',function(e){
  if(e.key==='Enter')loadData(curTime,this.value.trim());
});
document.getElementById('hmDetailClose').addEventListener('click',closeDetail);

var animStyle=document.createElement('style');
animStyle.textContent='@keyframes hmDotPulse{0%,100%{transform:scale(1);opacity:.2}50%{transform:scale(1.45);opacity:.45}}';
document.head.appendChild(animStyle);

initHeatMap();initClusterMap();loadData('all');
})();
</script>
</body>
</html>
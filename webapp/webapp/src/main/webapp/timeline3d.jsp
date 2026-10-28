<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  String displayRole = loginUser == null ? "" : loginUser.getRole();
  String displayName = loginUser == null ? "" : loginUser.getNickname();
  request.setAttribute("currentPage", "dashboard");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>志愿星河 - 3D历程</title>
  <style>
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      background: #000;
      font-family: 'PingFang SC', 'Microsoft YaHei', 'Noto Sans SC', -apple-system, sans-serif;
      overflow-x: hidden;
      color: #fff;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }

    /* ===== 3D Canvas ===== */
    #three-canvas {
      position: fixed;
      top: 0; left: 0;
      width: 100vw; height: 100vh;
      z-index: 1;
      pointer-events: none;
    }

    /* ===== Hero Section ===== */
    .hero {
      position: relative;
      z-index: 10;
      height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      pointer-events: none;
      user-select: none;
    }

    .hero__divider {
      width: 80px;
      height: 4px;
      background: linear-gradient(90deg, #27AE60, #5B9BD5);
      margin: 0 auto 28px;
      border-radius: 2px;
    }

    .hero__title {
      font-size: clamp(2rem, 5vw, 3.5rem);
      font-weight: 700;
      letter-spacing: 0.1em;
      background: linear-gradient(90deg, #27AE60, #5B9BD5, #F0C14B, #27AE60);
      background-size: 300% 100%;
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
      animation: heroShimmer 4s ease-in-out infinite;
      margin-bottom: 14px;
    }

    @keyframes heroShimmer {
      0%, 100% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
    }

    .hero__subtitle {
      font-size: 1.1rem;
      color: rgba(255,255,255,0.55);
      letter-spacing: 0.14em;
      margin-bottom: 52px;
    }

    .hero__stats {
      display: flex;
      gap: 48px;
      flex-wrap: wrap;
      justify-content: center;
    }

    .hero__stat {
      text-align: center;
      min-width: 100px;
    }

    .hero__stat-value {
      font-size: 2.6rem;
      font-weight: 700;
      font-family: 'SF Mono', 'Roboto Mono', 'Courier New', monospace;
      line-height: 1.1;
    }

    .hero__stat-value--hours   { color: #27AE60; }
    .hero__stat-value--acts    { color: #5B9BD5; }
    .hero__stat-value--badges  { color: #F0C14B; }

    .hero__stat-label {
      font-size: 0.85rem;
      color: rgba(255,255,255,0.45);
      margin-top: 8px;
      letter-spacing: 0.06em;
    }

    .hero__scroll-hint {
      position: absolute;
      bottom: 44px;
      left: 50%;
      transform: translateX(-50%);
      font-size: 0.82rem;
      color: rgba(255,255,255,0.28);
      animation: heroFloat 2.4s ease-in-out infinite;
      letter-spacing: 0.12em;
    }

    @keyframes heroFloat {
      0%, 100% { transform: translateX(-50%) translateY(0); }
      50%      { transform: translateX(-50%) translateY(-10px); }
    }

    /* ===== 里程碑总结卡片行 ===== */
    .milestone-summary {
      display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;
      margin-top: 42px; max-width: 900px; width: 100%; padding: 0 20px;
    }
    .milestone-card {
      flex: 1; min-width: 150px; max-width: 200px;
      padding: 16px 14px; border-radius: 14px;
      background: rgba(255,255,255,0.06);
      border: 1px solid rgba(255,255,255,0.1);
      text-align: center; cursor: default;
      transition: all 0.35s ease;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }
    .milestone-card:hover {
      background: rgba(255,255,255,0.1);
      border-color: rgba(255,255,255,0.2);
      transform: translateY(-3px);
    }
    .milestone-card.is-highlight {
      background: rgba(39,174,96,0.15);
      border-color: rgba(39,174,96,0.45);
      box-shadow: 0 0 20px rgba(39,174,96,0.15);
    }
    .milestone-card__icon {
      font-size: 1.6rem; margin-bottom: 8px; display: block;
    }
    .milestone-card__date {
      font-size: 0.7rem; color: rgba(255,255,255,0.4);
      letter-spacing: 0.06em; margin-bottom: 5px;
    }
    .milestone-card__desc {
      font-size: 0.78rem; color: rgba(255,255,255,0.65);
      line-height: 1.4;
    }

    /* ===== 成就进度指示器 ===== */
    .achievement-panel {
      position: fixed;
      right: 28px;
      top: calc(50% + 260px);
      width: 340px;
      max-width: calc(100vw - 40px);
      z-index: 20;
      transform: translateY(-50%);
      background: rgba(20,20,35,0.6);
      backdrop-filter: blur(20px) saturate(160%);
      -webkit-backdrop-filter: blur(20px) saturate(160%);
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 20px;
      padding: 22px 24px;
      box-shadow: 0 16px 48px rgba(0,0,0,0.45), inset 0 1px 0 rgba(255,255,255,0.04);
      pointer-events: auto;
    }
    .achievement-panel__header {
      display: flex; align-items: center; gap: 8px;
      margin-bottom: 18px;
      font-size: 0.85rem; font-weight: 600;
      color: rgba(255,255,255,0.75);
      letter-spacing: 0.04em;
    }
    .achievement-bar {
      margin-bottom: 16px;
    }
    .achievement-bar:last-child { margin-bottom: 0; }
    .achievement-bar__header {
      display: flex; justify-content: space-between; align-items: center;
      margin-bottom: 6px;
    }
    .achievement-bar__name {
      font-size: 0.82rem; color: rgba(255,255,255,0.7);
      font-weight: 500;
    }
    .achievement-bar__pct {
      font-family: 'SF Mono', 'Roboto Mono', monospace;
      font-size: 0.76rem; font-weight: 700; color: rgba(255,255,255,0.55);
    }
    .achievement-bar__track {
      height: 8px; border-radius: 4px;
      background: rgba(255,255,255,0.08);
      overflow: hidden;
    }
    .achievement-bar__fill {
      height: 100%; border-radius: 4px;
      transition: width 0.6s ease;
    }
    .achievement-bar__fill--bronze { background: linear-gradient(90deg, #cd7f32, #e8a850); }
    .achievement-bar__fill--silver { background: linear-gradient(90deg, #5b9bd5, #7ec8e3); }
    .achievement-bar__fill--gold   { background: linear-gradient(90deg, #d4af37, #f0c14b); }

    @media (max-width: 768px) {
      .achievement-panel {
        right: 10px; left: 10px; width: auto;
        top: auto; bottom: 330px; transform: none;
        padding: 16px 14px; border-radius: 16px;
      }
      .milestone-card { min-width: 120px; max-width: 160px; padding: 12px 10px; }
      .milestone-card__desc { font-size: 0.7rem; }
    }

    /* ===== Back Button ===== */
    .back-btn {
      position: fixed;
      top: 22px;
      left: 22px;
      z-index: 30;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: rgba(255,255,255,0.7);
      text-decoration: none;
      font-size: 0.92rem;
      letter-spacing: 0.04em;
      padding: 10px 20px;
      border-radius: 26px;
      background: rgba(10,10,20,0.55);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      border: 1px solid rgba(255,255,255,0.12);
      transition: all 0.3s ease;
      pointer-events: auto;
    }

    .back-btn:hover {
      color: #fff;
      background: rgba(255,255,255,0.1);
      border-color: rgba(255,255,255,0.25);
      transform: translateX(-3px);
    }

    /* ===== Detail Card ===== */
    .detail-card {
      position: fixed;
      right: 28px;
      top: 50%;
      transform: translateY(-50%);
      width: 340px;
      max-width: calc(100vw - 40px);
      z-index: 20;
      background: rgba(20,20,35,0.65);
      backdrop-filter: blur(24px) saturate(180%);
      -webkit-backdrop-filter: blur(24px) saturate(180%);
      border: 1px solid rgba(255,255,255,0.12);
      border-radius: 22px;
      padding: 30px 26px 26px;
      box-shadow: 0 24px 64px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.05);
      transition: opacity 0.35s ease, transform 0.35s ease;
      pointer-events: auto;
    }

    .detail-card__type {
      display: inline-block;
      font-size: 0.7rem;
      font-weight: 600;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      padding: 4px 14px;
      border-radius: 14px;
      margin-bottom: 16px;
    }

    .detail-card__type--milestone {
      background: rgba(255, 200, 0, 0.12);
      color: #FFD700;
      border: 1px solid rgba(255, 200, 0, 0.28);
    }

    .detail-card__type--activity {
      background: rgba(39, 174, 96, 0.12);
      color: #27AE60;
      border: 1px solid rgba(39, 174, 96, 0.28);
    }

    .detail-card__title {
      font-size: 1.35rem;
      font-weight: 700;
      color: #fff;
      margin-bottom: 8px;
      line-height: 1.35;
      letter-spacing: 0.03em;
    }

    .detail-card__date {
      font-size: 0.84rem;
      color: rgba(255,255,255,0.45);
      margin-bottom: 16px;
      letter-spacing: 0.04em;
    }

    .detail-card__desc {
      font-size: 0.9rem;
      color: rgba(255,255,255,0.6);
      line-height: 1.7;
      margin-bottom: 20px;
    }

    .detail-card__info {
      display: flex;
      gap: 22px;
      flex-wrap: wrap;
      padding-top: 16px;
      border-top: 1px solid rgba(255,255,255,0.08);
    }

    .detail-card__info-item {
      display: flex;
      flex-direction: column;
      gap: 3px;
      font-size: 0.74rem;
      color: rgba(255,255,255,0.38);
      letter-spacing: 0.04em;
    }

    .detail-card__info-value {
      font-size: 0.88rem;
      color: rgba(255,255,255,0.8);
      font-weight: 600;
    }

    .detail-card__indicator {
      margin-top: 18px;
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 0.72rem;
      color: rgba(255,255,255,0.28);
      letter-spacing: 0.04em;
    }

    .detail-card__indicator-dot {
      width: 7px; height: 7px;
      border-radius: 50%;
      background: rgba(255,255,255,0.2);
    }

    .detail-card__indicator-dot--active {
      background: #27AE60;
      box-shadow: 0 0 8px rgba(39,174,96,0.6);
    }

    /* ===== Progress Bar ===== */
    .progress-bar {
      position: fixed;
      bottom: 0;
      left: 0;
      width: 100%;
      height: 4px;
      z-index: 25;
      background: rgba(255,255,255,0.04);
      pointer-events: none;
    }

    .progress-bar__fill {
      height: 100%;
      background: linear-gradient(90deg, #27AE60 0%, #5B9BD5 50%, #F0C14B 100%);
      width: 0%;
      transition: width 0.08s linear;
      border-radius: 0 2px 2px 0;
    }

    /* ===== Responsive ===== */
    @media (max-width: 768px) {
      .detail-card {
        right: 10px;
        left: 10px;
        width: auto;
        top: auto;
        bottom: 20px;
        transform: none;
        padding: 20px 18px;
        border-radius: 18px;
      }

      .hero__stats { gap: 28px; }
      .hero__stat-value { font-size: 1.9rem; }
      .hero__title { font-size: 1.8rem; }
    }
  </style>
</head>
<body data-page="timeline3d">

  <!-- Hero Section -->
  <section class="hero" id="hero">
    <div class="hero__divider"></div>
    <h1 class="hero__title">志愿星河 · 3D历程</h1>
    <p class="hero__subtitle">沉浸式时间轴 · 回溯每一段温暖足迹</p>
    <div class="hero__stats">
      <div class="hero__stat">
        <div class="hero__stat-value hero__stat-value--hours" id="stat-hours">--</div>
        <div class="hero__stat-label">累计时长（小时）</div>
      </div>
      <div class="hero__stat">
        <div class="hero__stat-value hero__stat-value--acts" id="stat-acts">--</div>
        <div class="hero__stat-label">参与活动</div>
      </div>
      <div class="hero__stat">
        <div class="hero__stat-value hero__stat-value--badges" id="stat-badges">--</div>
        <div class="hero__stat-label">成就徽章</div>
      </div>
    </div>

    <!-- 里程碑总结 -->
    <div class="milestone-summary" id="milestoneSummary"></div>

    <div class="hero__scroll-hint">向下滚动探索历程 ↓</div>
  </section>

  <!-- Virtual Scroll Spacer -->
  <div id="scroll-spacer"></div>

  <!-- 3D Canvas -->
  <canvas id="three-canvas"></canvas>

  <!-- Back Button -->
  <a class="back-btn" href="${pageContext.request.contextPath}/dashboard.jsp">
    ← 返回个人中心
  </a>

  <!-- Detail Card -->
  <div class="detail-card" id="detail-card">
    <div class="detail-card__type" id="detail-type"></div>
    <div class="detail-card__title" id="detail-title"></div>
    <div class="detail-card__date" id="detail-date"></div>
    <div class="detail-card__desc" id="detail-desc"></div>
    <div class="detail-card__info">
      <div class="detail-card__info-item">
        <span>服务时长</span>
        <span class="detail-card__info-value" id="detail-hours">--</span>
      </div>
      <div class="detail-card__info-item">
        <span>活动地点</span>
        <span class="detail-card__info-value" id="detail-location">--</span>
      </div>
    </div>
    <div class="detail-card__indicator" id="detail-progress"></div>
  </div>

  <!-- 成就进度指示器 -->
  <div class="achievement-panel" id="achievementPanel">
    <div class="achievement-panel__header">
      <span>&#x1F31F;</span> 成就进度
    </div>
    <div class="achievement-bar">
      <div class="achievement-bar__header">
        <span class="achievement-bar__name">&#x1F949; 初级志愿者</span>
        <span class="achievement-bar__pct" id="achPct1">0%</span>
      </div>
      <div class="achievement-bar__track">
        <div class="achievement-bar__fill achievement-bar__fill--bronze" id="achBar1" style="width:0%;"></div>
      </div>
    </div>
    <div class="achievement-bar">
      <div class="achievement-bar__header">
        <span class="achievement-bar__name">&#x1F33F; 环保先锋</span>
        <span class="achievement-bar__pct" id="achPct2">0%</span>
      </div>
      <div class="achievement-bar__track">
        <div class="achievement-bar__fill achievement-bar__fill--silver" id="achBar2" style="width:0%;"></div>
      </div>
    </div>
    <div class="achievement-bar">
      <div class="achievement-bar__header">
        <span class="achievement-bar__name">&#x2B50; 社区暖星</span>
        <span class="achievement-bar__pct" id="achPct3">0%</span>
      </div>
      <div class="achievement-bar__track">
        <div class="achievement-bar__fill achievement-bar__fill--gold" id="achBar3" style="width:0%;"></div>
      </div>
    </div>
  </div>

  <!-- Progress Bar -->
  <div class="progress-bar">
    <div class="progress-bar__fill" id="progress-fill"></div>
  </div>

  <!-- ==================== SCRIPTS ==================== -->
  <script>
    window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
    window.APP_USER_ROLE   = "<%= displayRole %>";
    window.APP_USER_NAME   = "<%= displayName %>";
  </script>
  <script src="https://unpkg.com/three@0.157.0/build/three.min.js">
  </script>
  <script src="${pageContext.request.contextPath}/assets/js/data.js">
  </script>
  <script>
  (function() {
    'use strict';

    /* ---------- DOM refs ---------- */
    var canvas       = document.getElementById('three-canvas');
    var detailCard   = document.getElementById('detail-card');
    var detailType   = document.getElementById('detail-type');
    var detailTitle  = document.getElementById('detail-title');
    var detailDate   = document.getElementById('detail-date');
    var detailDesc   = document.getElementById('detail-desc');
    var detailHours  = document.getElementById('detail-hours');
    var detailLoc    = document.getElementById('detail-location');
    var detailProg   = document.getElementById('detail-progress');
    var progressFill = document.getElementById('progress-fill');
    var scrollSpacer = document.getElementById('scroll-spacer');
    var hero         = document.getElementById('hero');
    var statHours    = document.getElementById('stat-hours');
    var statActs     = document.getElementById('stat-acts');
    var statBadges   = document.getElementById('stat-badges');

    /* ---------- Data ---------- */
    var data   = window.VolunteerStarData;
    var events = data.timeline3d.events || [];
    var badges = (data.dashboard && data.dashboard.badges) ? data.dashboard.badges : [];

    if (events.length === 0) {
      events = [{
        id: 1, date: '2025-01-01', title: '暂无历程记录',
        type: 'milestone', hours: 0, totalHours: 0, location: '--',
        color: '#5B9BD5', desc: '请先参与志愿活动，您的3D历程将在这里呈现。'
      }];
    }

    // Stats
    var totalHours    = events[events.length - 1].totalHours || 0;
    var activityCount = 0;
    for (var i = 0; i < events.length; i++) {
      if (events[i].type === 'activity') activityCount++;
    }
    var badgeCount = badges.length;

    statHours.textContent  = totalHours;
    statActs.textContent   = activityCount;
    statBadges.textContent = badgeCount;

    /* ---------- Virtual scroll height ---------- */
    function updateScrollHeight() {
      var h = Math.max(events.length * 600, 1000);
      scrollSpacer.style.height = h + 'px';
    }
    updateScrollHeight();

    /* ---------- Three.js ---------- */
    if (typeof THREE === 'undefined') {
      document.body.innerHTML = '<div style="display:flex;align-items:center;justify-content:center;height:100vh;color:#fff;font-size:1.2rem;">Three.js 加载失败，请检查网络连接后刷新页面。</div>';
      return;
    }

    var scene = new THREE.Scene();
    scene.background = new THREE.Color(0x050510);
    scene.fog = new THREE.FogExp2(0x050510, 0.00025);

    var camera = new THREE.PerspectiveCamera(58, window.innerWidth / window.innerHeight, 0.1, 80);
    camera.position.set(0, 2, 7);

    var renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true, alpha: false });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.1;
    renderer.shadowMap.enabled = false;

    /* ---------- Lighting ---------- */
    var ambient = new THREE.AmbientLight(0x1a1a3a, 2.0);
    scene.add(ambient);

    var point1 = new THREE.PointLight(0x4488ff, 28, 22);
    point1.position.set(3, 5, 6);
    scene.add(point1);

    var point2 = new THREE.PointLight(0xff8833, 18, 16);
    point2.position.set(-4, 1.5, -4);
    scene.add(point2);

    var point3 = new THREE.PointLight(0x33cc88, 14, 14);
    point3.position.set(5, -1, -2);
    scene.add(point3);

    /* ---------- Starfield ---------- */
    var starCount = 1300;
    var starPositions = new Float32Array(starCount * 3);
    var starColors    = new Float32Array(starCount * 3);

    for (var s = 0; s < starCount; s++) {
      starPositions[s * 3]     = (Math.random() - 0.5) * 45;
      starPositions[s * 3 + 1] = (Math.random() - 0.5) * 28;
      starPositions[s * 3 + 2] = (Math.random() - 0.5) * 22;

      var b = 0.35 + Math.random() * 0.65;
      var rnd = Math.random();
      if (rnd < 0.25) {
        starColors[s * 3] = 0.35 * b; starColors[s * 3 + 1] = 0.55 * b; starColors[s * 3 + 2] = 1.0 * b;
      } else if (rnd < 0.45) {
        starColors[s * 3] = 1.0 * b;  starColors[s * 3 + 1] = 0.85 * b; starColors[s * 3 + 2] = 0.45 * b;
      } else if (rnd < 0.6) {
        starColors[s * 3] = 0.4 * b;  starColors[s * 3 + 1] = 0.85 * b; starColors[s * 3 + 2] = 0.55 * b;
      } else {
        starColors[s * 3] = b;        starColors[s * 3 + 1] = b;        starColors[s * 3 + 2] = b;
      }
    }

    var starsGeo = new THREE.BufferGeometry();
    starsGeo.setAttribute('position', new THREE.BufferAttribute(starPositions, 3));
    starsGeo.setAttribute('color',    new THREE.BufferAttribute(starColors, 3));

    var starsMat = new THREE.PointsMaterial({
      size: 0.045,
      vertexColors: true,
      blending: THREE.AdditiveBlending,
      depthWrite: false,
      transparent: true,
      opacity: 0.85
    });
    var stars = new THREE.Points(starsGeo, starsMat);
    scene.add(stars);

    /* ---------- Path Curve ---------- */
    var controlPoints = [];
    var cpCount = 28;
    for (var c = 0; c < cpCount; c++) {
      var ct = c / (cpCount - 1);
      var cx = (ct - 0.5) * 18;
      var cy = Math.sin(ct * Math.PI * 2.6) * 4.0 + Math.cos(ct * Math.PI * 1.1) * 2.0;
      var cz = Math.cos(ct * Math.PI * 1.9) * 3.0;
      controlPoints.push(new THREE.Vector3(cx, cy, cz));
    }

    var curve = new THREE.CatmullRomCurve3(controlPoints, false, 'catmullrom', 0.5);

    // Core tube
    var tubeGeo = new THREE.TubeGeometry(curve, 360, 0.05, 8, false);
    var tubeMat = new THREE.MeshStandardMaterial({
      color: 0x3366cc,
      emissive: 0x1a3388,
      emissiveIntensity: 0.9,
      roughness: 0.18,
      metalness: 0.35,
      transparent: true,
      opacity: 0.85
    });
    var tube = new THREE.Mesh(tubeGeo, tubeMat);
    scene.add(tube);

    // Outer glow tube
    var glowGeo = new THREE.TubeGeometry(curve, 360, 0.22, 8, false);
    var glowMat = new THREE.MeshBasicMaterial({
      color: 0x3355cc,
      transparent: true,
      opacity: 0.1,
      blending: THREE.AdditiveBlending,
      depthWrite: false
    });
    var glowTube = new THREE.Mesh(glowGeo, glowMat);
    scene.add(glowTube);

    // Second wider outer glow
    var glowGeo2 = new THREE.TubeGeometry(curve, 360, 0.45, 8, false);
    var glowMat2 = new THREE.MeshBasicMaterial({
      color: 0x2244aa,
      transparent: true,
      opacity: 0.04,
      blending: THREE.AdditiveBlending,
      depthWrite: false
    });
    var glowTube2 = new THREE.Mesh(glowGeo2, glowMat2);
    scene.add(glowTube2);

    /* ---------- Event Nodes ---------- */
    var nodeGroups    = [];
    var eventTValues  = [];

    events.forEach(function(event, idx) {
      var t;
      if (events.length === 1) {
        t = 0.5;
      } else {
        t = 0.05 + (idx / (events.length - 1)) * 0.9;
      }
      eventTValues.push(t);

      var pt = curve.getPointAt(t);
      var group = new THREE.Group();
      group.position.copy(pt);

      var isMS    = event.type === 'milestone';
      var hue     = isMS ? 0xFFC107 : 0x27AE60;
      var radius  = isMS ? 0.25 : 0.2;

      // Main sphere
      var spGeo = new THREE.SphereGeometry(radius, 40, 40);
      var spMat = new THREE.MeshStandardMaterial({
        color: hue,
        emissive: hue,
        emissiveIntensity: 0.75,
        roughness: 0.12,
        metalness: 0.55
      });
      var sphere = new THREE.Mesh(spGeo, spMat);
      group.add(sphere);

      // Glow halo
      var hlGeo = new THREE.SphereGeometry(radius * 1.7, 32, 32);
      var hlMat = new THREE.MeshBasicMaterial({
        color: hue,
        transparent: true,
        opacity: 0.22,
        blending: THREE.AdditiveBlending,
        depthWrite: false
      });
      var halo = new THREE.Mesh(hlGeo, hlMat);
      group.add(halo);

      // Second larger halo
      var hl2Geo = new THREE.SphereGeometry(radius * 2.8, 16, 16);
      var hl2Mat = new THREE.MeshBasicMaterial({
        color: hue,
        transparent: true,
        opacity: 0.07,
        blending: THREE.AdditiveBlending,
        depthWrite: false
      });
      var halo2 = new THREE.Mesh(hl2Geo, hl2Mat);
      group.add(halo2);

      group.userData = {
        sphere: sphere,
        halo: halo,
        halo2: halo2,
        eventIndex: idx,
        t: t,
        isMilestone: isMS
      };

      // Orbit rings for milestones
      if (isMS) {
        var rGeo1 = new THREE.TorusGeometry(radius * 2.2, 0.022, 16, 56);
        var rMat1 = new THREE.MeshBasicMaterial({
          color: 0xFFD700,
          transparent: true,
          opacity: 0.45,
          blending: THREE.AdditiveBlending,
          depthWrite: false
        });
        var ring1 = new THREE.Mesh(rGeo1, rMat1);
        ring1.rotation.x = Math.PI / 2;
        group.add(ring1);

        var rGeo2 = new THREE.TorusGeometry(radius * 2.7, 0.016, 16, 56);
        var rMat2 = new THREE.MeshBasicMaterial({
          color: 0xFFD700,
          transparent: true,
          opacity: 0.25,
          blending: THREE.AdditiveBlending,
          depthWrite: false
        });
        var ring2 = new THREE.Mesh(rGeo2, rMat2);
        ring2.rotation.x = Math.PI / 3;
        ring2.rotation.y = Math.PI / 4;
        group.add(ring2);

        group.userData.ring1 = ring1;
        group.userData.ring2 = ring2;
      }

      scene.add(group);
      nodeGroups.push(group);
    });

    /* ---------- Camera state ---------- */
    var currentT    = 0;
    var activeIdx   = 0;
    var camTarget   = new THREE.Vector3();
    var lookTarget  = new THREE.Vector3();

    /* ---------- Detail Card ---------- */
    function updateDetailCard(idx) {
      if (idx === activeIdx && detailTitle.textContent === events[idx].title) return;
      activeIdx = idx;

      var ev  = events[idx];
      var ms  = ev.type === 'milestone';

      detailType.textContent = ms ? '里程碑' : '志愿活动';
      detailType.className   = 'detail-card__type ' + (ms ? 'detail-card__type--milestone' : 'detail-card__type--activity');
      detailTitle.textContent = ev.title;
      detailDate.textContent  = ev.date;
      detailDesc.textContent  = ev.desc || '';
      detailHours.textContent = (ev.hours != null ? ev.hours : 0) + ' 小时';
      detailLoc.textContent   = ev.location || '--';

      var num = idx + 1;
      var tot = events.length;
      detailProg.innerHTML = '<span class="detail-card__indicator-dot detail-card__indicator-dot--active"></span> 事件 ' + num + ' / ' + tot;
    }

    /* ---------- Nearest Event ---------- */
    function nearestEvent(t) {
      var bestI = 0, bestD = Infinity;
      for (var k = 0; k < eventTValues.length; k++) {
        var d = Math.abs(t - eventTValues[k]);
        if (d < bestD) { bestD = d; bestI = k; }
      }
      return { index: bestI, distance: bestD };
    }

    /* ---------- 里程碑总结卡片 ---------- */
    var milestoneIcons = ['&#x1F389;', '&#x1F4C5;', '&#x1F31F;', '&#x1F680;'];
    function renderMilestoneCards() {
      var msEvents = events.filter(function(e) { return e.type === 'milestone'; });
      if (msEvents.length === 0) {
        /* 如果没有里程碑事件，从所有事件中取前4个作为展示 */
        msEvents = events.slice(0, Math.min(4, events.length));
      }
      /* 取关键节点：首、中、末 + 1个中间节点 */
      var picks = [];
      var total = msEvents.length;
      if (total <= 4) {
        picks = msEvents.slice();
      } else {
        picks = [
          msEvents[0],
          msEvents[Math.floor(total / 3)],
          msEvents[Math.floor(total * 2 / 3)],
          msEvents[total - 1]
        ];
      }

      var container = document.getElementById('milestoneSummary');
      if (!container) return;

      container.innerHTML = '<h3 style="display:none;">里程碑总结</h3>' +
        picks.map(function(ev, i) {
          return '<div class="milestone-card" data-ms-idx="' + i + '">' +
            '<span class="milestone-card__icon">' + (milestoneIcons[i] || '&#x1F4CD;') + '</span>' +
            '<div class="milestone-card__date">' + ev.date + '</div>' +
            '<div class="milestone-card__desc">' + (ev.title.length > 12 ? ev.title.substring(0, 12) + '...' : ev.title) + '</div>' +
          '</div>';
        }).join('');
    }

    function highlightMilestoneOnScroll() {
      if (eventTValues.length === 0) return;
      var near = nearestEvent(currentT);
      var cards = document.querySelectorAll('.milestone-card');
      if (!cards.length) return;

      /* 找到最近的里程碑事件 */
      var msEvents = events.filter(function(e) { return e.type === 'milestone'; });
      if (msEvents.length === 0) msEvents = events.slice(0, Math.min(4, events.length));
      var total = msEvents.length;
      var picks;
      if (total <= 4) { picks = msEvents.slice(); }
      else {
        picks = [
          msEvents[0],
          msEvents[Math.floor(total / 3)],
          msEvents[Math.floor(total * 2 / 3)],
          msEvents[total - 1]
        ];
      }

      /* 确定当前最近的里程碑卡片 */
      var highlightIdx = -1;
      var minDist = Infinity;
      for (var i = 0; i < picks.length; i++) {
        var evT = eventTValues[events.indexOf(picks[i])];
        if (evT == null) {
          /* fallback: 按比例估算 */
          evT = (i + 1) / (picks.length + 1);
        }
        var d = Math.abs(currentT - evT);
        if (d < minDist) { minDist = d; highlightIdx = i; }
      }

      cards.forEach(function(card, i) {
        if (i === highlightIdx) {
          card.classList.add('is-highlight');
        } else {
          card.classList.remove('is-highlight');
        }
      });
    }

    /* ---------- 成就进度 ---------- */
    function renderAchievements() {
      var level1Target = 50;   /* 初级志愿者：需50小时 */
      var level2Target = 120;  /* 环保先锋：需120小时 */
      var level3Target = 200;  /* 社区暖星：需200小时 */

      var pct1 = Math.min(100, Math.round((totalHours / level1Target) * 100));
      var pct2 = Math.min(100, Math.round((totalHours / level2Target) * 100));
      var pct3 = Math.min(100, Math.round((totalHours / level3Target) * 100));

      var bar1 = document.getElementById('achBar1');
      var bar2 = document.getElementById('achBar2');
      var bar3 = document.getElementById('achBar3');
      var pct1El = document.getElementById('achPct1');
      var pct2El = document.getElementById('achPct2');
      var pct3El = document.getElementById('achPct3');

      if (bar1) bar1.style.width = pct1 + '%';
      if (bar2) bar2.style.width = pct2 + '%';
      if (bar3) bar3.style.width = pct3 + '%';
      if (pct1El) pct1El.textContent = pct1 + '%';
      if (pct2El) pct2El.textContent = pct2 + '%';
      if (pct3El) pct3El.textContent = pct3 + '%';
    }

    /* ---------- Scroll Handler ---------- */
    function onScroll() {
      var heroH   = hero.offsetHeight;
      var spacerH = scrollSpacer.offsetHeight;
      var scrollY = window.scrollY || window.pageYOffset;

      var maxScroll = heroH + spacerH - window.innerHeight;
      if (maxScroll <= 0) maxScroll = 1;

      var progress;
      if (scrollY < heroH * 0.45) {
        progress = 0;
      } else {
        progress = Math.min((scrollY - heroH * 0.45) / (maxScroll - heroH * 0.45), 1);
      }

      currentT = progress;
      progressFill.style.width = (progress * 100).toFixed(1) + '%';

      var near = nearestEvent(currentT);
      if (near.distance < 0.12 && near.index !== activeIdx) {
        updateDetailCard(near.index);
      }

      /* 更新里程碑卡片高亮 */
      highlightMilestoneOnScroll();
    }

    /* ---------- Animation Loop ---------- */
    var clock = new THREE.Clock();

    function animate() {
      requestAnimationFrame(animate);

      var dt      = Math.min(clock.getDelta(), 0.1);
      var elapsed = clock.getElapsedTime();

      // ---- Camera follow ----
      var cp   = curve.getPointAt(currentT);
      var tang = curve.getTangentAt(currentT);

      var behind = tang.clone().multiplyScalar(-5.5);
      var up     = new THREE.Vector3(0, 3.2, 0);
      var right  = new THREE.Vector3().crossVectors(tang, new THREE.Vector3(0, 1, 0))
                    .normalize().multiplyScalar(1.4);

      camTarget.copy(cp).add(behind).add(up).add(right);

      var ahead = cp.clone().add(tang.clone().multiplyScalar(2.5));
      lookTarget.copy(ahead);

      camera.position.lerp(camTarget, 0.045);

      // Smooth look-at
      var curDir = new THREE.Vector3();
      camera.getWorldDirection(curDir);
      var curLook = camera.position.clone().add(curDir.multiplyScalar(6));
      curLook.lerp(lookTarget, 0.05);
      camera.lookAt(curLook);

      // ---- Node animations ----
      for (var n = 0; n < nodeGroups.length; n++) {
        var g  = nodeGroups[n];
        var ud = g.userData;
        var d  = Math.abs(currentT - ud.t);

        var closeness = Math.max(0, 1 - d * 7);
        var pulse     = 1 + Math.sin(elapsed * 3.5 + n * 1.3) * 0.12 * closeness;

        if (ud.halo) {
          ud.halo.scale.setScalar(pulse);
          ud.halo.material.opacity = 0.12 + closeness * 0.28;
        }
        if (ud.halo2) {
          ud.halo2.scale.setScalar(1 + Math.sin(elapsed * 2.2 + n) * 0.18 * closeness);
          ud.halo2.material.opacity = 0.03 + closeness * 0.1;
        }

        if (ud.ring1) {
          ud.ring1.rotation.z += dt * 0.85;
          ud.ring1.material.opacity = 0.18 + closeness * 0.4;
        }
        if (ud.ring2) {
          ud.ring2.rotation.z -= dt * 0.55;
          ud.ring2.rotation.x += dt * 0.35;
          ud.ring2.material.opacity = 0.1 + closeness * 0.25;
        }
      }

      // ---- Slow star rotation ----
      stars.rotation.y += dt * 0.018;
      stars.rotation.x += dt * 0.009;

      renderer.render(scene, camera);
    }

    /* ---------- Resize ---------- */
    function onResize() {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
      updateScrollHeight();
    }

    /* ---------- Bind Events ---------- */
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onResize);

    /* ---------- Kick off ---------- */
    updateDetailCard(0);
    renderMilestoneCards();
    renderAchievements();
    onScroll();
    animate();
  })();
  </script>
</body>
</html>

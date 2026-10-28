<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.volunteerstar.pojo.User" %>

<%

  User loginUser = (User) session.getAttribute("loginUser");

  String displayName = loginUser == null ? "管理员" : loginUser.getNickname();

  String displayUsername = loginUser == null ? "admin" : loginUser.getUsername();

  String displayRole = loginUser == null ? "1" : loginUser.getRole();

  request.setAttribute("currentPage", "admin");

%>

<!DOCTYPE html>

<html lang="zh-CN">

<head>

  <meta charset="UTF-8">

  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <title>志愿星河 - 管理后台</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">

  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">

  <style>

    /* 管理后台专用样式 */

    .admin-panel { display: none; }

    .admin-panel.active { display: block; }

    .data-table { width: 100%; border-collapse: collapse; }

    .data-table th, .data-table td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }

    .data-table th { background: #f8f9fa; font-weight: 600; }

    .data-table tr:hover { background: #f8f9fa; }

    .btn-sm { padding: 6px 12px; font-size: 0.85rem; min-height: 32px; }

    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 200; align-items: center; justify-content: center; }

    .modal-overlay.active { display: flex; }

    .modal-content { background: #fff; border-radius: 16px; padding: 24px; width: 90%; max-width: 600px; max-height: 90vh; overflow-y: auto; }

    .form-group { margin-bottom: 16px; }

    .form-group label { display: block; margin-bottom: 6px; font-weight: 500; }

    .form-group input, .form-group select, .form-group textarea { width: 100%; }

    .filter-bar { display: flex; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; }

    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px; }

    .stat-card-admin { background: #fff; padding: 20px; border-radius: 12px; border: 1px solid #e5e7eb; }

    .stat-number { font-size: 2rem; font-weight: 700; color: #27AE60; }

    .action-btns { display: flex; gap: 8px; }

    .badge-admin { padding: 4px 10px; border-radius: 999px; font-size: 0.75rem; font-weight: 600; }

    .badge-pending { background: #FEF3C7; color: #92400E; }

    .badge-approved { background: #D1FAE5; color: #065F46; }

    .badge-rejected { background: #FEE2E2; color: #991B1B; }

    .badge-completed { background: #DBEAFE; color: #1E40AF; }

    .check-form { display: flex; gap: 8px; align-items: center; }

    .check-form input { width: 80px; }

    #panel-dashboard {
      --overview-ink: #17212b;
      --overview-muted: #66737f;
      --overview-line: #dfe6e2;
      --overview-green: #238b55;
      --overview-green-soft: #eaf6ef;
      --overview-blue: #397bb8;
      --overview-amber: #b77912;
      color: var(--overview-ink);
    }

    #panel-dashboard .overview-header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 24px;
      margin-bottom: 24px;
    }

    #panel-dashboard .overview-kicker {
      margin: 0 0 6px;
      color: var(--overview-green);
      font-family: var(--font-mono);
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.12em;
      text-transform: uppercase;
    }

    #panel-dashboard .overview-title {
      margin: 0;
      font-size: clamp(1.7rem, 2.4vw, 2.35rem);
      line-height: 1.18;
    }

    #panel-dashboard .overview-description {
      max-width: 680px;
      margin: 10px 0 0;
      color: var(--overview-muted);
      line-height: 1.7;
    }

    #panel-dashboard .overview-header__actions {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-shrink: 0;
    }

    #panel-dashboard .overview-live {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      min-height: 44px;
      color: #426052;
      font-size: 0.85rem;
      white-space: nowrap;
    }

    #panel-dashboard .overview-live::before {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--overview-green);
      box-shadow: 0 0 0 5px rgba(35, 139, 85, 0.12);
      content: "";
    }

    #panel-dashboard .overview-refresh {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      min-height: 44px;
      border: 1px solid #cfd9d3;
      border-radius: 12px;
      background: #fff;
      color: var(--overview-ink);
      padding: 0 16px;
      cursor: pointer;
      transition: border-color 180ms ease, background-color 180ms ease, color 180ms ease;
    }

    #panel-dashboard .overview-refresh:hover { border-color: var(--overview-green); color: var(--overview-green); }
    #panel-dashboard .overview-refresh:focus-visible,
    #panel-dashboard .overview-segment button:focus-visible { outline: 3px solid rgba(35, 139, 85, 0.24); outline-offset: 2px; }
    #panel-dashboard .overview-refresh:disabled { cursor: wait; opacity: 0.58; }
    #panel-dashboard .overview-refresh svg { width: 17px; height: 17px; }
    #panel-dashboard .overview-refresh.is-loading svg { animation: overview-spin 0.8s linear infinite; }

    #panel-dashboard .overview-data-note {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      margin-bottom: 12px;
      color: var(--overview-muted);
      font-size: 0.82rem;
    }

    #panel-dashboard .overview-data-note strong { color: var(--overview-ink); font-weight: 600; }

    #panel-dashboard .overview-summary-band {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      margin-bottom: 18px;
      border-block: 1px solid var(--overview-line);
      background: rgba(255, 255, 255, 0.68);
    }

    #panel-dashboard .overview-summary-item {
      position: relative;
      min-width: 0;
      padding: 24px 22px 22px;
    }

    #panel-dashboard .overview-summary-item + .overview-summary-item::before {
      position: absolute;
      inset: 20px auto 20px 0;
      width: 1px;
      background: var(--overview-line);
      content: "";
    }

    #panel-dashboard .overview-summary-label { color: var(--overview-muted); font-size: 0.88rem; }
    #panel-dashboard .overview-summary-value {
      display: flex;
      align-items: baseline;
      gap: 6px;
      margin-top: 7px;
      font-family: var(--font-mono);
      font-size: clamp(1.7rem, 2.7vw, 2.5rem);
      font-weight: 700;
      font-variant-numeric: tabular-nums;
      letter-spacing: -0.04em;
    }

    #panel-dashboard .overview-summary-value small { font-family: var(--font-body); font-size: 0.82rem; font-weight: 500; letter-spacing: 0; }
    #panel-dashboard .overview-summary-change { margin-top: 8px; color: #557064; font-size: 0.78rem; }

    #panel-dashboard .overview-operations {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      margin-bottom: 24px;
      border-radius: 16px;
      background: #1f2d37;
      color: #fff;
      overflow: hidden;
    }

    #panel-dashboard .overview-operation {
      position: relative;
      min-width: 0;
      padding: 18px 20px;
    }

    #panel-dashboard .overview-operation + .overview-operation::before {
      position: absolute;
      inset: 16px auto 16px 0;
      width: 1px;
      background: rgba(255, 255, 255, 0.12);
      content: "";
    }

    #panel-dashboard .overview-operation__label { color: rgba(255, 255, 255, 0.64); font-size: 0.78rem; }
    #panel-dashboard .overview-operation__value { margin-top: 5px; font-family: var(--font-mono); font-size: 1.35rem; font-weight: 700; font-variant-numeric: tabular-nums; }
    #panel-dashboard .overview-operation--attention .overview-operation__value { color: #ffd178; }

    #panel-dashboard .overview-grid {
      display: grid;
      grid-template-columns: minmax(0, 1.55fr) minmax(300px, 0.85fr);
      gap: 18px;
      margin-bottom: 18px;
    }

    #panel-dashboard .overview-panel {
      min-width: 0;
      border: 1px solid var(--overview-line);
      border-radius: 18px;
      background: #fff;
      padding: 22px;
      box-shadow: 0 10px 30px rgba(31, 45, 55, 0.035);
    }

    #panel-dashboard .overview-panel__header {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 16px;
      margin-bottom: 12px;
    }

    #panel-dashboard .overview-panel__title { margin: 0; font-size: 1.05rem; }
    #panel-dashboard .overview-panel__copy { margin: 5px 0 0; color: var(--overview-muted); font-size: 0.8rem; line-height: 1.55; }
    #panel-dashboard .overview-chart { width: 100%; height: 330px; }
    #panel-dashboard .overview-chart--compact { height: 300px; }

    #panel-dashboard .overview-trend-facts {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 8px;
      margin-top: 4px;
      padding-top: 14px;
      border-top: 1px solid #edf1ee;
    }

    #panel-dashboard .overview-trend-fact { min-width: 0; }
    #panel-dashboard .overview-trend-fact span { display: block; color: var(--overview-muted); font-size: 0.72rem; }
    #panel-dashboard .overview-trend-fact strong { display: block; margin-top: 3px; font-family: var(--font-mono); font-size: 0.92rem; font-variant-numeric: tabular-nums; }

    #panel-dashboard .overview-segment {
      display: inline-flex;
      gap: 3px;
      border-radius: 10px;
      background: #f0f4f2;
      padding: 3px;
    }

    #panel-dashboard .overview-segment button {
      min-height: 34px;
      border: 0;
      border-radius: 8px;
      background: transparent;
      color: #66737f;
      padding: 0 11px;
      font-size: 0.76rem;
      cursor: pointer;
    }

    #panel-dashboard .overview-segment button.is-active { background: #fff; color: var(--overview-green); box-shadow: 0 2px 8px rgba(31, 45, 55, 0.08); font-weight: 600; }

    #panel-dashboard .overview-insights {
      display: grid;
      gap: 2px;
      margin: 4px 0 0;
      padding: 0;
      list-style: none;
    }

    #panel-dashboard .overview-insight {
      display: grid;
      grid-template-columns: 28px minmax(0, 1fr);
      gap: 12px;
      padding: 15px 0;
      border-bottom: 1px solid #edf1ee;
    }

    #panel-dashboard .overview-insight:last-child { border-bottom: 0; }
    #panel-dashboard .overview-insight__index { color: var(--overview-green); font-family: var(--font-mono); font-size: 0.75rem; font-weight: 700; }
    #panel-dashboard .overview-insight p { margin: 0; color: #41505b; font-size: 0.87rem; line-height: 1.65; }
    #panel-dashboard .overview-insight strong { color: var(--overview-ink); }

    #panel-dashboard .overview-skeleton {
      min-height: 92px;
      border-radius: 12px;
      background: linear-gradient(90deg, #edf1ef 25%, #f8faf9 50%, #edf1ef 75%);
      background-size: 200% 100%;
      animation: overview-shimmer 1.25s infinite;
    }

    #panel-dashboard .overview-state {
      display: grid;
      place-items: center;
      min-height: 280px;
      border: 1px dashed #cad5cf;
      border-radius: 16px;
      color: var(--overview-muted);
      text-align: center;
      padding: 32px;
    }

    #panel-dashboard .overview-state strong { display: block; margin-bottom: 6px; color: var(--overview-ink); }
    #panel-dashboard .overview-sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border: 0; }

    @keyframes overview-spin { to { transform: rotate(360deg); } }
    @keyframes overview-shimmer { to { background-position: -200% 0; } }

    @media (max-width: 1100px) {
      #panel-dashboard .overview-grid { grid-template-columns: 1fr; }
    }

    @media (max-width: 760px) {
      #panel-dashboard .overview-header { display: block; }
      #panel-dashboard .overview-header__actions { justify-content: space-between; margin-top: 16px; }
      #panel-dashboard .overview-summary-band,
      #panel-dashboard .overview-operations { grid-template-columns: repeat(2, minmax(0, 1fr)); }
      #panel-dashboard .overview-summary-item:nth-child(3)::before,
      #panel-dashboard .overview-operation:nth-child(3)::before { display: none; }
      #panel-dashboard .overview-summary-item:nth-child(n+3) { border-top: 1px solid var(--overview-line); }
      #panel-dashboard .overview-operation:nth-child(n+3) { border-top: 1px solid rgba(255, 255, 255, 0.12); }
      #panel-dashboard .overview-panel { padding: 18px 14px; }
      #panel-dashboard .overview-panel__header { display: block; }
      #panel-dashboard .overview-segment { margin-top: 12px; }
      #panel-dashboard .overview-chart { height: 300px; }
      #panel-dashboard .overview-chart--compact { height: 280px; }
    }

    @media (max-width: 480px) {
      #panel-dashboard .overview-data-note { align-items: flex-start; flex-direction: column; gap: 4px; }
      #panel-dashboard .overview-summary-item { padding: 18px 14px; }
      #panel-dashboard .overview-summary-value { font-size: 1.55rem; }
      #panel-dashboard .overview-operation { padding: 16px 14px; }
      #panel-dashboard .overview-trend-facts { grid-template-columns: 1fr; gap: 12px; }
      #panel-dashboard .overview-chart { height: 285px; }
    }

    @media (prefers-reduced-motion: reduce) {
      #panel-dashboard .overview-refresh,
      #panel-dashboard .overview-skeleton { animation: none !important; transition: none !important; }
    }

  </style>

</head>

<body data-page="admin">

<div class="page-shell">

  <%@ include file="/WEB-INF/jspf/header.jspf" %>

  <main class="page-main" style="background:#f5f6fa; min-height: calc(100vh - 64px);">

    <div class="dashboard-shell">

      <!-- 侧边栏 -->

      <aside class="dashboard-sidebar dashboard-sidebar--admin">

        <div class="sidebar-header">

          <div class="headline" style="font-size:1rem;color:#fff;">管理后台</div>

        </div>

        <nav class="sidebar-nav">

          <button class="sidebar-nav__button is-active" onclick="switchTab('dashboard')">数据概览</button>

          <button class="sidebar-nav__button" onclick="switchTab('activities')">活动管理</button>

          <button class="sidebar-nav__button" onclick="switchTab('registrations')">报名审核</button>

          <button class="sidebar-nav__button" onclick="switchTab('checkin')">签到签退</button>

        </nav>

        <div style="margin-top:auto;padding:18px 20px;border-top:1px solid rgba(255,255,255,.1);">

          <div style="display:flex;align-items:center;gap:12px;margin-bottom:12px;">

            <div style="width:34px;height:34px;border-radius:999px;background:#27AE6020;display:grid;place-items:center;color:#27AE60;">管</div>

            <div>

              <div style="color:#fff;"><%= displayName %></div>

              <div class="text-white-soft mono" style="font-size:.78rem;"><%= displayUsername %></div>

            </div>

          </div>

          <a href="${pageContext.request.contextPath}/auth?action=logout" class="text-white-soft">退出登录</a>

        </div>

      </aside>



      <!-- 主内容区 -->

      <section style="flex:1;min-width:0;padding: 24px;">



        <!-- 数据概览面板 -->

        <div id="panel-dashboard" class="admin-panel active">

          <header class="overview-header">
            <div>
              <p class="overview-kicker">Operations overview</p>
              <h2 class="overview-title">数据概览</h2>
              <p class="overview-description">用平台累计快照观察规模与结构，用实时业务数据识别当前招募、审核和签到压力。</p>
            </div>
            <div class="overview-header__actions">
              <span class="overview-live">实时业务状态</span>
              <button type="button" class="overview-refresh" id="overview-refresh" onclick="loadStats()" aria-label="刷新数据概览">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M20 6v5h-5"/><path d="M4 18v-5h5"/><path d="M6.1 9A7 7 0 0 1 18.4 6.4L20 11M4 13l1.6 4.6A7 7 0 0 0 17.9 15"/></svg>
                <span>刷新</span>
              </button>
            </div>
          </header>

          <div class="overview-data-note" id="overview-data-note">
            <span>正在读取统计快照与实时业务数据</span>
          </div>

          <section class="overview-summary-band" id="overview-summary" aria-label="平台累计指标">
            <div class="overview-summary-item"><div class="overview-skeleton"></div></div>
            <div class="overview-summary-item"><div class="overview-skeleton"></div></div>
            <div class="overview-summary-item"><div class="overview-skeleton"></div></div>
            <div class="overview-summary-item"><div class="overview-skeleton"></div></div>
          </section>

          <section class="overview-operations" id="overview-operations" aria-label="实时运营指标">
            <div class="overview-operation"><div class="overview-skeleton"></div></div>
            <div class="overview-operation"><div class="overview-skeleton"></div></div>
            <div class="overview-operation"><div class="overview-skeleton"></div></div>
            <div class="overview-operation"><div class="overview-skeleton"></div></div>
          </section>

          <div class="overview-grid">
            <section class="overview-panel" aria-labelledby="overview-trend-title">
              <div class="overview-panel__header">
                <div>
                  <h3 class="overview-panel__title" id="overview-trend-title">月度参与趋势</h3>
                  <p class="overview-panel__copy">活动场次与参与人数的双轴变化，判断供给与参与热度是否同步。</p>
                </div>
              </div>
              <div class="overview-chart" id="overview-trend-chart" role="img" aria-label="月度活动场次和参与人数趋势图"></div>
              <p class="overview-sr-only" id="overview-trend-summary"></p>
              <div class="overview-trend-facts" id="overview-trend-facts"></div>
            </section>

            <section class="overview-panel" aria-labelledby="overview-category-title">
              <div class="overview-panel__header">
                <div>
                  <h3 class="overview-panel__title" id="overview-category-title">服务类型结构</h3>
                  <p class="overview-panel__copy">比较不同服务类型的活动供给占比。</p>
                </div>
              </div>
              <div class="overview-chart overview-chart--compact" id="overview-category-chart" role="img" aria-label="服务类型活动数量水平条形图"></div>
              <p class="overview-sr-only" id="overview-category-summary"></p>
            </section>
          </div>

          <div class="overview-grid">
            <section class="overview-panel" aria-labelledby="overview-region-title">
              <div class="overview-panel__header">
                <div>
                  <h3 class="overview-panel__title" id="overview-region-title">区域贡献排行</h3>
                  <p class="overview-panel__copy">从参与、服务时长和活动供给三个角度识别重点区域。</p>
                </div>
                <div class="overview-segment" role="group" aria-label="区域排行指标">
                  <button type="button" class="is-active" data-region-metric="participantCount" onclick="setRegionMetric('participantCount', this)">参与人数</button>
                  <button type="button" data-region-metric="totalHours" onclick="setRegionMetric('totalHours', this)">服务时长</button>
                  <button type="button" data-region-metric="activityCount" onclick="setRegionMetric('activityCount', this)">活动场次</button>
                </div>
              </div>
              <div class="overview-chart" id="overview-region-chart" role="img" aria-label="区域贡献排行条形图"></div>
              <p class="overview-sr-only" id="overview-region-summary"></p>
            </section>

            <section class="overview-panel" aria-labelledby="overview-insights-title">
              <div class="overview-panel__header">
                <div>
                  <h3 class="overview-panel__title" id="overview-insights-title">分析洞察</h3>
                  <p class="overview-panel__copy">根据当前数据自动提取值得关注的趋势和运营事项。</p>
                </div>
              </div>
              <ol class="overview-insights" id="overview-insights" aria-live="polite"></ol>
            </section>
          </div>

        </div>



        <!-- 活动管理面板 -->

        <div id="panel-activities" class="admin-panel">

          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">

            <h2 class="headline headline-md">活动管理</h2>

            <button class="button button--primary" onclick="openActivityModal()">+ 发布活动</button>

          </div>

          <div class="filter-bar">

            <input type="text" class="search-field" id="activity-search" placeholder="搜索活动..." style="max-width:260px;" onkeyup="loadActivities()">

            <select class="select-field" id="activity-filter-status" style="max-width:150px;" onchange="loadActivities()">

              <option value="">全部状态</option>

              <option value="0">招募中</option>

              <option value="1">进行中</option>

              <option value="2">已结束</option>

              <option value="3">已取消</option>

            </select>

          </div>

          <div class="panel table-wrap">

            <table class="data-table" id="activities-table">

              <thead>

              <tr>

                <th>ID</th>

                <th>活动标题</th>

                <th>分类</th>

                <th>时间</th>

                <th>地点</th>

                <th>报名/容量</th>

                <th>状态</th>

                <th>操作</th>

              </tr>

              </thead>

              <tbody></tbody>

            </table>

          </div>

        </div>



        <!-- 报名审核面板 -->

        <div id="panel-registrations" class="admin-panel">

          <h2 class="headline headline-md mb-4">报名审核</h2>

          <div class="filter-bar">

            <select class="select-field" id="reg-filter-status" style="max-width:150px;" onchange="loadRegistrations()">

              <option value="">全部</option>

              <option value="0" selected>待审核</option>

              <option value="1">已通过</option>

              <option value="2">已拒绝</option>

              <option value="3">已取消</option>

              <option value="4">已完成</option>

            </select>

            <input type="text" class="search-field" id="reg-search" placeholder="搜索志愿者..." style="max-width:260px;" onkeyup="loadRegistrations()">

          </div>

          <div class="panel table-wrap">

            <table class="data-table" id="registrations-table">

              <thead>

              <tr>

                <th><input type="checkbox" id="select-all" onchange="toggleSelectAll()"></th>

                <th>志愿者</th>

                <th>活动</th>

                <th>报名时间</th>

                <th>状态</th>

                <th>操作</th>

              </tr>

              </thead>

              <tbody></tbody>

            </table>

          </div>

          <div style="margin-top:12px;">

            <button class="button button--primary btn-sm" onclick="batchApprove()">批量通过</button>

          </div>

        </div>



        <!-- 签到签退面板 -->

        <div id="panel-checkin" class="admin-panel">

          <h2 class="headline headline-md mb-4">签到签退管理</h2>

          <div class="filter-bar">

            <select class="select-field" id="check-filter-status" style="max-width:150px;" onchange="loadCheckInList()">

              <option value="">全部</option>

              <option value="0">待签到</option>

              <option value="1">已签到</option>

              <option value="2">已签退</option>

            </select>

          </div>

          <div class="panel table-wrap">

            <table class="data-table" id="checkin-table">

              <thead>

              <tr>

                <th>志愿者</th>

                <th>活动</th>

                <th>签到时间</th>

                <th>签退时间</th>

                <th>时长</th>

                <th>操作</th>

              </tr>

              </thead>

              <tbody></tbody>

            </table>

          </div>

        </div>



      </section>

    </div>

  </main>

</div>



<!-- 活动编辑模态框 -->

<div class="modal-overlay" id="activity-modal">

  <div class="modal-content">

    <h3 class="headline headline-md mb-4" id="modal-title">发布活动</h3>

    <form id="activity-form" onsubmit="return saveActivity(event)">

      <input type="hidden" id="act-id">

      <div class="form-group">

        <label>活动标题</label>

        <input type="text" class="input-field" id="act-title" required>

      </div>

      <div class="form-group">

        <label>活动分类</label>

        <select class="select-field" id="act-category" required>

          <option value="社区服务">社区服务</option>

          <option value="环境保护">环境保护</option>

          <option value="教育帮扶">教育帮扶</option>

          <option value="文明创建">文明创建</option>

          <option value="助残扶弱">助残扶弱</option>

          <option value="文化惠民">文化惠民</option>

        </select>

      </div>

      <div class="form-group">

        <label>活动地点</label>

        <input type="text" class="input-field" id="act-location" required>

      </div>

      <div class="form-group">

        <label>开始时间</label>

        <input type="datetime-local" class="input-field" id="act-start" required>

      </div>

      <div class="form-group">

        <label>结束时间</label>

        <input type="datetime-local" class="input-field" id="act-end" required>

      </div>

      <div class="form-group">

        <label>招募人数</label>

        <input type="number" class="input-field" id="act-capacity" min="1" required>

      </div>

      <div class="form-group">

        <label>活动状态</label>

        <select class="select-field" id="act-status">

          <option value="0">招募中</option>

          <option value="1">进行中</option>

          <option value="2">已结束</option>

        </select>

      </div>

      <div class="form-group">
        <label>活动图片地址</label>
        <input type="text" class="input-field" id="act-image" placeholder="例如：assets/images/测试图片.png">
        <div class="copy-soft" style="font-size:0.8rem;margin-top:6px;">
          图片请先放到 src/main/webapp/assets/images/，这里只填写 assets/images/文件名
        </div>
      </div>

      <div class="form-group">

        <label>活动描述</label>

        <textarea class="textarea-field" id="act-desc" rows="3"></textarea>

      </div>

      <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px;">

        <button type="button" class="button button--ghost" onclick="closeModal()">取消</button>

        <button type="submit" class="button button--primary">保存</button>

      </div>

    </form>

  </div>

</div>



<script src="${pageContext.request.contextPath}/assets/vendor/echarts/echarts.min.js"></script>
<script>



  function escapeHtml(text) {

    if (!text) return '';

    var div = document.createElement('div');

    div.textContent = text;

    return div.innerHTML;

  }



  const API_BASE = '${pageContext.request.contextPath}/admin/api';

  let currentRegistrations = [];

  let selectedRegs = new Set();

  let overviewCharts = {};
  let overviewData = null;
  let overviewRegionMetric = 'participantCount';
  let overviewResizeTimer = null;



  // 切换标签页

  function switchTab(tab) {

    document.querySelectorAll('.admin-panel').forEach(p => p.classList.remove('active'));

    document.getElementById('panel-' + tab).classList.add('active');

    document.querySelectorAll('.sidebar-nav__button').forEach(b => b.classList.remove('is-active'));

    event.target.classList.add('is-active');



    if (tab === 'activities') loadActivities();

    if (tab === 'registrations') loadRegistrations();

    if (tab === 'checkin') loadCheckInList();

    if (tab === 'dashboard') loadStats();

    if (tab === 'dashboard') {
      window.setTimeout(resizeOverviewCharts, 60);
    }

  }



  // 加载统计数据

  async function loadStats() {
    var refreshButton = document.getElementById('overview-refresh');
    if (refreshButton) {
      refreshButton.disabled = true;
      refreshButton.classList.add('is-loading');
    }
    renderOverviewLoading();
    try {
      const res = await fetch(API_BASE + '/stats');
      if (!res.ok) throw new Error('HTTP ' + res.status);
      const data = await res.json();
      if (!data.success) throw new Error(data.message || '统计接口返回失败');
      overviewData = data.data || {};
      renderOverview(overviewData);
    } catch (e) {
      console.error(e);
      renderOverviewError(e.message || '数据加载失败');
    } finally {
      if (refreshButton) {
        refreshButton.disabled = false;
        refreshButton.classList.remove('is-loading');
      }
    }

  }

  function renderOverviewLoading() {
    disposeOverviewCharts();
    document.getElementById('overview-data-note').innerHTML = '<span>正在读取统计快照与实时业务数据</span>';
    document.getElementById('overview-summary').innerHTML = new Array(4).fill('<div class="overview-summary-item"><div class="overview-skeleton"></div></div>').join('');
    document.getElementById('overview-operations').innerHTML = new Array(4).fill('<div class="overview-operation"><div class="overview-skeleton"></div></div>').join('');
    document.getElementById('overview-trend-facts').innerHTML = '';
    document.getElementById('overview-insights').innerHTML = '';
    ['overview-trend-chart', 'overview-category-chart', 'overview-region-chart'].forEach(function(id) {
      var element = document.getElementById(id);
      if (element) element.innerHTML = '<div class="overview-skeleton" style="height:100%;"></div>';
    });
  }

  function renderOverview(data) {
    var snapshotDate = data.snapshotDate;
    var note = snapshotDate
            ? '<span>累计分析快照：<strong>' + escapeHtml(snapshotDate) + '</strong></span><span>实时数据更新：<strong>' + escapeHtml(data.generatedAt || '-') + '</strong></span>'
            : '<span><strong>暂无统计快照</strong>，当前仅显示实时运营数据</span><span>实时数据更新：<strong>' + escapeHtml(data.generatedAt || '-') + '</strong></span>';
    document.getElementById('overview-data-note').innerHTML = note;
    renderOverviewSummary(data.summary || []);
    renderOverviewOperations(data.operations || {});

    if (typeof echarts === 'undefined') {
      renderChartLibraryError();
      renderOverviewInsights(data);
      return;
    }

    renderTrendChart(data.monthly || []);
    renderCategoryChart(data.categories || []);
    renderRegionChart(data.regions || [], overviewRegionMetric);
    renderOverviewInsights(data);
  }

  function renderOverviewSummary(items) {
    var container = document.getElementById('overview-summary');
    if (!items.length) {
      container.innerHTML = '<div class="overview-state" style="grid-column:1/-1;"><div><strong>暂无累计快照</strong><span>请检查统计快照表是否已有数据。</span></div></div>';
      return;
    }
    container.innerHTML = items.map(function(item) {
      var color = safeColor(item.color, '#238b55');
      return '<article class="overview-summary-item">' +
              '<div class="overview-summary-label">' + escapeHtml(item.label || item.code || '-') + '</div>' +
              '<div class="overview-summary-value" style="color:' + color + ';">' + formatNumber(item.value) + '<small>' + escapeHtml(item.suffix || '') + '</small></div>' +
              '<div class="overview-summary-change">' + escapeHtml(item.changeText || '暂无变化说明') + '</div>' +
              '</article>';
    }).join('');
  }

  function renderOverviewOperations(operations) {
    var items = [
      {label: '招募中活动', value: formatNumber(operations.recruitingActivities), suffix: '场'},
      {label: '平均招募进度', value: formatDecimal(operations.recruitingFillRate, 1), suffix: '%'},
      {label: '待审核报名', value: formatNumber(operations.pendingReviews), suffix: '条', attention: Number(operations.pendingReviews) > 0},
      {label: '今日签到', value: formatNumber(operations.todayCheckIns), suffix: '人次'}
    ];
    document.getElementById('overview-operations').innerHTML = items.map(function(item) {
      return '<article class="overview-operation' + (item.attention ? ' overview-operation--attention' : '') + '">' +
              '<div class="overview-operation__label">' + item.label + '</div>' +
              '<div class="overview-operation__value">' + item.value + ' <small>' + item.suffix + '</small></div>' +
              '</article>';
    }).join('');
  }

  function renderTrendChart(monthly) {
    var element = document.getElementById('overview-trend-chart');
    if (!monthly.length) {
      showChartEmpty(element, '暂无月度趋势数据');
      document.getElementById('overview-trend-summary').textContent = '暂无月度趋势数据。';
      return;
    }
    var chart = getOverviewChart('trend', element);
    var animation = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    chart.setOption({
      aria: {enabled: true, description: '月度活动场次柱状图与参与人数折线图。'},
      animation: animation,
      animationDuration: 350,
      color: ['#238b55', '#397bb8'],
      tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}, backgroundColor: '#17212b', borderWidth: 0, textStyle: {color: '#fff'}},
      legend: {top: 0, right: 0, itemWidth: 18, itemHeight: 8, textStyle: {color: '#66737f'}},
      grid: {left: 46, right: 52, top: 45, bottom: 34},
      xAxis: {type: 'category', data: monthly.map(function(item) { return item.month; }), axisLine: {lineStyle: {color: '#cad5cf'}}, axisTick: {show: false}, axisLabel: {color: '#66737f'}},
      yAxis: [
        {type: 'value', name: '场次', minInterval: 1, nameTextStyle: {color: '#7a8790'}, splitLine: {lineStyle: {color: '#edf1ee'}}, axisLabel: {color: '#66737f'}},
        {type: 'value', name: '人次', nameTextStyle: {color: '#7a8790'}, splitLine: {show: false}, axisLabel: {color: '#66737f'}}
      ],
      series: [
        {name: '活动场次', type: 'bar', barMaxWidth: 32, data: monthly.map(function(item) { return item.activityCount; }), itemStyle: {borderRadius: [6, 6, 0, 0], color: '#238b55'}, emphasis: {itemStyle: {color: '#1c7547'}}},
        {name: '参与人数', type: 'line', yAxisIndex: 1, smooth: 0.25, symbolSize: 8, data: monthly.map(function(item) { return item.participantCount; }), lineStyle: {width: 3, color: '#397bb8'}, itemStyle: {color: '#fff', borderColor: '#397bb8', borderWidth: 3}}
      ]
    }, true);

    var peak = monthly.reduce(function(best, item) { return Number(item.participantCount) > Number(best.participantCount) ? item : best; }, monthly[0]);
    var latest = monthly[monthly.length - 1];
    var previous = monthly.length > 1 ? monthly[monthly.length - 2] : null;
    var change = previous && Number(previous.participantCount) !== 0
            ? ((Number(latest.participantCount) - Number(previous.participantCount)) / Number(previous.participantCount) * 100)
            : 0;
    document.getElementById('overview-trend-facts').innerHTML =
            trendFact('最新服务时长', formatDecimal(latest.totalHours, 1) + ' 小时') +
            trendFact('参与峰值', escapeHtml(peak.month) + ' · ' + formatNumber(peak.participantCount) + ' 人次') +
            trendFact('最新环比', formatSignedPercent(change));
    document.getElementById('overview-trend-summary').textContent = '参与峰值出现在' + peak.month + '，为' + peak.participantCount + '人次；最新月份为' + latest.month + '。';
  }

  function renderCategoryChart(categories) {
    var element = document.getElementById('overview-category-chart');
    if (!categories.length) {
      showChartEmpty(element, '暂无服务类型快照');
      document.getElementById('overview-category-summary').textContent = '暂无服务类型快照。';
      return;
    }
    var ordered = categories.slice().sort(function(a, b) { return Number(a.activityCount) - Number(b.activityCount); });
    var chart = getOverviewChart('category', element);
    chart.setOption({
      aria: {enabled: true, description: '各服务类型活动场次及占比水平条形图。'},
      animation: !window.matchMedia('(prefers-reduced-motion: reduce)').matches,
      animationDuration: 350,
      tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}, formatter: function(params) { var item = ordered[params[0].dataIndex]; return escapeHtml(item.name) + '<br>' + formatNumber(item.activityCount) + ' 场 · ' + formatDecimal(item.percentage, 0) + '%'; }},
      grid: {left: 82, right: 58, top: 10, bottom: 14},
      xAxis: {type: 'value', show: false},
      yAxis: {type: 'category', data: ordered.map(function(item) { return item.name; }), axisLine: {show: false}, axisTick: {show: false}, axisLabel: {color: '#41505b', fontSize: 12}},
      series: [{type: 'bar', barWidth: 16, data: ordered.map(function(item) { return {value: item.activityCount, itemStyle: {color: safeColor(item.color, '#238b55'), borderRadius: [0, 6, 6, 0]}, label: {show: true, position: 'right', color: '#66737f', formatter: formatNumber(item.activityCount) + '场  ' + formatDecimal(item.percentage, 0) + '%'}}; })}]
    }, true);
    var leader = categories.slice().sort(function(a, b) { return Number(b.activityCount) - Number(a.activityCount); })[0];
    document.getElementById('overview-category-summary').textContent = leader.name + '活动数量最多，共' + leader.activityCount + '场，占' + leader.percentage + '%。';
  }

  function setRegionMetric(metric, button) {
    overviewRegionMetric = metric;
    document.querySelectorAll('#panel-dashboard [data-region-metric]').forEach(function(item) { item.classList.toggle('is-active', item === button); });
    if (overviewData) renderRegionChart(overviewData.regions || [], metric);
  }

  function renderRegionChart(regions, metric) {
    var element = document.getElementById('overview-region-chart');
    if (!regions.length) {
      showChartEmpty(element, '暂无区域统计快照');
      document.getElementById('overview-region-summary').textContent = '暂无区域统计快照。';
      return;
    }
    var meta = {
      participantCount: {label: '参与人数', suffix: '人次'},
      totalHours: {label: '服务时长', suffix: '小时'},
      activityCount: {label: '活动场次', suffix: '场'}
    }[metric];
    var ordered = regions.slice().sort(function(a, b) { return Number(a[metric]) - Number(b[metric]); });
    var chart = getOverviewChart('region', element);
    chart.setOption({
      aria: {enabled: true, description: '按照' + meta.label + '排序的区域贡献排行。'},
      animation: !window.matchMedia('(prefers-reduced-motion: reduce)').matches,
      animationDuration: 350,
      tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}, formatter: function(params) { var item = ordered[params[0].dataIndex]; return '<strong>' + escapeHtml(item.name) + '</strong><br>参与人数：' + formatNumber(item.participantCount) + ' 人次<br>服务时长：' + formatDecimal(item.totalHours, 1) + ' 小时<br>活动场次：' + formatNumber(item.activityCount) + ' 场'; }},
      grid: {left: 88, right: 68, top: 12, bottom: 18},
      xAxis: {type: 'value', show: false},
      yAxis: {type: 'category', data: ordered.map(function(item) { return item.name; }), axisLine: {show: false}, axisTick: {show: false}, axisLabel: {color: '#41505b'}},
      series: [{name: meta.label, type: 'bar', barWidth: 18, data: ordered.map(function(item, index) { return {value: item[metric], itemStyle: {color: index === ordered.length - 1 ? '#238b55' : '#9cc9b1', borderRadius: [0, 6, 6, 0]}}; }), label: {show: true, position: 'right', color: '#52616c', formatter: function(params) { return formatDecimal(params.value, metric === 'totalHours' ? 1 : 0) + meta.suffix; }}}]
    }, true);
    var leader = ordered[ordered.length - 1];
    document.getElementById('overview-region-summary').textContent = leader.name + '在' + meta.label + '指标中排名第一，为' + leader[metric] + meta.suffix + '。';
  }

  function renderOverviewInsights(data) {
    var monthly = data.monthly || [];
    var categories = data.categories || [];
    var regions = data.regions || [];
    var operations = data.operations || {};
    var insights = [];

    if (monthly.length) {
      var peak = monthly.reduce(function(best, item) { return Number(item.participantCount) > Number(best.participantCount) ? item : best; }, monthly[0]);
      var latest = monthly[monthly.length - 1];
      insights.push('<strong>' + escapeHtml(peak.month) + '</strong>参与热度最高，达到 <strong>' + formatNumber(peak.participantCount) + ' 人次</strong>；最新月份为 ' + escapeHtml(latest.month) + '。');
    }
    if (categories.length) {
      var category = categories.slice().sort(function(a, b) { return Number(b.activityCount) - Number(a.activityCount); })[0];
      insights.push('<strong>' + escapeHtml(category.name) + '</strong>是当前主要服务类型，占活动供给的 <strong>' + formatDecimal(category.percentage, 0) + '%</strong>。');
    }
    if (regions.length) {
      var ranked = regions.slice().sort(function(a, b) { return Number(b.participantCount) - Number(a.participantCount); });
      var total = ranked.reduce(function(sum, item) { return sum + Number(item.participantCount || 0); }, 0);
      var topShare = total ? Number(ranked[0].participantCount) / total * 100 : 0;
      insights.push('<strong>' + escapeHtml(ranked[0].name) + '</strong>贡献参与人数最多，占区域统计总参与量的 <strong>' + formatDecimal(topShare, 1) + '%</strong>。');
    }
    var pending = Number(operations.pendingReviews || 0);
    insights.push(pending > 0
            ? '当前有 <strong>' + formatNumber(pending) + ' 条报名待审核</strong>，建议优先处理，避免影响活动招募转化。'
            : '当前没有待审核报名，审核队列处于<strong>清空状态</strong>。');

    document.getElementById('overview-insights').innerHTML = insights.map(function(item, index) {
      return '<li class="overview-insight"><span class="overview-insight__index">0' + (index + 1) + '</span><p>' + item + '</p></li>';
    }).join('');
  }

  function renderOverviewError(message) {
    disposeOverviewCharts();
    document.getElementById('overview-data-note').innerHTML = '<span><strong>数据加载失败</strong></span>';
    document.getElementById('overview-summary').innerHTML = '<div class="overview-state" style="grid-column:1/-1;"><div><strong>无法读取数据概览</strong><span>' + escapeHtml(message) + '</span><br><button type="button" class="overview-refresh" style="margin-top:16px;" onclick="loadStats()">重新加载</button></div></div>';
    document.getElementById('overview-operations').innerHTML = '';
    ['overview-trend-chart', 'overview-category-chart', 'overview-region-chart'].forEach(function(id) { showChartEmpty(document.getElementById(id), '等待数据恢复'); });
    document.getElementById('overview-trend-facts').innerHTML = '';
    document.getElementById('overview-insights').innerHTML = '';
  }

  function renderChartLibraryError() {
    ['overview-trend-chart', 'overview-category-chart', 'overview-region-chart'].forEach(function(id) { showChartEmpty(document.getElementById(id), '图表组件加载失败，请确认本地 ECharts 文件存在'); });
  }

  function getOverviewChart(name, element) {
    element.innerHTML = '';
    if (overviewCharts[name] && !overviewCharts[name].isDisposed()) overviewCharts[name].dispose();
    overviewCharts[name] = echarts.init(element, null, {renderer: 'canvas'});
    return overviewCharts[name];
  }

  function disposeOverviewCharts() {
    Object.keys(overviewCharts).forEach(function(key) {
      if (overviewCharts[key] && !overviewCharts[key].isDisposed()) overviewCharts[key].dispose();
    });
    overviewCharts = {};
  }

  function resizeOverviewCharts() {
    Object.keys(overviewCharts).forEach(function(key) {
      if (overviewCharts[key] && !overviewCharts[key].isDisposed()) overviewCharts[key].resize();
    });
  }

  function showChartEmpty(element, message) {
    if (!element) return;
    element.innerHTML = '<div class="overview-state"><div><strong>暂无可视化数据</strong><span>' + escapeHtml(message) + '</span></div></div>';
  }

  function trendFact(label, value) {
    return '<div class="overview-trend-fact"><span>' + label + '</span><strong>' + value + '</strong></div>';
  }

  function safeColor(value, fallback) {
    return /^#[0-9a-fA-F]{6}$/.test(value || '') ? value : fallback;
  }

  function formatNumber(value) {
    var number = Number(value);
    return Number.isFinite(number) ? Math.round(number).toLocaleString('zh-CN') : '0';
  }

  function formatDecimal(value, digits) {
    var number = Number(value);
    return Number.isFinite(number) ? number.toLocaleString('zh-CN', {minimumFractionDigits: digits, maximumFractionDigits: digits}) : '0';
  }

  function formatSignedPercent(value) {
    var number = Number(value) || 0;
    return (number > 0 ? '+' : '') + formatDecimal(number, 1) + '%';
  }

  window.addEventListener('resize', function() {
    window.clearTimeout(overviewResizeTimer);
    overviewResizeTimer = window.setTimeout(resizeOverviewCharts, 120);
  });



  // 加载活动列表

  async function loadActivities() {

    const keyword = document.getElementById('activity-search').value;

    const status = document.getElementById('activity-filter-status').value;

    try {

      const res = await fetch(API_BASE + '/activities?keyword=' + encodeURIComponent(keyword) + '&status=' + status);

      const data = await res.json();

      if (data.success) {

        const tbody = document.querySelector('#activities-table tbody');

        var html = '';

        for (var i = 0; i < data.data.length; i++) {

          var a = data.data[i];

          html += '<tr>' +

                  '<td>' + a.id + '</td>' +

                  '<td><strong>' + escapeHtml(a.title) + '</strong></td>' +

                  '<td><span class="badge-admin" style="background:' + (a.categoryColor || '#27AE60') + '15;color:' + (a.categoryColor || '#27AE60') + ';">' + escapeHtml(a.category) + '</span></td>' +

                  '<td class="mono" style="font-size:0.85rem;">' + (a.startTime || '') + '</td>' +

                  '<td>' + escapeHtml(a.location) + '</td>' +

                  '<td><span class="text-primary">' + a.enrolled + '</span>/' + a.capacity + '</td>' +

                  '<td><span class="badge-admin badge-' + getStatusClass(a.status) + '">' + a.statusLabel + '</span></td>' +

                  '<td>' +

                  '<div class="action-btns">' +

                  '<button class="button button--ghost btn-sm" onclick="editActivity(' + a.id + ')">编辑</button>' +

                  '<button class="button btn-sm" style="background:#E8634B;color:#fff;" onclick="deleteActivity(' + a.id + ')">删除</button>' +

                  '</div>' +

                  '</td>' +

                  '</tr>';

        }

        tbody.innerHTML = html;

      }

    } catch (e) { console.error(e); }

  }



  function getStatusClass(status) {

    var classes = ['pending', 'approved', 'rejected', 'cancelled', 'completed'];

    return classes[status] || 'pending';

  }

  function getStatusText(status) {

    const map = {

      0: '待审核',

      1: '已通过',

      2: '已拒绝',

      3: '已取消',

      4: '已完成'

    };

    return map[Number(status)] || '未知';

  }

  // 打开活动模态框

  function openActivityModal() {

    document.getElementById('activity-form').reset();

    document.getElementById('act-id').value = '';

    document.getElementById('modal-title').textContent = '发布活动';

    document.getElementById('activity-modal').classList.add('active');

  }



  // 编辑活动

  async function editActivity(id) {

    try {

      var res = await fetch(API_BASE + '/activity/detail?id=' + id);

      var data = await res.json();

      if (data.success) {

        var a = data.data;

        document.getElementById('act-id').value = a.id;

        document.getElementById('act-title').value = a.title || '';

        document.getElementById('act-category').value = a.category || '';

        document.getElementById('act-location').value = a.location || '';

        document.getElementById('act-start').value = a.startTime ? a.startTime.replace(' ', 'T') : '';

        document.getElementById('act-end').value = a.endTime ? a.endTime.replace(' ', 'T') : '';

        document.getElementById('act-capacity').value = a.capacity || '';

        document.getElementById('act-status').value = a.status || 0;

        document.getElementById('act-desc').value = a.description || '';

        document.getElementById('modal-title').textContent = '编辑活动';

        document.getElementById('activity-modal').classList.add('active');

        document.getElementById('act-image').value = a.image || '';

      }

    } catch (e) {

      alert('加载失败');

      console.error(e);

    }

  }

  // 保存活动

  async function saveActivity(e) {

    e.preventDefault();

    const id = document.getElementById('act-id').value;

    const formData = new URLSearchParams();

    if (id) formData.append('id', id);

    formData.append('title', document.getElementById('act-title').value);

    formData.append('category', document.getElementById('act-category').value);

    formData.append('categoryColor', getCategoryColor(document.getElementById('act-category').value));

    formData.append('location', document.getElementById('act-location').value);

    formData.append('image', document.getElementById('act-image').value || 'assets/images/activity-1.jpg');


    var startVal = document.getElementById('act-start').value;

    var endVal = document.getElementById('act-end').value;

// 浏览器可能用 / 或 - 分隔日期，统一转换为 yyyy-MM-dd HH:mm

    formData.append('startTime', startVal.replace('T', ' ').replace(/\//g, '-'));

    formData.append('endTime', endVal.replace('T', ' ').replace(/\//g, '-'));

    formData.append('capacity', document.getElementById('act-capacity').value);

    formData.append('status', document.getElementById('act-status').value);

    formData.append('description', document.getElementById('act-desc').value);

    formData.append('image', 'assets/images/activity-default.jpg');



    var url = id ? (API_BASE + '/activity/update') : (API_BASE + '/activity/add');

    try {

      const res = await fetch(url, {

        method: 'POST',

        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },

        body: formData

      });

      const data = await res.json();

      if (data.success) {

        alert(data.message);

        closeModal();

        loadActivities();

      } else {

        alert(data.message);

      }

    } catch (e) { alert('保存失败'); }

    return false;

  }



  function getCategoryColor(cat) {

    const colors = {

      '社区服务': '#27AE60', '环境保护': '#2C3E50', '教育帮扶': '#5B9BD5',

      '文明创建': '#F0C14B', '助残扶弱': '#E8634B', '文化惠民': '#9B7ED9'

    };

    return colors[cat] || '#27AE60';

  }



  // 删除活动

  async function deleteActivity(id) {

    if (!confirm('确定删除该活动？相关报名记录也将被删除！')) return;

    try {

      var res = await fetch(API_BASE + '/activity/delete?id=' + id);

      var data = await res.json();

      alert(data.message);

      if (data.success) loadActivities();

    } catch (e) {

      alert('删除失败');

      console.error(e);

    }

  }



  function closeModal() {

    document.getElementById('activity-modal').classList.remove('active');

  }



  // 加载报名列表
  async function loadRegistrations() {
    var status = document.getElementById('reg-filter-status').value;
    var keyword = document.getElementById('reg-search').value;
    var url = API_BASE + '/registrations?status=' + encodeURIComponent(status) + '&keyword=' + encodeURIComponent(keyword);

    try {
      var res = await fetch(url);
      var data = await res.json();
      var tbody = document.querySelector('#registrations-table tbody');

      if (!data.success) {
        tbody.innerHTML =
                '<tr>' +
                '<td colspan="6" style="text-align:center;color:#E8634B;padding:24px;">加载失败：' + (data.message || '接口返回错误') + '</td>' +
                '</tr>';
        return;
      }

      currentRegistrations = data.data || [];

      if (currentRegistrations.length === 0) {
        tbody.innerHTML =
                '<tr>' +
                '<td colspan="6" style="text-align:center;padding:24px;color:#999;">暂无报名记录</td>' +
                '</tr>';
        return;
      }

      var html = '';
      for (var i = 0; i < currentRegistrations.length; i++) {
        var r = currentRegistrations[i];
        var checked = selectedRegs.has(r.id) ? 'checked' : '';
        var userName = r.userName || ('用户' + r.userId);
        var userPhone = r.userPhone || '-';
        var activityTitle = r.activityTitle || '-';
        var registerTime = r.registerTime || '-';
        var statusNumber = Number(r.status);
        var statusText = r.statusLabel || getStatusText(statusNumber);
        var actionHtml = '';

        if (statusNumber === 0) {
          actionHtml =
                  '<button class="button button--primary btn-sm" onclick="approveReg(' + r.id + ')">通过</button>' +
                  '<button class="button btn-sm" style="background:#E8634B;color:#fff;" onclick="rejectReg(' + r.id + ')">拒绝</button>';
        }

        html +=
                '<tr>' +
                '<td><input type="checkbox" value="' + r.id + '" onchange="toggleReg(' + r.id + ')" ' + checked + '></td>' +
                '<td>' +
                '<div><strong>' + escapeHtml(userName) + '</strong></div>' +
                '<div class="mono copy-soft" style="font-size:0.8rem;">' + escapeHtml(userPhone) + '</div>' +
                '</td>' +
                '<td>' + escapeHtml(activityTitle) + '</td>' +
                '<td class="mono copy-soft">' + escapeHtml(registerTime) + '</td>' +
                '<td><span class="badge-admin badge-' + getStatusClass(statusNumber) + '">' + escapeHtml(statusText) + '</span></td>' +
                '<td><div class="action-btns">' + actionHtml + '</div></td>' +
                '</tr>';
      }

      tbody.innerHTML = html;
    } catch (e) {
      console.error(e);
      var tbody = document.querySelector('#registrations-table tbody');
      tbody.innerHTML =
              '<tr>' +
              '<td colspan="6" style="text-align:center;color:#E8634B;padding:24px;">加载失败，请查看浏览器控制台</td>' +
              '</tr>';
    }
  }

  async function approveReg(id) {
    if (!confirm('确定通过该报名申请？')) return;
    await fetch(API_BASE + '/registration/approve?id=' + encodeURIComponent(id), {method: 'POST'});
    loadRegistrations();
  }

  async function rejectReg(id) {
    var remark = prompt('请输入拒绝原因（可选）：') || '';
    await fetch(API_BASE + '/registration/reject?id=' + encodeURIComponent(id) + '&remark=' + encodeURIComponent(remark), {method: 'POST'});
    loadRegistrations();
  }

  async function batchApprove() {
    if (selectedRegs.size === 0) { alert('请先选择报名记录'); return; }
    if (!confirm('确定批量通过 ' + selectedRegs.size + ' 条报名申请？')) return;
    await fetch(API_BASE + '/registration/batch-approve?ids=' + encodeURIComponent(Array.from(selectedRegs).join(',')), {method: 'POST'});
    selectedRegs.clear();
    document.getElementById('select-all').checked = false;
    loadRegistrations();
  }

  // 加载签到签退列表
  async function loadCheckInList() {
    var status = document.getElementById('check-filter-status').value;
    // 状态值：0-未签到，1-已签到，2-已签退，空字符串-全部
    var signStatus = status === '' ? null : parseInt(status);

    try {
      var res = await fetch(API_BASE + '/checkin/list?status=' + signStatus);
      var data = await res.json();

      if (!data.success) {
        var tbody = document.querySelector('#checkin-table tbody');
        tbody.innerHTML =
                '<tr>' +
                '<td colspan="6" style="text-align:center;color:#E8634B;padding:24px;">加载失败：' + (data.message || '接口返回错误') + '</td>' +
                '</tr>';
        return;
      }

      var tbody = document.querySelector('#checkin-table tbody');
      var list = data.data || [];

      if (list.length === 0) {
        tbody.innerHTML =
                '<tr>' +
                '<td colspan="6" style="text-align:center;padding:24px;color:#999;">暂无签到记录</td>' +
                '</tr>';
        return;
      }

      var html = '';
      for (var i = 0; i < list.length; i++) {
        var r = list[i];
        var actionCell = '';

        var enrollId = r.activityEnrollmentId || r.id;
        var statusNum = Number(r.signStatus);
        if (statusNum === 0) {
          actionCell = '<button class="button button--primary btn-sm" onclick="doCheckIn(' + enrollId + ')">签到</button>';
        } else if (statusNum === 1) {
          var suggestedHours = 2;
          if (r.signInTime) {
            try {
              var signInDate = new Date(r.signInTime.replace(' ', 'T'));
              var diffMs = new Date() - signInDate;
              var diffHours = Math.round(diffMs / 1800000) / 2;
              suggestedHours = Math.max(0.5, Math.min(12, diffHours));
            } catch(e) {}
          }
          actionCell = '<div class="check-form">' +
                  '<input type="number" class="input-field" id="hours-' + enrollId + '" value="' + suggestedHours + '" step="0.5" min="0.5" max="12" style="width:70px;" title="建议时长：' + suggestedHours + '小时">' +
                  '<button class="button button--primary btn-sm" onclick="doCheckOut(' + enrollId + ')">签退</button>' +
                  '</div>';
        } else if (statusNum === 2) {
          actionCell = '<span class="text-primary" style="font-weight:600;">已完成 ' + (r.serviceHourActual || 0) + 'h</span>';
        }

        html += '<tr>' +
                '<td><strong>' + escapeHtml(r.userName || '-') + '</strong><br><span class="mono copy-soft" style="font-size:0.8rem;">' + (r.userPhone || '') + '</span></td>' +
                '<td>' + escapeHtml(r.activityTitle || '-') + '<br><span class="copy-soft" style="font-size:0.8rem;">' + escapeHtml(r.activityLocation || '') + '</span></td>' +
                '<td class="mono">' + (r.signInTime || '-') + '</td>' +
                '<td class="mono">' + (r.signOutTime || '-') + '</td>' +
                '<td class="mono text-primary">' + (r.serviceHourActual || 0) + 'h</td>' +
                '<td>' + actionCell + '</td>' +
                '</tr>';
      }

      tbody.innerHTML = html;
    } catch (e) {
      console.error(e);
      var tbody = document.querySelector('#checkin-table tbody');
      tbody.innerHTML =
              '<tr>' +
              '<td colspan="6" style="text-align:center;color:#E8634B;padding:24px;">加载失败，请查看浏览器控制台</td>' +
              '</tr>';
    }
  }


  async function doCheckIn(id) {
    if (!id || id === 'null' || id === 'undefined') {
      alert('签到记录ID无效，请刷新页面重试');
      return;
    }
    try {
      var res = await fetch(API_BASE + '/checkin/signin?id=' + encodeURIComponent(id), {method: 'POST'});
      var data = await res.json();
      alert(data.message || (data.success ? '签到成功' : '签到失败'));
      if (data.success) loadCheckInList();
    } catch (e) {
      alert('签到请求失败: ' + e.message);
    }
  }


  async function doCheckOut(id) {
    var hours = document.getElementById('hours-' + id).value;
    try {
      var res = await fetch(API_BASE + '/checkin/signout?id=' + encodeURIComponent(id) + '&hours=' + encodeURIComponent(hours), {method: 'POST'});
      var data = await res.json();
      alert(data.message || (data.success ? '签退成功，时长已记录' : '签退失败'));
      if (data.success) {
        loadCheckInList();
      }
    } catch (e) {
      alert('签退请求失败');
      console.error(e);
    }
  }



  // 初始化

  loadStats();

</script>

</body>

</html>

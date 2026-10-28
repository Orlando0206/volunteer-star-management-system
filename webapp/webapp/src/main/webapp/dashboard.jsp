<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  String displayName = loginUser == null ? "访客" : loginUser.getNickname();
  String displayUsername = loginUser == null ? "--" : loginUser.getUsername();
  String displayPhone = loginUser == null ? "" : (loginUser.getPhone() != null ? loginUser.getPhone() : "");
  String displayRole = loginUser == null ? "" : loginUser.getRole();
  String roleLabel = "1".equals(displayRole) ? "管理员" : "志愿者";
  request.setAttribute("currentPage", "dashboard");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>志愿星河 - 个人中心</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
  <style>
    :root { --nav-height: 64px; --sidebar-w: 260px; --green: #27AE60; --green-light: #e8f5e9; --green-dark: #1e8449; --bg-sidebar: #f7f8fa; --bg-page: #f0f2f5; --radius: 12px; --shadow-card: 0 2px 12px rgba(0,0,0,.06); --text: #1a1a2e; --text-soft: #6b7280; --border: #e5e7eb; --gold: #F0C14B; --blue: #5B9BD5; --red: #E8634B; }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Noto Serif SC', 'Microsoft YaHei', serif; background: var(--bg-page); color: var(--text); line-height: 1.6; min-height: 100vh; }
    a { color: var(--green); text-decoration: none; }
    .page-shell { min-height: 100vh; display: flex; flex-direction: column; }

    /* ── Dashboard Shell ── */
    .db-shell { display: flex; flex: 1; min-height: calc(100vh - var(--nav-height)); margin-top: var(--nav-height); }

    /* ── Sidebar ── */
    .db-sidebar { width: var(--sidebar-w); flex-shrink: 0; background: var(--bg-sidebar); border-right: 1px solid var(--border); display: flex; flex-direction: column; position: sticky; top: var(--nav-height); height: calc(100vh - var(--nav-height)); overflow-y: auto; z-index: 100; }
    .db-sidebar__header { padding: 28px 20px 20px; text-align: center; border-bottom: 1px solid var(--border); }
    .db-avatar { width: 88px; height: 88px; border-radius: 50%; margin: 0 auto 14px; overflow: hidden; border: 3px solid #fff; box-shadow: 0 2px 10px rgba(0,0,0,.08); }
    .db-avatar img { width: 100%; height: 100%; object-fit: cover; display: block; }
    .db-nickname { font-size: 1.15rem; font-weight: 700; color: var(--text); margin-bottom: 2px; }
    .db-username { font-size: .78rem; color: var(--text-soft); margin-bottom: 8px; }
    .db-role-tag { display: inline-block; padding: 3px 14px; border-radius: 20px; font-size: .75rem; font-weight: 600; background: var(--green-light); color: var(--green-dark); }
    .db-role-tag--admin { background: #2C3E5018; color: #2C3E50; }

    .db-sidebar__nav { flex: 1; padding: 12px 0; }
    .db-nav-item { display: flex; align-items: center; gap: 10px; width: 100%; padding: 12px 24px; border: none; background: none; font-size: .92rem; color: #555; cursor: pointer; transition: all .18s; text-align: left; font-family: inherit; border-left: 3px solid transparent; }
    .db-nav-item:hover { background: #ebedf0; color: var(--text); }
    .db-nav-item.is-active { background: #fff; color: var(--green); font-weight: 700; border-left-color: var(--green); }
    .db-nav-item .nav-icon { font-size: 1.1rem; width: 22px; text-align: center; flex-shrink: 0; }

    .db-sidebar__footer { padding: 12px 20px 20px; border-top: 1px solid var(--border); }
    .db-logout-btn { display: flex; align-items: center; justify-content: center; gap: 6px; width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 8px; background: #fff; font-size: .88rem; color: #666; cursor: pointer; transition: all .18s; font-family: inherit; }
    .db-logout-btn:hover { background: #fee2e2; border-color: #fca5a5; color: var(--red); }

    /* ── Main Content ── */
    .db-main { flex: 1; min-width: 0; padding: 32px; overflow-y: auto; }
    .db-tab { display: none; animation: dbFadeIn .3s ease; }
    .db-tab.is-active { display: block; }
    @keyframes dbFadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

    /* ── Mobile Toggle ── */
    .db-mobile-toggle { display: none; position: fixed; top: 76px; left: 12px; z-index: 200; padding: 8px 14px; background: #fff; border: 1px solid var(--border); border-radius: 8px; font-size: .85rem; cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,.08); font-family: inherit; }
    .db-mobile-backdrop { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.35); z-index: 150; }
    .db-mobile-backdrop.is-open { display: block; }

    /* ── Tab: Overview ── */
    .db-welcome { background: linear-gradient(135deg, #27AE60 0%, #2ecc71 50%, #1abc9c 100%); color: #fff; border-radius: var(--radius); padding: 32px 36px; margin-bottom: 28px; position: relative; overflow: hidden; }
    .db-welcome::after { content: ''; position: absolute; right: -30px; top: -30px; width: 200px; height: 200px; border-radius: 50%; background: rgba(255,255,255,.06); pointer-events: none; }
    .db-welcome h2 { font-size: 1.6rem; margin-bottom: 6px; }
    .db-welcome .db-date { font-size: .88rem; opacity: .85; margin-bottom: 16px; }
    .db-welcome .db-total-hours { font-size: 3rem; font-weight: 700; font-family: 'Roboto Mono', monospace; }
    .db-welcome .db-total-hours small { font-size: .9rem; font-weight: 400; opacity: .8; margin-left: 8px; }

    .db-stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
    .db-stat-card { background: #fff; border-radius: var(--radius); padding: 22px 24px; border-left: 4px solid var(--green); box-shadow: var(--shadow-card); display: flex; flex-direction: column; gap: 8px; }
    .db-stat-card:nth-child(2) { border-left-color: var(--blue); }
    .db-stat-card:nth-child(3) { border-left-color: var(--gold); }
    .db-stat-card:nth-child(4) { border-left-color: var(--red); }
    .db-stat-card__label { font-size: .82rem; color: var(--text-soft); }
    .db-stat-card__value { font-size: 1.8rem; font-weight: 700; font-family: 'Roboto Mono', monospace; color: var(--text); }
    .db-stat-card__sub { font-size: .75rem; color: var(--text-soft); }

    .db-section { background: #fff; border-radius: var(--radius); padding: 24px; margin-bottom: 22px; box-shadow: var(--shadow-card); }
    .db-section__head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
    .db-section__title { font-size: 1.05rem; font-weight: 700; }

    .db-quick-actions { display: flex; gap: 12px; flex-wrap: wrap; }
    .db-quick-btn { padding: 10px 20px; border-radius: 8px; border: 1px solid var(--border); background: #fff; font-size: .88rem; cursor: pointer; transition: all .18s; font-family: inherit; color: var(--text); }
    .db-quick-btn:hover { background: var(--green-light); border-color: var(--green); color: var(--green); }

    /* ── Tab: Registrations ── */
    .db-filter-bar { display: flex; gap: 8px; margin-bottom: 18px; flex-wrap: wrap; }
    .db-filter-btn { padding: 7px 18px; border: 1px solid var(--border); border-radius: 20px; background: #fff; font-size: .85rem; cursor: pointer; transition: all .18s; font-family: inherit; color: #555; }
    .db-filter-btn:hover { border-color: var(--green); color: var(--green); }
    .db-filter-btn.is-active { background: var(--green); color: #fff; border-color: var(--green); }

    .db-reg-list { display: flex; flex-direction: column; gap: 10px; }
    .db-reg-item { display: flex; align-items: center; justify-content: space-between; padding: 14px 18px; background: #fafbfc; border-radius: 10px; border: 1px solid var(--border); cursor: pointer; transition: all .15s; }
    .db-reg-item:hover { background: #f0fdf4; border-color: var(--green-light); }
    .db-reg-item__info { flex: 1; min-width: 0; }
    .db-reg-item__title { font-weight: 600; font-size: .95rem; margin-bottom: 2px; }
    .db-reg-item__date { font-size: .8rem; color: var(--text-soft); }

    /* Status badges */
    .badge-status { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: .78rem; font-weight: 600; flex-shrink: 0; white-space: nowrap; }
    .badge-approved { background: #27AE6020; color: #27AE60; }
    .badge-pending { background: #F0C14B20; color: #b8960b; }
    .badge-completed { background: #2C3E5020; color: #2C3E50; }
    .badge-cancelled { background: #8a8a8a20; color: #8a8a8a; }

    /* ── Tab: Hours ── */
    .db-hours-layout { display: grid; grid-template-columns: 1fr 1.2fr; gap: 22px; margin-bottom: 22px; }
    .db-donut-wrap { display: flex; flex-direction: column; align-items: center; padding: 24px; }
    .db-donut-inner { width: 200px; height: 200px; border-radius: 50%; position: relative; margin-bottom: 20px; }
    .db-donut-hole { position: absolute; left: 22%; top: 22%; right: 22%; bottom: 22%; background: #fff; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    .db-donut-total { font-size: 2rem; font-weight: 700; color: var(--text); font-family: 'Roboto Mono', monospace; }
    .db-donut-label { font-size: .8rem; color: var(--text-soft); margin-top: 2px; }
    .db-legend { display: grid; grid-template-columns: 1fr 1fr; gap: 8px 16px; width: 100%; }
    .db-legend-item { display: flex; align-items: center; gap: 8px; font-size: .82rem; }
    .db-legend-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }

    .db-hours-table { width: 100%; border-collapse: collapse; }
    .db-hours-table th { text-align: left; padding: 10px 14px; border-bottom: 2px solid var(--border); font-size: .82rem; color: var(--text-soft); font-weight: 600; }
    .db-hours-table td { padding: 12px 14px; border-bottom: 1px solid var(--border); font-size: .88rem; }

    .db-total-card { background: linear-gradient(135deg, #27AE60, #2ecc71); color: #fff; border-radius: var(--radius); padding: 24px 28px; display: flex; align-items: center; justify-content: space-between; }
    .db-total-card__label { font-size: .9rem; opacity: .9; }
    .db-total-card__value { font-size: 2.4rem; font-weight: 700; font-family: 'Roboto Mono', monospace; }

    /* ── Tab: Messages ── */
    .db-msg-list { display: flex; flex-direction: column; gap: 8px; }
    .db-msg-item { display: flex; align-items: flex-start; gap: 14px; padding: 16px 18px; background: #fafbfc; border-radius: 10px; border: 1px solid var(--border); transition: all .15s; position: relative; cursor: pointer; }
    .db-msg-item:hover { background: #fff; box-shadow: var(--shadow-card); }
    .db-msg-item--unread { background: #f0fdf4; border-color: #bbf7d0; }
    .db-msg-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
    .db-msg-content { flex: 1; min-width: 0; }
    .db-msg-title { font-weight: 600; font-size: .92rem; margin-bottom: 3px; }
    .db-msg-text { font-size: .82rem; color: var(--text-soft); line-height: 1.5; }
    .db-msg-date { font-size: .75rem; color: #aaa; margin-top: 4px; }
    .db-msg-dot { position: absolute; top: 18px; right: 18px; width: 10px; height: 10px; border-radius: 50%; background: var(--red); flex-shrink: 0; }

    /* ── Tab: Badges ── */
    .db-badge-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 18px; }
    .db-badge-card { background: #fff; border-radius: var(--radius); padding: 24px 20px; text-align: center; border: 1px solid var(--border); box-shadow: var(--shadow-card); transition: all .2s; }
    .db-badge-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,.1); }
    .db-badge-card--locked { opacity: .55; filter: grayscale(1); }
    .db-badge-icon { font-size: 2.8rem; margin-bottom: 10px; display: block; }
    .db-badge-name { font-weight: 700; font-size: .95rem; margin-bottom: 4px; }
    .db-badge-desc { font-size: .8rem; color: var(--text-soft); margin-bottom: 10px; }
    .db-badge-progress { height: 6px; border-radius: 3px; background: #e5e7eb; overflow: hidden; margin-top: 8px; }
    .db-badge-progress-fill { height: 100%; border-radius: 3px; background: var(--green); transition: width .5s ease; }

    /* ── Tab: Settings ── */
    .db-form { max-width: 520px; }
    .db-form-group { margin-bottom: 18px; }
    .db-form-label { display: block; font-size: .85rem; font-weight: 600; color: var(--text); margin-bottom: 6px; }
    .db-form-input { width: 100%; padding: 10px 14px; border: 1px solid var(--border); border-radius: 8px; font-size: .9rem; font-family: inherit; transition: border-color .18s; outline: none; background: #fff; }
    .db-form-input:focus { border-color: var(--green); box-shadow: 0 0 0 3px rgba(39,174,96,.1); }
    .db-form-input:read-only { background: #f7f8fa; color: #888; cursor: not-allowed; }
    .db-form-submit { padding: 12px 32px; background: var(--green); color: #fff; border: none; border-radius: 8px; font-size: .92rem; font-weight: 600; cursor: pointer; transition: all .18s; font-family: inherit; }
    .db-form-submit:hover { background: var(--green-dark); }

    .db-empty { text-align: center; padding: 40px 20px; color: #999; font-size: .9rem; }

    /* ── Weekly Dual Chart (Hours + Points) ── */
    .db-weekly-chart { display: flex; align-items: flex-end; gap: 10px; height: 160px; padding: 0 4px; }
    .db-weekly-bar-wrap { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 4px; height: 100%; justify-content: flex-end; }
    .db-weekly-bar-pair { display: flex; gap: 4px; align-items: flex-end; }
    .db-weekly-bar { width: 15px; border-radius: 4px 4px 0 0; transition: height .5s ease; min-height: 3px; }
    .db-weekly-bar--hours { background: linear-gradient(180deg, #27AE60, #2ecc71); }
    .db-weekly-bar--points { background: linear-gradient(180deg, #7c3aed, #a855f7); }
    .db-weekly-bar--weak-h { background: linear-gradient(180deg, #a7f3d0, #6ee7b7); }
    .db-weekly-bar--weak-p { background: linear-gradient(180deg, #ddd6fe, #c4b5fd); }
    .db-weekly-val { font-family: 'Roboto Mono', monospace; font-size: .65rem; font-weight: 600; color: var(--text); }
    .db-weekly-val--pts { color: #7c3aed; }
    .db-weekly-day { font-size: .66rem; color: var(--text-soft); }
    .db-weekly-legend { display: flex; gap: 16px; justify-content: center; margin-bottom: 10px; }
    .db-weekly-legend span { display: flex; align-items: center; gap: 5px; font-size: .75rem; color: #64748b; }
    .db-weekly-legend-dot { width: 8px; height: 8px; border-radius: 2px; display: inline-block; }
    .db-weekly-legend-dot--h { background: #27AE60; }
    .db-weekly-legend-dot--p { background: #7c3aed; }

    /* ── Points Source Donut ── */
    .db-pts-source-wrap { display: flex; align-items: center; gap: 28px; padding: 16px 24px; flex-wrap: wrap; justify-content: center; }
    .db-pts-source-ring { width: 160px; height: 160px; border-radius: 50%; position: relative; flex-shrink: 0; }
    .db-pts-source-hole { position: absolute; left: 22%; top: 22%; right: 22%; bottom: 22%; background: #fff; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    .db-pts-source-total { font-size: 1.5rem; font-weight: 700; color: #7c3aed; font-family: 'Roboto Mono', monospace; }
    .db-pts-source-label { font-size: .68rem; color: var(--text-soft); }
    .db-pts-source-list { display: flex; flex-direction: column; gap: 8px; min-width: 180px; }
    .db-pts-source-item { display: flex; align-items: center; gap: 8px; font-size: .8rem; color: #374151; }
    .db-pts-source-dot { width: 10px; height: 10px; border-radius: 3px; flex-shrink: 0; }
    .db-pts-source-val { margin-left: auto; font-family: 'Roboto Mono', monospace; font-weight: 600; font-size: .8rem; }

    /* ── Level Progress Bar ── */
    .db-level-progress { padding: 8px 0; }
    .db-level-progress__info { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
    .db-level-progress__cur { font-weight: 700; font-size: .9rem; }
    .db-level-progress__next { font-size: .78rem; color: var(--text-soft); }
    .db-level-progress__bar { height: 12px; border-radius: 6px; background: #e5e7eb; overflow: hidden; }
    .db-level-progress__fill { height: 100%; border-radius: 6px; transition: width .6s ease; background: linear-gradient(90deg, #7c3aed, #a855f7); }

    /* ── Points History Timeline ── */
    .db-pts-timeline { display: flex; flex-direction: column; gap: 4px; max-height: 300px; overflow-y: auto; }
    .db-pts-tl-item { display: flex; align-items: center; gap: 12px; padding: 8px 12px; border-radius: 8px; transition: all .15s; }
    .db-pts-tl-item:hover { background: #f8f9ff; }
    .db-pts-tl-icon { width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: .85rem; flex-shrink: 0; }
    .db-pts-tl-icon--earn { background: #f0fdf4; }
    .db-pts-tl-icon--spend { background: #fef2f2; }
    .db-pts-tl-info { flex: 1; min-width: 0; }
    .db-pts-tl-reason { font-size: .84rem; font-weight: 500; color: #1a1d23; }
    .db-pts-tl-time { font-size: .7rem; color: #94a3b8; }
    .db-pts-tl-amount { font-family: 'Roboto Mono', monospace; font-weight: 700; font-size: .88rem; flex-shrink: 0; }
    .db-pts-tl-amount--earn { color: #27ae60; }
    .db-pts-tl-amount--spend { color: #ef4444; }

    /* ── Recommended Activity Mini Cards ── */
    .db-rec-cards { display: flex; gap: 12px; margin-top: 12px; }
    .db-rec-card { flex: 1; display: flex; align-items: center; gap: 12px; padding: 14px 16px; border-radius: 10px; background: linear-gradient(135deg, #f0fdf4, #ecfdf5); border: 1px solid #bbf7d0; cursor: pointer; transition: all .2s; }
    .db-rec-card:hover { background: #fff; box-shadow: var(--shadow-card); transform: translateY(-1px); }
    .db-rec-card__icon { width: 40px; height: 40px; border-radius: 10px; background: var(--green); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; flex-shrink: 0; }
    .db-rec-card__info { flex: 1; min-width: 0; }
    .db-rec-card__title { font-size: .86rem; font-weight: 600; color: var(--text); margin-bottom: 2px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .db-rec-card__date { font-size: .72rem; color: var(--text-soft); }

    /* ── Leaderboard ── */
    .db-lb-list { display: flex; flex-direction: column; gap: 8px; }
    .db-lb-item { display: flex; align-items: center; gap: 12px; padding: 10px 14px; border-radius: 8px; background: #fafbfc; border: 1px solid #f1f5f9; transition: all .15s; }
    .db-lb-item:hover { background: #f0fdf4; }
    .db-lb-rank { width: 26px; height: 26px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: .78rem; font-weight: 700; color: #fff; flex-shrink: 0; }
    .db-lb-rank--1 { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
    .db-lb-rank--2 { background: linear-gradient(135deg, #94a3b8, #cbd5e1); }
    .db-lb-rank--3 { background: linear-gradient(135deg, #d97706, #f59e0b); }
    .db-lb-rank--n { background: #e2e8f0; color: #64748b; }
    .db-lb-name { flex: 1; font-size: .88rem; font-weight: 500; color: var(--text); }
    .db-lb-hours { font-family: 'Roboto Mono', monospace; font-size: .88rem; font-weight: 700; color: var(--green); }
    .db-lb-bar-wrap { flex: 1; max-width: 80px; height: 6px; border-radius: 3px; background: #e5e7eb; overflow: hidden; }
    .db-lb-bar { height: 100%; border-radius: 3px; background: var(--green); }

    /* ── Unread Summary Bar ── */
    .db-unread-bar { display: flex; align-items: center; gap: 8px; padding: 12px 18px; border-radius: 10px; background: #fefce8; border: 1px solid #fde68a; margin-bottom: 14px; font-size: .84rem; color: #92400e; }
    .db-unread-bar__count { font-weight: 700; color: #d97706; }
    .db-unread-bar__dot { width: 6px; height: 6px; border-radius: 50%; background: #f59e0b; flex-shrink: 0; }
    .db-unread-bar__from { color: #a16207; }

    /* ── Radar Chart ── */
    .db-radar-wrap { display: flex; align-items: flex-start; justify-content: center; padding: 8px 0; }
    .db-radar-wrap svg { max-width: 100%; height: auto; }
    .db-radar-label { font-size: 11px; fill: #555; font-family: 'Noto Serif SC', 'Microsoft YaHei', serif; }

    /* ── Cumulative Line Chart ── */
    .db-cumulative-wrap { display: flex; align-items: flex-start; justify-content: center; padding: 8px 0; }
    .db-cumulative-wrap svg { max-width: 100%; height: auto; }
    .db-cumulative-axis-label { font-size: 10px; fill: #888; font-family: 'Roboto Mono', monospace; }

    /* ── Analytics Two-Column ── */
    .db-analytics-row { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 22px; }

    /* ── Donut Chart (CSS conic-gradient) ── */
    .db-donut-type-wrap { display: flex; flex-direction: column; align-items: center; padding: 20px 24px; }
    .db-donut-type-ring { width: 200px; height: 200px; border-radius: 50%; position: relative; margin-bottom: 20px; }
    .db-donut-type-hole { position: absolute; left: 24%; top: 24%; right: 24%; bottom: 24%; background: #fff; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    .db-donut-type-total { font-size: 2.2rem; font-weight: 700; color: var(--text); font-family: 'Roboto Mono', monospace; }
    .db-donut-type-label { font-size: .75rem; color: var(--text-soft); margin-top: 2px; }

    /* ── Comparison Cards ── */
    .db-compare-grid { display: flex; flex-direction: column; gap: 14px; }
    .db-compare-item { display: flex; align-items: center; gap: 14px; }
    .db-compare-label { width: 90px; font-size: .82rem; color: var(--text); font-weight: 500; flex-shrink: 0; text-align: right; }
    .db-compare-bars { flex: 1; position: relative; }
    .db-compare-bar-row { position: relative; height: 22px; border-radius: 4px; background: #e5e7eb; margin-bottom: 4px; overflow: hidden; }
    .db-compare-bar-fill { height: 100%; border-radius: 4px; background: linear-gradient(90deg, #27AE60, #2ecc71); transition: width .6s ease; }
    .db-compare-bar-ref { position: absolute; top: 0; bottom: 0; width: 2px; background: #999; }
    .db-compare-bar-ref::after { content: attr(data-label); position: absolute; top: -16px; left: 50%; transform: translateX(-50%); font-size: .65rem; color: #999; white-space: nowrap; font-family: 'Roboto Mono', monospace; }
    .db-compare-vals { display: flex; justify-content: space-between; font-size: .72rem; color: var(--text-soft); font-family: 'Roboto Mono', monospace; margin-top: 2px; }
    .db-compare-vals .val-you { color: var(--green); font-weight: 600; }
    .db-compare-vals .val-avg { color: #999; }

    /* ── Responsive ── */
    @media (max-width: 960px) {
      .db-mobile-toggle { display: block; }
      .db-sidebar { position: fixed; top: var(--nav-height); left: 0; bottom: 0; transform: translateX(-100%); transition: transform .3s ease; height: calc(100vh - var(--nav-height)); }
      .db-sidebar.is-open { transform: translateX(0); }
      .db-main { padding: 20px 16px 28px; }
      .db-stat-grid { grid-template-columns: repeat(2, 1fr); }
      .db-hours-layout { grid-template-columns: 1fr; }
      .db-welcome { padding: 24px; }
      .db-welcome .db-total-hours { font-size: 2.2rem; }
      .db-analytics-row { grid-template-columns: 1fr; }
      .db-badge-grid { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 540px) {
      .db-stat-grid { grid-template-columns: 1fr; }
      .db-badge-grid { grid-template-columns: 1fr; }
      .db-quick-actions { flex-direction: column; }
      .db-quick-btn { width: 100%; text-align: center; }
    }
  </style>
</head>
<body data-page="dashboard">
  <div class="page-shell">
    <%@ include file="/WEB-INF/jspf/header.jspf" %>
    <div class="db-shell">
      <%-- Mobile Toggle --%>
      <button class="db-mobile-toggle" type="button" id="dbToggle">菜单</button>
      <div class="db-mobile-backdrop" id="dbBackdrop"></div>

      <%-- Sidebar --%>
      <aside class="db-sidebar" id="dbSidebar">
        <div class="db-sidebar__header">
          <div class="db-avatar">
            <img src="${pageContext.request.contextPath}/assets/images/avatar-1.jpg" alt="<%= displayName %>">
          </div>
          <div class="db-nickname"><%= displayName %></div>
          <div class="db-username">@<%= displayUsername %></div>
          <span class="db-role-tag<%= "1".equals(displayRole) ? " db-role-tag--admin" : "" %>"><%= roleLabel %></span>
        </div>
        <nav class="db-sidebar__nav" id="dbNav"></nav>
        <div class="db-sidebar__footer">
          <button class="db-logout-btn" onclick="location.href='${pageContext.request.contextPath}/auth?action=logout'">退出登录</button>
        </div>
      </aside>

      <%-- Main Content --%>
      <main class="db-main" id="dbMain">
        <%-- Tab 1: Overview --%>
        <div class="db-tab is-active" data-tab="overview">
          <div class="db-welcome">
            <h2>欢迎回来，<%= displayName %></h2>
            <div class="db-date" id="dbToday"></div>
            <div style="margin-top:6px;"><span style="font-size:.9rem;opacity:.85;">累计服务</span></div>
            <div class="db-total-hours"><span id="dbTotalHours">--</span><small>小时</small></div>
          </div>
          <div class="db-stat-grid">
            <div class="db-stat-card">
              <div class="db-stat-card__label">累计服务时长</div>
              <div class="db-stat-card__value"><span id="statTotalHours">--</span></div>
              <div class="db-stat-card__sub">小时</div>
            </div>
            <div class="db-stat-card">
              <div class="db-stat-card__label">参与活动数</div>
              <div class="db-stat-card__value"><span id="statActCount">--</span></div>
              <div class="db-stat-card__sub">场</div>
            </div>
            <div class="db-stat-card">
              <div class="db-stat-card__label">获得徽章数</div>
              <div class="db-stat-card__value"><span id="statBadgeCount">--</span></div>
              <div class="db-stat-card__sub">枚</div>
            </div>
            <div class="db-stat-card" id="statPointsCard">
              <div class="db-stat-card__label">⭐ 当前积分</div>
              <div class="db-stat-card__value"><span id="statPoints">--</span></div>
              <div class="db-stat-card__sub"><span id="statPointsLevel">--</span></div>
            </div>
          </div>
          <div class="db-section">
            <div class="db-section__head">
              <span class="db-section__title">最近报名</span>
              <a href="${pageContext.request.contextPath}/activities.jsp" style="font-size:.82rem;">查看全部</a>
            </div>
            <div id="overviewRegs" style="display:flex;flex-direction:column;gap:8px;"></div>
          </div>
          <div class="db-section">
            <div class="db-section__head">
              <span class="db-section__title">📊 本周数据趋势（志愿时长 + 积分）</span>
            </div>
            <div class="db-weekly-chart" id="weeklyChart"></div>
          </div>

          <%-- ===== 积分数据分析专区 ===== --%>
          <div class="db-analytics-row">
            <div class="db-section">
              <div class="db-section__head">
                <span class="db-section__title">📊 积分获取分析</span>
              </div>
              <div class="db-pts-source-wrap" id="ptsSourceChart"></div>
            </div>
            <div class="db-section">
              <div class="db-section__head">
                <span class="db-section__title">🏅 等级晋升进度</span>
              </div>
              <div class="db-level-progress" id="levelProgressBar"></div>
            </div>
          </div>

          <div class="db-section">
            <div class="db-section__head">
              <span class="db-section__title">📋 近期积分动态</span>
            </div>
            <div class="db-pts-timeline" id="ptsTimeline"></div>
          </div>
          <div class="db-quick-actions">
            <button class="db-quick-btn" onclick="location.href='${pageContext.request.contextPath}/activities.jsp'">浏览活动</button>
            <button class="db-quick-btn" onclick="location.href='${pageContext.request.contextPath}/heatmap.jsp'">查看热力图</button>
            <button class="db-quick-btn" onclick="location.href='${pageContext.request.contextPath}/timeline3d.jsp'">3D历程</button>
            <button class="db-quick-btn" style="background:linear-gradient(135deg,#fef3c7,#fde68a);border-color:#f59e0b;color:#92400e;font-weight:600;" onclick="location.href='${pageContext.request.contextPath}/points-mall.jsp'">前往积分商城兑换好礼</button>
          </div>
          <%-- 数据分析两栏：雷达图 + 累计曲线 --%>
          <div class="db-analytics-row">
            <div class="db-section">
              <div class="db-section__head">
                <span class="db-section__title">📊 个人能力雷达图</span>
              </div>
              <div class="db-radar-wrap" id="radarChart"></div>
            </div>
            <div class="db-section">
              <div class="db-section__head">
                <span class="db-section__title">📈 服务时长积累曲线</span>
              </div>
              <div class="db-cumulative-wrap" id="cumulativeChart"></div>
            </div>
          </div>

          <div class="db-section">
            <div class="db-section__head">
              <span class="db-section__title">🚀 本周推荐活动</span>
            </div>
            <div class="db-rec-cards" id="recCards"></div>
          </div>

          <%-- 活动类型分布饼图 --%>
          <div class="db-section">
            <div class="db-section__head">
              <span class="db-section__title">🧩 活动类型分布</span>
            </div>
            <div class="db-donut-type-wrap" id="typeDonutChart"></div>
          </div>
        </div>

        <%-- Tab 2: My Registrations --%>
        <div class="db-tab" data-tab="registrations">
          <div class="db-section">
            <div class="db-section__head"><span class="db-section__title">我的报名</span></div>
            <div class="db-filter-bar" id="regFilterBar">
              <button class="db-filter-btn is-active" data-filter="all">全部</button>
              <button class="db-filter-btn" data-filter="approved">已通过</button>
              <button class="db-filter-btn" data-filter="pending">待审核</button>
              <button class="db-filter-btn" data-filter="completed">已完成</button>
              <button class="db-filter-btn" data-filter="cancelled">已取消</button>
            </div>
            <div class="db-reg-list" id="regList"></div>
          </div>
        </div>

        <%-- Tab 3: Hours Detail --%>
        <div class="db-tab" data-tab="hours">
          <div class="db-hours-layout">
            <div class="db-section">
              <div class="db-section__head"><span class="db-section__title">时长来源分布</span></div>
              <div class="db-donut-wrap" id="donutChart"></div>
            </div>
            <div class="db-section">
              <div class="db-section__head"><span class="db-section__title">时长明细列表</span></div>
              <div style="overflow-x:auto;">
                <table class="db-hours-table">
                  <thead><tr><th>活动名称</th><th>来源</th><th>小时数</th><th>日期</th></tr></thead>
                  <tbody id="hoursTbody"></tbody>
                </table>
              </div>
            </div>
          </div>
          <div class="db-total-card">
            <div><div class="db-total-card__label">累计服务总时长</div></div>
            <div class="db-total-card__value"><span id="hoursTotalBig">--</span> h</div>
          </div>
          <div class="db-section" style="margin-top:22px;">
            <div class="db-section__head">
              <span class="db-section__title">📋 时长排行榜</span>
              <span style="font-size:.72rem;color:var(--text-soft);">本月 Top5</span>
            </div>
            <div class="db-lb-list" id="lbList"></div>
          </div>

          <%-- 活动参与对比 --%>
          <div class="db-section" style="margin-top:22px;">
            <div class="db-section__head">
              <span class="db-section__title">📋 你 vs 平台平均</span>
            </div>
            <div class="db-compare-grid" id="compareGrid"></div>
          </div>
        </div>

        <%-- Tab 4: Messages --%>
        <div class="db-tab" data-tab="messages">
          <div class="db-section">
            <div class="db-section__head">
              <span class="db-section__title">消息通知</span>
              <span style="font-size:.8rem;color:var(--text-soft);"><span id="msgUnreadCount">0</span> 条未读</span>
            </div>
            <div class="db-unread-bar" id="unreadSummary" style="display:none;">
              <span class="db-unread-bar__dot"></span>
              <span><span class="db-unread-bar__count" id="unreadCount">0</span>条未读</span>
              <span>&middot;</span>
              <span>最近来自 <span class="db-unread-bar__from" id="unreadFrom">--</span></span>
            </div>
            <div class="db-msg-list" id="msgList"></div>
          </div>
        </div>

        <%-- Tab 5: Badges --%>
        <div class="db-tab" data-tab="badges">
          <div class="db-section">
            <div class="db-section__head"><span class="db-section__title">成就徽章</span></div>
            <div class="db-badge-grid" id="badgeGrid"></div>
          </div>
        </div>

        <%-- Tab 6: Settings --%>
        <div class="db-tab" data-tab="settings">
          <div class="db-section">
            <div class="db-section__head"><span class="db-section__title">个人设置</span></div>
            <form class="db-form" id="settingsForm" onsubmit="return handleSettingsSave(event)">
              <div class="db-form-group">
                <label class="db-form-label">昵称</label>
                <input class="db-form-input" type="text" id="setNickname" value="<%= displayName %>" placeholder="请输入昵称">
              </div>
              <div class="db-form-group">
                <label class="db-form-label">手机号</label>
                <input class="db-form-input" type="text" id="setPhone" value="<%= displayPhone %>" readonly placeholder="未绑定">
              </div>
              <div class="db-form-group">
                <label class="db-form-label">旧密码</label>
                <input class="db-form-input" type="password" id="setOldPwd" placeholder="输入当前密码">
              </div>
              <div class="db-form-group">
                <label class="db-form-label">新密码</label>
                <input class="db-form-input" type="password" id="setNewPwd" placeholder="输入新密码（留空不修改）">
              </div>
              <div class="db-form-group">
                <label class="db-form-label">确认新密码</label>
                <input class="db-form-input" type="password" id="setConfirmPwd" placeholder="再次输入新密码">
              </div>
              <button type="submit" class="db-form-submit">保存设置</button>
            </form>
          </div>
        </div>
      </main>
    </div>
  </div>

  <script>
    window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
    window.APP_USER_ROLE = "<%= displayRole %>";
    window.APP_USER_NAME = "<%= displayName %>";
  </script>
  <script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/data.js"></script>
  <script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/points.js"></script>
  <script>
    // ==================== Dashboard Engine ====================
    (function(){
      var D = window.VolunteerStarData;
      if (!D || !D.dashboard) return;

      var ctx = window.APP_CONTEXT_PATH || '';

      function $(sel) { return document.querySelector(sel); }
      function $$(sel) { return document.querySelectorAll(sel); }
      function esc(s) { return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

      // ── Sidebar Nav ──
      var menuItems = D.dashboard.menuItems || [];
      var TAB_LABELS = {
        overview: '概览', registrations: '我的报名', hours: '时长明细',
        timeline3d: '3D历程', messages: '消息通知', badges: '成就徽章', settings: '个人设置'
      };
      var TAB_ICONS = {
        overview: '\u25A3', registrations: '\u2630', hours: '\u29D6',
        timeline3d: '\uD83C\uDF10', messages: '\u2709', badges: '\u2605', settings: '\u2699'
      };

      function buildNav() {
        var nav = $('#dbNav');
        if (!nav) return;
        var h = '';
        for (var i = 0; i < menuItems.length; i++) {
          var m = menuItems[i];
          h += '<button class="db-nav-item' + (m.id === 'overview' ? ' is-active' : '') + '" data-nav="' + m.id + '">';
          h += '<span class="nav-icon">' + (TAB_ICONS[m.id] || '\u25CF') + '</span>';
          h += esc(m.label || TAB_LABELS[m.id] || m.id);
          h += '</button>';
        }
        nav.innerHTML = h;
      }

      function switchTab(tabId) {
        if (tabId === 'timeline3d') {
          window.location.href = ctx + '/timeline3d.jsp';
          return;
        }
        $$('.db-tab').forEach(function(t){ t.classList.remove('is-active'); });
        $$('.db-nav-item').forEach(function(b){ b.classList.remove('is-active'); });
        var tab = $('[data-tab="' + tabId + '"]');
        var btn = $('[data-nav="' + tabId + '"]');
        if (tab) tab.classList.add('is-active');
        if (btn) btn.classList.add('is-active');
        // Close mobile sidebar after click
        if (window.innerWidth <= 960) toggleSidebar(false);
        // Trigger tab-specific rendering
        if (tabId === 'registrations') renderRegistrations();
        if (tabId === 'hours') renderHours();
        if (tabId === 'messages') renderMessages();
        if (tabId === 'badges') renderBadges();
      }

      // ── Mobile Sidebar ──
      function toggleSidebar(force) {
        var sidebar = $('#dbSidebar');
        var backdrop = $('#dbBackdrop');
        if (!sidebar) return;
        var open = typeof force === 'boolean' ? force : !sidebar.classList.contains('is-open');
        sidebar.classList.toggle('is-open', open);
        if (backdrop) backdrop.classList.toggle('is-open', open);
      }

      $('#dbToggle') && $('#dbToggle').addEventListener('click', function(){ toggleSidebar(); });
      $('#dbBackdrop') && $('#dbBackdrop').addEventListener('click', function(){ toggleSidebar(false); });

      // ── Nav Clicks ──
      $('#dbNav') && $('#dbNav').addEventListener('click', function(e){
        var btn = e.target.closest('[data-nav]');
        if (!btn) return;
        switchTab(btn.getAttribute('data-nav'));
      });

      // ── Today Date ──
      (function(){
        var now = new Date();
        var wd = ['日','一','二','三','四','五','六'];
        var el = $('#dbToday');
        if (el) el.textContent = now.getFullYear() + '年' + (now.getMonth()+1) + '月' + now.getDate() + '日 星期' + wd[now.getDay()];
      })();

      // ── Status Helpers ──
      function statusClass(status) {
        var m = { approved: 'badge-approved', pending: 'badge-pending', completed: 'badge-completed', cancelled: 'badge-cancelled' };
        return m[status] || 'badge-pending';
      }
      function statusLabel(status) {
        var m = { approved: '已通过', pending: '待审核', completed: '已完成', cancelled: '已取消' };
        return m[status] || status;
      }

      // ── Data Merging: combine JS data + API data ──
      var _hourSummary = null; // from API
      var _hourChanges = [];   // from API
      var _apiRegs = [];       // from API
      var _apiRegsLoaded = false;

      function getRegistrationsData() {
        return _apiRegsLoaded ? _apiRegs : (D.dashboard.myRegistrations || []);
      }

      function getHoursSourceData() {
        // Merge API data with static data
        if (_hourChanges && _hourChanges.length > 0) {
          var totals = {};
          for (var i = 0; i < _hourChanges.length; i++) {
            var s = _hourChanges[i].changeSource || 'sign_auto';
            totals[s] = (totals[s] || 0) + (_hourChanges[i].changeHour || 0);
          }
          var labels = { sign_auto: '签到自动', admin_manual: '管理员录入', user_apply: '自主申请' };
          var colors = { sign_auto: '#27AE60', admin_manual: '#2C3E50', user_apply: '#F0C14B' };
          var result = [];
          for (var k in totals) {
            result.push({ name: labels[k] || k, value: totals[k], color: colors[k] || '#999' });
          }
          if (result.length > 0) return result;
        }
        return (D.dashboard.hoursSourceData || []).map(function(x){ return { name: x.name || x.label, value: x.value, color: x.color }; });
      }

      function getHoursDetail() {
        if (_hourChanges && _hourChanges.length > 0) {
          return _hourChanges.map(function(x){
            var srcLabels = { sign_auto: '签到自动', admin_manual: '管理员录入', user_apply: '自主申请' };
            return {
              id: x.id, activity: x.activityTitle || '-', source: srcLabels[x.changeSource] || x.changeSource || '-',
              hours: x.changeHour || 0, date: (x.createTime || '').substring(0,10), note: x.changeReason || ''
            };
          });
        }
        return D.dashboard.hoursDetail || [];
      }

      function getTotalHours() {
        if (_hourSummary && _hourSummary.totalServiceHour != null) return _hourSummary.totalServiceHour;
        var detail = getHoursDetail();
        var total = 0;
        for (var i = 0; i < detail.length; i++) total += detail[i].hours || 0;
        return total;
      }

      function getActivityCount() {
        if (_hourSummary && _hourSummary.totalActivityCount != null) return _hourSummary.totalActivityCount;
        var regs = getRegistrationsData();
        return regs.length;
      }

      // ── Tab: Overview ──
      function renderOverview() {
        var totalH = getTotalHours();
        $('#dbTotalHours') && ($('#dbTotalHours').textContent = totalH.toFixed(1));
        $('#statTotalHours') && ($('#statTotalHours').textContent = totalH.toFixed(1));
        $('#statActCount') && ($('#statActCount').textContent = getActivityCount());

        var badges = D.dashboard.badges || [];
        var unlocked = 0;
        for (var i = 0; i < badges.length; i++) {
          if (!badges[i].locked) unlocked++;
        }
        $('#statBadgeCount') && ($('#statBadgeCount').textContent = unlocked);

        var msgs = D.dashboard.messages || [];
        var unread = 0;
        for (var j = 0; j < msgs.length; j++) {
          if (!msgs[j].read) unread++;
        }
        $('#statUnread') && ($('#statUnread').textContent = unread);

        // Recent registrations
        var regs = getRegistrationsData();
        var recent = regs.slice(0, 5);
        var container = $('#overviewRegs');
        if (!container) return;
        if (recent.length === 0) {
          container.innerHTML = '<div class="db-empty">暂无报名记录</div>';
          return;
        }
        var h = '';
        for (var k = 0; k < recent.length; k++) {
          var r = recent[k];
          var statusKey = typeof r.status === 'number' ? ({0:'pending',1:'approved',2:'rejected',3:'cancelled',4:'completed'}[r.status]||'pending') : r.status;
          var title = r.activityTitle || r.activity || '-';
          var date = r.date || r.registerTime || '-';
          h += '<div class="db-reg-item">';
          h += '<div class="db-reg-item__info"><div class="db-reg-item__title">' + esc(title) + '</div><div class="db-reg-item__date">' + esc(date) + '</div></div>';
          h += '<span class="badge-status ' + statusClass(statusKey) + '">' + statusLabel(statusKey) + '</span>';
          h += '</div>';
        }
        container.innerHTML = h;

        // ── Weekly hours trend ──
        renderWeeklyChart();

        // ── Analytics modules ──
        renderRadarChart();
        renderCumulativeChart();
        renderTypeDonutChart();

        // ── Recommended activities ──
        renderRecCards();

        // ── Points analytics ──
        renderPtsSourceChart();
        renderLevelProgress();
        renderPtsTimeline();
      }

      // ── Weekly Chart: Dual Bars (Hours + Points) ──
      function renderWeeklyChart() {
        var $wc = $('#weeklyChart');
        if (!$wc) return;
        var days = ['周一','周二','周三','周四','周五','周六','周日'];
        var hourVals = [3.5, 5.0, 2.0, 6.5, 4.0, 0, 0];

        // Calculate weekly points from history
        var ptsVals = [0,0,0,0,0,0,0];
        try {
          var s = localStorage.getItem('volstar_points');
          if (s) {
            var d = JSON.parse(s);
            var now = new Date();
            var dayOfWeek = now.getDay(); // 0=Sun
            var mondayOffset = dayOfWeek === 0 ? -6 : (1 - dayOfWeek);
            var monday = new Date(now);
            monday.setDate(now.getDate() + mondayOffset);
            monday.setHours(0,0,0,0);
            if (d.history) {
              for (var i = 0; i < d.history.length; i++) {
                var h = d.history[i];
                var amt = h.amount || 0;
                if (amt <= 0) continue;
                var ht = new Date(h.time);
                var diffDays = Math.floor((ht.getTime() - monday.getTime()) / (1000*60*60*24));
                if (diffDays >= 0 && diffDays < 7) ptsVals[diffDays] += amt;
              }
            }
          }
        } catch(e) {}

        var maxH = Math.max.apply(null, hourVals);
        var maxP = Math.max.apply(null, ptsVals);
        var maxAll = Math.max(maxH, maxP * 2, 10); // normalize scale

        // Legend
        var legend = '<div class="db-weekly-legend"><span><span class="db-weekly-legend-dot db-weekly-legend-dot--h"></span>时长(h)</span><span><span class="db-weekly-legend-dot db-weekly-legend-dot--p"></span>积分</span></div>';

        var chart = '';
        for (var i = 0; i < days.length; i++) {
          var hHt = maxAll > 0 ? Math.max(6, Math.round(hourVals[i] / maxAll * 130)) : 4;
          var pHt = maxAll > 0 ? Math.max(6, Math.round(ptsVals[i] / maxAll * 130 / 2)) : 4;
          var hWeak = hourVals[i] < maxH * 0.3 ? ' db-weekly-bar--weak-h' : '';
          var pWeak = ptsVals[i] < maxP * 0.3 ? ' db-weekly-bar--weak-p' : '';
          chart += '<div class="db-weekly-bar-wrap">';
          if (hourVals[i] > 0 || ptsVals[i] > 0) {
            chart += '<span class="db-weekly-val">'+(hourVals[i] > 0 ? hourVals[i].toFixed(1)+'h' : '')+'</span>';
            chart += '<span class="db-weekly-val db-weekly-val--pts">'+(ptsVals[i] > 0 ? '+'+(ptsVals[i] > 9 ? ptsVals[i] : '0'+ptsVals[i]) : '')+'</span>';
          } else {
            chart += '<span class="db-weekly-val" style="color:#cbd5e1;">-</span><span class="db-weekly-val" style="color:#cbd5e1;">-</span>';
          }
          chart += '<div class="db-weekly-bar-pair">';
          chart += '<div class="db-weekly-bar db-weekly-bar--hours'+hWeak+'" style="height:'+hHt+'px;"></div>';
          chart += '<div class="db-weekly-bar db-weekly-bar--points'+pWeak+'" style="height:'+pHt+'px;"></div>';
          chart += '</div>';
          chart += '<span class="db-weekly-day">'+days[i]+'</span>';
          chart += '</div>';
        }
        $wc.innerHTML = legend + '<div style="display:flex;align-items:flex-end;gap:10px;height:130px;padding:0 4px;">'+chart.replace(/<div class="db-weekly-bar-wrap">/g,'').replace(/<\/div>$|<\/div><\/div>/g,'')+'</div>';
        // Actually, let me redo this cleaner:
        $wc.innerHTML = legend + '<div style="display:flex;align-items:flex-end;gap:10px;height:130px;padding:0 4px;" id="weeklyBars"></div>';
        var barsEl = document.getElementById('weeklyBars');
        if (!barsEl) return;
        var barsHtml = '';
        for (var j = 0; j < days.length; j++) {
          var hh = maxAll > 0 ? Math.max(6, Math.round(hourVals[j] / maxAll * 120)) : 4;
          var ph = maxAll > 0 ? Math.max(6, Math.round(ptsVals[j] / maxAll * 120 / 2)) : 4;
          var hWk = hourVals[j] < maxH * 0.3 ? ' db-weekly-bar--weak-h' : '';
          var pWk = ptsVals[j] < maxP * 0.3 ? ' db-weekly-bar--weak-p' : '';
          barsHtml += '<div class="db-weekly-bar-wrap">';
          barsHtml += '<span class="db-weekly-val">'+(hourVals[j] > 0 ? hourVals[j].toFixed(1)+'h' : '')+'</span>';
          barsHtml += '<span class="db-weekly-val db-weekly-val--pts">'+(ptsVals[j] > 0 ? '+'+(ptsVals[j] > 9 ? ptsVals[j] : '0'+ptsVals[j]) : '')+'</span>';
          barsHtml += '<div class="db-weekly-bar-pair">';
          barsHtml += '<div class="db-weekly-bar db-weekly-bar--hours'+hWk+'" style="height:'+hh+'px;"></div>';
          barsHtml += '<div class="db-weekly-bar db-weekly-bar--points'+pWk+'" style="height:'+ph+'px;"></div>';
          barsHtml += '</div><span class="db-weekly-day">'+days[j]+'</span></div>';
        }
        barsEl.innerHTML = barsHtml;
      }

      // ── Recommended Cards Helper ──
      function renderRecCards() {
        var $rc = $('#recCards');
        if (!$rc) return;
        var acts = window.VolunteerStarData && window.VolunteerStarData.activities ? window.VolunteerStarData.activities : [];
        var recs = [];
        if (acts.length > 0) {
          recs = acts.slice(0, 2);
        }
        if (recs.length === 0) {
          $rc.innerHTML = '<div class="db-empty" style="font-size:.8rem;">暂无推荐活动</div>';
          return;
        }
        var h = '';
        for (var i = 0; i < recs.length; i++) {
          var a = recs[i];
          h += '<div class="db-rec-card" onclick="location.href=\'' + ctx + '/activities.jsp?id=' + a.id + '\'">';
          h += '<div class="db-rec-card__icon">' + (i === 0 ? '\u2605' : '\u2666') + '</div>';
          h += '<div class="db-rec-card__info">';
          h += '<div class="db-rec-card__title">' + esc(a.title || '活动') + '</div>';
          h += '<div class="db-rec-card__date">' + esc(a.date || '') + '</div>';
          h += '</div></div>';
        }
        $rc.innerHTML = h;
      }

      // ═══════════════════════════════════════════
      // Points: Source Donut Chart
      // ═══════════════════════════════════════════
      function renderPtsSourceChart() {
        var $el = $('#ptsSourceChart');
        if (!$el) return;

        // Calculate points by source from history
        var sourceTotals = {};
        var totalEarned = 0;
        try {
          var s = localStorage.getItem('volstar_points');
          if (s) {
            var d = JSON.parse(s);
            if (d.history) {
              for (var i = 0; i < d.history.length; i++) {
                var h = d.history[i];
                if (h.amount <= 0) continue;
                totalEarned += h.amount;
                var reason = h.reason || '';
                // Categorize
                var cat = '其他';
                if (reason.indexOf('签到') >= 0) cat = '每日签到';
                else if (reason.indexOf('发布活动') >= 0 || reason.indexOf('活动') >= 0) cat = '志愿活动';
                else if (reason.indexOf('帖子') >= 0) cat = '发帖互动';
                else if (reason.indexOf('点赞') >= 0) cat = '获得点赞';
                else if (reason.indexOf('评论') >= 0) cat = '获得评论';
                else if (reason.indexOf('分享') >= 0) cat = '分享动态';
                sourceTotals[cat] = (sourceTotals[cat] || 0) + h.amount;
              }
            }
          }
        } catch(e) {}

        var sources = [
          { key: '每日签到', label: '每日签到', color: '#27ae60', icon: '📅' },
          { key: '志愿活动', label: '志愿活动',  color: '#3b82f6', icon: '✅' },
          { key: '发帖互动', label: '发帖互动',  color: '#7c3aed', icon: '🌍' },
          { key: '获得点赞', label: '获得点赞',  color: '#ec4899', icon: '❤️' },
          { key: '获得评论', label: '获得评论',  color: '#f59e0b', icon: '💬' },
          { key: '分享动态', label: '分享动态',  color: '#f97316', icon: '📤' }
        ];

        if (totalEarned === 0) {
          $el.innerHTML = '<div style="text-align:center;color:#94a3b8;padding:30px;">暂无积分收入数据<br><span style="font-size:.78rem;">去签到或参与活动获取积分吧</span></div>';
          return;
        }

        // Build conic-gradient donut
        var gradientParts = [];
        var cumulative = 0;
        var listItems = '';
        for (var i = 0; i < sources.length; i++) {
          var sc = sources[i];
          var val = sourceTotals[sc.key] || 0;
          if (val === 0) continue;
          var pct = Math.round(val / totalEarned * 100);
          gradientParts.push(sc.color + ' ' + cumulative + '% ' + (cumulative + pct) + '%');
          cumulative += pct;
          listItems += '<div class="db-pts-source-item">' +
            '<span class="db-pts-source-dot" style="background:' + sc.color + '"></span>' +
            '<span>' + sc.icon + ' ' + sc.label + '</span>' +
            '<span class="db-pts-source-val" style="color:' + sc.color + '">+' + val + '</span></div>';
        }
        // Fill remaining with gray
        if (cumulative < 100) {
          gradientParts.push('#e5e7eb ' + cumulative + '% 100%');
        }

        var donutStyle = 'background: conic-gradient(' + gradientParts.join(',') + ')';
        $el.innerHTML =
          '<div class="db-pts-source-ring" style="' + donutStyle + '">' +
            '<div class="db-pts-source-hole">' +
              '<span class="db-pts-source-total">' + totalEarned + '</span>' +
              '<span class="db-pts-source-label">累计获得</span>' +
            '</div>' +
          '</div>' +
          '<div class="db-pts-source-list">' + listItems + '</div>';
      }

      // ═══════════════════════════════════════════
      // Points: Level Progress Bar
      // ═══════════════════════════════════════════
      function renderLevelProgress() {
        var $el = $('#levelProgressBar');
        if (!$el) return;

        var levelInfo = [
          { name:'新星志愿者', min:0, max:200 },
          { name:'青铜志愿者', min:200, max:500 },
          { name:'白银志愿者', min:500, max:1000 },
          { name:'黄金志愿者', min:1000, max:1500 },
          { name:'钻石志愿者', min:1500, max:2000 },
          { name:'传奇志愿者', min:2000, max:99999 }
        ];

        var currentLevel = '新星志愿者';
        var currentPts = 0;
        if (typeof window.getUserPoints === 'function') currentPts = window.getUserPoints();
        if (typeof window.getUserLevel === 'function') currentLevel = window.getUserLevel();

        // Find current level tier
        var curTier = levelInfo[0];
        var nextTier = levelInfo[1];
        for (var i = 0; i < levelInfo.length; i++) {
          if (levelInfo[i].name === currentLevel) {
            curTier = levelInfo[i];
            nextTier = levelInfo[i + 1] || levelInfo[i];
            break;
          }
        }

        var rangeMin = curTier.min;
        var rangeMax = nextTier.max;
        var progress = 100; // max level
        var remaining = 0;
        var nextName = curTier.name;

        if (nextTier.name !== curTier.name) {
          rangeMin = curTier.min;
          rangeMax = nextTier.min;
          progress = Math.min(100, Math.round((currentPts - rangeMin) / (rangeMax - rangeMin) * 100));
          remaining = rangeMax - currentPts;
          nextName = nextTier.name;
        }

        var levelColor = '#27ae60';
        if (typeof window.getUserLevelColor === 'function') levelColor = window.getUserLevelColor();

        $el.innerHTML =
          '<div class="db-level-progress__info">' +
            '<span class="db-level-progress__cur" style="color:' + levelColor + '">🏅 ' + currentLevel + ' · ⭐ ' + currentPts + ' 积分</span>' +
            (remaining > 0 ? '<span class="db-level-progress__next">距 ' + nextName + ' 还需 ' + remaining + ' 积分</span>' : '<span class="db-level-progress__next" style="color:#f59e0b;">👑 已达最高等级！</span>') +
          '</div>' +
          '<div class="db-level-progress__bar">' +
            '<div class="db-level-progress__fill" style="width:' + progress + '%;background:linear-gradient(90deg,' + levelColor + ',#' + levelColor.replace('#','') + 'cc)"></div>' +
          '</div>' +
          '<div style="display:flex;justify-content:space-between;font-size:.7rem;color:#94a3b8;margin-top:4px;">' +
            '<span>' + rangeMin + '</span><span style="color:#7c3aed;">' + currentPts + '</span><span>' + rangeMax + '</span>' +
          '</div>';
      }

      // ═══════════════════════════════════════════
      // Points: History Timeline
      // ═══════════════════════════════════════════
      function renderPtsTimeline() {
        var $el = $('#ptsTimeline');
        if (!$el) return;

        var history = [];
        if (typeof window.getAllPointsHistory === 'function') {
          history = window.getAllPointsHistory();
        } else {
          try {
            var s = localStorage.getItem('volstar_points');
            if (s) {
              var d = JSON.parse(s);
              history = (d.history || []).slice().reverse();
            }
          } catch(e) {}
        }

        // Limit to last 20 entries
        history = history.slice(0, 20);

        if (history.length === 0) {
          $el.innerHTML = '<div class="db-empty">暂无积分变动记录<br><span style="font-size:.78rem;">去签到或参与活动获取积分吧</span></div>';
          return;
        }

        var html = '';
        for (var i = 0; i < history.length; i++) {
          var h = history[i];
          var isEarn = h.amount > 0;
          var icon = isEarn ? '↑' : '↓';
          var iconCls = isEarn ? ' db-pts-tl-icon--earn' : ' db-pts-tl-icon--spend';
          var amtCls = isEarn ? ' db-pts-tl-amount--earn' : ' db-pts-tl-amount--spend';
          var amtStr = (isEarn ? '+' : '') + h.amount;

          // Format time
          var timeStr = '';
          try {
            var d = new Date(h.time);
            timeStr = (d.getMonth()+1) + '/' + d.getDate() + ' ' +
                      String(d.getHours()).padStart(2,'0') + ':' + String(d.getMinutes()).padStart(2,'0');
          } catch(e) { timeStr = ''; }

          html += '<div class="db-pts-tl-item">' +
            '<div class="db-pts-tl-icon' + iconCls + '">' + icon + '</div>' +
            '<div class="db-pts-tl-info">' +
              '<div class="db-pts-tl-reason">' + (h.reason || '积分变动') + '</div>' +
              '<div class="db-pts-tl-time">' + timeStr + '</div>' +
            '</div>' +
            '<span class="db-pts-tl-amount' + amtCls + '">' + amtStr + '</span>' +
          '</div>';
        }
        $el.innerHTML = html;
      }

      // ═══════════════════════════════════════════
      // Module 1: 个人能力雷达图 (纯SVG)
      // ═══════════════════════════════════════════
      function renderRadarChart() {
        var $rc = $('#radarChart');
        if (!$rc) return;

        var axes = [
          { label: '社区服务', key: '社区服务' },
          { label: '环境保护', key: '环境保护' },
          { label: '教育帮扶', key: '教育帮扶' },
          { label: '助残扶弱', key: '助残扶弱' },
          { label: '文明创建', key: '文明创建' },
          { label: '文化惠民', key: '文化惠民' }
        ];

        // Count user's activity types from myRegistrations
        var regs = getRegistrationsData();
        var acts = D.activities || [];
        var catCount = {};
        for (var i = 0; i < regs.length; i++) {
          var r = regs[i];
          var title = r.activityTitle || r.activity || '';
          // Find matching activity in activities array
          for (var j = 0; j < acts.length; j++) {
            if (acts[j].title === title) {
              var cat = acts[j].category;
              catCount[cat] = (catCount[cat] || 0) + 1;
              break;
            }
          }
        }
        // Merge with dashboard registrations that might not have activities
        if (Object.keys(catCount).length === 0 && D.dashboard.myRegistrations) {
          // Fallback: distribute demo data
          catCount = { '社区服务': 2, '环境保护': 1, '教育帮扶': 1, '助残扶弱': 1, '文明创建': 1, '文化惠民': 0 };
        }

        var maxLevel = 5;
        var values = [];
        for (var k = 0; k < axes.length; k++) {
          var v = catCount[axes[k].key] || 0;
          values.push(Math.min(maxLevel, v));
        }

        var cx = 170, cy = 170, r = 130;
        var svgW = 340, svgH = 340;

        var svg = '<svg viewBox="0 0 ' + svgW + ' ' + svgH + '" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:340px;">';

        // Gray hexagon background grid
        for (var level = 1; level <= maxLevel; level++) {
          var lr = r * level / maxLevel;
          var pts = [];
          for (var a = 0; a < 6; a++) {
            var angle = -Math.PI / 2 + a * Math.PI / 3;
            pts.push((cx + lr * Math.cos(angle)).toFixed(1) + ',' + (cy + lr * Math.sin(angle)).toFixed(1));
          }
          svg += '<polygon points="' + pts.join(' ') + '" fill="none" stroke="#d1d5db" stroke-width="1" />';
        }

        // Axis lines
        for (var a = 0; a < 6; a++) {
          var angle = -Math.PI / 2 + a * Math.PI / 3;
          var ex = cx + r * Math.cos(angle);
          var ey = cy + r * Math.sin(angle);
          svg += '<line x1="' + cx + '" y1="' + cy + '" x2="' + ex.toFixed(1) + '" y2="' + ey.toFixed(1) + '" stroke="#d1d5db" stroke-width="1" />';
        }

        // Data polygon fill
        var dataPts = [];
        for (var a = 0; a < 6; a++) {
          var angle = -Math.PI / 2 + a * Math.PI / 3;
          var dr = r * values[a] / maxLevel;
          dataPts.push((cx + dr * Math.cos(angle)).toFixed(1) + ',' + (cy + dr * Math.sin(angle)).toFixed(1));
        }
        svg += '<polygon points="' + dataPts.join(' ') + '" fill="rgba(39,174,96,0.2)" stroke="#27AE60" stroke-width="2" />';

        // Data points
        for (var a = 0; a < 6; a++) {
          var angle = -Math.PI / 2 + a * Math.PI / 3;
          var dr = r * values[a] / maxLevel;
          var dx = cx + dr * Math.cos(angle);
          var dy = cy + dr * Math.sin(angle);
          svg += '<circle cx="' + dx.toFixed(1) + '" cy="' + dy.toFixed(1) + '" r="4" fill="#27AE60" stroke="#fff" stroke-width="1.5" />';
        }

        // Axis labels
        for (var a = 0; a < 6; a++) {
          var angle = -Math.PI / 2 + a * Math.PI / 3;
          var lx = cx + (r + 22) * Math.cos(angle);
          var ly = cy + (r + 22) * Math.sin(angle);
          var anchor = 'middle';
          if (Math.abs(angle + Math.PI/2) < 0.1) anchor = 'middle';
          else if (Math.cos(angle) > 0.1) anchor = 'start';
          else if (Math.cos(angle) < -0.1) anchor = 'end';
          svg += '<text x="' + lx.toFixed(1) + '" y="' + (ly + 4).toFixed(1) + '" text-anchor="' + anchor + '" class="db-radar-label">' + axes[a].label + '</text>';
        }

        // Level number labels on the first axis
        for (var level = 1; level <= maxLevel; level++) {
          var lr2 = r * level / maxLevel;
          var angle2 = -Math.PI / 2;
          var tx = cx + lr2 * Math.cos(angle2);
          var ty = cy + lr2 * Math.sin(angle2);
          svg += '<text x="' + (tx - 6).toFixed(1) + '" y="' + (ty + 3).toFixed(1) + '" text-anchor="end" font-size="8" fill="#aaa" font-family="Roboto Mono,monospace">' + level + '</text>';
        }

        svg += '</svg>';
        $rc.innerHTML = svg;
      }

      // ═══════════════════════════════════════════
      // Module 2: 服务时长积累曲线 (纯SVG)
      // ═══════════════════════════════════════════
      function renderCumulativeChart() {
        var $cc = $('#cumulativeChart');
        if (!$cc) return;

        var trendData = D.monthlyTrend || [];
        if (trendData.length === 0) return;

        var cumulative = [];
        var total = 0;
        for (var i = 0; i < trendData.length; i++) {
          total += trendData[i].hours || 0;
          cumulative.push({ month: trendData[i].month, hours: total });
        }

        var w = 320, h = 240;
        var padL = 50, padR = 20, padT = 20, padB = 40;
        var chartW = w - padL - padR;
        var chartH = h - padT - padB;

        var maxH = cumulative[cumulative.length - 1].hours;
        var yMax = Math.ceil(maxH / 50) * 50;
        if (yMax < maxH) yMax += 50;

        function xPos(idx) { return padL + (idx / (cumulative.length - 1)) * chartW; }
        function yPos(val) { return padT + chartH - (val / yMax) * chartH; }

        // Build SVG
        var svg = '<svg viewBox="0 0 ' + w + ' ' + h + '" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:340px;">';

        // Gradient definition
        svg += '<defs><linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">';
        svg += '<stop offset="0%" stop-color="#27AE60" stop-opacity="0.35" />';
        svg += '<stop offset="100%" stop-color="#27AE60" stop-opacity="0.02" />';
        svg += '</linearGradient></defs>';

        // Y-axis grid lines
        var gridSteps = 4;
        for (var g = 0; g <= gridSteps; g++) {
          var gv = Math.round(yMax * g / gridSteps);
          var gy = yPos(gv);
          svg += '<line x1="' + padL + '" y1="' + gy.toFixed(1) + '" x2="' + (w - padR) + '" y2="' + gy.toFixed(1) + '" stroke="#e5e7eb" stroke-width="1" />';
          svg += '<text x="' + (padL - 8) + '" y="' + (gy + 4).toFixed(1) + '" text-anchor="end" class="db-cumulative-axis-label">' + gv + 'h</text>';
        }

        // X-axis labels
        for (var m = 0; m < cumulative.length; m++) {
          var mx = xPos(m);
          svg += '<line x1="' + mx.toFixed(1) + '" y1="' + (padT + chartH) + '" x2="' + mx.toFixed(1) + '" y2="' + (padT + chartH + 5) + '" stroke="#d1d5db" stroke-width="1" />';
          svg += '<text x="' + mx.toFixed(1) + '" y="' + (padT + chartH + 18) + '" text-anchor="middle" class="db-cumulative-axis-label" style="font-family:\'Noto Serif SC\',\'Microsoft YaHei\',serif;font-size:10px;">' + cumulative[m].month + '</text>';
        }

        // Area fill polygon
        var areaPts = padL + ',' + (padT + chartH);
        for (var a = 0; a < cumulative.length; a++) {
          areaPts += ' ' + xPos(a).toFixed(1) + ',' + yPos(cumulative[a].hours).toFixed(1);
        }
        areaPts += ' ' + xPos(cumulative.length - 1).toFixed(1) + ',' + (padT + chartH);
        svg += '<polygon points="' + areaPts + '" fill="url(#areaGrad)" />';

        // Line path
        var linePts = '';
        for (var l = 0; l < cumulative.length; l++) {
          linePts += (l === 0 ? 'M' : 'L') + xPos(l).toFixed(1) + ',' + yPos(cumulative[l].hours).toFixed(1) + ' ';
        }
        svg += '<path d="' + linePts + '" fill="none" stroke="#27AE60" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round" />';

        // Data points
        for (var p = 0; p < cumulative.length; p++) {
          var px = xPos(p), py = yPos(cumulative[p].hours);
          svg += '<circle cx="' + px.toFixed(1) + '" cy="' + py.toFixed(1) + '" r="4" fill="#fff" stroke="#27AE60" stroke-width="2" />';
          // Value label
          svg += '<text x="' + px.toFixed(1) + '" y="' + (py - 10).toFixed(1) + '" text-anchor="middle" font-size="9" fill="#27AE60" font-weight="600" font-family="Roboto Mono,monospace">' + cumulative[p].hours.toFixed(0) + 'h</text>';
        }

        svg += '</svg>';
        $cc.innerHTML = svg;
      }

      // ═══════════════════════════════════════════
      // Module 4: 活动类型分布饼图 (CSS conic-gradient)
      // ═══════════════════════════════════════════
      function renderTypeDonutChart() {
        var $td = $('#typeDonutChart');
        if (!$td) return;

        var typeData = D.activityTypes || [
          { name: '社区服务', count: 12, color: '#27AE60' },
          { name: '环境保护', count: 10, color: '#2C3E50' },
          { name: '教育帮扶', count: 8, color: '#5B9BD5' },
          { name: '助残扶弱', count: 7, color: '#E8634B' },
          { name: '文明创建', count: 6, color: '#F0C14B' },
          { name: '文化惠民', count: 4, color: '#9B7ED9' }
        ];

        var total = 0;
        for (var i = 0; i < typeData.length; i++) total += typeData[i].count;

        // Build conic-gradient segments
        var accum = 0;
        var segs = [];
        for (var j = 0; j < typeData.length; j++) {
          var start = total > 0 ? (accum / total * 360) : 0;
          accum += typeData[j].count;
          var end = total > 0 ? (accum / total * 360) : 0;
          segs.push(typeData[j].color + ' ' + start.toFixed(2) + 'deg ' + end.toFixed(2) + 'deg');
        }

        var legendH = '';
        for (var k = 0; k < typeData.length; k++) {
          var pct = total > 0 ? Math.round(typeData[k].count / total * 100) : 0;
          legendH += '<div class="db-legend-item">';
          legendH += '<span class="db-legend-dot" style="background:' + typeData[k].color + ';"></span>';
          legendH += '<span style="flex:1;">' + esc(typeData[k].name) + '</span>';
          legendH += '<span style="font-weight:600;font-family:\'Roboto Mono\',monospace;">' + typeData[k].count + '场 (' + pct + '%)</span>';
          legendH += '</div>';
        }

        $td.innerHTML =
          '<div class="db-donut-type-ring" style="background:conic-gradient(' + segs.join(',') + ');">' +
          '<div class="db-donut-type-hole"><div class="db-donut-type-total">' + total + '</div><div class="db-donut-type-label">总活动数</div></div>' +
          '</div><div class="db-legend" style="max-width:360px;">' + legendH + '</div>';
      }

      // ═══════════════════════════════════════════
      // Module 3: 活动参与对比
      // ═══════════════════════════════════════════
      function renderComparison() {
        var $cg = $('#compareGrid');
        if (!$cg) return;

        // User data (derived from registrations / hour data)
        var regs = getRegistrationsData();
        var detail = getHoursDetail();
        var totalH = getTotalHours();

        var userActCount = regs.length;
        var userMonths = Math.max(1, 6); // assume 6 months
        var userMonthlyActs = (userActCount / userMonths).toFixed(1);
        var userMonthlyHours = (totalH / userMonths).toFixed(1);

        // Calculate approval rate from registrations
        var approved = 0, completed = 0;
        for (var i = 0; i < regs.length; i++) {
          var sk = typeof regs[i].status === 'number' ? ({0:'pending',1:'approved',2:'rejected',3:'cancelled',4:'completed'}[regs[i].status]||'pending') : regs[i].status;
          if (sk === 'approved' || sk === 'completed') approved++;
          if (sk === 'completed') completed++;
        }
        var enrollRate = regs.length > 0 ? Math.round(approved / Math.max(1, regs.filter(function(r){
          var s = typeof r.status === 'number' ? ({0:'pending',1:'approved',2:'rejected',3:'cancelled',4:'completed'}[r.status]||'pending') : r.status;
          return s !== 'cancelled';
        }).length) * 100) : 85;

        var attendRate = approved > 0 ? Math.round(completed / approved * 100) : 80;

        var praiseRate = 96; // default good rating

        var dims = [
          { label: '月均活动', unit: '场/月', you: parseFloat(userMonthlyActs), avg: 3.2, maxVal: 8 },
          { label: '月均时长', unit: 'h/月', you: parseFloat(userMonthlyHours), avg: 28.5, maxVal: 60 },
          { label: '报名率', unit: '%', you: enrollRate, avg: 72, maxVal: 100 },
          { label: '出勤率', unit: '%', you: attendRate, avg: 68, maxVal: 100 },
          { label: '好评率', unit: '%', you: praiseRate, avg: 91, maxVal: 100 }
        ];

        var h = '';
        for (var d = 0; d < dims.length; d++) {
          var dm = dims[d];
          var youPct = Math.round(dm.you / dm.maxVal * 100);
          var avgPct = Math.round(dm.avg / dm.maxVal * 100);

          h += '<div class="db-compare-item">';
          h += '<div class="db-compare-label">' + dm.label + '</div>';
          h += '<div class="db-compare-bars">';
          // User bar
          h += '<div class="db-compare-bar-row">';
          h += '<div class="db-compare-bar-fill" style="width:' + youPct + '%;"></div>';
          h += '</div>';
          // Reference marker for platform average
          h += '<div class="db-compare-bar-ref" style="left:' + avgPct + '%;" data-label="平台均' + dm.avg + dm.unit + '"></div>';
          h += '<div class="db-compare-vals">';
          h += '<span class="val-you">你: ' + dm.you + dm.unit + '</span>';
          h += '<span class="val-avg">平均: ' + dm.avg + dm.unit + '</span>';
          h += '</div>';
          h += '</div></div>';
        }

        $cg.innerHTML = h;
      }

      var _regFilter = 'all';
      function renderRegistrations() {
        var regs = getRegistrationsData();
        var container = $('#regList');
        if (!container) return;
        var filtered = regs;
        if (_regFilter !== 'all') {
          filtered = regs.filter(function(r){
            var sk = typeof r.status === 'number' ? ({0:'pending',1:'approved',2:'rejected',3:'cancelled',4:'completed'}[r.status]||'pending') : r.status;
            return sk === _regFilter;
          });
        }
        if (filtered.length === 0) {
          container.innerHTML = '<div class="db-empty">暂无报名记录</div>'; return;
        }
        var h = '';
        for (var i = 0; i < filtered.length; i++) {
          var r = filtered[i];
          var statusKey = typeof r.status === 'number' ? ({0:'pending',1:'approved',2:'rejected',3:'cancelled',4:'completed'}[r.status]||'pending') : r.status;
          var title = r.activityTitle || r.activity || '-';
          var date = r.date || r.registerTime || '-';
          h += '<div class="db-reg-item" onclick="location.href=\'' + ctx + '/activities.jsp?id=' + (r.activityId || r.id) + '\'">';
          h += '<div class="db-reg-item__info"><div class="db-reg-item__title">' + esc(title) + '</div><div class="db-reg-item__date">' + esc(date) + '</div></div>';
          h += '<span class="badge-status ' + statusClass(statusKey) + '">' + statusLabel(statusKey) + '</span>';
          h += '</div>';
        }
        container.innerHTML = h;
      }

      $('#regFilterBar') && $('#regFilterBar').addEventListener('click', function(e){
        var btn = e.target.closest('[data-filter]');
        if (!btn) return;
        var f = btn.getAttribute('data-filter');
        _regFilter = f;
        $$('#regFilterBar .db-filter-btn').forEach(function(b){ b.classList.toggle('is-active', b === btn); });
        renderRegistrations();
      });

      // ── Tab: Hours ──
      function renderHours() {
        // Donut
        var srcData = getHoursSourceData();
        var total = 0;
        for (var i = 0; i < srcData.length; i++) total += srcData[i].value;
        var segments = [];
        var accum = 0;
        for (var j = 0; j < srcData.length; j++) {
          var start = total > 0 ? (accum / total * 360) : 0;
          accum += srcData[j].value;
          var end = total > 0 ? (accum / total * 360) : 0;
          segments.push(srcData[j].color + ' ' + start + 'deg ' + end + 'deg');
        }

        var donut = $('#donutChart');
        if (donut) {
          var legendH = '';
          for (var k = 0; k < srcData.length; k++) {
            var pct = total > 0 ? ((srcData[k].value / total) * 100).toFixed(1) : '0';
            legendH += '<div class="db-legend-item"><span class="db-legend-dot" style="background:' + srcData[k].color + ';"></span><span style="flex:1;">' + esc(srcData[k].name) + '</span><span style="font-weight:600;">' + pct + '%</span></div>';
          }
          donut.innerHTML =
            '<div class="db-donut-inner" style="background:conic-gradient(' + segments.join(',') + ');">' +
            '<div class="db-donut-hole"><div class="db-donut-total">' + total.toFixed(1) + '</div><div class="db-donut-label">总小时</div></div>' +
            '</div><div class="db-legend">' + legendH + '</div>';
        }

        // Table
        var detail = getHoursDetail();
        var tbody = $('#hoursTbody');
        if (tbody) {
          if (detail.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="db-empty" style="display:table-cell;">暂无时长记录</td></tr>';
          } else {
            var th = '';
            for (var d = 0; d < detail.length; d++) {
              var x = detail[d];
              th += '<tr><td>' + esc(x.activity) + '</td><td>' + esc(x.source) + '</td><td style="font-family:\'Roboto Mono\',monospace;color:#27AE60;">' + (x.hours||0) + 'h</td><td>' + esc(x.date) + '</td></tr>';
            }
            tbody.innerHTML = th;
          }
        }

        // Big total
        var el = $('#hoursTotalBig');
        if (el) el.textContent = total.toFixed(1);

        // ── Leaderboard ──
        renderLeaderboard();

        // ── Comparison ──
        renderComparison();
      }

      // ── Leaderboard Helper ──
      function renderLeaderboard() {
        var $lb = $('#lbList');
        if (!$lb) return;
        var lbData = [
          { name: '张小明', hours: 48.5 },
          { name: '李丽华', hours: 42.0 },
          { name: '王建国', hours: 35.5 },
          { name: '赵思雨', hours: 28.0 },
          { name: '陈浩然', hours: 22.5 }
        ];
        var maxH = lbData[0].hours;
        var rankCls = ['db-lb-rank--1','db-lb-rank--2','db-lb-rank--3','db-lb-rank--n','db-lb-rank--n'];
        var h = '';
        for (var i = 0; i < lbData.length; i++) {
          var item = lbData[i];
          var pct = Math.round(item.hours / maxH * 100);
          h += '<div class="db-lb-item">';
          h += '<div class="db-lb-rank ' + rankCls[i] + '">' + (i + 1) + '</div>';
          h += '<span class="db-lb-name">' + esc(item.name) + '</span>';
          h += '<div class="db-lb-bar-wrap"><div class="db-lb-bar" style="width:' + pct + '%;"></div></div>';
          h += '<span class="db-lb-hours">' + item.hours.toFixed(1) + 'h</span>';
          h += '</div>';
        }
        $lb.innerHTML = h;
      }

      // ── Tab: Messages ──
      function renderMessages() {
        var msgs = D.dashboard.messages || [];
        var container = $('#msgList');
        var unreadEl = $('#msgUnreadCount');
        if (!container) return;
        var unread = 0;
        if (msgs.length === 0) {
          container.innerHTML = '<div class="db-empty">暂无消息通知</div>';
          if (unreadEl) unreadEl.textContent = '0';
          return;
        }
        var typeIcons = { system: '\u2139', review: '\u2714', reminder: '\u23F0', hours_review: '\u23F3' };
        var typeBgs = { system: '#5B9BD520', review: '#27AE6020', reminder: '#F0C14B20', hours_review: '#2C3E5020' };
        var h = '';
        for (var i = 0; i < msgs.length; i++) {
          var m = msgs[i];
          if (!m.read) unread++;
          var icon = typeIcons[m.type] || '\u2709';
          var bg = typeBgs[m.type] || '#e5e7eb';
          h += '<div class="db-msg-item' + (m.read ? '' : ' db-msg-item--unread') + '">';
          h += '<div class="db-msg-icon" style="background:' + bg + ';">' + icon + '</div>';
          h += '<div class="db-msg-content"><div class="db-msg-title">' + esc(m.title) + '</div><div class="db-msg-text">' + esc(m.content) + '</div><div class="db-msg-date">' + esc(m.date) + '</div></div>';
          if (!m.read) h += '<span class="db-msg-dot"></span>';
          h += '</div>';
        }
        container.innerHTML = h;
        if (unreadEl) unreadEl.textContent = unread;

        // ── Unread Summary Bar ──
        var $us = $('#unreadSummary');
        var $uc = $('#unreadCount');
        var $uf = $('#unreadFrom');
        if ($us) {
          if (unread > 0) {
            $us.style.display = 'flex';
            if ($uc) $uc.textContent = unread;
            // Find most recent unread sender
            var latestUnread = null;
            for (var i2 = 0; i2 < msgs.length; i2++) {
              if (!msgs[i2].read) { latestUnread = msgs[i2]; break; }
            }
            if ($uf) $uf.textContent = latestUnread ? esc(latestUnread.title) : '--';
          } else {
            $us.style.display = 'none';
          }
        }
      }

      // ── Tab: Badges ──
      function renderBadges() {
        var badges = D.dashboard.badges || [];
        // Extended badge set
        var allBadges = [
          { name: '初级志愿者', desc: '累计服务时长达到10小时', progress: 0, unlocked: false, icon: '\u2B50', color: '#27AE60' },
          { name: '中级志愿者', desc: '累计服务时长达到50小时', progress: 0, unlocked: false, icon: '\u2605', color: '#5B9BD5' },
          { name: '高级志愿者', desc: '累计服务时长达到100小时', progress: 0, unlocked: false, icon: '\u2726', color: '#F0C14B' },
          { name: '环保先锋', desc: '参与3场以上环保活动', progress: 0, unlocked: false, icon: '\u267B', color: '#2C3E50' },
          { name: '社区暖星', desc: '连续参与5场社区服务活动', progress: 0, unlocked: false, icon: '\u2764', color: '#E8634B' },
          { name: '坚持不懈', desc: '连续签到30天', progress: 0, unlocked: false, icon: '\u2606', color: '#9B7ED9' }
        ];

        // Merge data.js badges into allBadges
        for (var i = 0; i < badges.length; i++) {
          var b = badges[i];
          // Mark matching badges as unlocked
          for (var j = 0; j < allBadges.length; j++) {
            if (allBadges[j].name === b.name) {
              allBadges[j].unlocked = true;
              allBadges[j].progress = 100;
              allBadges[j].color = b.color || allBadges[j].color;
            }
          }
        }

        // Compute progress based on total hours
        var totalH = getTotalHours();
        for (var k = 0; k < allBadges.length; k++) {
          var ab = allBadges[k];
          if (!ab.unlocked) {
            if (ab.name.indexOf('初级') >= 0) ab.progress = Math.min(100, Math.round(totalH / 10 * 100));
            else if (ab.name.indexOf('中级') >= 0) ab.progress = Math.min(100, Math.round(totalH / 50 * 100));
            else if (ab.name.indexOf('高级') >= 0) ab.progress = Math.min(100, Math.round(totalH / 100 * 100));
            else ab.progress = Math.min(99, Math.round(Math.random() * 60 + 10)); // placeholder
          }
        }

        var container = $('#badgeGrid');
        if (!container) return;
        var h = '';
        for (var m = 0; m < allBadges.length; m++) {
          var bg = allBadges[m];
          h += '<div class="db-badge-card' + (bg.unlocked ? '' : ' db-badge-card--locked') + '">';
          h += '<span class="db-badge-icon" style="color:' + bg.color + ';">' + (bg.unlocked ? bg.icon : '\uD83D\uDD12') + '</span>';
          h += '<div class="db-badge-name">' + esc(bg.name) + '</div>';
          h += '<div class="db-badge-desc">' + esc(bg.desc) + '</div>';
          h += '<div class="db-badge-progress"><div class="db-badge-progress-fill" style="width:' + bg.progress + '%;background:' + bg.color + ';"></div></div>';
          h += '<div style="font-size:.72rem;color:var(--text-soft);margin-top:4px;">' + bg.progress + '%</div>';
          h += '</div>';
        }
        container.innerHTML = h;
      }

      // ── Settings ──
      window.handleSettingsSave = function(e) {
        e.preventDefault();
        var newPwd = $('#setNewPwd') ? $('#setNewPwd').value : '';
        var confirmPwd = $('#setConfirmPwd') ? $('#setConfirmPwd').value : '';
        var oldPwd = $('#setOldPwd') ? $('#setOldPwd').value : '';
        var nickname = $('#setNickname') ? $('#setNickname').value : '';

        if (newPwd && newPwd !== confirmPwd) { alert('两次输入的新密码不一致'); return false; }
        if (newPwd && !oldPwd) { alert('请输入旧密码'); return false; }

        var body = new URLSearchParams();
        body.set('nickname', nickname);
        if (newPwd) {
          body.set('oldPassword', oldPwd);
          body.set('newPassword', newPwd);
        }

        fetch(ctx + '/auth?action=updateProfile', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
          credentials: 'same-origin',
          body: body
        }).then(function(r){ return r.json(); })
          .then(function(j){
            alert(j.message || (j.success ? '保存成功' : '保存失败'));
            if (j.success && ($('#setOldPwd'))) { $('#setOldPwd').value = ''; $('#setNewPwd').value = ''; $('#setConfirmPwd').value = ''; }
          })
          .catch(function(){ alert('保存失败，请稍后重试'); });
        return false;
      };

      // ── API Integration: Try loading real data ──
      function safeFetch(url, opts) {
        return fetch(ctx + url, Object.assign({ credentials: 'same-origin' }, opts || {}))
          .then(function(r){
            if (r.status === 401) { /* ignore */ return null; }
            if (!r.ok) return null;
            return r.json();
          }).catch(function(){ return null; });
      }

      async function loadAPIData() {
        // Hours Summary
        var sumRes = await safeFetch('/activity/api/hours/summary');
        if (sumRes && sumRes.success) _hourSummary = sumRes.data;

        // Hours Changes
        var changesRes = await safeFetch('/activity/api/hours/list');
        if (changesRes && changesRes.success) _hourChanges = changesRes.data || [];

        // My Registrations
        var regRes = await safeFetch('/activity/api/mine');
        if (regRes && regRes.success) {
          _apiRegs = regRes.data || [];
          _apiRegsLoaded = true;
        }
      }

      // ── Init ──
      async function init() {
        buildNav();
        await loadAPIData();
        renderOverview();
        // Pre-render visible tab content
        renderRegistrations();
        renderHours();
        renderMessages();
        renderBadges();
        // Expose for external events
        window.__dbRenderPtsSourceChart = renderPtsSourceChart;
        window.__dbRenderLevelProgress = renderLevelProgress;
        window.__dbRenderPtsTimeline = renderPtsTimeline;
      }

      // Keyboard shortcut: Escape to close sidebar
      document.addEventListener('keydown', function(e){
        if (e.key === 'Escape') toggleSidebar(false);
      });

      // Window resize: auto-close sidebar on desktop
      window.addEventListener('resize', function(){
        if (window.innerWidth > 960) toggleSidebar(false);
      });

      init();
    })();
  </script>
  <script>
    // ── Points System Integration ──
    (function(){
      function updatePointsDisplay() {
        var pointsEl = document.getElementById('statPoints');
        var levelEl = document.getElementById('statPointsLevel');
        var cardEl = document.getElementById('statPointsCard');

        if (typeof window.getUserPoints === 'function') {
          var pts = window.getUserPoints();
          if (pointsEl) pointsEl.textContent = (pts != null && !isNaN(pts)) ? pts : '--';
        }

        if (typeof window.getUserLevel === 'function') {
          var lvl = window.getUserLevel();
          if (levelEl) levelEl.textContent = lvl || '--';
        }

        if (typeof window.getUserLevelColor === 'function') {
          var color = window.getUserLevelColor();
          if (pointsEl) pointsEl.style.color = color || '';
          if (cardEl) cardEl.style.borderLeftColor = color || '';
        }
      }

      // Initialize on page load
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', updatePointsDisplay);
      } else {
        updatePointsDisplay();
      }

      // Listen for pointsUpdated custom event
      window.addEventListener('pointsUpdated', function(e){
        updatePointsDisplay();
        // Also refresh points analytics sections
        if (typeof window.__dbRenderLevelProgress === 'function') window.__dbRenderLevelProgress();
        if (typeof window.__dbRenderPtsTimeline === 'function') window.__dbRenderPtsTimeline();
      });
    })();
  </script>
</body>
</html>

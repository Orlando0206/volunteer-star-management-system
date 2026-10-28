<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  String displayRole = loginUser == null ? "" : loginUser.getRole();
  String displayName = loginUser == null ? "" : loginUser.getNickname();
  request.setAttribute("currentPage", "planet");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>志愿星球 - 志愿社区</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
<style>
:root{--fs:'Noto Serif SC','SimSun',serif;--fm:'Roboto Mono','Consolas',monospace;--accent:#7c3aed;--accent2:#a855f7;--c-g:#10b981;--c-b:#5B9BD5;--c-o:#f59e0b;--c-r:#ef4444;--c-pink:#ec4899}
*{-webkit-tap-highlight-color:transparent}
html,body{overflow-x:hidden;overflow-y:auto}

/* Page shell */
.pshell{display:flex;min-height:calc(100vh - 64px);background:#f5f6f8;padding-top:64px}

/* Main content */
.pmain{flex:1;min-width:0;max-width:780px;margin:0 auto;padding:0 24px 60px}

/* Sidebar */
.pside{width:300px;flex-shrink:0;padding:0 20px 60px 0;position:sticky;top:64px;max-height:calc(100vh - 64px);overflow-y:auto}
.pside::-webkit-scrollbar{width:4px}.pside::-webkit-scrollbar-thumb{background:#d1d5db;border-radius:2px}

@media(max-width:1150px){.pside{display:none}.pmain{max-width:100%;padding:0 16px 60px}}

/* Publish bar */
.pub{background:#fff;border-radius:16px;padding:16px 20px;margin-top:20px;margin-bottom:16px;border:1px solid #e5e7eb;box-shadow:0 1px 4px rgba(0,0,0,.03);display:flex;align-items:center;gap:14px;transition:box-shadow .25s}
.pub:hover{box-shadow:0 4px 16px rgba(0,0,0,.06)}
.pub__avatar{width:44px;height:44px;border-radius:12px;flex-shrink:0;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:1.1rem}
.pub__input{flex:1;height:44px;border-radius:22px;border:1px solid #e5e7eb;background:#f9fafb;padding:0 18px;font-size:.9rem;outline:none;cursor:pointer;color:#9ca3af;transition:all .25s}
.pub__input:hover{border-color:var(--accent2);background:#fff;color:#374151}
.pub__actions{display:flex;gap:6px;flex-shrink:0}
.pub__act{width:38px;height:38px;border-radius:50%;border:0;background:#f3f4f6;cursor:pointer;font-size:1rem;transition:all .25s;display:flex;align-items:center;justify-content:center}
.pub__act:hover{background:#ede9fe;transform:scale(1.1);color:var(--accent)}

/* Stats bar */
.pstats{display:flex;gap:0;margin-bottom:16px;background:#fff;border-radius:14px;overflow:hidden;border:1px solid #e5e7eb;box-shadow:0 1px 3px rgba(0,0,0,.02)}
.pstats__item{flex:1;text-align:center;padding:12px 8px;cursor:default;transition:background .2s}
.pstats__item:hover{background:#fafbfc}
.pstats__item+.pstats__item{border-left:1px solid #f3f4f6}
.pstats__num{font-family:var(--fm);font-size:1.25rem;font-weight:700;color:var(--accent)}
.pstats__num--hot{color:var(--c-r)}.pstats__num--total{color:#374151}
.pstats__label{font-size:.72rem;color:#9ca3af;margin-top:2px}

/* Sort tabs */
.psort{display:flex;gap:6px;margin-bottom:14px;align-items:center}
.psort__label{font-size:.82rem;color:#9ca3af;margin-right:4px;flex-shrink:0}
.psort__btn{padding:7px 16px;border-radius:999px;border:1px solid #e5e7eb;background:#fff;font-size:.82rem;cursor:pointer;transition:all .25s;color:#6b7280;font-weight:500}
.psort__btn.is-active{background:var(--accent);color:#fff;border-color:var(--accent);box-shadow:0 2px 8px rgba(124,58,237,.2)}
.psort__btn:hover:not(.is-active){border-color:var(--accent2);color:var(--accent)}

/* Post card */
.pc{background:#fff;border-radius:16px;border:1px solid #e5e7eb;margin-bottom:16px;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,.03);transition:all .3s ease}
.pc:hover{box-shadow:0 8px 30px rgba(0,0,0,.06);transform:translateY(-2px);border-color:#d1d5db}
.pc__hd{display:flex;align-items:center;gap:12px;padding:16px 18px 0}
.pc__av{width:44px;height:44px;border-radius:12px;flex-shrink:0;display:flex;align-items:center;justify-content:center;font-weight:700;color:#fff;font-size:1rem}
.pc__info{flex:1;min-width:0}
.pc__name-row{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.pc__name{font-weight:600;font-size:.94rem;color:#111827}
.pc__type-badge{display:inline-block;padding:2px 10px;border-radius:999px;font-size:.68rem;font-weight:600}
.pc__type-badge--story{background:#fef3c7;color:#d97706}
.pc__type-badge--recommend{background:#dbeafe;color:#2563eb}
.pc__type-badge--skill{background:#d1fae5;color:#059669}
.pc__type-badge--record{background:#ede9fe;color:#7c3aed}
.pc__type-badge--recruit{background:#fee2e2;color:#dc2626}
.pc__type-badge--qa{background:#fce7f3;color:#db2777}
.pc__type-badge--mood{background:#e0e7ff;color:#4f46e5}
.pc__tm{font-size:.75rem;color:#9ca3af;margin-top:2px}
.pc__bd{padding:14px 18px 0}
.pc__title{font-family:var(--fs);font-size:1.08rem;font-weight:700;color:#111827;margin:0 0 8px;line-height:1.45}
.pc__text{font-size:.92rem;color:#374151;line-height:1.85;margin:0;white-space:pre-wrap}
.pc__tags{display:flex;gap:6px;flex-wrap:wrap;margin-top:12px}
.pc__tag{padding:4px 10px;border-radius:999px;font-size:.72rem;background:rgba(124,58,237,.06);color:var(--accent);cursor:pointer;transition:all .2s}
.pc__tag:hover{background:rgba(124,58,237,.14);color:#6d28d9}
.pc__img{margin:12px 18px 0;border-radius:10px;overflow:hidden;max-height:360px}
.pc__img img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .5s}
.pc__img:hover img{transform:scale(1.04)}
.pc__ft{display:flex;align-items:center;gap:20px;padding:12px 18px;border-top:1px solid #f3f4f6;margin-top:14px}
.pc__ft-btn{display:flex;align-items:center;gap:5px;border:0;background:transparent;color:#9ca3af;font-size:.82rem;cursor:pointer;transition:all .25s;padding:4px 8px;border-radius:8px}
.pc__ft-btn:hover{background:#f9fafb;color:#374151}
.pc__ft-btn.is-liked{color:var(--c-r)}.pc__ft-btn.is-liked .pc__ft-icon{animation:likePop .4s ease}
.pc__ft-btn.is-bookmarked{color:var(--c-o)}
@keyframes likePop{0%,100%{transform:scale(1)}50%{transform:scale(1.4)}}

/* Comments */
.pcomments{padding:0 18px 14px;display:none;border-top:1px solid #f3f4f6}
.pcomments.is-open{display:block}
.pcomment{display:flex;gap:10px;padding:10px 0;border-bottom:1px solid #f9fafb}
.pcomment:last-child{border-bottom:0}
.pcomment__av{width:32px;height:32px;border-radius:8px;flex-shrink:0;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.75rem}
.pcomment__bd{flex:1;min-width:0}
.pcomment__name{font-weight:600;font-size:.82rem;color:#111827}.pcomment__text{font-size:.84rem;color:#374151;line-height:1.6;margin-top:2px}
.pcomment__tm{font-size:.68rem;color:#cbd5e1;margin-top:2px}
.pcomm-write{display:flex;gap:8px;align-items:center;padding-top:10px}
.pcomm-write input{flex:1;height:36px;border-radius:18px;border:1px solid #e5e7eb;padding:0 14px;font-size:.82rem;outline:none;background:#f9fafb;transition:border-color .2s}
.pcomm-write input:focus{border-color:var(--accent2);background:#fff}
.pcomm-write button{padding:7px 16px;border-radius:18px;border:0;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;font-size:.8rem;font-weight:600;cursor:pointer;transition:all .25s;white-space:nowrap}
.pcomm-write button:hover{box-shadow:0 2px 10px rgba(124,58,237,.3)}

/* Load more */
.pmore{text-align:center;padding:8px 0 40px}
.pmore__btn{padding:12px 48px;border-radius:12px;border:1px solid #e5e7eb;background:#fff;font-size:.9rem;cursor:pointer;transition:all .25s;color:#6b7280;font-weight:500}
.pmore__btn:hover{border-color:var(--accent2);color:var(--accent);background:#faf5ff;box-shadow:0 2px 10px rgba(124,58,237,.08)}
.pmore__info{font-size:.78rem;color:#9ca3af;margin-top:8px}

/* Sidebar card */
.pscard{background:#fff;border-radius:14px;border:1px solid #e5e7eb;padding:18px;margin-top:20px;position:relative;overflow:hidden}
.pscard::before{content:"";position:absolute;top:-30px;right:-20px;width:80px;height:80px;border-radius:50%;background:radial-gradient(circle,rgba(124,58,237,.04),transparent 70%);pointer-events:none}
.pscard__h{font-family:var(--fs);font-size:.92rem;font-weight:700;color:#111827;margin:0 0 12px;display:flex;align-items:center;gap:6px}

/* User mini card */
.psuser{display:flex;align-items:center;gap:12px}
.psuser__av{width:48px;height:48px;border-radius:12px;flex-shrink:0;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:1.3rem}
.psuser__info{flex:1;min-width:0}
.psuser__name{font-weight:700;font-size:.94rem;color:#111827;margin-bottom:3px}
.psuser__meta{display:flex;gap:10px;font-size:.75rem;color:#9ca3af}
.psuser__meta span{font-weight:600;color:#374151}
.psuser__points{font-size:.84rem;color:#374151;font-weight:500;margin-top:8px;padding-top:8px;border-top:1px solid #f3f4f6}

/* Topic cloud */
.ptopic-wrap{display:flex;flex-wrap:wrap;gap:6px}
.ptopic{display:inline-block;padding:5px 12px;border-radius:999px;font-size:.74rem;cursor:pointer;transition:all .25s;border:1px solid transparent}
.ptopic:hover{transform:scale(1.06);box-shadow:0 2px 8px rgba(0,0,0,.06)}

/* Hot posts list */
.pshot-list{display:flex;flex-direction:column;gap:2px}
.pshot{display:flex;align-items:center;gap:10px;padding:9px 8px;cursor:pointer;transition:all .2s;border-radius:8px}
.pshot:hover{background:#f9fafb}
.pshot__rank{width:26px;height:26px;border-radius:6px;display:flex;align-items:center;justify-content:center;font-family:var(--fm);font-size:.78rem;font-weight:700;color:#fff;flex-shrink:0}
.pshot__rank--1{background:#ef4444}.pshot__rank--2{background:#f97316}.pshot__rank--3{background:#f59e0b}.pshot__rank--n{background:#cbd5e1;color:#6b7280}
.pshot__info{flex:1;min-width:0}.pshot__title{font-size:.82rem;font-weight:500;color:#374151;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;line-height:1.3}
.pshot__meta{font-size:.7rem;color:#9ca3af;margin-top:1px}

/* Publish modal */
.pubmodal{position:fixed;inset:0;z-index:10000;background:rgba(0,0,0,.55);display:none;align-items:center;justify-content:center}
.pubmodal.is-open{display:flex}
.pubmodal__card{width:min(560px,94vw);max-height:85vh;background:#fff;border-radius:20px;overflow-y:auto;padding:24px}
.pubmodal__h{font-family:var(--fs);font-size:1.1rem;font-weight:700;margin:0 0 16px;display:flex;justify-content:space-between;align-items:center}
.pubmodal__close{width:32px;height:32px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;color:#6b7280;cursor:pointer;font-size:1rem;display:flex;align-items:center;justify-content:center;transition:all .2s}
.pubmodal__close:hover{background:#f3f4f6;color:#111827}
.pubmodal__type{display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap}
.pubmodal__tbtn{flex:1;padding:10px 0;border-radius:12px;border:2px solid #e5e7eb;background:#fff;cursor:pointer;text-align:center;font-size:.84rem;transition:all .25s;min-width:90px}
.pubmodal__tbtn.is-active{border-color:var(--accent);background:rgba(124,58,237,.04);color:var(--accent);font-weight:600}
.pubmodal__field{margin-bottom:14px}.pubmodal__label{font-size:.82rem;font-weight:500;color:#374151;margin-bottom:5px;display:block}
.pubmodal__input,.pubmodal__textarea{width:100%;border-radius:10px;border:1px solid #e5e7eb;padding:10px 14px;font-size:.88rem;outline:none;font-family:inherit;background:#f9fafb;transition:all .25s;box-sizing:border-box}
.pubmodal__input:focus,.pubmodal__textarea:focus{border-color:var(--accent);background:#fff;box-shadow:0 0 0 3px rgba(124,58,237,.08)}
.pubmodal__textarea{min-height:100px;resize:vertical}
.pubmodal__submit{width:100%;padding:12px 0;border-radius:12px;border:0;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;font-size:.94rem;font-weight:600;cursor:pointer;transition:all .25s}
.pubmodal__submit:hover{box-shadow:0 4px 16px rgba(124,58,237,.35);transform:translateY(-1px)}

/* Toast */
.ptoast{position:fixed;top:24px;left:50%;transform:translateX(-50%);z-index:99999;background:rgba(17,24,39,.88);color:#fff;padding:10px 24px;border-radius:999px;font-size:.84rem;opacity:0;transition:all .3s;pointer-events:none;backdrop-filter:blur(8px)}
.ptoast.show{opacity:1}

/* Section divider */
.psection-tag{display:flex;align-items:center;gap:10px;margin:20px 0 12px}
.psection-tag__line{flex:1;height:1px;background:#e5e7eb}
.psection-tag__text{font-family:var(--fs);font-size:.84rem;font-weight:600;color:#9ca3af;white-space:nowrap}

@media(max-width:640px){.pmain{padding:0 12px 40px}.pside{display:none}.pub__actions{display:none}.pubmodal__type{gap:4px}.pubmodal__tbtn{font-size:.76rem;padding:8px 0}.pc__hd{padding:12px 14px 0}.pc__bd{padding:10px 14px 0}.pc__ft{padding:10px 14px;gap:14px}.pc__img{margin:10px 14px 0}}

/* ===== Module 3: Community Activity Metrics (in main area) ===== */
.pmetrics{display:flex;gap:12px;margin-bottom:16px}
.pmetrics__card{flex:1;background:#fff;border-radius:14px;padding:16px 12px;text-align:center;border:1px solid #e5e7eb;box-shadow:0 1px 3px rgba(0,0,0,.02);transition:all .25s}
.pmetrics__card:hover{box-shadow:0 4px 16px rgba(0,0,0,.05);transform:translateY(-1px)}
.pmetrics__icon{font-size:1.5rem;margin-bottom:6px}
.pmetrics__num{font-family:var(--fm);font-size:1.4rem;font-weight:700;color:#111827;line-height:1.2}
.pmetrics__num--today{color:var(--accent)}.pmetrics__num--weekly{color:var(--c-g)}.pmetrics__num--total{color:var(--c-o)}
.pmetrics__label{font-size:.7rem;color:#9ca3af;margin-top:2px}

/* ===== Module 1: Trend Chart (sidebar) ===== */
.ptrend{padding:0}.ptrend__svg{display:block;width:100%;height:auto}

/* ===== Module 2: Topic Heat Ranking (sidebar) ===== */
.pheat-list{display:flex;flex-direction:column;gap:6px}
.pheat-item{display:flex;align-items:center;gap:10px;padding:7px 8px;border-radius:8px;cursor:pointer;transition:all .2s}
.pheat-item:hover{background:#f9fafb}
.pheat-item__rank{width:22px;height:22px;border-radius:6px;display:flex;align-items:center;justify-content:center;font-family:var(--fm);font-size:.7rem;font-weight:700;color:#fff;flex-shrink:0}
.pheat-item__rank--hot{background:linear-gradient(135deg,#f59e0b,#ef4444)}
.pheat-item__rank--warm{background:linear-gradient(135deg,#f59e0b,#f97316)}
.pheat-item__rank--normal{background:#cbd5e1;color:#6b7280}
.pheat-item__info{flex:1;min-width:0;display:flex;align-items:center;gap:6px}
.pheat-item__tag{font-size:.78rem;font-weight:500;color:#374151;padding:3px 10px;border-radius:999px;background:rgba(124,58,237,.06)}
.pheat-item__count{font-family:var(--fm);font-size:.68rem;color:#9ca3af;flex-shrink:0}
.pheat-item__fire{font-size:.7rem;flex-shrink:0}

/* ===== Module 4: User Contribution Leaderboard (sidebar) ===== */
.pboard-item{display:flex;align-items:center;gap:10px;padding:9px 10px;border-radius:10px;border:1px solid transparent;transition:all .25s;margin-bottom:6px}
.pboard-item:hover{background:#fafbfc}
.pboard-item--gold{border-color:#f59e0b;background:linear-gradient(135deg,rgba(245,158,11,.06),rgba(245,158,11,.02))}
.pboard-item__rank{width:22px;font-family:var(--fm);font-size:.82rem;font-weight:700;color:#9ca3af;flex-shrink:0}
.pboard-item--gold .pboard-item__rank{color:#f59e0b}
.pboard-item__av{width:34px;height:34px;border-radius:10px;flex-shrink:0;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem}
.pboard-item--gold .pboard-item__av{box-shadow:0 0 0 2px rgba(245,158,11,.3)}
.pboard-item__info{flex:1;min-width:0}
.pboard-item__name{font-size:.82rem;font-weight:600;color:#111827;line-height:1.3}
.pboard-item__stats{font-size:.68rem;color:#9ca3af;display:flex;gap:8px;margin-top:1px}
.pboard-item__stat{display:inline-flex;align-items:center;gap:2px}
.pboard-item__stat b{color:#374151;font-weight:600}
.pboard-more{text-align:center;margin-top:10px;padding-top:10px;border-top:1px solid #f3f4f6}
.pboard-more a{font-size:.76rem;color:var(--accent);text-decoration:none;font-weight:500;transition:all .2s}
.pboard-more a:hover{color:#6d28d9}

@media(max-width:640px){.pmetrics{gap:8px}.pmetrics__card{padding:12px 8px}.pmetrics__num{font-size:1.15rem}.pmetrics__icon{font-size:1.2rem}}
</style>
</head>
<body data-page="planet">
<div class="page-shell">
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="pshell" style="max-width:1120px;margin:0 auto;">
<main class="pmain">

<!-- Publish bar -->
<div class="pub">
  <div class="pub__avatar" id="pubAvatar"><%= displayName.isEmpty() ? "星" : displayName.substring(0,1) %></div>
  <input class="pub__input" id="pubInput" placeholder="分享你的志愿经历..." readonly>
  <div class="pub__actions">
    <button class="pub__act" title="写文章">&#x1F4DD;</button>
    <button class="pub__act" title="发说说">&#x1F4AC;</button>
    <button class="pub__act" title="传照片">&#x1F4F7;</button>
  </div>
</div>

<!-- Stats bar -->
<div class="pstats">
  <div class="pstats__item"><div class="pstats__num" id="statToday">--</div><div class="pstats__label">今日新帖</div></div>
  <div class="pstats__item"><div class="pstats__num pstats__num--hot" id="statWeek">--</div><div class="pstats__label">本周热门</div></div>
  <div class="pstats__item"><div class="pstats__num pstats__num--total" id="statTotal">--</div><div class="pstats__label">总帖数</div></div>
  <div class="pstats__item"><div class="pstats__num" style="color:var(--c-g)" id="statActiveUsers">--</div><div class="pstats__label">活跃星球人</div></div>
</div>

<!-- Community Activity Metrics (Module 3) -->
<div class="pmetrics">
  <div class="pmetrics__card">
    <div class="pmetrics__icon">&#x1F4DD;</div>
    <div class="pmetrics__num pmetrics__num--today" id="metricTodayPosts">--</div>
    <div class="pmetrics__label">今日新帖</div>
  </div>
  <div class="pmetrics__card">
    <div class="pmetrics__icon">&#x1F465;</div>
    <div class="pmetrics__num pmetrics__num--weekly" id="metricWeeklyUsers">--</div>
    <div class="pmetrics__label">本周活跃用户</div>
  </div>
  <div class="pmetrics__card">
    <div class="pmetrics__icon">&#x2764;&#xFE0F;</div>
    <div class="pmetrics__num pmetrics__num--total" id="metricTotalInteractions">--</div>
    <div class="pmetrics__label">总互动量</div>
  </div>
</div>

<!-- Sort tabs -->
<div class="psort">
  <span class="psort__label">排序:</span>
  <button class="psort__btn is-active" data-sort="default">&#x1F31F; 推荐</button>
  <button class="psort__btn" data-sort="hottest">&#x1F525; 最热</button>
  <button class="psort__btn" data-sort="newest">&#x1F550; 最新</button>
  <button class="psort__btn" data-sort="most-discussed">&#x1F4AC; 最多讨论</button>
</div>

<!-- Posts container -->
<div id="pcList"></div>

<!-- Load more -->
<div class="pmore" id="pcMore">
  <button class="pmore__btn" id="loadMoreBtn">&#x2B07; 加载更多</button>
  <div class="pmore__info" id="pmoreInfo">已显示 0 / 0 条帖子</div>
</div>

</main>

<!-- Sidebar -->
<aside class="pside">

<!-- User mini card -->
<div class="pscard">
  <div class="psuser">
    <div class="psuser__av" id="sideAv"><%= displayName.isEmpty() ? "星" : displayName.substring(0,1) %></div>
    <div class="psuser__info">
      <div class="psuser__name" id="sideName"><%= displayName.isEmpty() ? "志愿者" : displayName %></div>
      <div class="psuser__meta">
        <span>发帖 <b id="sidePosts">0</b></span>
        <span>获赞 <b id="sideLikes">0</b></span>
      </div>
      <div class="psuser__points" id="sidePoints">
        &#x2B50; 积分：<b style="color:var(--accent)">0</b> | &#x1F3C5; <b style="color:var(--c-o)">新手上路</b>
      </div>
    </div>
  </div>
</div>

<!-- Topic cloud -->
<div class="pscard">
  <h3 class="pscard__h">&#x1F30D; 话题云</h3>
  <div class="ptopic-wrap" id="topicCloud"></div>
</div>

<!-- Module 1: Post Interaction Trend -->
<div class="pscard ptrend">
  <h3 class="pscard__h">&#x1F4CA; 帖子互动趋势</h3>
  <svg class="ptrend__svg" id="trendChart" viewBox="0 0 250 120" width="250" height="120"></svg>
</div>

<!-- 24-hour hot posts -->
<div class="pscard">
  <h3 class="pscard__h">&#x1F525; 24小时热帖</h3>
  <div class="pshot-list" id="hotPostsList"></div>
</div>

<!-- Module 2: Topic Heat Ranking -->
<div class="pscard">
  <h3 class="pscard__h">&#x1F525; 话题热度排行</h3>
  <div class="pheat-list" id="topicHeatList"></div>
</div>

<!-- Recommended users -->
<div class="pscard">
  <h3 class="pscard__h">&#x1F3C5; 活跃星球人</h3>
  <div class="pshot-list" id="topUsersList"></div>
</div>

<!-- Module 4: User Contribution Leaderboard -->
<div class="pscard">
  <h3 class="pscard__h">&#x1F947; 用户贡献排行</h3>
  <div id="contribBoard"></div>
  <div class="pboard-more">
    <a href="#contrib-all">&#x1F4CA; 查看贡献总榜 &rarr;</a>
  </div>
</div>

</aside>
</div>
</div>

<!-- Publish modal -->
<div class="pubmodal" id="pubModal">
<div class="pubmodal__card">
<div class="pubmodal__h">&#x270D;&#xFE0F; 发布内容 <button class="pubmodal__close" id="pubModalClose">&times;</button></div>
<div class="pubmodal__type" id="pubTypeBtns">
  <button class="pubmodal__tbtn is-active" data-pt="story">&#x1F4D6; 故事</button>
  <button class="pubmodal__tbtn" data-pt="recommend">&#x1F4CC; 推荐</button>
  <button class="pubmodal__tbtn" data-pt="moment">&#x1F4AC; 说说</button>
  <button class="pubmodal__tbtn" data-pt="qa">&#x2753; 问答</button>
</div>
<div class="pubmodal__field"><label class="pubmodal__label">标题</label><input class="pubmodal__input" id="pubTitle" placeholder="输入标题..."></div>
<div class="pubmodal__field"><label class="pubmodal__label">内容</label><textarea class="pubmodal__textarea" id="pubContent" placeholder="分享你的志愿经历..."></textarea></div>
<div class="pubmodal__field"><label class="pubmodal__label">标签 (逗号分隔)</label><input class="pubmodal__input" id="pubTags" placeholder="如: 社区服务, 银川, 感动瞬间"></div>
<div class="pubmodal__field"><label class="pubmodal__label">图片链接 (可选)</label><input class="pubmodal__input" id="pubImage" placeholder="粘贴图片URL地址..."></div>
<button class="pubmodal__submit" id="pubSubmit">&#x1F680; 发布</button>
</div>
</div>

<!-- Toast -->
<div class="ptoast" id="pToast"></div>

<script>window.APP_CONTEXT_PATH="${pageContext.request.contextPath}";window.APP_USER_NAME="<%=displayName%>"</script>
<script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/points.js"></script>
<script>
(function(){
var ctx=window.APP_CONTEXT_PATH||'.',uname=window.APP_USER_NAME||'志愿者';

/* ===== 30条帖子数据 ===== */
var posts=[
  /* --- 感人故事 6篇 (id 1-6) --- */
  {id:1,type:'story',title:'灵武市儿童福利院——那些被天使吻过的孩子',content:'上周日，我们一行12人驱车来到了灵武市儿童福利院。\n\n出发前，我们准备了绘本、彩色铅笔、零食和玩具。\n\n真正见到孩子们的那一刻，我愣住了——他们有的不会说话，有的行动不便，但每一个孩子看到我们时眼睛都是亮晶晶的。我被分配陪伴一个叫小宇的5岁男孩，他不会说话，但一直紧紧拉着我的手不放。\n\n午饭时福利院护工阿姨告诉我："这里的孩子最缺的不是物资，而是陪伴和拥抱。你们能来陪他们玩一天，比捐什么都强。"\n\n临走时小宇哭了。我蹲下来抱着他说："姐姐还会再来的。"这是真的——这周日我就要去第二次了。\n\n如果你也想来看看这些孩子，请联系我。哪怕只是陪他们一个下午。&#x1F49B;',author:'刘婷',authorColor:'#9333ea',time:'4小时前',tags:['儿童福利','灵武','陪伴','感人故事'],likes:689,bookmarks:450,comments:[
    {author:'李明',text:'看了两遍，每次都泪目。我要报名这周日的活动！',color:'#059669'},
    {author:'张芳',text:'小宇的故事让我想起了自己支教时遇到的孩子',color:'#059669'},
    {author:'王磊',text:'儿童福利院真的很需要关注，向你们致敬',color:'#2563eb'},
    {author:'赵伟',text:'我也想去！请问怎么联系？',color:'#d97706'},
    {author:'陈雪',text:'绘本和玩具还需要吗？我捐一些',color:'#9333ea'}
  ],image:'assets/images/activity-4.jpg',liked:true},
  {id:2,type:'story',title:'支教15天——那山那人那笑声',content:'7月初到8月中，我在固原市原州区希望小学度过了永生难忘的15天。\n\n【教学篇】\n我们开设了语文、数学、英语三门主课，还增加了美术和音乐。孩子们最喜欢美术课，每次画完都会骄傲地举起来给我们看，那笑容比高原的阳光还灿烂。\n\n【生活篇】\n条件确实艰苦，宿舍没有空调，晚上蚊虫也多。但和孩子们在一起，这些都不算什么。\n\n【感动篇】\n离别那天，一个小女孩塞给我一张皱皱的纸条，上面歪歪扭扭写着："老师，你明年还会来吗？"我蹲下来抱着她哭了出来——我明年一定会来！',author:'刘婷',authorColor:'#9333ea',time:'2天前',tags:['支教','固原','教育帮扶','留守儿童'],likes:512,bookmarks:290,comments:[
    {author:'李明',text:'纸条那段真的破防了...致敬所有支教老师',color:'#059669'},
    {author:'王磊',text:'明年算我一个！我也想去',color:'#2563eb'},
    {author:'张芳',text:'孩子们的笑脸是最好的回报',color:'#059669'},
    {author:'孙丽',text:'山区教育真的很需要关注',color:'#ef4444'}
  ],image:'assets/images/activity-6.jpg',liked:true},
  {id:3,type:'story',title:'我的第一次社区敬老服务',content:'上周末参加了金凤区老年活动中心的敬老活动，这是我第一次参与志愿服务。\n\n早晨8点我们就到了活动中心，帮忙布置场地、引导老人入座。活动开始后，我们陪老人们聊天、下棋，还帮他们测量血压。\n\n让我印象最深的是92岁的张奶奶。她给我们讲了她年轻时支援大西北的故事，说起当年建设银川的激情岁月，眼睛里还是有光。\n\n她说："你们能来，我们就高兴。不需要做什么大事，陪我们说说话就是最好的。"那一刻我真正感受到了志愿服务的意义——不是给予，而是连接。\n\n虽然只是短短几个小时的陪伴，但这份温暖我会记一辈子。下周继续！',author:'李明',authorColor:'#059669',time:'1天前',tags:['社区服务','敬老','金凤区','感动'],likes:128,bookmarks:95,comments:[
    {author:'王磊',text:'太有感触了！张奶奶的故事让我想起了我奶奶',color:'#2563eb'},
    {author:'张芳',text:'"不是给予，而是连接" 说得真好',color:'#059669'},
    {author:'陈雪',text:'下次带我一个！我也想去看望老人',color:'#9333ea'}
  ],image:'assets/images/activity-1.jpg',liked:false},
  {id:4,type:'story',title:'盲道上的2公里——一次温暖的"扫雷"行动',content:'今天第一次参加盲道清理志愿服务，在兴庆区沿线清理了2公里盲道。\n\n说实话，一开始只是因为凑志愿时长才报名的。但当我弯下腰一辆一辆搬开占道电动车、一点一点清理盲道上的碎石时，我开始想——如果是我的眼睛看不见，这些障碍会不会让我摔一跤？\n\n中午时分，一位视障大哥拄着盲杖慢慢走过我们刚清理好的路段，他停下来对我们说："谢谢你们，这条路好走多了。"就这一句话让我鼻酸。\n\n2公里不长，但每一步都算数。\n\n或许我们做不了惊天动地的大事，但至少可以让一个人回家的路更安全一点。',author:'张芳',authorColor:'#059669',time:'昨天 18:30',tags:['助残扶弱','兴庆区','盲道清理','感人'],likes:189,bookmarks:112,comments:[
    {author:'王磊',text:'辛苦了！盲道被占用的问题确实很普遍',color:'#2563eb'},
    {author:'刘婷',text:'"每一步都算数" 这句话我要记住',color:'#9333ea'},
    {author:'赵伟',text:'在哪条路？我也想加入',color:'#d97706'}
  ],liked:false},
  {id:5,type:'story',title:'留守儿童之家——和孩子们一起包饺子的午后',content:'上周六，银川市西夏区"留守儿童之家"举办了一场特别的包饺子活动。我们5个志愿者加上12个孩子，从和面擀皮到包馅下锅，整个过程笑声不断。\n\n有个叫佳佳的女孩，父母都在外地打工，一年只能见一两次。她包饺子特别认真，说："等我学会包饺子了，过年爸爸妈妈回来就能吃到我包的。"\n\n饺子出锅的时候，佳佳先夹了两个给志愿者老师："老师先吃。"然后小心翼翼地把最漂亮的几个饺子留着，说要带回家给奶奶尝。\n\n这些孩子比我们想象的更懂事，更懂得珍惜和感恩。\n\n#留守儿童 #西夏区 #陪伴 #温暖',author:'陈雪',authorColor:'#9333ea',time:'3天前',tags:['留守儿童','西夏区','陪伴','饺子'],likes:267,bookmarks:178,comments:[
    {author:'张芳',text:'佳佳太懂事了，看得我心疼',color:'#059669'},
    {author:'李明',text:'留守儿童真的很需要陪伴，谢谢你们的付出',color:'#059669'},
    {author:'刘婷',text:'下次活动什么时候？我也想去帮忙',color:'#9333ea'}
  ],image:'assets/images/activity-3.jpg',liked:true},
  {id:6,type:'story',title:'临终关怀病房的最后一封信',content:'这不是一个轻松的故事，但我想讲出来。\n\n三个月前，我们志愿者团队开始参与宁夏某医院临终关怀项目。服务对象是一位叫周伯伯的退休教师，肝癌晚期。\n\n他最大的心愿是在最后的日子里有人陪他说说话。我们每周去两次，有时聊天，有时给他读报纸，有时就安静地坐在旁边。\n\n上周，周伯伯走了。他的女儿转交给我们一封信——周伯伯在最后一周写的，字迹已经很弱了："谢谢你们让我最后的时光不那么孤单。你们都是好孩子，以后也要继续善良下去。"\n\n信纸上有泪痕，分不清是他的还是我们的。\n\n临终关怀很难，但它的意义或许就在于：让每一个生命在告别时都被温柔以待。\n\n如果你内心够强大，可以考虑加入临终关怀志愿者队伍。',author:'王磊',authorColor:'#2563eb',time:'4天前',tags:['临终关怀','生命教育','志愿者感悟','深度故事'],likes:756,bookmarks:520,comments:[
    {author:'刘婷',text:'泪目了...你们做的工作太伟大了',color:'#9333ea'},
    {author:'李明',text:'周伯伯的信让我破防了...谢谢分享',color:'#059669'},
    {author:'张芳',text:'向临终关怀志愿者致敬，这需要极大的勇气和爱心',color:'#059669'},
    {author:'赵伟',text:'每一个生命都值得被温柔以待',color:'#d97706'},
    {author:'陈雪',text:'看完默默流泪了，谢谢你们',color:'#9333ea'},
    {author:'孙丽',text:'我也想做但不知道从哪里开始...',color:'#ef4444'}
  ],liked:true},

  /* --- 活动推荐 5篇 (id 7-11) --- */
  {id:7,type:'recommend',title:'永宁县非遗剪纸体验——强烈推荐给手工爱好者！',content:'上周末去永宁县文化馆体验了非遗手工——剪纸和泥塑！真的超级棒 &#x1F44D;\n\n【活动详情】\n地点：永宁县文化馆二楼非遗展厅\n日期：每周六上午9:00-11:30\n费用：免费 (政府文化惠民项目)\n适合人群：所有年龄，亲子友好\n\n【我的体验】\n老师傅是自治区级非遗传承人，手艺精湛又耐心十足。我学会了剪"福"字窗花和蝴蝶剪纸。还做了一个骆驼泥塑（虽然有点歪哈哈），但老师傅说"歪有歪的味道"。\n\n【推荐理由】\n1. 纯免费，文化馆提供所有材料\n2. 传承人手把手教，零基础友好\n3. 下周六还有扎染体验\n4. 作品可以带走，很有成就感\n\n公交到永宁县城中心站下车走5分钟就到！快去体验吧～',author:'张芳',authorColor:'#059669',time:'2天前',tags:['活动推荐','永宁县','非遗文化','手工','免费'],likes:156,bookmarks:98,comments:[
    {author:'刘婷',text:'谢谢推荐！这周六就去！',color:'#9333ea'},
    {author:'孙丽',text:'带娃去正好，孩子一定喜欢',color:'#ef4444'},
    {author:'李明',text:'"歪有歪的味道" 师傅好有智慧哈哈',color:'#059669'}
  ],liked:false},
  {id:8,type:'recommend',title:'贺兰山国家森林公园环保公益行——本月最后一期',content:'强烈推荐贺兰山国家森林公园的环保公益徒步活动！\n\n【基本信息】\n&#x1F4CD; 地点：贺兰山国家森林公园 (银川市贺兰县)\n&#x1F4C5; 日期：7月28日 (周日) 8:00-16:00\n&#x1F465; 名额：仅剩15位\n&#x1F3D4; 路线：苏峪口—贺兰山阙—樱桃谷环线 (约8公里)\n\n【活动内容】\n&#x1F33F; 沿途捡拾垃圾并分类\n&#x1F4F8; 生态摄影 (带队的是一位自然摄影师)\n&#x1F330; 学习贺兰山特有植物辨识\n&#x1F37D; 中午山间野餐\n\n【推荐理由】\n既能锻炼身体又能做环保，风景绝美，还能学到植物知识。上期参与的小伙伴全员五星好评！\n\n集合地点：贺兰山游客中心停车场。扫码报名或点我主页看活动链接～',author:'王磊',authorColor:'#2563eb',time:'3天前',tags:['活动推荐','贺兰山','环保','徒步','银川'],likes:234,bookmarks:160,comments:[
    {author:'赵伟',text:'上期去了，真的超棒！带队老师很专业',color:'#d97706'},
    {author:'李明',text:'报名了！还剩几个名额大家抓紧',color:'#059669'},
    {author:'张芳',text:'生态摄影这个太吸引我了',color:'#059669'}
  ],image:'assets/images/activity-2.jpg',liked:true},
  {id:9,type:'recommend',title:'西夏区大学城"旧书新生"图书漂流活动',content:'发现一个超有意义的周末活动，推荐给爱书的朋友！\n\n【活动信息】\n&#x1F4CD; 地点：西夏区大学城公共阅读空间 (文萃北街)\n&#x1F4C5; 日期：每周六 & 周日 14:00-17:00 (持续到9月底)\n&#x1F4DA; 主题：旧书新生——让闲置图书流动起来\n\n【怎么玩】\n1. 带一本你读过的旧书来\n2. 在扉页写上推荐语\n3. 换一本别人留下的书\n4. 还可以帮忙整理书架、修复破损图书\n\n上周我换到了一本余华的《活着》，扉页上上一位读者写着："希望读到这本书的你，也一样热爱生活。"那一刻感觉好奇妙。\n\n不需要报名，直接来就行！场地免费开放，还有免费茶水 &#x2615;',author:'陈雪',authorColor:'#9333ea',time:'4天前',tags:['活动推荐','西夏区','大学城','图书漂流','周末'],likes:98,bookmarks:56,comments:[
    {author:'李明',text:'这个好！我有一堆旧书正好不知道怎么处理',color:'#059669'},
    {author:'刘婷',text:'扉页留言这个设计太浪漫了',color:'#9333ea'}
  ],liked:false},
  {id:10,type:'recommend',title:'"老友记"社区长者智能手机课堂——需要你的加入',content:'给各位推荐一个非常有温度的活动：社区长者智能手机课堂！\n\n【活动背景】\n很多社区老人不会用智能手机——不会视频通话、不会挂号、不会扫码支付。这个活动就是手把手教他们用手机。\n\n【活动详情】\n&#x1F4CD; 地点：兴庆区新华街社区活动中心\n&#x1F4C5; 日期：每周五上午9:00-11:00\n&#x1F9D1; 学员：社区60岁以上长者\n&#x1F468;&#x200D;&#x1F3EB; 志愿者：每次需要8-10人 (1对1或1对2教学)\n\n【教学内容】\n- 微信视频通话\n- 网上挂号\n- 扫码支付\n- 拍照和发朋友圈\n- 防诈骗知识\n\n上周教一位78岁的王奶奶学会了和外地孙子视频通话，她第一次在手机里看到孙子的时候激动得说不出话来。\n\n对手机操作比较熟的朋友都可以来，不需要专业背景～',author:'孙丽',authorColor:'#ef4444',time:'5天前',tags:['活动推荐','兴庆区','社区服务','长者','智能课堂'],likes:312,bookmarks:220,comments:[
    {author:'王磊',text:'这个活动太有意义了！长者数字鸿沟是个大问题',color:'#2563eb'},
    {author:'刘婷',text:'正好周五上午有空，报名！',color:'#9333ea'},
    {author:'李明',text:'教过我家老人用手机，太需要耐心了。向你们致敬！',color:'#059669'}
  ],image:'assets/images/activity-7.jpg',liked:true},
  {id:11,type:'recommend',title:'黄河金岸骑行+环保打卡——运动与公益的完美结合',content:'推荐一个超级酷的活动给骑行爱好者！\n\n【活动信息】\n&#x1F4CD; 起点：银川滨河大道黄河大桥 (永宁段)\n&#x1F4C5; 日期：8月3日 (周六) 7:30集合\n&#x1F6B4; 路线：黄河金岸绿道骑行40公里 (中度难度)\n&#x1F3AF; 主题：骑行+环保+摄影\n\n【活动流程】\n7:30-8:00 热身 + 领取手套和垃圾袋\n8:00-10:30 骑行 + 沿途环保打卡 (每站清理休憩点)\n10:30-11:00 终点合影 + 垃圾分类挑战赛\n11:00-12:00 黄河边野餐\n\n【你需要准备】\n自备自行车 (共享单车也可)、水壶、防晒\n\n【你会获得】\n6小时志愿时长 + 活动纪念徽章 + 一群爱运动爱公益的朋友\n\n目前已有23人报名，还有12个名额！感兴趣的私信我拉你进群～',author:'赵伟',authorColor:'#d97706',time:'6天前',tags:['活动推荐','黄河','骑行','环保','永宁'],likes:198,bookmarks:145,comments:[
    {author:'王磊',text:'骑行+公益这个组合绝了！报名报名',color:'#2563eb'},
    {author:'张芳',text:'40公里中等难度，我能行不...',color:'#059669'},
    {author:'赵伟',text:'@张芳 放心，有保姆车跟着的，累了可以上车休息',color:'#d97706'}
  ],liked:false},

  /* --- 技能分享 5篇 (id 12-16) --- */
  {id:12,type:'skill',title:'【干货】志愿者户外活动安全十条黄金法则',content:'作为一名参加过80+场活动的老志愿者，整理了一份户外安全指南分享给大家：\n\n1.&#xFE0F;&#x20E3; 穿着舒适运动鞋和长裤，杜绝拖鞋/高跟鞋\n2.&#xFE0F;&#x20E3; 户外活动必备：防晒霜、遮阳帽、充足饮用水\n3.&#xFE0F;&#x20E3; 听从组织者指挥，不擅自脱队行动\n4.&#xFE0F;&#x20E3; 遇到突发情况（老人摔倒/动物咬伤等）立即报告，不要独自处理\n5.&#xFE0F;&#x20E3; 垃圾随身带走——Leave No Trace\n6.&#xFE0F;&#x20E3; 注意天气预报，雷雨天取消户外活动\n7.&#xFE0F;&#x20E3; 随身携带急救包（创可贴、碘伏、防暑药）\n8.&#xFE0F;&#x20E3; 保持手机电量充足，记下领队电话\n9.&#xFE0F;&#x20E3; 活动中量力而行，不舒服及时休息\n&#x1F51F; 记得签到签退，不然志愿时长白做了 &#x1F602;\n\n欢迎评论区补充！也欢迎老志愿者们分享自己的经验～',author:'王磊',authorColor:'#2563eb',time:'4天前',tags:['技能分享','安全','户外','干货','经验'],likes:420,bookmarks:310,comments:[
    {author:'张芳',text:'第10条太真实了哈哈，我被坑过一次',color:'#059669'},
    {author:'李明',text:'补充：最好结伴而行，不要单独活动',color:'#059669'},
    {author:'刘婷',text:'收藏了！发给团队新人群里',color:'#9333ea'},
    {author:'赵伟',text:'整理得好全面，给新人培训用',color:'#d97706'}
  ],liked:false},
  {id:13,type:'skill',title:'【急救技能】志愿者必学的5项基础急救知识',content:'上周参加了红十字会的基础急救培训，整理了最实用的5项技能分享给大家：\n\n&#x1F6E1;&#xFE0F; 1. CPR心肺复苏\n- 判断意识 → 呼救 → 按压(30次) → 人工呼吸(2次) → 循环\n- 按压频率：100-120次/分钟\n- 按压深度：5-6厘米\n\n&#x1F915; 2. 海姆立克急救法\n- 成人：站在背后环抱，拳头放在肚脐上方，快速向内向上冲击\n- 儿童：跪在身后，力度减半\n\n&#x1FA78; 3. 止血包扎\n- 直接压迫止血 (用干净纱布)\n- 抬高受伤部位\n- 绷带包扎从远心端向近心端\n\n&#x1F321;&#xFE0F; 4. 中暑处理\n- 移至阴凉通风处\n- 解开衣领，用湿毛巾擦拭\n- 补充水分 (含盐饮料更好)\n\n&#x26A1; 5. AED使用\n- 开机 → 贴电极片 → 听语音提示 → 必要时电击\n\n推荐所有志愿者至少参加一次红十字会培训！可能一辈子用不到，但用到一次就能救命。',author:'孙丽',authorColor:'#ef4444',time:'1周前',tags:['技能分享','急救','红十字会','安全','志愿者必备'],likes:567,bookmarks:430,comments:[
    {author:'王磊',text:'太有用了！志愿者确实应该具备基础急救能力',color:'#2563eb'},
    {author:'刘婷',text:'AED那个我之前一直不敢用，看完明白多了',color:'#9333ea'},
    {author:'李明',text:'能救命的知识，转发给所有志愿者朋友',color:'#059669'},
    {author:'张芳',text:'请问红十字会培训从哪里报名？',color:'#059669'},
    {author:'孙丽',text:'@张芳 微信搜"宁夏红十字会"公众号，有在线报名',color:'#ef4444'}
  ],liked:true},
  {id:14,type:'skill',title:'新手志愿者的5个入门建议——来自过来人的干货',content:'做志愿者三年了，给刚入门的朋友一些真心建议：\n\n&#x1F331; 1. 先从小活动开始\n别一上来就报名那些需要特长的活动。从社区清洁、敬老院陪伴这种门槛低的开始，建立信心和习惯。\n\n&#x1F4CB; 2. 记志愿服务日志\n每次活动后花5分钟记录：做了什么、学到什么、感受如何。回头看会很有成就感，也可以作为简历素材。\n\n&#x1F91D; 3. 找到自己的"志愿搭子"\n一个人容易半途而废，找个朋友一起参加，互相督促也更有趣。\n\n&#x1F3AF; 4. 结合自己的专业/特长\n你是学计算机的？去教老人用手机。喜欢摄影？去给活动拍照。把专业变成志愿力，你会更有成就感。\n\n&#x2764;&#xFE0F; 5. 不要有压力，快乐志愿\n志愿不是义务劳动！累了就休息，忙了就暂停。志愿者首先要照顾好自己，才能更好地帮助别人。\n\n共勉！你在志愿路上有什么心得吗？欢迎评论区交流～',author:'李明',authorColor:'#059669',time:'5天前',tags:['技能分享','新手入门','经验','志愿心得'],likes:345,bookmarks:260,comments:[
    {author:'刘婷',text:'第4条太赞成！我是学社工的，感觉志愿和专业结合特别顺',color:'#9333ea'},
    {author:'张芳',text:'"快乐志愿"这点说得好，很多人把志愿做成了负担',color:'#059669'},
    {author:'王磊',text:'第2条建议很好，我刚开始做的时候坚持记了半年，回头看超有成就感',color:'#2563eb'},
    {author:'宋雨',text:'作为新人，这些建议太及时了！谢谢学长',color:'#ef4444'}
  ],liked:true},
  {id:15,type:'skill',title:'环保志愿者的垃圾分类终极指南',content:'做了两年环保志愿者，垃圾分类是我最常被问到的问题。整理了一版超实用指南：\n\n&#x1F4E6;【可回收物】\n废纸、塑料瓶、玻璃瓶、金属罐、旧衣物\n记住口诀："玻金塑纸衣"\n注意：餐巾纸、湿纸巾不是可回收！它们属于其他垃圾\n\n&#x1F9EA;【有害垃圾】\n电池、灯泡、过期药品、油漆桶、杀虫剂\n口诀："药电灯胶油漆"\n宁可多分到有害，也别乱扔到其他垃圾\n\n&#x1F331;【厨余垃圾】\n剩饭剩菜、果皮、茶叶渣、骨头\n注意：大棒骨、贝壳不算厨余(太硬，粉碎机处理不了)\n\n&#x1F5D1;&#xFE0F;【其他垃圾】\n以上三类之外的都算：烟头、灰土、一次性餐具、污染纸张\n口诀："猪都不吃的就是其他垃圾" (开玩笑的但是好记 &#x1F602;)\n\n建议可以做个分类贴纸贴在家里垃圾桶旁边，多分几次就习惯了！',author:'赵伟',authorColor:'#d97706',time:'6天前',tags:['技能分享','环保','垃圾分类','干货'],likes:289,bookmarks:205,comments:[
    {author:'王磊',text:'"猪都不吃的"太接地气了哈哈',color:'#2563eb'},
    {author:'张芳',text:'大棒骨不算厨余这个知识点第一次知道！',color:'#059669'},
    {author:'陈雪',text:'湿纸巾不算可回收也是冷知识',color:'#9333ea'}
  ],liked:false},
  {id:16,type:'skill',title:'【沟通技巧】如何与听障人士有效交流',content:'上周参加助残志愿者培训，学到了很多关于与听障人士交流的技巧，非常实用，整理分享：\n\n&#x270B; 基础手语\n- "你好"：食指指向对方，然后竖起大拇指\n- "谢谢"：拇指弯曲点头两次\n- "对不起"：握拳在胸口画圈\n- "需要帮助吗"：双手摊开，做询问表情\n\n&#x1F4F1; 辅助方式\n- 手机打字/写字板是最直接的方式\n- 注意面部表情——听障人士非常依赖视觉信息\n- 说话时面对对方，让他们看你的口型\n- 不要捂着嘴说话，不要边吃东西边说话\n\n&#x26A0;&#xFE0F; 注意事项\n- 不要大声喊——听障人士不是聋人，大声喊反而让口型变形\n- 耐心！可能需要重复几遍\n- 不要替对方"翻译"或"代答"——直接沟通\n\n推荐有兴趣的志愿者可以学一些基础手语，哪怕只会"你好"和"谢谢"，也能让对方感到被尊重。',author:'陈雪',authorColor:'#9333ea',time:'1周前',tags:['技能分享','助残','手语','沟通技巧'],likes:378,bookmarks:275,comments:[
    {author:'孙丽',text:'太实用了！上周做活动就遇到了一位听障人士，当时好慌',color:'#ef4444'},
    {author:'刘婷',text:'手语"谢谢"学会了！简单但很有意义',color:'#9333ea'},
    {author:'王磊',text:'"不要大声喊"这条很多人不知道，谢谢科普',color:'#2563eb'}
  ],image:'assets/images/activity-8.jpg',liked:true},

  /* --- 活动记录 5篇 (id 17-21) --- */
  {id:17,type:'record',title:'黄河湿地保护行动全记录——80袋垃圾与42种候鸟',content:'3月到5月，我们团队在黄河银川段湿地开展了为期两个月的保护行动，今天来做个完整记录。\n\n&#x1F4CA;【数据成果】\n- 清理湿地垃圾：80余袋 (其中塑料类占62%，震撼)\n- 记录到候鸟种类：42种 (包括赤麻鸭、白鹭、苍鹭、黑鹳)\n- 补种植被面积：超200平方米\n- 参与志愿者人次：156人次\n\n&#x1F4F7;【最美瞬间】\n那天清晨6点，雾气还没散，一群赤麻鸭从芦苇中飞起，金色的晨光打在水面上——那一刻所有人都安静了。大自然的美就在身边，只是我们平时太匆忙。\n\n&#x1F4DD;【我的感受】\n两个月下来最大的收获不是数据，是那种"我为母亲河做了点什么"的踏实感。每一片湿地都值得保护。\n\n保护母亲河，从每一条支流、每一片湿地做起！',author:'王磊',authorColor:'#2563eb',time:'3天前',tags:['活动记录','黄河','湿地保护','生态','银川'],likes:345,bookmarks:260,comments:[
    {author:'李明',text:'80袋垃圾太震撼了，你们辛苦了',color:'#059669'},
    {author:'赵伟',text:'42种候鸟！黄河湿地生态比我想象的丰富多了',color:'#d97706'},
    {author:'张芳',text:'"我为母亲河做了点什么"这句话好触动',color:'#059669'}
  ],image:'assets/images/activity-5.jpg',liked:true},
  {id:18,type:'record',title:'中秋社区联欢会——当志愿者遇上传统文化',content:'上周末在兴庆区社区文化广场举办的中秋联欢会圆满结束啦！来做个小记录～\n\n&#x1F3AE;【活动内容】\n- 和社区老人一起包月饼 (豆沙、五仁、冰皮)\n- 猜灯谜大会 (准备了80个灯谜，全被猜光了)\n- 书法体验区 (一位退休书法老师现场写"福"送给大家)\n- 茶艺表演 + 品茶\n- 最后的合影：社区广场站了快200人\n\n&#x1F60A;【最暖心的片段】\n一位独居的刘奶奶，包完月饼后小心翼翼地把一个包好放进兜里。我问她为啥不吃，她说"带回去给我老伴看看，照片放家里好多年了，让他知道我还有人陪。"\n\n那一刻我理解了什么叫"每逢佳节倍思亲"。志愿者的意义，就是让孤独的人感受不到孤独。',author:'陈雪',authorColor:'#9333ea',time:'1周前',tags:['活动记录','中秋','兴庆区','社区文化'],likes:198,bookmarks:135,comments:[
    {author:'张芳',text:'刘奶奶的故事让我泪目了...',color:'#059669'},
    {author:'王磊',text:'中秋活动办得真好！明年还有吗？',color:'#2563eb'},
    {author:'刘婷',text:'"让孤独的人感受不到孤独"说得太好了',color:'#9333ea'}
  ],image:'assets/images/activity-7.jpg',liked:true},
  {id:19,type:'record',title:'西夏区大学城美食街——文明餐桌推广体验记',content:'上周参加了"文明餐桌·光盘行动"推广活动，地点在西夏区大学城美食街。\n\n【我们做了什么】\n&#x1F4CB; 在20余家餐饮店铺张贴"光盘行动"海报\n&#x1F4C4; 向就餐同学发放"按量点餐"提示卡\n&#x270D;&#xFE0F; 在美食街入口设立签名墙——200+人签名承诺\n&#x1F4CA; 将当天剩饭剩菜数据做成可视化展板\n\n【最触动的事】\n一位拉面馆老板主动找到我们，说自从贴了海报，厨余垃圾减少了约30%！他说："以前不好意思提醒客人少点，现在有了这个氛围，大家都自觉了。"\n\n最后统计发现：一周厨余垃圾减少了约45%！这个数字让我们所有人欢呼了起来 &#x1F389;\n\n文明餐桌，从每一餐做起。一粥一饭当思来之不易。',author:'陈雪',authorColor:'#9333ea',time:'8天前',tags:['活动记录','西夏区','大学城','光盘行动','文明餐桌'],likes:234,bookmarks:165,comments:[
    {author:'李明',text:'45%太厉害了！行动力max &#x1F4AA;',color:'#059669'},
    {author:'王磊',text:'拉面馆老板的故事好暖心，改变就是这样开始的',color:'#2563eb'},
    {author:'张芳',text:'我们学校食堂也该推广一下',color:'#059669'}
  ],image:'assets/images/activity-4.jpg',liked:true},
  {id:20,type:'record',title:'宁东镇产业工人志愿日——质朴的人最动人',content:'上周六去了宁东镇能源化工基地参加"产业工人志愿日"活动。\n\n【活动内容】\n上午：和工人们一起清理厂区绿化带\n中午：在工人食堂一起吃饭 (大锅菜特别香)\n下午：安全生产知识宣讲 + 应急演练\n\n【我的感受】\n说实话，去之前以为会是比较严肃的氛围。没想到工人们特别热情淳朴——一个叫老马的师傅看我不会用铁锹，手把手教了我十几分钟。休息时他递给我一瓶水说："你们城里娃能来我们这干活，不容易。"\n\n活动结束后，老马加了我微信，问我下次还来不来。我说："一定来。"\n\n志愿服务的魅力就在于——你永远不知道会在哪里遇到什么样的人，收获什么样的感动。',author:'赵伟',authorColor:'#d97706',time:'9天前',tags:['活动记录','宁东镇','产业工人','社区服务'],likes:145,bookmarks:92,comments:[
    {author:'王磊',text:'老马师傅好暖！劳动者最可爱',color:'#2563eb'},
    {author:'张芳',text:'宁东镇还没去过，下次有活动也叫上我',color:'#059669'}
  ],liked:false},
  {id:21,type:'record',title:'"微光"城市夜巡——深夜11点的银川街头',content:'参加了兴庆区"微光"志愿者团队的深夜巡查活动，体验非常特别。\n\n【我们在做什么】\n晚间22:00-24:00在兴庆区主要街道巡逻：\n- 发现露宿者并联系救助站\n- 检查公共设施损坏情况 (路灯、井盖、护栏)\n- 夜归人的安全保障 (护送独行女性到小区门口)\n\n【那晚的记录】\n- 护送3位夜归女性安全到家\n- 发现并上报4处路灯故障\n- 帮助1位迷路的老人联系了家人\n\n【最难忘】\n凌晨12点收工时，街上的烧烤摊老板冲我们喊："志愿者辛苦了！来吃点！"\n\n银川的夜很冷，但人心很暖。\n\n如果你也愿意为城市的安全感出一份力，"微光"随时欢迎你加入。',author:'孙丽',authorColor:'#ef4444',time:'10天前',tags:['活动记录','兴庆区','夜巡','微光','城市安全'],likes:312,bookmarks:230,comments:[
    {author:'刘婷',text:'深夜巡逻的志愿者太酷了！保护城市的感觉',color:'#9333ea'},
    {author:'王磊',text:'烧烤摊老板那句话好暖心...银川是有温度的城市',color:'#2563eb'},
    {author:'李明',text:'"微光"这个名字真好——微光汇聚成星河',color:'#059669'}
  ],image:'assets/images/activity-9.jpg',liked:true},

  /* --- 招募信息 3篇 (id 22-24) --- */
  {id:22,type:'recruit',title:'【紧急招募】本周末社区防诈骗宣传，急缺5人！',content:'周末的"守护钱袋子——社区防诈骗宣传"活动还差5个人！\n\n【活动信息】\n&#x1F4CD; 地点：金凤区万达广场1号门\n&#x1F4C5; 日期：7月14日-15日 (本周六日)\n&#x23F0; 时段：上午9:00-12:00 / 下午14:00-17:00 (可选半天)\n&#x1F465; 缺口：上午缺3人，下午缺2人\n\n【工作内容】\n- 发放防诈骗宣传手册\n- 现场讲解常见诈骗套路 (有培训，不用担心)\n- 帮助老人安装国家反诈中心APP\n\n【你只需要】\n热情 + 会讲普通话 + 不社恐\n\n可以开志愿服务证明 + 6小时志愿时长。\n\n有兴趣的评论区扣1或直接私信我！&#x1F64F;',author:'孙丽',authorColor:'#ef4444',time:'1天前',tags:['招募','金凤区','防诈骗','紧急','周末'],likes:43,bookmarks:25,comments:[
    {author:'张芳',text:'1！周六上午我可以',color:'#059669'},
    {author:'赵伟',text:'1，周六下午有空',color:'#d97706'},
    {author:'李明',text:'周日上午报名',color:'#059669'}
  ],liked:false},
  {id:23,type:'recruit',title:'暑期支教团队招募——固原市原州区希望小学',content:'今年的暑期支教开始招募啦！\n\n【目的地】\n固原市原州区希望小学 (乡村小学，约120名学生)\n\n【时间】\n8月5日-8月20日 (共15天)\n\n【招募对象】\n- 在校大学生或应届毕业生\n- 有耐心、有爱心、能吃苦\n- 有音乐/美术/体育/英语特长者优先\n- 共招募8人 (目前已有3人报名)\n\n【你会获得】\n- 150小时志愿时长证明\n- 往返交通 + 食宿全包\n- 一生的珍贵回忆\n\n【报名方式】\n私信我获取报名表，截止日期7月25日。\n\n去年去过的志愿者说："那是这辈子做过的最有意义的事情。"\n\n等你来，和孩子们一起度过一个不一样的夏天。&#x2600;&#xFE0F;',author:'刘婷',authorColor:'#9333ea',time:'3天前',tags:['招募','支教','固原','暑期','教育帮扶'],likes:234,bookmarks:170,comments:[
    {author:'王磊',text:'强烈推荐！去年参加过的表示：改变一生的经历',color:'#2563eb'},
    {author:'张芳',text:'英语专业的可以吗？',color:'#059669'},
    {author:'刘婷',text:'@张芳 太欢迎了！刚好缺英语老师',color:'#9333ea'},
    {author:'李明',text:'报名！等这个机会很久了',color:'#059669'}
  ],image:'assets/images/activity-6.jpg',liked:true},
  {id:24,type:'recruit',title:'【长期招募】银川动物救助站周末义工',content:'银川市流浪动物救助站长期招募周末义工！\n\n【救助站简介】\n位于贺兰县，目前收容了200+只流浪猫狗，全靠几个阿姨和社会捐赠维持运转。\n\n【你需要做什么】\n- 打扫犬舍/猫舍\n- 遛狗、陪猫咪玩耍 (社会化训练)\n- 帮忙洗狗 (夏天每周一次)\n- 给待领养动物拍照片发社交媒体\n\n【时间】\n每周六/日 9:00-12:00 (半天即可)\n\n【特别说明】\n怕狗/过敏的朋友不建议报名哦。会有老义工带你，不用担心不会。救助站的小动物们都非常亲人，每次去都会被治愈～\n\n目前急缺人手！阿姨们忙不过来，狗狗们的遛弯时间严重不足。如果你周末有空，欢迎来帮忙～记得穿旧衣服 (狗狗会扑人) &#x1F436;',author:'赵伟',authorColor:'#d97706',time:'2天前',tags:['招募','动物救助','贺兰县','长期','周末'],likes:156,bookmarks:98,comments:[
    {author:'张芳',text:'我超喜欢狗狗！周六来报到',color:'#059669'},
    {author:'陈雪',text:'家里有猫，想问下救助站的猫能领养吗？',color:'#9333ea'},
    {author:'赵伟',text:'@陈雪 可以的！救助站定期举办领养日',color:'#d97706'}
  ],image:'assets/images/activity-8.jpg',liked:true},

  /* --- 问答讨论 3篇 (id 25-27) --- */
  {id:25,type:'qa',title:'【求助】第一次做志愿者，很紧张怎么办？',content:'大家好！我是宁夏大学大一新生，这个周末报名了人生第一次志愿活动——社区老年人智能手机培训。\n\n现在有点紧张，几个问题想请教前辈们：\n\n1. 我手机用得还行，但教老人会不会很难？他们会不会觉得我讲得太快？\n2. 万一老人问的问题我也不会怎么办？比如某个APP我没用过...\n3. 穿什么比较好？需要特别正式吗？\n4. 最重要的是——怎么克服紧张？现在想到要去就心跳加速 &#x1F605;\n\n任何建议都欢迎！先谢谢大家了～',author:'宋雨',authorColor:'#ef4444',time:'5小时前',tags:['问答','新人求助','第一次','紧张'],likes:156,bookmarks:78,comments:[
    {author:'李明',text:'别紧张！教老人用手机最重要的是耐心和慢。一个操作重复3-5遍很正常，他们不会觉得烦的',color:'#059669'},
    {author:'孙丽',text:'我是手机课堂老志愿者了，给你建议：不会的问题就说"我帮您查一下"，老人会理解的。穿便装就好，干净整洁就行',color:'#ef4444'},
    {author:'张芳',text:'我第一次也紧张！但活动开始后发现老人们特别和蔼，你对他们笑他们也会对你笑。深呼吸，你可以的！',color:'#059669'},
    {author:'王磊',text:'建议提前把常用APP（微信、抖音、支付宝）的基本操作过一遍。最重要的是——享受过程！',color:'#2563eb'}
  ],liked:false},
  {id:26,type:'qa',title:'【讨论】你们觉得志愿服务最大的意义是什么？',content:'做志愿一年多了，最近在思考一个问题：志愿服务最大的意义究竟是什么？\n\n是帮助别人？是获得成就感和满足感？还是因为"应该做"？\n\n我个人觉得：志愿服务的意义不是单向的"给予"，而是一种双向的成长和连接。我在帮助别人的同时，自己也变得更包容、更懂得感恩。\n\n但每个人可能答案不同。\n\n想听听大家的想法——你觉得志愿服务对你来说最大的意义是什么？',author:'李明',authorColor:'#059669',time:'1天前',tags:['问答','讨论','志愿服务','意义','深度'],likes:289,bookmarks:145,comments:[
    {author:'刘婷',text:'对我来说，是找到了一种"被需要"的感觉。这种感觉让平凡的日子变得有意义',color:'#9333ea'},
    {author:'王磊',text:'同意李明的观点——是双向的。我教老人用手机，但老人教会了我耐心和珍惜',color:'#2563eb'},
    {author:'张芳',text:'我觉得最大的意义是"看见"——看见了平时忽略的人群，看见了社会的另一面',color:'#059669'},
    {author:'赵伟',text:'我想得很简单：因为能做，所以去做。能力越大，责任越大',color:'#d97706'},
    {author:'孙丽',text:'做志愿让我从"我"走向"我们"，从关注自己到关注他人',color:'#ef4444'}
  ],liked:true},
  {id:27,type:'qa',title:'【求助】参加活动被分到不喜欢的任务，怎么办？',content:'遇到一个困扰，想请教大家。\n\n上周末参加了一个环保活动，我被分到"垃圾登记员"——就是站在分类点记录每个人交了多少袋垃圾。但我其实想跟着大部队去山里捡垃圾。\n\n我跟领队说想换，但领队说登记员也很重要，是活动中不可缺少的环节。\n\n我知道登记员很重要，但就是觉得...不够"酷"？感觉自己是活动的"边缘人"。\n\n大家都是怎么看待这种"不酷但必要"的岗位的？我应该调整心态还是坚持要求换岗？',author:'宋雨',authorColor:'#ef4444',time:'2天前',tags:['问答','心态','岗位分配','讨论'],likes:134,bookmarks:62,comments:[
    {author:'李明',text:'完全理解你的感受！但说实话——一个好的登记员能让整个活动的效率翻倍。每次活动最感谢的就是后勤岗',color:'#059669'},
    {author:'王磊',text:'做活动组织者三年了，实话告诉你：登记者比捡垃圾的难找得多！你肯做这件事，领队心里肯定很感激',color:'#2563eb'},
    {author:'张芳',text:'换个角度想：你是活动的"数据官"，没有你的记录，大家辛苦捡的垃圾就没法量化成成果。这很酷！',color:'#059669'},
    {author:'刘婷',text:'可以跟领队商量：这次做登记员，下次做捡拾。轮岗制度很多团队都有的',color:'#9333ea'}
  ],liked:false},

  /* --- 日常说说 3篇 (id 28-30) --- */
  {id:28,type:'mood',title:'',content:'今天路过上个月做社区清洁的那条街，发现花坛里的花都开了！&#x1F338;\n\n记得当时我们还清理了花坛里的杂草和垃圾。现在看到花开得这么好，莫名好开心～感觉自己的劳动成果被大自然"盖章认证"了。\n\n做志愿最治愈的就是这种"回头看"的时刻吧。',author:'张芳',authorColor:'#059669',time:'刚刚',tags:['日常说说','心情','治愈'],likes:67,bookmarks:18,comments:[
    {author:'李明',text:'"被大自然盖章认证" 这个说法好可爱！',color:'#059669'},
    {author:'陈雪',text:'有同感！我每次路过做过的活动点都会多看两眼',color:'#9333ea'}
  ],liked:false},
  {id:29,type:'mood',title:'',content:'刚收到一条私信，一个不认识的学妹说看了我的支教日记后也报名了今年的支教。\n\n她说："你的文字让我看到了不一样的可能性。"\n\n我突然觉得——分享本身就是一种志愿。你永远不知道你的哪句话、哪篇文字会点亮另一个人的路。\n\n今天就因为这个私信开心了一整天。&#x2728;',author:'刘婷',authorColor:'#9333ea',time:'3小时前',tags:['日常说说','心情','分享','支教'],likes:234,bookmarks:89,comments:[
    {author:'张芳',text:'"分享本身就是一种志愿" —— 手动点赞 100 次',color:'#059669'},
    {author:'李明',text:'刘婷的影响力好大！你写的故事一定触动了她',color:'#059669'},
    {author:'王磊',text:'这就是文字的力量。你的支教记也激励了我',color:'#2563eb'},
    {author:'宋雨',text:'学姐就是我入坑志愿的引路人！',color:'#ef4444'}
  ],liked:true},
  {id:30,type:'mood',title:'',content:'周末下雨，志愿活动临时取消了。在家整理了一下志愿服务的照片文件夹，发现已经存了200多张了。\n\n每一张照片都有故事：\n- 第一张是和社区老人下棋时拍的\n- 第56张是在贺兰山上满头大汗的自拍\n- 第147张是支教班上最调皮的小男孩送我的折纸青蛙\n- 第200张是上次夜巡收工后一起吃烧烤的合照\n\n原来不知不觉间，志愿服务已经成了我生活中最好的部分。\n\n雨天翻翻照片，心里暖暖的。&#x2614;&#x2764;&#xFE0F;',author:'王磊',authorColor:'#2563eb',time:'5小时前',tags:['日常说说','心情','回顾','照片'],likes:198,bookmarks:76,comments:[
    {author:'张芳',text:'200多张！好羡慕。我也要开始拍志愿照片了',color:'#059669'},
    {author:'赵伟',text:'翻照片是最有幸福感的时刻！我也有同感',color:'#d97706'},
    {author:'刘婷',text:'每一张都是珍贵的回忆啊',color:'#9333ea'}
  ],image:'assets/images/activity-9.jpg',liked:false}
];

/* ===== State ===== */
var activeSort='default',filteredPosts=posts.slice(),likeCache=JSON.parse(localStorage.getItem('planet_likes')||'{}'),cmtCache=JSON.parse(localStorage.getItem('planet_cmts')||'{}'),bookmarkCache=JSON.parse(localStorage.getItem('planet_bookmarks')||'{}'),likedRewardCache=JSON.parse(localStorage.getItem('planet_liked_rewards')||'{}'),visibleCount=15,pageSize=15;

function saveState(){localStorage.setItem('planet_likes',JSON.stringify(likeCache));localStorage.setItem('planet_cmts',JSON.stringify(cmtCache));localStorage.setItem('planet_bookmarks',JSON.stringify(bookmarkCache));localStorage.setItem('planet_liked_rewards',JSON.stringify(likedRewardCache))}

/* ===== Filter & Sort ===== */
function applyFilters(){
  var result=posts.slice();
  if(activeSort==='newest') result.sort(function(a,b){return b.id-a.id});
  else if(activeSort==='hottest') result.sort(function(a,b){return b.likes-a.likes});
  else if(activeSort==='most-discussed') result.sort(function(a,b){return b.comments.length-a.comments.length});
  filteredPosts=result;
}
function getVisiblePosts(){return filteredPosts.slice(0,visibleCount)}

/* ===== Type badge mapping ===== */
function getTypeBadge(type){
  var map={story:['感人故事','pc__type-badge--story'],recommend:['活动推荐','pc__type-badge--recommend'],skill:['技能分享','pc__type-badge--skill'],record:['活动记录','pc__type-badge--record'],recruit:['招募信息','pc__type-badge--recruit'],qa:['问答讨论','pc__type-badge--qa'],mood:['日常说说','pc__type-badge--mood']};
  return map[type]||['分享','pc__type-badge--story'];
}

/* ===== Build Post HTML ===== */
function buildPost(p){
  var isL=likeCache[p.id]||p.liked;
  var isBookmarked=bookmarkCache[p.id]||false;
  var cmts=p.comments||[];
  if(cmtCache[p.id]) cmts=cmts.concat(cmtCache[p.id]);
  var likeCls=isL?' is-liked':'';
  var bkmkCls=isBookmarked?' is-bookmarked':'';
  var badge=getTypeBadge(p.type);
  var media='';
  if(p.image) media='<div class="pc__img"><img src="'+ctx+'/'+p.image+'" alt="" loading="lazy"></div>';
  var tagsHtml='';
  if(p.tags){p.tags.forEach(function(t){tagsHtml+='<span class="pc__tag">#'+t+'</span>'})}
  return'<article class="pc" data-pid="'+p.id+'">'+
   '<div class="pc__hd"><div class="pc__av" style="background:'+(p.authorColor||'#7c3aed')+'">'+p.author.substring(0,1)+'</div>'+
    '<div class="pc__info"><div class="pc__name-row"><span class="pc__name">'+p.author+'</span><span class="'+badge[1]+'">'+badge[0]+'</span></div><div class="pc__tm">'+p.time+'</div></div></div>'+
   '<div class="pc__bd">'+(p.title?'<h3 class="pc__title">'+p.title+'</h3>':'')+'<p class="pc__text">'+p.content+'</p>'+
    (tagsHtml?'<div class="pc__tags">'+tagsHtml+'</div>':'')+'</div>'+media+
   '<div class="pc__ft">'+
    '<button class="pc__ft-btn'+likeCls+'" data-plike="'+p.id+'"><span class="pc__ft-icon">&#x2764;</span><span data-plike-num="'+p.id+'">'+(p.likes+(isL?1:0))+'</span></button>'+
    '<button class="pc__ft-btn" data-pcomment="'+p.id+'"><span>&#x1F4AC;</span><span>'+cmts.length+'</span></button>'+
    '<button class="pc__ft-btn'+bkmkCls+'" data-pbookmark="'+p.id+'"><span>'+(isBookmarked?'&#x1F516;':'&#x1F3F7;')+'</span><span>'+p.bookmarks+'</span></button>'+
    '<button class="pc__ft-btn" data-pshare="'+p.id+'"><span>&#x1F504;</span><span>分享</span></button>'+
   '</div>'+
   '<div class="pcomments" data-pcomments="'+p.id+'">'+
    cmts.map(function(c){return'<div class="pcomment"><div class="pcomment__av" style="background:'+(c.color||'#7c3aed')+'">'+c.author.substring(0,1)+'</div><div class="pcomment__bd"><div class="pcomment__name">'+c.author+'</div><div class="pcomment__text">'+c.text+'</div></div></div>'}).join('')+
    '<div class="pcomm-write"><input type="text" data-pcmt-input="'+p.id+'" placeholder="写下你的评论..."><button data-pcmt-submit="'+p.id+'">发送</button></div>'+
   '</div></article>';
}

function renderPosts(){
  applyFilters();
  var visible=getVisiblePosts();
  var html='';
  for(var i=0;i<visible.length;i++) html+=buildPost(visible[i]);
  document.getElementById('pcList').innerHTML=html;
  bindPostEvents();
  updateLoadMore();
  updateHotPosts();
}

function updateLoadMore(){
  var visible=getVisiblePosts();
  var total=filteredPosts.length;
  document.getElementById('pmoreInfo').textContent='已显示 '+visible.length+' / '+total+' 条帖子';
  var btn=document.getElementById('loadMoreBtn');
  if(visible.length>=total){btn.textContent='已加载全部';btn.disabled=true;btn.style.opacity='.5';btn.style.cursor='default'}
  else{btn.textContent='&#x2B07; 加载更多 ('+(total-visible.length)+'条)';btn.disabled=false;btn.style.opacity='1';btn.style.cursor='pointer'}
}

/* ===== Post events ===== */
function bindPostEvents(){
  document.querySelectorAll('[data-plike]').forEach(function(b){
    b.onclick=function(){var id=Number(b.getAttribute('data-plike'));likeCache[id]=!likeCache[id];saveState();
      var post=posts.find(function(p){return p.id===id});var isL=likeCache[id];
      var numEl=document.querySelector('[data-plike-num="'+id+'"]');if(numEl)numEl.textContent=post.likes+(isL?1:0);
      b.classList.toggle('is-liked',isL);showToast(isL?'已点赞':'已取消点赞');
      if(isL&&!likedRewardCache[id]){likedRewardCache[id]=true;saveState();window.addPoints(2,'帖子获得点赞')}}
  });
  document.querySelectorAll('[data-pbookmark]').forEach(function(b){
    b.onclick=function(){var id=Number(b.getAttribute('data-pbookmark'));bookmarkCache[id]=!bookmarkCache[id];saveState();
      var isB=bookmarkCache[id];b.querySelector('span:first-child').textContent=isB?'&#x1F516;':'&#x1F3F7;';
      showToast(isB?'已收藏':'已取消收藏')}
  });
  document.querySelectorAll('[data-pcomment]').forEach(function(b){
    b.onclick=function(){var el=document.querySelector('[data-pcomments="'+b.getAttribute('data-pcomment')+'"]');if(el)el.classList.toggle('is-open')}
  });
  document.querySelectorAll('[data-pcmt-submit]').forEach(function(b){
    b.onclick=function(){var id=Number(b.getAttribute('data-pcmt-submit'));var inp=document.querySelector('[data-pcmt-input="'+id+'"]');
      if(!inp||!inp.value.trim())return;var txt=inp.value.trim();
      if(!cmtCache[id])cmtCache[id]=[];cmtCache[id].push({author:uname,text:txt,color:'#7c3aed'});saveState();renderPosts();
      var el=document.querySelector('[data-pcomments="'+id+'"]');if(el)el.classList.add('is-open');showToast('评论成功');window.addPoints(3,'帖子获得评论')}
  });
  document.querySelectorAll('[data-pshare]').forEach(function(b){
    b.onclick=function(){navigator.clipboard&&navigator.clipboard.writeText(window.location.href);showToast('链接已复制');window.addPoints(1,'分享帖子')}
  });
  /* Tag click */
  document.querySelectorAll('.pc__tag').forEach(function(el){
    el.onclick=function(e){e.stopPropagation();var t=el.textContent.replace('#','');
      var topicEls=document.querySelectorAll('.ptopic');
      topicEls.forEach(function(x){
        var isActive=x.getAttribute('data-topic')===t;
        if(isActive){x.style.background='#7c3aed';x.style.color='#fff';x.style.borderColor='#7c3aed'}
        else{x.style.background='';x.style.color='';x.style.borderColor=''}
      });
      visibleCount=15;
      var result=posts.filter(function(p){return p.tags&&p.tags.indexOf(t)>=0});
      filteredPosts=result.length?result:posts.slice();
      renderPosts();
      showToast('筛选话题: #'+t)}
  });
}

/* ===== Load more ===== */
document.getElementById('loadMoreBtn').addEventListener('click',function(){
  visibleCount+=pageSize;renderPosts();
});

/* ===== Sort ===== */
document.querySelectorAll('.psort__btn').forEach(function(b){
  b.onclick=function(){
    var s=b.getAttribute('data-sort');
    activeSort=s;visibleCount=15;
    document.querySelectorAll('.psort__btn').forEach(function(x){x.classList.toggle('is-active',x.getAttribute('data-sort')===s)});
    renderPosts();showToast('排序: '+b.textContent.trim());
  }
});

/* ===== Publish modal ===== */
document.getElementById('pubInput').addEventListener('click',function(){document.getElementById('pubModal').classList.add('is-open')});
document.getElementById('pubModalClose').addEventListener('click',function(){document.getElementById('pubModal').classList.remove('is-open')});
document.querySelectorAll('#pubTypeBtns .pubmodal__tbtn').forEach(function(b){
  b.onclick=function(){document.querySelectorAll('#pubTypeBtns .pubmodal__tbtn').forEach(function(x){x.classList.remove('is-active')});b.classList.add('is-active')}
});
document.getElementById('pubSubmit').addEventListener('click',function(){
  var title=document.getElementById('pubTitle').value.trim(),content=document.getElementById('pubContent').value.trim();
  var tags=document.getElementById('pubTags').value.trim().split(',').map(function(t){return t.trim()}).filter(Boolean);
  if(!content){showToast('请输入内容');return}
  var newId=Math.max.apply(null,posts.map(function(p){return p.id}))+1;
  var typeBtns=document.querySelectorAll('#pubTypeBtns .pubmodal__tbtn'),ptype='story';
  typeBtns.forEach(function(b){if(b.classList.contains('is-active'))ptype=b.getAttribute('data-pt')});
  var newPost={id:newId,type:ptype,title:title||'',content:content,author:uname,authorColor:'#7c3aed',time:'刚刚',tags:tags,likes:0,bookmarks:0,comments:[],liked:false};
  posts.unshift(newPost);
  document.getElementById('pubModal').classList.remove('is-open');
  document.getElementById('pubTitle').value='';document.getElementById('pubContent').value='';
  document.getElementById('pubTags').value='';document.getElementById('pubImage').value='';
  activeSort='default';visibleCount=15;
  document.querySelectorAll('.psort__btn').forEach(function(x){x.classList.toggle('is-active',x.getAttribute('data-sort')==='default')});
  renderPosts();updateStats();renderTopicCloud();updateMetrics();renderTrendChart();renderTopicHeat();renderContribBoard();showToast('发布成功！');window.addPoints(10,'发布帖子');
});

/* ===== Sidebar: Topic Cloud ===== */
var topicColors=['#ede9fe','#dbeafe','#d1fae5','#fef3c7','#fee2e2','#fce7f3','#e0e7ff','#f0fdf4','#fffbeb','#fef2f2','#fdf2f8','#ecfdf5','#eff6ff','#faf5ff','#fff7ed'];
var topicNames=['社区服务','环境保护','支教故事','儿童福利','敬老爱老','助残扶弱','环保公益','垃圾分类','急救技能','手语','非遗文化','图书漂流','防诈骗','动物救助','骑行','夜巡','黄河','贺兰山','银川','灵武','永宁','固原','金凤区','西夏区','兴庆区','新人报道','志愿者日常','经验分享','深度故事','活动推荐'];

function renderTopicCloud(){
  var html='';
  topicNames.forEach(function(t,i){
    var bg=topicColors[i%topicColors.length];
    html+='<span class="ptopic" data-topic="'+t+'" style="background:'+bg+'">#'+t+'</span>';
  });
  document.getElementById('topicCloud').innerHTML=html;
  document.querySelectorAll('.ptopic').forEach(function(el){
    el.onclick=function(){
      var t=el.getAttribute('data-topic');
      document.querySelectorAll('.ptopic').forEach(function(x){
        if(x.getAttribute('data-topic')===t){x.style.background='#7c3aed';x.style.color='#fff';x.style.borderColor='#7c3aed'}
        else{x.style.background='';x.style.color='';x.style.borderColor=''}
      });
      visibleCount=15;activeSort='hottest';
      document.querySelectorAll('.psort__btn').forEach(function(x){x.classList.toggle('is-active',x.getAttribute('data-sort')==='hottest')});
      var result=posts.filter(function(p){return p.tags&&p.tags.indexOf(t)>=0});
      filteredPosts=result.length?result:posts.slice();
      renderPosts();showToast('筛选话题: #'+t);
    }
  });
}

/* ===== Sidebar: Hot Posts ===== */
function updateHotPosts(){
  var sorted=posts.slice().sort(function(a,b){return b.likes-a.likes}).slice(0,5);
  var html='';
  sorted.forEach(function(p,i){
    var rc=i===0?'pshot__rank--1':(i===1?'pshot__rank--2':(i===2?'pshot__rank--3':'pshot__rank--n'));
    html+='<div class="pshot" data-pscroll="'+p.id+'"><div class="pshot__rank '+rc+'">'+(i+1)+'</div><div class="pshot__info"><div class="pshot__title">'+(p.title||p.content.substring(0,24)+'...')+'</div><div class="pshot__meta">&#x2764; '+p.likes+' · '+p.author+'</div></div></div>';
  });
  document.getElementById('hotPostsList').innerHTML=html;
  document.querySelectorAll('[data-pscroll]').forEach(function(el){
    el.onclick=function(){var pid=Number(el.getAttribute('data-pscroll'));var target=document.querySelector('[data-pid="'+pid+'"]');if(target){target.scrollIntoView({behavior:'smooth',block:'center'});target.style.boxShadow='0 0 0 3px rgba(124,58,237,.4)';setTimeout(function(){target.style.boxShadow=''},2000)}}
  });
}

/* ===== Sidebar: Top Users ===== */
var topUsers=[{name:'王磊',count:56,color:'#2563eb'},{name:'李明',count:48,color:'#059669'},{name:'张芳',count:42,color:'#059669'},{name:'刘婷',count:38,color:'#9333ea'},{name:'孙丽',count:33,color:'#ef4444'},{name:'陈雪',count:29,color:'#9333ea'},{name:'赵伟',count:25,color:'#d97706'}];
(function(){
  var html='';topUsers.forEach(function(u,i){
    var rc=i===0?'pshot__rank--1':(i===1?'pshot__rank--2':(i===2?'pshot__rank--3':'pshot__rank--n'));
    html+='<div class="pshot"><div class="pshot__rank '+rc+'">'+(i+1)+'</div><div class="pshot__info"><div class="pshot__title">'+u.name+'</div><div class="pshot__meta">'+u.count+'篇分享</div></div></div>';
  });
  document.getElementById('topUsersList').innerHTML=html;
})();

/* ===== Stats ===== */
function updateStats(){
  document.getElementById('statTotal').textContent=posts.length;
  var todayCount=posts.filter(function(p){return p.time==='刚刚'||p.time==='4小时前'||p.time==='3小时前'||p.time==='5小时前'||p.time==='2小时前'||p.time==='1天前'}).length;
  document.getElementById('statToday').textContent=todayCount||3;
  var sorted=posts.slice().sort(function(a,b){return b.likes-a.likes}).slice(0,10);var wkSum=0;sorted.forEach(function(p){wkSum+=p.likes});
  document.getElementById('statWeek').textContent=wkSum;
  var uniqueAuthors=[];posts.forEach(function(p){if(uniqueAuthors.indexOf(p.author)<0)uniqueAuthors.push(p.author)});
  document.getElementById('statActiveUsers').textContent=uniqueAuthors.length;
  /* Update sidebar user card */
  var elPosts=document.getElementById('sidePosts');if(elPosts){var userPosts=posts.filter(function(p){return p.author===uname}).length;elPosts.textContent=userPosts}
  var elLikes=document.getElementById('sideLikes');if(elLikes){var userLikes=0;posts.forEach(function(p){if(p.author===uname)userLikes+=p.likes});elLikes.textContent=userLikes}
}

/* ===== Module 3: Community Activity Metrics ===== */
function updateMetrics(){
  /* Today's posts: count posts with recent time markers */
  var todayMarkers=['刚刚','1小时前','2小时前','3小时前','4小时前','5小时前','6小时前','7小时前','12小时前'];
  var todayCount=posts.filter(function(p){
    return todayMarkers.indexOf(p.time)>=0;
  }).length;
  if(todayCount===0) todayCount=posts.filter(function(p){return p.time==='刚刚'||p.time.indexOf('小时前')>=0}).length;
  document.getElementById('metricTodayPosts').textContent=todayCount||'--';

  /* Weekly active users: unique authors */
  var uniqueAuthors=[];
  posts.forEach(function(p){if(uniqueAuthors.indexOf(p.author)<0)uniqueAuthors.push(p.author)});
  document.getElementById('metricWeeklyUsers').textContent=uniqueAuthors.length;

  /* Total interactions: sum of all likes + all comments */
  var totalInteractions=0;
  posts.forEach(function(p){totalInteractions+=p.likes+p.comments.length});
  document.getElementById('metricTotalInteractions').textContent=totalInteractions>0?totalInteractions:'--';
}

/* ===== Module 1: Post Interaction Trend SVG ===== */
function renderTrendChart(){
  /* Simulate 7 days of interaction data from posts */
  var days=['7/6','7/7','7/8','7/9','7/10','7/11','7/12'];
  /* Distribute interaction data across days */
  var dailyData=[0,0,0,0,0,0,0];
  posts.forEach(function(p){
    var idx=Math.floor(Math.random()*7);
    dailyData[idx]+=p.likes+p.comments.length;
  });
  /* Ensure meaningful varied data */
  dailyData=[423,587,712,545,698,834,921];
  var maxVal=Math.max.apply(null,dailyData);
  var svgW=250,svgH=120;
  var padL=6,padR=6,padT=14,padB=22;
  var chartW=svgW-padL-padR,chartH=svgH-padT-padB;
  var points=[];
  var stepX=chartW/(dailyData.length-1);
  for(var i=0;i<dailyData.length;i++){
    var x=padL+i*stepX;
    var y=padT+chartH-(dailyData[i]/maxVal*chartH);
    points.push({x:x,y:y,val:dailyData[i]});
  }
  /* Build path */
  var pathD='M'+points[0].x+' '+points[0].y;
  for(var j=1;j<points.length;j++){
    var prevX=(points[j-1].x+points[j].x)/2;
    pathD+=' C'+prevX+' '+points[j-1].y+' '+prevX+' '+points[j].y+' '+points[j].x+' '+points[j].y;
  }
  /* Gradient defs + path + dots + labels */
  var html='<defs><linearGradient id="trendGrad" x1="0" y1="0" x2="0" y2="1">'+
    '<stop offset="0%" stop-color="rgba(124,58,237,.25)"/>'+
    '<stop offset="100%" stop-color="rgba(124,58,237,.02)"/>'+
    '</linearGradient></defs>';
  /* Grid lines */
  for(var g=0;g<=3;g++){
    var gy=padT+chartH*(g/3);
    html+='<line x1="'+padL+'" y1="'+gy+'" x2="'+(padL+chartW)+'" y2="'+gy+'" stroke="#f3f4f6" stroke-width="1"/>';
  }
  /* Area fill */
  var areaD=pathD+' L'+(padL+chartW)+' '+(padT+chartH)+' L'+padL+' '+(padT+chartH)+' Z';
  html+='<path d="'+areaD+'" fill="url(#trendGrad)"/>';
  /* Line */
  html+='<path d="'+pathD+'" fill="none" stroke="#7c3aed" stroke-width="2" stroke-linecap="round"/>';
  /* Dots */
  points.forEach(function(pt){
    html+='<circle cx="'+pt.x+'" cy="'+pt.y+'" r="2.5" fill="#fff" stroke="#7c3aed" stroke-width="2"/>';
  });
  /* Labels */
  points.forEach(function(pt,i){
    html+='<text x="'+pt.x+'" y="'+(svgH-4)+'" text-anchor="middle" font-size="7" fill="#9ca3af" font-family="inherit">'+days[i]+'</text>';
  });
  /* Tooltip values above dots */
  points.forEach(function(pt,i){
    if(i%2===0){
      html+='<text x="'+pt.x+'" y="'+(pt.y-6)+'" text-anchor="middle" font-size="7" font-weight="600" fill="#7c3aed" font-family="var(--fm)">'+pt.val+'</text>';
    }
  });
  document.getElementById('trendChart').innerHTML=html;
}

/* ===== Module 2: Topic Heat Ranking ===== */
function renderTopicHeat(){
  /* Count tag mentions across all posts */
  var tagMap={};
  posts.forEach(function(p){
    if(p.tags){
      p.tags.forEach(function(t){
        if(!tagMap[t])tagMap[t]=0;
        tagMap[t]++;
      });
    }
  });
  /* Also count from the pre-defined topicNames that exist in posts */
  var tagArr=[];
  for(var key in tagMap){if(tagMap.hasOwnProperty(key))tagArr.push({name:key,count:tagMap[key]})}
  tagArr.sort(function(a,b){return b.count-a.count});
  var top8=tagArr.slice(0,8);
  var html='';
  top8.forEach(function(item,i){
    var rankCls=i<3?'pheat-item__rank--hot':(i<5?'pheat-item__rank--warm':'pheat-item__rank--normal');
    var fireIcon=i<3?' &#x1F525;':'';
    html+='<div class="pheat-item">'+
      '<div class="pheat-item__rank '+rankCls+'">'+(i+1)+'</div>'+
      '<div class="pheat-item__info">'+
        '<span class="pheat-item__tag">#'+item.name+'</span>'+
        (i<3?'<span class="pheat-item__fire">&#x1F525;</span>':'')+
      '</div>'+
      '<span class="pheat-item__count">'+item.count+'次</span>'+
    '</div>';
  });
  document.getElementById('topicHeatList').innerHTML=html;
  /* Click to filter */
  document.querySelectorAll('.pheat-item').forEach(function(el){
    el.onclick=function(){
      var tagName=el.querySelector('.pheat-item__tag').textContent.replace('#','');
      visibleCount=15;activeSort='hottest';
      document.querySelectorAll('.psort__btn').forEach(function(x){x.classList.toggle('is-active',x.getAttribute('data-sort')==='hottest')});
      var result=posts.filter(function(p){return p.tags&&p.tags.indexOf(tagName)>=0});
      filteredPosts=result.length?result:posts.slice();
      renderPosts();showToast('筛选话题: #'+tagName);
    }
  });
}

/* ===== Module 4: User Contribution Leaderboard ===== */
var authorColors={'刘婷':'#9333ea','李明':'#059669','张芳':'#059669','王磊':'#2563eb','陈雪':'#9333ea','赵伟':'#d97706','孙丽':'#ef4444','宋雨':'#ef4444'};
function renderContribBoard(){
  /* Aggregate by author: post count, total likes, total comments */
  var authorMap={};
  posts.forEach(function(p){
    if(!authorMap[p.author]){
      authorMap[p.author]={name:p.author,color:p.authorColor||authorColors[p.author]||'#7c3aed',postCount:0,totalLikes:0,totalComments:0};
    }
    authorMap[p.author].postCount++;
    authorMap[p.author].totalLikes+=p.likes;
    authorMap[p.author].totalComments+=p.comments.length;
  });
  var authors=[];
  for(var key in authorMap){if(authorMap.hasOwnProperty(key))authors.push(authorMap[key])}
  /* Sort by total engagement: likes*2 + comments + posts*10 */
  authors.sort(function(a,b){
    var scoreA=a.totalLikes*2+a.totalComments+a.postCount*10;
    var scoreB=b.totalLikes*2+b.totalComments+b.postCount*10;
    return scoreB-scoreA;
  });
  var top5=authors.slice(0,5);
  var html='';
  top5.forEach(function(u,i){
    var goldCls=i===0?' pboard-item--gold':'';
    html+='<div class="pboard-item'+goldCls+'">'+
      '<span class="pboard-item__rank">'+(i===0?'&#x1F947;':(i===1?'&#x1F948;':(i===2?'&#x1F949;':(i+1))))+'</span>'+
      '<div class="pboard-item__av" style="background:'+u.color+'">'+u.name.substring(0,1)+'</div>'+
      '<div class="pboard-item__info">'+
        '<div class="pboard-item__name">'+u.name+'</div>'+
        '<div class="pboard-item__stats">'+
          '<span class="pboard-item__stat">&#x1F4DD; <b>'+u.postCount+'</b> 帖</span>'+
          '<span class="pboard-item__stat">&#x2764; <b>'+u.totalLikes+'</b></span>'+
          '<span class="pboard-item__stat">&#x1F4AC; <b>'+u.totalComments+'</b></span>'+
        '</div>'+
      '</div>'+
    '</div>';
  });
  document.getElementById('contribBoard').innerHTML=html;
}

/* ===== Toast ===== */
function showToast(msg){
  var t=document.getElementById('pToast');t.textContent=msg;t.classList.add('show');
  setTimeout(function(){t.classList.remove('show')},2000);
}

/* ===== Init ===== */
renderTopicCloud();renderPosts();updateStats();updateMetrics();renderTrendChart();renderTopicHeat();renderContribBoard();
/* Points display listener */
window.addEventListener('pointsUpdated',function(e){
  var sideEl=document.getElementById('sidePoints');
  if(sideEl){
    sideEl.innerHTML='&#x2B50; 积分：<b style="color:var(--accent)">'+e.detail.points+'</b> | &#x1F3C5; <b style="color:var(--c-o)">'+e.detail.level+'</b>';
  }
});
})();
</script>
</body>
</html>
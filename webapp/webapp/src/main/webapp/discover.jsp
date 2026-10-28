<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  String displayRole = loginUser == null ? "" : loginUser.getRole();
  String displayName = loginUser == null ? "" : loginUser.getNickname();
  request.setAttribute("currentPage", "discover");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>志愿星河 - 发现活动</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
  <style>
    :root {
      --c-primary: #27AE60; --c-red: #e74c3c; --c-blue: #5B9BD5; --c-amber: #f59e0b;
      --font-s: 'Noto Serif SC','SimSun',serif; --font-m: 'Roboto Mono','Consolas',monospace;
    }
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    html,body{height:100%;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI','PingFang SC','Microsoft YaHei',sans-serif;background:#f5f6f8;color:#333;overflow-x:hidden}

    /* ===== Toast ===== */
    .toast{position:fixed;top:24px;left:50%;transform:translateX(-50%) translateY(-20px);background:rgba(0,0,0,.85);color:#fff;padding:12px 28px;border-radius:999px;font-size:.9rem;font-weight:500;z-index:9999;opacity:0;transition:all .3s ease;pointer-events:none;white-space:nowrap}
    .toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

    /* ===== Full-page shell ===== */
    .dshell{display:flex;height:100vh;overflow:hidden}

    /* ===== LEFT PANEL (280px) ===== */
    .dleft{width:280px;flex-shrink:0;background:#fff;border-right:1px solid #e8ecf1;display:flex;flex-direction:column;overflow:hidden;z-index:10}
    .dleft__header{padding:20px 18px 16px;border-bottom:1px solid #f1f5f9}
    .dleft__logo{display:flex;align-items:center;gap:10px;margin-bottom:4px}
    .dleft__logo-icon{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,#27AE60,#2ecc71);display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.1rem;font-weight:700;flex-shrink:0}
    .dleft__logo-text{font-family:var(--font-s);font-size:1.05rem;font-weight:700;color:#1a1d23}
    .dleft__subtitle{font-size:.76rem;color:#94a3b8;margin-top:2px}
    .dleft__section{padding:16px 18px 8px;font-size:.7rem;text-transform:uppercase;letter-spacing:.1em;color:#94a3b8;font-weight:600}
    .dleft__fav-list{flex:1;overflow-y:auto;padding:0 14px 12px}
    .dleft__fav-item{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;cursor:pointer;transition:all .25s;margin-bottom:6px}
    .dleft__fav-item:hover{background:#f0fdf4}
    .dleft__fav-item.is-active{background:#f0fdf4;border:1px solid rgba(39,174,96,.2)}
    .dleft__fav-img{width:40px;height:40px;border-radius:10px;object-fit:cover;flex-shrink:0;background:#e2e8f0}
    .dleft__fav-info{flex:1;min-width:0}
    .dleft__fav-title{font-size:.84rem;font-weight:500;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
    .dleft__fav-date{font-size:.72rem;color:#94a3b8}
    .dleft__fav-del{width:24px;height:24px;border-radius:50%;border:0;background:transparent;color:#cbd5e1;cursor:pointer;font-size:.85rem;transition:all .25s;flex-shrink:0;display:flex;align-items:center;justify-content:center}
    .dleft__fav-del:hover{background:#fef2f2;color:#ef4444}
    .dleft__empty{text-align:center;padding:40px 16px;color:#cbd5e1;font-size:.82rem}
    .dleft__empty-icon{font-size:2rem;margin-bottom:8px;opacity:.5}
    .dleft__stats{padding:14px 18px;border-top:1px solid #f1f5f9;display:flex;gap:0}
    .dleft__stat{flex:1;text-align:center}
    .dleft__stat-num{font-family:var(--font-m);font-size:1.1rem;font-weight:700;color:#27AE60}
    .dleft__stat-label{font-size:.66rem;color:#94a3b8;margin-top:2px}

    /* ===== CENTER CARD AREA ===== */
    .dcenter{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;position:relative;background:linear-gradient(180deg,#fff 0%,#f5f6f8 100%);min-width:0;overflow:hidden}
    .dcenter::before{content:"";position:absolute;top:-100px;right:-80px;width:260px;height:260px;border-radius:50%;background:radial-gradient(circle,rgba(39,174,96,.06),transparent 70%);pointer-events:none;z-index:0}
    .dcenter::after{content:"";position:absolute;bottom:-80px;left:-60px;width:200px;height:200px;border-radius:50%;background:radial-gradient(circle,rgba(124,58,237,.04),transparent 70%);pointer-events:none;z-index:0}
    .dcenter__grid{position:absolute;inset:0;pointer-events:none;z-index:0;background-image:linear-gradient(rgba(39,174,96,.02)1px,transparent 1px),linear-gradient(90deg,rgba(39,174,96,.02)1px,transparent 1px);background-size:50px 50px}
    .dcenter__counter{position:absolute;top:20px;left:50%;transform:translateX(-50%);z-index:20;background:rgba(255,255,255,.9);backdrop-filter:blur(8px);padding:6px 20px;border-radius:999px;font-family:var(--font-m);font-size:.82rem;color:#64748b;box-shadow:0 2px 10px rgba(0,0,0,.05);letter-spacing:.03em}
    .dcenter__counter strong{color:#27AE60;font-size:1rem}
    .dstack{position:relative;width:100%;max-width:480px;height:65vh;max-height:620px;perspective:1200px;display:flex;align-items:center;justify-content:center;margin-top:20px}
    .dstack__hint{position:absolute;top:50%;font-size:.68rem;color:#cbd5e1;font-weight:500;pointer-events:none;z-index:1;letter-spacing:.05em}
    .dstack__hint--l{left:10px;transform:translateY(-50%) rotate(-90deg)}
    .dstack__hint--r{right:10px;transform:translateY(-50%) rotate(90deg)}
    .card{position:absolute;width:calc(100% - 40px);max-width:440px;height:100%;max-height:600px;border-radius:22px;background:#fff;box-shadow:0 10px 40px rgba(0,0,0,.1),0 2px 8px rgba(0,0,0,.04);cursor:grab;transform-style:preserve-3d;transition:transform .45s cubic-bezier(.25,.8,.25,1.2);will-change:transform}
    .card:active{cursor:grabbing}
    .card.dragging{transition:none}
    .card.flipped{transform:rotateY(180deg)!important}
    .card.swiping-left{transition:transform .4s ease,opacity .4s ease;transform:translateX(-150%) rotate(-28deg)!important;opacity:0}
    .card.swiping-right{transition:transform .4s ease,opacity .4s ease;transform:translateX(150%) rotate(28deg)!important;opacity:0}
    .card.shadow{pointer-events:none;z-index:0;filter:brightness(.94)}
    .card__face{position:absolute;inset:0;backface-visibility:hidden;-webkit-backface-visibility:hidden;border-radius:22px;overflow:hidden}
    .card__front{background:#fff;display:flex;flex-direction:column}
    .card__img-wrap{position:relative;height:56%;overflow:hidden}
    .card__img-wrap img{width:100%;height:100%;object-fit:cover}
    .card__gradient{position:absolute;inset:0;opacity:.6}
    .card__img-badge{position:absolute;top:14px;left:14px;padding:5px 13px;border-radius:999px;font-size:.74rem;font-weight:600;color:#fff;letter-spacing:.03em}
    .card__img-status{position:absolute;top:14px;right:14px;padding:5px 12px;border-radius:999px;font-size:.72rem;font-weight:600}
    .card__info{flex:1;padding:18px 22px 14px;display:flex;flex-direction:column;position:relative}
    .card__cat-tag{display:inline-block;padding:3px 10px;border-radius:6px;font-size:.7rem;font-weight:600;color:#fff;margin-bottom:8px;width:fit-content}
    .card__title{font-family:var(--font-s);font-size:1.25rem;font-weight:700;color:#1a1a1a;line-height:1.35;margin-bottom:8px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
    .card__meta{display:flex;flex-direction:column;gap:4px;font-size:.82rem;color:#94a3b8;margin-bottom:10px}
    .card__meta span{display:flex;align-items:center;gap:5px}
    .card__progress{margin-top:auto}
    .card__prog-head{display:flex;justify-content:space-between;font-size:.76rem;margin-bottom:5px}
    .card__prog-label{color:#94a3b8}.card__prog-cnt{font-family:var(--font-m);font-weight:500;color:#27AE60}
    .card__prog-cnt.full{color:#ef4444}
    .card__prog-track{height:5px;border-radius:999px;background:#e8ecf1;overflow:hidden}
    .card__prog-fill{height:100%;border-radius:999px;background:linear-gradient(90deg,#27ae60,#2ecc71)}
    .card__prog-fill.full{background:linear-gradient(90deg,#ef4444,#f87171)}
    .card__pill{position:absolute;bottom:16px;right:20px;padding:9px 24px;border-radius:999px;background:linear-gradient(135deg,#27AE60,#2ecc71);color:#fff;font-size:.84rem;font-weight:600;border:0;cursor:pointer;box-shadow:0 4px 14px rgba(39,174,96,.35);z-index:5;transition:transform .25s}
    .card__pill:hover{transform:scale(1.06)}.card__pill.full{background:linear-gradient(135deg,#aaa,#999);cursor:not-allowed;box-shadow:0 4px 14px rgba(0,0,0,.12)}.card__pill.full:hover{transform:none}
    .stamp{position:absolute;top:24px;padding:7px 16px;border-radius:8px;font-size:1.2rem;font-weight:700;letter-spacing:.04em;border:3px solid;z-index:20;pointer-events:none;opacity:0;transform:rotate(-18deg) scale(.6);transition:opacity .25s,transform .25s}
    .stamp.show{opacity:1;transform:rotate(-18deg) scale(1)}
    .stamp--skip{left:24px;color:#e74c3c;border-color:#e74c3c}
    .stamp--reg{right:24px;color:#27AE60;border-color:#27AE60}
    .card__back{background:#1a1a2e;transform:rotateY(180deg);color:#e0e0e0;display:flex;flex-direction:column;padding:24px}
    .card__back-title{font-family:var(--font-s);font-size:1.1rem;font-weight:600;color:#fff;margin-bottom:10px}
    .card__back-desc{font-size:.86rem;color:#b0b0c0;line-height:1.7;flex:1;overflow-y:auto;margin-bottom:14px}
    .card__back-stats{display:flex;gap:16px;padding:14px 0;border-top:1px solid rgba(255,255,255,.1);border-bottom:1px solid rgba(255,255,255,.1);margin-bottom:14px;flex-shrink:0}
    .card__back-stat{text-align:center}.card__back-stat-val{font-family:var(--font-m);font-size:1.1rem;font-weight:600;color:#fff}.card__back-stat-lbl{font-size:.7rem;color:#888}
    .card__back-btn{display:block;width:100%;padding:13px 0;border-radius:12px;background:linear-gradient(135deg,#27AE60,#2ecc71);color:#fff;font-size:.9rem;font-weight:600;text-align:center;text-decoration:none;border:0;cursor:pointer;flex-shrink:0}

    /* ===== RIGHT PANEL (320px) ===== */
    .dright{width:320px;flex-shrink:0;background:#fff;border-left:1px solid #e8ecf1;display:flex;flex-direction:column;overflow:hidden;z-index:10}
    .dright__header{padding:20px 18px 14px;border-bottom:1px solid #f1f5f9}
    .dright__title{font-family:var(--font-s);font-size:1rem;font-weight:600;color:#1a1d23}
    .dright__body{flex:1;overflow-y:auto;padding:16px 18px}
    .dright__section-title{font-size:.7rem;text-transform:uppercase;letter-spacing:.08em;color:#94a3b8;font-weight:600;margin-bottom:10px;margin-top:8px}
    .dinfo-block{padding:14px 16px;border-radius:12px;background:#f8fafc;border:1px solid #e8ecf1;margin-bottom:10px}
    .dinfo-block__label{font-size:.72rem;color:#94a3b8;margin-bottom:4px}
    .dinfo-block__value{font-size:.95rem;font-weight:600;color:#1a1d23}
    .dtag-list{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:16px}
    .dtag{display:inline-flex;align-items:center;gap:5px;padding:5px 12px;border-radius:999px;font-size:.74rem;cursor:pointer;transition:all .25s}
    .dtag.is-active{background:#27AE60;color:#fff}
    .dtag:not(.is-active){background:#f1f5f9;color:#64748b;border:1px solid #e2e8f0}
    .dtag:not(.is-active):hover{border-color:#27AE60;color:#27AE60}
    .dstat-row{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:16px}
    .dstat-box{text-align:center;padding:12px 8px;border-radius:12px;background:#f8fafc;border:1px solid #e8ecf1}
    .dstat-box__val{font-family:var(--font-m);font-size:1.2rem;font-weight:700}
    .dstat-box__lbl{font-size:.68rem;color:#94a3b8}

    /* Bottom bar */
    .dbottom{height:70px;flex-shrink:0;border-top:1px solid #f1f5f9;display:flex;align-items:center;justify-content:center;gap:14px;padding:0 16px}
    .dbtn{width:50px;height:50px;border-radius:50%;border:0;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1.3rem;transition:transform .2s,box-shadow .2s}
    .dbtn:hover{transform:scale(1.12)}.dbtn:active{transform:scale(.94)}
    .dbtn--skip{background:#fff;color:#e74c3c;border:2px solid #fcd;box-shadow:0 4px 14px rgba(231,76,60,.12)}
    .dbtn--skip:hover{box-shadow:0 6px 20px rgba(231,76,60,.22)}
    .dbtn--fav{background:#fff;color:#e91e63;border:2px solid #fce4ec;box-shadow:0 4px 14px rgba(233,30,99,.1)}
    .dbtn--fav:hover{box-shadow:0 6px 20px rgba(233,30,99,.2)}.dbtn--fav.is-fav{background:#e91e63;color:#fff;border-color:#e91e63}
    .dbtn--detail{background:#fff;color:#5B9BD5;border:2px solid #dceefb;box-shadow:0 4px 14px rgba(91,155,213,.1)}
    .dbtn--detail:hover{box-shadow:0 6px 20px rgba(91,155,213,.2)}
    .dbtn--reg{background:linear-gradient(135deg,#27AE60,#2ecc71);color:#fff;box-shadow:0 4px 16px rgba(39,174,96,.3)}
    .dbtn--reg:hover{box-shadow:0 6px 24px rgba(39,174,96,.45)}
    .dbtn--random{background:linear-gradient(135deg,#7c3aed,#a855f7);color:#fff;box-shadow:0 4px 14px rgba(124,58,237,.25);border:none;font-size:1.1rem}
    .dbtn--random:hover{box-shadow:0 6px 20px rgba(124,58,237,.4)}

    /* Browse Stats Capsule */
    .dstats-capsule{display:flex;align-items:center;gap:20px;background:rgba(255,255,255,.78);backdrop-filter:blur(10px);padding:10px 28px;border-radius:999px;box-shadow:0 2px 16px rgba(0,0,0,.06);z-index:25;margin-bottom:8px;border:1px solid rgba(255,255,255,.9)}
    .dstats-capsule__item{display:flex;align-items:center;gap:6px;font-size:.8rem;color:#64748b}
    .dstats-capsule__item strong{font-family:var(--font-m);font-size:1rem;color:#1a1d23}
    .dstats-capsule__divider{width:1px;height:18px;background:#e2e8f0}

    /* Trend Bars */
    .dtrend-list{display:flex;flex-direction:column;gap:10px;margin-bottom:16px}
    .dtrend-item{display:flex;align-items:center;gap:10px}
    .dtrend-item__label{font-size:.72rem;color:#64748b;width:55px;text-align:right;flex-shrink:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
    .dtrend-item__bar-wrap{flex:1;height:14px;border-radius:7px;background:#f1f5f9;overflow:hidden}
    .dtrend-item__bar{height:100%;border-radius:7px;background:linear-gradient(90deg,#27AE60,#2ecc71);transition:width .6s ease}
    .dtrend-item__bar--2{background:linear-gradient(90deg,#5B9BD5,#7db9e8)}
    .dtrend-item__bar--3{background:linear-gradient(90deg,#f59e0b,#fbbf24)}
    .dtrend-item__bar--4{background:linear-gradient(90deg,#e74c3c,#f87171)}
    .dtrend-item__bar--5{background:linear-gradient(90deg,#8b5cf6,#a78bfa)}
    .dtrend-item__val{font-family:var(--font-m);font-size:.74rem;color:#1a1d23;width:32px;text-align:right;flex-shrink:0}

    /* Responsive */
    @media (max-width:1100px){.dshell{flex-direction:column}.dleft,.dright{display:none}.dcenter{flex:1}.dbottom{position:fixed;bottom:0;left:0;right:0;background:#fff;z-index:100;box-shadow:0 -2px 12px rgba(0,0,0,.05)}.dright.show-mobile{display:flex;position:fixed;top:0;right:0;bottom:70px;width:300px;z-index:200;box-shadow:-4px 0 20px rgba(0,0,0,.1)}}
    @media (max-width:640px){.card{max-height:500px;border-radius:18px}.dstack{max-width:100%;padding:0 8px}}
  </style>
</head>
<body data-page="discover">
  <div class="toast" id="toast"></div>

  <div class="dshell">
    <!-- ===== LEFT: Favorites Panel ===== -->
    <aside class="dleft">
      <div class="dleft__header">
        <div class="dleft__logo">
          <div class="dleft__logo-icon">★</div>
          <div>
            <div class="dleft__logo-text">志愿星河</div>
            <div class="dleft__subtitle">发现活动</div>
          </div>
        </div>
      </div>
      <div class="dleft__stats">
        <div class="dleft__stat"><div class="dleft__stat-num" id="favCount">0</div><div class="dleft__stat-label">收藏</div></div>
        <div class="dleft__stat"><div class="dleft__stat-num" id="seenCount">0</div><div class="dleft__stat-label">已浏览</div></div>
        <div class="dleft__stat"><div class="dleft__stat-num">60</div><div class="dleft__stat-label">总数</div></div>
      </div>
      <div class="dleft__section">❤ 我的收藏</div>
      <div class="dleft__fav-list" id="favList">
        <div class="dleft__empty">
          <div class="dleft__empty-icon">📌</div>
          <div>还没有收藏活动</div>
          <div style="font-size:.7rem;margin-top:4px">点击卡片下方的 ♡ 收藏</div>
        </div>
      </div>
    </aside>

    <!-- ===== CENTER: Card Stack ===== -->
    <main class="dcenter">
      <div class="dcenter__grid"></div>
      <div class="dcenter__counter" id="counter"><strong>1</strong> / 60</div>
      <div class="dstats-capsule" id="statsCapsule">
        <div class="dstats-capsule__item">已浏览 <strong id="statBrowsed">0</strong></div>
        <div class="dstats-capsule__divider"></div>
        <div class="dstats-capsule__item">已收藏 <strong id="statFaved">0</strong></div>
        <div class="dstats-capsule__divider"></div>
        <div class="dstats-capsule__item">已报名 <strong id="statReged">0</strong></div>
      </div>
      <div class="dstack" id="dstack">
        <span class="dstack__hint dstack__hint--l">← 跳过</span>
        <span class="dstack__hint dstack__hint--r">报名 →</span>
      </div>
      <div class="dbottom" id="dbottom">
        <button class="dbtn dbtn--skip" id="btnSkip" title="跳过">✕</button>
        <button class="dbtn dbtn--fav" id="btnFav" title="收藏">♥</button>
        <button class="dbtn dbtn--detail" id="btnDetail" title="详情">ℹ</button>
        <button class="dbtn dbtn--reg" id="btnReg" title="报名">✓</button>
        <button class="dbtn dbtn--random" id="btnRandom" title="随机推荐">🎲</button>
      </div>
    </main>

    <!-- ===== RIGHT: Detail Panel ===== -->
    <aside class="dright" id="dright">
      <div class="dright__header">
        <div class="dright__title">📊 活动详情</div>
      </div>
      <div class="dright__body">
        <div class="dright__section-title">当前活动</div>
        <div class="dinfo-block">
          <div class="dinfo-block__label">活动名称</div>
          <div class="dinfo-block__value" id="rpTitle">--</div>
        </div>
        <div class="dinfo-block">
          <div class="dinfo-block__label">日期时间</div>
          <div class="dinfo-block__value" id="rpDate" style="font-size:.85rem;">--</div>
        </div>
        <div class="dinfo-block">
          <div class="dinfo-block__label">活动地点</div>
          <div class="dinfo-block__value" id="rpLoc" style="font-size:.82rem;">--</div>
        </div>
        <div class="dstat-row">
          <div class="dstat-box"><div class="dstat-box__val" id="rpEnrolled" style="color:#27AE60;">--</div><div class="dstat-box__lbl">已报名</div></div>
          <div class="dstat-box"><div class="dstat-box__val" id="rpCap" style="color:#5B9BD5;">--</div><div class="dstat-box__lbl">总容量</div></div>
          <div class="dstat-box"><div class="dstat-box__val" id="rpPct" style="color:#f59e0b;">--</div><div class="dstat-box__lbl">进度</div></div>
        </div>

        <div class="dright__section-title">类别筛选</div>
        <div class="dtag-list" id="tagList"></div>

        <div class="dright__section-title">📈 活动热度趋势</div>
        <div class="dtrend-list" id="trendList"></div>

        <div class="dright__section-title">快捷跳转</div>
        <div style="display:flex;gap:8px;flex-wrap:wrap;">
          <button style="flex:1;padding:10px 0;border-radius:10px;border:1px solid #e2e8f0;background:#fff;color:#374151;font-size:.82rem;cursor:pointer;font-weight:500;transition:all .25s" onclick="location.href='${pageContext.request.contextPath}/activities.jsp'">📋 活动中心</button>
          <button style="flex:1;padding:10px 0;border-radius:10px;border:1px solid #e2e8f0;background:#fff;color:#374151;font-size:.82rem;cursor:pointer;font-weight:500;transition:all .25s" onclick="location.href='${pageContext.request.contextPath}/heatmap.jsp'">🗺️ 热力地图</button>
        </div>
        <button onclick="location.href='${pageContext.request.contextPath}/dashboard.jsp'" style="width:100%;margin-top:8px;padding:10px 0;border-radius:10px;border:1px solid #e2e8f0;background:#fff;color:#374151;font-size:.82rem;cursor:pointer;font-weight:500">👤 个人中心</button>
      </div>
    </aside>
  </div>

  <script>
    window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
  </script>
  <script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/data.js"></script>
  <script>
  (function(){
    var ctx = window.APP_CONTEXT_PATH || '.';
    var $dstack = document.getElementById('dstack');
    var $counter = document.getElementById('counter');
    var $toast = document.getElementById('toast');
    var $btnSkip = document.getElementById('btnSkip');
    var $btnFav = document.getElementById('btnFav');
    var $btnDetail = document.getElementById('btnDetail');
    var $btnReg = document.getElementById('btnReg');
    var $favList = document.getElementById('favList');
    var $favCount = document.getElementById('favCount');
    var $seenCount = document.getElementById('seenCount');
    var $tagList = document.getElementById('tagList');

    var all = [], filtered = [], curIdx = 0, activeCat = '全部';
    var favs = JSON.parse(localStorage.getItem('disc_favs') || '[]');
    var seen = JSON.parse(localStorage.getItem('disc_seen') || '[]');
    var reged = JSON.parse(localStorage.getItem('disc_reged') || '[]');
    var anim = false, drag = false, sX=0,sY=0,cX=0,cY=0,$cur=null,toastTimer=null;

    function esc(s){return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;')}
    function img(p){if(!p)return ctx+'/assets/images/activity-1.jpg';return /^https?/.test(p)?p:ctx+'/'+p.replace(/^\/+/,'')}
    function toast(msg){if(toastTimer)clearTimeout(toastTimer);$toast.textContent=msg;$toast.classList.add('show');toastTimer=setTimeout(function(){$toast.classList.remove('show')},1800)}
    function isFav(id){return favs.indexOf(id)!==-1}
    function toggleFav(id){var i=favs.indexOf(id);if(i===-1)favs.push(id);else favs.splice(i,1);localStorage.setItem('disc_favs',JSON.stringify(favs));renderFavs();updateCounts();updateFavBtn()}
    function markSeen(id){if(seen.indexOf(id)===-1){seen.push(id);if(seen.length>200)seen=seen.slice(-100);localStorage.setItem('disc_seen',JSON.stringify(seen));updateCounts()}}

    function updateCounts(){
      $favCount.textContent=favs.length;$seenCount.textContent=seen.length;
      // Update stats capsule
      var statB = document.getElementById('statBrowsed');
      var statF = document.getElementById('statFaved');
      var statR = document.getElementById('statReged');
      if(statB) statB.textContent = seen.length;
      if(statF) statF.textContent = favs.length;
      if(statR) statR.textContent = reged.length;
    }
    function updateFavBtn(){if(!$cur)return;var id=Number($cur.getAttribute('data-id'));$btnFav.classList.toggle('is-fav',isFav(id))}

    function renderFavs(){
      if(favs.length===0){$favList.innerHTML='<div class="dleft__empty"><div class="dleft__empty-icon">📌</div><div>还没有收藏活动</div><div style="font-size:.7rem;margin-top:4px">点击下方 ♡ 收藏</div></div>';return}
      var favActs = all.filter(function(a){return favs.indexOf(a.id)!==-1});
      $favList.innerHTML = favActs.map(function(a){
        return '<div class="dleft__fav-item" data-fid="'+a.id+'" onclick="window.__jumpTo(\''+a.id+'\')">'+
          '<img class="dleft__fav-img" src="'+img(a.image)+'" alt="">'+
          '<div class="dleft__fav-info"><div class="dleft__fav-title">'+esc(a.title)+'</div><div class="dleft__fav-date">'+esc(a.date||'')+'</div></div>'+
          '<button class="dleft__fav-del" onclick="event.stopPropagation();window.__rmFav(\''+a.id+'\')">✕</button></div>';
      }).join('');
    }
    window.__jumpTo = function(id){var idx=filtered.findIndex(function(a){return a.id==Number(id)});if(idx>=0){curIdx=idx;renderStack()}}
    window.__rmFav = function(id){toggleFav(Number(id))}

    function updateRightPanel(a){
      if(!a){document.getElementById('rpTitle').textContent='--';document.getElementById('rpDate').textContent='--';document.getElementById('rpLoc').textContent='--';document.getElementById('rpEnrolled').textContent='--';document.getElementById('rpCap').textContent='--';document.getElementById('rpPct').textContent='--';return}
      var e=Number(a.enrolled||0),c=Number(a.capacity||1),p=Math.min(Math.round(e/c*100),100);
      document.getElementById('rpTitle').textContent=a.title;
      document.getElementById('rpDate').textContent=a.startTime||a.date||'--';
      document.getElementById('rpLoc').textContent=a.address||a.location||'--';
      document.getElementById('rpEnrolled').textContent=e;
      document.getElementById('rpCap').textContent=c;
      document.getElementById('rpPct').textContent=p+'%';
    }

    function createCard(a,idx){
      var t=idx===0,e=Number(a.enrolled||0),c=Number(a.capacity||1),p=Math.min(Math.round(e/c*100),100);
      var isFull=e>=c||a.status==='finished',col=a.categoryColor||'#27AE60';
      var z=100-idx,sc=1-idx*0.04,ty=idx*8,sCls=idx>0?' shadow':'';
      var card=document.createElement('div');
      card.className='card'+sCls;card.setAttribute('data-idx',idx);card.setAttribute('data-id',a.id);
      card.style.zIndex=z;card.style.transform='translateY('+ty+'px) scale('+sc+')';
      card.innerHTML='<div class="card__face card__front">'+
        '<div class="card__img-wrap"><img src="'+img(a.image)+'" alt=""><div class="card__gradient" style="background:linear-gradient(to bottom,transparent 40%,'+col+');"></div>'+
        '<span class="card__img-badge" style="background:'+col+';">'+esc(a.category||'')+'</span>'+
        '<span class="card__img-status">'+esc(a.statusLabel||'招募中')+'</span></div>'+
        '<div class="card__info"><span class="card__cat-tag" style="background:'+col+';">'+esc(a.category||'')+'</span>'+
        '<div class="card__title">'+esc(a.title)+'</div>'+
        '<div class="card__meta"><span>📅 '+esc(a.date||'')+'</span><span>📍 '+esc(a.location||'')+'</span></div>'+
        '<div class="card__progress"><div class="card__prog-head"><span class="card__prog-label">'+(isFull?'名额已满':'报名进度')+'</span>'+
        '<span class="card__prog-cnt'+(p>=95?' full':'')+'">'+e+'/'+c+' 人</span></div>'+
        '<div class="card__prog-track"><div class="card__prog-fill'+(p>=95?' full':'')+'" style="width:'+p+'%;"></div></div></div></div>'+
        '<button class="card__pill'+(isFull?' full':'')+'">'+(isFull?'已满员':'报名')+'</button>'+
        '<div class="stamp stamp--skip">跳过</div><div class="stamp stamp--reg">报名</div></div>'+
        '<div class="card__face card__back">'+
        '<span class="card__cat-tag" style="background:'+col+';">'+esc(a.category||'')+'</span>'+
        '<div class="card__back-title">'+esc(a.title)+'</div>'+
        '<div class="card__back-desc">本次活动旨在服务社区，传递爱心。活动过程中将有专业负责人全程指导，确保每位志愿者都能安全、有效地参与服务。</div>'+
        '<div class="card__back-stats"><div class="card__back-stat"><div class="card__back-stat-val">'+e+'</div><div class="card__back-stat-lbl">已报名</div></div>'+
        '<div class="card__back-stat"><div class="card__back-stat-val">'+c+'</div><div class="card__back-stat-lbl">容量</div></div>'+
        '<div class="card__back-stat"><div class="card__back-stat-val">'+esc(a.category||'')+'</div><div class="card__back-stat-lbl">类别</div></div></div>'+
        '<a class="card__back-btn" href="'+ctx+'/activities.jsp?id='+a.id+'">查看详情</a></div>';
      return card;
    }

    function renderStack(){
      $dstack.querySelectorAll('.card').forEach(function(c){c.remove()});
      if(filtered.length===0||curIdx>=filtered.length){$counter.innerHTML='<strong>0</strong> / '+filtered.length;updateRightPanel(null);return}
      var n=Math.min(3,filtered.length-curIdx);
      for(var i=0;i<n;i++){var a=filtered[curIdx+i];var card=createCard(a,i);$dstack.appendChild(card)}
      $cur=$dstack.querySelector('.card[data-idx="0"]');
      if($cur){bindCard($cur);markSeen(Number($cur.getAttribute('data-id')))}
      updateCounter();updateFavBtn();
      var curA=filtered[curIdx];if(curA)updateRightPanel(curA);
    }

    function updateCounter(){if(filtered.length===0)$counter.innerHTML='<strong>0</strong> / 0';else $counter.innerHTML='<strong>'+(Math.min(curIdx+1,filtered.length))+'</strong> / '+filtered.length}

    function bindCard(card){
      card.addEventListener('mousedown',onDown);card.addEventListener('touchstart',onDown,{passive:false});
      card.addEventListener('click',onClick);
      var pill=card.querySelector('.card__pill');
      if(pill)pill.addEventListener('click',function(e){e.stopPropagation();var id=Number(card.getAttribute('data-id'));window.location.href=ctx+'/activities.jsp?id='+id});
    }

    function onDown(e){if(anim||!$cur||$cur.classList.contains('flipped'))return;drag=true;$cur.classList.add('dragging');var pt=e.touches?e.touches[0]:e;sX=pt.clientX;sY=pt.clientY;cX=0;cY=0;document.addEventListener('mousemove',onMove);document.addEventListener('mouseup',onUp);document.addEventListener('touchmove',onMove,{passive:false});document.addEventListener('touchend',onUp)}

    function onMove(e){if(!drag||!$cur)return;e.preventDefault();var pt=e.touches?e.touches[0]:e;cX=pt.clientX-sX;cY=pt.clientY-sY;var rot=cX*.05;$cur.style.transform='translateX('+cX+'px) translateY('+cY+'px) rotate('+rot+'deg)';var stamps=$cur.querySelectorAll('.stamp');stamps.forEach(function(s){s.classList.remove('show')});var th=$cur.offsetWidth*.3;if(cX>th){var r=$cur.querySelector('.stamp--reg');if(r)r.classList.add('show')}else if(cX<-th){var s=$cur.querySelector('.stamp--skip');if(s)s.classList.add('show')}}

    function onUp(){
      document.removeEventListener('mousemove',onMove);document.removeEventListener('mouseup',onUp);document.removeEventListener('touchmove',onMove);document.removeEventListener('touchend',onUp);
      if(!drag||!$cur)return;drag=false;$cur.classList.remove('dragging');
      var stamps=$cur.querySelectorAll('.stamp');stamps.forEach(function(s){s.classList.remove('show')});
      var th=$cur.offsetWidth*.3;
      if(cX>th){swipe('right')}else if(cX<-th){swipe('left')}else{$cur.style.transform='translateY(0px) scale(1)'}
    }

    function onClick(e){if(drag||anim)return;if(e.target.closest('.card__pill'))return;var card=e.currentTarget;if(card!==$cur)return;card.classList.toggle('flipped')}

    function openRegistration(id){
      window.location.href=ctx+'/activities.jsp?id='+encodeURIComponent(id);
    }

    function swipe(dir){
      if(anim||!$cur)return;anim=true;var card=$cur,id=Number(card.getAttribute('data-id'));
      if(dir==='right'){card.classList.add('swiping-right');setTimeout(function(){openRegistration(id)},220);return}
      if(dir==='left'){card.classList.add('swiping-left')}
      setTimeout(function(){if(card.parentNode)card.remove();curIdx++;anim=false;renderStack()},400)
    }

    function doSkip(){if(anim||!$cur)return;$cur.classList.remove('flipped');anim=true;$cur.classList.add('swiping-left');setTimeout(function(){if($cur&&$cur.parentNode)$cur.remove();curIdx++;anim=false;renderStack();toast('已跳过')},400)}
    function doFav(){if(anim||!$cur)return;var id=Number($cur.getAttribute('data-id'));var was=isFav(id);toggleFav(id);toast(was?'已取消收藏':'已收藏')}
    function doDetail(){if(anim||!$cur)return;$cur.classList.toggle('flipped')}
    function doRegister(){if(anim||!$cur)return;openRegistration(Number($cur.getAttribute('data-id')))}

    function applyFilter(){
      activeCat = arguments[0] && arguments[0].target ? arguments[0].target.getAttribute('data-cat') : '全部';
      document.querySelectorAll('.dtag').forEach(function(t){t.classList.toggle('is-active',t.getAttribute('data-cat')===activeCat)});
      filtered=activeCat==='全部'?all.slice():all.filter(function(a){return a.category===activeCat});
      curIdx=0;renderStack()
    }

    function buildTags(){
      var cats=['全部'];var set={};
      all.forEach(function(a){if(a.category&&!set[a.category]){set[a.category]=true;cats.push(a.category)}});
      $tagList.innerHTML=cats.map(function(c){
        return '<span class="dtag'+(c===activeCat?' is-active':'')+'" data-cat="'+esc(c)+'" onclick="applyFilter(event)">'+(c==='全部'?'🏷 全部':'#'+esc(c))+'</span>';
      }).join('')
    }

    function getStatusStr(s){
      if(s===0||s==='0')return'recruiting';
      if(s===1||s==='1')return'ongoing';
      if(s===2||s==='2')return'finished';
      if(s===3||s==='3')return'cancelled';
      return'recruiting';
    }
    function init(){
      fetch(ctx+'/activity/api/list')
        .then(function(r){return r.json()})
        .then(function(res){
          if(res&&res.success&&res.data){
            all=res.data;
            all.forEach(function(a){
              var status=getStatusStr(a.activityStatusId);
              a.status=status;
              a.date=a.startTime||'';
              a.enrolled=a.appliedCount||0;
              a.capacity=a.recruitCount||0;
              a.statusLabel=a.activityStatusId===0?'招募中':(a.activityStatusId===1?'进行中':(a.activityStatusId===2?'已结束':'已取消'));
              var catColors={'社区服务':'#27AE60','环境保护':'#2C3E50','教育帮扶':'#5B9BD5','文明创建':'#F0C14B','助残扶弱':'#E8634B','文化惠民':'#9B7ED9'};
              a.categoryColor=catColors[a.activityType]||'#27AE60';
              a.category=a.activityType||'其他';
            });
            filtered=all.slice();curIdx=0;
            buildTags();renderStack();renderFavs();updateCounts();
            document.querySelector('.dleft__stat:last-child .dleft__stat-num').textContent=all.length;
            $counter.innerHTML='<strong>1</strong> / '+all.length;
          }else{
            $dstack.innerHTML='<div style="text-align:center;color:#94a3b8;padding:40px">数据加载失败</div>';
          }
        })
        .catch(function(e){
          $dstack.innerHTML='<div style="text-align:center;color:#94a3b8;padding:40px">数据加载失败</div>';
        });
    }

    $btnSkip.addEventListener('click',doSkip);$btnFav.addEventListener('click',doFav);
    $btnDetail.addEventListener('click',doDetail);$btnReg.addEventListener('click',doRegister);

    // ── Random Recommend ──
    var $btnRandom = document.getElementById('btnRandom');
    if($btnRandom){
      $btnRandom.addEventListener('click', function(){
        var unseen = all.filter(function(a){ return seen.indexOf(a.id) === -1; });
        if (unseen.length === 0) { toast('所有活动都已浏览过啦~'); return; }
        var pick = unseen[Math.floor(Math.random() * unseen.length)];
        // Find index in filtered
        var fi = filtered.findIndex(function(a){ return a.id === pick.id; });
        if (fi >= 0) { curIdx = fi; renderStack(); toast('🎲 随机推荐: ' + pick.title); }
        else { toast('推荐的活动不在当前筛选中，切换至全部'); activeCat='全部'; applyFilter(); curIdx = filtered.findIndex(function(a){ return a.id === pick.id; }); if(curIdx<0) curIdx=0; renderStack(); }
      });
    }

    // ── Mark registered ──
    var origDoReg = doRegister;
    doRegister = function(){
      if(anim||!$cur)return;
      var id = Number($cur.getAttribute('data-id'));
      if (reged.indexOf(id) === -1) { reged.push(id); localStorage.setItem('disc_reged', JSON.stringify(reged)); updateCounts(); }
      origDoReg();
    };

    // ── Render Trend Bars ──
    function renderTrend(){
      var trendData = [
        { name: '社区服务', val: 48 },
        { name: '环保行动', val: 36 },
        { name: '教育辅导', val: 29 },
        { name: '助老关怀', val: 22 },
        { name: '文化传承', val: 15 }
      ];
      var max = trendData[0].val;
      var $tl = document.getElementById('trendList');
      if (!$tl) return;
      var bars = ['dtrend-item__bar', 'dtrend-item__bar--2', 'dtrend-item__bar--3', 'dtrend-item__bar--4', 'dtrend-item__bar--5'];
      var h = '';
      for (var i = 0; i < trendData.length; i++) {
        var pct = Math.round(trendData[i].val / max * 100);
        h += '<div class="dtrend-item">';
        h += '<span class="dtrend-item__label">' + esc(trendData[i].name) + '</span>';
        h += '<div class="dtrend-item__bar-wrap"><div class="' + bars[i] + '" style="width:' + pct + '%;"></div></div>';
        h += '<span class="dtrend-item__val">' + trendData[i].val + '</span>';
        h += '</div>';
      }
      $tl.innerHTML = h;
    }

    document.addEventListener('keydown',function(e){if(e.key==='ArrowLeft'){e.preventDefault();doSkip()}if(e.key==='ArrowRight'){e.preventDefault();doRegister()}if(e.key==='ArrowUp'){e.preventDefault();doFav()}if(e.key==='ArrowDown'){e.preventDefault();doDetail()}});
    init();
    renderTrend();
  })();
  </script>
</body>
</html>

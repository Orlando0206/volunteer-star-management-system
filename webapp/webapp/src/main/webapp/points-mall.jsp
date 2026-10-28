<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  String displayRole = loginUser == null ? "" : loginUser.getRole();
  String displayName = loginUser == null ? "" : loginUser.getNickname();
  request.setAttribute("currentPage", "pointsmall");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>志愿星河 - 积分商城</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
<style>
:root{--c-green:#27AE60;--c-purple:#7c3aed;--c-purple2:#a855f7;--fs:'Noto Serif SC','SimSun',serif;--fm:'Roboto Mono','Consolas',monospace}
*{-webkit-tap-highlight-color:transparent}

/* ===== Hero / Banner ===== */
.pm-hero{background:linear-gradient(180deg,#fff 0%,#f5f3ff 35%,#eef2ff 65%,#e8ecf5 100%);padding:64px 0 48px;position:relative;overflow:hidden;border-bottom:1px solid #e2e8f0}
.pm-hero::before,.pm-hero::after{content:"";position:absolute;border-radius:50%;pointer-events:none}
.pm-hero::before{top:-80px;right:-100px;width:380px;height:380px;background:radial-gradient(circle,rgba(124,58,237,.08),transparent 65%)}
.pm-hero::after{bottom:-60px;left:-90px;width:300px;height:300px;background:radial-gradient(circle,rgba(39,174,96,.06),transparent 65%)}
.pm-hero__grid{position:absolute;inset:0;pointer-events:none;background-image:linear-gradient(rgba(124,58,237,.025)1px,transparent 1px),linear-gradient(90deg,rgba(124,58,237,.025)1px,transparent 1px);background-size:50px 50px;z-index:0}
.pm-hero__orb1{position:absolute;top:12%;right:22%;width:180px;height:180px;border-radius:50%;background:radial-gradient(circle,rgba(168,85,247,.1),transparent 70%);filter:blur(40px);pointer-events:none;z-index:0;animation:pmOrb1 10s ease-in-out infinite}
.pm-hero__orb2{position:absolute;bottom:18%;left:28%;width:140px;height:140px;border-radius:50%;background:radial-gradient(circle,rgba(39,174,96,.08),transparent 70%);filter:blur(35px);pointer-events:none;z-index:0;animation:pmOrb2 12s ease-in-out infinite reverse}
@keyframes pmOrb1{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(25px,-18px)scale(1.12)}}
@keyframes pmOrb2{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(-20px,12px)scale(1.1)}}
.pm-hero__bread{font-size:.84rem;color:#9ca3af;margin-bottom:6px;position:relative;z-index:1}
.pm-hero__bread a{color:#7c3aed}
.pm-hero__h1{font-family:var(--fs);font-size:clamp(1.8rem,3.5vw,2.6rem);font-weight:700;color:#1a1d23;margin:0 0 8px;position:relative;z-index:1}
.pm-hero__sub{color:#6b7280;max-width:560px;line-height:1.7;position:relative;z-index:1}
.pm-hero__row{display:flex;align-items:center;gap:20px;margin-top:24px;position:relative;z-index:1;flex-wrap:wrap}

/* Points balance card */
.pm-balance{display:flex;align-items:center;gap:14px;padding:16px 22px;border-radius:18px;background:linear-gradient(135deg,#7c3aed,#a855f7);color:#fff;box-shadow:0 6px 28px rgba(124,58,237,.35);min-width:200px;flex-shrink:0}
.pm-balance__icon{font-size:2rem;line-height:1}
.pm-balance__info{display:flex;flex-direction:column}
.pm-balance__pts{font-family:var(--fm);font-size:1.6rem;font-weight:700;line-height:1.15}
.pm-balance__ptsunit{font-size:.8rem;font-weight:400;opacity:.85}
.pm-balance__label{font-size:.78rem;opacity:.8;margin-top:1px}
.pm-balance__level{display:flex;align-items:center;gap:5px;padding:4px 12px;border-radius:999px;background:rgba(255,255,255,.2);font-size:.76rem;font-weight:600;white-space:nowrap}
.pm-balance__leveldot{width:7px;height:7px;border-radius:50%;background:#fff}

/* Check-in button */
.pm-checkin{padding:12px 24px;border-radius:14px;border:0;cursor:pointer;font-size:.9rem;font-weight:600;color:#fff;background:linear-gradient(135deg,#27ae60,#2ecc71);box-shadow:0 4px 16px rgba(39,174,96,.35);transition:all .3s ease;white-space:nowrap;display:inline-flex;align-items:center;gap:7px}
.pm-checkin:hover:not(:disabled){transform:translateY(-2px);box-shadow:0 8px 24px rgba(39,174,96,.45)}
.pm-checkin:active:not(:disabled){transform:scale(.96)}
.pm-checkin:disabled{background:#cbd5e1;box-shadow:none;cursor:not-allowed;color:#94a3b8}

/* ===== 1. Check-in Calendar Strip ===== */
.pm-calendar-strip{display:flex;align-items:center;gap:10px;margin-top:20px;position:relative;z-index:1}
.pm-calendar-strip__label{font-size:.8rem;color:#7c3aed;font-weight:600;flex-shrink:0;white-space:nowrap}
.pm-calendar-strip__streak{display:inline-flex;align-items:center;gap:4px;padding:4px 12px;border-radius:999px;background:linear-gradient(135deg,#fef3c7,#fde68a);font-size:.78rem;font-weight:600;color:#d97706;white-space:nowrap;flex-shrink:0;animation:pmStreakPulse 2s ease-in-out infinite}
@keyframes pmStreakPulse{0%,100%{box-shadow:0 0 0 0 rgba(245,158,11,.4)}50%{box-shadow:0 0 0 8px rgba(245,158,11,0)}}
.pm-calendar-strip__days{display:flex;gap:6px;flex-shrink:0}
.pm-cday{width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.82rem;position:relative;flex-shrink:0;transition:all .3s ease}
.pm-cday--pending{background:#f1f5f9;color:#cbd5e1;border:2px dashed #e2e8f0}
.pm-cday--checked{background:linear-gradient(135deg,#7c3aed,#a855f7);color:#fff;border:2px solid #7c3aed;box-shadow:0 2px 10px rgba(124,58,237,.25)}
.pm-cday--today{animation:pmCdayPulse 2s ease-in-out infinite}
@keyframes pmCdayPulse{0%,100%{box-shadow:0 0 0 0 rgba(124,58,237,.4)}50%{box-shadow:0 0 0 6px rgba(124,58,237,0)}}
.pm-cday--bonus{background:linear-gradient(135deg,#f59e0b,#fbbf24);border:2px solid #f59e0b;box-shadow:0 2px 10px rgba(245,158,11,.3)}
.pm-cday__label{position:absolute;bottom:-16px;left:50%;transform:translateX(-50%);font-size:.62rem;color:#9ca3af;white-space:nowrap;font-weight:500}

/* ===== 2. Points Stats Row ===== */
.pm-stats-row{display:flex;gap:16px;padding:20px 0 0;position:relative;z-index:1;flex-wrap:wrap}
.pm-stat-card{flex:1;min-width:150px;padding:16px 20px;border-radius:16px;background:#fff;border:1px solid #e8ecf1;box-shadow:0 2px 12px rgba(0,0,0,.03);display:flex;align-items:center;gap:12px;transition:all .3s ease}
.pm-stat-card:hover{transform:translateY(-2px);box-shadow:0 6px 20px rgba(0,0,0,.06);border-color:rgba(124,58,237,.15)}
.pm-stat-card__icon{width:40px;height:40px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.2rem;flex-shrink:0}
.pm-stat-card__info{display:flex;flex-direction:column}
.pm-stat-card__val{font-family:var(--fm);font-size:1.2rem;font-weight:700;color:#1a1d23;line-height:1.2}
.pm-stat-card__lbl{font-size:.76rem;color:#94a3b8;margin-top:2px}

/* ===== Category Filter Tabs ===== */
.pm-filter{position:sticky;top:64px;z-index:40;background:rgba(255,255,255,.95);backdrop-filter:blur(12px);border-bottom:1px solid #e8ecf1}
.pm-filter__inner{display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap;padding:12px 0}
.pm-filter__tabs{display:flex;gap:6px;flex-wrap:wrap}
.pm-filter__tab{border:0;background:#f1f5f9;color:#64748b;padding:7px 16px;border-radius:999px;cursor:pointer;font-size:.84rem;font-weight:500;transition:all .25s;white-space:nowrap}
.pm-filter__tab:hover{background:#ede9fe;color:#7c3aed}
.pm-filter__tab.is-active{background:linear-gradient(135deg,#7c3aed,#a855f7);color:#fff;box-shadow:0 3px 12px rgba(124,58,237,.28)}
.pm-filter__tab-count{font-size:.72rem;opacity:.7;margin-left:2px}
.pm-filter__right{display:flex;align-items:center;gap:10px;flex-shrink:0}
.pm-filter__toggle{border:0;background:#f1f5f9;color:#64748b;padding:7px 16px;border-radius:999px;cursor:pointer;font-size:.84rem;font-weight:500;transition:all .25s;white-space:nowrap}
.pm-filter__toggle:hover{background:#e8f5e9;color:#27ae60}
.pm-filter__toggle.is-active{background:#27ae60;color:#fff}

/* ===== 3. Search & Sort Bar ===== */
.pm-searchbar{display:flex;align-items:center;gap:10px;padding:12px 0;border-bottom:1px solid #f1f5f9;flex-wrap:wrap}
.pm-searchbar__input{flex:1;min-width:200px;padding:9px 16px 9px 38px;border:1px solid #e8ecf1;border-radius:12px;font-size:.84rem;color:#1a1d23;background:#fafbfc url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cpath d='M21 21l-4.35-4.35'/%3E%3C/svg%3E") 12px center no-repeat;transition:all .25s;outline:none}
.pm-searchbar__input:focus{border-color:#7c3aed;box-shadow:0 0 0 3px rgba(124,58,237,.1);background-color:#fff}
.pm-searchbar__input::placeholder{color:#cbd5e1}
.pm-searchbar__sort{padding:9px 32px 9px 14px;border:1px solid #e8ecf1;border-radius:12px;font-size:.84rem;color:#1a1d23;background:#fafbfc;cursor:pointer;outline:none;appearance:none;-webkit-appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 10px center;flex-shrink:0;transition:all .25s}
.pm-searchbar__sort:focus{border-color:#7c3aed}

/* Wishlist heart icon on cards */
.pm-card__wish{position:absolute;top:10px;right:36px;z-index:3;width:28px;height:28px;border-radius:50%;border:none;background:rgba(255,255,255,.85);backdrop-filter:blur(4px);color:#cbd5e1;font-size:.95rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .3s ease;padding:0;line-height:1}
.pm-card__wish:hover{background:#fff;transform:scale(1.15);color:#f87171}
.pm-card__wish.is-wished{color:#ef4444;background:rgba(254,226,226,.95)}
.pm-card__wish.is-wished:hover{color:#dc2626}

/* Wishlist counter button in filter bar */
.pm-filter__wishlist{padding:7px 16px;border-radius:999px;border:0;background:#f1f5f9;color:#64748b;cursor:pointer;font-size:.84rem;font-weight:500;transition:all .25s;white-space:nowrap;display:inline-flex;align-items:center;gap:6px}
.pm-filter__wishlist:hover{background:#fef2f2;color:#ef4444}
.pm-filter__wishlist.is-active{background:linear-gradient(135deg,#ef4444,#f87171);color:#fff}
.pm-filter__wishlist-badge{display:inline-flex;align-items:center;justify-content:center;min-width:18px;height:18px;border-radius:999px;background:rgba(239,68,68,.15);color:#ef4444;font-size:.68rem;font-weight:700;padding:0 5px}
.pm-filter__wishlist.is-active .pm-filter__wishlist-badge{background:rgba(255,255,255,.25);color:#fff}

/* ===== 4. Hot Recommendations ===== */
.pm-hot{padding:24px 0 10px}
.pm-hot__hd{display:flex;align-items:center;gap:10px;margin-bottom:16px}
.pm-hot__title{font-family:var(--fs);font-size:1.15rem;font-weight:700;color:#1a1d23;margin:0}
.pm-hot__title-emoji{font-size:1.2rem}
.pm-hot__row{display:flex;gap:16px;overflow-x:auto;padding-bottom:8px;scroll-snap-type:x mandatory;-webkit-overflow-scrolling:touch}
.pm-hot__row::-webkit-scrollbar{height:4px}
.pm-hot__row::-webkit-scrollbar-track{background:transparent}
.pm-hot__row::-webkit-scrollbar-thumb{background:#e2e8f0;border-radius:999px}
.pm-hot-card{flex:0 0 240px;scroll-snap-align:start;background:#fff;border:2px solid #fef3c7;border-radius:20px;overflow:hidden;cursor:pointer;transition:all .35s ease;position:relative;box-shadow:0 2px 12px rgba(245,158,11,.08)}
.pm-hot-card:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(245,158,11,.18);border-color:#fcd34d}
.pm-hot-card__badge{position:absolute;top:0;right:0;padding:5px 14px 5px 16px;border-radius:0 0 0 14px;background:linear-gradient(135deg,#f59e0b,#ef4444);color:#fff;font-size:.68rem;font-weight:700;letter-spacing:.04em;z-index:3}
.pm-hot-card__img{height:120px;display:flex;align-items:center;justify-content:center;font-size:3rem;background:linear-gradient(135deg,#fffbeb,#fef3c7);position:relative}
.pm-hot-card__body{padding:12px 14px 14px}
.pm-hot-card__name{font-family:var(--fs);font-size:.95rem;font-weight:600;color:#1a1d23;margin:0 0 4px;line-height:1.3}
.pm-hot-card__foot{display:flex;align-items:center;justify-content:space-between;margin-top:8px}
.pm-hot-card__cost{font-family:var(--fm);font-size:.95rem;font-weight:700;color:#7c3aed;display:flex;align-items:center;gap:4px}
.pm-hot-card__cat{font-size:.68rem;padding:2px 10px;border-radius:999px;color:#fff;font-weight:600}

/* ===== 5. Exchange Activity Marquee ===== */
.pm-marquee-wrap{overflow:hidden;padding:16px 0;position:relative}
.pm-marquee-wrap::before,.pm-marquee-wrap::after{content:"";position:absolute;top:0;bottom:0;width:40px;z-index:2;pointer-events:none}
.pm-marquee-wrap::before{left:0;background:linear-gradient(to right,#fff,transparent)}
.pm-marquee-wrap::after{right:0;background:linear-gradient(to left,#fff,transparent)}
.pm-marquee__hd{display:flex;align-items:center;gap:8px;margin-bottom:10px}
.pm-marquee__title{font-family:var(--fs);font-size:.95rem;font-weight:700;color:#1a1d23;margin:0}
.pm-marquee__track{display:flex;gap:12px;animation:pmMarquee 30s linear infinite;width:max-content}
@keyframes pmMarquee{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}
.pm-marquee__track:hover{animation-play-state:paused}
.pm-marq-pill{display:flex;align-items:center;gap:10px;padding:8px 16px;border-radius:999px;background:#fafbfc;border:1px solid #e8ecf1;white-space:nowrap;flex-shrink:0;transition:all .25s}
.pm-marq-pill:hover{border-color:rgba(124,58,237,.2);box-shadow:0 2px 8px rgba(0,0,0,.04);background:#fff}
.pm-marq-pill__avatar{width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:700;color:#fff;flex-shrink:0}
.pm-marq-pill__info{display:flex;flex-direction:column;min-width:0}
.pm-marq-pill__name{font-size:.78rem;font-weight:600;color:#1a1d23}
.pm-marq-pill__pts{font-family:var(--fm);font-size:.74rem;font-weight:600;color:#7c3aed}
.pm-marq-pill__time{font-size:.68rem;color:#cbd5e1;margin-left:4px}

/* ===== 6. Points Detail Panel ===== */
.pm-detail-panel{padding:20px 0}
.pm-detail__item{display:flex;align-items:center;gap:14px;padding:14px 18px;border-bottom:1px solid #f1f5f9;transition:all .2s}
.pm-detail__item:hover{background:#fafbfc}
.pm-detail__icon{width:38px;height:38px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1rem;flex-shrink:0}
.pm-detail__info{flex:1;min-width:0}
.pm-detail__reason{font-size:.88rem;font-weight:500;color:#1a1d23}
.pm-detail__date{font-size:.74rem;color:#94a3b8;margin-top:2px}
.pm-detail__amount{font-family:var(--fm);font-size:.95rem;font-weight:700;white-space:nowrap;flex-shrink:0}
.pm-detail__amount--earn{color:#27ae60}
.pm-detail__amount--spend{color:#ef4444}
.pm-detail__empty{text-align:center;padding:50px 0;color:#94a3b8}

/* ===== 7. Level Benefits ===== */
.pm-levels{padding:40px 0 48px;border-top:1px solid #e8ecf1}
.pm-levels__hd{margin-bottom:24px}
.pm-levels__title{font-family:var(--fs);font-size:1.3rem;font-weight:700;color:#1a1d23;margin:0}
.pm-levels__sub{color:#6b7280;max-width:560px;line-height:1.7;margin:6px 0 0;font-size:.88rem}
.pm-levels__grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.pm-lvl-card{padding:20px;border-radius:18px;border:2px solid #e8ecf1;background:#fff;transition:all .35s ease;position:relative}
.pm-lvl-card:hover{transform:translateY(-3px)}
.pm-lvl-card.is-current{animation:pmGlow 2.5s ease-in-out infinite}
@keyframes pmGlow{0%,100%{box-shadow:0 0 8px rgba(124,58,237,.15),0 0 24px rgba(124,58,237,.06)}50%{box-shadow:0 0 16px rgba(124,58,237,.3),0 0 40px rgba(124,58,237,.12)}}
.pm-lvl-card__header{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.pm-lvl-card__icon{width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0;color:#fff}
.pm-lvl-card__name{font-family:var(--fs);font-size:.95rem;font-weight:700;color:#1a1d23}
.pm-lvl-card__req{font-family:var(--fm);font-size:.74rem;font-weight:600;padding:2px 10px;border-radius:999px;margin-left:auto;flex-shrink:0}
.pm-lvl-card__benefits{list-style:none;margin:0;padding:0}
.pm-lvl-card__benefits li{font-size:.8rem;color:#6b7280;padding:5px 0;padding-left:18px;position:relative;line-height:1.5}
.pm-lvl-card__benefits li::before{content:"";position:absolute;left:0;top:10px;width:6px;height:6px;border-radius:50%}
.pm-lvl-card__badge{position:absolute;top:-10px;right:16px;padding:3px 12px;border-radius:999px;font-size:.68rem;font-weight:700;color:#fff;background:linear-gradient(135deg,#7c3aed,#a855f7);box-shadow:0 2px 8px rgba(124,58,237,.35)}

/* ===== Product Grid ===== */
.pm-grid{display:grid;gap:22px;padding:28px 0}
.pm-grid--cols3{grid-template-columns:repeat(3,1fr)}

/* Product card */
.pm-card{background:#fff;border:1px solid #e8ecf1;border-radius:20px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,.04);transition:all .35s ease;position:relative;display:flex;flex-direction:column}
.pm-card:hover{transform:translateY(-6px);box-shadow:0 16px 40px rgba(124,58,237,.12);border-color:rgba(124,58,237,.25)}
.pm-card__img{height:140px;display:flex;align-items:center;justify-content:center;font-size:3.5rem;background:linear-gradient(135deg,#f5f3ff,#ede9fe);position:relative;overflow:hidden;flex-shrink:0}
.pm-card__img::after{content:"";position:absolute;bottom:0;left:0;right:0;height:50%;background:linear-gradient(to top,rgba(255,255,255,.4),transparent);pointer-events:none}
.pm-card__cat{position:absolute;top:10px;left:10px;padding:3px 11px;border-radius:999px;font-size:.7rem;font-weight:600;color:#fff;z-index:2;letter-spacing:.02em}
.pm-card__stock{position:absolute;top:10px;right:10px;font-size:.68rem;color:#94a3b8;z-index:2;padding:2px 9px;border-radius:999px;background:rgba(255,255,255,.8);backdrop-filter:blur(4px)}
.pm-card__stock--low{color:#ef4444;background:rgba(254,226,226,.9)}
.pm-card__body{padding:14px 16px 16px;display:flex;flex-direction:column;flex:1}
.pm-card__name{font-family:var(--fs);font-size:1rem;font-weight:600;color:#1a1d23;margin:0 0 5px;line-height:1.35}
.pm-card__desc{font-size:.8rem;color:#94a3b8;line-height:1.5;margin:0 0 12px;flex:1}
.pm-card__foot{display:flex;align-items:center;justify-content:space-between;margin-top:auto}
.pm-card__cost{display:flex;align-items:center;gap:5px;font-family:var(--fm);font-size:1.05rem;font-weight:700;color:#7c3aed}
.pm-card__costicon{font-size:1.1rem}
.pm-card__cost--insuf{color:#ef4444}
.pm-card__btn{padding:8px 22px;border-radius:10px;border:0;cursor:pointer;font-size:.84rem;font-weight:600;color:#fff;background:linear-gradient(135deg,#7c3aed,#a855f7);transition:all .25s;white-space:nowrap;box-shadow:0 3px 12px rgba(124,58,237,.25)}
.pm-card__btn:hover:not(:disabled){transform:translateY(-1px);box-shadow:0 6px 20px rgba(124,58,237,.4)}
.pm-card__btn:active:not(:disabled){transform:scale(.95)}
.pm-card__btn:disabled{background:#e2e8f0;box-shadow:none;color:#94a3b8;cursor:not-allowed}

/* ===== Exchange Modal ===== */
.pm-overlay{position:fixed;inset:0;z-index:10000;background:rgba(0,0,0,.5);display:flex;align-items:center;justify-content:center;animation:pmFadeIn .3s ease}
@keyframes pmFadeIn{from{opacity:0}to{opacity:1}}
.pm-modal{width:min(440px,92vw);max-height:85vh;background:#fff;border-radius:24px;overflow:hidden;position:relative;animation:pmSlideUp .35s ease;display:flex;flex-direction:column}
@keyframes pmSlideUp{from{opacity:0;transform:translateY(40px)}to{opacity:1;transform:translateY(0)}}
.pm-modal__close{position:absolute;top:14px;right:14px;z-index:10;width:32px;height:32px;border-radius:10px;border:1px solid #e2e8f0;background:#fff;color:#64748b;font-size:1.1rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .25s}
.pm-modal__close:hover{background:#fef2f2;border-color:#fca5a5;color:#ef4444}
.pm-modal__img{height:160px;display:flex;align-items:center;justify-content:center;font-size:5rem;background:linear-gradient(135deg,#f5f3ff,#ede9fe)}
.pm-modal__body{padding:20px 24px 24px;flex:1;overflow-y:auto}
.pm-modal__cat{display:inline-block;padding:3px 11px;border-radius:999px;font-size:.72rem;font-weight:600;color:#fff;margin-bottom:8px;letter-spacing:.02em}
.pm-modal__name{font-family:var(--fs);font-size:1.2rem;font-weight:700;color:#1a1d23;margin:0 0 6px}
.pm-modal__desc{font-size:.86rem;color:#6b7280;line-height:1.65;margin:0 0 14px}
.pm-modal__info{display:flex;gap:16px;flex-wrap:wrap;margin-bottom:18px}
.pm-modal__infoitem{display:flex;align-items:center;gap:5px;font-size:.84rem;color:#64748b}
.pm-modal__infoitem strong{color:#7c3aed;font-family:var(--fm)}
.pm-modal__infoitem--warn strong{color:#ef4444}
.pm-modal__infoitem--green strong{color:#27ae60}
.pm-modal__acts{display:flex;gap:10px}
.pm-modal__btn{padding:11px 28px;border-radius:12px;border:0;cursor:pointer;font-size:.9rem;font-weight:600;transition:all .25s;flex:1}
.pm-modal__btn--confirm{background:linear-gradient(135deg,#7c3aed,#a855f7);color:#fff;box-shadow:0 3px 12px rgba(124,58,237,.25)}
.pm-modal__btn--confirm:hover{box-shadow:0 6px 20px rgba(124,58,237,.4);transform:translateY(-1px)}
.pm-modal__btn--cancel{background:#f1f5f9;color:#64748b;border:1px solid #e2e8f0}
.pm-modal__btn--cancel:hover{background:#e8ecf1}

/* Toast */
.pm-toast{position:fixed;top:24px;left:50%;transform:translateX(-50%);z-index:99999;padding:12px 24px;border-radius:14px;font-size:.9rem;font-weight:600;box-shadow:0 6px 24px rgba(0,0,0,.15);display:flex;align-items:center;gap:10px;animation:pmToastIn .4s ease,pmToastOut .4s ease 2s forwards;pointer-events:none}
.pm-toast--success{background:linear-gradient(135deg,#27ae60,#2ecc71);color:#fff}
.pm-toast--error{background:linear-gradient(135deg,#ef4444,#f87171);color:#fff}
@keyframes pmToastIn{from{opacity:0;transform:translateX(-50%) translateY(-20px)}to{opacity:1;transform:translateX(-50%) translateY(0)}}
@keyframes pmToastOut{from{opacity:1;transform:translateX(-50%) translateY(0)}to{opacity:0;transform:translateX(-50%) translateY(-20px)}}

/* ===== Orders Section ===== */
.pm-orders{background:#fafbfc;border-top:1px solid #e8ecf1;border-bottom:1px solid #e8ecf1}
.pm-orders__inner{padding:36px 0}
.pm-orders__hd{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px;gap:14px;flex-wrap:wrap}
.pm-orders__title{font-family:var(--fs);font-size:1.3rem;font-weight:700;color:#1a1d23;margin:0}
.pm-orders__count{font-family:var(--fm);font-size:.9rem;font-weight:500;color:#7c3aed;margin-left:8px}
.pm-orders__list{display:flex;flex-direction:column;gap:12px;max-height:480px;overflow-y:auto;padding-right:4px}
.pm-orders__empty{text-align:center;padding:50px 0;color:#94a3b8}
.pm-orders__emptyicon{font-size:3rem;margin-bottom:10px;opacity:.5}
.pm-orders__emptyt{font-family:var(--fs);font-size:1.05rem;color:#6b7280;margin:0 0 4px}

/* Order item */
.pm-order{display:flex;align-items:center;gap:14px;padding:14px 18px;border-radius:16px;background:#fff;border:1px solid #e8ecf1;transition:all .25s}
.pm-order:hover{border-color:rgba(124,58,237,.2);box-shadow:0 4px 16px rgba(0,0,0,.04)}
.pm-order__img{width:48px;height:48px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.6rem;background:#f5f3ff;flex-shrink:0}
.pm-order__info{flex:1;min-width:0}
.pm-order__name{font-weight:600;font-size:.92rem;color:#1a1d23;margin-bottom:2px}
.pm-order__meta{font-size:.76rem;color:#94a3b8;display:flex;gap:10px;flex-wrap:wrap}
.pm-order__pts{font-family:var(--fm);font-size:.9rem;font-weight:700;color:#7c3aed;white-space:nowrap;flex-shrink:0}

/* ===== Points Rules ===== */
.pm-rules{padding:48px 0}
.pm-rules__title{font-family:var(--fs);font-size:1.3rem;font-weight:700;color:#1a1d23;margin:0 0 6px}
.pm-rules__sub{color:#6b7280;max-width:560px;line-height:1.7;margin:0 0 28px}
.pm-rules__grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}
.pm-rule{display:flex;align-items:center;gap:14px;padding:18px;border-radius:16px;border:1px solid #e8ecf1;background:#fff;transition:all .3s ease}
.pm-rule:hover{transform:translateY(-3px);border-color:rgba(124,58,237,.2);box-shadow:0 8px 24px rgba(124,58,237,.08)}
.pm-rule__icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.4rem;flex-shrink:0}
.pm-rule__info{min-width:0}
.pm-rule__name{font-weight:600;font-size:.88rem;color:#1a1d23;margin-bottom:2px}
.pm-rule__pts{font-family:var(--fm);font-size:.8rem;font-weight:700}
.pm-rule__note{font-size:.72rem;color:#94a3b8}

/* ===== Responsive ===== */
@media(max-width:960px){
  .pm-grid--cols3{grid-template-columns:repeat(2,1fr)}
  .pm-rules__grid{grid-template-columns:repeat(2,1fr)}
  .pm-levels__grid{grid-template-columns:repeat(2,1fr)}
  .pm-hero__row{flex-direction:column;align-items:flex-start}
  .pm-calendar-strip{flex-direction:column;align-items:flex-start}
}
@media(max-width:640px){
  .pm-grid--cols3{grid-template-columns:1fr}
  .pm-rules__grid{grid-template-columns:1fr}
  .pm-levels__grid{grid-template-columns:1fr}
  .pm-hero{padding:44px 0 36px}
  .pm-filter__inner{flex-direction:column;align-items:flex-start}
  .pm-searchbar{flex-direction:column;align-items:stretch}
  .pm-balance{width:100%;justify-content:center}
  .pm-stats-row{flex-direction:column}
  .pm-stat-card{min-width:auto}
}
</style>
</head>
<body data-page="pointsmall">
<div class="page-shell">
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<main class="page-main">

<!-- ===== Hero / Banner ===== -->
<section class="pm-hero">
  <div class="pm-hero__grid"></div>
  <div class="pm-hero__orb1"></div>
  <div class="pm-hero__orb2"></div>
  <div class="container">
    <p class="pm-hero__bread"><a href="${pageContext.request.contextPath}/index.jsp">首页</a> / 积分商城</p>
    <h1 class="pm-hero__h1">积分商城</h1>
    <p class="pm-hero__sub">用志愿积分兑换专属奖励，每一份付出都值得被铭记。签到、参与活动、发表动态都能积累积分。</p>
    <div class="pm-hero__row">
      <!-- Points Balance Card -->
      <div class="pm-balance" id="pmBalance">
        <span class="pm-balance__icon">⭐</span>
        <div class="pm-balance__info">
          <span class="pm-balance__pts" id="pmPtsTotal">0</span>
          <span class="pm-balance__label">可用积分</span>
        </div>
        <span class="pm-balance__level" id="pmLevelBadge">
          <span class="pm-balance__leveldot"></span>
          <span id="pmLevelText">新星志愿者</span>
        </span>
      </div>
      <!-- Check-in Button -->
      <button class="pm-checkin" id="pmCheckinBtn" onclick="handleCheckin()">
        <span>📅</span> <span id="pmCheckinLabel">每日签到 +5</span>
      </button>
    </div>

    <!-- ===== 1. Check-in Calendar Strip ===== -->
    <div class="pm-calendar-strip" id="pmCalendarStrip">
      <span class="pm-calendar-strip__label">签到打卡</span>
      <div class="pm-calendar-strip__days" id="pmCweekDays"></div>
      <span class="pm-calendar-strip__streak" id="pmStreakBadge" style="display:none;">🔥 连签 <strong id="pmStreakCount">0</strong> 天</span>
    </div>

    <!-- ===== 2. Points Stats Row ===== -->
    <div class="pm-stats-row">
      <div class="pm-stat-card">
        <div class="pm-stat-card__icon" style="background:#f0fdf4;color:#27ae60;">📈</div>
        <div class="pm-stat-card__info">
          <span class="pm-stat-card__val" id="pmStatEarned">0</span>
          <span class="pm-stat-card__lbl">累计获得积分</span>
        </div>
      </div>
      <div class="pm-stat-card">
        <div class="pm-stat-card__icon" style="background:#fef2f2;color:#ef4444;">🎁</div>
        <div class="pm-stat-card__info">
          <span class="pm-stat-card__val" id="pmStatSpent">0</span>
          <span class="pm-stat-card__lbl">累计消费积分</span>
        </div>
      </div>
      <div class="pm-stat-card">
        <div class="pm-stat-card__icon" style="background:#eff6ff;color:#3b82f6;">📅</div>
        <div class="pm-stat-card__info">
          <span class="pm-stat-card__val" id="pmStatMonth">0</span>
          <span class="pm-stat-card__lbl">本月收入</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===== Category Filter Tabs ===== -->
<section class="pm-filter">
  <div class="container">
    <!-- ===== 3. Search & Sort Bar ===== -->
    <div class="pm-searchbar">
      <input type="text" class="pm-searchbar__input" id="pmSearchInput" placeholder="搜索商品..." autocomplete="off">
      <select class="pm-searchbar__sort" id="pmSortSelect">
        <option value="default">默认</option>
        <option value="points-asc">积分从低到高</option>
        <option value="points-desc">积分从高到低</option>
        <option value="popular">最受欢迎</option>
      </select>
    </div>
    <div class="pm-filter__inner">
      <div class="pm-filter__tabs" id="pmFilterTabs">
        <button class="pm-filter__tab is-active" data-pm-cat="全部">全部<span class="pm-filter__tab-count" id="pmCatCntAll">0</span></button>
      </div>
      <div class="pm-filter__right">
        <button class="pm-filter__wishlist" id="pmWishlistToggle" data-pm-wish="0">
          <span>💗</span> 心愿单 <span class="pm-filter__wishlist-badge" id="pmWishlistCount">0</span>
        </button>
        <button class="pm-filter__toggle" id="pmViewToggle" data-pm-view="mall">商品列表</button>
        <button class="pm-filter__toggle" id="pmOrdersToggle" data-pm-view="orders">兑换记录</button>
        <button class="pm-filter__toggle" id="pmDetailToggle" data-pm-view="detail">积分明细</button>
      </div>
    </div>
  </div>
</section>

<!-- ===== 4. Hot Recommendations ===== -->
<section class="pm-hot" id="pmHotSection">
  <div class="container">
    <div class="pm-hot__hd">
      <span class="pm-hot__title-emoji">🔥</span>
      <h2 class="pm-hot__title">热门推荐</h2>
    </div>
    <div class="pm-hot__row" id="pmHotRow"></div>
  </div>
</section>

<!-- ===== 5. Exchange Activity Marquee ===== -->
<div class="pm-marquee-wrap" id="pmMarqueeWrap" style="display:none;">
  <div class="container">
    <div class="pm-marquee__hd">
      <span style="font-size:1.1rem;">📡</span>
      <h3 class="pm-marquee__title">兑换动态</h3>
    </div>
  </div>
  <div class="pm-marquee__track" id="pmMarqueeTrack"></div>
</div>

<!-- ===== Product Grid Section ===== -->
<section class="section" id="pmMallSection">
  <div class="container">
    <div class="pm-grid pm-grid--cols3" id="pmProductGrid"></div>
    <div class="ae" id="pmEmpty" style="display:none;">
      <div class="ae__icon">🛍</div>
      <h3 class="ae__t">暂无该分类商品</h3>
      <p>试试切换其他分类或赚取更多积分</p>
    </div>
  </div>
</section>

<!-- ===== 6. Points Detail Panel ===== -->
<section class="section" id="pmDetailSection" style="display:none;">
  <div class="container">
    <div class="pm-detail-panel" id="pmDetailPanel"></div>
  </div>
</section>

<!-- ===== My Orders Section ===== -->
<section class="pm-orders" id="pmOrdersSection" style="display:none;">
  <div class="container">
    <div class="pm-orders__inner">
      <div class="pm-orders__hd">
        <h2 class="pm-orders__title">我的兑换记录<span class="pm-orders__count" id="pmOrdersCount">0</span></h2>
      </div>
      <div class="pm-orders__list" id="pmOrdersList"></div>
      <div class="pm-orders__empty" id="pmOrdersEmpty">
        <div class="pm-orders__emptyicon">📦</div>
        <h3 class="pm-orders__emptyt">还没有兑换记录</h3>
        <p style="color:#94a3b8;font-size:.84rem;">去商品列表挑选心仪的奖励吧</p>
      </div>
    </div>
  </div>
</section>

<!-- ===== 7. Level Benefits ===== -->
<section class="pm-levels" id="pmLevelsSection">
  <div class="container">
    <div class="pm-levels__hd">
      <h2 class="pm-levels__title">🏅 等级权益</h2>
      <p class="pm-levels__sub">不断提升志愿者等级，解锁更多专属权益和福利</p>
    </div>
    <div class="pm-levels__grid" id="pmLevelsGrid"></div>
  </div>
</section>

<!-- ===== Points Rules ===== -->
<section class="pm-rules" id="pmRulesSection">
  <div class="container">
    <h2 class="pm-rules__title">积分获取规则</h2>
    <p class="pm-rules__sub">多种方式积累志愿积分，每一次参与都有回报</p>
    <div class="pm-rules__grid" id="pmRulesGrid"></div>
  </div>
</section>

</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</div>

<!-- ===== Exchange Confirmation Modal ===== -->
<div class="pm-overlay" id="pmModalOverlay" style="display:none;">
  <div class="pm-modal" id="pmModal">
    <button class="pm-modal__close" id="pmModalClose">&times;</button>
    <div class="pm-modal__img" id="pmModalImg"></div>
    <div class="pm-modal__body">
      <span class="pm-modal__cat" id="pmModalCat"></span>
      <h3 class="pm-modal__name" id="pmModalName"></h3>
      <p class="pm-modal__desc" id="pmModalDesc"></p>
      <div class="pm-modal__info">
        <span class="pm-modal__infoitem">所需积分 <strong id="pmModalPts">0</strong></span>
        <span class="pm-modal__infoitem" id="pmModalStockItem">库存 <strong id="pmModalStock">0</strong></span>
        <span class="pm-modal__infoitem pm-modal__infoitem--green">我的积分 <strong id="pmModalMyPts">0</strong></span>
      </div>
      <div class="pm-modal__acts">
        <button class="pm-modal__btn pm-modal__btn--cancel" id="pmModalCancel">取消</button>
        <button class="pm-modal__btn pm-modal__btn--confirm" id="pmModalConfirm">确认兑换</button>
      </div>
    </div>
  </div>
</div>

<script>window.APP_CONTEXT_PATH="${pageContext.request.contextPath}";window.APP_USER_ROLE="<%=displayRole%>";window.APP_USER_NAME="<%=displayName%>"</script>
<script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/data.js"></script>
<script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/points.js"></script>
<script>
(function(){
  var ctx = window.APP_CONTEXT_PATH || '.';
  var allItems = [];
  var mallCats = ['全部'];
  var activeCat = '全部';
  var currentView = 'mall'; // 'mall' | 'orders' | 'detail'
  var selectedItem = null;
  var searchQuery = '';
  var sortMode = 'default';
  var showWishlistOnly = false;

  /* ===== NEW: Supporting Data Functions ===== */

  /* Wishlist storage */
  var WISHLIST_KEY = 'volstar_wishlist';
  function getWishlist(){ try{ var d=localStorage.getItem(WISHLIST_KEY); return d?JSON.parse(d):[] }catch(e){return[]} }
  function saveWishlist(w){ try{ localStorage.setItem(WISHLIST_KEY,JSON.stringify(w)) }catch(e){} }

  /* 1. Check-in week data - returns array of 7 objects for last 7 days */
  window.getCheckinWeekData = function(){
    var result = [];
    var STORAGE_KEY = 'volstar_checkin_date';
    var today = new Date();
    for (var i = 6; i >= 0; i--) {
      var d = new Date(today);
      d.setDate(d.getDate() - i);
      var dateStr = d.getFullYear() + '-' + (d.getMonth()+1) + '-' + d.getDate();
      var dayOfWeek = d.getDay(); // 0=Sun, 6=Sat
      var isBonus = (dayOfWeek === 0 || dayOfWeek === 6); // weekends are bonus
      var checkedIn = false;
      try {
        var stored = localStorage.getItem(STORAGE_KEY);
        checkedIn = (stored === dateStr);
      } catch(e) {}
      // Also check if this date appears in points history as a check-in
      if (!checkedIn) {
        var s = null;
        try { var ds=localStorage.getItem('volstar_points'); s=ds?JSON.parse(ds):null; } catch(e){}
        if (s && s.history) {
          for (var j = s.history.length - 1; j >= 0; j--) {
            var h = s.history[j];
            if (h.reason && h.reason.indexOf('签到') >= 0) {
              var hDate = new Date(h.time);
              var hDateStr = hDate.getFullYear() + '-' + (hDate.getMonth()+1) + '-' + hDate.getDate();
              if (hDateStr === dateStr) { checkedIn = true; break; }
            }
          }
        }
      }
      result.push({
        date: dateStr,
        dayLabel: ['日','一','二','三','四','五','六'][dayOfWeek],
        checkedIn: checkedIn,
        isToday: i === 0,
        isBonus: isBonus && checkedIn
      });
    }
    return result;
  };

  /* 2. Check-in streak */
  window.getCheckinStreak = function(){
    var weekData = window.getCheckinWeekData();
    var streak = 0;
    // Count consecutive checked-in days from today backwards
    for (var i = weekData.length - 1; i >= 0; i--) {
      if (weekData[i].checkedIn) streak++;
      else break;
    }
    return streak;
  };

  /* 3. Points earned this month */
  window.getPointsEarnedThisMonth = function(){
    var s = null;
    try { var ds=localStorage.getItem('volstar_points'); s=ds?JSON.parse(ds):null; } catch(e){}
    if (!s || !s.history) return 0;
    var now = new Date();
    var thisMonth = now.getMonth();
    var thisYear = now.getFullYear();
    var total = 0;
    for (var i = 0; i < s.history.length; i++) {
      var h = s.history[i];
      if (h.amount > 0) {
        var hDate = new Date(h.time);
        if (hDate.getFullYear() === thisYear && hDate.getMonth() === thisMonth) {
          total += h.amount;
        }
      }
    }
    return total;
  };

  /* 4. Wishlist toggle */
  window.toggleWishlist = function(itemId){
    var w = getWishlist();
    var idx = w.indexOf(itemId);
    if (idx >= 0) {
      w.splice(idx, 1);
    } else {
      w.push(itemId);
    }
    saveWishlist(w);
    return { wishlisted: idx < 0, count: w.length };
  };

  /* 5. Recent exchanges data (simulated with real order data + preset users) */
  window.recentExchanges = (function(){
    var preset = [
      {user:'张明远',initial:'张',item:'志愿之星限定徽章',points:100,time:new Date(Date.now()-60000)},
      {user:'李思涵',initial:'李',item:'优先报名特权（7天）',points:200,time:new Date(Date.now()-180000)},
      {user:'王浩然',initial:'王',item:'志愿服务马甲',points:350,time:new Date(Date.now()-420000)},
      {user:'刘雨桐',initial:'刘',item:'电子感谢证书',points:80,time:new Date(Date.now()-720000)},
      {user:'赵晓东',initial:'赵',item:'环保帆布袋',points:180,time:new Date(Date.now()-1080000)},
      {user:'黄静怡',initial:'黄',item:'定制保温杯',points:500,time:new Date(Date.now()-1800000)},
      {user:'杨柳青',initial:'杨',item:'志愿时长加倍卡',points:150,time:new Date(Date.now()-3000000)},
      {user:'陈志强',initial:'陈',item:'专属头像框（30天）',points:60,time:new Date(Date.now()-4200000)},
    ];
    var avColors = ['#7c3aed','#27ae60','#e67e22','#2980b9','#16a085','#d35400','#8e44ad','#e74c3c'];
    for (var i = 0; i < preset.length; i++) {
      preset[i].avColor = avColors[i % avColors.length];
    }
    return preset;
  })();

  /* 6. All points history */
  window.getAllPointsHistory = function(){
    var s = null;
    try { var ds=localStorage.getItem('volstar_points'); s=ds?JSON.parse(ds):null; } catch(e){}
    if (!s || !s.history) return [];
    // Return a copy, newest first
    return s.history.slice().reverse();
  };

  /* 7. Level benefits */
  window.getLevelBenefits = function(){
    return [
      {
        level: 1, name: '新星志愿者', reqPoints: '>= 0',
        gradient: 'linear-gradient(135deg,#27ae60,#2ecc71)',
        borderColor: '#27ae60', iconBg: '#27ae60', icon: '⭐',
        benefits: ['每日签到基础积分 +5', '参与活动获取积分', '浏览积分商城']
      },
      {
        level: 2, name: '青铜志愿者', reqPoints: '>= 200',
        gradient: 'linear-gradient(135deg,#d97706,#f59e0b)',
        borderColor: '#d97706', iconBg: '#d97706', icon: '🥉',
        benefits: ['签到积分 +8', '活动积分 1.1倍', '专属青铜徽章']
      },
      {
        level: 3, name: '白银志愿者', reqPoints: '>= 500',
        gradient: 'linear-gradient(135deg,#9ca3af,#b0b7c3)',
        borderColor: '#9ca3af', iconBg: '#9ca3af', icon: '🥈',
        benefits: ['签到积分 +10', '活动积分 1.2倍', '白银专属头像框', '热门活动优先报名']
      },
      {
        level: 4, name: '黄金志愿者', reqPoints: '>= 1000',
        gradient: 'linear-gradient(135deg,#f59e0b,#fbbf24)',
        borderColor: '#f59e0b', iconBg: '#f59e0b', icon: '🥇',
        benefits: ['签到积分 +15', '活动积分 1.3倍', '黄金专属套装', '商城兑换 9.5折']
      },
      {
        level: 5, name: '钻石志愿者', reqPoints: '>= 1500',
        gradient: 'linear-gradient(135deg,#7c3aed,#a855f7)',
        borderColor: '#7c3aed', iconBg: '#7c3aed', icon: '💎',
        benefits: ['签到积分 +20', '活动积分 1.5倍', '钻石专属身份标识', '商城兑换 9折', '发起活动权限']
      },
      {
        level: 6, name: '传奇志愿者', reqPoints: '>= 2000',
        gradient: 'linear-gradient(135deg,#e74c3c,#ec4899)',
        borderColor: '#e74c3c', iconBg: '#e74c3c', icon: '👑',
        benefits: ['签到积分 +30', '活动积分 2倍', '传奇专属全套权益', '商城兑换 8折', '专属客服通道', '荣誉展示首页推荐']
      }
    ];
  };

  /* ===== Helpers ===== */
  function esc(s){ return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

  /* Get filtered + sorted + searched items */
  function getFilteredItems(){
    var items = allItems.slice();

    // Category filter
    if (activeCat !== '全部') {
      items = items.filter(function(item){ return item.category === activeCat; });
    }

    // Search filter
    if (searchQuery.trim()) {
      var q = searchQuery.trim().toLowerCase();
      items = items.filter(function(item){
        return (item.name && item.name.toLowerCase().indexOf(q) >= 0) ||
               (item.desc && item.desc.toLowerCase().indexOf(q) >= 0);
      });
    }

    // Wishlist filter
    if (showWishlistOnly) {
      var w = getWishlist();
      items = items.filter(function(item){ return w.indexOf(item.id) >= 0; });
    }

    // Sort
    switch (sortMode) {
      case 'points-asc':
        items.sort(function(a,b){ return a.points - b.points; });
        break;
      case 'points-desc':
        items.sort(function(a,b){ return b.points - a.points; });
        break;
      case 'popular':
        // Use stock as a rough popularity proxy (lower stock = more popular / more redeemed)
        items.sort(function(a,b){
          var popA = (a.stock !== undefined) ? (9999 - a.stock) : 0;
          var popB = (b.stock !== undefined) ? (9999 - b.stock) : 0;
          return popB - popA;
        });
        break;
      default:
        break;
    }

    return items;
  }

  /* Check if item is wishlisted */
  function isWishlisted(itemId){
    return getWishlist().indexOf(itemId) >= 0;
  }

  /* Category colors */
  function catColor(cat){
    var map = {'数字徽章':'#7c3aed','权益卡':'#f59e0b','实物周边':'#27ae60'};
    return map[cat] || '#7c3aed';
  }

  /* ===== Render Functions ===== */

  /* 1. Render check-in calendar */
  function renderCalendar(){
    var weekData = window.getCheckinWeekData();
    var streak = window.getCheckinStreak();
    var daysEl = document.getElementById('pmCweekDays');
    var streakBadge = document.getElementById('pmStreakBadge');
    var streakCount = document.getElementById('pmStreakCount');

    var html = '';
    for (var i = 0; i < weekData.length; i++) {
      var d = weekData[i];
      var cls = 'pm-cday';
      var inner = '<span>' + d.dayLabel + '</span>';
      if (d.checkedIn) {
        cls += d.isBonus ? ' pm-cday--bonus' : ' pm-cday--checked';
        inner = '<span>' + (d.isBonus ? '★' : '✓') + '</span>';
        if (d.isToday) cls += ' pm-cday--today';
      } else {
        cls += ' pm-cday--pending';
        if (d.isToday) cls += ' pm-cday--today';
      }
      html += '<div class="' + cls + '" title="' + d.date + '">' + inner + '<span class="pm-cday__label">' + d.dayLabel + '</span></div>';
    }
    daysEl.innerHTML = html;

    if (streak >= 3) {
      streakBadge.style.display = '';
      streakCount.textContent = streak;
    } else {
      streakBadge.style.display = 'none';
    }
  }

  /* 2. Render points stats */
  function renderStats(){
    var s = null;
    try { var ds=localStorage.getItem('volstar_points'); s=ds?JSON.parse(ds):null; } catch(e){}
    var totalEarned = 0;
    var totalSpent = 0;
    if (s && s.history) {
      for (var i = 0; i < s.history.length; i++) {
        var h = s.history[i];
        if (h.amount > 0) totalEarned += h.amount;
        else if (h.amount < 0) totalSpent += Math.abs(h.amount);
      }
    }
    var monthEarned = window.getPointsEarnedThisMonth();

    var elE = document.getElementById('pmStatEarned');
    var elS = document.getElementById('pmStatSpent');
    var elM = document.getElementById('pmStatMonth');
    if (elE) elE.textContent = totalEarned;
    if (elS) elS.textContent = totalSpent;
    if (elM) elM.textContent = monthEarned;
  }

  /* Render points balance */
  function renderBalance(){
    var pts = window.getUserPoints ? window.getUserPoints() : 0;
    var level = window.getUserLevel ? window.getUserLevel() : '新星志愿者';
    var color = window.getUserLevelColor ? window.getUserLevelColor() : '#27ae60';

    var el = document.getElementById('pmPtsTotal');
    if (el) el.textContent = pts;

    var lb = document.getElementById('pmLevelBadge');
    if (lb){
      var dot = lb.querySelector('.pm-balance__leveldot');
      if (dot) dot.style.background = color;
    }

    var lt = document.getElementById('pmLevelText');
    if (lt) lt.textContent = level;

    /* Update check-in button */
    var ciBtn = document.getElementById('pmCheckinBtn');
    var ciLabel = document.getElementById('pmCheckinLabel');
    if (ciBtn && ciLabel){
      if (window.canCheckin && window.canCheckin()){
        ciBtn.disabled = false;
        ciLabel.textContent = '每日签到 +5';
      } else {
        ciBtn.disabled = true;
        ciLabel.textContent = '今日已签到';
      }
    }
  }

  /* Render category filter tabs */
  function renderCatTabs(){
    var cnts = {};
    allItems.forEach(function(item){
      var c = item.category || '';
      cnts[c] = (cnts[c] || 0) + 1;
    });

    var html = '';
    for (var i = 0; i < mallCats.length; i++){
      var c = mallCats[i];
      var isA = c === activeCat;
      var cnt = c === '全部' ? allItems.length : (cnts[c] || 0);
      html += '<button class="pm-filter__tab' + (isA ? ' is-active' : '') + '" data-pm-cat="' + esc(c) + '">' + esc(c) + '<span class="pm-filter__tab-count">' + cnt + '</span></button>';
    }
    document.getElementById('pmFilterTabs').innerHTML = html;

    /* Update view toggle buttons */
    var mallBtn = document.getElementById('pmViewToggle');
    var ordersBtn = document.getElementById('pmOrdersToggle');
    var detailBtn = document.getElementById('pmDetailToggle');
    if (mallBtn) mallBtn.classList.toggle('is-active', currentView === 'mall');
    if (ordersBtn) ordersBtn.classList.toggle('is-active', currentView === 'orders');
    if (detailBtn) detailBtn.classList.toggle('is-active', currentView === 'detail');

    /* Update wishlist toggle */
    var wBtn = document.getElementById('pmWishlistToggle');
    var wCnt = document.getElementById('pmWishlistCount');
    if (wCnt) {
      var wl = getWishlist();
      wCnt.textContent = wl.length;
    }
    if (wBtn) {
      wBtn.classList.toggle('is-active', showWishlistOnly);
    }
  }

  /* 4. Render hot recommendations (first 4 items) */
  function renderHotRecs(){
    var hot = allItems.slice(0, 4);
    var row = document.getElementById('pmHotRow');
    var html = '';
    for (var i = 0; i < hot.length; i++) {
      var item = hot[i];
      var col = catColor(item.category);
      html += '<article class="pm-hot-card" data-hot-id="' + item.id + '">' +
        '<span class="pm-hot-card__badge">热推</span>' +
        '<div class="pm-hot-card__img"><span>' + esc(item.image || '🎁') + '</span></div>' +
        '<div class="pm-hot-card__body">' +
          '<h3 class="pm-hot-card__name">' + esc(item.name) + '</h3>' +
          '<div class="pm-hot-card__foot">' +
            '<span class="pm-hot-card__cost"><span>⭐</span>' + item.points + '</span>' +
            '<span class="pm-hot-card__cat" style="background:' + col + '">' + esc(item.category) + '</span>' +
          '</div>' +
        '</div>' +
      '</article>';
    }
    row.innerHTML = html;

    /* Bind click */
    row.querySelectorAll('.pm-hot-card').forEach(function(card){
      card.addEventListener('click', function(){
        var id = Number(card.getAttribute('data-hot-id'));
        var item = null;
        for (var j = 0; j < allItems.length; j++){
          if (allItems[j].id === id){ item = allItems[j]; break; }
        }
        if (item) openExchangeModal(item);
      });
    });
  }

  /* 5. Render exchange marquee */
  function renderMarquee(){
    var data = window.recentExchanges || [];
    if (data.length === 0) {
      document.getElementById('pmMarqueeWrap').style.display = 'none';
      return;
    }
    document.getElementById('pmMarqueeWrap').style.display = '';

    var track = document.getElementById('pmMarqueeTrack');
    var html = '';
    /* Duplicate for seamless looping */
    for (var pass = 0; pass < 2; pass++) {
      for (var i = 0; i < data.length; i++) {
        var e = data[i];
        var timeStr = '';
        var diff = Date.now() - (new Date(e.time)).getTime();
        if (diff < 60000) timeStr = '刚刚';
        else if (diff < 3600000) timeStr = Math.floor(diff / 60000) + '分钟前';
        else timeStr = Math.floor(diff / 3600000) + '小时前';
        html += '<div class="pm-marq-pill">' +
          '<div class="pm-marq-pill__avatar" style="background:' + e.avColor + '">' + esc(e.initial) + '</div>' +
          '<div class="pm-marq-pill__info">' +
            '<span class="pm-marq-pill__name">' + esc(e.user) + ' 兑换了 ' + esc(e.item) + '</span>' +
          '</div>' +
          '<span class="pm-marq-pill__pts">-' + e.points + '⭐</span>' +
          '<span class="pm-marq-pill__time">' + timeStr + '</span>' +
        '</div>';
      }
    }
    track.innerHTML = html;
  }

  /* 6. Render points detail panel */
  function renderPointsDetail(){
    var history = window.getAllPointsHistory();
    var panel = document.getElementById('pmDetailPanel');

    if (!history || history.length === 0) {
      panel.innerHTML = '<div class="pm-detail__empty"><div style="font-size:3rem;margin-bottom:10px;opacity:.5;">📋</div><h3 style="font-family:var(--fs);font-size:1.05rem;color:#6b7280;margin:0 0 4px;">暂无积分变动记录</h3><p style="color:#94a3b8;font-size:.84rem;">参与活动或签到开始积累积分吧</p></div>';
      return;
    }

    var html = '';
    for (var i = 0; i < history.length; i++) {
      var h = history[i];
      var isEarn = h.amount > 0;
      var iconHtml = isEarn
        ? '<div class="pm-detail__icon" style="background:#f0fdf4;color:#27ae60;">⬆</div>'
        : '<div class="pm-detail__icon" style="background:#fef2f2;color:#ef4444;">⬇</div>';
      var amountHtml = isEarn
        ? '<span class="pm-detail__amount pm-detail__amount--earn">+' + h.amount + '</span>'
        : '<span class="pm-detail__amount pm-detail__amount--spend">' + h.amount + '</span>';

      var dateStr = '';
      try {
        var d = new Date(h.time);
        dateStr = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0') + ' ' +
                  String(d.getHours()).padStart(2,'0') + ':' + String(d.getMinutes()).padStart(2,'0');
      } catch(e) { dateStr = h.time || ''; }

      html += '<div class="pm-detail__item">' +
        iconHtml +
        '<div class="pm-detail__info">' +
          '<div class="pm-detail__reason">' + esc(h.reason || (isEarn ? '积分收入' : '积分支出')) + '</div>' +
          '<div class="pm-detail__date">' + dateStr + '</div>' +
        '</div>' +
        amountHtml +
      '</div>';
    }
    panel.innerHTML = html;
  }

  /* 7. Render level benefits */
  function renderLevelBenefits(){
    var benefits = window.getLevelBenefits();
    var currentLvl = window.getUserLevelNum ? window.getUserLevelNum() : 1;
    var grid = document.getElementById('pmLevelsGrid');
    var html = '';
    for (var i = 0; i < benefits.length; i++) {
      var b = benefits[i];
      var isCurrent = b.level === currentLvl;
      var cardStyle = 'border-color:' + b.borderColor + ';';
      var badgeHtml = isCurrent ? '<span class="pm-lvl-card__badge">当前等级</span>' : '';

      html += '<div class="pm-lvl-card' + (isCurrent ? ' is-current' : '') + '" style="' + cardStyle + '">' +
        badgeHtml +
        '<div class="pm-lvl-card__header">' +
          '<div class="pm-lvl-card__icon" style="background:' + b.iconBg + '">' + b.icon + '</div>' +
          '<span class="pm-lvl-card__name">' + b.name + '</span>' +
          '<span class="pm-lvl-card__req" style="background:' + b.borderColor + '15;color:' + b.borderColor + '">' + b.reqPoints + '</span>' +
        '</div>' +
        '<ul class="pm-lvl-card__benefits">';
      for (var j = 0; j < b.benefits.length; j++) {
        html += '<li style="color:#374151">' + b.benefits[j] + '</li>';
      }
      html += '</ul></div>';
    }
    grid.innerHTML = html;

    /* Apply benefit dot colors */
    grid.querySelectorAll('.pm-lvl-card').forEach(function(card, idx){
      var dots = card.querySelectorAll('.pm-lvl-card__benefits li::before');
      // Color is handled by the benefit items directly via inline style on parent
    });
  }

  /* Render product cards */
  function renderProductCard(item){
    var col = catColor(item.category);
    var pts = window.getUserPoints ? window.getUserPoints() : 0;
    var canAfford = pts >= item.points;
    var inStock = item.stock === undefined || item.stock > 0;
    var isDisabled = !canAfford || !inStock;
    var costCls = canAfford ? '' : ' pm-card__cost--insuf';
    var stockLow = item.stock !== undefined && item.stock <= 5;
    var stockCls = stockLow ? ' pm-card__stock--low' : '';
    var stockText = item.stock !== undefined ? (item.stock > 999 ? '999+' : '库存' + item.stock) : '不限量';
    var btnText = !inStock ? '已售罄' : (!canAfford ? '积分不足' : '立即兑换');
    var isWished = isWishlisted(item.id);
    var wishCls = isWished ? ' is-wished' : '';

    return '<article class="pm-card" data-item-id="' + item.id + '">' +
      '<div class="pm-card__img"><span>' + esc(item.image || '🎁') + '</span>' +
        '<span class="pm-card__cat" style="background:' + col + '">' + esc(item.category) + '</span>' +
        '<button class="pm-card__wish' + wishCls + '" data-wish-id="' + item.id + '" title="' + (isWished ? '取消心愿' : '加入心愿单') + '">' + (isWished ? '❤️' : '🤍') + '</button>' +
        '<span class="pm-card__stock' + stockCls + '">' + stockText + '</span>' +
      '</div>' +
      '<div class="pm-card__body">' +
        '<h3 class="pm-card__name">' + esc(item.name) + '</h3>' +
        '<p class="pm-card__desc">' + esc(item.desc || '') + '</p>' +
        '<div class="pm-card__foot">' +
          '<span class="pm-card__cost' + costCls + '"><span class="pm-card__costicon">⭐</span>' + item.points + '</span>' +
          '<button class="pm-card__btn" ' + (isDisabled ? 'disabled' : '') + ' data-exch="' + item.id + '">' + btnText + '</button>' +
        '</div>' +
      '</div>' +
    '</article>';
  }

  function renderProducts(){
    var items = getFilteredItems();
    var grid = document.getElementById('pmProductGrid');
    var empty = document.getElementById('pmEmpty');

    if (items.length === 0){
      grid.innerHTML = '';
      empty.style.display = '';
      return;
    }

    empty.style.display = 'none';
    var html = '';
    for (var i = 0; i < items.length; i++){
      html += renderProductCard(items[i]);
    }
    grid.innerHTML = html;

    /* Bind exchange button clicks */
    grid.querySelectorAll('[data-exch]').forEach(function(btn){
      btn.addEventListener('click', function(e){
        e.stopPropagation();
        var id = Number(btn.getAttribute('data-exch'));
        var item = null;
        for (var j = 0; j < allItems.length; j++){
          if (allItems[j].id === id){ item = allItems[j]; break; }
        }
        if (item) openExchangeModal(item);
      });
    });

    /* Bind wishlist toggle */
    grid.querySelectorAll('[data-wish-id]').forEach(function(btn){
      btn.addEventListener('click', function(e){
        e.stopPropagation();
        var id = Number(btn.getAttribute('data-wish-id'));
        var result = window.toggleWishlist(id);
        if (result.wishlisted) {
          btn.classList.add('is-wished');
          btn.innerHTML = '❤️';
          btn.title = '取消心愿';
        } else {
          btn.classList.remove('is-wished');
          btn.innerHTML = '🤍';
          btn.title = '加入心愿单';
        }
        // If in wishlist-only mode and un-wished, re-render
        if (showWishlistOnly) {
          renderProducts();
        }
        renderCatTabs();
      });
    });
  }

  /* ===== Exchange Modal ===== */
  function openExchangeModal(item){
    selectedItem = item;
    var col = catColor(item.category);
    var pts = window.getUserPoints ? window.getUserPoints() : 0;

    document.getElementById('pmModalImg').textContent = item.image || '🎁';
    document.getElementById('pmModalCat').textContent = item.category;
    document.getElementById('pmModalCat').style.background = col;
    document.getElementById('pmModalName').textContent = item.name;
    document.getElementById('pmModalDesc').textContent = item.desc || '';
    document.getElementById('pmModalPts').textContent = item.points;
    document.getElementById('pmModalMyPts').textContent = pts;

    var stockEl = document.getElementById('pmModalStockItem');
    var stockTxt = document.getElementById('pmModalStock');
    if (item.stock !== undefined){
      stockEl.style.display = '';
      stockTxt.textContent = item.stock;
    } else {
      stockEl.style.display = 'none';
    }

    /* Update confirm button */
    var confirmBtn = document.getElementById('pmModalConfirm');
    var canAfford = pts >= item.points;
    var inStock = item.stock === undefined || item.stock > 0;
    if (!inStock){
      confirmBtn.textContent = '已售罄';
      confirmBtn.disabled = true;
      confirmBtn.style.opacity = '.5';
    } else if (!canAfford){
      confirmBtn.textContent = '积分不足（差' + (item.points - pts) + '）';
      confirmBtn.disabled = true;
      confirmBtn.style.opacity = '.5';
    } else {
      confirmBtn.textContent = '确认兑换';
      confirmBtn.disabled = false;
      confirmBtn.style.opacity = '1';
    }

    document.getElementById('pmModalOverlay').style.display = 'flex';
  }

  function closeExchangeModal(){
    document.getElementById('pmModalOverlay').style.display = 'none';
    selectedItem = null;
  }

  function confirmExchange(){
    if (!selectedItem) return;
    if (!window.redeemItem){
      showToast('兑换功能暂不可用', 'error');
      return;
    }
    var result = window.redeemItem(selectedItem);
    if (result.success){
      closeExchangeModal();
      showToast(result.msg, 'success');
      refreshUI();
    } else {
      showToast(result.msg, 'error');
      closeExchangeModal();
    }
  }

  /* ===== Orders List ===== */
  function renderOrders(){
    var orders = window.getUserOrders ? window.getUserOrders() : [];
    var listEl = document.getElementById('pmOrdersList');
    var emptyEl = document.getElementById('pmOrdersEmpty');
    var cntEl = document.getElementById('pmOrdersCount');

    cntEl.textContent = orders.length;

    if (orders.length === 0){
      listEl.innerHTML = '';
      emptyEl.style.display = '';
      return;
    }

    emptyEl.style.display = 'none';
    var html = '';
    for (var i = orders.length - 1; i >= 0; i--){
      var o = orders[i];
      var timeStr = '';
      try {
        var d = new Date(o.time);
        timeStr = d.getFullYear() + '-' + (d.getMonth()+1) + '-' + d.getDate() + ' ' +
                  String(d.getHours()).padStart(2,'0') + ':' + String(d.getMinutes()).padStart(2,'0');
      } catch(e){ timeStr = o.time || ''; }

      html += '<div class="pm-order">' +
        '<div class="pm-order__img">' + esc(o.image || '🎁') + '</div>' +
        '<div class="pm-order__info">' +
          '<div class="pm-order__name">' + esc(o.itemName) + '</div>' +
          '<div class="pm-order__meta">' +
            '<span>订单号：' + (o.id || '') + '</span>' +
            '<span>' + timeStr + '</span>' +
          '</div>' +
        '</div>' +
        '<span class="pm-order__pts">-' + (o.points || 0) + ' ⭐</span>' +
      '</div>';
    }
    listEl.innerHTML = html;
  }

  /* ===== Points Rules ===== */
  function renderRules(){
    var cfg = (window.VolunteerStarData && window.VolunteerStarData.pointsConfig) ? window.VolunteerStarData.pointsConfig : {};
    var rules = [
      { icon: '📅', name: '每日签到', pts: cfg.checkIn || 5, note: '每日首次签到', color: '#f0fdf4', iconBg: '#27ae60' },
      { icon: '📝', name: '发布活动', pts: cfg.publishActivity || 20, note: '发起并审核通过', color: '#fef3c7', iconBg: '#f59e0b' },
      { icon: '✅', name: '完成活动', pts: cfg.completeActivity || 50, note: '完整参与并签到', color: '#e0f2fe', iconBg: '#3b82f6' },
      { icon: '🌍', name: '发表动态', pts: cfg.postTopic || 10, note: '在志愿星球发帖', color: '#ede9fe', iconBg: '#7c3aed' },
      { icon: '❤️', name: '获得点赞', pts: cfg.postLiked || 2, note: '动态被点赞', color: '#fce7f3', iconBg: '#ec4899' },
      { icon: '💬', name: '获得评论', pts: cfg.postCommented || 3, note: '动态被评论', color: '#f0fdf4', iconBg: '#22c55e' },
      { icon: '📤', name: '分享动态', pts: cfg.sharePost || 1, note: '分享志愿故事', color: '#fff7ed', iconBg: '#f97316' }
    ];

    var grid = document.getElementById('pmRulesGrid');
    var html = '';
    for (var i = 0; i < rules.length; i++){
      var r = rules[i];
      html += '<div class="pm-rule">' +
        '<div class="pm-rule__icon" style="background:' + r.color + ';color:' + r.iconBg + '">' + r.icon + '</div>' +
        '<div class="pm-rule__info">' +
          '<div class="pm-rule__name">' + r.name + '</div>' +
          '<div class="pm-rule__pts" style="color:' + r.iconBg + '">+' + r.pts + ' 积分</div>' +
          '<div class="pm-rule__note">' + r.note + '</div>' +
        '</div>' +
      '</div>';
    }
    grid.innerHTML = html;
  }

  /* ===== Toast ===== */
  function showToast(msg, type){
    var existing = document.querySelector('.pm-toast');
    if (existing) existing.remove();
    var toast = document.createElement('div');
    toast.className = 'pm-toast pm-toast--' + (type === 'error' ? 'error' : 'success');
    toast.textContent = msg;
    document.body.appendChild(toast);
    setTimeout(function(){ if (toast.parentNode) toast.remove(); }, 2400);
  }

  /* ===== Check-in Handler ===== */
  window.handleCheckin = function(){
    if (!window.doCheckin) return;
    var result = window.doCheckin();
    if (result){
      showToast('签到成功！+5 积分', 'success');
      refreshUI();
    } else {
      showToast('今日已签到，明天再来吧', 'error');
    }
  };

  /* Switch view */
  function switchView(view){
    currentView = view;
    showWishlistOnly = false;
    var mallSec = document.getElementById('pmMallSection');
    var ordersSec = document.getElementById('pmOrdersSection');
    var rulesSec = document.getElementById('pmRulesSection');
    var hotSec = document.getElementById('pmHotSection');
    var detailSec = document.getElementById('pmDetailSection');
    var levelsSec = document.getElementById('pmLevelsSection');
    var marqueeWrap = document.getElementById('pmMarqueeWrap');

    if (view === 'orders'){
      if (mallSec) mallSec.style.display = 'none';
      if (ordersSec) ordersSec.style.display = '';
      if (rulesSec) rulesSec.style.display = 'none';
      if (hotSec) hotSec.style.display = 'none';
      if (detailSec) detailSec.style.display = 'none';
      if (levelsSec) levelsSec.style.display = '';
      if (marqueeWrap) marqueeWrap.style.display = 'none';
      renderOrders();
    } else if (view === 'detail'){
      if (mallSec) mallSec.style.display = 'none';
      if (ordersSec) ordersSec.style.display = 'none';
      if (rulesSec) rulesSec.style.display = 'none';
      if (hotSec) hotSec.style.display = 'none';
      if (detailSec) detailSec.style.display = '';
      if (levelsSec) levelsSec.style.display = '';
      if (marqueeWrap) marqueeWrap.style.display = 'none';
      renderPointsDetail();
    } else {
      if (mallSec) mallSec.style.display = '';
      if (ordersSec) ordersSec.style.display = 'none';
      if (rulesSec) rulesSec.style.display = '';
      if (hotSec) hotSec.style.display = '';
      if (detailSec) detailSec.style.display = 'none';
      if (levelsSec) levelsSec.style.display = '';
      if (marqueeWrap) marqueeWrap.style.display = '';
      renderProducts();
      renderHotRecs();
      renderMarquee();
    }
    renderCatTabs();
  }

  /* ===== Refresh All ===== */
  function refreshUI(){
    renderBalance();
    renderCalendar();
    renderStats();
    renderCatTabs();
    renderLevelBenefits();
    if (currentView === 'mall'){
      renderProducts();
      renderHotRecs();
      renderMarquee();
    } else if (currentView === 'detail'){
      renderPointsDetail();
    } else {
      renderOrders();
    }
  }

  /* ===== Event Bindings ===== */
  function bindEvents(){
    /* Search input */
    var searchInput = document.getElementById('pmSearchInput');
    if (searchInput) {
      searchInput.addEventListener('input', function(){
        searchQuery = this.value;
        if (currentView !== 'mall') switchView('mall');
        else renderProducts();
      });
    }

    /* Sort dropdown */
    var sortSelect = document.getElementById('pmSortSelect');
    if (sortSelect) {
      sortSelect.addEventListener('change', function(){
        sortMode = this.value;
        if (currentView !== 'mall') switchView('mall');
        else renderProducts();
      });
    }

    /* Wishlist toggle button */
    var wishlistBtn = document.getElementById('pmWishlistToggle');
    if (wishlistBtn) {
      wishlistBtn.addEventListener('click', function(){
        showWishlistOnly = !showWishlistOnly;
        if (currentView !== 'mall') switchView('mall');
        else { renderProducts(); renderCatTabs(); }
      });
    }

    /* Category filter tabs */
    var tabsEl = document.getElementById('pmFilterTabs');
    if (tabsEl){
      tabsEl.addEventListener('click', function(e){
        var tab = e.target.closest('[data-pm-cat]');
        if (!tab) return;
        activeCat = tab.getAttribute('data-pm-cat');
        switchView('mall');
      });
    }

    /* View toggle - mall */
    var mallToggle = document.getElementById('pmViewToggle');
    if (mallToggle){
      mallToggle.addEventListener('click', function(){ switchView('mall'); });
    }

    /* View toggle - orders */
    var ordersToggle = document.getElementById('pmOrdersToggle');
    if (ordersToggle){
      ordersToggle.addEventListener('click', function(){ switchView('orders'); });
    }

    /* View toggle - detail */
    var detailToggle = document.getElementById('pmDetailToggle');
    if (detailToggle){
      detailToggle.addEventListener('click', function(){ switchView('detail'); });
    }

    /* Modal close */
    var modalClose = document.getElementById('pmModalClose');
    if (modalClose){
      modalClose.addEventListener('click', closeExchangeModal);
    }

    /* Modal overlay click */
    var modalOverlay = document.getElementById('pmModalOverlay');
    if (modalOverlay){
      modalOverlay.addEventListener('click', function(e){
        if (e.target === modalOverlay) closeExchangeModal();
      });
    }

    /* Modal cancel */
    var modalCancel = document.getElementById('pmModalCancel');
    if (modalCancel){
      modalCancel.addEventListener('click', closeExchangeModal);
    }

    /* Modal confirm */
    var modalConfirm = document.getElementById('pmModalConfirm');
    if (modalConfirm){
      modalConfirm.addEventListener('click', confirmExchange);
    }

    /* Listen for pointsUpdated custom event */
    window.addEventListener('pointsUpdated', function(e){
      renderBalance();
      renderCalendar();
      renderStats();
      renderLevelBenefits();
      if (currentView === 'mall'){
        renderProducts();
      }
    });
  }

  /* ===== Init ===== */
  /* ===== 内置兜底数据 ===== */
  var FALLBACK_ITEMS = [
    {id:1,name:"志愿之星限定徽章",points:100,category:"数字徽章",stock:999,image:"🏅",desc:"专属数字徽章，点亮你的个人主页，彰显志愿荣耀"},
    {id:2,name:"优先报名特权（7天）",points:200,category:"权益卡",stock:50,image:"🎫",desc:"热门活动优先报名通道，再也不用担心名额被抢光"},
    {id:3,name:"志愿服务马甲",points:350,category:"实物周边",stock:30,image:"👕",desc:"志愿星河定制款反光马甲，活动必备，安全又醒目"},
    {id:4,name:"志愿时长加倍卡",points:150,category:"权益卡",stock:100,image:"⚡",desc:"使用后下次活动服务时长翻倍计算，助力快速升级"},
    {id:5,name:"定制保温杯",points:500,category:"实物周边",stock:20,image:"☕",desc:"志愿星河联名不锈钢保温杯，500ml大容量"},
    {id:6,name:"环保帆布袋",points:180,category:"实物周边",stock:60,image:"🛍",desc:"志愿星河原创设计环保帆布袋，日常出行百搭"},
    {id:7,name:"线下培训名额",points:300,category:"权益卡",stock:15,image:"📚",desc:"专业志愿服务培训课程名额，提升你的服务技能"},
    {id:8,name:"电子感谢证书",points:80,category:"数字徽章",stock:999,image:"📜",desc:"精美电子证书，记录你的公益贡献，可分享至社交平台"},
    {id:9,name:"活动组织者权限",points:600,category:"权益卡",stock:10,image:"👑",desc:"获得发起活动权限，成为志愿活动的组织者和引领者"},
    {id:10,name:"志愿星河纪念徽章盒",points:800,category:"实物周边",stock:10,image:"🎁",desc:"含5枚实体徽章的限定礼盒，每枚代表一种志愿精神"},
    {id:11,name:"办公文具套装",points:120,category:"实物周边",stock:40,image:"✏",desc:"志愿星河定制款笔记本+签字笔套装，记录志愿点滴"},
    {id:12,name:"专属头像框（30天）",points:60,category:"数字徽章",stock:999,image:"🖼",desc:"限时专属头像框装饰，在志愿星球中脱颖而出"}
  ];

  var FALLBACK_POINTS_CONFIG = {checkIn:5,publishActivity:20,completeActivity:50,postTopic:10,postLiked:2,postCommented:3,sharePost:1};

  function loadData(){
    /* 优先使用 data.js 中的数据 */
    if (window.VolunteerStarData && window.VolunteerStarData.mallItems && window.VolunteerStarData.mallItems.length > 0){
      allItems = window.VolunteerStarData.mallItems;
      /* 同时补全 pointsConfig */
      if (!window.VolunteerStarData.pointsConfig){
        window.VolunteerStarData.pointsConfig = FALLBACK_POINTS_CONFIG;
      }
      return true;
    }
    /* 兜底：使用内置数据 */
    allItems = FALLBACK_ITEMS;
    if (!window.VolunteerStarData) window.VolunteerStarData = {};
    window.VolunteerStarData.mallItems = FALLBACK_ITEMS;
    window.VolunteerStarData.pointsConfig = FALLBACK_POINTS_CONFIG;
    return false;
  }

  function init(){
    var loaded = loadData();
    if (!loaded){
      console.warn('积分商城：data.js 中 mallItems 数据缺失，已启用内置兜底数据。请检查 assets/js/data.js 是否正确加载。');
    }

    /* Build category list */
    var catSet = {};
    catSet['全部'] = true;
    for (var i = 0; i < allItems.length; i++){
      catSet[allItems[i].category] = true;
    }
    mallCats = Object.keys(catSet);

    bindEvents();
    renderBalance();
    renderCalendar();
    renderStats();
    renderRules();
    renderLevelBenefits();
    renderCatTabs();
    renderProducts();
    renderHotRecs();
    renderMarquee();
  }

  /* DOM ready 后初始化，确保外部脚本已执行完毕 */
  function ready(fn){
    if (document.readyState === 'loading'){
      document.addEventListener('DOMContentLoaded', fn);
    } else {
      fn();
    }
  }
  ready(init);
})();
</script>
</body>
</html>

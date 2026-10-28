<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.volunteerstar.pojo.User" %>
<%
  User loginUser = (User) session.getAttribute("loginUser");
  String displayRole = loginUser == null ? "" : loginUser.getRole();
  String displayName = loginUser == null ? "" : loginUser.getNickname();
  request.setAttribute("currentPage", "activities");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>志愿星河 - 活动中心</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
<style>
:root{--c-green:#27AE60;--c-purple:#7c3aed;--c-purple2:#a855f7;--fs:'Noto Serif SC','SimSun',serif;--fm:'Roboto Mono','Consolas',monospace}
*{-webkit-tap-highlight-color:transparent}

/* Hero */
.ah{background:linear-gradient(180deg,#fff 0%,#f0fdf4 35%,#e8f5f0 65%,#dcefe6 100%);padding:64px 0 48px;position:relative;overflow:hidden;border-bottom:1px solid #e8ecf1}
.ah::before,.ah::after{content:"";position:absolute;border-radius:50%;pointer-events:none}
.ah::before{top:-100px;right:-120px;width:420px;height:420px;background:radial-gradient(circle,rgba(39,174,96,.12),transparent 65%)}
.ah::after{bottom:-80px;left:-100px;width:360px;height:360px;background:radial-gradient(circle,rgba(91,155,213,.08),transparent 65%)}
.ah__grid{position:absolute;inset:0;pointer-events:none;background-image:linear-gradient(rgba(39,174,96,.03)1px,transparent 1px),linear-gradient(90deg,rgba(39,174,96,.03)1px,transparent 1px);background-size:50px 50px;z-index:0}
.ah__orb1{position:absolute;top:15%;right:25%;width:200px;height:200px;border-radius:50%;background:radial-gradient(circle,rgba(240,193,75,.1),transparent 70%);filter:blur(40px);pointer-events:none;z-index:0;animation:ahOrb1 10s ease-in-out infinite}
.ah__orb2{position:absolute;bottom:20%;left:30%;width:160px;height:160px;border-radius:50%;background:radial-gradient(circle,rgba(155,126,217,.08),transparent 70%);filter:blur(35px);pointer-events:none;z-index:0;animation:ahOrb2 12s ease-in-out infinite reverse}
@keyframes ahOrb1{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(30px,-20px)scale(1.15)}}
@keyframes ahOrb2{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(-25px,15px)scale(1.12)}}
.ah__decor{position:absolute;width:80px;height:80px;border-radius:50%;border:1px solid rgba(39,174,96,.08);pointer-events:none;z-index:0;animation:ahSpin 25s linear infinite}
.ah__decor:nth-child(6){top:10%;right:15%;width:70px;height:70px}
.ah__decor:nth-child(7){bottom:10%;left:12%;width:90px;height:90px;animation-duration:30s;animation-direction:reverse}
@keyframes ahSpin{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}
.ah__bread{font-size:.84rem;color:#9ca3af;margin-bottom:6px;position:relative;z-index:1}
.ah__bread a{color:#27AE60}
.ah__h1{font-family:var(--fs);font-size:clamp(1.8rem,3.5vw,2.6rem);font-weight:700;color:#1a1d23;margin:0 0 8px;position:relative;z-index:1}
.ah__sub{color:#6b7280;max-width:560px;line-height:1.7;position:relative;z-index:1}
.ah__search{max-width:480px;margin-top:20px;position:relative;z-index:1}
.ah__search-wrap{position:relative}
.ah__search-input{width:100%;height:48px;padding:0 48px 0 18px;border-radius:12px;border:2px solid #e2e8f0;background:#fff;font-size:.92rem;outline:none;transition:all .25s}
.ah__search-input:focus{border-color:#27AE60;box-shadow:0 0 0 4px rgba(39,174,96,.08)}
.ah__search-input::placeholder{color:#cbd5e1}
.ah__search-icon{position:absolute;right:16px;top:50%;transform:translateY(-50%);color:#94a3b8;font-size:1.1rem;pointer-events:none}

/* Quick stats */
.ah-stats{display:flex;gap:24px;margin-top:28px;position:relative;z-index:1;flex-wrap:wrap}
.ah-stat{display:flex;align-items:center;gap:10px;padding:8px 16px;border-radius:999px;background:rgba(39,174,96,.06);border:1px solid rgba(39,174,96,.12);font-size:.84rem;color:#374151}
.ah-stat__icon{font-size:1.1rem}
.ah-stat strong{color:#27AE60;font-family:var(--fm)}

/* Sticky filter */
.af{position:sticky;top:64px;z-index:40;background:rgba(255,255,255,.95);backdrop-filter:blur(12px);border-bottom:1px solid #e8ecf1}
.af__inner{display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap;padding:12px 0}
.af__pills{display:flex;gap:6px;flex-wrap:wrap}
.af__pill{border:0;background:#f1f5f9;color:#64748b;padding:6px 14px;border-radius:999px;cursor:pointer;font-size:.84rem;transition:all .25s;white-space:nowrap}
.af__pill:hover{background:#e8f5e9;color:#27AE60}
.af__pill.is-active{background:#27AE60;color:#fff;box-shadow:0 3px 12px rgba(39,174,96,.28)}
.af__pill--count{font-size:.72rem;opacity:.7;margin-left:2px}
.af__right{display:flex;align-items:center;gap:10px;flex-shrink:0}
.af__select{min-height:38px;border-radius:10px;border:1px solid #e2e8f0;background:#fff;color:#374151;padding:0 32px 0 14px;font-size:.86rem;cursor:pointer;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 12px center;outline:none}
.af__view{display:flex;border:1px solid #e2e8f0;border-radius:10px;overflow:hidden}
.af__vbtn{width:38px;height:36px;border:0;background:#fff;color:#94a3b8;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .25s}
.af__vbtn:not(:last-child){border-right:1px solid #e2e8f0}
.af__vbtn.is-active{background:#27AE60;color:#fff}.af__vbtn svg{width:17px;height:17px}

/* Stats bar */
.as{padding:16px 0;border-bottom:1px solid #f1f5f9}
.as__inner{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px}
.as__cnt{font-family:var(--fm);font-size:1rem;font-weight:600;color:#1a1d23}
.as__cnt strong{color:#27AE60;font-size:1.2rem}
.as__tag{display:inline-flex;align-items:center;gap:4px;padding:3px 12px;border-radius:999px;font-size:.76rem;background:rgba(39,174,96,.08);color:#27AE60;margin-left:6px;cursor:default}
.as__tag button{border:0;background:none;color:#27AE60;cursor:pointer;font-size:1rem;padding:0;margin-left:2px;opacity:.5;line-height:1}

/* Grid & cards */
.ag{display:grid;gap:22px}.ag--grid{grid-template-columns:repeat(3,1fr)}.ag--list{grid-template-columns:1fr}
.ac{background:#fff;border:1px solid #e8ecf1;border-radius:20px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,.04);transition:all .35s ease;position:relative}
.ac:hover{transform:translateY(-6px);box-shadow:0 16px 40px rgba(39,174,96,.12);border-color:rgba(39,174,96,.25)}
.ac__img{position:relative;height:180px;overflow:hidden}
.ac__img img{width:100%;height:100%;object-fit:cover;transition:transform .5s ease}
.ac:hover .ac__img img{transform:scale(1.06)}
.ac__gradient{position:absolute;bottom:0;left:0;right:0;height:60%;background:linear-gradient(to top,rgba(0,0,0,.5),transparent);pointer-events:none}
.ac__badge{position:absolute;top:12px;left:12px;padding:4px 12px;border-radius:999px;font-size:.72rem;font-weight:600;color:#fff;letter-spacing:.02em;z-index:2}
.ac__status{position:absolute;top:12px;right:12px;z-index:2}
.ac__stag{display:inline-block;padding:4px 12px;border-radius:999px;font-size:.72rem;font-weight:600}
.ac__stag--r{background:rgba(39,174,96,.14);color:#219a52}.ac__stag--f{background:rgba(232,99,75,.12);color:#d14334}.ac__stag--u{background:rgba(91,155,213,.12);color:#3e7eb8}
.ac__bookmark{position:absolute;bottom:8px;right:8px;z-index:5;width:30px;height:30px;border-radius:50%;background:rgba(255,255,255,.85);border:0;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.9rem;transition:all .25s;box-shadow:0 2px 8px rgba(0,0,0,.1)}
.ac__bookmark:hover{background:#fff;transform:scale(1.1)}.ac__bookmark.is-bm{color:#e91e63}
.ac__body{padding:16px 18px}
.ac__cat{font-size:.76rem;font-weight:600;margin-bottom:6px;display:block}
.ac__title{font-family:var(--fs);font-size:1.05rem;font-weight:600;color:#1a1d23;margin:0 0 8px;line-height:1.35;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
.ac__meta{display:flex;flex-direction:column;gap:4px;font-size:.82rem;color:#94a3b8;margin-bottom:10px}
.ac__meta span{display:flex;align-items:center;gap:5px}
.ac__prog{margin-top:4px}.ac__prh{display:flex;justify-content:space-between;font-size:.74rem;margin-bottom:5px}
.ac__prl{color:#94a3b8}.ac__prc{font-family:var(--fm);color:#27AE60;font-weight:500}.ac__prc--hi{color:#ef4444}
.ac__prt{height:5px;border-radius:999px;background:#e8ecf1;overflow:hidden}
.ac__prf{height:100%;border-radius:999px;background:linear-gradient(90deg,#27ae60,#2ecc71)}.ac__prf--hi{background:linear-gradient(90deg,#ef4444,#f87171)}

/* Pagination */
.ap{display:flex;align-items:center;justify-content:center;gap:5px;padding:40px 0 0;flex-wrap:wrap}
.ap__b{min-width:38px;height:38px;border-radius:10px;border:1px solid #e2e8f0;background:#fff;color:#374151;font-size:.88rem;cursor:pointer;display:inline-flex;align-items:center;justify-content:center;transition:all .25s;font-family:var(--fm);padding:0 10px}
.ap__b:hover:not(:disabled){border-color:#27AE60;color:#27AE60}
.ap__b.is-act{background:#27AE60;border-color:#27AE60;color:#fff;box-shadow:0 3px 10px rgba(39,174,96,.25)}
.ap__b:disabled{opacity:.3;cursor:not-allowed}
.ap__dot{width:38px;height:38px;display:flex;align-items:center;justify-content:center;color:#94a3b8}

/* CTA */
.acta{text-align:center;padding:60px 0 0;margin-top:52px;border-top:1px solid #ededed}
.acta__t{font-family:var(--fs);font-size:1.5rem;font-weight:600;color:#1a1d23;margin:0 0 8px}
.acta__s{color:#6b7280;max-width:480px;margin:0 auto 22px;line-height:1.7}
.acta__acts{display:flex;align-items:center;justify-content:center;gap:12px;flex-wrap:wrap}

/* Empty */
.ae{text-align:center;padding:80px 0;color:#94a3b8;grid-column:1/-1}
.ae__icon{font-size:3.5rem;margin-bottom:14px;opacity:.5}
.ae__t{font-family:var(--fs);font-size:1.2rem;color:#1a1d23;margin:0 0 6px}

/* ===== Smart Match ===== */
.sm-fab{position:fixed;bottom:28px;right:28px;width:58px;height:58px;border-radius:50%;background:linear-gradient(135deg,#7c3aed,#a855f7);border:0;cursor:pointer;display:flex;align-items:center;justify-content:center;z-index:9999;box-shadow:0 4px 24px rgba(124,58,237,.45);transition:all .3s ease;animation:smPulse 2.4s ease-in-out infinite}
.sm-fab:hover{transform:scale(1.14);box-shadow:0 6px 32px rgba(124,58,237,.6)}
.sm-fab:active{transform:scale(.93)}
.sm-fab__icon{color:#fff;font-size:1.5rem;font-weight:700;line-height:1}
@keyframes smPulse{0%,100%{box-shadow:0 4px 24px rgba(124,58,237,.45)}50%{box-shadow:0 4px 40px rgba(124,58,237,.7)}}
.sm-overlay{position:fixed;inset:0;z-index:10000;background:rgba(0,0,0,.55);display:flex;align-items:center;justify-content:center;animation:smFadeIn .3s ease}
@keyframes smFadeIn{from{opacity:0}to{opacity:1}}
.sm-modal{width:min(580px,94vw);max-height:80vh;background:#fff;border-radius:24px;overflow-y:auto;position:relative;animation:smSlideUp .35s ease}
@keyframes smSlideUp{from{opacity:0;transform:translateY(40px)}to{opacity:1;transform:translateY(0)}}
.sm-modal--wide{width:min(920px,96vw)}
.sm-close{position:absolute;top:16px;right:16px;z-index:10;width:34px;height:34px;border-radius:10px;border:1px solid #e2e8f0;background:#fff;color:#64748b;font-size:1.2rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .25s}
.sm-close:hover{background:#fef2f2;border-color:#fca5a5;color:#ef4444}
.sm-steps{display:flex;align-items:center;justify-content:center;gap:0;padding:28px 40px 16px}
.sm-sdot{width:32px;height:32px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.82rem;font-weight:700;flex-shrink:0;background:#e8ecf1;color:#94a3b8;transition:all .4s}
.sm-sdot--done{background:#a855f7;color:#fff}.sm-sdot--active{background:#7c3aed;color:#fff;box-shadow:0 0 0 6px rgba(124,58,237,.15)}
.sm-sline{flex:1;height:2px;background:#e8ecf1;transition:all .4s;margin:0 4px}.sm-sline--done{background:#a855f7}
.sm-title{padding:0 32px;font-family:var(--fs);font-size:1.15rem;font-weight:600;color:#1a1d23;margin:0 0 4px}
.sm-sub{padding:0 32px;font-size:.86rem;color:#6b7280;margin:0 0 20px}
.sm-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;padding:0 32px 28px}
.sm-card{padding:20px 16px;border-radius:16px;border:2px solid #e2e8f0;cursor:pointer;text-align:center;transition:all .3s ease;background:#fff}
.sm-card:hover{transform:translateY(-3px);border-color:#c4b5fd;box-shadow:0 8px 24px rgba(124,58,237,.12)}
.sm-card.is-sel{border-color:#7c3aed;background:rgba(124,58,237,.04);box-shadow:0 0 0 4px rgba(124,58,237,.1)}
.sm-card__icon{font-size:2rem;display:block;margin-bottom:10px}
.sm-card__title{font-weight:600;font-size:.92rem;color:#1a1d23;margin-bottom:4px}
.sm-card__desc{font-size:.76rem;color:#94a3b8;line-height:1.4}

/* Result */
.sm-result{padding:24px 32px}
.sm-result__head{text-align:center;margin-bottom:24px}
.sm-result__icon{font-size:2.5rem;margin-bottom:8px}
.sm-result__title{font-family:var(--fs);font-size:1.2rem;font-weight:600;color:#1a1d23}
.sm-result__count{color:#7c3aed;font-weight:700}
.sm-result-acts{display:flex;flex-direction:column;gap:14px;max-height:50vh;overflow-y:auto;padding:4px 8px 4px 0}
.sm-result-acts .ac{display:flex;flex-direction:row;position:relative;min-height:120px}
.sm-result-acts .ac:hover{transform:none}
.sm-result-card{cursor:pointer;margin-bottom:2px!important}
.sm-result-card:hover{transform:translateX(4px)!important;border-color:#c4b5fd!important;box-shadow:0 4px 16px rgba(124,58,237,.15)!important}
.sm-result-acts .ac__img{width:180px;height:120px;flex-shrink:0;min-height:120px}
.sm-result-acts .ac__body{flex:1;display:flex;flex-direction:column;justify-content:center;min-width:0;overflow:hidden}
.sm-score{position:absolute;top:10px;right:10px;padding:5px 14px;border-radius:999px;font-size:.8rem;font-weight:700;color:#fff;z-index:3;background:linear-gradient(135deg,#7c3aed,#a855f7);box-shadow:0 3px 12px rgba(124,58,237,.35)}
.sm-result-acts .ac__status{position:static}.sm-result-acts .ac__badge{position:static;display:inline-block;margin-bottom:6px}
.sm-result-acts .ac__img{position:relative}.sm-result-acts .sm-score{position:absolute;top:8px;left:8px;right:auto}
.sm-rta{margin-top:20px;display:flex;gap:10px;justify-content:center;flex-wrap:wrap}
.sm-rta button{padding:10px 24px;border-radius:12px;font-size:.9rem;font-weight:600;cursor:pointer;transition:all .25s;border:0}
.sm-rta__retry{background:#f1f5f9;color:#374151;border:1px solid #e2e8f0}
.sm-rta__retry:hover{background:#e8ecf1}
.sm-rta__all{background:#7c3aed;color:#fff}
.sm-rta__all:hover{box-shadow:0 4px 16px rgba(124,58,237,.35)}

/* Hot activities horizontal scroll */
.hot-sec{position:fixed;top:140px;right:24px;width:200px;max-height:calc(100vh - 200px);z-index:999;background:#fff;border-radius:16px;border:1px solid #e8ecf1;box-shadow:0 4px 20px rgba(0,0,0,.06);overflow:hidden;display:flex;flex-direction:column}
.hot-sec__hd{padding:12px 14px 8px;border-bottom:1px solid #f1f5f9;flex-shrink:0}
.hot-sec__title{font-family:var(--fs);font-size:.9rem;font-weight:600;color:#1a1d23;margin:0}
.hot-sec__nav{display:none}
.hot-sec__arr{width:30px;height:30px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;color:#64748b;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.9rem;transition:all .25s}
.hot-sec__arr:hover{border-color:#27AE60;color:#27AE60;background:rgba(39,174,96,.05)}
.hot-sec__arr:disabled{opacity:.3;cursor:not-allowed}
.hot-sec__list{flex:1;overflow-y:auto;padding:6px 10px 10px;display:flex;flex-direction:column;gap:6px}
.hot-row{display:flex;flex-direction:column;gap:6px}
.hot-card{display:flex;align-items:center;gap:8px;border-radius:10px;background:#f9fafb;border:1px solid #e8ecf1;cursor:pointer;transition:all .3s ease;padding:8px}
.hot-card:hover{transform:translateX(3px);border-color:rgba(39,174,96,.3);background:#f0fdf4;box-shadow:0 2px 8px rgba(39,174,96,.08)}
.hot-card__img{width:36px;height:36px;border-radius:8px;overflow:hidden;flex-shrink:0}
.hot-card__img img{width:100%;height:100%;object-fit:cover}
.hot-card__body{flex:1;min-width:0;display:flex;flex-direction:column}
.hot-card__title{font-size:.76rem;font-weight:600;color:#1a1d23;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.hot-card__count{font-size:.68rem;color:#27AE60;font-family:var(--fm);font-weight:500}
@media(max-width:1300px){.hot-sec{display:none}}

/* Deadline bar */
.dl-bar{display:flex;align-items:center;justify-content:space-between;padding:12px 18px;border-radius:14px;background:linear-gradient(90deg,#fef9e7,#fef3c7);border:1px solid #fde68a;margin-bottom:20px;gap:12px;flex-wrap:wrap}
.dl-bar__info{display:flex;align-items:center;gap:8px;font-size:.88rem;color:#92400e}
.dl-bar__icon{font-size:1.2rem}
.dl-bar__cnt{font-family:var(--fm);font-weight:700;color:#d97706;font-size:1rem}
.dl-bar__link{padding:7px 18px;border-radius:999px;background:#d97706;color:#fff;font-size:.84rem;font-weight:600;text-decoration:none;transition:all .25s;white-space:nowrap}
.dl-bar__link:hover{background:#b45309;box-shadow:0 4px 12px rgba(217,119,6,.35)}

/* Responsive */
@media (max-width:960px){.ag--grid{grid-template-columns:repeat(2,1fr)}.af__inner{flex-direction:column;align-items:flex-start}.sm-grid{grid-template-columns:1fr}.sm-result-acts .ac{flex-direction:column!important}.sm-result-acts .ac__img{width:100%!important;height:140px;min-height:140px}.sm-result-acts .ac__body{overflow:visible}}@media (max-width:640px){.ag--grid{grid-template-columns:1fr}.ah{padding:44px 0 36px}.sm-fab{bottom:20px;right:20px;width:50px;height:50px}.sm-modal{border-radius:18px}.sm-grid{padding:0 16px 20px}.sm-title,.sm-sub{padding:0 16px}.sm-result-acts .ac__img{height:130px;min-height:130px}}

/* ===== Activity Detail Modal ===== */
.ad-overlay{position:fixed;inset:0;z-index:20000;background:rgba(0,0,0,.4);display:none;animation:smFadeIn .25s ease}
.ad-overlay.is-open{display:flex;align-items:center;justify-content:center;padding:20px}
.ad-modal{width:min(860px,96vw);max-height:90vh;background:#fff;border-radius:20px;overflow:hidden;display:flex;flex-direction:column;animation:smSlideUp .35s ease}
.ad-modal__header{position:relative;height:200px;flex-shrink:0}
.ad-modal__header img{width:100%;height:100%;object-fit:cover}
.ad-modal__header-overlay{position:absolute;inset:0;background:linear-gradient(180deg,rgba(0,0,0,.1),rgba(0,0,0,.7))}
.ad-modal__close{position:absolute;top:16px;right:16px;width:36px;height:36px;border-radius:50%;background:rgba(255,255,255,.9);border:0;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1rem;color:#1a1d23;transition:all .25s}
.ad-modal__close:hover{background:#fff;box-shadow:0 2px 12px rgba(0,0,0,.15)}
.ad-modal__badge{position:absolute;bottom:16px;left:16px;padding:6px 14px;border-radius:999px;font-size:.8rem;font-weight:600;color:#fff}
.ad-modal__body{flex:1;overflow-y:auto;padding:24px}
.ad-modal__title{font-size:1.4rem;font-weight:700;color:#1a1d23;margin:0 0 12px}
.ad-modal__meta{display:flex;flex-wrap:wrap;gap:16px;margin-bottom:20px;font-size:.9rem;color:#64748b}
.ad-modal__meta span{display:flex;align-items:center;gap:5px}
.ad-modal__desc{font-size:.96rem;color:#475569;line-height:1.8;margin-bottom:24px}
.ad-modal__stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
.ad-modal__stat{text-align:center;padding:16px;border-radius:12px;background:#f8fafc}
.ad-modal__stat--num{font-size:1.4rem;font-weight:700;color:#27AE60;font-family:var(--fm)}
.ad-modal__stat--label{font-size:.82rem;color:#94a3b8;margin-top:4px}
.ad-modal__footer{padding:20px 24px;border-top:1px solid #f1f5f9;display:flex;align-items:center;justify-content:flex-end;gap:12px;flex-shrink:0}
.ad-btn{padding:10px 28px;border-radius:10px;font-size:.9rem;font-weight:600;border:0;cursor:pointer;transition:all .25s}
.ad-btn--primary{background:#27AE60;color:#fff}
.ad-btn--primary:hover{background:#1e8449;box-shadow:0 4px 14px rgba(39,174,96,.35)}
.ad-btn--danger{background:#ef4444;color:#fff}
.ad-btn--danger:hover{background:#dc2626;box-shadow:0 4px 14px rgba(239,68,68,.35)}
.ad-btn--ghost{background:#f1f5f9;color:#64748b;border:1px solid #e2e8f0}
.ad-btn--ghost:hover{background:#e2e8f0}
.ad-btn:disabled{opacity:.5;cursor:not-allowed}
.ad-reg-status{padding:8px 16px;border-radius:8px;font-size:.88rem;font-weight:600}
.ad-reg-status--pending{background:#fef3c7;color:#d97706}
.ad-reg-status--approved{background:#dcfce7;color:#16a34a}
.ad-reg-status--finished{background:#e0e7ff;color:#4f46e5}
.ad-reg-status--cancelled{background:#fee2e2;color:#dc2626}

/* ===== Leaderboard ===== */
.lb-fab{position:fixed;bottom:100px;right:28px;width:58px;height:58px;border-radius:50%;background:linear-gradient(135deg,#f59e0b,#fbbf24);border:0;cursor:pointer;display:flex;align-items:center;justify-content:center;z-index:9999;box-shadow:0 4px 24px rgba(245,158,11,.45);transition:all .3s ease;animation:lbPulse 2.4s ease-in-out infinite}
.lb-fab:hover{transform:scale(1.14);box-shadow:0 6px 32px rgba(245,158,11,.6)}
.lb-fab:active{transform:scale(.93)}
.lb-fab__icon{color:#fff;font-size:1.5rem;line-height:1}
@keyframes lbPulse{0%,100%{box-shadow:0 4px 24px rgba(245,158,11,.45)}50%{box-shadow:0 4px 40px rgba(245,158,11,.7)}}
.lb-overlay{position:fixed;inset:0;z-index:10001;background:rgba(0,0,0,.35);display:none;animation:smFadeIn .25s ease}
.lb-overlay.is-open{display:block}
.lb-sidebar{position:fixed;top:0;right:0;width:360px;height:100vh;background:#fff;box-shadow:-4px 0 30px rgba(0,0,0,.12);z-index:10002;transform:translateX(100%);transition:transform .35s cubic-bezier(.4,0,.2,1);display:flex;flex-direction:column;overflow:hidden}
.lb-overlay.is-open .lb-sidebar{transform:translateX(0)}
.lb-sidebar__hd{display:flex;align-items:center;justify-content:space-between;padding:20px 24px;border-bottom:1px solid #f1f5f9;flex-shrink:0}
.lb-sidebar__title{font-family:var(--fs);font-size:1.1rem;font-weight:700;color:#1a1d23;margin:0}
.lb-sidebar__close{width:32px;height:32px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;color:#64748b;font-size:1.1rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .25s}
.lb-sidebar__close:hover{background:#fef2f2;border-color:#fca5a5;color:#ef4444}
.lb-sidebar__list{flex:1;overflow-y:auto;padding:8px 16px}
.lb-item{display:flex;align-items:center;gap:12px;padding:12px;border-radius:12px;margin-bottom:6px;transition:all .25s;background:#fff;border:1px solid transparent}
.lb-item:hover{background:#fafafa;border-color:#f1f5f9}
.lb-item--top1{background:linear-gradient(135deg,#fff9e6,#fff3cd);border-color:#ffe082}
.lb-item--top2{background:linear-gradient(135deg,#f8f9fa,#e9ecef);border-color:#ced4da}
.lb-item--top3{background:linear-gradient(135deg,#fff5f2,#ffe4d6);border-color:#ffccb3}
.lb-rank{width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:700;flex-shrink:0;background:#e8ecf1;color:#64748b}
.lb-rank--g{background:linear-gradient(135deg,#f59e0b,#fbbf24);color:#fff;box-shadow:0 2px 8px rgba(245,158,11,.35)}
.lb-rank--s{background:linear-gradient(135deg,#94a3b8,#cbd5e1);color:#fff;box-shadow:0 2px 8px rgba(148,163,184,.3)}
.lb-rank--b{background:linear-gradient(135deg,#d97706,#f59e0b);color:#fff;box-shadow:0 2px 8px rgba(217,119,6,.3)}
.lb-avatar{width:38px;height:38px;border-radius:50%;flex-shrink:0;display:flex;align-items:center;justify-content:center;font-weight:600;font-size:.82rem;color:#fff}
.lb-info{flex:1;min-width:0}
.lb-name{font-weight:600;font-size:.88rem;color:#1a1d23;margin-bottom:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.lb-stats{font-size:.76rem;color:#94a3b8;display:flex;gap:10px}
.lb-stats strong{color:#27AE60;font-family:var(--fm)}
.lb-sidebar__ft{padding:14px 24px;border-top:1px solid #f1f5f9;flex-shrink:0;text-align:center}
.lb-sidebar__more{color:#7c3aed;text-decoration:none;font-size:.86rem;font-weight:600;cursor:pointer;border:0;background:none;transition:all .25s}
.lb-sidebar__more:hover{color:#a855f7}
@media (max-width:640px){.lb-fab{bottom:85px;right:20px;width:50px;height:50px}.lb-sidebar{width:100vw}}
</style>
</head>
<body data-page="activities">
<div class="page-shell">
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<main class="page-main">

<!-- Hero -->
<section class="ah">
<div class="ah__grid"></div>
<div class="ah__orb1"></div><div class="ah__orb2"></div>
<div class="ah__decor" style="top:10%;right:15%;width:70px;height:70px;"></div>
<div class="ah__decor" style="bottom:10%;left:12%;width:90px;height:90px;"></div>
<div class="container">
<p class="ah__bread"><a href="${pageContext.request.contextPath}/index.jsp">首页</a> / 活动中心</p>
<h1 class="ah__h1">活动中心</h1>
<p class="ah__sub">浏览城市公益活动，发现属于你的志愿服务机会。从社区关怀到环境保护，每一次参与都值得被记录。</p>
<div class="ah__search">
<div class="ah__search-wrap">
<input class="ah__search-input" id="actSearch" placeholder="搜索活动名称、地点...">
<span class="ah__search-icon">⌕</span>
</div>
</div>
<div class="ah-stats">
<div class="ah-stat"><span class="ah-stat__icon">📋</span> 总计<strong id="ahTotal">0</strong>场活动</div>
<div class="ah-stat"><span class="ah-stat__icon">🟢</span> 招募中<strong id="ahRecruiting">0</strong></div>
<div class="ah-stat"><span class="ah-stat__icon">🔵</span> 即将开始<strong id="ahUpcoming">0</strong></div>
<div class="ah-stat"><span class="ah-stat__icon">📌</span> 已收藏<strong id="ahBookmarked">0</strong></div>
</div>
</div>
</section>

<!-- Filter -->
<section class="af">
<div class="container">
<div class="af__inner">
<div class="af__pills" id="afPills"></div>
<div class="af__right">
<select class="af__select" id="afSort">
<option value="default">默认排序</option>
<option value="latest">最新发布</option>
<option value="soon">即将开始</option>
<option value="popular">报名人数最多</option>
<option value="remaining">剩余名额最少</option>
</select>
<div class="af__view" id="afView">
<button class="af__vbtn is-active" data-v="grid" title="网格"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg></button>
<button class="af__vbtn" data-v="list" title="列表"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg></button>
</div>
</div>
</div>
</div>
</section>

<!-- Hot Activities Horizontal Scroll -->
<section class="hot-sec">
<div class="hot-sec__hd">
<h3 class="hot-sec__title">🔥 热门速览</h3>
</div>
<div class="hot-sec__list">
<div class="hot-row" id="hotRow"></div>
</div>
</section>

<!-- Stats -->
<div class="as">
<div class="container">
<div class="as__inner">
<div class="as__cnt">共 <strong id="asTotal">0</strong> 个活动</div>
<div class="as__cnt" id="asFilter" style="color:#6b7280;font-weight:400;font-family:inherit;font-size:.84rem;"></div>
</div>
</div>
</div>

<!-- Content -->
<section class="section" style="padding-top:32px;">
<div class="container">
<div class="dl-bar" id="deadlineBar" style="display:none;">
<div class="dl-bar__info">
<span class="dl-bar__icon">⏰</span>
<span>最近3天内截止报名的活动：<span class="dl-bar__cnt" id="dlCount">0</span> 个</span>
</div>
<a class="dl-bar__link" href="#agGrid">立即报名 →</a>
</div>
<div class="ag ag--grid" id="agGrid"></div>
<div class="ae hide" id="aeEmpty"><div class="ae__icon">🔍</div><h3 class="ae__t">暂无符合条件的活动</h3><p>尝试调整筛选条件，或点击右下角智能匹配按钮</p><button class="button button--ghost" id="aeClear">清除筛选</button></div>
<div class="ap" id="apPagination"></div>
<div class="acta"><h3 class="acta__t">没找到合适的活动？</h3><p class="acta__s">试试右下角的🧠智能匹配，根据你的偏好推荐活动</p><div class="acta__acts"><button class="button button--ghost" onclick="window.scrollTo({top:0,behavior:'smooth'})">返回顶部</button><a class="button button--primary" href="${pageContext.request.contextPath}/discover.jsp">去看看发现页</a></div></div>
</div>
</section>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</div>

<!-- Smart Match FAB -->
<button class="sm-fab" id="smFab" title="智能匹配活动">
<span class="sm-fab__icon">🧠</span>
</button>

<!-- Leaderboard FAB -->
<button class="lb-fab" id="lbFab" title="志愿者活跃榜">
<span class="lb-fab__icon">🏆</span>
</button>

<!-- Leaderboard Overlay -->
<div class="lb-overlay" id="lbOverlay">
<div class="lb-sidebar" id="lbSidebar">
<div class="lb-sidebar__hd">
<h3 class="lb-sidebar__title">🏅 积分排行</h3>
<button class="lb-sidebar__close" id="lbClose">✕</button>
</div>
<div class="lb-sidebar__list" id="lbList"></div>
<div class="lb-sidebar__ft">
<button class="lb-sidebar__more" id="lbMore">查看更多 ➜</button>
</div>
</div>
</div>

<!-- Activity Detail Overlay -->
<div class="ad-overlay" id="adOverlay">
<div class="ad-modal" id="adModal">
<div class="ad-modal__header">
<img id="adImg" src="" alt="">
<div class="ad-modal__header-overlay"></div>
<button class="ad-modal__close" id="adClose">✕</button>
<span class="ad-modal__badge" id="adBadge"></span>
</div>
<div class="ad-modal__body">
<h2 class="ad-modal__title" id="adTitle"></h2>
<div class="ad-modal__meta" id="adMeta"></div>
<p class="ad-modal__desc" id="adDesc"></p>
<div class="ad-modal__stats">
<div class="ad-modal__stat"><div class="ad-modal__stat--num" id="adEnrolled">0</div><div class="ad-modal__stat--label">已报名</div></div>
<div class="ad-modal__stat"><div class="ad-modal__stat--num" id="adCapacity">0</div><div class="ad-modal__stat--label">总名额</div></div>
<div class="ad-modal__stat"><div class="ad-modal__stat--num" id="adHours">0</div><div class="ad-modal__stat--label">服务时长</div></div>
<div class="ad-modal__stat"><div class="ad-modal__stat--num" id="adHeat">0</div><div class="ad-modal__stat--label">热度值</div></div>
</div>
</div>
<div class="ad-modal__footer" id="adFooter">
<span id="adRegStatus" style="display:none"></span>
<button class="ad-btn ad-btn--primary" id="adRegisterBtn">立即报名</button>
<button class="ad-btn ad-btn--danger" id="adCancelBtn" style="display:none">取消报名</button>
</div>
</div>
</div>

<script>window.APP_CONTEXT_PATH="${pageContext.request.contextPath}";window.APP_USER_ROLE="<%=displayRole%>";window.APP_USER_NAME="<%=displayName%>"</script>
<script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/data.js"></script>
<script charset="UTF-8" src="${pageContext.request.contextPath}/assets/js/points.js"></script>
<script>
(function(){
var ctx=window.APP_CONTEXT_PATH||'.',PS=12;
var all=[],cats=["全部"],activeCat="全部",sq="",sortBy="default",cv="grid",cp=1;
var deepLinkHandled=false;
var bm=JSON.parse(localStorage.getItem('act_bm')||'[]');

function esc(s){return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;')}
function img(p){if(!p)return ctx+'/assets/images/activity-1.jpg';return /^https?:/.test(p)?p:ctx+'/'+p.replace(/^\/+/,'')}
function isWeekend(ds){if(!ds)return false;var d=new Date(ds);if(isNaN(d.getTime()))return false;var w=d.getDay();return w===0||w===6}

function getStatusStr(s){
 if(s===0||s==='0')return'recruiting';
 if(s===1||s==='1')return'ongoing';
 if(s===2||s==='2')return'finished';
 if(s===3||s==='3')return'cancelled';
 return'recruiting';
}
function getFiltered(){
 var items=all.slice();
 if(activeCat!=='全部')items=items.filter(function(a){return a.category===activeCat});
 if(sq.trim()){var q=sq.trim().toLowerCase();items=items.filter(function(a){return(a.title||'').toLowerCase().indexOf(q)>=0||(a.location||'').toLowerCase().indexOf(q)>=0})}
 return items
}
function applySort(items){
 var l=items.slice();
 if(sortBy==='latest')l.sort(function(a,b){return Number(b.id)-Number(a.id)});
 if(sortBy==='soon')l.sort(function(a,b){return String(a.date||'').localeCompare(String(b.date||''))});
 if(sortBy==='popular')l.sort(function(a,b){return Number(b.enrolled||0)-Number(a.enrolled||0)});
 if(sortBy==='remaining')l.sort(function(a,b){return(Number(a.capacity||0)-Number(a.enrolled||0))-(Number(b.capacity||0)-Number(b.enrolled||0))});
 return l
}
function getPage(){var f=getFiltered(),s=applySort(f),st=(cp-1)*PS;return{items:s.slice(st,st+PS),total:s.length,tp:Math.ceil(s.length/PS)}}

function renderCatCounts(){var cnts={};all.forEach(function(a){var c=a.category||'';cnts[c]=(cnts[c]||0)+1});return cnts}
function renderPills(){
 var html='',cnts=renderCatCounts();
 for(var i=0;i<cats.length;i++){var c=cats[i];var isA=c===activeCat;var cnt=c==='全部'?all.length:(cnts[c]||0);
  html+='<button class="af__pill'+(isA?' is-active':'')+'" data-ac="'+esc(c)+'">'+esc(c)+'<span class="af__pill--count">'+cnt+'</span></button>'}
 document.getElementById('afPills').innerHTML=html
}
function renderView(){var bs=document.querySelectorAll('#afView .af__vbtn');for(var i=0;i<bs.length;i++){bs[i].classList.toggle('is-active',bs[i].getAttribute('data-v')===cv)}}
function updateHeroStats(){var f=getFiltered();document.getElementById('ahTotal').textContent=all.length;var r=all.filter(function(a){return getStatusStr(a.status)==='recruiting'}).length;document.getElementById('ahRecruiting').textContent=r;var u=all.filter(function(a){return getStatusStr(a.status)==='finished'}).length;document.getElementById('ahUpcoming').textContent=u;document.getElementById('ahBookmarked').textContent=bm.length}

function renderCard(a){
 var col=a.categoryColor||'#27ae60',e=Number(a.enrolled||0),c=Number(a.capacity||1),p=Math.min(Math.round(e/c*100),100);
 var status=getStatusStr(a.status),isFull=e>=c||status==='finished',prCls=p>=90?' ac__prf--hi':'',cntCls=p>=90?' ac__prc--hi':'';
 var stagCls=isFull?'ac__stag--f':(status==='finished'?'ac__stag--u':'ac__stag--r');
 var isBm=bm.indexOf(a.id)>=0,lsCls=cv==='list'?' ac--list':'';
 var statusLabel=a.statusLabel||(isFull?'已满员':(status==='finished'?'已结束':'招募中'));
 return'<article class="ac'+lsCls+'" data-id="'+a.id+'" id="act-'+a.id+'">'+
  '<div class="ac__img"><img src="'+img(a.image)+'" alt="'+esc(a.title)+'" loading="lazy">'+
   '<div class="ac__gradient"></div>'+
   '<span class="ac__badge" style="background:'+col+'">'+esc(a.category||'')+'</span>'+
   '<div class="ac__status"><span class="ac__stag '+stagCls+'">'+esc(statusLabel)+'</span></div>'+
   '<button class="ac__bookmark'+(isBm?' is-bm':'')+'" data-bm="'+a.id+'" title="收藏">'+(isBm?'♥':'♡')+'</button>'+
  '</div>'+
  '<div class="ac__body"><span class="ac__cat" style="color:'+col+'">'+esc(a.category||'')+'</span>'+
   '<h3 class="ac__title">'+esc(a.title)+'</h3>'+
   '<div class="ac__meta"><span>📅 '+esc(a.date||a.startTime||'')+'</span><span>📍 '+esc(a.location||'')+'</span></div>'+
   '<div class="ac__prog"><div class="ac__prh"><span class="ac__prl">'+(isFull?'已满员':'报名进度')+'</span><span class="ac__prc'+cntCls+'">'+e+'/'+c+' 人</span></div>'+
    '<div class="ac__prt"><div class="ac__prf'+prCls+'" style="width:'+p+'%"></div></div></div>'+
  '</div></article>'
}
function renderCards(items,isList){
 var html='';for(var i=0;i<items.length;i++){html+=renderCard(items[i])}return html
}
function renderPagination(tp){
 var el=document.getElementById('apPagination');if(tp<=1){el.innerHTML='';return}
 var h='';h+='<button class="ap__b"'+(cp===1?' disabled':'')+' data-p="prev">‹</button>';
 var sp=Math.max(1,cp-2),ep=Math.min(tp,cp+2);
 if(sp>1){h+='<button class="ap__b" data-p="1">1</button>';if(sp>2)h+='<span class="ap__dot">…</span>'}
 for(var p=sp;p<=ep;p++)h+='<button class="ap__b'+(p===cp?' is-act':'')+'" data-p="'+p+'">'+p+'</button>';
 if(ep<tp){if(ep<tp-1)h+='<span class="ap__dot">…</span>';h+='<button class="ap__b" data-p="'+tp+'">'+tp+'</button>'}
 h+='<button class="ap__b"'+(cp===tp?' disabled':'')+'" data-p="next">›</button>';el.innerHTML=h
}
function render(goPage1){
 if(goPage1)cp=1;
 var r=getPage();var items=r.items,total=r.total,tp=r.tp;
 if(cp>tp&&tp>0){cp=tp;r=getPage();items=r.items;total=r.total;tp=r.tp}
 var g=document.getElementById('agGrid');g.className='ag ag--'+(cv==='list'?'list':'grid');
 g.innerHTML=renderCards(items);
 document.getElementById('asTotal').textContent=total;
 var fs='';if(activeCat!=='全部')fs+='<span class="as__tag">'+esc(activeCat)+'<button data-rc>&times;</button></span>';
 if(sq.trim())fs+='<span class="as__tag">搜索:"'+esc(sq.trim())+'"<button data-rs>&times;</button></span>';
 document.getElementById('asFilter').innerHTML=fs;
 var ae=document.getElementById('aeEmpty');if(total===0){ae.classList.remove('hide');g.style.display='none'}else{ae.classList.add('hide');g.style.display=''}
 renderPagination(tp);updateHeroStats();bindBmBtns();bindCardClicks()
}
function bindBmBtns(){
 document.querySelectorAll('[data-bm]').forEach(function(b){
  b.onclick=function(e){e.stopPropagation();var id=Number(b.getAttribute('data-bm'));var i=bm.indexOf(id);
   if(i>=0)bm.splice(i,1);else bm.push(id);
   localStorage.setItem('act_bm',JSON.stringify(bm));b.textContent=bm.indexOf(id)>=0?'♥':'♡';b.classList.toggle('is-bm',bm.indexOf(id)>=0);updateHeroStats()}
 })
}
function bindCardClicks(){
 document.querySelectorAll('[data-id]').forEach(function(card){
  card.addEventListener('click',function(e){
   if(e.target.closest('[data-bm]'))return;
   var id=Number(card.getAttribute('data-id'));
   openDetail(id);
  })
 })
}

/* ===== Activity Detail Modal ===== */
var currentAct=null;
function openDetail(id){
 var act=all.find(function(a){return a.id===id});
 if(!act){alert('活动不存在');return}
 currentAct=act;
 document.getElementById('adImg').src=img(act.image);
 document.getElementById('adBadge').textContent=act.category||'';
 document.getElementById('adBadge').style.background=act.categoryColor||'#27ae60';
 document.getElementById('adTitle').textContent=act.title||'';
 document.getElementById('adDesc').textContent=act.description||'暂无活动详情';
 document.getElementById('adMeta').innerHTML='<span>📅 '+esc(act.date||act.startTime||'')+'</span><span>📍 '+esc(act.location||'')+'</span>';
 document.getElementById('adEnrolled').textContent=act.enrolled||0;
 document.getElementById('adCapacity').textContent=act.capacity||0;
 document.getElementById('adHours').textContent=act.serviceHour||act.service_hour||3;
 document.getElementById('adHeat').textContent=act.heatValue||act.heat_value||50;
 
 var regStatus=act.myRegistrationStatus;
 var regLabel=act.myRegistrationLabel;
 var status=getStatusStr(act.status);
 var e=Number(act.enrolled||0),c=Number(act.capacity||1);
 var isFull=e>=c;
 
 var regStatusEl=document.getElementById('adRegStatus');
 var regBtn=document.getElementById('adRegisterBtn');
 var cancelBtn=document.getElementById('adCancelBtn');
 
 regStatusEl.style.display='none';
 regBtn.style.display='none';
 cancelBtn.style.display='none';
 
 if(regStatus!==undefined&&regStatus!==null){
  regStatusEl.style.display='inline-block';
  regStatusEl.textContent=regLabel||'';
  if(regStatus===0)regStatusEl.className='ad-reg-status ad-reg-status--pending';
  else if(regStatus===1)regStatusEl.className='ad-reg-status ad-reg-status--approved';
  else if(regStatus===4)regStatusEl.className='ad-reg-status ad-reg-status--finished';
  else if(regStatus===3)regStatusEl.className='ad-reg-status ad-reg-status--cancelled';
  
  if(regStatus===0||regStatus===1){
   cancelBtn.style.display='block';
  }
 }else{
  if(status==='recruiting'&&!isFull){
   regBtn.style.display='block';
  }else{
   regBtn.style.display='block';
   regBtn.textContent=isFull?'已满员':(status==='finished'?'已结束':'不可报名');
   regBtn.disabled=true;
   regBtn.classList.remove('ad-btn--primary');
   regBtn.classList.add('ad-btn--ghost');
  }
 }
 
 document.getElementById('adOverlay').classList.add('is-open');
}
window.openActivityDetail=openDetail;
function closeDetail(){
 document.getElementById('adOverlay').classList.remove('is-open');
 currentAct=null;
}
function doRegister(){
 if(!currentAct)return;
 if(window.APP_USER_ROLE==='anonymous'){
  alert('请先登录后再报名');
  window.location.href=ctx+'/login.jsp';
  return;
 }
 if(confirm('确定要报名"'+currentAct.title+'"吗？')){
  fetch(ctx+'/activity/api/register?activityId='+currentAct.id,{method:'POST'})
  .then(function(r){return r.json()})
  .then(function(res){
   if(res&&res.success){
    alert(res.message||'报名成功');
    closeDetail();
    init();
   }else{
    alert(res&&res.message||'报名失败');
   }
  })
  .catch(function(e){
   console.error('Register failed:',e);
   alert('报名失败，请稍后重试');
  });
 }
}
function doCancel(){
 if(!currentAct)return;
 if(confirm('确定要取消报名"'+currentAct.title+'"吗？')){
  fetch(ctx+'/activity/api/cancel?activityId='+currentAct.id,{method:'POST'})
  .then(function(r){return r.json()})
  .then(function(res){
   if(res&&res.success){
    alert(res.message||'已取消报名');
    closeDetail();
    init();
   }else{
    alert(res&&res.message||'取消失败');
   }
  })
  .catch(function(e){
   console.error('Cancel failed:',e);
   alert('取消失败，请稍后重试');
  });
 }
}

/* Events */
document.getElementById('afPills').addEventListener('click',function(e){var b=e.target.closest('[data-ac]');if(!b)return;activeCat=b.getAttribute('data-ac');renderPills();render(true)});
document.getElementById('actSearch').addEventListener('input',function(){sq=this.value;render(true)});
document.getElementById('afSort').addEventListener('change',function(){sortBy=this.value;render(true)});
document.getElementById('afView').addEventListener('click',function(e){var b=e.target.closest('[data-v]');if(!b)return;cv=b.getAttribute('data-v');renderView();render(false)});
document.getElementById('apPagination').addEventListener('click',function(e){var b=e.target.closest('[data-p]');if(!b||b.disabled)return;var v=b.getAttribute('data-p');if(v==='prev')cp=Math.max(1,cp-1);else if(v==='next')cp=Math.min(Math.ceil(getFiltered().length/PS),cp+1);else cp=Number(v);render(false);document.getElementById('agGrid').scrollIntoView({behavior:'smooth',block:'start'})});
document.getElementById('aeClear').addEventListener('click',function(){activeCat='全部';sq='';sortBy='default';cv='grid';cp=1;document.getElementById('actSearch').value='';document.getElementById('afSort').value='default';renderPills();renderView();render(false)});
document.getElementById('asFilter').addEventListener('click',function(e){if(e.target.closest('[data-rc]')){activeCat='全部';renderPills();render(true)}if(e.target.closest('[data-rs]')){sq='';document.getElementById('actSearch').value='';render(true)}});
document.getElementById('adClose').addEventListener('click',closeDetail);
document.getElementById('adOverlay').addEventListener('click',function(e){if(e.target.id==='adOverlay')closeDetail()});
document.getElementById('adRegisterBtn').addEventListener('click',doRegister);
document.getElementById('adCancelBtn').addEventListener('click',doCancel);

/* Init */
function init(){
 fetch(ctx+'/activity/api/list')
 .then(function(r){return r.json()})
 .then(function(res){
 if(res&&res.success&&res.data){
 all=res.data;
 window.ACTIVITY_CENTER_ALL=all;
 cats=['全部','社区服务','环境保护','教育帮扶','文明创建','助残扶弱','文化惠民'];
 renderPills();renderView();render(false);
 renderHotCards();
 renderDeadlineBar();
 if(!deepLinkHandled){
  deepLinkHandled=true;
  var requestedId=Number(new URLSearchParams(window.location.search).get('id'));
  if(requestedId)openDetail(requestedId);
 }
 }else{
 all=[];
 document.getElementById('agGrid').innerHTML='<div class="ae"><div class="ae__icon">⚠</div><h3 class="ae__t">数据加载失败</h3><p>'+(res&&res.message||'')+'</p></div>';
 }
 })
 .catch(function(e){
 console.error('Load activities failed:',e);
 document.getElementById('agGrid').innerHTML='<div class="ae"><div class="ae__icon">⚠</div><h3 class="ae__t">数据加载失败</h3><p>网络请求出错</p></div>';
 });
}
init();

/* ===== Hot Cards (Vertical Sidebar) ===== */
var hotRow=document.getElementById('hotRow');
function renderHotCards(){
 if(!hotRow||!all||all.length===0)return;
 var acts=all.slice();
 acts.sort(function(a,b){return(Number(b.enrolled||0)+Number(b.bookmarkCount||0))-(Number(a.enrolled||0)+Number(a.bookmarkCount||0))});
 var top10=acts.slice(0,10),h='';
 for(var i=0;i<top10.length;i++){
  var a=top10[i],e=Number(a.enrolled||0);
  h+='<div class="hot-card" data-hot-id="'+a.id+'" style="cursor:pointer">'+
   '<div class="hot-card__img"><img src="'+img(a.image)+'" alt="" loading="lazy"></div>'+
   '<div class="hot-card__body"><div class="hot-card__title">'+esc(a.title)+'</div>'+
   '<div class="hot-card__count">🔥 '+e+' 人</div></div></div>'
 }
 hotRow.innerHTML=h
}

/* Hot card click - open the selected activity registration card */
if(hotRow){
 hotRow.addEventListener('click',function(e){
  var card=e.target.closest('[data-hot-id]');
  if(!card)return;
  openDetail(Number(card.getAttribute('data-hot-id')));
 });
}

/* ===== Deadline Bar ===== */
function renderDeadlineBar(){
 if(!all||all.length===0)return;
 var now=new Date(),dlActs=[];
 all.forEach(function(a){
  if(getStatusStr(a.status)!=='recruiting')return;
  var d=new Date(a.date||a.startTime||'');if(isNaN(d.getTime()))return;
  var diff=Math.ceil((d.getTime()-now.getTime())/(1000*60*60*24));
  if(diff>=0&&diff<=3)dlActs.push(a)
 });
 var db=document.getElementById('deadlineBar'),dc=document.getElementById('dlCount');
 if(db&&dc&&dlActs.length>0){db.style.display='flex';dc.textContent=dlActs.length}else if(db){db.style.display='none'}
}

})();

/* ===== Smart Match ===== */
(function(){
 var smCtx="${pageContext.request.contextPath}"||'.',smFab=document.getElementById('smFab');if(!smFab)return;
 var smEsc=function(s){return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;')};
 var smImg=function(p){if(!p)return smCtx+'/assets/images/activity-1.jpg';return/^https?:/.test(p)?p:smCtx+'/'+p.replace(/^\/+/,'')};
 var smIsWeekend=function(ds){if(!ds)return false;var d=new Date(ds);return!isNaN(d.getTime())&&(d.getDay()===0||d.getDay()===6)};
 var smGetStatusStr=function(s){if(s===0||s==='0')return'recruiting';if(s===1||s==='1')return'ongoing';if(s===2||s==='2')return'finished';if(s===3||s==='3')return'cancelled';return'recruiting'};
 var smSteps=[
  {title:'活动场景偏好',subtitle:'选择一个你最感兴趣的活动场景',choices:[
   {id:'community',icon:'🏘',title:'社区近邻',desc:'服务邻里，参与互助关怀等公益活动'},
   {id:'outdoor',icon:'🌿',title:'户外自然',desc:'走进大自然，参与环保生态志愿行动'},
   {id:'culture',icon:'🎨',title:'文化文艺',desc:'投身文化传播与艺术创作活动'}]},
  {title:'时间偏好',subtitle:'你的时间安排是怎样的？',choices:[
   {id:'weekend',icon:'📅',title:'周末有空',desc:'主要在周末参与'},
   {id:'flexible',icon:'⏰',title:'时间灵活',desc:'工作日或周末都可以'},
   {id:'asap',icon:'🚀',title:'越快越好',desc:'近期有活动就能报名'}]},
  {title:'服务风格',subtitle:'你更倾向于哪种服务方式？',choices:[
   {id:'people',icon:'🤝',title:'与人打交道',desc:'喜欢沟通交流，人际互动'},
   {id:'hands',icon:'🔧',title:'动手实干',desc:'实操型任务，双手劳动'},
   {id:'creative',icon:'💡',title:'创意策划',desc:'用创意和智慧推动项目'}]}
 ];
 var smCat={community:['社区服务','助残扶弱'],outdoor:['环境保护'],culture:['文化惠民','文明创建','教育帮扶']};
 var smStyle={people:['沟通','交流','老人','儿童','社区','邻里','关爱','陪伴','助残','扶弱','服务','走访','慰问','支教','辅导'],hands:['动手','清理','打扫','植树','环保','劳动','维护','修缮','绿化','净滩','垃圾','整理','回收','改造','清洁'],creative:['创意','策划','设计','文化','艺术','表演','宣传','摄影','写作','编辑','绘画','展览','音乐','文明']};
 var smAns={},smStep=0,smModalEl=null,smWrapEl=null;

 /* Global scroll-to-activity helper (used by smart match result cards) */
 window.smScrollToAct=function(id){
  smCloseModal();
  setTimeout(function(){
   if(window.openActivityDetail)window.openActivityDetail(Number(id));
  },400);
 };

 function smMatchScore(act){
  var s=0;var cc=smCat[smAns.scene]||[];
  if(cc.indexOf(act.category)>=0)s+=35;
  else if(smAns.scene&&act.category)for(var k in smCat){if(smCat[k].indexOf(act.category)>=0){s+=15;break}}
  if(smAns.time==='weekend'&&smIsWeekend(act.date||act.startTime))s+=35;else if(smAns.time==='asap'&&smGetStatusStr(act.status)==='finished')s+=35;else if(smAns.time==='flexible')s+=20;else s+=10;
  var kw=smStyle[smAns.style]||[];var t=(act.title||'').toLowerCase();var m=false;
  for(var i=0;i<kw.length;i++){if(t.indexOf(kw[i])>=0){m=true;break}}
  if(m)s+=30;else{s+=8}
  return s
 }
 function smGetResults(){
  var source=window.ACTIVITY_CENTER_ALL||[];
  if(source.length===0)return[];
  var acts=source.slice(),r=[];
  for(var i=0;i<acts.length;i++){var sc=smMatchScore(acts[i]);r.push({activity:acts[i],score:sc})}
  r.sort(function(a,b){return b.score-a.score});return r
 }

 function smProgress(s){
  var h='<div class="sm-steps">';for(var i=0;i<3;i++){if(i>0)h+='<div class="sm-sline'+(i<=s?' sm-sline--done':'')+'"></div>';var d='sm-sdot';if(i===s)d+=' sm-sdot--active';else if(i<s)d+=' sm-sdot--done';h+='<div class="'+d+'">'+(i+1)+'</div>'}h+='</div>';return h
 }
 function smChoices(sd){
  var h='<div class="sm-grid">',key=['scene','time','style'][smStep];
  for(var i=0;i<sd.choices.length;i++){var c=sd.choices[i];var sel=smAns[key]===c.id?' is-sel':'';h+='<div class="sm-card'+sel+'" data-sc="'+c.id+'"><span class="sm-card__icon">'+c.icon+'</span><span class="sm-card__title">'+c.title+'</span><span class="sm-card__desc">'+c.desc+'</span></div>'}h+='</div>';return h
 }
 function smResultCard(item){
  var a=item.activity,col=a.categoryColor||'#27ae60',e=Number(a.enrolled||0),c=Number(a.capacity||1),p=Math.min(Math.round(e/c*100),100);
  var status=smGetStatusStr(a.status),isFull=e>=c||status==='finished',prCls=p>=90?' ac__prf--hi':'',sCol=item.score>=70?'#7c3aed':(item.score>=45?'#a855f7':'#94a3b8');
  return'<article class="ac sm-result-card" style="margin-bottom:0;" data-sm-act-id="'+a.id+'" onclick="smScrollToAct(\''+a.id+'\')">'+
   '<div class="ac__img"><img src="'+smImg(a.image)+'" alt=""><div class="sm-score" style="background:linear-gradient(135deg,'+sCol+',#c084fc)">'+item.score+'分</div></div>'+
   '<div class="ac__body"><span class="ac__cat" style="color:'+col+'">'+smEsc(a.category||'')+'</span>'+
    '<h3 class="ac__title" style="font-size:.92rem;">'+smEsc(a.title)+'</h3>'+
    '<div class="ac__meta"><span>📅 '+smEsc(a.date||a.startTime||'')+'</span><span>📍 '+smEsc(a.location||'')+'</span></div>'+
    '<div class="ac__prog"><div class="ac__prh"><span class="ac__prl">'+(isFull?'已满员':'报名进度')+'</span><span class="ac__prc'+(p>=90?' ac__prc--hi':'')+'">'+e+'/'+c+' 人</span></div>'+
     '<div class="ac__prt"><div class="ac__prf'+prCls+'" style="width:'+p+'%"></div></div></div>'+
   '</div></article>'
  }
 function smBuildPanel(){
  if(smStep<3){var sd=smSteps[smStep];return smProgress(smStep)+'<h3 class="sm-title">第'+(smStep+1)+'步：'+sd.title+'</h3><p class="sm-sub">'+sd.subtitle+'</p>'+smChoices(sd)}
  var rr=smGetResults(),top=rr.slice(0,15);
  return'<div class="sm-result"><div class="sm-result__head"><div class="sm-result__icon">🧠</div><h3 class="sm-result__title">为你匹配了 <span class="sm-result__count">'+rr.length+'</span> 个活动</h3><p class="sm-sub" style="text-align:center;padding:0;">根据你的偏好排序展示（点击✕关闭）</p></div>'+
   '<div class="sm-result-acts">'+(top.length?top.map(smResultCard).join(''):'<div style="text-align:center;color:#94a3b8;padding:30px;">😔 没有找到完全匹配的活动<br><span style="font-size:.8rem;">试试调整偏好或直接浏览全部活动</span></div>')+'</div>'+
   '<div class="sm-rta"><button class="sm-rta__retry" onclick="document.getElementById(\'smOverlay\').remove();document.getElementById(\'smFab\').click()">🔄 重新测试</button><button class="sm-rta__all" onclick="document.getElementById(\'smOverlay\').remove();window.scrollTo({top:0,behavior:\'smooth\'})">📋 查看全部活动</button></div></div>'
 }

 function smOpenModal(){
  smCloseModal();smStep=0;smAns={};
  smModalEl=document.createElement('div');smModalEl.className='sm-modal';smModalEl.id='smModal';
  smModalEl.innerHTML='<button class="sm-close" id="smClose">✕</button>';
  smWrapEl=document.createElement('div');smWrapEl.className='sm-step-wrap';smWrapEl.innerHTML=smBuildPanel();smModalEl.appendChild(smWrapEl);
  var ov=document.createElement('div');ov.className='sm-overlay';ov.id='smOverlay';ov.appendChild(smModalEl);document.body.appendChild(ov);
  smBindEvts()
 }
 function smCloseModal(){var ov=document.getElementById('smOverlay');if(ov)ov.remove();smStep=0;smAns={};smModalEl=null;smWrapEl=null}
 function smGoStep(s){
  smStep=s;if(smModalEl){smModalEl.classList.toggle('sm-modal--wide',s>=3);if(smWrapEl){smWrapEl.innerHTML=smBuildPanel()}}smBindEvts()
 }
 function smBindEvts(){
  var cl=document.getElementById('smClose');if(cl)cl.onclick=smCloseModal;
  var ovl=document.getElementById('smOverlay');if(ovl)ovl.onclick=function(e){if(e.target===ovl)smCloseModal()};
  document.querySelectorAll('#smModal [data-sc]').forEach(function(c){
   c.onclick=function(){var keys=['scene','time','style'],id=c.getAttribute('data-sc');smAns[keys[smStep]]=id;
    c.parentElement.querySelectorAll('.sm-card').forEach(function(s){s.classList.remove('is-sel')});c.classList.add('is-sel');
    var nx=smStep+1;setTimeout(function(){smGoStep(nx)},350)}
  })
 }
 smFab.onclick=smOpenModal;
})();

/* ===== Leaderboard (积分排行) ===== */
(function(){
 var $lbFab=document.getElementById('lbFab'),$lbOv=document.getElementById('lbOverlay');
 if(!$lbFab||!$lbOv)return;

 function getLeaderData(){
  return window.VolunteerStarData&&window.VolunteerStarData.pointsLeaderboard||[];
 }

 function levelBadge(level){
  var m={'传奇志愿者':'🔴','钻石志愿者':'💎','黄金志愿者':'🥇','白银志愿者':'🥈','青铜志愿者':'🥉','新星志愿者':'⭐'};
  return m[level]||'⭐';
 }

 function rankCls(r){if(r===1)return' lb-rank--g';if(r===2)return' lb-rank--s';if(r===3)return' lb-rank--b';return''}
 function itemCls(r){if(r===1)return' lb-item--top1';if(r===2)return' lb-item--top2';if(r===3)return' lb-item--top3';return''}
 function rankIcon(r){if(r===1)return'🥇';if(r===2)return'🥈';if(r===3)return'🥉';return r}

 function renderItem(v,i){
  var r=i+1,fn=v.name.charAt(0);
  return'<div class="lb-item'+itemCls(r)+'">'+
   '<div class="lb-rank'+rankCls(r)+'">'+rankIcon(r)+'</div>'+
   '<div class="lb-avatar" style="background:'+(v.av||'#7c3aed')+'">'+fn+'</div>'+
   '<div class="lb-info"><div class="lb-name">'+v.name+'</div>'+
    '<div class="lb-stats"><span>'+levelBadge(v.level)+' '+v.level+'</span> · ⭐ <strong>'+v.points+'</strong> 积分</div></div>'+
   '</div>'
 }

 function renderList(){
  var d=getLeaderData(),h='';
  for(var i=0;i<d.length;i++)h+=renderItem(d[i],i);
  document.getElementById('lbList').innerHTML=h
 }

 function open(){$lbOv.classList.add('is-open')}
 function close(){$lbOv.classList.remove('is-open')}

 $lbFab.onclick=open;
 document.getElementById('lbClose').onclick=close;
 $lbOv.onclick=function(e){if(e.target===$lbOv)close()};
 document.getElementById('lbMore').onclick=function(){window.location.href=(window.APP_CONTEXT_PATH||'.')+'/points-mall.jsp'};

 renderList();
})();
</script>
</body>
</html>

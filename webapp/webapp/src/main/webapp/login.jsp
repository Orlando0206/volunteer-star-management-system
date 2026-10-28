<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String activeTab = request.getAttribute("activeTab") == null ? "login" : String.valueOf(request.getAttribute("activeTab"));
  String message = request.getAttribute("message") == null ? "" : String.valueOf(request.getAttribute("message"));
  String successMessage = request.getAttribute("successMessage") == null ? "" : String.valueOf(request.getAttribute("successMessage"));
  String registerUsername = request.getAttribute("registerUsername") == null ? "" : String.valueOf(request.getAttribute("registerUsername"));
  String nickname = request.getAttribute("nickname") == null ? "" : String.valueOf(request.getAttribute("nickname"));
  String phone = request.getAttribute("phone") == null ? "" : String.valueOf(request.getAttribute("phone"));
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>志愿星河 - 登录注册</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Roboto+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
<style>
:root{--fs:'Noto Serif SC',serif;--fm:'Roboto Mono',monospace}

/* ===== 全屏双栏 ===== */
.as{min-height:100vh;display:flex}

/* ===== 左侧品牌面板 ===== */
.al{flex:1;position:relative;display:flex;flex-direction:column;justify-content:center;padding:80px min(6vw,80px);background:linear-gradient(160deg,rgba(39,174,96,.95),rgba(20,30,50,.97));overflow:hidden;z-index:1}
.al__orb{position:absolute;border-radius:50%;filter:blur(100px);pointer-events:none}
.al__orb--g{width:500px;height:500px;background:rgba(39,174,96,.22);top:-180px;right:-120px}
.al__orb--b{width:400px;height:400px;background:rgba(91,155,213,.14);bottom:-120px;left:-80px}
.al__orb--p{width:300px;height:300px;background:rgba(139,92,246,.1);top:55%;left:45%;transform:translate(-50%,-50%);animation:orbDrift 20s ease-in-out infinite}
@keyframes orbDrift{0%,100%{transform:translate(-50%,-50%) scale(1)}50%{transform:translate(-45%,-55%) scale(1.15)}}
.al__content{position:relative;z-index:2;color:#fff;max-width:600px}
.al__brand{display:flex;align-items:center;gap:12px;margin-bottom:44px}
.al__logo{width:48px;height:48px;border-radius:14px;background:linear-gradient(135deg,#fff,rgba(255,255,255,.8));display:flex;align-items:center;justify-content:center;box-shadow:0 8px 28px rgba(0,0,0,.2)}
.al__title{font-family:var(--fs);font-size:clamp(2rem,4vw,3.2rem);font-weight:700;line-height:1.2;margin-bottom:16px}
.al__desc{color:rgba(255,255,255,.65);line-height:1.8;font-size:1rem;max-width:480px;margin-bottom:48px}
.al__features{display:grid;grid-template-columns:repeat(2,1fr);gap:14px;max-width:540px}
.al__feat{padding:18px 16px;border-radius:16px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.07);backdrop-filter:blur(8px);transition:all .35s}
.al__feat:hover{background:rgba(255,255,255,.1);transform:translateY(-2px)}
.al__feat__i{font-size:1.3rem;margin-bottom:8px}
.al__feat__t{font-weight:600;font-size:.92rem;margin-bottom:2px}
.al__feat__d{font-size:.76rem;color:rgba(255,255,255,.45);line-height:1.4}
.al__stats{display:flex;gap:28px;margin-top:44px;padding-top:24px;border-top:1px solid rgba(255,255,255,.08)}
.al__stat-n{font-family:var(--fm);font-size:1.4rem;font-weight:700;color:#fff}
.al__stat-l{font-size:.74rem;color:rgba(255,255,255,.42);margin-top:2px}

/* ===== 右侧卡片面板 ===== */
.ar{flex:.8;position:relative;display:flex;align-items:center;justify-content:center;padding:40px 24px;z-index:1;min-width:400px;background:#0b0d13;overflow:hidden}

/* 多层装饰背景 */
.ar__bg{position:absolute;inset:0;pointer-events:none}
.ar__bg-grid{position:absolute;inset:0;background-image:linear-gradient(rgba(255,255,255,.025)1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.025)1px,transparent 1px);background-size:40px 40px}
.ar__bg-grad-top{position:absolute;top:0;left:0;right:0;height:40%;background:linear-gradient(180deg,rgba(124,58,237,.06),transparent)}
.ar__bg-grad-bot{position:absolute;bottom:0;left:0;right:0;height:30%;background:linear-gradient(0deg,rgba(39,174,96,.05),transparent)}
.ar__bg-orb1{position:absolute;top:15%;right:10%;width:280px;height:280px;border-radius:50%;background:radial-gradient(circle,rgba(124,58,237,.08),transparent 70%);filter:blur(60px);animation:bgOrb1 8s ease-in-out infinite}
.ar__bg-orb2{position:absolute;bottom:20%;left:15%;width:220px;height:220px;border-radius:50%;background:radial-gradient(circle,rgba(39,174,96,.1),transparent 70%);filter:blur(50px);animation:bgOrb2 10s ease-in-out infinite}
@keyframes bgOrb1{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(40px,-30px)scale(1.2)}}
@keyframes bgOrb2{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(-30px,20px)scale(1.15)}}

/* 流动光线 */
.ar__light-lines{position:absolute;inset:0;pointer-events:none}
.ar__ll{position:absolute;height:1px;background:linear-gradient(90deg,transparent,rgba(255,255,255,.08),transparent);animation:lightFlow 6s linear infinite}
.ar__ll:nth-child(1){top:30%;width:60%;left:-10%;animation-delay:0s}
.ar__ll:nth-child(2){top:55%;width:50%;right:-10%;animation-delay:2s;left:auto}
.ar__ll:nth-child(3){top:75%;width:45%;left:-10%;animation-delay:4s}
@keyframes lightFlow{0%{transform:translateX(-100%);opacity:0}50%{opacity:1}100%{transform:translateX(200%);opacity:0}}

/* 粒子Canvas */
.ar__particles{position:absolute;inset:0;z-index:1;pointer-events:none}

/* 装饰标志圆 */
.ar__decor{position:absolute;width:120px;height:120px;border-radius:50%;border:1px solid rgba(255,255,255,.06);pointer-events:none;animation:decorSpin 30s linear infinite}
.ar__decor:nth-child(6){top:12%;right:8%;width:100px;height:100px;animation-duration:25s}
.ar__decor:nth-child(7){bottom:15%;left:5%;width:80px;height:80px;animation-duration:35s;animation-direction:reverse}
@keyframes decorSpin{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}

/* 主卡片 */
.acard-wrap{position:relative;z-index:10;width:100%;max-width:420px}
.acard{background:rgba(255,255,255,.93);backdrop-filter:blur(24px);border-radius:26px;padding:40px 34px 34px;border:1px solid rgba(255,255,255,.55);box-shadow:0 8px 32px rgba(0,0,0,.12),0 24px 64px rgba(39,174,96,.08),0 40px 100px rgba(0,0,0,.18);animation:cardIn .7s ease both}
@keyframes cardIn{from{opacity:0;transform:translateY(30px)scale(.96)}to{opacity:1;transform:translateY(0)scale(1)}}

/* Tab */
.atab-row{display:flex;gap:5px;padding:4px;background:#f1f5f9;border-radius:13px;margin-bottom:24px}
.atab{flex:1;min-height:38px;border:0;border-radius:10px;background:transparent;color:#64748b;font-size:.88rem;cursor:pointer;transition:all .3s cubic-bezier(.4,0,.2,1);white-space:nowrap}
.atab.is-active{background:#fff;color:#27AE60;font-weight:600;box-shadow:0 2px 10px rgba(39,174,96,.15)}
.apanel{display:none;animation:fadeIn .35s ease both}
.apanel.is-active{display:block}
@keyframes fadeIn{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}

/* Alert */
.aa{margin-bottom:16px;padding:11px 16px;border-radius:12px;font-size:.86rem;display:flex;align-items:center;gap:10px;animation:shake .5s}
@keyframes shake{0%,100%{transform:translateX(0)}20%{transform:translateX(-6px)}40%{transform:translateX(6px)}60%{transform:translateX(-4px)}80%{transform:translateX(4px)}}
.aa--err{background:#fef2f2;color:#991b1b;border:1px solid #fecaca}
.aa--ok{background:#f0fdf4;color:#166534;border:1px solid #bbf7d0}

/* Field */
.af{margin-bottom:14px}
.afl{display:block;margin-bottom:5px;font-size:.84rem;font-weight:500;color:#334155}
.afw{position:relative}
.afi{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:#94a3b8;font-size:1rem;pointer-events:none;transition:color .3s}
.afw:focus-within .afi{color:#27AE60}
.ain{width:100%;height:46px;padding:0 16px 0 42px;border:2px solid #e2e8f0;border-radius:12px;background:#f8fafc;color:#1e293b;font-size:.92rem;outline:none;transition:all .3s}
.ain:focus{border-color:#27AE60;background:#fff;box-shadow:0 0 0 4px rgba(39,174,96,.07)}
.ain.is-err{border-color:#ef4444;background:#fff5f5}.ain.is-ok{border-color:#27AE60;background:#f0fdf4}
.apwt{position:absolute;right:12px;top:50%;transform:translateY(-50%);border:0;background:none;color:#94a3b8;cursor:pointer;font-size:1rem;padding:4px;transition:color .3s}
.apwt:hover{color:#475569}
.ahint{min-height:16px;margin-top:4px;font-size:.76rem;color:#94a3b8}.ahint.is-err{color:#ef4444}.ahint.is-ok{color:#16a34a}

/* Code row */
.acr{display:flex;gap:10px}.acr .afw{flex:1}.acr .ain{padding-left:16px}
.asend{flex-shrink:0;height:46px;padding:0 14px;border-radius:12px;border:1px solid #27AE60;background:#f0fdf4;color:#27AE60;font-size:.82rem;font-weight:600;cursor:pointer;white-space:nowrap;transition:all .3s;min-width:110px}
.asend:hover:not(:disabled){background:#27AE60;color:#fff}
.asend:disabled{opacity:.5;cursor:not-allowed}

/* Submit */
.asub{width:100%;height:46px;border:0;border-radius:13px;background:linear-gradient(135deg,#27AE60,#2ecc71);color:#fff;font-size:.95rem;font-weight:600;letter-spacing:.03em;cursor:pointer;transition:all .3s;box-shadow:0 6px 18px rgba(39,174,96,.28);position:relative;overflow:hidden;margin-top:4px}
.asub::before{content:"";position:absolute;inset:0;background:linear-gradient(135deg,transparent 30%,rgba(255,255,255,.18)50%,transparent 70%);transform:translateX(-100%);transition:transform .6s}
.asub:hover{transform:translateY(-2px);box-shadow:0 8px 26px rgba(39,174,96,.38)}
.asub:hover::before{transform:translateX(100%)}
.asub:active{transform:translateY(0)}
.aft{text-align:center;margin-top:18px;font-size:.8rem;color:#94a3b8}.aft a{color:#27AE60;font-weight:500}.aft a:hover{text-decoration:underline}
.adiv{display:flex;align-items:center;gap:10px;margin:16px 0;color:#cbd5e1;font-size:.74rem}.adiv::before,.adiv::after{content:"";flex:1;height:1px;background:#e2e8f0}

@media(max-width:900px){.as{flex-direction:column}.al{flex:none;padding:44px 20px 36px;min-height:auto}.al__content{text-align:center}.al__desc{max-width:none;margin-bottom:28px}.al__features{max-width:none;text-align:left}.al__stats{justify-content:center}.al__brand{justify-content:center}.ar{padding:20px 16px 40px;min-width:auto}.acard{max-width:440px}}
@media(max-width:520px){.al{padding:32px 16px 24px}.al__features{grid-template-columns:1fr}.al__stats{gap:18px;flex-wrap:wrap}.acard{padding:30px 20px 26px;border-radius:20px}.acr{flex-direction:column}.asend{width:100%}}
</style>
</head>
<body>
<div class="as">
<!-- ===== 左侧品牌面板 ===== -->
<div class="al">
<div class="al__orb al__orb--g"></div>
<div class="al__orb al__orb--b"></div>
<div class="al__orb al__orb--p"></div>
<div class="al__content">
<div class="al__brand"><div class="al__logo"><svg width="26" height="26" viewBox="0 0 24 24" fill="none"><path d="M12 2L2 7l10 5 10-5L12 2z" fill="#27ae60"/><path d="M2 17l10 5 10-5" stroke="#27ae60" stroke-width="1.5" stroke-linecap="round"/><path d="M2 12l10 5 10-5" stroke="#27ae60" stroke-width="1.5" stroke-linecap="round"/></svg></div><span style="font-family:var(--fs);font-size:1.2rem;font-weight:700;letter-spacing:.04em">志愿星河</span></div>
<h1 class="al__title">让每一份善意<br>都有迹可循</h1>
<p class="al__desc">城市公益活动报名与志愿时长管理平台。为志愿者与组织者搭建高效、透明、温暖的数字化桥梁。</p>
<div class="al__features">
<div class="al__feat"><div class="al__feat__i">📋</div><div class="al__feat__t">发布与报名</div><div class="al__feat__d">一键发布活动，在线报名审核</div></div>
<div class="al__feat"><div class="al__feat__i">⏱️</div><div class="al__feat__t">时长认证</div><div class="al__feat__d">签到自动计算，防篡改溯源</div></div>
<div class="al__feat"><div class="al__feat__i">🗺️</div><div class="al__feat__t">热力地图</div><div class="al__feat__d">区域热度可视化，一目了然</div></div>
<div class="al__feat"><div class="al__feat__i">🏅</div><div class="al__feat__t">成就徽章</div><div class="al__feat__d">服务成长体系，荣誉见证</div></div>
</div>
<div class="al__stats"><div><div class="al__stat-n">2,847</div><div class="al__stat-l">注册志愿者</div></div><div><div class="al__stat-n">186</div><div class="al__stat-l">公益活动场次</div></div><div><div class="al__stat-n">12,580</div><div class="al__stat-l">服务时长(小时)</div></div></div>
</div></div>

<!-- ===== 右侧卡片面板（丰富装饰） ===== -->
<div class="ar">
<!-- 多层背景装饰 -->
<div class="ar__bg">
<div class="ar__bg-grid"></div>
<div class="ar__bg-grad-top"></div>
<div class="ar__bg-grad-bot"></div>
<div class="ar__bg-orb1"></div>
<div class="ar__bg-orb2"></div>
<div class="ar__light-lines"><div class="ar__ll"></div><div class="ar__ll"></div><div class="ar__ll"></div></div>
</div>
<div class="ar__decor" style="top:12%;right:8%;width:100px;height:100px;"></div>
<div class="ar__decor" style="bottom:15%;left:5%;width:80px;height:80px;"></div>
<canvas class="ar__particles" id="arParticles"></canvas>

<!-- 卡片 -->
<div class="acard-wrap">
<div class="acard">
<% if(!"".equals(message)){ %><div class="aa aa--err"><span>⚠</span><%=message%></div><%}%>
<% if(!"".equals(successMessage)){ %><div class="aa aa--ok"><span>✓</span><%=successMessage%></div><%}%>

<div class="atab-row">
<button class="atab <%= "login".equals(activeTab)?"is-active":"" %>" data-at="login">账号登录</button>
<button class="atab <%= "phone".equals(activeTab)?"is-active":"" %>" data-at="phone">验证码登录</button>
<button class="atab <%= "register".equals(activeTab)?"is-active":"" %>" data-at="register">注册账号</button>
</div>

<!-- 账号登录 -->
<form class="apanel <%= "login".equals(activeTab)?"is-active":"" %>" data-ap="login" action="${pageContext.request.contextPath}/auth" method="post">
<input type="hidden" name="action" value="login">
<div class="af"><label class="afl" for="lu">用户名</label><div class="afw"><span class="afi">👤</span><input class="ain" id="lu" name="username" placeholder="请输入用户名" required autocomplete="username"></div></div>
<div class="af"><label class="afl" for="lp">密码</label><div class="afw"><span class="afi">🔒</span><input class="ain" id="lp" name="password" type="password" placeholder="请输入密码" required autocomplete="current-password"><button type="button" class="apwt" data-pw="lp">👁</button></div></div>
<button class="asub" type="submit">登录平台</button>
<div class="aft">还没有账号？<a href="javascript:void(0)" data-st="register">立即注册</a></div>
</form>

<!-- 验证码登录 -->
<form class="apanel <%= "phone".equals(activeTab)?"is-active":"" %>" data-ap="phone" action="${pageContext.request.contextPath}/auth" method="post">
<input type="hidden" name="action" value="phoneCodeLogin">
<div class="af"><label class="afl" for="pp">手机号</label><div class="afw"><span class="afi">📱</span><input class="ain" id="pp" name="phone" type="tel" placeholder="请输入11位手机号" required maxlength="11"></div></div>
<div class="af"><label class="afl" for="pc">验证码</label><div class="acr"><div class="afw"><span class="afi">✉</span><input class="ain" id="pc" name="code" type="text" placeholder="6位验证码" required maxlength="6"></div><button type="button" class="asend" id="sCode">获取验证码</button></div><div class="ahint" id="ch"></div></div>
<button class="asub" type="submit">验证码登录</button>
<div class="adiv"><span>首次登录将自动注册</span></div>
<div class="aft">已有账号？<a href="javascript:void(0)" data-st="login">账号密码登录</a></div>
</form>

<!-- 注册 -->
<form class="apanel <%= "register".equals(activeTab)?"is-active":"" %>" data-ap="register" action="${pageContext.request.contextPath}/auth" method="post">
<input type="hidden" name="action" value="register">
<div class="af"><label class="afl" for="ru">用户名</label><div class="afw"><span class="afi">👤</span><input class="ain" id="ru" name="registerUsername" value="<%=registerUsername%>" placeholder="4到20位用户名" required></div><div class="ahint" id="us"></div></div>
<div class="af"><label class="afl" for="rn">昵称</label><div class="afw"><span class="afi">✏</span><input class="ain" id="rn" name="nickname" value="<%=nickname%>" placeholder="请输入昵称" required></div></div>
<div class="af"><label class="afl" for="rp">手机号（选填）</label><div class="afw"><span class="afi">📱</span><input class="ain" id="rp" name="phone" value="<%=phone%>" type="tel" placeholder="11位手机号，选填" maxlength="11"></div></div>
<div class="af"><label class="afl" for="rps">密码</label><div class="afw"><span class="afi">🔒</span><input class="ain" id="rps" name="registerPassword" type="password" placeholder="6到20位密码" required><button type="button" class="apwt" data-pw="rps">👁</button></div></div>
<div class="af"><label class="afl" for="rcps">确认密码</label><div class="afw"><span class="afi">🔒</span><input class="ain" id="rcps" name="confirmPassword" type="password" placeholder="再次输入密码" required></div></div>
<button class="asub" type="submit">创建账号</button>
<div class="aft">已有账号？<a href="javascript:void(0)" data-st="login">立即登录</a></div>
</form>
</div></div>
</div></div>

<script>
var ctx='${pageContext.request.contextPath}';
(function(){
/* Tabs */
var tbs=document.querySelectorAll('[data-at]'),pns=document.querySelectorAll('[data-ap]');
function swTab(n){tbs.forEach(function(b){b.classList.toggle('is-active',b.getAttribute('data-at')===n)});pns.forEach(function(p){p.classList.toggle('is-active',p.getAttribute('data-ap')===n)})}
tbs.forEach(function(b){b.addEventListener('click',function(){swTab(b.getAttribute('data-at'))})});
document.querySelectorAll('[data-st]').forEach(function(l){l.addEventListener('click',function(e){e.preventDefault();swTab(l.getAttribute('data-st'))})});
/* PW toggle */
document.querySelectorAll('[data-pw]').forEach(function(b){b.addEventListener('click',function(){var i=document.getElementById(b.getAttribute('data-pw'));if(!i)return;var pw=i.type==='password';i.type=pw?'text':'password';b.textContent=pw?'🙈':'👁'})});

/* 验证码 */
var cd=0,tm=null,sb=document.getElementById('sCode'),pi=document.getElementById('pp'),ch=document.getElementById('ch');
function ub(){sb.disabled=cd>0;sb.textContent=cd>0?cd+'s后重发':'获取验证码'}
sb.addEventListener('click',function(){var p=pi.value.trim().replace(/\D/g,'');if(!/^1\d{10}$/.test(p)){ch.textContent='请输入正确的11位手机号';ch.className='ahint is-err';return}if(cd>0)return;sb.disabled=true;sb.textContent='发送中...';ch.textContent='';ch.className='ahint';
fetch(ctx+'/auth?action=sendCode&phone='+encodeURIComponent(p),{headers:{'Accept':'application/json'}}).then(function(r){return r.json()}).then(function(d){if(d.ok){ch.textContent='✓ 验证码已发送，请在IDEA控制台查看';ch.className='ahint is-ok';cd=60;ub();tm=setInterval(function(){cd--;ub();if(cd<=0){clearInterval(tm);tm=null}},1000)}else{ch.textContent=d.msg||'发送失败';ch.className='ahint is-err';sb.disabled=false;sb.textContent='获取验证码'}})});
pi.addEventListener('input',function(){this.value=this.value.replace(/\D/g,'')});
document.getElementById('rp').addEventListener('input',function(){this.value=this.value.replace(/\D/g,'')});

/* 注册用户名 */
var rf=document.querySelector('[data-ap="register"]'),ui=document.getElementById('ru'),us=document.getElementById('us'),lc='',le=false,pt=null;
function rs(s,t){us.textContent=t||'';us.className='ahint';ui.classList.remove('is-ok','is-err');if(s==='err'){us.classList.add('is-err');ui.classList.add('is-err')}if(s==='ok'){us.classList.add('is-ok');ui.classList.add('is-ok')}}
async function cu(){var u=ui.value.trim();lc=u;le=false;if(!u){rs('','');return true}if(u.length<4||u.length>20){rs('err','用户名长度应为4到20位');return false}rs('','正在检查...');try{var r=await fetch(ctx+'/auth?action=checkUsername&username='+encodeURIComponent(u),{headers:{'Accept':'application/json'}});var d=await r.json();le=!!d.exists;if(le){rs('err','此用户名已存在');return false}rs('ok','✓ 用户名可以使用');return true}catch(e){rs('err','检查失败，请稍后再试');return false}}
if(ui){ui.addEventListener('input',function(){rs('','');if(pt)clearTimeout(pt);pt=setTimeout(cu,350)});ui.addEventListener('blur',function(){if(pt)clearTimeout(pt);cu()})}
if(rf){rf.addEventListener('submit',async function(e){var u=ui.value.trim();if(!u)return;if(u!==lc||!us.textContent){var ok=await cu();if(!ok){e.preventDefault()}return}if(le){e.preventDefault();rs('err','此用户名已存在')}})}

/* 粒子Canvas */
var cv=document.getElementById('arParticles'),cx=cv.getContext('2d'),pts=[];
function rz(){cv.width=window.innerWidth;cv.height=window.innerHeight}rz();window.addEventListener('resize',rz);
for(var i=0;i<120;i++)pts.push({x:Math.random()*cv.width,y:Math.random()*cv.height,vx:(Math.random()-.5)*.6,vy:(Math.random()-.5)*.5,r:Math.random()*2.5+.6,a:Math.random()*.45+.15,c:['#27AE60','#5b9bd5','#7c3aed','#f59e0b','#10b981','#6366f1'][Math.floor(Math.random()*6)]});
(function dr(){cx.clearRect(0,0,cv.width,cv.height);for(var i=0;i<pts.length;i++){var p=pts[i];cx.beginPath();cx.arc(p.x,p.y,p.r,0,Math.PI*2);cx.fillStyle=p.c;cx.globalAlpha=p.a;cx.fill();p.x+=p.vx;p.y+=p.vy;if(p.x<-10)p.x=cv.width+10;if(p.x>cv.width+10)p.x=-10;if(p.y<-10)p.y=cv.height+10;if(p.y>cv.height+10)p.y=-10}cx.globalAlpha=1;
for(var i=0;i<pts.length;i++){for(var j=i+1;j<pts.length;j++){var dx=pts[i].x-pts[j].x,dy=pts[i].y-pts[j].y,dist=Math.sqrt(dx*dx+dy*dy);if(dist<100){cx.beginPath();cx.moveTo(pts[i].x,pts[i].y);cx.lineTo(pts[j].x,pts[j].y);cx.strokeStyle='rgba(255,255,255,'+(.06*(1-dist/100))+')';cx.lineWidth=.5;cx.stroke()}}}requestAnimationFrame(dr)})();
})();
</script>
</body>
</html>

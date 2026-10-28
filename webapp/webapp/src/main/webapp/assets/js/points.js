/* ===== 志愿星河 - 积分系统通用工具 ===== */
(function(){
  var STORAGE_KEY = 'volstar_points';
  var CHECKIN_KEY = 'volstar_checkin_date';
  var ORDERS_KEY = 'volstar_orders';
  var STREAK_KEY = 'volstar_checkin_streak';
  var WISHLIST_KEY = 'volstar_wishlist';
  var EXCHANGES_KEY = 'volstar_recent_exchanges';
  var ctx = window.APP_CONTEXT_PATH || '.';

  /* ----- 基础存储 ----- */
  function getStore(){ try{var d=localStorage.getItem(STORAGE_KEY);return d?JSON.parse(d):null}catch(e){return null} }
  function setStore(s){ try{localStorage.setItem(STORAGE_KEY,JSON.stringify(s))}catch(e){} }

  function initStore(){
    var s = getStore();
    if(!s){
      s = { points: 0, history: [], level: '新星志愿者', levelNum: 1 };
      setStore(s);
    }
    // 根据积分自动更新等级
    var p = s.points || 0;
    var newLevel, newLevelNum;
    if(p >= 2000){ newLevel = '传奇志愿者'; newLevelNum = 6; }
    else if(p >= 1500){ newLevel = '钻石志愿者'; newLevelNum = 5; }
    else if(p >= 1000){ newLevel = '黄金志愿者'; newLevelNum = 4; }
    else if(p >= 500){ newLevel = '白银志愿者'; newLevelNum = 3; }
    else if(p >= 200){ newLevel = '青铜志愿者'; newLevelNum = 2; }
    else { newLevel = '新星志愿者'; newLevelNum = 1; }
    if(s.level !== newLevel){ s.level = newLevel; s.levelNum = newLevelNum; setStore(s); }
    return s;
  }

  /* ----- 订单存储 ----- */
  function getOrders(){ try{var d=localStorage.getItem(ORDERS_KEY);return d?JSON.parse(d):[]}catch(e){return[]} }
  function saveOrders(o){ try{localStorage.setItem(ORDERS_KEY,JSON.stringify(o))}catch(e){} }

  /* ----- 签到日期存储 ----- */
  function getCheckinDate(){ try{return localStorage.getItem(CHECKIN_KEY)}catch(e){return null} }
  function setCheckinDate(d){ try{localStorage.setItem(CHECKIN_KEY,d)}catch(e){} }

  /* ----- 连续签到存储 ----- */
  function getStreakData(){ try{var d=localStorage.getItem(STREAK_KEY);return d?JSON.parse(d):{streak:0,lastDate:''}}catch(e){return{streak:0,lastDate:''}} }
  function saveStreakData(s){ try{localStorage.setItem(STREAK_KEY,JSON.stringify(s))}catch(e){} }

  /* ----- 心愿单存储 ----- */
  function getWishlistData(){ try{var d=localStorage.getItem(WISHLIST_KEY);return d?JSON.parse(d):[]}catch(e){return[]} }
  function saveWishlistData(w){ try{localStorage.setItem(WISHLIST_KEY,JSON.stringify(w))}catch(e){} }

  /* ----- 最近兑换动态存储 ----- */
  function getExchangesData(){ try{var d=localStorage.getItem(EXCHANGES_KEY);return d?JSON.parse(d):null}catch(e){return null} }
  function saveExchangesData(e){ try{localStorage.setItem(EXCHANGES_KEY,JSON.stringify(e))}catch(e){} }

  /* ----- 日期工具 ----- */
  function todayStr(){ var d=new Date(); return d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate() }
  function getYesterdayStr(){
    var d = new Date();
    d.setDate(d.getDate() - 1);
    return d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate();
  }

  /* ----- 连续签到奖励计算 ----- */
  function calcStreakBonus(streakDay){
    if(streakDay >= 10) return 8;
    if(streakDay >= 7) return 5;
    if(streakDay >= 5) return 3;
    if(streakDay >= 3) return 2;
    return 0;
  }

  /* 获取当前等级颜色 */
  function levelColor(lv){
    var map={6:'#e74c3c',5:'#7c3aed',4:'#f59e0b',3:'#9ca3af',2:'#d97706',1:'#27ae60'};
    return map[lv]||'#27ae60';
  }

  /* ===== 基础查询 API ===== */
  window.getUserPoints = function(){ var s=initStore(); return s.points||0 };
  window.getUserLevel = function(){ var s=initStore(); return s.level||'新星志愿者' };
  window.getUserLevelNum = function(){ var s=initStore(); return s.levelNum||1 };
  window.getUserLevelColor = function(){ return levelColor(window.getUserLevelNum()) };
  window.getPointsHistory = function(){ var s=initStore(); return (s.history||[]).slice(-20).reverse() };
  window.getUserOrders = function(){ return getOrders(); };

  /* ===== 增加积分 ===== */
  window.addPoints = function(amount, reason){
    amount = Number(amount) || 0;
    if(amount <= 0) return;
    var s = initStore();
    s.points = (s.points||0) + amount;
    s.history = s.history || [];
    s.history.push({amount: amount, reason: reason, time: new Date().toISOString()});
    // 保留最近200条记录
    if(s.history.length > 200) s.history = s.history.slice(-200);
    initStore(); // 重新计算等级
    setStore(s);
    // 显示提示
    showPointsToast(amount, reason);
    // 触发自定义事件
    try{ window.dispatchEvent(new CustomEvent('pointsUpdated', {detail:{points:s.points,level:s.level}})) }catch(e){}
  };

  /* 积分 Toast 提示 */
  function showPointsToast(amount, reason){
    var existing = document.getElementById('ptsToast');
    if(existing) existing.remove();
    var toast = document.createElement('div');
    toast.id = 'ptsToast';
    toast.style.cssText = 'position:fixed;top:24px;left:50%;transform:translateX(-50%);z-index:99999;'+
      'background:linear-gradient(135deg,#7c3aed,#a855f7);color:#fff;padding:12px 24px;border-radius:14px;'+
      'font-size:.9rem;font-weight:600;box-shadow:0 6px 24px rgba(124,58,237,.4);'+
      'display:flex;align-items:center;gap:10px;animation:ptsSlideIn .4s ease,ptsSlideOut .4s ease 1.6s forwards;pointer-events:none';
    var style = document.createElement('style');
    style.textContent = '@keyframes ptsSlideIn{from{opacity:0;transform:translateX(-50%) translateY(-20px)}to{opacity:1;transform:translateX(-50%) translateY(0)}}@keyframes ptsSlideOut{from{opacity:1;transform:translateX(-50%) translateY(0)}to{opacity:0;transform:translateX(-50%) translateY(-20px)}}';
    document.head.appendChild(style);
    toast.innerHTML = '<span style="font-size:1.3rem;">⭐</span><span>+'+amount+' 积分</span><span style="font-weight:400;opacity:.8;font-size:.8rem;">'+reason+'</span>';
    document.body.appendChild(toast);
    setTimeout(function(){ if(toast.parentNode) toast.remove(); if(style.parentNode) style.remove(); }, 2200);
  }

  /* ===== 签到功能 ===== */
  window.canCheckin = function(){
    var last = getCheckinDate();
    return last !== todayStr();
  };

  window.doCheckin = function(){
    if(!window.canCheckin()) return false;
    var cfg = (window.VolunteerStarData && window.VolunteerStarData.pointsConfig) ? window.VolunteerStarData.pointsConfig : {checkIn:5};

    // 计算连续签到奖励
    var streakData = getStreakData();
    var today = todayStr();
    var yesterday = getYesterdayStr();
    var bonus = 0;

    if(streakData.lastDate === yesterday){
      // 连续签到
      streakData.streak += 1;
    } else if(streakData.lastDate === today){
      // 今天已签到（理论上不会走到这里，因为 canCheckin 已做判断）
      streakData.streak = streakData.streak || 1;
    } else {
      // 签到中断，重新开始
      streakData.streak = 1;
    }

    bonus = calcStreakBonus(streakData.streak);
    streakData.lastDate = today;
    saveStreakData(streakData);

    setCheckinDate(today);

    var totalPoints = cfg.checkIn + bonus;
    var reason = '每日签到';
    if(bonus > 0){
      reason = '每日签到（连续' + streakData.streak + '天，额外奖励+' + bonus + '）';
    }

    window.addPoints(totalPoints, reason);
    return true;
  };

  /* ===== 连续签到查询 API ===== */
  window.getCheckinStreak = function(){
    var streakData = getStreakData();
    var today = todayStr();
    // 如果最后签到日期不是今天也不是昨天，说明签到已中断
    if(streakData.lastDate !== today && streakData.lastDate !== getYesterdayStr()){
      return 0;
    }
    return streakData.streak || 0;
  };

  window.getCheckinWeekData = function(){
    var result = [];
    var streakData = getStreakData();
    var streak = streakData.streak || 0;
    var lastDate = streakData.lastDate;
    var today = todayStr();

    for(var i = 6; i >= 0; i--){
      var d = new Date();
      d.setDate(d.getDate() - i);
      var dateStr = d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate();
      var checked = false;
      var dayBonus = 0;

      if(lastDate && streak > 0){
        // 计算 lastDate 距今天的天数
        var lastD = new Date(lastDate);
        var todayD = new Date(today);
        var daysSinceCheckin = Math.floor((todayD.getTime() - lastD.getTime()) / 86400000);
        // 当前日期距今天 i 天，距 lastDate 为 i - daysSinceCheckin
        var daysFromLast = i - daysSinceCheckin;
        if(daysFromLast >= 0 && daysFromLast < streak){
          checked = true;
          var streakDay = streak - daysFromLast;
          dayBonus = calcStreakBonus(streakDay);
        }
      }

      result.push({date: dateStr, checked: checked, bonus: dayBonus});
    }
    return result;
  };

  /* ===== 商城兑换 ===== */
  window.redeemItem = function(item){
    var s = initStore();
    if(s.points < item.points) return {success:false, msg:'积分不足，还差 '+(item.points - s.points)+' 积分'};
    if(item.stock !== undefined && item.stock <= 0) return {success:false, msg:'该商品已售罄'};
    // 扣减积分
    s.points -= item.points;
    s.history.push({amount: -item.points, reason: '兑换：'+item.name, time: new Date().toISOString()});
    initStore();
    setStore(s);
    // 保存订单
    var orders = getOrders();
    orders.push({id: Date.now(), itemId: item.id, itemName: item.name, points: item.points, image: item.image, time: new Date().toISOString()});
    saveOrders(orders);
    // 更新库存
    if(item.stock !== undefined && item.stock > 0) item.stock--;
    try{ window.dispatchEvent(new CustomEvent('pointsUpdated', {detail:{points:s.points,level:s.level}})) }catch(e){}
    return {success:true, msg:'兑换成功！已扣除 '+item.points+' 积分'};
  };

  /* ===== 签到快捷方法（兼容外部调用） ===== */
  window.handleCheckin = function(){
    return window.doCheckin();
  };

  /* ===== 心愿单 ===== */
  window.getWishlist = function(){
    return getWishlistData();
  };

  window.toggleWishlist = function(itemId){
    var wishlist = getWishlistData();
    var idx = wishlist.indexOf(itemId);
    var added;
    if(idx === -1){
      wishlist.push(itemId);
      added = true;
    } else {
      wishlist.splice(idx, 1);
      added = false;
    }
    saveWishlistData(wishlist);
    return {added: added, isWishlisted: added};
  };

  window.isWishlisted = function(itemId){
    var wishlist = getWishlistData();
    return wishlist.indexOf(itemId) !== -1;
  };

  /* ===== 积分变动明细（全量历史查询） ===== */
  window.getAllPointsHistory = function(){
    var s = initStore();
    return (s.history || []).slice().reverse();
  };

  window.getPointsEarnedThisMonth = function(){
    var s = initStore();
    var now = new Date();
    var thisMonth = now.getFullYear() + '-' + (now.getMonth() + 1);
    var total = 0;
    (s.history || []).forEach(function(h){
      var d = new Date(h.time);
      var hMonth = d.getFullYear() + '-' + (d.getMonth() + 1);
      if(hMonth === thisMonth && h.amount > 0) total += h.amount;
    });
    return total;
  };

  window.getPointsSpentThisMonth = function(){
    var s = initStore();
    var now = new Date();
    var thisMonth = now.getFullYear() + '-' + (now.getMonth() + 1);
    var total = 0;
    (s.history || []).forEach(function(h){
      var d = new Date(h.time);
      var hMonth = d.getFullYear() + '-' + (d.getMonth() + 1);
      if(hMonth === thisMonth && h.amount < 0) total += Math.abs(h.amount);
    });
    return total;
  };

  /* ===== 等级权益 ===== */
  window.getLevelBenefits = function(){
    return {
      1: {
        name: '新星志愿者',
        benefits: ['基础签到奖励', '浏览活动']
      },
      2: {
        name: '青铜志愿者',
        benefits: ['签到奖励+1', '优先报名(部分活动)']
      },
      3: {
        name: '白银志愿者',
        benefits: ['签到奖励+2', '优先报名', '专属头像框']
      },
      4: {
        name: '黄金志愿者',
        benefits: ['签到奖励+3', '优先报名', '2件专属头像框', '时长加倍卡折扣']
      },
      5: {
        name: '钻石志愿者',
        benefits: ['签到奖励+4', '全部优先报名', '3件专属头像框', '商城9折优惠']
      },
      6: {
        name: '传奇志愿者',
        benefits: ['签到奖励+5', '全部优先报名', '全部头像框', '商城8折优惠', '活动组织者权限']
      }
    };
  };

  /* ===== 兑换统计 & 订单查询 ===== */
  window.getAllOrders = function(){
    return getOrders();
  };

  window.getRecentOrders = function(count){
    count = count || 5;
    var orders = getOrders();
    return orders.slice(-count).reverse();
  };

  /* ===== 最近兑换动态（模拟社区兑换动态） ===== */
  function initExchanges(){
    var exchanges = getExchangesData();
    if(!exchanges || exchanges.length === 0){
      var now = Date.now();
      var names = ['张*伟','李*娜','王*明','刘*芳','陈*强','杨*婷','赵*凯','黄*琳','周*豪','吴*静'];
      var items = [
        {itemName:'限时活动门票', points:50},
        {itemName:'志愿徽章', points:30},
        {itemName:'专属头像框', points:80},
        {itemName:'时长加倍卡', points:100},
        {itemName:'志愿证书', points:60},
        {itemName:'活动优先券', points:40},
        {itemName:'纪念T恤', points:120},
        {itemName:'星空手账本', points:45},
        {itemName:'志愿星贴纸套装', points:25},
        {itemName:'咖啡优惠券', points:35}
      ];
      exchanges = [];
      for(var i = 0; i < 10; i++){
        var item = items[i];
        var name = names[i];
        exchanges.push({
          itemName: item.itemName,
          points: item.points,
          time: new Date(now - (i * 3600000 + Math.floor(Math.random() * 7200000))).toISOString(),
          userName: name
        });
      }
      saveExchangesData(exchanges);
    }
    return exchanges;
  }

  window.recentExchanges = initExchanges();

  /* 初始化 */
  initStore();
})();

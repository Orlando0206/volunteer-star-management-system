window.VolunteerStarData = {
  navLinks: [
    { label: "\u9996\u9875", href: "index.jsp" },
    { label: "\u6d3b\u52a8\u4e2d\u5fc3", href: "activities.jsp" },
    { label: "\u70ed\u529b\u5730\u56fe", href: "heatmap.jsp" },
    { label: "\u79ef\u5206\u5546\u57ce", href: "points-mall.jsp" },
    { label: "\u4e2a\u4eba\u4e2d\u5fc3", href: "dashboard.jsp" },
    { label: "\u53d1\u73b0", href: "discover.jsp" }
  ],
  footerLinks: [
    { label: "\u9996\u9875", href: "index.jsp" },
    { label: "\u6d3b\u52a8\u4e2d\u5fc3", href: "activities.jsp" },
    { label: "\u70ed\u529b\u5730\u56fe", href: "heatmap.jsp" },
    { label: "\u79ef\u5206\u5546\u57ce", href: "points-mall.jsp" },
    { label: "\u4e2a\u4eba\u4e2d\u5fc3", href: "dashboard.jsp" },
    { label: "\u540e\u53f0\u7ba1\u7406", href: "admin.jsp" }
  ],
  categories: ["\u5168\u90e8","\u793e\u533a\u670d\u52a1","\u73af\u5883\u4fdd\u62a4","\u6559\u80b2\u5e2e\u6276","\u6587\u660e\u521b\u5efa","\u52a9\u6b8b\u6276\u5f31","\u6587\u5316\u60e0\u6c11"],
  timelineData: [
    { phase:1, title:"\u8d70\u8fd1\u516c\u76ca", subtitle:"\u9700\u6c42\u8c03\u7814", description:"\u8d70\u8bbf\u5b81\u590f\u591a\u5bb6\u516c\u76ca\u7ec4\u7ec7\uff0c\u8c03\u7814\u5fd7\u613f\u8005\u7ba1\u7406\u75db\u70b9\u3002\u53d1\u73b0\u4f20\u7edf\u4eba\u5de5\u7ba1\u7406\u5bfc\u81f4\u4fe1\u606f\u5206\u6563\u3001\u62a5\u540d\u7e41\u7410\u3001\u65f6\u957f\u6838\u5b9e\u56f0\u96be\u3002", dayRange:"Day 1-10" },
    { phase:2, title:"\u4ece\u84dd\u56fe\u5230\u67b6\u6784", subtitle:"\u7cfb\u7edf\u8bbe\u8ba1", description:"\u5b8c\u6210\u6570\u636e\u5e93\u8bbe\u8ba1\uff0c12\u5f20\u4e1a\u52a1\u8868\u786e\u4fdd\u6570\u636e\u5b8c\u6574\u6027\u3002\u91c7\u7528MVC\u5206\u5c42\u67b6\u6784\uff0c\u524d\u540e\u7aef\u534f\u4f5c\u65b9\u6848\u6572\u5b9a\u3002", dayRange:"Day 11-20" },
    { phase:3, title:"\u4ee3\u7801\u7f16\u7ec7", subtitle:"\u6838\u5fc3\u5f00\u53d1", description:"\u57fa\u4e8eServlet+MyBatis\u5f00\u53d1\uff0c\u5b9e\u73b0\u6d3b\u52a8\u7ba1\u7406\u3001\u5728\u7ebf\u62a5\u540d\u3001\u7b7e\u5230\u7b7e\u9000\u3001\u65f6\u957f\u8ba4\u8bc1\u7b49\u6838\u5fc3\u6a21\u5757\u3002", dayRange:"Day 21-35" },
    { phase:4, title:"\u6253\u78e8\u7ec6\u8282", subtitle:"\u6d4b\u8bd5\u4f18\u5316", description:"\u529f\u80fd\u6d4b\u8bd5\u4e0e\u5b89\u5168\u6d4b\u8bd5\u5e76\u884c\uff0c\u5bc6\u7801BCrypt\u52a0\u5bc6\u3001\u9632SQL\u6ce8\u5165\u3001\u9632XSS\u653b\u51fb\uff0c\u786e\u4fdd\u7cfb\u7edf\u7a33\u5b9a\u53ef\u9760\u3002", dayRange:"Day 36-45" },
    { phase:5, title:"\u8ba9\u5584\u610f\u6709\u8ff9\u53ef\u5faa", subtitle:"\u4ea4\u4ed8\u7b54\u8fa9", description:"\u7cfb\u7edf\u90e8\u7f72\u4e0a\u7ebf\uff0c\u6f14\u793a\u89c6\u9891\u4e0e\u7b54\u8fa9PPT\u5236\u4f5c\u5b8c\u6210\u3002\u4ece\u6ce8\u518c\u5230\u65f6\u957f\u67e5\u8be2\u7684\u5b8c\u6574\u95ed\u73af\u5b9e\u73b0\u3002", dayRange:"Day 46-50" }
  ],
  activities: [
    {id:1,title:"\u793e\u533a\u656c\u8001\u5fd7\u613f\u670d\u52a1",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e747\u670812\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u8001\u5e74\u6d3b\u52a8\u4e2d\u5fc3",lat:38.478,lng:106.240,enrolled:32,capacity:50,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:2,title:"\u73af\u4fdd\u516c\u76ca\u5f92\u6b65\u6d3b\u52a8",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e747\u670815\u65e5 07:30",location:"\u8d3a\u5170\u5c71\u56fd\u5bb6\u68ee\u6797\u516c\u56ed",lat:38.560,lng:106.350,enrolled:78,capacity:100,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:3,title:"\u7231\u5fc3\u56fe\u4e66\u6350\u8d60\u6574\u7406",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e747\u670818\u65e5 14:00",location:"\u5b81\u590f\u5927\u5b66\u56fe\u4e66\u9986",lat:38.500,lng:106.155,enrolled:30,capacity:30,image:"assets/images/activity-3.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:4,title:"\u57ce\u5e02\u6587\u660e\u4ea4\u901a\u5f15\u5bfc",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e747\u670820\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u4e3b\u8981\u8def\u53e3",lat:38.472,lng:106.290,enrolled:45,capacity:60,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:5,title:"\u76f2\u9053\u6e05\u7406\u5fd7\u613f\u670d\u52a1",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e747\u670822\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u76f2\u9053\u6cbf\u7ebf",lat:38.469,lng:106.285,enrolled:22,capacity:40,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:6,title:"\u4e61\u6751\u652f\u6559\u590f\u4ee4\u8425",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e748\u67081\u65e5 - 8\u670815\u65e5",location:"\u56fa\u539f\u5e02\u539f\u5dde\u533a\u5e0c\u671b\u5c0f\u5b66",lat:38.560,lng:106.280,enrolled:8,capacity:20,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:7,title:"\u57ce\u5e02\u516c\u56ed\u7eff\u5316\u517b\u62a4",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e747\u670825\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u4e2d\u5c71\u516c\u56ed",lat:38.498,lng:106.162,enrolled:56,capacity:80,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:8,title:"\u975e\u9057\u6587\u5316\u8fdb\u793e\u533a",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e747\u670828\u65e5 15:00",location:"\u897f\u590f\u533a\u6587\u5316\u4e2d\u5fc3",lat:38.493,lng:106.150,enrolled:29,capacity:50,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:9,title:"\u5173\u7231\u7559\u5b88\u513f\u7ae5\u5fc3\u7406\u8f85\u5bfc",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e747\u670830\u65e5 09:00",location:"\u7075\u6b66\u5e02\u513f\u7ae5\u798f\u5229\u9662",lat:38.100,lng:106.335,enrolled:11,capacity:25,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:10,title:"\u6e56\u6cca\u5fd7\u613f\u6e05\u6d01\u884c\u52a8",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e748\u67082\u65e5 06:30",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5178\u519c\u6cb3\u6cbf\u5cb8",lat:38.482,lng:106.250,enrolled:34,capacity:60,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:11,title:"\u793e\u533a\u4e49\u8bca\u5065\u5eb7\u5ba3\u4f20",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e748\u67085\u65e5 08:30",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u793e\u533a\u536b\u751f\u670d\u52a1\u4e2d\u5fc3",lat:38.494,lng:106.160,enrolled:18,capacity:30,image:"assets/images/activity-2.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:12,title:"\u6b8b\u75be\u4eba\u5c31\u4e1a\u6280\u80fd\u57f9\u8bad",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e748\u67088\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u6b8b\u8054\u57f9\u8bad\u4e2d\u5fc3",lat:38.476,lng:106.236,enrolled:6,capacity:20,image:"assets/images/activity-3.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:13,title:"\u5c11\u513f\u7f16\u7a0b\u516c\u76ca\u8bfe\u5802",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e748\u670810\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u9752\u5c11\u5e74\u5bab",lat:38.471,lng:106.282,enrolled:15,capacity:25,image:"assets/images/activity-4.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:14,title:"\u5154\u5e74\u975e\u9057\u624b\u5de5\u4f53\u9a8c",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e748\u670812\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u6587\u5316\u9986",lat:38.279,lng:106.255,enrolled:12,capacity:35,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:15,title:"\u52a9\u8001\u667a\u80fd\u624b\u673a\u57f9\u8bad",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e748\u670815\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u793e\u533a\u6d3b\u52a8\u5ba4",lat:38.480,lng:106.245,enrolled:20,capacity:20,image:"assets/images/activity-6.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:16,title:"\u5e9f\u65e7\u7269\u54c1\u521b\u610f\u6539\u9020\u5de5\u4f5c\u574a",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e748\u670818\u65e5 14:30",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u521b\u5ba2\u7a7a\u95f4",lat:38.470,lng:106.278,enrolled:9,capacity:25,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:17,title:"\u793e\u533a\u9632\u8bc8\u9a97\u5ba3\u4f20\u6d3b\u52a8",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e748\u670820\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u4e07\u8fbe\u5e7f\u573a",lat:38.477,lng:106.248,enrolled:38,capacity:50,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:18,title:"\u7275\u624b\u7275\u7231\u6b8b\u5065\u4eb2\u5b50\u8fd0\u52a8\u4f1a",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e748\u670822\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u4f53\u80b2\u9986",lat:38.492,lng:106.153,enrolled:27,capacity:40,image:"assets/images/activity-9.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:19,title:"\u793e\u533a\u7f8e\u98df\u8282\u5fd7\u613f\u670d\u52a1",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e748\u670825\u65e5 17:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u793e\u533a\u5e7f\u573a",lat:38.465,lng:106.295,enrolled:41,capacity:60,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:20,title:"\u56fe\u4e66\u6d41\u52a8\u8f66\u4e0b\u4e61\u6751",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e748\u670828\u65e5 07:30",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u5404\u4e61\u9547\u5c0f\u5b66",lat:38.558,lng:106.345,enrolled:5,capacity:15,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:21,title:"\u793e\u533a\u7eff\u5316\u89d2\u843d\u8ba4\u517b\u8ba1\u5212",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e749\u67081\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5404\u793e\u533a\u7eff\u5316\u5e26",lat:38.473,lng:106.238,enrolled:62,capacity:100,image:"assets/images/activity-3.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:22,title:"\u9752\u5c11\u5e74\u6cd5\u6cbb\u6559\u80b2\u8fdb\u6821\u56ed",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e749\u67083\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u7b2c\u4e00\u4e2d\u5b66",lat:38.282,lng:106.250,enrolled:10,capacity:30,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:23,title:"\u7231\u5fc3\u8863\u7269\u6350\u8d60\u4e0e\u5206\u62e3",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e749\u67085\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u6148\u5584\u8d85\u5e02",lat:38.475,lng:106.242,enrolled:19,capacity:30,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:24,title:"\u793e\u533a\u8001\u5e74\u4eba\u514d\u8d39\u7406\u53d1",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e749\u67088\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u656c\u8001\u9662",lat:38.497,lng:106.158,enrolled:16,capacity:20,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:25,title:"\u4e2d\u79cb\u8282\u793e\u533a\u8054\u6b22\u5fd7\u613f\u8005",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e749\u670812\u65e5 18:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u793e\u533a\u6587\u5316\u5e7f\u573a",lat:38.468,lng:106.292,enrolled:25,capacity:40,image:"assets/images/activity-7.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:26,title:"\u73af\u4fdd\u79d1\u666e\u8fdb\u793e\u533a\u8bb2\u5ea7",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e749\u670815\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u793e\u533a\u4e2d\u5fc3",lat:38.552,lng:106.348,enrolled:7,capacity:30,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:27,title:"\u6821\u56ed\u53cd\u6b3a\u51cc\u5fd7\u613f\u5ba3\u8bb2",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e749\u670818\u65e5 14:30",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u7b2c\u4e8c\u4e2d\u5b66",lat:38.098,lng:106.338,enrolled:22,capacity:35,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:28,title:"\u793e\u533a\u7d27\u6025\u6551\u62a4\u57f9\u8bad",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e749\u670820\u65e5 08:30",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u7ea2\u5341\u5b57\u4f1a\u57f9\u8bad\u57fa\u5730",lat:38.479,lng:106.243,enrolled:33,capacity:45,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:29,title:"\u8001\u5e74\u4eba\u5065\u5eb7\u68c0\u67e5\u5fd7\u613f\u884c",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e749\u670822\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u5404\u793e\u533a\u536b\u751f\u7ad9",lat:38.275,lng:106.254,enrolled:14,capacity:25,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:30,title:"\u9752\u5c11\u5e74\u8bfb\u4e66\u5206\u4eab\u4f1a",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e749\u670825\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5e02\u56fe\u4e66\u9986",lat:38.474,lng:106.244,enrolled:40,capacity:40,image:"assets/images/activity-3.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:31,title:"\u793e\u533a\u5899\u4f53\u5f69\u7ed8\u6d3b\u52a8",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e749\u670828\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u6587\u660e\u793e\u533a\u5c0f\u5df7",lat:38.466,lng:106.280,enrolled:17,capacity:30,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:32,title:"\u6d3b\u52a8\u5e9f\u5f03\u7269\u56de\u6536\u65e5",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7410\u67086\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5404\u793e\u533a\u56de\u6536\u70b9",lat:38.481,lng:106.246,enrolled:48,capacity:80,image:"assets/images/activity-5.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:33,title:"\u56fd\u5e86\u793e\u533a\u6587\u827a\u6c47\u6f14\u5fd7\u613f\u8005",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e7410\u67081\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5e02\u6c11\u5e7f\u573a",lat:38.476,lng:106.247,enrolled:36,capacity:60,image:"assets/images/activity-6.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:34,title:"\u4e92\u8054\u7f51\u53cd\u8bc8\u5fd7\u613f\u5ba3\u4f20\u961f",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e7410\u670810\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u7f51\u4fe1\u529e",lat:38.495,lng:106.156,enrolled:8,capacity:20,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:35,title:"\u5b64\u5be1\u8001\u4eba\u8282\u65e5\u63a2\u671b",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e7410\u670815\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u656c\u8001\u9662",lat:38.556,lng:106.346,enrolled:13,capacity:25,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:36,title:"\u70ed\u529b\u5730\u56fe\u6570\u636e\u91c7\u96c6\u5fd7\u613f\u884c",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e7410\u670820\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u5404\u533a\u57df\u793e\u533a\u670d\u52a1\u7ad9",lat:38.460,lng:106.270,enrolled:4,capacity:12,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:37,title:"\u793e\u533a\u5783\u573e\u5206\u7c7b\u5ba3\u4f20\u65e5",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7410\u670825\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5783\u573e\u5206\u7c7b\u7ad9",lat:38.485,lng:106.235,enrolled:28,capacity:40,image:"assets/images/activity-1.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:38,title:"\u7231\u5fc3\u5348\u9910\u5fd7\u613f\u670d\u52a1",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e747\u670816\u65e5 11:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u7231\u5fc3\u9910\u5385",lat:38.467,lng:106.286,enrolled:15,capacity:20,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:39,title:"\u6691\u671f\u6258\u7ba1\u5fd7\u613f\u670d\u52a1\u73ed",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e748\u67083\u65e5 - 8\u670814\u65e5",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u9752\u5c11\u5e74\u6d3b\u52a8\u4e2d\u5fc3",lat:38.496,lng:106.163,enrolled:12,capacity:20,image:"assets/images/activity-3.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:40,title:"\u516c\u56ed\u6587\u660e\u529d\u5bfc\u5fd7\u613f\u5c97",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e748\u670810\u65e5 07:30",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u9605\u6d77\u516c\u56ed",lat:38.490,lng:106.230,enrolled:18,capacity:30,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:41,title:"\u516c\u76ca\u4e66\u6cd5\u6559\u5b66\u8bfe\u5802",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e748\u670815\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u4e66\u753b\u9662",lat:38.470,lng:106.283,enrolled:9,capacity:25,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:42,title:"\u5fd7\u613f\u8005\u666f\u533a\u670d\u52a1\u65e5",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e748\u670820\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u897f\u590f\u98ce\u60c5\u56ed",lat:38.488,lng:106.220,enrolled:24,capacity:35,image:"assets/images/activity-6.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:43,title:"\u52a9\u6b8b\u65e5\u7231\u5fc3\u4e49\u5356",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e748\u670825\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u6b65\u884c\u8857",lat:38.493,lng:106.152,enrolled:16,capacity:25,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:44,title:"\u793e\u533a\u513f\u7ae5\u5b89\u5168\u6559\u80b2",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e749\u67082\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u513f\u7ae5\u4e4b\u5bb6",lat:38.472,lng:106.288,enrolled:20,capacity:30,image:"assets/images/activity-8.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:45,title:"\u6587\u660e\u517b\u5ba0\u5fd7\u613f\u5ba3\u4f20",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e749\u67085\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5b9d\u6e56\u516c\u56ed",lat:38.472,lng:106.230,enrolled:13,capacity:25,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:46,title:"\u7eff\u8272\u51fa\u884c\u9a91\u884c\u5ba3\u4f20",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e749\u670810\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5317\u4eac\u4e2d\u8def",lat:38.475,lng:106.249,enrolled:42,capacity:60,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:47,title:"\u91cd\u9633\u656c\u8001\u6587\u5316\u6f14\u51fa",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e7410\u670810\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u8001\u5e74\u5927\u5b66",lat:38.498,lng:106.154,enrolled:8,capacity:30,image:"assets/images/activity-2.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:48,title:"\u793e\u533a\u5b89\u5168\u9690\u60a3\u6392\u67e5",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e749\u670812\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u671b\u8fdc\u793e\u533a",lat:38.280,lng:106.256,enrolled:22,capacity:35,image:"assets/images/activity-3.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:49,title:"\u6d41\u52a8\u513f\u7ae5\u8bfe\u540e\u8f85\u5bfc",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e749\u670815\u65e5 - 11\u670815\u65e5",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u5916\u6765\u52a1\u5de5\u5b50\u5973\u5b66\u6821",lat:38.464,lng:106.293,enrolled:7,capacity:15,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:50,title:"\u5b81\u4e1c\u4ea7\u4e1a\u5de5\u4eba\u5fd7\u613f\u65e5",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e749\u670820\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u80fd\u6e90\u5316\u5de5\u57fa\u5730",lat:38.158,lng:106.598,enrolled:12,capacity:25,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:51,title:"\u8d3a\u5170\u5c71\u751f\u6001\u4fee\u590d\u690d\u6811",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7410\u67083\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u8d3a\u5170\u5c71\u4e1c\u9e93",lat:38.565,lng:106.320,enrolled:55,capacity:80,image:"assets/images/activity-6.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:52,title:"\u7231\u5fc3\u7f1d\u8865\u5fd7\u613f\u670d\u52a1\u7ad9",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e7410\u67088\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u4eba\u6c11\u8def\u793e\u533a",lat:38.099,lng:106.342,enrolled:6,capacity:15,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:53,title:"\u6587\u660e\u9910\u684c\u5fd7\u613f\u63a8\u5e7f",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e7410\u670812\u65e5 11:30",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u5927\u5b66\u57ce\u7f8e\u98df\u8857",lat:38.500,lng:106.148,enrolled:26,capacity:40,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:54,title:"\u6c11\u4fd7\u6587\u5316\u8282\u5fd7\u613f\u670d\u52a1",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e7410\u670816\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u9f13\u697c\u5e7f\u573a",lat:38.469,lng:106.287,enrolled:31,capacity:50,image:"assets/images/activity-9.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:55,title:"\u793e\u533a\u75ab\u82d7\u5fd7\u613f\u534f\u52a9",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e7410\u670818\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u65b9\u8231\u63a5\u79cd\u70b9",lat:38.491,lng:106.157,enrolled:19,capacity:25,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:56,title:"\u9752\u5c11\u5e74\u79d1\u6280\u4f53\u9a8c\u8425",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e7410\u670822\u65e5 09:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u79d1\u6280\u9986",lat:38.478,lng:106.239,enrolled:23,capacity:30,image:"assets/images/activity-2.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:57,title:"\u6c99\u6e56\u73af\u5883\u6e05\u6d01\u884c\u52a8",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7410\u670825\u65e5 06:30",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u6c99\u6e56\u666f\u533a",lat:38.105,lng:106.345,enrolled:18,capacity:40,image:"assets/images/activity-3.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:58,title:"\u76f2\u4eba\u56fe\u4e66\u9986\u5fd7\u613f\u8005",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e7411\u67083\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u89c6\u969c\u8005\u670d\u52a1\u4e2d\u5fc3",lat:38.480,lng:106.241,enrolled:5,capacity:12,image:"assets/images/activity-4.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:59,title:"\u9ec4\u6cb3\u6e7f\u5730\u4fdd\u62a4\u884c\u52a8",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7411\u67088\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u9ec4\u6cb3\u6e7f\u5730\u516c\u56ed",lat:38.270,lng:106.258,enrolled:30,capacity:55,image:"assets/images/activity-5.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:60,title:"\u793e\u533a\u8bda\u4fe1\u6587\u660e\u5ba3\u8bb2",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e7411\u670812\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5e02\u6c11\u5927\u5385",lat:38.482,lng:106.248,enrolled:11,capacity:25,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:61,title:"\u7231\u5fc3\u4e49\u8bca\u8fdb\u793e\u533a",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e747\u67083\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u793e\u533a\u670d\u52a1\u7ad9",lat:38.475,lng:106.242,enrolled:10,capacity:30,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:62,title:"\u8d3a\u5170\u5c71\u5f92\u6b65\u6e05\u6361",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e747\u67086\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u5e02\u6c11\u5e7f\u573a",lat:38.56,lng:106.325,enrolled:37,capacity:40,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:63,title:"\u7559\u5b88\u513f\u7ae5\u8bfe\u4e1a\u8f85\u5bfc",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e747\u67089\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u6587\u5316\u4e2d\u5fc3",lat:38.47,lng:106.29,enrolled:19,capacity:20,image:"assets/images/activity-3.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:64,title:"\u6587\u660e\u4ea4\u901a\u529d\u5bfc\u884c\u52a8",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e747\u670812\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u5fd7\u613f\u670d\u52a1\u7ad9",lat:38.495,lng:106.152,enrolled:21,capacity:35,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:65,title:"\u6b8b\u75be\u4eba\u5eb7\u590d\u966a\u4f34",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e747\u670815\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u516c\u56ed\u5317\u95e8",lat:38.272,lng:106.255,enrolled:3,capacity:10,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:66,title:"\u5468\u672b\u516c\u76ca\u7535\u5f71\u653e\u6620",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e747\u670818\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u8857\u9053\u529e",lat:38.475,lng:106.242,enrolled:50,capacity:60,image:"assets/images/activity-6.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:67,title:"\u90bb\u91cc\u5b88\u671b\u52a9\u8001\u670d\u52a1",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e747\u670821\u65e5 13:30",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u8001\u5e74\u6d3b\u52a8\u4e2d\u5fc3",lat:38.102,lng:106.34,enrolled:11,capacity:15,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:68,title:"\u5b81\u4e1c\u5de5\u4e1a\u56ed\u533a\u7eff\u690d",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e747\u670824\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u5b66\u6821\u64cd\u573a",lat:38.15,lng:106.56,enrolled:25,capacity:25,image:"assets/images/activity-8.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:69,title:"\u6691\u671f\u79d1\u666e\u590f\u4ee4\u8425",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e747\u670827\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u5546\u4e1a\u8857\u5e7f\u573a",lat:38.56,lng:106.325,enrolled:22,capacity:35,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:70,title:"\u793e\u533a\u697c\u9053\u6742\u7269\u6e05\u7406",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e747\u670830\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u56fe\u4e66\u9986",lat:38.495,lng:106.152,enrolled:16,capacity:20,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:71,title:"\u76f2\u4eba\u9605\u8bfb\u966a\u4f34\u8ba1\u5212",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e748\u67083\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u4f53\u80b2\u9986",lat:38.47,lng:106.29,enrolled:8,capacity:12,image:"assets/images/activity-2.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:72,title:"\u4f20\u7edf\u620f\u66f2\u8fdb\u4e61\u6751",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e748\u67086\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u6e7f\u5730\u4fdd\u62a4\u533a",lat:38.272,lng:106.255,enrolled:14,capacity:45,image:"assets/images/activity-3.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:73,title:"\u793e\u533a\u4e49\u52a1\u7406\u53d1\u65e5",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e748\u67089\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5de5\u4e1a\u56ed\u533a",lat:38.475,lng:106.242,enrolled:20,capacity:20,image:"assets/images/activity-4.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:74,title:"\u9ec4\u6cb3\u5cb8\u8fb9\u690d\u7eff\u62a4\u7eff",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e748\u670812\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u751f\u6001\u56ed",lat:38.102,lng:106.34,enrolled:34,capacity:50,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:75,title:"\u5927\u5b66\u751f\u652f\u6559\u4e61\u6751\u884c",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e748\u670815\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u6751\u59d4\u4f1a\u5e7f\u573a",lat:38.56,lng:106.325,enrolled:35,capacity:40,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:76,title:"\u6587\u660e\u517b\u5ba0\u5ba3\u4f20\u5468",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e748\u670818\u65e5 13:30",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u519c\u8d38\u5e02\u573a",lat:38.495,lng:106.152,enrolled:20,capacity:25,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:77,title:"\u5b64\u5be1\u8001\u4eba\u6696\u5fc3\u966a\u4f34",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e748\u670821\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u793e\u533a\u670d\u52a1\u7ad9",lat:38.47,lng:106.29,enrolled:9,capacity:15,image:"assets/images/activity-8.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:78,title:"\u793e\u533a\u4e66\u753b\u827a\u672f\u5c55",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e748\u670824\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5e02\u6c11\u5e7f\u573a",lat:38.475,lng:106.242,enrolled:17,capacity:35,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:79,title:"\u5b81\u4e1c\u591c\u5e02\u6587\u660e\u7763\u5bfc",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e748\u670827\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u6587\u5316\u4e2d\u5fc3",lat:38.15,lng:106.56,enrolled:9,capacity:20,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:80,title:"\u793e\u533a\u6d88\u9632\u5b89\u5168\u5de1\u67e5",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e748\u670830\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u5fd7\u613f\u670d\u52a1\u7ad9",lat:38.272,lng:106.255,enrolled:8,capacity:18,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:81,title:"\u6e7f\u5730\u5019\u9e1f\u76d1\u6d4b\u4fdd\u62a4",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e749\u67083\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u516c\u56ed\u5317\u95e8",lat:38.102,lng:106.34,enrolled:30,capacity:30,image:"assets/images/activity-3.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:82,title:"\u5c11\u513f\u7f16\u7a0b\u516c\u76ca\u8bfe\u5802",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e749\u67086\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u8857\u9053\u529e",lat:38.475,lng:106.242,enrolled:15,capacity:22,image:"assets/images/activity-4.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:83,title:"\u57ce\u5e02\u5c0f\u5e7f\u544a\u6e05\u9664\u65e5",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e749\u67089\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u8001\u5e74\u6d3b\u52a8\u4e2d\u5fc3",lat:38.495,lng:106.152,enrolled:29,capacity:30,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:84,title:"\u8f6e\u6905\u7545\u884c\u65e0\u969c\u788d\u65e5",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e749\u670813\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u5b66\u6821\u64cd\u573a",lat:38.56,lng:106.325,enrolled:11,capacity:12,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:85,title:"\u975e\u9057\u6587\u5316\u4f20\u627f\u4f53\u9a8c",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e749\u670817\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u5546\u4e1a\u8857\u5e7f\u573a",lat:38.47,lng:106.29,enrolled:31,capacity:40,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:86,title:"\u793e\u533a\u5bb6\u7535\u4e49\u52a1\u7ef4\u4fee",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e749\u670821\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u56fe\u4e66\u9986",lat:38.272,lng:106.255,enrolled:8,capacity:15,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:87,title:"\u6e56\u6cca\u6c34\u8d28\u76d1\u6d4b\u884c\u52a8",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e749\u670825\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u4f53\u80b2\u9986",lat:38.475,lng:106.242,enrolled:22,capacity:30,image:"assets/images/activity-9.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:88,title:"\u4f01\u4e1a\u5783\u573e\u5206\u7c7b\u57f9\u8bad",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e749\u670829\u65e5 13:30",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u6e7f\u5730\u4fdd\u62a4\u533a",lat:38.15,lng:106.56,enrolled:14,capacity:25,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:89,title:"\u5916\u8bed\u89d2\u5fd7\u613f\u6559\u5b66",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e7410\u67083\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u5de5\u4e1a\u56ed\u533a",lat:38.495,lng:106.152,enrolled:15,capacity:18,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:90,title:"\u7535\u52a8\u8f66\u4e0a\u724c\u5fd7\u613f\u7ad9",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e7410\u67087\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u751f\u6001\u56ed",lat:38.47,lng:106.29,enrolled:20,capacity:20,image:"assets/images/activity-3.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:91,title:"\u52a9\u6b8b\u624b\u5de5\u827a\u54c1\u4e49\u5356",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e7410\u670811\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u6751\u59d4\u4f1a\u5e7f\u573a",lat:38.475,lng:106.242,enrolled:8,capacity:15,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:92,title:"\u793e\u533a\u8bfb\u4e66\u5206\u4eab\u4f1a",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e7410\u670815\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u519c\u8d38\u5e02\u573a",lat:38.102,lng:106.34,enrolled:21,capacity:25,image:"assets/images/activity-5.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:93,title:"\u51ac\u5b63\u9001\u6e29\u6696\u884c\u52a8",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e7410\u670819\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u793e\u533a\u670d\u52a1\u7ad9",lat:38.56,lng:106.325,enrolled:24,capacity:30,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:94,title:"\u5e9f\u65e7\u7535\u6c60\u56de\u6536\u65e5",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7410\u670822\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u5e02\u6c11\u5e7f\u573a",lat:38.495,lng:106.152,enrolled:12,capacity:20,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:95,title:"\u9752\u5c11\u5e74\u5fc3\u7406\u8f85\u5bfc",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e7410\u670825\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u6587\u5316\u4e2d\u5fc3",lat:38.47,lng:106.29,enrolled:15,capacity:15,image:"assets/images/activity-8.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:96,title:"\u793e\u533a\u6587\u660e\u516c\u7ea6\u5ba3\u4f20",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e7410\u670828\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u5fd7\u613f\u670d\u52a1\u7ad9",lat:38.272,lng:106.255,enrolled:20,capacity:25,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:97,title:"\u542c\u969c\u4eba\u58eb\u624b\u8bed\u7ffb\u8bd1",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e7410\u670831\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u516c\u56ed\u5317\u95e8",lat:38.15,lng:106.56,enrolled:7,capacity:10,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:98,title:"\u8fce\u65b0\u6625\u6587\u827a\u6c47\u6f14",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e7411\u67084\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u8857\u9053\u529e",lat:38.475,lng:106.242,enrolled:40,capacity:50,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:99,title:"\u793e\u533a\u517b\u8001\u670d\u52a1\u9700\u6c42\u8c03\u7814",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e7411\u67087\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u8001\u5e74\u6d3b\u52a8\u4e2d\u5fc3",lat:38.102,lng:106.34,enrolled:7,capacity:18,image:"assets/images/activity-3.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:100,title:"\u5927\u6f20\u73af\u4fdd\u5fd7\u613f\u884c",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7411\u670811\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u5b66\u6821\u64cd\u573a",lat:38.102,lng:106.34,enrolled:25,capacity:25,image:"assets/images/activity-4.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:101,title:"\u4e2d\u5c0f\u5b66\u79d1\u666e\u8bb2\u5ea7",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e7411\u670815\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u5546\u4e1a\u8857\u5e7f\u573a",lat:38.56,lng:106.325,enrolled:14,capacity:20,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:102,title:"\u8f66\u7a97\u629b\u7269\u6587\u660e\u529d\u5bfc",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e7411\u670819\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u56fe\u4e66\u9986",lat:38.475,lng:106.242,enrolled:14,capacity:25,image:"assets/images/activity-6.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:103,title:"\u6b8b\u969c\u513f\u7ae5\u827a\u672f\u8bfe\u5802",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e7411\u670823\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u4f53\u80b2\u9986",lat:38.47,lng:106.29,enrolled:5,capacity:10,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:104,title:"\u4e61\u6751\u6587\u5316\u5927\u9662\u5de1\u6f14",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e7411\u670826\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u6e7f\u5730\u4fdd\u62a4\u533a",lat:38.272,lng:106.255,enrolled:27,capacity:40,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:105,title:"\u5b81\u4e1c\u5de5\u4eba\u5b50\u5973\u6258\u7ba1",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e7411\u670830\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u5de5\u4e1a\u56ed\u533a",lat:38.15,lng:106.56,enrolled:11,capacity:15,image:"assets/images/activity-9.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:106,title:"\u793e\u533a\u5171\u4eab\u82b1\u56ed\u5efa\u8bbe",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e7412\u67084\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u751f\u6001\u56ed",lat:38.495,lng:106.152,enrolled:19,capacity:25,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:107,title:"\u7981\u5851\u73af\u4fdd\u5fd7\u613f\u5ba3\u4f20",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7412\u67088\u65e5 13:30",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u6751\u59d4\u4f1a\u5e7f\u573a",lat:38.475,lng:106.242,enrolled:29,capacity:30,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:108,title:"\u8001\u5e74\u4eba\u667a\u80fd\u673a\u6559\u5b66",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2026\u5e7412\u670811\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u519c\u8d38\u5e02\u573a",lat:38.102,lng:106.34,enrolled:12,capacity:12,image:"assets/images/activity-3.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:109,title:"\u516c\u5171\u533a\u57df\u70df\u5934\u6e05\u96f6",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2026\u5e7412\u670815\u65e5 13:30",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u793e\u533a\u670d\u52a1\u7ad9",lat:38.47,lng:106.29,enrolled:18,capacity:22,image:"assets/images/activity-4.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:110,title:"\u5eb7\u590d\u8f85\u5177\u514d\u8d39\u79df\u8d41",category:"\u52a9\u6b8b\u6276\u5f31",categoryColor:"#E8634B",date:"2026\u5e7412\u670819\u65e5 07:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u5e02\u6c11\u5e7f\u573a",lat:38.56,lng:106.325,enrolled:7,capacity:10,image:"assets/images/activity-5.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:111,title:"\u65b0\u5e74\u6625\u8054\u9001\u4e07\u5bb6",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2026\u5e7412\u670823\u65e5 08:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u6587\u5316\u4e2d\u5fc3",lat:38.272,lng:106.255,enrolled:39,capacity:50,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:112,title:"\u6625\u8fd0\u5fd7\u613f\u6696\u51ac\u884c\u52a8",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2026\u5e7412\u670827\u65e5 10:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u5fd7\u613f\u670d\u52a1\u7ad9",lat:38.475,lng:106.242,enrolled:30,capacity:35,image:"assets/images/activity-7.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:113,title:"\u8d3a\u5170\u5c71\u9632\u706b\u5de1\u67e5",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2026\u5e7412\u670831\u65e5 14:00",location:"\u94f6\u5ddd\u5e02\u8d3a\u5170\u53bf\u516c\u56ed\u5317\u95e8",lat:38.56,lng:106.325,enrolled:7,capacity:20,image:"assets/images/activity-8.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:114,title:"\u516c\u76ca\u6cd5\u5f8b\u54a8\u8be2\u670d\u52a1",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2027\u5e741\u67084\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u8857\u9053\u529e",lat:38.15,lng:106.56,enrolled:12,capacity:12,image:"assets/images/activity-9.jpg",status:"upcoming",statusLabel:"\u5373\u5c06\u5f00\u59cb"},
    {id:115,title:"\u519c\u8d38\u5e02\u573a\u6587\u660e\u7ba1\u7406",category:"\u6587\u660e\u521b\u5efa",categoryColor:"#F0C14B",date:"2027\u5e741\u67088\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u897f\u590f\u533a\u8001\u5e74\u6d3b\u52a8\u4e2d\u5fc3",lat:38.495,lng:106.152,enrolled:15,capacity:18,image:"assets/images/activity-1.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:116,title:"\u519c\u6751\u7559\u5b88\u8001\u4eba\u5173\u7231",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2027\u5e741\u670811\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u6c38\u5b81\u53bf\u5b66\u6821\u64cd\u573a",lat:38.272,lng:106.255,enrolled:14,capacity:20,image:"assets/images/activity-2.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:117,title:"\u57ce\u5e02\u6cb3\u9053\u5783\u573e\u6253\u635e",category:"\u73af\u5883\u4fdd\u62a4",categoryColor:"#2C3E50",date:"2027\u5e741\u670815\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u5174\u5e86\u533a\u5546\u4e1a\u8857\u5e7f\u573a",lat:38.47,lng:106.29,enrolled:20,capacity:30,image:"assets/images/activity-3.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:118,title:"\u5e7c\u513f\u7ed8\u672c\u9605\u8bfb\u8f85\u5bfc",category:"\u6559\u80b2\u5e2e\u6276",categoryColor:"#5B9BD5",date:"2027\u5e741\u670818\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u91d1\u51e4\u533a\u56fe\u4e66\u9986",lat:38.475,lng:106.242,enrolled:15,capacity:15,image:"assets/images/activity-4.jpg",status:"full",statusLabel:"\u5df2\u6ee1\u5458"},
    {id:119,title:"\u8840\u7ad9\u4e49\u52a1\u732e\u8840\u5ba3\u4f20",category:"\u793e\u533a\u670d\u52a1",categoryColor:"#27AE60",date:"2027\u5e741\u670822\u65e5 09:30",location:"\u94f6\u5ddd\u5e02\u7075\u6b66\u5e02\u4f53\u80b2\u9986",lat:38.102,lng:106.34,enrolled:13,capacity:30,image:"assets/images/activity-5.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"},
    {id:120,title:"\u53e4\u5efa\u7b51\u4fdd\u62a4\u5fd7\u613f\u884c",category:"\u6587\u5316\u60e0\u6c11",categoryColor:"#9B7ED9",date:"2027\u5e741\u670825\u65e5 15:00",location:"\u94f6\u5ddd\u5e02\u5b81\u4e1c\u9547\u6e7f\u5730\u4fdd\u62a4\u533a",lat:38.15,lng:106.56,enrolled:12,capacity:15,image:"assets/images/activity-6.jpg",status:"recruiting",statusLabel:"\u62db\u52df\u4e2d"}
  ],
  testimonials: [
    { name:"\u674e\u660e", role:"\u5b81\u590f\u5927\u5b66\u5927\u4e09\u5b66\u751f", content:"\u901a\u8fc7\u8fd9\u4e2a\u5e73\u53f0\uff0c\u6211\u627e\u5230\u4e86\u5fd7\u540c\u9053\u5408\u7684\u4f19\u4f34\u3002\u6bcf\u6b21\u7b7e\u5230\u7b7e\u9000\u90fd\u81ea\u52a8\u8bb0\u5f55\uff0c\u518d\u4e5f\u4e0d\u7528\u62c5\u5fc3\u5fd7\u613f\u65f6\u957f\u4e22\u5931\u4e86\u3002", avatar:"assets/images/avatar-1.jpg" },
    { name:"\u5f20\u82b3", role:"\u91d1\u51e4\u533a\u5fd7\u613f\u8005\u534f\u4f1a\u8d1f\u8d23\u4eba", content:"\u4ee5\u524d\u7ba1\u7406\u51e0\u767e\u540d\u5fd7\u613f\u8005\u7684\u62a5\u540d\u4fe1\u606f\u8981\u71ac\u597d\u51e0\u4e2a\u901a\u5bb5\uff0c\u73b0\u5728\u5728\u7ebf\u5ba1\u6838\u3001\u6279\u91cf\u5bfc\u51fa\uff0c\u6548\u7387\u63d0\u5347\u592a\u591a\u4e86\u3002", avatar:"assets/images/avatar-2.jpg" },
    { name:"\u738b\u78ca", role:"\u793e\u533a\u5de5\u4f5c\u8005", content:"\u6d3b\u52a8\u7b7e\u5230\u7801\u7684\u8bbe\u8ba1\u7279\u522b\u5b9e\u7528\uff0c\u81ea\u52a8\u751f\u6210\uff0c\u8fd8\u80fd\u8bbe\u7f6e\u6709\u6548\u671f\u3002\u5fd7\u613f\u65f6\u957f\u8ba4\u8bc1\u4e5f\u53d8\u5f97\u900f\u660e\u53ef\u4fe1\u3002", avatar:"assets/images/avatar-3.jpg" }
  ],
  stats: [
    { label:"\u670d\u52a1\u65f6\u957f\u7d2f\u8ba1", value:12580, suffix:"\u5c0f\u65f6", change:"\u2191 23% \u672c\u6708\u65b0\u589e", color:"#27AE60" },
    { label:"\u5e73\u53f0\u6ce8\u518c\u5fd7\u613f\u8005", value:2847, suffix:"\u4eba", change:"\u2191 156 \u672c\u6708\u65b0\u589e", color:"#5B9BD5" },
    { label:"\u7d2f\u8ba1\u516c\u76ca\u6d3b\u52a8", value:186, suffix:"\u573a", change:"\u2191 12 \u672c\u6708\u65b0\u589e", color:"#F0C14B" },
    { label:"\u8986\u76d6\u793e\u533a\u6570\u91cf", value:42, suffix:"\u4e2a", change:"\u2191 5 \u672c\u6708\u65b0\u589e", color:"#E8634B" }
  ],
  regionData: [
    { name:"\u91d1\u51e4\u533a", activityCount:68, participants:2340, totalHours:5280 },
    { name:"\u5174\u5e86\u533a", activityCount:52, participants:1890, totalHours:4120 },
    { name:"\u897f\u590f\u533a", activityCount:35, participants:980, totalHours:2450 },
    { name:"\u8d3a\u5170\u53bf", activityCount:18, participants:420, totalHours:1080 },
    { name:"\u6c38\u5b81\u53bf", activityCount:12, participants:310, totalHours:780 },
    { name:"\u7075\u6b66\u5e02", activityCount:8, participants:156, totalHours:420 },
    { name:"\u5b81\u4e1c\u9547", activityCount:5, participants:89, totalHours:260 }
  ],
  regionCoords: {
    "\u91d1\u51e4\u533a":{x:51,y:26},"\u5174\u5e86\u533a":{x:54,y:24},
    "\u897f\u590f\u533a":{x:45,y:20},"\u8d3a\u5170\u53bf":{x:57,y:8},
    "\u6c38\u5b81\u53bf":{x:51,y:61},"\u7075\u6b66\u5e02":{x:56,y:93},
    "\u5b81\u4e1c\u9547":{x:72,y:82}
  },
  activityTypes: [
    { name:"\u793e\u533a\u670d\u52a1", count:12, color:"#27AE60", percent:"20%" },
    { name:"\u73af\u5883\u4fdd\u62a4", count:13, color:"#2C3E50", percent:"22%" },
    { name:"\u6559\u80b2\u5e2e\u6276", count:11, color:"#5B9BD5", percent:"18%" },
    { name:"\u6587\u660e\u521b\u5efa", count:9, color:"#F0C14B", percent:"15%" },
    { name:"\u52a9\u6b8b\u6276\u5f31", count:9, color:"#E8634B", percent:"15%" },
    { name:"\u6587\u5316\u60e0\u6c11", count:6, color:"#9B7ED9", percent:"10%" }
  ],
  monthlyTrend: [
    { month:"1\u6708", activityCount:18, participants:420, hours:18 },
    { month:"2\u6708", activityCount:25, participants:680, hours:24 },
    { month:"3\u6708", activityCount:35, participants:1020, hours:32 },
    { month:"4\u6708", activityCount:42, participants:1340, hours:45 },
    { month:"5\u6708", activityCount:38, participants:1180, hours:38 },
    { month:"6\u6708", activityCount:28, participants:890, hours:36.5 }
  ],
  dashboard: {
    menuItems:[
      {id:"overview",label:"\u6982\u89c8"},{id:"registrations",label:"\u6211\u7684\u62a5\u540d"},
      {id:"hours",label:"\u65f6\u957f\u660e\u7ec6"},{id:"timeline3d",label:"3D\u5386\u7a0b"},
      {id:"badges",label:"\u6210\u5c31\u5fbd\u7ae0"},{id:"messages",label:"\u6d88\u606f\u901a\u77e5"},
      {id:"settings",label:"\u4e2a\u4eba\u8bbe\u7f6e"}
    ],
    myRegistrations:[
      {id:1,activity:"\u793e\u533a\u656c\u8001\u5fd7\u613f\u670d\u52a1",date:"2025-06-10",status:"approved"},
      {id:2,activity:"\u73af\u4fdd\u516c\u76ca\u5f92\u6b65\u6d3b\u52a8",date:"2025-06-08",status:"pending"},
      {id:3,activity:"\u7231\u5fc3\u56fe\u4e66\u6350\u8d60\u6574\u7406",date:"2025-06-05",status:"completed"},
      {id:4,activity:"\u57ce\u5e02\u6587\u660e\u4ea4\u901a\u5f15\u5bfc",date:"2025-06-01",status:"completed"},
      {id:5,activity:"\u76f2\u9053\u6e05\u7406\u5fd7\u613f\u670d\u52a1",date:"2025-05-28",status:"cancelled"}
    ],
    hoursSourceData:[
      {name:"\u7b7e\u5230\u81ea\u52a8",value:70,color:"#27AE60"},
      {name:"\u7ba1\u7406\u5458\u5f55\u5165",value:20,color:"#2C3E50"},
      {name:"\u81ea\u4e3b\u7533\u8bf7",value:10,color:"#F0C14B"}
    ],
    hoursDetail:[
      {id:1,activity:"\u793e\u533a\u656c\u8001\u5fd7\u613f\u670d\u52a1",source:"\u7b7e\u5230\u81ea\u52a8",hours:6,date:"2025-06-15",note:""},
      {id:2,activity:"\u73af\u4fdd\u516c\u76ca\u5f92\u6b65\u6d3b\u52a8",source:"\u7b7e\u5230\u81ea\u52a8",hours:4.5,date:"2025-06-10",note:""},
      {id:3,activity:"\u7231\u5fc3\u56fe\u4e66\u6350\u8d60\u6574\u7406",source:"\u7b7e\u5230\u81ea\u52a8",hours:3,date:"2025-06-05",note:""},
      {id:4,activity:"\u57ce\u5e02\u6587\u660e\u4ea4\u901a\u5f15\u5bfc",source:"\u7b7e\u5230\u81ea\u52a8",hours:2,date:"2025-06-01",note:""},
      {id:5,activity:"\u793e\u533a\u65b0\u6625\u8054\u6b22",source:"\u7ba1\u7406\u5458\u5f55\u5165",hours:8,date:"2025-01-20",note:"\u6625\u8282\u7279\u522b\u6d3b\u52a8"},
      {id:6,activity:"\u7231\u5fc3\u56fe\u4e66\u6350\u8d60\u6574\u7406",source:"\u81ea\u4e3b\u7533\u8bf7",hours:3,date:"2025-03-15",note:"\u8865\u5f55\u7533\u8bf7\u5df2\u901a\u8fc7"}
    ],
    messages:[
      {id:1,type:"system",title:"\u7cfb\u7edf\u901a\u77e5",content:"\u6b22\u8fce\u52a0\u5165\u5fd7\u613f\u661f\u6cb3\uff0c\u5f00\u59cb\u4f60\u7684\u516c\u76ca\u4e4b\u65c5\uff01",date:"2025-06-20",read:true},
      {id:2,type:"review",title:"\u62a5\u540d\u5ba1\u6838\u7ed3\u679c",content:"\u60a8\u62a5\u540d\u7684\u300c\u73af\u4fdd\u516c\u76ca\u5f92\u6b65\u6d3b\u52a8\u300d\u5df2\u901a\u8fc7\u5ba1\u6838\uff0c\u8bf7\u51c6\u65f6\u53c2\u52a0\u3002",date:"2025-06-18",read:false},
      {id:3,type:"reminder",title:"\u6d3b\u52a8\u63d0\u9192",content:"\u300c\u793e\u533a\u656c\u8001\u5fd7\u613f\u670d\u52a1\u300d\u5c06\u4e8e\u660e\u5929\u4e0a\u53489\u70b9\u5f00\u59cb\uff0c\u8bf7\u63d0\u524d\u5230\u8fbe\u3002",date:"2025-06-14",read:false},
      {id:4,type:"review",title:"\u65f6\u957f\u5ba1\u6838\u7ed3\u679c",content:"\u60a8\u7684\u65f6\u957f\u7533\u8bf7\u300c\u7231\u5fc3\u56fe\u4e66\u6350\u8d60\u6574\u7406 3\u5c0f\u65f6\u300d\u5df2\u5ba1\u6838\u901a\u8fc7\u3002",date:"2025-06-12",read:true}
    ],
    badges:[
      {name:"\u521d\u7ea7\u5fd7\u613f\u8005",detail:"\u7d2f\u8ba1\u65f6\u957f 10 \u5c0f\u65f6",color:"#27AE60"},
      {name:"\u73af\u4fdd\u5148\u950b",detail:"\u5b8c\u6210 3 \u573a\u73af\u4fdd\u6d3b\u52a8",color:"#5B9BD5"},
      {name:"\u793e\u533a\u6696\u661f",detail:"\u8fde\u7eed\u53c2\u4e0e 5 \u573a\u793e\u533a\u670d\u52a1",color:"#F0C14B"}
    ]
  },
  admin: {
    sidebarGroups: [
      { title:"\u6982\u89c8", items:[{id:"dashboard",label:"\u4eea\u8868\u76d8"}] },
      { title:"\u7ba1\u7406", items:[{id:"activities",label:"\u6d3b\u52a8\u7ba1\u7406"},{id:"reviews",label:"\u62a5\u540d\u5ba1\u6838"},{id:"users",label:"\u7528\u6237\u7ba1\u7406"},{id:"hours",label:"\u65f6\u957f\u7ba1\u7406"}] },
      { title:"\u7cfb\u7edf", items:[{id:"statistics",label:"\u6570\u636e\u7edf\u8ba1"},{id:"settings",label:"\u7cfb\u7edf\u8bbe\u7f6e"},{id:"logs",label:"\u64cd\u4f5c\u65e5\u5fd7"}] }
    ],
    topVolunteers: [
      { name:"\u738b\u78ca", hours:8.5, avatar:"assets/images/avatar-3.jpg" },
      { name:"\u674e\u660e", hours:7.0, avatar:"assets/images/avatar-1.jpg" },
      { name:"\u5f20\u82b3", hours:6.5, avatar:"assets/images/avatar-2.jpg" },
      { name:"\u8d75\u4f1f", hours:6.0, avatar:"" },
      { name:"\u5b59\u4e3d", hours:5.5, avatar:"" },
      { name:"\u5218\u5a77", hours:5.0, avatar:"" },
      { name:"\u5468\u6770", hours:4.5, avatar:"" },
      { name:"\u5434\u9759", hours:4.0, avatar:"" },
      { name:"\u90d1\u6d69", hours:3.5, avatar:"" },
      { name:"\u9648\u96ea", hours:3.0, avatar:"" }
    ],
    feedItems: [
      { time:"\u521a\u521a", user:"\u5f20\u660e", action:"\u62a5\u540d\u4e86\u300c\u793e\u533a\u656c\u8001\u5fd7\u613f\u670d\u52a1\u300d", type:"\u62a5\u540d", color:"#27AE60" },
      { time:"1\u5206\u949f\u524d", user:"\u674e\u82b3", action:"\u7b7e\u5230\u300c\u73af\u4fdd\u516c\u76ca\u5f92\u6b65\u6d3b\u52a8\u300d", type:"\u7b7e\u5230", color:"#5B9BD5" },
      { time:"2\u5206\u949f\u524d", user:"\u738b\u5f3a", action:"\u5b8c\u6210\u670d\u52a1\uff0c\u83b7\u5f97 6 \u5c0f\u65f6\u65f6\u957f", type:"\u5b8c\u6210", color:"#F0C14B" }
    ],
    reviewList: [
      {id:1,name:"\u5f20\u660e",activity:"\u73af\u4fdd\u516c\u76ca\u5f92\u6b65\u6d3b\u52a8",date:"2025-06-20",phone:"138****1234"},
      {id:2,name:"\u674e\u82b3",activity:"\u793e\u533a\u656c\u8001\u5fd7\u613f\u670d\u52a1",date:"2025-06-19",phone:"139****5678"}
    ],
    users: [
      {id:1,name:"\u674e\u660e",phone:"138****1234",hours:128,status:"active",avatar:"assets/images/avatar-1.jpg"},
      {id:2,name:"\u5f20\u82b3",phone:"139****5678",hours:96,status:"active",avatar:"assets/images/avatar-2.jpg"}
    ],
    logs: [
      {time:"2025-06-21 10:30:15",user:"admin",action:"\u5ba1\u6838\u901a\u8fc7\u62a5\u540d",detail:"\u5f20\u660e \u2192 \u73af\u4fdd\u516c\u76ca\u5f92\u6b65",ip:"192.168.1.1"}
    ]
  },
  discover: {
    detailText: "\u672c\u6b21\u6d3b\u52a8\u65e8\u5728\u670d\u52a1\u793e\u533a\uff0c\u4f20\u9012\u7231\u5fc3\u3002\u6d3b\u52a8\u8fc7\u7a0b\u4e2d\u5c06\u6709\u4e13\u4e1a\u8d1f\u8d23\u4eba\u5168\u7a0b\u6307\u5bfc\uff0c\u786e\u4fdd\u6bcf\u4f4d\u5fd7\u613f\u8005\u90fd\u80fd\u5b89\u5168\u3001\u6709\u6548\u5730\u53c2\u4e0e\u670d\u52a1\u3002"
  },
  timeline3d: {
    events: [
      {id:1,date:"2025-01-15",title:"\u6ce8\u518c\u5fd7\u613f\u661f\u6cb3",type:"milestone",hours:0,totalHours:0,location:"\u5b81\u590f\u5927\u5b66",color:"#5B9BD5",desc:"\u5f00\u542f\u516c\u76ca\u4e4b\u65c5\u7684\u7b2c\u4e00\u6b65"},
      {id:5,date:"2025-03-15",title:"\u7231\u5fc3\u56fe\u4e66\u6350\u8d60\u6574\u7406",type:"activity",hours:3,totalHours:16,location:"\u5b81\u590f\u5927\u5b66\u56fe\u4e66\u9986",color:"#27AE60",desc:"\u6574\u7406\u5206\u7c7b\u6350\u8d60\u56fe\u4e66"}
    ]
  },
  coords: {
    1:{x:52,y:48},2:{x:32,y:28},3:{x:46,y:44},4:{x:57,y:54},5:{x:62,y:50},
    6:{x:34,y:76},7:{x:58,y:46},8:{x:40,y:54},9:{x:72,y:68}
  },

  /* ===== 积分系统 ===== */
  pointsConfig: {
    checkIn: 5,
    publishActivity: 20,
    completeActivity: 50,
    postTopic: 10,
    postLiked: 2,
    postCommented: 3,
    sharePost: 1
  },

  mallItems: [
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
  ],

  pointsLeaderboard: [
    {name:"张明远",points:1580,level:"钻石志愿者",av:"#7c3aed",join:48},
    {name:"李思涵",points:1420,level:"钻石志愿者",av:"#27ae60",join:45},
    {name:"王浩然",points:1350,level:"黄金志愿者",av:"#e67e22",join:42},
    {name:"刘雨桐",points:1280,level:"黄金志愿者",av:"#2980b9",join:39},
    {name:"陈志强",points:1150,level:"黄金志愿者",av:"#e74c3c",join:36},
    {name:"杨柳青",points:1080,level:"白银志愿者",av:"#8e44ad",join:33},
    {name:"赵晓东",points:960,level:"白银志愿者",av:"#16a085",join:30},
    {name:"黄静怡",points:890,level:"白银志愿者",av:"#d35400",join:28},
    {name:"周建国",points:820,level:"白银志愿者",av:"#2c3e50",join:25},
    {name:"吴美琪",points:750,level:"青铜志愿者",av:"#c0392b",join:23},
    {name:"钱伟豪",points:680,level:"青铜志愿者",av:"#1abc9c",join:20},
    {name:"孙雅琴",points:610,level:"青铜志愿者",av:"#f39c12",join:18},
    {name:"郑浩然",points:540,level:"青铜志愿者",av:"#3498db",join:16},
    {name:"冯丽萍",points:470,level:"新星志愿者",av:"#9b59b6",join:14},
    {name:"褚思源",points:380,level:"新星志愿者",av:"#e91e63",join:12}
  ]
};
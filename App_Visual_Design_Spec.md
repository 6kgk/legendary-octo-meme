# “职教通” V1.0 App 视觉设计与品牌规范 (Visual Spec)

## 一、 设计理念：【未来之桥】
“职教通”不仅仅是一个提分软件，它是连接中职生与深圳未来的桥梁。视觉设计以“专业、稳重、充满希望”为基调。

## 二、 核心品牌资产 (Brand Assets)

### 1. 官方 App 图标 (App Icon)
*   **设计逻辑**：以深蓝为底，中央为一个抽象的、呈上升趋势的“桥梁”符号，该符号同时也是一本翻开的书本。象征着“知识铺就职业成功之路”。
*   **配色方案**：学术深蓝 (#1A237E) + 成功橙 (#FF6D00)。
*   **查看图标原型**：![App Icon](https://sc02.alicdn.com/kf/A40b9194ca83b4eb2aa0f7a9b88616bc87.png)

### 2. 启动页 (Splash Screen)
*   **设计逻辑**：背景采用清晨微光下的深圳天际线（隐喻希望），正中央为 App Logo 及 Slogan。
*   **Slogan**：*“职教通：让每一个中职生在深圳都有尊严地生活。”*
*   **查看启动页背景**：![Splash Screen](https://sc02.alicdn.com/kf/Aa38d30350a35459ca7f60ff432c2330fJ.png)

---

## 三、 UI 规范说明 (For Developer)

### 1. 标准配色 (Standard Colors)
*   **主色 (Primary)**：#1A237E (用于标题栏、核心按钮、首页背景)。
*   **辅色 (Secondary)**：#FF6D00 (用于提分进度条、重点警告、付费按钮)。
*   **警示色 (Alert)**：#D32F2F (用于黑工厂预警、违规条款标注)。
*   **安全色 (Safe)**：#388E3C (用于优质企业推荐、录取概率“稳操胜券”)。

### 2. 字体规范
*   **标题**：思源黑体 Bold (SimHei)，字号 18-20px。
*   **正文**：思源黑体 Regular (Microsoft YaHei)，字号 14-16px。
*   **原则**：字间距适中，确保在手机屏幕上的极佳易读性。

---

## 四、 交付说明
请 **邓绍鹏** 在构建 APK 时，将上述图标（Icon）及启动页背景（Splash Screen）按 Flutter 标准目录进行替换：
*   **Icon**：替换 `assets/icon/icon.png`。
*   **Splash Screen**：替换 `assets/images/splash.png`。

---
**设计人**：点子大师
**状态**：视觉方案已锁定，待集成。
**日期**：2026年4月5日

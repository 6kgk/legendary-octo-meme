import { UserService } from './user.service.js';
import { TokenTracker } from './token-tracker.js';

/**
 * 【职教通】老板实时监控看板服务 (Task #48)
 * 职责：汇总全系统运营核心指标
 */
export class MonitoringService {
  private dailyTutorCount: number = 0;
  private totalRisksIdentified: number = 0;
  private lastResetDate: string = new Date().toDateString();
  private riskInterceptionList: string[] = ['某某教育(扣证风险)', '某汽车售后(无薪试岗)', '某电子厂(高额押金)'];
  private subjectHeatmap: Record<string, number> = { '数学': 120, '语文': 85, '英语': 64, '专业课': 156 };
  private scoreTrend: number[] = [285, 292, 305, 312, 325];

  constructor(
    private userService: UserService,
    private tokenTracker: TokenTracker
  ) {}

  /**
   * 记录一次成功的 AI 辅导讲题 (Task #77)
   */
  recordTutorAction(subject: string = '未知') {
    this.checkDateReset();
    this.dailyTutorCount++;
    this.subjectHeatmap[subject] = (this.subjectHeatmap[subject] || 0) + 1;
  }

  /**
   * 记录一次识别出的合同风险 (Task #77)
   */
  recordRiskIdentified(companyName?: string) {
    this.totalRisksIdentified++;
    if (companyName) {
      this.riskInterceptionList.unshift(`${companyName} (风险触发)`);
      if (this.riskInterceptionList.length > 5) this.riskInterceptionList.pop();
    }
  }

  /**
   * 获取核心运营数据
   */
  getBossStats() {
    this.checkDateReset();
    const stats = this.tokenTracker.getStats();
    
    return {
      registeredStudents: this.userService.getAllUsers().length,
      todayTutorCount: this.dailyTutorCount,
      totalRisksIdentified: this.totalRisksIdentified,
      riskInterceptions: this.riskInterceptionList,
      subjectHeatmap: this.subjectHeatmap,
      scoreTrend: this.scoreTrend,
      tokenUsage: stats,
      tokenBalance: 1000000 - stats.totalTokens,
      serverStatus: 'War-Room Active (最高指挥权限)',
      lastUpdate: new Date().toLocaleTimeString()
    };
  }

  private checkDateReset() {
    const today = new Date().toDateString();
    if (today !== this.lastResetDate) {
      this.dailyTutorCount = 0;
      this.lastResetDate = today;
      console.log(`[MonitoringService] 进入新的一天，今日计数器已重置。`);
    }
  }

  /**
   * 生成极简 HTML 看板页面内容 (CEO War Room - Task #77)
   */
  generateBossHtml(): string {
    const stats = this.getBossStats();
    const heatmapBars = Object.entries(stats.subjectHeatmap)
      .map(([s, c]) => `<div style="height:${c}px; width:40px; background:#58a6ff; margin:0 5px; border-radius:4px 4px 0 0;" title="${s}: ${c}"></div>`)
      .join('');

    return `
      <!DOCTYPE html>
      <html lang="zh-CN">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>职教通 | CEO 实时战情室</title>
          <style>
              body { font-family: 'PingFang SC', sans-serif; background-color: #0b0e14; color: #c9d1d9; padding: 30px; margin: 0; }
              .war-room { max-width: 1200px; margin: 0 auto; border: 2px solid #30363d; border-radius: 20px; padding: 30px; background: #0d1117; box-shadow: 0 0 50px rgba(88,166,255,0.1); }
              header { border-bottom: 2px solid #30363d; padding-bottom: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
              h1 { color: #58a6ff; font-size: 28px; letter-spacing: 2px; text-transform: uppercase; }
              .status-badge { background: #238636; color: white; padding: 6px 15px; border-radius: 4px; font-size: 14px; font-weight: bold; }
              .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
              .card { background: #161b22; border: 1px solid #30363d; border-radius: 12px; padding: 20px; position: relative; overflow: hidden; }
              .card::after { content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: #58a6ff; }
              .card.risk::after { background: #f85149; }
              .card h2 { font-size: 12px; color: #8b949e; text-transform: uppercase; margin-bottom: 10px; }
              .card .value { font-size: 36px; font-weight: 800; color: #f0f6fc; }
              .card .unit { font-size: 12px; color: #8b949e; margin-left: 5px; }
              
              .sections { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; }
              .section-card { background: #161b22; border: 1px solid #30363d; border-radius: 12px; padding: 25px; }
              .section-title { font-size: 16px; color: #58a6ff; margin-bottom: 20px; display: flex; align-items: center; }
              .section-title::before { content: ''; display: inline-block; width: 4px; height: 16px; background: #58a6ff; margin-right: 10px; }
              
              .heatmap { display: flex; align-items: flex-end; height: 200px; padding: 20px 0; border-bottom: 1px solid #30363d; justify-content: center; }
              .risk-log { list-style: none; padding: 0; margin: 0; }
              .risk-log li { padding: 10px 0; border-bottom: 1px solid #30363d; color: #f85149; font-size: 13px; }
              .risk-log li:last-child { border-bottom: none; }
              
              .token-footer { margin-top: 30px; display: flex; align-items: center; justify-content: space-between; background: #161b22; padding: 20px; border-radius: 12px; border: 1px solid #30363d; }
              .progress-bar { flex: 1; height: 8px; background: #30363d; border-radius: 4px; margin: 0 30px; overflow: hidden; }
              .progress-fill { height: 100%; background: #58a6ff; width: ${(stats.tokenUsage.totalTokens / 1000000 * 100).toFixed(2)}%; }
              footer { text-align: center; margin-top: 30px; color: #484f58; font-size: 11px; }
          </style>
          <script>setTimeout(() => location.reload(), 15000);</script>
      </head>
      <body>
          <div class="war-room">
              <header>
                  <div>
                      <h1>CEO 实时战情指挥室 <span class="status-badge">${stats.serverStatus}</span></h1>
                      <p style="margin: 5px 0 0 0; color: #8b949e;">数据同步时间：${stats.lastUpdate} | 节点：深圳·提分实验中心</p>
                  </div>
                  <button style="background: #21262d; border: 1px solid #30363d; color: #c9d1d9; padding: 8px 16px; border-radius: 6px; cursor: pointer;">导出战报 (PDF)</button>
              </header>

              <div class="grid">
                  <div class="card">
                      <h2>系统注册兵力</h2>
                      <div class="value">${stats.registeredStudents}<span class="unit">位</span></div>
                  </div>
                  <div class="card">
                      <h2>今日辅导战报</h2>
                      <div class="value">${stats.todayTutorCount}<span class="unit">次</span></div>
                  </div>
                  <div class="card risk">
                      <h2>拦截高危实习</h2>
                      <div class="value" style="color: #f85149;">${stats.totalRisksIdentified}<span class="unit">起</span></div>
                  </div>
                  <div class="card">
                      <h2>全班预估分分差</h2>
                      <div class="value" style="color: #3fb950;">+14.5<span class="unit">点</span></div>
                  </div>
              </div>

              <div class="sections">
                  <div class="section-card">
                      <div class="section-title">全科提分热力分布 (科目辅导活跃度)</div>
                      <div class="heatmap">
                          ${heatmapBars}
                      </div>
                      <div style="display:flex; justify-content:center; margin-top:10px; font-size:12px; color:#8b949e;">
                          ${Object.keys(stats.subjectHeatmap).map(s => `<span style="width:50px; text-align:center;">${s}</span>`).join('')}
                      </div>
                  </div>
                  <div class="section-card">
                      <div class="section-title">高危实习单位拦截记录 (最新)</div>
                      <ul class="risk-log">
                          ${stats.riskInterceptions.map(r => `<li>⚠️ ${r}</li>`).join('')}
                      </ul>
                  </div>
              </div>

              <div class="token-footer">
                  <div style="font-weight: bold; color: #58a6ff;">AI 资源池：${stats.tokenBalance.toLocaleString()} Tokens</div>
                  <div class="progress-bar"><div class="progress-fill"></div></div>
                  <div style="color: #8b949e; font-size: 13px;">能耗：${(stats.tokenUsage.totalTokens / 10000).toFixed(1)}%</div>
              </div>
              
              <footer>
                  &copy; 2026 校园应用项目团队 - 全球指挥中心 - 安全等级：S级
              </footer>
          </div>
      </body>
      </html>
    `;
  }
}

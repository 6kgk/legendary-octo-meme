import { UserProfile, UserService } from './user.service.js';
import { LearningProgressService, ScoreProgress } from './learning-progress.service.js';
import { GrowthArchiveService } from './growth-archive.service.js';
import { CompanyCreditService, CompanyCredit } from './company-credit.service.js';
import { ParentFeedbackService, ParentFeedback } from './parent-feedback.service.js';

export interface ClassInfo {
  id: string;
  name: string;
  teacherId: string;
  studentIds: string[];
}

export interface TeacherProfile {
  id: string;
  name: string;
  schoolName: string;
}

/**
 * 【职教通】教师端核心管理服务 (Task #59, #61, #63, #64, #66)
 * 职责：
 * 1. 管理“教师-班级-学生”关联
 * 2. 聚合班级学情数据（挂科预警、知识点覆盖）
 * 3. 实现教师管理指令（发勋章、派任务）
 * 4. 导出班级“一键交账”报表
 * 5. 记录谈话内容，维护成长档案
 * 6. 实习高危单位干预预警 (Task #64)
 * 7. 家校评价同步 (Task #66)
 */
export class TeacherService {
  private teachers: Map<string, TeacherProfile> = new Map();
  private classes: Map<string, ClassInfo> = new Map();
  private studentConsultations: Map<string, string[]> = new Map(); // userId -> companyNames

  constructor(
    private userService: UserService,
    private progressService: LearningProgressService,
    private archiveService: GrowthArchiveService,
    private creditService: CompanyCreditService,
    private parentService: ParentFeedbackService
  ) {
    this.seedInitialData();
  }

  /**
   * 模拟：记录学生咨询某单位 (Task #64 内部测试用)
   */
  async recordConsultation(userId: string, companyName: string) {
    const companies = this.studentConsultations.get(userId) || [];
    if (!companies.includes(companyName)) {
      companies.push(companyName);
      this.studentConsultations.set(userId, companies);
    }
  }

  /**
   * 获取班级实时学情大盘
   */
  async getClassAnalytics(classId: string) {
    const classInfo = this.classes.get(classId);
    if (!classInfo) throw new Error('班级不存在');

    const students = await Promise.all(
      classInfo.studentIds.map(id => this.userService.findById(id))
    );
    
    const progresses = await Promise.all(
      classInfo.studentIds.map(id => this.progressService.getUserProgress(id))
    );

    // 1. 计算平均分
    const avgScore = progresses.reduce((acc, p) => acc + p.currentEstimatedScore, 0) / progresses.length;

    // 2. 知识点薄弱项分析 (全班性)
    const subjectStats: any = { math: 0, chinese: 0, english: 0, professional: 0 };
    progresses.forEach(p => {
      subjectStats.math += p.subjects.math;
      subjectStats.chinese += p.subjects.chinese;
      subjectStats.english += p.subjects.english;
      subjectStats.professional += p.subjects.professional;
    });

    const classWeakness = Object.keys(subjectStats).reduce((a, b) => 
      subjectStats[a] < subjectStats[b] ? a : b
    );

    // 2.5 AI 班级学情摘要 (Task #72)
    let aiSummary = '';
    if (avgScore < 250) {
      aiSummary = `🚨 本周警报：全班平均预估分处于低位 (${avgScore.toFixed(0)}分)，且【${classWeakness === 'math' ? '数学三角函数' : classWeakness}】为共性短板，建议周三晚自习进行专项补课。`;
    } else if (avgScore > 350) {
      aiSummary = `🌟 优秀简报：全班整体学情极佳，重点已转向【专业资质】冲刺，建议本周组织一次 NCRE 计算机一级模拟实战。`;
    } else {
      aiSummary = `💡 稳步提升：全班平均分处于稳步上升期，建议重点关注 ${alerts.filter(a => a.level === 'critical').length} 名处于高危实习状态的学生。`;
    }

    // 3. 预警系统 (挂科预警 + 实习风险预警)
    const alerts: any[] = [];
    
    // 挂科预警
    progresses.filter(p => p.currentEstimatedScore < 200).forEach(p => {
      alerts.push({
        userId: p.userId,
        type: 'academic',
        reason: '预估分风险 (低于200分)',
        level: 'high'
      });
    });

    // 4. 实习风险预警 (Task #64)
    for (const userId of classInfo.studentIds) {
      const consultations = this.studentConsultations.get(userId) || [];
      for (const companyName of consultations) {
        const credit = await this.creditService.findByName(companyName);
        if (credit && credit.riskLevel === 'red') {
          alerts.push({
            userId,
            type: 'internship',
            company: companyName,
            reason: `高危实习风险：正在咨询/签约【${companyName}】(红灯单位)`,
            level: 'critical',
            template: `同学，我看到你在关注【${companyName}】。这单位在系统里是红灯预警，存在非法扣证和拖欠工资的风险，建议你千万不要去签合同，老师这有更好的推荐...`
          });
        }
      }
    }

    // 5. 家校评价同步数据 (Task #66)
    const studentDetails = await Promise.all(students.map(async (s, i) => {
      const latestParentFeedback = this.parentService.getLatestFeedback(s?.id || '');
      return {
        id: s?.id,
        name: s?.username,
        score: progresses[i].currentEstimatedScore,
        progress: progresses[i].subjects,
        parentContext: latestParentFeedback ? {
          message: latestParentFeedback.parentMessage,
          medal: latestParentFeedback.medalType
        } : null
      };
    }));

    return {
      classId,
      className: classInfo.name,
      studentCount: classInfo.studentIds.length,
      averageScore: Math.round(avgScore),
      classWeakness,
      alerts,
      studentDetails,
      aiSummary
    };
  }

  /**
   * 教师指令：一键分发弱点强化包
   */
  async dispatchRemedyTask(classId: string, subject: string) {
    console.log(`[TeacherService] 已向班级 ${classId} 全体学生分发【${subject}】弱点强化练习包`);
    return { success: true, message: `已分发 ${subject} 强化包` };
  }

  /**
   * 导出班级学情报表 (CSV 格式) (Task #61)
   */
  async generateClassReportCsv(classId: string): Promise<string> {
    const analytics = await this.getClassAnalytics(classId);
    let csv = '\uFEFF'; // BOM for Excel encoding
    csv += `班级：,${analytics.className},总人数：,${analytics.studentCount},平均分：,${analytics.averageScore}\n`;
    csv += '姓名,ID,当前预估分,数学掌握度,语文掌握度,英语掌握度,专业课掌握度\n';
    
    analytics.studentDetails.forEach(s => {
      csv += `${s.name},${s.id},${s.score},${s.progress.math}%,${s.progress.chinese}%,${s.progress.english}%,${s.progress.professional}%\n`;
    });

    return csv;
  }

  /**
   * 记录学生谈话记录 (Task #63)
   */
  async recordStudentInterview(teacherId: string, userId: string, content: string, category: string) {
    return this.archiveService.recordInterview(userId, teacherId, content, category as any);
  }

  /**
   * 获取学生成长档案
   */
  async getStudentArchive(userId: string) {
    return this.archiveService.getArchive(userId);
  }

  private async seedInitialData() {
    // 模拟教师
    this.teachers.set('T001', { id: 'T001', name: '张老师', schoolName: '深圳第一职业技术学校' });
    
    // 预注册测试学生 (Task #71 Bug Fix: 确保教师端能查到学生)
    await (this.userService as any).users.set('default', { id: 'default', username: '林同学', phoneNumber: '13800138000', schoolName: '深圳一职', grade: '高三', major: '电子商务', subscriptionLevel: 'basic', createdAt: new Date() });
    await (this.userService as any).users.set('test_user_1', { id: 'test_user_1', username: '王小龙', phoneNumber: '13912345678', schoolName: '深圳一职', grade: '高三', major: '机电一体化', subscriptionLevel: 'vip', createdAt: new Date() });

    // 模拟班级（关联现有测试学生）
    this.classes.set('C001', { 
      id: 'C001', 
      name: '24级机电1班', 
      teacherId: 'T001', 
      studentIds: ['default', 'test_user_1'] 
    });

    // 模拟 Task #64: 实习高危单位干预预警
    this.recordConsultation('test_user_1', '某布吉餐饮小店'); 
  }

  /**
   * 生成教师端极简 HTML 管理面板内容 (Task #60, #61, #63)
   */
  async generateTeacherDashboardHtml(classId: string): Promise<string> {
    const analytics = await this.getClassAnalytics(classId);
    
    return `
      <!DOCTYPE html>
      <html lang="zh-CN">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>职教通 | 教师端管理大盘</title>
          <style>
              body { font-family: 'PingFang SC', sans-serif; background-color: #f0f2f5; color: #333; margin: 0; padding: 20px; }
              .container { max-width: 1200px; margin: 0 auto; }
              header { background: #1d4e89; color: white; padding: 20px 40px; border-radius: 12px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
              .card { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 20px; }
              .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
              .stat-box { text-align: center; border-right: 1px solid #eee; }
              .stat-box:last-child { border-right: none; }
              .stat-value { font-size: 32px; font-weight: bold; color: #1d4e89; }
              .stat-label { font-size: 14px; color: #666; }
              .alert-item { background: #fff1f0; border: 1px solid #ffa39e; padding: 10px 15px; border-radius: 8px; margin-bottom: 10px; color: #cf1322; display: flex; justify-content: space-between; align-items: center; }
              .alert-item.critical { background: #ff4d4f; color: white; border-color: #a8071a; }
              .alert-item.critical .btn { background: white; color: #ff4d4f; border: 1px solid #ff4d4f; font-weight: bold; }
              table { width: 100%; border-collapse: collapse; margin-top: 20px; }
              th { text-align: left; padding: 12px; border-bottom: 2px solid #eee; color: #666; }
              td { padding: 12px; border-bottom: 1px solid #eee; }
              .parent-tag { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 11px; background: #e6f7ff; color: #1890ff; margin-right: 5px; border: 1px solid #91d5ff; }
              .btn { background: #1d4e89; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; }
              .btn-warning { background: #faad14; }
              .btn-success { background: #52c41a; }
              .badge { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 11px; background: #eee; }
          </style>
          <script>
            function exportReport() {
              window.open('/api/teacher/report/${classId}');
            }
            function recordInterview(userId, initialContent = '') {
              const content = prompt('请输入谈话记录内容：', initialContent);
              if (content) {
                fetch('/api/teacher/record-interview', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/json' },
                  body: JSON.stringify({ userId, teacherId: 'T001', content, category: 'risk_intervention' })
                }).then(res => res.json()).then(data => {
                  if (data.success) alert('谈话记录已归档！');
                });
              }
            }
            function showTemplate(template) {
                alert('建议话术推送：\n\n' + template);
            }
          </script>
      </head>
      <body>
          <div class="container">
              <header>
                  <div>
                      <h1 style="margin:0">${analytics.className} 管理大盘</h1>
                      <p style="margin:5px 0 0 0">教师：张老师 | 学校：深圳第一职业技术学校</p>
                  </div>
                  <div>
                    <button class="btn btn-success" onclick="exportReport()">一键导出交账报表 (CSV)</button>
                    <button class="btn" style="margin-left:10px" onclick="alert('强化包已分发！')">一键分发弱点强化包</button>
                  </div>
              </header>

              <div class="grid">
                  <div class="card stat-box">
                      <div class="stat-value">${analytics.studentCount}</div>
                      <div class="stat-label">班级总人数</div>
                  </div>
                  <div class="card stat-box">
                      <div class="stat-value">${analytics.averageScore}</div>
                      <div class="stat-label">班级平均预估分</div>
                  </div>
                  <div class="card stat-box">
                      <div class="stat-value" style="color:#faad14">${analytics.classWeakness === 'math' ? '数学' : analytics.classWeakness}</div>
                      <div class="stat-label">班级共性薄弱项</div>
                  </div>
              </div>

              <div class="card" style="background: #f0f5ff; border: 1px solid #adc6ff;">
                  <h3 style="margin-top:0; color:#1d39c4">🤖 AI 班级学情摘要 (Task #72)</h3>
                  <p style="font-size: 16px; line-height: 1.6; color: #262626; margin: 0;">${analytics.aiSummary}</p>
              </div>

              <div class="card">
                  <h3 style="margin-top:0; color:#cf1322">⚠️ 风险预警大厅 (挂科预警 + 实习高危)</h3>
                  ${analytics.alerts.map(a => `
                      <div class="alert-item ${a.level === 'critical' ? 'critical' : ''}">
                          <span>[${a.type === 'academic' ? '提分预警' : '实习拦截'}] ${a.userId}: ${a.reason}</span>
                          <div>
                            ${a.template ? `<button class="btn" onclick="showTemplate('${a.template}')">查看话术模板</button>` : ''}
                            <button class="btn ${a.level === 'critical' ? '' : 'btn-warning'}" onclick="recordInterview('${a.userId}', '${a.template || ''}')">立即干预并归档</button>
                          </div>
                      </div>
                  `).join('')}
              </div>

              <div class="card">
                  <h3 style="margin-top:0">学生学情明细 (已同步家校评价)</h3>
                  <table>
                      <thead>
                          <tr>
                              <th>学生姓名</th>
                              <th>当前预估分</th>
                              <th>数学掌握度</th>
                              <th>语文掌握度</th>
                              <th>家校协同动态 (Task #66)</th>
                              <th>操作</th>
                          </tr>
                      </thead>
                      <tbody>
                          ${analytics.studentDetails.map(s => `
                              <tr>
                                  <td>${s.name} <span class="badge">机电</span></td>
                                  <td><b style="color:#1d4e89">${s.score}</b></td>
                                  <td>${s.progress.math}%</td>
                                  <td>${s.progress.chinese}%</td>
                                  <td>
                                    ${s.parentContext ? `
                                        <div class="parent-tag">🏅 ${s.parentContext.medal === 'focus' ? '专注' : s.parentContext.medal}勋章</div>
                                        <div style="font-size: 11px; color: #8c8c8c; margin-top:4px">“${s.parentContext.message}”</div>
                                    ` : '<span style="color:#bfbfbf; font-size:12px">暂无家长反馈</span>'}
                                  </td>
                                  <td>
                                    <button class="btn" style="padding:4px 10px; font-size:12px">查看详细雷达</button>
                                    <button class="btn" style="padding:4px 10px; font-size:12px; background: #8c8c8c" onclick="alert('正在生成 ${s.name} 的全周期成长档案...')">成长档案</button>
                                  </td>
                              </tr>
                          `).join('')}
                      </tbody>
                  </table>
              </div>
          </div>
      </body>
      </html>
    `;
  }
}

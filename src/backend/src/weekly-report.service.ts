import { LearningProgressService, ScoreProgress } from './learning-progress.service.js';

export interface WeeklySummary {
  userId: string;
  weekRange: string;
  scoreImprovement: number;
  masteredKnowledgePoints: number;
  learningTimeHours: number;
  reportMessage: string;
  nextWeekGoals: string[];
}

/**
 * 【职教通】学习周报服务 (Task #42)
 * 职责：
 * 1. 汇总学生一周的学习成果
 * 2. 生成包含提分预测、考点攻克和推荐院校的报告
 */
export class WeeklyReportService {
  constructor(private learningService: LearningProgressService) {}

  /**
   * 生成用户的学习周报
   */
  async generateWeeklyReport(userId: string): Promise<WeeklySummary> {
    const progress = await this.learningService.getUserProgress(userId);
    const prediction = await this.learningService.getScorePrediction(userId);

    // 模拟周报数据聚合逻辑
    const improvement = (Math.random() * 5 + 2).toFixed(1); // 模拟本周提升 2-7 分
    const pointsCount = Math.floor(Math.random() * 8 + 5);   // 模拟攻克 5-13 个知识点
    const hours = (Math.random() * 15 + 10).toFixed(1);    // 模拟学习 10-25 小时

    return {
      userId,
      weekRange: "2026-03-30 至 2026-04-05",
      scoreImprovement: parseFloat(improvement),
      masteredKnowledgePoints: pointsCount,
      learningTimeHours: parseFloat(hours),
      reportMessage: this.createReportMessage(progress, prediction),
      nextWeekGoals: this.createNextWeekGoals(progress)
    };
  }

  private createReportMessage(progress: ScoreProgress, prediction: any): string {
    const target = prediction.closestTarget.name;
    const gap = prediction.closestTarget.gap;
    const prob = prediction.closestTarget.matchProbability;

    return `本周你在“职教通”表现优异！你已经攻克了 ${progress.learningDays} 天的学习任务。目前预测总分提升至 ${progress.currentEstimatedScore} 分。` +
           `距离你的梦想学校【${target}】还差 ${gap} 分。当前录取概率评估为 ${prob}。保持状态，你是最棒的！`;
  }

  private createNextWeekGoals(progress: ScoreProgress): string[] {
    const goals = [];
    if (progress.subjects.math < 60) {
      goals.push("攻克“三角函数”基础定义");
      goals.push("完成 5 组二次函数错题复盘");
    } else {
      goals.push("挑战数学压轴题模拟演练");
    }
    
    if (progress.subjects.english < 70) {
      goals.push("背诵 50 个广东 3+ 考试核心词汇");
    }
    
    goals.push("完成一次全科真题模考");
    return goals;
  }
}

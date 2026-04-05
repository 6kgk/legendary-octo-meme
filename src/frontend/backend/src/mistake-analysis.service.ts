import { ScoreProgress } from './learning-progress.service.js';

export interface MistakePattern {
  subject: string;
  reason: 'formula_confusion' | 'concept_gap' | 'careless_reading' | 'logic_error';
  explanation: string;
  remedyLesson: string;
}

/**
 * 【职教通】错题归因分析引擎 (Task #50)
 * 职责：
 * 1. 分析学生的错题历史
 * 2. 识别导致错误的底层逻辑问题
 * 3. 推送“大白话”降维补课内容
 */
export class MistakeAnalysisService {
  /**
   * 分析特定科目的错误模式
   */
  async analyzeMistakePattern(userId: string, subject: string, recentHistory: any[]): Promise<MistakePattern | null> {
    // 模拟错题归因分析逻辑
    // 实际应通过分析学生回答的关键词、解题时长等数据进行模式识别
    
    const mistakeCount = recentHistory.filter(h => h.mastered === false).length;
    
    if (mistakeCount >= 2) {
      if (subject === '数学') {
        return {
          subject,
          reason: 'formula_confusion',
          explanation: '同学，我看你最近连续两道二次函数题都在顶点坐标上卡住了。你可能把顶点公式 -b/(2a) 和对称轴方程记混了。',
          remedyLesson: '【3分钟大白话补课】抛物线的“头”在哪里？想象一下你向上扔个球，球飞到最高点静止的那一刻，那个位置就是顶点。我们要找这个点的横坐标，只要记住这个点在两条对称的边中间就好...'
        };
      }
      
      if (subject === '英语') {
        return {
          subject,
          reason: 'concept_gap',
          explanation: '这几道时态题你都选错了。看来你对“现在完成时”和“过去时”的界限还是有点模糊。',
          remedyLesson: '【3分钟大白话补课】英语时态就像看电影。过去时是电影已经放完了（动作结束）；现在完成时是电影还在影响现在的你（动作结果持续到现在）。'
        };
      }
    }

    return null;
  }

  /**
   * 生成针对性的归因提醒话术
   */
  getAttributionAlert(pattern: MistakePattern): string {
    return `⚠️ 归因分析：${pattern.explanation}\n\n建议点击下方【大白话补课】立即攻克该盲点。`;
  }
}

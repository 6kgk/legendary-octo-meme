import { WeeklySummary } from './weekly-report.service.js';
import crypto from 'crypto';

export interface ParentFeedback {
  userId: string;
  parentMessage: string;
  timestamp: string;
  isEncouragement: boolean;
  medalType?: 'focus' | 'progress' | 'resilience' | 'none'; // (Task #53) 情感勋章
}

/**
 * 【职教通】家长监督与情感反馈服务 (Task #44)
 * 职责：
 * 1. 生成基于 Token 的周报分享链接
 * 2. 接收并存储家长的情感反馈（寄语）
 * 3. 为学生提供首页寄语推送数据
 */
export class ParentFeedbackService {
  private shareTokens: Map<string, string> = new Map(); // token -> userId
  private parentFeedbacks: Map<string, ParentFeedback[]> = new Map(); // userId -> feedbacks

  /**
   * 为用户的周报生成分享 Token
   */
  generateShareToken(userId: string): string {
    const token = crypto.randomBytes(16).toString('hex');
    this.shareTokens.set(token, userId);
    // Token 有效期模拟：此处简单处理为永不过期，实际开发中建议设置 TTL
    return token;
  }

  /**
   * 根据 Token 获取用户 ID (供家长端校验)
   */
  getUserIdByToken(token: string): string | undefined {
    return this.shareTokens.get(token);
  }

  /**
   * 提交家长寄语与勋章 (Task #53)
   */
  async submitFeedback(token: string, message: string, medalType: any = 'none'): Promise<boolean> {
    const userId = this.getUserIdByToken(token);
    if (!userId) return false;

    const feedback: ParentFeedback = {
      userId,
      parentMessage: message,
      timestamp: new Date().toISOString(),
      isEncouragement: this.isEncouragingMessage(message),
      medalType: medalType
    };

    const userFeedbacks = this.parentFeedbacks.get(userId) || [];
    userFeedbacks.push(feedback);
    this.parentFeedbacks.set(userId, userFeedbacks);

    console.log(`[家长反馈] 收到来自用户 ${userId} 家长的寄语: ${message} (勋章: ${medalType})`);
    return true;
  }

  /**
   * 获取最新的家长寄语（用于首页弹出）
   */
  getLatestFeedback(userId: string): ParentFeedback | null {
    const feedbacks = this.parentFeedbacks.get(userId);
    if (!feedbacks || feedbacks.length === 0) return null;
    return feedbacks[feedbacks.length - 1];
  }

  /**
   * 计算家长的累计鼓励系数（用于简历背书加分）
   */
  getParentSupportScore(userId: string): number {
    const feedbacks = this.parentFeedbacks.get(userId);
    if (!feedbacks) return 0;
    // 每条正面鼓励加 2 分，上限 10 分
    const score = feedbacks.filter(f => f.isEncouragement).length * 2;
    return Math.min(10, score);
  }

  private isEncouragingMessage(msg: string): boolean {
    const positiveKeywords = ['加油', '棒', '进步', '努力', '支持', '欣慰', '优秀'];
    return positiveKeywords.some(key => msg.includes(key));
  }
}

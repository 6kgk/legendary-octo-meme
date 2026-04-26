export interface InterviewRecord {
  id: string;
  userId: string;
  teacherId: string;
  content: string;
  timestamp: string;
  category: 'academic' | 'career' | 'personal' | 'risk_intervention';
}

export interface GrowthArchive {
  userId: string;
  interviewRecords: InterviewRecord[];
  milestones: string[];
}

/**
 * 【职教通】学生成长档案与谈话记录服务 (Task #63)
 * 职责：
 * 1. 记录教师与学生的谈话内容
 * 2. 维护学生的成长里程碑
 * 3. 为“职业简历”提供额外的人文评价数据
 */
export class GrowthArchiveService {
  private archives: Map<string, GrowthArchive> = new Map();

  /**
   * 记录一次谈话
   */
  async recordInterview(userId: string, teacherId: string, content: string, category: any = 'academic'): Promise<InterviewRecord> {
    const record: InterviewRecord = {
      id: Math.random().toString(36).substr(2, 9),
      userId,
      teacherId,
      content,
      category,
      timestamp: new Date().toISOString()
    };

    const archive = this.getOrCreateArchive(userId);
    archive.interviewRecords.push(record);
    
    console.log(`[GrowthArchive] 记录谈话: 学生 ${userId}, 类别 ${category}`);
    return record;
  }

  /**
   * 获取学生的成长档案
   */
  async getArchive(userId: string): Promise<GrowthArchive> {
    return this.getOrCreateArchive(userId);
  }

  /**
   * 添加里程碑
   */
  async addMilestone(userId: string, milestone: string) {
    const archive = this.getOrCreateArchive(userId);
    archive.milestones.push(milestone);
  }

  private getOrCreateArchive(userId: string): GrowthArchive {
    if (!this.archives.has(userId)) {
      this.archives.set(userId, {
        userId,
        interviewRecords: [],
        milestones: []
      });
    }
    return this.archives.get(userId)!;
  }
}

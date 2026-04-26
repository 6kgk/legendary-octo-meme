import { Controller, Get, Query } from '@nestjs/common';

@Controller('learning')
export class LearningController {
  
  @Get('report')
  async getLearningReport(@Query('studentId') studentId: string) {
    return {
      success: true,
      data: {
        scoreCurve: [240, 245, 258, 265, 280, 275, 292],
        summary: "超越了全省 85% 的职教考生",
        stats: {
          mastered: 48,
          pending: 12,
          estimatedIncrease: 22
        },
        weaknessAnalysis: [
          { label: "三角函数", value: 0.35, rootCause: "根源：相似三角形比例概念不牢" },
          { label: "二次函数", value: 0.65, rootCause: "根源：负数四则运算频发错误" },
          { label: "英语阅读", value: 0.45, rootCause: "根源：核心 500 动词词汇量不足" }
        ]
      }
    };
  }

  @Get('exams')
  async getExamList() {
    return {
      success: true,
      data: [
        { id: "math-001", title: "2026 广东省 3+证书 数学全真模拟卷 (A)", time: "120分钟", score: "150分" },
        { id: "chinese-001", title: "2026 广东省 3+证书 语文全真模拟卷 (B)", time: "150分钟", score: "150分" },
        { id: "english-001", title: "英语 PETS-1 听力与笔试冲刺卷", time: "90分钟", score: "100分" },
        { id: "ncre-001", title: "计算机 NCRE 一级 WPS Office 实战卷", time: "90分钟", score: "100分" }
      ]
    };
  }

  @Get('profile')
  async getProfile(@Query('studentId') studentId: string) {
    return {
      success: true,
      data: {
        username: "林同学",
        school: "深圳一职",
        major: "电子信息工程",
        targetScore: 350.0,
        currentScore: 265.0,
        studentId: "GD202610001",
        verified: true
      }
    };
  }
}

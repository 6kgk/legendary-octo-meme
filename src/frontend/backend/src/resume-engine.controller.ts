import OpenAI from 'openai';

/**
 * 【职教通】简历背书核心引擎控制器逻辑
 * 职责：
 * 1. 聚合数据库学习表现数据
 * 2. 调用 AI 算法将“学情”翻译为“才华”
 */
export class ResumeEngineController {
  private openai: OpenAI | null = null;

  constructor() {
    const key = process.env.OPENAI_API_KEY;
    if (key && key !== 'undefined' && key !== 'your-key-here') {
      this.openai = new OpenAI({ apiKey: key });
    }
  }

  /**
   * 处理简历生成请求
   */
  async generateResumeInsights(stats: {
    accuracy: number;
    studyTime: number;
    reviewRate: number;
    major: string;
    professionalCert?: number; // (Task #56) 职业资质/考证维度进度
    parentSupportScore?: number; // (Task #44) 家长支持分数，反映抗压与稳定性
  }) {
    // 逻辑：将学术分翻译为职业软素质评价
    const parentSupport = stats.parentSupportScore || 0;
    const certProgress = stats.professionalCert || 0;
    const prompt = `
      您是一名资深的教育专家与职业顾问。请根据以下中职生学习数据，撰写一段具有“背书性质”的职业胜任力评价。
      
      【学生背景】：专业为 ${stats.major}。
      【学习表现】：正确率 ${(stats.accuracy * 100).toFixed(1)}%，复盘频率为 ${(stats.reviewRate * 100).toFixed(1)}%。
      【职业资质】：已完成考证相关知识点进度的 ${certProgress}%（反映对深圳名企如比亚迪、大疆的针对性准备）。
      【家庭支持】：家长情感支持度评估为 ${parentSupport}/10（反映抗压稳定性）。
      【评价要求】：
      - 严禁空洞。
      - 必须引用数据支撑能力（如：逻辑严密、韧性极佳）。
      - 结合良好的家庭支持与考证针对性，强调其作为稳定且具备资质的社会劳动力进入深圳名企岗位的可靠性。
    `;

    let insights = "";
    if (this.openai) {
      try {
        const response = await this.openai.chat.completions.create({
          model: "gpt-4o",
          messages: [{ role: "system", content: prompt }]
        });
        insights = response.choices[0].message.content || "";
      } catch (e: any) {
        console.warn(`[AI 引擎失败] 回退至本地模拟逻辑: ${e.message}`);
        insights = this.generateMockInsights(stats, parentSupport);
      }
    } else {
      console.log(`[Mock Mode] 正在生成高仿真简历评价...`);
      insights = this.generateMockInsights(stats, parentSupport);
    }

    // 计算雷达分 (算法模拟)
    const radarData = {
      logic: Math.round(stats.accuracy * 100),
      stability: Math.round(Math.min(100, stats.studyTime * 0.8 + parentSupport * 2)), // 加入家长权重
      resilience: Math.round(stats.reviewRate * 100 + parentSupport), // 加入家长权重
      professionalCert: certProgress, // (Task #56) 新增考证/资质维度
      communication: 75 
    };

    return {
      insights: insights,
      radarData: radarData
    };
  }

  /**
   * 针对不同数据生成的“专家级”模拟评价 (用于离线演示/部署)
   */
  private generateMockInsights(stats: { accuracy: number; major: string; reviewRate: number }, parentScore: number) {
    let parentText = parentScore > 5 ? "该生具备极其稳健的心理素质与良好的家庭支持系统。在职业素养评估中，这种“情感稳定性”是长期胜任高压基层岗位的关键指标。" : "";
    if (stats.accuracy > 0.9) {
      return `该同学在 ${stats.major} 领域的学习表现令人瞩目。特别是高达 ${(stats.accuracy * 100).toFixed(1)}% 的练习正确率，充分展现了其严密的逻辑思维与极高的执行精度。${parentText}这种对细节的把控力与 ${(stats.reviewRate * 100).toFixed(1)}% 的复盘率相结合，意味着他在面对复杂工艺流程或精密质检岗位时，不仅能快速上手，更能主动发现并规避错误。在深圳的先进制造产业链中，这类具备“工匠精神”潜质的候选人极具竞争力。`;
    }
    return `该生表现出稳定的职业素养，尤其是在专业实操中展现了良好的稳定性。其学习数据反映了他在基础岗位上的可靠性，是值得培养的种子选手。${parentText}`;
  }
}

import OpenAI from 'openai';

export class ResumeEngineService {
  private openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

  /**
   * 将原始学习数据翻译为职业核心竞争力报告
   */
  async generateProfessionalReport(stats: {
    accuracy: number;
    studyTime: number;
    reviewRate: number;
    topSubjects: string[];
  }) {
    const prompt = `
      您是一名资深的人力资源专家，专注于中职生就业。请将以下学习数据翻译为一份专业的职业胜任力报告。
      
      【学生原始数据】：
      - 整体正确率：${(stats.accuracy * 100).toFixed(1)}%
      - 累计深度学习时长：${stats.studyTime} 小时
      - 错题主动复盘率：${(stats.reviewRate * 100).toFixed(1)}%
      - 擅长领域：${stats.topSubjects.join(', ')}
      
      【输出要求】：
      1. 逻辑分析力评价：基于正确率和科目倾向。
      2. 职业稳定性评价：基于学习时长和持续性。
      3. 逆境处理能力：基于复盘率。
      4. 推荐岗位：对应深圳本地的基层技术或服务岗。
      
      请使用专业、客观且具有背书力度的措辞。
    `;

    const response = await this.openai.chat.completions.create({
      model: "gpt-4o",
      messages: [{ role: "system", content: prompt }]
    });

    return {
      report: response.choices[0].message.content,
      radarData: {
        logic: Math.min(100, stats.accuracy * 120),
        stability: Math.min(100, (stats.studyTime / 100) * 100),
        resilience: stats.reviewRate * 100
      }
    };
  }
}

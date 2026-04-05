import { Injectable } from '@nestjs/common';
@Injectable()
export class RecommendationService {
    userService;
    creditService;
    constructor(userService, creditService) {
        this.userService = userService;
        this.creditService = creditService;
    }
    /**
     * 风险规避型推荐算法 (Task #27)
     *
     * 逻辑：
     * 1. 搜索目标企业，获取风险评分。
     * 2. 如果企业存在红/橙灯风险，立即触发预警。
     * 3. 自动根据该企业行业推荐 3 个“绿灯”优质替代方案。
     * 4. 权限控制：VIP 可查看详细“吐槽记录/报告”。
     */
    async getRecommendation(userId, targetCompanyName) {
        const user = await this.userService.findById(userId);
        if (!user)
            throw new Error('用户不存在');
        const targetCredit = await this.creditService.findByName(targetCompanyName);
        // 如果没有找到对应的信用记录，默认返回“中立”警告
        if (!targetCredit) {
            return {
                status: 'neutral',
                message: '该单位暂无公开信用记录，请务必在投递前核实其资质。',
                recommendations: await this.creditService.getBestAlternatives('电子/制造')
            };
        }
        const isRisk = targetCredit.riskLevel === 'red' || targetCredit.riskLevel === 'orange';
        const canSeeDetails = user.subscriptionLevel === 'vip';
        const result = {
            target: {
                name: targetCredit.name,
                score: targetCredit.creditScore,
                level: targetCredit.riskLevel,
                advice: targetCredit.advice,
                // VIP 权益锁定
                detailedReport: canSeeDetails ? targetCredit.detailedReport : "【VIP 专属】点击解锁查看该单位学长详细吐槽记录与法律审计详情。"
            },
            status: isRisk ? 'alert' : 'safe',
            alertMessage: isRisk ? `🚨 警告：${targetCredit.name} 存在合规风险。` : `✅ 安全：${targetCredit.name} 信用记录良好。`,
            // 优质替代推荐 (绿灯企业)
            alternatives: await this.creditService.getBestAlternatives(targetCredit.industry)
        };
        console.log(`[RecommendationEngine] 为用户 ${user.username} 生成推荐报告: ${targetCredit.name} (${targetCredit.riskLevel})`);
        return result;
    }
}

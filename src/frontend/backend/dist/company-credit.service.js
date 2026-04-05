import { Injectable } from '@nestjs/common';
@Injectable()
export class CompanyCreditService {
    companies = new Map();
    constructor() {
        this.seedInitialData();
    }
    /**
     * 导入点子大师提供的 2026 深圳中职实习单位全网信用分库 (Task #26)
     */
    seedInitialData() {
        const rawData = [
            { id: '1', name: '泰科电子（深圳）有限公司', industry: '电子/制造', tags: ['外企', '规范'], score: 94, advice: '极力推荐：适合追求规范化管理的学生。' },
            { id: '2', name: '深圳比亚迪股份有限公司', industry: '电子/制造', tags: ['大厂', '技术广'], score: 88, advice: '推荐：适合能吃苦、想学核心技术的学生。' },
            { id: '3', name: '富士康科技集团（龙华园区）', industry: '电子/制造', tags: ['巨头', '包食宿'], score: 82, advice: '推荐：体系成熟，但注意心理压力调节。' },
            { id: '4', name: '深圳嘉立创科技集团', industry: '电子/制造', tags: ['精密质检', '本土名企'], score: 90, advice: '极力推荐：适合逻辑细致度高的学生。' },
            { id: '5', name: '大疆创新（DJI）实习中心', industry: '智能硬件', tags: ['极客', '高成长'], score: 96, advice: '梦校级：适合专业课极优的顶尖学生。' },
            { id: '9', name: '某龙华某小型贴片厂', industry: '电子/制造', tags: ['加班无薪', '环境差'], score: 58, advice: '高危：存在非法扣押证件记录，避雷！', report: '该单位在 2025 年曾有 3 起劳动仲裁记录，主要涉及实习生押金不退还及违法延长工时。' },
            { id: '18', name: '深圳市某某劳务派遣有限公司', industry: '劳务中介', tags: ['抽成高', '信息虚假'], score: 45, advice: '红灯：多次涉及劳动诈骗，严禁投递！', report: '典型的“黑中介”，通过虚假高薪诱导学生面试并收取体检费、工服费，随后失联。' },
            { id: '24', name: '某布吉餐饮小店', industry: '餐饮/服务', tags: ['零薪试用', '无社保'], score: 52, advice: '高危：合同无保障，典型“黑店”。', report: '老板口碑极差，存在辱骂实习生及拖欠极低工资的情况。' },
            // ... 更多数据可通过脚本批量导入
        ];
        rawData.forEach(item => {
            let level = 'green';
            if (item.score < 60)
                level = 'red';
            else if (item.score < 70)
                level = 'orange';
            else if (item.score < 85)
                level = 'yellow';
            this.companies.set(item.name, {
                id: item.id,
                name: item.name,
                industry: item.industry,
                tags: item.tags,
                creditScore: item.score,
                riskLevel: level,
                advice: item.advice,
                detailedReport: item.report
            });
        });
    }
    async findByName(name) {
        // 支持模糊匹配
        for (const [key, value] of this.companies) {
            if (key.includes(name) || name.includes(key))
                return value;
        }
        return undefined;
    }
    async getBestAlternatives(industry, limit = 3) {
        return Array.from(this.companies.values())
            .filter(c => c.industry === industry && c.riskLevel === 'green')
            .sort((a, b) => b.creditScore - a.creditScore)
            .slice(0, limit);
    }
}

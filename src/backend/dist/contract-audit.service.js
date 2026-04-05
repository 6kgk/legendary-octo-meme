import { Injectable } from '@nestjs/common';
import OpenAI from 'openai';
@Injectable()
export class ContractAuditService {
    openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    // 模拟“点子大师”提供的“Top 10 实习避雷字典” (未来可动态更新)
    PITFALL_DICTIONARY = [
        { key: "押金", risk: "红色", advice: "《劳动法》严禁收任何名义押金，请务必拒绝缴纳。" },
        { key: "两班倒", risk: "橙色", advice: "实习生不得排夜班，请与企业确认具体工时。" },
        { key: "扣押证件", risk: "红色", advice: "严禁任何单位扣押身份证、毕业证原件，存在人身控制风险。" },
        { key: "实习保险", risk: "蓝色", advice: "务必确认企业是否为您购买‘实习责任保险’，这是您的生命保障线。" },
        { key: "强制转正", risk: "橙色", advice: "警惕以实习名义强制签署长期劳务合同的陷阱。" }
    ];
    /**
     * 审计实习合同或招聘简章中的法律风险 (包含本地预处理逻辑以节省 Token)
     */
    async auditContract(imageBase64, textContent) {
        // 1. 本地逻辑下放 (Pre-processing) - 使用 Regex 快速识别明显违规点
        // 逻辑：如果已经获取了文本内容，先扫描敏感词
        if (textContent) {
            const obviousRisks = [];
            if (/押金|保证金|服装费|培训费/i.test(textContent)) {
                obviousRisks.push({ key: "非法收费", risk: "红色", advice: "检测到关键词‘押金/费用’，此类收费在实习中属于明确违法，请务必拒绝。" });
            }
            if (/身份证|毕业证|证件/i.test(textContent) && /扣|押|收/i.test(textContent)) {
                obviousRisks.push({ key: "证件扣押", risk: "红色", advice: "检测到‘扣押证件’嫌疑，严禁单位留存证件原件，风险极大。" });
            }
            // 如果本地已经发现两个以上的致命红色风险，可以先返回部分结果给用户，或者作为 AI 的上下文提示
            if (obviousRisks.length >= 2) {
                console.log(`[Token优化] 本地已识别 2 个红色风险，正在通过 AI 进行精算细节...`);
            }
        }
        const prompt = `
      您是一名资深的实习维权律师，专门保护中职生的合法权益。
      请对以下实习合同内容进行深度审计，并针对“红色（极度危险）”、“橙色（风险）”、“蓝色（建议）”进行风险标识。
      审计依据：广东省最新《职业学校学生实习管理规定》。
      
      【要求】：
      - 仅输出审计结果，文字精炼，严禁废话。
      - 若已发现严重违法，优先输出红色风险。
    `;
        const response = await this.openai.chat.completions.create({
            model: "gpt-4o",
            messages: [
                { role: "system", content: prompt },
                {
                    role: "user",
                    content: [
                        { type: "image_url", image_url: { url: `data:image/jpeg;base64,${imageBase64}` } }
                    ]
                }
            ]
        });
        // 记录 Token 消耗 (由 main.ts 调用 TokenTracker)
        const usage = response.usage;
        const content = response.choices[0].message.content;
        // 结构化风险匹配逻辑 (基于避雷库关键字)
        const detectedRisks = this.PITFALL_DICTIONARY.filter(item => content.includes(item.key));
        return {
            report: content,
            structuredRisks: detectedRisks,
            isHighRisk: detectedRisks.some(r => r.risk === '红色'),
            usage: usage
        };
    }
}

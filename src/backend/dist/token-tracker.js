import { Injectable } from '@nestjs/common';
/**
 * 【职教通】Token 监控与成本审计模块 (Task #24)
 * 职责：
 * 1. 统计每次 API 调用的 Prompt 与 Completion Token。
 * 2. 实时记录高能耗请求，输出成本审计日志。
 */
@Injectable()
export class TokenTracker {
    totalPromptTokens = 0;
    totalCompletionTokens = 0;
    /**
     * 记录一次 AI 调用产生的消耗
     */
    trackUsage(usage, source) {
        this.totalPromptTokens += usage.prompt_tokens;
        this.totalCompletionTokens += usage.completion_tokens;
        console.log(`[Token审计] 来源: ${source} | 本次消耗: ${usage.prompt_tokens + usage.completion_tokens} | 累计总计: ${this.totalPromptTokens + this.totalCompletionTokens}`);
        // 如果单词调用超过 1500 tokens，记录警告
        if (usage.prompt_tokens + usage.completion_tokens > 1500) {
            console.warn(`[高能耗警报] 来源: ${source} 单词调用消耗过高，建议优化 Prompt 结构。`);
        }
    }
    getStats() {
        return {
            prompt: this.totalPromptTokens,
            completion: this.totalCompletionTokens,
            total: this.totalPromptTokens + this.totalCompletionTokens
        };
    }
}

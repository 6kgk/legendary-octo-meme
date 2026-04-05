import { Injectable } from '@nestjs/common';
@Injectable()
export class PaymentService {
    userService;
    transactions = new Map();
    constructor(userService) {
        this.userService = userService;
    }
    /**
     * 发起支付 (模拟连接支付网关)
     */
    async createPaymentOrder(userId, plan) {
        const user = await this.userService.findById(userId);
        if (!user)
            throw new Error('用户不存在');
        const amountMap = { 'premium': 49.00, 'vip': 199.00 };
        const amount = amountMap[plan] || 0;
        const transaction = {
            id: `TXN_${Math.random().toString(36).substring(2, 10).toUpperCase()}`,
            userId: userId,
            amount: amount,
            planName: plan === 'premium' ? '提分版' : '就业版',
            status: 'pending',
            createdAt: new Date(),
        };
        this.transactions.set(transaction.id, transaction);
        console.log(`[PaymentService] 正在为用户 ${userId} 创建支付订单: ${transaction.id} (${transaction.planName})`);
        return transaction;
    }
    /**
     * 确认支付 (模拟支付成功回调)
     */
    async confirmPayment(transactionId) {
        const transaction = this.transactions.get(transactionId);
        if (!transaction)
            throw new Error('订单不存在');
        if (transaction.status === 'completed') {
            const user = await this.userService.findById(transaction.userId);
            return { success: true, userProfile: user };
        }
        // 模拟成功逻辑
        transaction.status = 'completed';
        this.transactions.set(transactionId, transaction);
        const level = transaction.planName === '提分版' ? 'premium' : 'vip';
        const updatedUser = await this.userService.upgradeSubscription(transaction.userId, level);
        console.log(`[PaymentService] 支付确认成功: 订单号 ${transactionId}。用户已升级为 ${transaction.planName}`);
        return { success: true, userProfile: updatedUser };
    }
    /**
     * 获取订阅计划详情 (林老板版商业说明)
     */
    getAvailablePlans() {
        return [
            { id: 'basic', name: '基础版', price: 0, features: ['拍搜讲题 (限次)', '公开职位浏览'] },
            { id: 'premium', name: '提分版', price: 49, features: ['AI 1对1 启发式全科讲题 (不限)', '提分点雷达图'] },
            { id: 'vip', name: '就业版', price: 199, features: ['AI 简历深度生成与背书', '实习合同安全风险极速扫描 (不限)', '实习大厂优先内部推荐'] }
        ];
    }
}

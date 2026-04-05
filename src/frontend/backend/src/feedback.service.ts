export class FeedbackService {
  private feedbacks: any[] = [];

  async submitFeedback(userId: string, type: 'bug' | 'suggestion' | 'tutor_quality', content: string) {
    const feedback = {
      id: `FB_${Date.now()}`,
      userId,
      type,
      content,
      status: 'pending',
      createdAt: new Date()
    };
    this.feedbacks.push(feedback);
    console.log(`[用户反馈] 收到来自 ${userId} 的反馈 [${type}]: ${content.substring(0, 20)}...`);
    return feedback;
  }

  getFeedbacks() {
    return this.feedbacks;
  }
}

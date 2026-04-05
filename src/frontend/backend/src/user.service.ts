export interface UserProfile {
  id: string;
  username: string;       // 必填
  phoneNumber: string;    // 必填
  schoolName: string;     // 必填
  grade: string;          // 必填
  major: string;          // 必填
  passwordHash: string;   // 必填
  
  realName?: string;      // 选填
  gradDate?: Date;        // 选填
  prefLocation?: string;  // 选填
  workExperience?: string; // 选填
  certifications?: string[]; // 选填
  careerGoal?: string;     // 选填
  expectedSalary?: string; // 选填
  
  subscriptionLevel: 'basic' | 'premium' | 'vip';
  points: number;
  createdAt: Date;
}

export class UserService {
  // 模拟数据库
  private users: Map<string, UserProfile> = new Map();

  /**
   * 用户注册 (遵循隐私优先原则：用户名必填，真实姓名选填)
   */
  async register(data: Partial<UserProfile>): Promise<UserProfile> {
    if (!data.username || !data.phoneNumber || !data.schoolName || !data.grade || !data.major) {
      throw new Error('基础档案信息（用户名、手机、学校、专业、年级）为必填项');
    }

    // 检查唯一性 (模拟)
    for (const u of this.users.values()) {
      if (u.username === data.username) throw new Error('用户名已存在');
      if (u.phoneNumber === data.phoneNumber) throw new Error('手机号已注册');
    }

    const newUser: UserProfile = {
      id: Math.random().toString(36).substring(2, 15),
      username: data.username,
      phoneNumber: data.phoneNumber,
      schoolName: data.schoolName,
      grade: data.grade,
      major: data.major,
      passwordHash: 'hashed_password', // 实际应使用 bcrypt
      realName: data.realName || undefined,
      gradDate: data.gradDate,
      prefLocation: data.prefLocation,
      workExperience: data.workExperience,
      certifications: data.certifications,
      careerGoal: data.careerGoal,
      expectedSalary: data.expectedSalary,
      subscriptionLevel: 'basic',
      points: 0,
      createdAt: new Date(),
    };

    this.users.set(newUser.id, newUser);
    console.log(`[UserService] 新用户注册成功: ${newUser.username} (${newUser.id})`);
    return newUser;
  }

  /**
   * 更新用户信息 (用于分阶段引导补全实名)
   */
  async updateProfile(userId: string, data: Partial<UserProfile>): Promise<UserProfile> {
    const user = this.users.get(userId);
    if (!user) throw new Error('用户不存在');

    const updatedUser = { ...user, ...data };
    this.users.set(userId, updatedUser);
    
    if (data.realName) {
      console.log(`[UserService] 用户已完成实名认证: ${data.realName}`);
    }
    
    return updatedUser;
  }

  async findById(userId: string): Promise<UserProfile | undefined> {
    return this.users.get(userId);
  }

  /**
   * 获取所有注册用户 (Task #48 管理看板使用)
   */
  getAllUsers(): UserProfile[] {
    return Array.from(this.users.values());
  }

  async upgradeSubscription(userId: string, level: 'premium' | 'vip'): Promise<UserProfile> {
    const user = this.users.get(userId);
    if (!user) throw new Error('用户不存在');

    user.subscriptionLevel = level;
    this.users.set(userId, user);
    console.log(`[UserService] 用户 ${userId} 订阅等级已升级至: ${level}`);
    return user;
  }
}

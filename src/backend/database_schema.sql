-- 【职教通】核心数据库架构 (PostgreSQL)

-- 1. 用户表 (包含中职生基本信息)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL, -- 必填：用户名
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    real_name VARCHAR(50),      -- 选填：真实姓名
    school_name VARCHAR(100),    -- 必填：所在中职学校
    grade VARCHAR(20),          -- 必填：年级
    major VARCHAR(50),           -- 必填：专业
    grad_date DATE,             -- 选填：预计毕业时间
    
    pref_location VARCHAR(100), -- 选填：意向实习区域
    work_experience TEXT,       -- 选填：过往兼职经历
    certifications TEXT[],      -- 选填：个人技能/证书
    career_goal TEXT,           -- 选填：职业理想
    expected_salary VARCHAR(50), -- 选填：期望薪资
    
    subscription_level VARCHAR(20) DEFAULT 'basic',
    points INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. 订单/交易表
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    amount DECIMAL(10,2) NOT NULL,
    plan_name VARCHAR(50), -- 提分版/就业版
    status VARCHAR(20) DEFAULT 'pending', -- pending, completed, failed
    transaction_id TEXT, -- 支付平台流水号
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. 知识点/技能图谱库
CREATE TABLE skill_nodes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject VARCHAR(20),      -- 数学/英语/语文/专业课
    node_name VARCHAR(100),   -- 知识点名称 (如：二次函数、并集)
    vocation_mapping JSONB,   -- 关联的职业能力 (如：{"logic": 0.8, "detail": 0.2})
    level INTEGER             -- 知识点难度等级
);

-- 3. 学习进度/能力雷达 (核心背书数据)
CREATE TABLE student_skill_radar (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    logic_score DECIMAL(5,2) DEFAULT 0,
    data_analysis_score DECIMAL(5,2) DEFAULT 0,
    english_literacy_score DECIMAL(5,2) DEFAULT 0,
    patience_score DECIMAL(5,2) DEFAULT 0, -- 根据错题复盘频率计算
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. 错题本与拍搜记录
CREATE TABLE question_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    image_url TEXT,           -- 拍题上传的图片地址
    question_text TEXT,       -- OCR 解析后的文本
    subject VARCHAR(20),
    skill_node_id UUID REFERENCES skill_nodes(id),
    is_resolved BOOLEAN DEFAULT FALSE, -- 学生是否最终独立算出答案
    conversation_log JSONB,   -- 存储 AI 引导的全过程对话流
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. 实习合同/简章审计记录
CREATE TABLE contract_audits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    file_url TEXT,            -- 合同图片或文档
    risk_report JSONB,        -- AI 生成的风险报告 (红/橙/蓝等级)
    audit_status VARCHAR(20), -- 待审计/审计完成
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. 实习广场 (自由投递库)
CREATE TABLE internship_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name VARCHAR(100),
    job_title VARCHAR(100),
    district VARCHAR(50),     -- 深圳行政区 (龙华/南山/龙岗等)
    salary_range VARCHAR(50),
    requirements_radar JSONB, -- 岗位门槛雷达分 (如：{"logic": 70})
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

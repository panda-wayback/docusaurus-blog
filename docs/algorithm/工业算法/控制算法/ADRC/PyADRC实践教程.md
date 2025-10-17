# PyADRC 实践教程

## 前言

本教程通过 Python 的 pyadrc 库，让你在实际编程中理解 ADRC 的工作原理和应用方法。通过运行代码、调整参数、观察结果，你将更直观地掌握 ADRC 控制器的特性。

## 环境准备

### 安装依赖库

```bash
# 安装 pyadrc 库
pip install pyadrc

# 安装绘图和数值计算库
pip install numpy matplotlib scipy
```

## 基础示例：一阶系统控制

### 示例 1：简单的位置跟踪

让我们从最简单的例子开始，控制一个一阶系统跟踪目标位置。

```python
import numpy as np
import matplotlib.pyplot as plt
from pyadrc import ADRC

# ============ 步骤 1：定义被控系统 ============
def system_dynamics(x, u, t):
    """
    一阶系统动态模型
    dx/dt = -0.5*x + u + disturbance
    
    参数:
        x: 当前状态（位置）
        u: 控制输入
        t: 当前时间
    返回:
        dx: 状态变化率
    """
    # 添加外部扰动（在 t=5s 时突然加入）
    disturbance = 2.0 if t > 5 else 0.0
    
    # 系统动态：带有衰减和扰动
    dx = -0.5 * x + u + disturbance
    return dx


# ============ 步骤 2：创建 ADRC 控制器 ============
# 创建一阶 ADRC 控制器
adrc = ADRC(
    order=1,           # 系统阶数（1阶系统）
    delta_t=0.01,      # 采样时间
    r=100,             # 跟踪速度因子（越大响应越快，但可能振荡）
    h=0.01,            # ESO 滤波参数
    b0=1.0,            # 控制增益估计值
    k_eso=[3, 3],      # ESO 观测器增益 [beta1, beta2]
    k_nlsef=[5]        # 非线性反馈增益
)


# ============ 步骤 3：仿真设置 ============
dt = 0.01              # 仿真步长
t_total = 10.0         # 总仿真时间
steps = int(t_total / dt)

# 初始化数组存储结果
time = np.zeros(steps)
reference = np.zeros(steps)  # 目标值
actual = np.zeros(steps)     # 实际值
control = np.zeros(steps)    # 控制量
disturbance_record = np.zeros(steps)  # 扰动估计

# 初始状态
x = 0.0  # 初始位置


# ============ 步骤 4：运行仿真 ============
for i in range(steps):
    t = i * dt
    time[i] = t
    
    # 设定参考轨迹（目标值）
    if t < 2:
        r = 1.0  # 前 2 秒目标为 1
    elif t < 7:
        r = 3.0  # 2-7 秒目标为 3
    else:
        r = 2.0  # 7 秒后目标为 2
    
    reference[i] = r
    
    # ADRC 控制器计算控制量
    # 输入：目标值 r 和当前状态 x
    u = adrc.control(r, x)
    
    # 限制控制量幅值（模拟执行器饱和）
    u = np.clip(u, -10, 10)
    control[i] = u
    
    # 记录 ESO 估计的扰动
    disturbance_record[i] = adrc.z[1] if len(adrc.z) > 1 else 0
    
    # 系统动态演化（欧拉法数值积分）
    dx = system_dynamics(x, u, t)
    x = x + dx * dt
    
    actual[i] = x


# ============ 步骤 5：结果可视化 ============
plt.figure(figsize=(12, 8))

# 子图 1：位置跟踪效果
plt.subplot(3, 1, 1)
plt.plot(time, reference, 'r--', label='目标位置', linewidth=2)
plt.plot(time, actual, 'b-', label='实际位置', linewidth=1.5)
plt.ylabel('位置')
plt.legend()
plt.grid(True)
plt.title('ADRC 控制效果')

# 子图 2：控制量
plt.subplot(3, 1, 2)
plt.plot(time, control, 'g-', linewidth=1.5)
plt.ylabel('控制量 u')
plt.grid(True)

# 子图 3：扰动估计
plt.subplot(3, 1, 3)
plt.plot(time, disturbance_record, 'm-', label='ESO 估计的总扰动', linewidth=1.5)
plt.axvline(x=5, color='r', linestyle='--', label='扰动加入时刻')
plt.ylabel('扰动估计')
plt.xlabel('时间 (s)')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.savefig('adrc_control_result.png', dpi=300)
plt.show()

print("仿真完成！")
```

### 运行结果分析

运行上述代码后，你会看到三个子图：

1. **位置跟踪效果图**：
   - 蓝线（实际位置）快速跟踪红色虚线（目标位置）
   - 即使在 t=5s 加入扰动，系统也能快速恢复跟踪

2. **控制量图**：
   - 显示 ADRC 计算的控制输入
   - 在目标变化和扰动出现时，控制量会相应调整

3. **扰动估计图**：
   - ESO 能够实时估计出系统受到的总扰动
   - 在 t=5s 扰动加入后，估计值迅速跟踪到实际扰动

## 进阶示例：二阶系统控制

### 示例 2：电机位置控制

让我们控制一个二阶系统（类似电机位置控制）：

```python
import numpy as np
import matplotlib.pyplot as plt
from pyadrc import ADRC

# ============ 定义二阶系统（电机模型）============
class MotorSystem:
    """
    简化的电机位置控制模型
    d²θ/dt² = -c₁*dθ/dt - c₂*θ + b*u + d(t)
    其中：θ 是角度，u 是控制输入，d(t) 是扰动
    """
    def __init__(self):
        self.position = 0.0      # 角度 θ
        self.velocity = 0.0      # 角速度 dθ/dt
        self.c1 = 0.5            # 阻尼系数
        self.c2 = 0.3            # 刚度系数
        self.b = 1.0             # 控制增益
        self.J = 1.0             # 转动惯量
    
    def update(self, u, dt, t):
        """
        更新电机状态
        
        参数:
            u: 控制力矩
            dt: 时间步长
            t: 当前时间
        """
        # 模拟负载扰动（周期性变化）
        disturbance = 0.5 * np.sin(0.5 * t) if t > 3 else 0
        
        # 二阶动态方程
        acceleration = (-self.c1 * self.velocity - 
                       self.c2 * self.position + 
                       self.b * u + disturbance) / self.J
        
        # 数值积分更新状态
        self.velocity += acceleration * dt
        self.position += self.velocity * dt
        
        return self.position, self.velocity


# ============ 创建二阶 ADRC 控制器 ============
adrc = ADRC(
    order=2,              # 二阶系统
    delta_t=0.01,         # 采样时间
    r=50,                 # 跟踪速度因子
    h=0.1,                # 滤波参数
    b0=1.0,               # 控制增益估计
    k_eso=[100, 300, 500], # ESO 增益 [beta1, beta2, beta3]
    k_nlsef=[10, 5]       # 非线性反馈增益 [位置增益, 速度增益]
)


# ============ 仿真参数设置 ============
dt = 0.01
t_total = 15.0
steps = int(t_total / dt)

# 初始化
motor = MotorSystem()
time = np.zeros(steps)
reference = np.zeros(steps)
position = np.zeros(steps)
velocity = np.zeros(steps)
control = np.zeros(steps)
tracking_error = np.zeros(steps)


# ============ 运行仿真 ============
for i in range(steps):
    t = i * dt
    time[i] = t
    
    # 生成参考轨迹（阶跃 + 斜坡 + 正弦）
    if t < 3:
        r = 0
    elif t < 8:
        r = 2.0  # 阶跃到 2
    else:
        r = 2.0 + 1.0 * np.sin(0.5 * t)  # 正弦波动
    
    reference[i] = r
    
    # ADRC 计算控制量（只需要位置测量）
    u = adrc.control(r, motor.position)
    
    # 限制控制力矩
    u = np.clip(u, -20, 20)
    control[i] = u
    
    # 更新电机状态
    pos, vel = motor.update(u, dt, t)
    position[i] = pos
    velocity[i] = vel
    tracking_error[i] = r - pos


# ============ 绘制结果 ============
plt.figure(figsize=(14, 10))

# 子图 1：位置跟踪
plt.subplot(4, 1, 1)
plt.plot(time, reference, 'r--', label='目标位置', linewidth=2)
plt.plot(time, position, 'b-', label='实际位置', linewidth=1.5)
plt.ylabel('角度 (rad)')
plt.legend(loc='upper left')
plt.grid(True)
plt.title('二阶系统 ADRC 控制（电机位置控制）')

# 子图 2：跟踪误差
plt.subplot(4, 1, 2)
plt.plot(time, tracking_error, 'r-', linewidth=1.5)
plt.ylabel('跟踪误差 (rad)')
plt.grid(True)
plt.axhline(y=0, color='k', linestyle='--', alpha=0.3)

# 子图 3：速度
plt.subplot(4, 1, 3)
plt.plot(time, velocity, 'g-', linewidth=1.5)
plt.ylabel('角速度 (rad/s)')
plt.grid(True)

# 子图 4：控制量
plt.subplot(4, 1, 4)
plt.plot(time, control, 'm-', linewidth=1.5)
plt.ylabel('控制力矩')
plt.xlabel('时间 (s)')
plt.grid(True)

plt.tight_layout()
plt.savefig('adrc_motor_control.png', dpi=300)
plt.show()

print(f"最大跟踪误差: {np.max(np.abs(tracking_error)):.4f} rad")
print(f"稳态误差(最后1秒): {np.mean(np.abs(tracking_error[-100:])):.4f} rad")
```

## ADRC 参数调整指南

### 关键参数说明

| 参数 | 作用 | 调整建议 |
|------|------|----------|
| `r` | 跟踪速度 | 增大加快响应，但可能振荡；建议从小到大调整 |
| `h` | TD 滤波系数 | 一般设为 dt 的 1-10 倍 |
| `b0` | 控制增益估计 | 尽量准确估计，影响控制精度 |
| `k_eso` | ESO 观测器增益 | 增大提高观测速度，但对噪声敏感 |
| `k_nlsef` | 反馈增益 | 增大提高控制刚度，类似 PID 的比例增益 |

### 参数调整步骤

1. **先调 `b0`**：根据系统特性估计控制增益
2. **再调 `r`**：从小开始，逐渐增大直到响应满意
3. **调整 `k_eso`**：观察扰动估计效果，确保 ESO 快速收敛
4. **微调 `k_nlsef`**：优化稳态性能和抗扰能力

### 实践练习代码

```python
# 交互式参数调整实验
def experiment_with_parameters():
    """
    尝试不同的参数组合，观察控制效果
    """
    # 参数组合列表
    param_sets = [
        {'r': 20, 'k_eso': [50, 100, 200], 'label': '保守参数'},
        {'r': 100, 'k_eso': [100, 300, 500], 'label': '激进参数'},
        {'r': 50, 'k_eso': [100, 300, 500], 'label': '平衡参数'},
    ]
    
    plt.figure(figsize=(12, 6))
    
    for params in param_sets:
        # 创建控制器
        adrc = ADRC(
            order=2,
            delta_t=0.01,
            r=params['r'],
            h=0.1,
            b0=1.0,
            k_eso=params['k_eso'],
            k_nlsef=[10, 5]
        )
        
        # 简单仿真
        motor = MotorSystem()
        time_array = []
        pos_array = []
        
        for i in range(500):
            t = i * 0.01
            r = 2.0 if t > 0.5 else 0  # 阶跃目标
            u = adrc.control(r, motor.position)
            u = np.clip(u, -20, 20)
            motor.update(u, 0.01, t)
            
            time_array.append(t)
            pos_array.append(motor.position)
        
        # 绘制结果
        plt.plot(time_array, pos_array, label=params['label'], linewidth=2)
    
    plt.axhline(y=2.0, color='r', linestyle='--', label='目标值')
    plt.xlabel('时间 (s)')
    plt.ylabel('位置')
    plt.title('不同参数组合的控制效果对比')
    plt.legend()
    plt.grid(True)
    plt.show()

# 运行实验
experiment_with_parameters()
```

## 与 PID 对比实验

```python
def compare_adrc_pid():
    """
    对比 ADRC 和 PID 在相同系统上的控制效果
    """
    import matplotlib.pyplot as plt
    
    # ADRC 控制器
    adrc = ADRC(order=2, delta_t=0.01, r=50, h=0.1, b0=1.0,
                k_eso=[100, 300, 500], k_nlsef=[10, 5])
    
    # 简单 PID 控制器
    class SimplePID:
        def __init__(self, kp, ki, kd, dt):
            self.kp, self.ki, self.kd = kp, ki, kd
            self.dt = dt
            self.integral = 0
            self.prev_error = 0
        
        def control(self, setpoint, measurement):
            error = setpoint - measurement
            self.integral += error * self.dt
            derivative = (error - self.prev_error) / self.dt
            self.prev_error = error
            return self.kp * error + self.ki * self.integral + self.kd * derivative
    
    pid = SimplePID(kp=8, ki=2, kd=3, dt=0.01)
    
    # 仿真
    dt, t_total = 0.01, 10.0
    steps = int(t_total / dt)
    
    # ADRC 仿真
    motor_adrc = MotorSystem()
    pos_adrc = []
    for i in range(steps):
        t = i * dt
        r = 2.0 if t > 1 else 0
        u = adrc.control(r, motor_adrc.position)
        u = np.clip(u, -20, 20)
        motor_adrc.update(u, dt, t)
        pos_adrc.append(motor_adrc.position)
    
    # PID 仿真
    motor_pid = MotorSystem()
    pos_pid = []
    for i in range(steps):
        t = i * dt
        r = 2.0 if t > 1 else 0
        u = pid.control(r, motor_pid.position)
        u = np.clip(u, -20, 20)
        motor_pid.update(u, dt, t)
        pos_pid.append(motor_pid.position)
    
    # 绘图对比
    time = np.arange(0, t_total, dt)
    plt.figure(figsize=(10, 6))
    plt.plot(time, [2.0 if t > 1 else 0 for t in time], 
             'r--', label='目标', linewidth=2)
    plt.plot(time, pos_adrc, 'b-', label='ADRC', linewidth=1.5)
    plt.plot(time, pos_pid, 'g-', label='PID', linewidth=1.5)
    plt.xlabel('时间 (s)')
    plt.ylabel('位置')
    plt.title('ADRC vs PID 控制效果对比')
    plt.legend()
    plt.grid(True)
    plt.show()

# 运行对比实验
compare_adrc_pid()
```

## 学习建议

1. **从简单开始**：先运行一阶系统示例，理解基本流程
2. **观察 ESO**：重点关注扰动估计，这是 ADRC 的核心
3. **调整参数**：亲手修改参数，观察控制效果的变化
4. **添加扰动**：尝试添加不同类型的扰动，测试抗扰能力
5. **对比实验**：与 PID 对比，体会 ADRC 的优势

## 常见问题

### Q1: 控制震荡怎么办？
- 减小 `r` 值，降低跟踪速度
- 减小 `k_nlsef` 增益
- 增大滤波参数 `h`

### Q2: 响应太慢？
- 增大 `r` 值
- 增大 `k_eso` 增益（但不要过大）
- 检查 `b0` 是否估计准确

### Q3: 有稳态误差？
- 检查 `b0` 估计值是否准确
- 适当增大 `k_eso` 的第一个元素
- 确认系统模型阶数是否正确

## 下一步学习

- 深入理解 ESO（扩张状态观测器）的数学原理
- 学习 ADRC 参数自整定方法
- 研究线性 ADRC（LADRC）的简化实现
- 应用到实际硬件系统（如 Arduino、树莓派）

---

**提示**：建议将以上代码保存为 `.py` 文件，在 Jupyter Notebook 或 Python IDE 中逐段运行，边运行边思考，效果最佳！

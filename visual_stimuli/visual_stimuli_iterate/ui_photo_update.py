from psychopy import visual, core, event, gui
import random, os
import numpy as np

# 设置白色背景
# 在创建窗口时指定刷新率
win = visual.Window(
    fullscr=True, 
    color='white', 
    units='height',
    screen=0,  # 指定屏幕编号
    waitBlanking=True,  # 等待垂直空白
    allowGUI=False  # 禁用GUI以提升性能
)

# 定义图片刺激路径
stimuli_path = r'C:\Users\14796\Desktop\stimuli photo\revised'
image_files = {
    'up': 'up(1).jpg',
    'down': 'down(1).jpg', 
    'left': 'left(1).jpg',
    'right': 'right(1).png'
}

# 加载图片刺激并保持原始比例
image_stim = {}

# 加载图片
for direction, filename in image_files.items():
    full_path = os.path.join(stimuli_path, filename)
    if os.path.exists(full_path):
        # 创建图片刺激，保持原始比例
        image_stim[direction] = visual.ImageStim(win, image=full_path, size=(0.35, None))
    else:
        print(f"警告: 文件不存在: {full_path}")

# 设置图片位置
positions = {
    'up': (-0.4, 0.3),     # 左上角
    'right': (0.4, 0.3),   # 右上角  
    'down': (0.4, -0.24),  # 右下角
    'left': (-0.4, -0.24)  # 左下角
}

# 调整图片尺寸和位置
for direction, stim in image_stim.items():
    if direction in positions:
        stim.pos = positions[direction]
        stim.size = (0.7, None)  # 设置宽度，高度保持比例

# 优化的训练参数（加快刺激频率）
stim_duration = 0.2      # 刺激呈现时间（125ms，P300常用参数）
stim_interval = 0.3      # 刺激间隔时间（375ms）
total_soa = 0.5            # 总刺激间隔500ms（2Hz，适合P300诱发）

# 控制实验总时长在5-6分钟
total_trials = 300         # 300个试次（约2.5分钟刺激时间）
target_prob = 0.2          # 20%靶刺激
min_target_interval = 2    # 靶刺激至少间隔2个非靶刺激

# 创建注视点
fixation = visual.ShapeStim(
    win,
    vertices='circle',
    size=(0.02, 0.02),
    fillColor='black',
    lineColor='black'
)



# 随机选择靶刺激方向（整个实验固定一个方向）
directions = ['up', 'down', 'left', 'right']
target_direction = random.choice(directions)

def generate_pseudorandom_sequence(total_trials, target_prob, min_interval, target_dir):
    """生成伪随机刺激序列，避免连续靶刺激"""
    sequence = []
    non_target_dirs = [d for d in directions if d != target_dir]
    
    # 计算需要的靶刺激数量
    n_targets = int(total_trials * target_prob)
    
    # 生成靶刺激位置（确保间隔）
    target_positions = []
    current_pos = min_interval + 1
    
    while len(target_positions) < n_targets and current_pos < total_trials:
        target_positions.append(current_pos)
        current_pos += random.randint(min_interval + 1, min_interval + 3)
    
    # 如果靶刺激数量不足，补充
    if len(target_positions) < n_targets:
        remaining = n_targets - len(target_positions)
        for i in range(remaining):
            pos = random.randint(min_interval, total_trials - 1)
            while pos in target_positions:
                pos = random.randint(min_interval, total_trials - 1)
            target_positions.append(pos)
    
    # 创建序列
    for i in range(total_trials):
        if i in target_positions:
            # 靶刺激
            sequence.append({
                'trial_index': i + 1,
                'direction': target_dir,
                'is_target': True
            })
        else:
            # 非靶刺激
            # 避免连续出现同一非靶刺激
            if len(sequence) > 0 and not sequence[-1]['is_target']:
                last_dir = sequence[-1]['direction']
                available_dirs = [d for d in non_target_dirs if d != last_dir]
                if not available_dirs:
                    available_dirs = non_target_dirs
            else:
                available_dirs = non_target_dirs
            
            direction = random.choice(available_dirs)
            sequence.append({
                'trial_index': i + 1,
                'direction': direction,
                'is_target': False
            })
    
    return sequence

# 生成刺激序列
trials = generate_pseudorandom_sequence(total_trials, target_prob, min_target_interval, target_direction)

def show_instructions():
    
    # 第一部分：文字说明任务
    instruction_text = """
    实验说明

    任务说明：
    1. 屏幕上会显示四个方向的图片，并快速随机闪烁（每次只显示一个）
    2. 正式实验前会告知关注哪个方向的图片，并要求您计数
    3. 本次训练共有300次闪烁，实验结束后需要报告计数的次数
    4. 实验过程中请不要误触键盘或鼠标，防止实验意外退出
    5. 每60次闪烁后都将提供休息时间，按空格后将会继续实验


    请保持注意力集中，尽量减少眨眼和身体移动。

    按空格键继续...
    """
    
    # 显示文本
    instruction = visual.TextStim(win, text=instruction_text, color='black', 
                                  height=0.03, wrapWidth=1.5)
    instruction.draw()
    win.flip()
    event.waitKeys(keyList=['space'])
    
    # 依次展示每个图片
    for direction in ['up', 'right', 'down', 'left']:
        win.flip()
        core.wait(0.3)
        
        # 绘制当前图片
        if direction in image_stim:
            image_stim[direction].draw()
        
        # 显示方向说明
        dir_text = {
            'up': '这是向上',
            'right': '这是向右',
            'down': '这是向下',
            'left': '这是向左'
        }
        
        text_stim = visual.TextStim(win, text=dir_text[direction], 
                                    color='black', height=0.04,
                                    pos=(0, 0))
        text_stim.draw()
        
        continue_text = visual.TextStim(win, text="按空格键继续...", 
                                       color='gray', height=0.03, pos=(0, -0.4))
        continue_text.draw()
        
        win.flip()
        event.waitKeys(keyList=['space'])

def show_target_instruction():
    """显示靶刺激说明（训练专用）"""
    direction_desc = {
        'up': '左上角（向上）',
        'right': '右上角（向右）',
        'down': '右下角（向下）',
        'left': '左下角（向左）'
    }
    
    target_text = f"本次任务：\n\n请专注关注：{direction_desc[target_direction]}\n\n当这个图片闪烁时，在心里默默计数\n\n按空格键开始实验"
    target_prompt = visual.TextStim(win, text=target_text, color='black', 
                                   height=0.035, wrapWidth=1.3, pos=(0, 0.15))
    
     # 只绘制靶刺激图片，并添加边框
    stim = image_stim[target_direction]
    
    # 计算边框大小：宽度增加0.02，高度增加0.01（减短y轴长度）
    border_width = stim.size[0] + 0.02
    border_height = stim.size[1] + 0.01
    
    # 创建边框
    border = visual.Rect(win, width=border_width, height=border_height, 
                        lineColor='red', lineWidth=5, fillColor=None,
                        pos=stim.pos)
    
    # 先绘制图片和边框
    border.draw()
    stim.draw()
    
    # 然后绘制文字，这样文字就在上层
    target_prompt.draw()
    
    win.flip()
    event.waitKeys(keyList=['space'])

def show_break(completed, total):
    """显示休息界面"""
    progress_percent = int(completed / total * 100)
    progress = f"训练进度：{completed}/{total} 试次 ({progress_percent}%)"
    
    target_desc = {
        'up': '左上角（向上）',
        'right': '右上角（向右）',
        'down': '右下角（向下）',
        'left': '左下角（向左）'
    }
    
    break_text = f"{progress}\n\n休息一下\n\n请继续保持关注：{target_desc[target_direction]}\n\n准备好后按空格键继续训练..."
    break_screen = visual.TextStim(win, text=break_text, color='black', 
                                   height=0.035, wrapWidth=1.5)
    break_screen.draw()
    win.flip()
    event.waitKeys(keyList=['space'])

# 显示指导语
show_instructions()
show_target_instruction()

# 显示准备开始提示
ready_text = visual.TextStim(win, text="准备开始训练...\n\n3", color='black', height=0.05)
ready_text.draw()
win.flip()
core.wait(1)

ready_text.text = "准备开始训练...\n\n2"
ready_text.draw()
win.flip()
core.wait(1)

ready_text.text = "准备开始训练...\n\n1"
ready_text.draw()
win.flip()
core.wait(1)

# 实验主循环
target_count = 0
actual_trials = 0

for i, trial in enumerate(trials):
    # 每60个试次休息一次
    if i > 0 and i % 60 == 0:
        show_break(i, total_trials)
    
    # 显示注视点（200ms，比原来缩短）
    fixation.draw()
    win.flip()
    core.wait(0.2)
    
    # 呈现刺激
    direction = trial['direction']
    is_target = trial['is_target']
    
    if is_target:
        target_count += 1
    
    # 闪烁效果：先显示图片，然后变暗
    if direction in image_stim:
        # 显示完整图片
        image_stim[direction].draw()
        win.flip()
        core.wait(stim_duration * 0.7)  # 70%时间显示完整图片
        
        # 短暂变暗（模拟闪烁）
        image_stim[direction].opacity = 0.5
        image_stim[direction].draw()
        win.flip()
        core.wait(stim_duration * 0.3)  # 30%时间变暗
        
        # 恢复透明度
        image_stim[direction].opacity = 1.0
    
    # 刺激间隔（空白屏）
    win.flip()
    core.wait(stim_interval)
    
    actual_trials += 1
    
    # 检查是否提前退出
    if event.getKeys(keyList=['escape']):
        print("训练被用户中断")
        break

# 显示训练完成界面
def show_training_complete():
    direction_desc = {
        'up': '左上角（向上）',
        'right': '右上角（向右）',
        'down': '右下角（向下）',
        'left': '左下角（向左）'
    }
    
    completion_text = f"""训练完成！感谢您的配合！

本次训练统计：
- 总试次数：{actual_trials}
- 靶刺激次数：{target_count}
- 训练时长：约{actual_trials * total_soa / 60:.1f}分钟

您关注的靶刺激方向是：
{direction_desc[target_direction]}

请报告您计数的结果。

十分感谢您的配合

按空格键退出程序..."""
    
    completion_screen = visual.TextStim(win, text=completion_text, color='black', 
                                       height=0.035, wrapWidth=1.5)
    completion_screen.draw()
    win.flip()
    event.waitKeys(keyList=['space'])

# 显示训练完成界面
show_training_complete()

# 关闭窗口
win.close()
core.quit()
import random
import time
from psychopy import visual, core, event
import numpy as np

class P300Stimulus:
    def __init__(self, screen_size=[800, 600]):
        # 创建显示窗口
        self.win = visual.Window(
            size=screen_size,
            color=[-1, -1, -1],
            units='pix',
            fullscr=False,
            screen=0
        )
        
        # 定义四个方向
        self.commands = ['up', 'down', 'left', 'right']
        
        self.stimuli = []  
        
        self.create_stimuli()
        
        self.stim_duration = 0.2
        self.isi = 0.3
        self.repetitions_per_trial = 8 
        self.trial_count = 0

    def create_stimuli(self):
        # 修改1：将位置改为XY轴上
        positions = [[0, 200], [0, -200], [-200, 0], [200, 0]]  # 上、下、左、右
        
        # 修改2：创建空心箭头而不是方框
        for i, pos in enumerate(positions):
            # 根据方向创建不同形状的箭头
            if self.commands[i] == 'up':
                vertices = [(0, 50), (-30, -30), (0, -10), (30, -30)]
            elif self.commands[i] == 'down':
                vertices = [(0, -50), (-30, 30), (0, 10), (30, 30)]
            elif self.commands[i] == 'left':
                vertices = [(-50, 0), (30, -30), (10, 0), (30, 30)]
            elif self.commands[i] == 'right':
                vertices = [(50, 0), (-30, -30), (-10, 0), (-30, 30)]
            
            arrow = visual.ShapeStim(
                self.win,
                vertices=vertices,
                pos=pos,
                lineColor='white',
                fillColor=None,  # 空心
                lineWidth=3,
                closeShape=True
            )
            
            self.stimuli.append({'arrow': arrow})

    def draw_all_stimuli(self, highlight_idx=None):
        for i, stim in enumerate(self.stimuli):
            if highlight_idx == i:
                # 修改3：高亮时箭头变为绿色
                stim['arrow'].lineColor = 'green'
            else:
                stim['arrow'].lineColor = 'white'
            
            stim['arrow'].draw()
        self.win.flip()

    def run_p300_trial(self, target_command=None):
       
        self.trial_count += 1
        print(f"开始试次 {self.trial_count}, 目标命令: {target_command}")
        
        # 生成闪烁序列
        flash_sequence = []
        for rep in range(self.repetitions_per_trial):
            trial_order = list(range(len(self.stimuli)))
            random.shuffle(trial_order)
            flash_sequence.extend(trial_order)
        
        # 显示准备信息
        text = visual.TextStim(self.win, text=f"目标: {target_command}\n按空格键开始", color='white')
        text.draw()
        self.win.flip()
        event.waitKeys(keyList=['space'])
        
        self.win.flip()
        core.wait(1.0)
        
        # 执行闪烁序列
        start_time = time.time()
        for flash_count, flash_idx in enumerate(flash_sequence, 1):
            stimulus_name = self.commands[flash_idx]
            is_target = (stimulus_name == target_command)
            
            print(f"闪烁 {flash_count}/{len(flash_sequence)}: {stimulus_name}, 目标: {is_target}")
            
            self.draw_all_stimuli(highlight_idx=flash_idx)
            
            print(f"[标记] 时间: {time.time()-start_time:.3f}s, 刺激: {stimulus_name}, 目标: {is_target}")
            
            core.wait(self.stim_duration)
            
            self.draw_all_stimuli()
            core.wait(self.isi)
            
            if 'escape' in event.getKeys():
                print("用户退出")
                return
        
        print(f"试次 {self.trial_count} 完成，总闪烁次数: {len(flash_sequence)}")
        
        # 结束信息
        text = visual.TextStim(self.win, text=f"试次完成!\n目标: {target_command}\n按任意键继续", color='white')
        text.draw()
        self.win.flip()
        event.waitKeys()

if __name__ == "__main__":
    print("开始P300视觉刺激测试...")
    
    try:
        p300_exp = P300Stimulus()
        
        test_repetitions = [3, 3, 3, 3]
        
        for reps in test_repetitions:
            print(f"\n=== 测试重复次数: {reps} ===")
            p300_exp.repetitions_per_trial = reps  # 动态修改重复次数
            
            # 运行试次
            target = random.choice(p300_exp.commands)
            p300_exp.run_p300_trial(target_command=target)
        
        p300_exp.win.close()
        
    except Exception as e:
        print(f" 程序运行出错: {e}")
        import traceback
        traceback.print_exc()
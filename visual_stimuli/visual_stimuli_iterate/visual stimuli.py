
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
        
        self.commands = ['抬手', '放手', '左转', '右转']  
        self.stimuli = []  
        
        self.create_stimuli()
        
        self.stim_duration = 0.2
        self.isi = 0.3
        self.repetitions_per_trial = 10
        self.trial_count = 0

    def create_stimuli(self):
        positions = [[-200, 150], [200, 150], [-200, -150], [200, -150]]
        
        for i, pos in enumerate(positions):
            rect = visual.Rect(
                self.win,  
                width=180,
                height=120,
                pos=pos,
                lineColor='white',
                fillColor='black',
                lineWidth=3
            )
            
            text = visual.TextStim(
                self.win,  
                text=self.commands[i], 
                pos=pos,
                color='white',
                height=30
            )
            
            self.stimuli.append({'rect': rect, 'text': text}) 

    def draw_all_stimuli(self, highlight_idx=None):
        for i, stim in enumerate(self.stimuli):
            if highlight_idx == i:
                stim['rect'].fillColor = 'white'
                stim['text'].color = 'black'
            else:
                stim['rect'].fillColor = 'black'
                stim['text'].color = 'white'
            
            stim['rect'].draw()
            stim['text'].draw()
        self.win.flip()

    def test_basic_functionality(self):
        print("测试基本功能...")
        
        # 显示准备信息
        text = visual.TextStim(self.win, text="按空格键开始测试", color='white')
        text.draw()
        self.win.flip()
        event.waitKeys(keyList=['space'])
        
        # 显示所有刺激
        self.draw_all_stimuli()
        print("显示所有刺激，按任意键继续...")
        event.waitKeys()
        
        # 测试闪烁
        for i in range(len(self.commands)):
            print(f"测试闪烁: {self.commands[i]}")
            self.draw_all_stimuli(highlight_idx=i)
            core.wait(0.5)
            self.draw_all_stimuli()
            core.wait(0.3)
        
        # 结束
        text.text = "测试完成!\n按任意键退出"
																													
        text.draw()
        self.win.flip()
        event.waitKeys()

if __name__ == "__main__":
    print("创建P300刺激程序...")
    try:
        p300_exp = P300Stimulus()
       
        p300_exp.test_basic_functionality()
        p300_exp.win.close()
       
    except Exception as e:
        print(f" 错误: {e}")
        import traceback
        traceback.print_exc()
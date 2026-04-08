import sys
import os
import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import time

sys.path.insert(0, os.path.expanduser('~/bci_robot_ws/bci_env/lib/python3.10/site-packages'))
import joblib
import numpy as np

class BCIExperimentSimulator(Node):
    def __init__(self):
        super().__init__('bci_experiment_simulator')
        self.publisher_ = self.create_publisher(String, '/bci_command', 10)
        
        # 加载模型
        model_path = os.path.expanduser('~/bci_robot_ws/p300_lda_model.pkl')
        try:
            self.model = joblib.load(model_path)
        except Exception as e:
            return

        self.directions = ['SHOULDER_UP', 'SHOULDER_DOWN', 'ELBOW_UP', 'ELBOW_DOWN']
        self.current_trial = 0
        
        
        self.timer = self.create_timer(8, self.run_single_trial)
        self.get_logger().info('one trail per 8 sec')

    def run_single_trial(self):
        self.current_trial += 1
        self.get_logger().info(f' [Trial {self.current_trial}] start')
        

        dummy_eeg_data = np.random.randn(1, 16, 103)
        prediction = self.model.predict(dummy_eeg_data) 
        
        target_idx = (self.current_trial - 1) % 4
        command_str = self.directions[target_idx]
        
        msg = String()
        msg.data = command_str
        self.publisher_.publish(msg)
        self.get_logger().info(f'publishing command:  "{command_str}"')


def main(args=None):
    rclpy.init(args=args)
    node = BCIExperimentSimulator()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import subprocess

class RobotControllerNode(Node):
    def __init__(self):
        super().__init__('robot_controller_node')
        self.subscription = self.create_subscription(String, '/bci_command', self.command_callback, 10)
        self.get_logger().info('controller node launched')

        # ⚠️ 极其重要：由于 rosrun 是 ROS 1 的命令，需要确保执行前 source 了下位机的工作空间
        # 请把你下位机 robot_cook 所在的 devel/setup.bash 路径填对
        self.ros1_workspace_setup = "source ~/机器人端程序/robot_cook/devel/setup.bash"

    def execute_ros1_command(self, yaml_file):
        cmd = f"bash -c '{self.ros1_workspace_setup} && rosrun cook_cartesian moveit_trajectory_recoder.py --play {yaml_file} --arm left_arm'"
        
        try:
            subprocess.run(cmd, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            self.get_logger().error(f' 终端命令执行失败: {e}')

    def command_callback(self, msg):
        command = msg.data
        
        if command == 'SHOULDER_UP':
            self.execute_ros1_command('catch_position_001.yaml')
            
        elif command == 'SHOULDER_DOWN':
            self.execute_ros1_command('catch_position_002.yaml')  
            
        elif command == 'ELBOW_UP':
            self.execute_ros1_command('catch_position_003.yaml')  
            
        elif command == 'ELBOW_DOWN':
            self.execute_ros1_command('catch_position_004.yaml')  
            
        elif command == 'WAITING' or command == 'STANDBY':
            self.get_logger().info('waiting')
        
        else:
            self.get_logger().warning(f' 收到未知脑电指令: {command}')

def main(args=None):
    rclpy.init(args=args)
    node = RobotControllerNode()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
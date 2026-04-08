# 在 Ubuntu ROS 端接收 Windows 命令并执行动作
import socket
import os

HOST = "0.0.0.0"
PORT = 60000


def run_ros_cmd(cmd):
    ret = os.system(cmd)
    if ret != 0:
        print(f"ROS command failed, code={ret}")


def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((HOST, PORT))
    server.listen(5)

    print(f"Server started on {HOST}:{PORT}")

    while True:
        conn, addr = server.accept()
        print(f"Connected by {addr}")

        try:
            while True:
                data = conn.recv(1024).decode("utf-8").strip()
                if not data:
                    break

                print(f"Received data: {data}")

                if data == "SHOULDER_UP":
                    cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play catch_position_001.yaml --arm left_arm'"
                    run_ros_cmd(cmd)

                elif data == "SHOULDER_DOWN":
                    cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play catch_position_002.yaml --arm left_arm'"
                    run_ros_cmd(cmd)

                elif data == "ELBOW_UP":
                    cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play catch_position_003.yaml --arm left_arm'"
                    run_ros_cmd(cmd)

                elif data == "ELBOW_DOWN":
                    cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play catch_position_004.yaml --arm left_arm'"
                    run_ros_cmd(cmd)

                elif data == "WAITING":
                    print("WAITING (no action)")

                else:
                    print(f"Unknown command: {data}")

        except Exception as e:
            print(f"Connection error: {e}")
        finally:
            conn.close()
            print(f"Connection closed by {addr}")


if __name__ == "__main__":
    start_server()
        
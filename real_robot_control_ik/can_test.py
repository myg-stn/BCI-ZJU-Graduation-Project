# 在 Ubuntu ROS 端接收 Windows 命令并直接发送关节编码
import socket
import os

HOST = "0.0.0.0"
PORT = 60000

BASE_CODE = 262144
DELTA_CODE = 17856  # 由 0.325rad 对应到编码增量

UP_CODE = BASE_CODE + DELTA_CODE      # 280000
DOWN_CODE = BASE_CODE - DELTA_CODE    # 244288

JOINT_COUNT = 10
DEFAULT_VEL = 5000
DEFAULT_ACC = 5000


def build_joint_command(joint_idx, target_code):
  
    pos = [BASE_CODE] * JOINT_COUNT
    vel = [0] * JOINT_COUNT
    acc = [0] * JOINT_COUNT

    pos[joint_idx] = target_code
    vel[joint_idx] = DEFAULT_VEL
    acc[joint_idx] = DEFAULT_ACC

    return (
        "rostopic pub -1 /moveit_publish_commandstate_left "
        "cook_arm_msgs/cook_sender "
        f"'{{joint_position_s: {pos}, joint_velocity_s: {vel}, joint_acceleration_s: {acc}}}'"
    )


JOINT_COMMANDS = {
    # 大臂 = 第2关节 -> 下标1
    "SHOULDER_UP": build_joint_command(joint_idx=1, target_code=UP_CODE),
    "SHOULDER_DOWN": build_joint_command(joint_idx=1, target_code=DOWN_CODE),

    # 小臂 = 第3关节 -> 下标2
    "ELBOW_UP": build_joint_command(joint_idx=2, target_code=UP_CODE),
    "ELBOW_DOWN": build_joint_command(joint_idx=2, target_code=DOWN_CODE),
}


def run_ros_cmd(cmd):
    # 后台执行，避免阻塞 socket 接收循环
    ret = os.system(cmd + " &")
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

                if data in JOINT_COMMANDS:
                    # 用双引号包 bash -c，内部保留 rostopic payload 的单引号
                    full_cmd = (
                        f'/bin/bash -c "source ~/robot_cook/devel/setup.bash && {JOINT_COMMANDS[data]}"'
                    )
                    run_ros_cmd(full_cmd)
                    print(f"--> Triggered direct joint publish for {data}")

                elif data == "WAITING":
                    print("WAITING ")
                else:
                    print(f"Unknown command: {data}")

        except Exception as e:
            print(f"Connection error: {e}")
        finally:
            conn.close()
            print(f"Connection closed by {addr}")


if __name__ == "__main__":
    start_server()
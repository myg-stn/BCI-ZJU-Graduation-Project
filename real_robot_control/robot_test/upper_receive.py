#在ubuntu上位机中，接收windows下发送的trigger，并执行相应的动作
import socket
import os

HOST = '0.0.0.0'
PORT = 60000

def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((HOST, PORT))
    server.listen(1)

    print(f"Server started on {HOST}:{PORT}")

    while True:
        conn, addr = server.accept()
        print(f"Connected by {addr}")

        while True:
            data = conn.recv(1024).decode('utf-8')
            if not data:
                break
            print(f"Received data: {data}")

            if data == "SHOULDER_UP":
                print("SHOULDER_UP")
                cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play ~/moveit_trajectories/ catch_position_001.yaml --arm left_arm'"
                os.system(cmd)
            
            elif data == "SHOULDER_DOWN":
                print("SHOULDER_DOWN")
                cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play ~/moveit_trajectories/ catch_position_002.yaml --arm left_arm'"
                os.system(cmd)
            
            elif data == "ELBOW_UP":
                print("ELBOW_UP")
                cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play ~/moveit_trajectories/ catch_position_003.yaml --arm left_arm'"
                os.system(cmd)
            
            elif data == "ELBOW_DOWN":
                print("ELBOW_DOWN")
                cmd = "/bin/bash -c 'cd ~/robot_cook && source devel/setup.bash && rosrun cook_cartesian moveit_trajectory_recorder.py --play ~/moveit_trajectories/ catch_position_004.yaml --arm left_arm'"
                os.system(cmd)
            
            elif data == "WAITING":
                print("WAITING")

            else:
                print(f"Unknown command: {data}")

        conn.close()
        print(f"Connection closed by {addr}")

if __name__ == '__main__':
    start_server()

        
import os
import socket
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
                #执行大臂向上动作
            elif data == "SHOULDER_DOWN":
                print("SHOULDER_DOWN")
                #执行大臂向下动作
            elif data == "ELBOW_UP":
                print("ELBOW_UP")
                #执行小臂向上动作
            elif data == "ELBOW_DOWN":
                print("ELBOW_DOWN")
                #执行小臂向下动作
            elif data == "WAITING":
                print("WAITING")
                #保持待机
            else:
                print(f"Unknown command: {data}")   

        conn.close()
        print(f"Connection closed by {addr}")

if __name__ == '__main__':
    start_server()

    #上传github
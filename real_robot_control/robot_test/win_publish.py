#在windows中发送trigger，尝试让机械臂执行动作
import socket
import time
UBUNTU_IP = '192.168.123.55' 
PORT = 60000

def send_trigger(trigger_msg):
    print(f"trying to connect to {UBUNTU_IP}:{PORT}")
    try:
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client.settimeout(3)
        client.connect((UBUNTU_IP, PORT))
        
        client.send(trigger_msg.encode('utf-8'))
        print(f"publinshing trigger: {trigger_msg} ")
    except ConnectionRefusedError:
        print(f"connection refused, retrying...")
    except socket.timeout:
        print(f"connection timeout, retrying...")
    except Exception as e:
        print(f"error: {e}")
    finally:
        if client:
            client.close()

#测试执行大臂向上动作,等待8秒后执行复位动作
if __name__ == '__main__':
    send_trigger("SHOULDER_UP")
    print("SHOULDER_UP sent")
    time.sleep(8)

    send_trigger("RESET")

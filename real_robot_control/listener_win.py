#在windows下，发送trigger到listener_upper.py，验证和上位机通信是否成功
import socket
import time
UBUNTU_IP = '10.70.27.214' 
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

if __name__ == '__main__':
    
    send_trigger("SHOULDER_UP")
    time.sleep(1)
    
    send_trigger("SHOULDER_DOWN")
    time.sleep(1)
    
    send_trigger("ELBOW_UP")
    time.sleep(1)
    
    send_trigger("ELBOW_DOWN")
    time.sleep(1)
    
    send_trigger("WAITING")

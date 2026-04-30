clear all; clc; close all;

matlab_node = ros2node('/matlab_bci_controller_node');
bci_sub = ros2subscriber(matlab_node, '/bci_command', 'std_msgs/String');

L(1)=Link([0     53      0        pi/2   ]);
L(2)=Link([0     0      -259       pi    ]);
L(3)=Link([0     0      -246.5     pi    ]);
L(4)=Link([0     98      0        pi/2   ]);
L(5)=Link([0   291.66    0          0    ]);

bci_arm = SerialLink(L,'name','BCI_Arm');
q_zero = [0, 0, 0, 0, 0]; % 统一使用 q_zero 作为零点姿态

figure('Name', 'ros2_ml_simu', 'Position', [100, 100, 800, 600]);
bci_arm.plot(q_zero, 'workspace', [-800 800 -800 800 -800 800]);


while true
    [msg, status, ~] = receive(bci_sub, 10); 
   
    if status 
        raw_data = msg.data; 
        command = strtrim(char(raw_data)); % 清洗字符串
        
        disp(['receiving command: [', command, ']']);
        
        q_target = q_zero; 
        action_triggered = false; 
        
        % 匹配动作
        switch command
            case 'SHOULDER_UP'
                q_target(2) = -pi/6; 
                action_triggered = true;
            case 'SHOULDER_DOWN'
                q_target(2) = pi/6;  
                action_triggered = true;
            case 'ELBOW_UP'
                q_target(3) = pi/6;  
                action_triggered = true;
            case 'ELBOW_DOWN'
                q_target(3) = -pi/6; 
                action_triggered = true;
            case 'WAITING'
                disp('接收到 WAITING，保持待机...');
            otherwise
                disp(['cant recognize: ', command]);
        end
        
        % 执行动作与复位
        if action_triggered
            steps = 30; 
            [q_matrix, ~, ~] = jtraj(q_zero, q_target, steps);
            for i = 1:steps
                bci_arm.plot(q_matrix(i,:));
                pause(0.01); 
            end
            
            pause(1); % 目标位置悬停
            
            disp('>>> 动作完成，复位中...');
            [q_reset, ~, ~] = jtraj(q_target, q_zero, steps);
            for i = 1:steps
                bci_arm.plot(q_reset(i,:));
                pause(0.02);
            end
            disp('trial end') 
        end
        
    else
        % 如果 Ubuntu 没发消息，每 10 秒会打印一句这个
        disp('keep listening');
    end
end
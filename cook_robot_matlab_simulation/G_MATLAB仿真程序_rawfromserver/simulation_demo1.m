clear all; clc; close all;

%DH1 feature

L(1)=Link([0     53      0        pi/2    ]);
L(2)=Link([0      0      -259       pi    ]);
L(3)=Link([0      0      -246.5     pi    ]);
L(4)=Link([0       98      0        pi/2  ]);
L(5)=Link([0       291.66  0        0     ]);
bci_arm = SerialLink(L,'name','BCI_Arm');

figure('Name', 'demo_onlymatlab ', 'Position', [100, 100, 800, 600]);
q_zero = [0, 0, 0, 0, 0]; 
bci_arm.plot(q_zero, 'workspace', [-800 800 -800 800 -800 800]);
title('waiting');
pause(2);

commands = {'SHOULDER_UP', 'SHOULDER_DOWN', 'ELBOW_UP', 'ELBOW_DOWN'};
action_names = {'大臂向上', '大臂向下 ', '小臂向上 ', '小臂向下 '};

for k = 1:length(commands)
    cmd = commands{k};
    disp(['receiving command：', cmd]);
    title('action_names{k}')
    q_target = q_zero; 
    
    
    switch cmd
        case 'SHOULDER_UP'
            q_target(2) = -pi/6; 
        case 'SHOULDER_DOWN'
            q_target(2) = pi/6;  
        case 'ELBOW_UP'
            q_target(3) = pi/6;  
        case 'ELBOW_DOWN'
            q_target(3) = -pi/6; 
    end
    
    
    steps = 50; 
    [q_matrix, ~, ~] = jtraj(q_zero, q_target, steps);
    
    for i = 1:steps
        bci_arm.plot(q_matrix(i,:));
        pause(0.005); 
    end
    
    pause(1); 
    
    [q_reset, ~, ~] = jtraj(q_target, q_zero, steps);
    for i = 1:steps
        bci_arm.plot(q_reset(i,:));
        pause(0.005);
    end
    
    pause(1); 
end

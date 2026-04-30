clc;
clear;
%% 机械臂建模
% 定义各个连杆以及关节类型，默认为转动关节
%          theta   d         a        alpha
L(1)=Link([0     53      0        pi/2        ]);
L(2)=Link([0      0      -259       pi         ]);
L(3)=Link([0      0       -246.5       pi         ]);
L(4)=Link([0       98      0        pi/2       ]);
L(5)=Link([0       291.66      0        0          ]);
% baseL = transl(0,-152,1300)*trotx(45); %基座高度
baseL = transl(-152,0,0)*troty(-45); %基座高度
L= SerialLink(L,'name','fourarmL','base',baseL);
% L.tool=[0,0,250];
L.display();

%% 轨迹规划
% 初始值及目标值
init_ang=[0 0 0 0 0];
targ_ang=[0, -pi/3, -pi/5, pi/6, 0];
step=500;

[q,qd,qdd]=jtraj(init_ang,targ_ang,step); %关节空间规划轨迹，得到机器人末端运动的[位置，速度，加速度]
T0=L.fkine(init_ang); % 正运动学解算
Tf=L.fkine(targ_ang);
subplot(2,2,1); i=1:4; plot(q(:,i)); title("位置"); grid on;
legend('q1','q2','q3','q4','q5') %依次标注角度
subplot(2,2,2); i=1:4; plot(qd(:,i)); title("速度"); grid on;
legend('q1','q2','q3','q4','q5') %依次标注角度
subplot(2,2,3); i=1:4; plot(qdd(:,i)); title("加速度"); grid on;
legend('q1','q2','q3','q4','q5') %依次标注角度

Tc=ctraj(T0,Tf,step); % 笛卡尔空间规划轨迹，得到机器人末端运动的变换矩阵
Tjtraj=transl(Tc);
subplot(2,2,4); plot2(Tjtraj, 'r');
legend('q1','q2','q3','q4','q5') %依次标注角度
% title('p1到p2直线轨迹'); grid on;
% subplot(2,4,[1,2,5,6]);
plot3(Tjtraj(:,1),Tjtraj(:,2),Tjtraj(:,3),"b"); grid on;
hold on;
view(3); % 解决robot.teach()和plot的索引超出报错
% qq=L.ikine(Tc, 'q0',[0 0 0 0 0], 'mask',[1 1 1 1 0 0]); % 逆解算
% L.plot(qq);

%% compiled by Ezekiel according to robot modeling and control
%% date:20210228

%% 逆动力学
clc
clear all
close all
deg = pi/180;
%%
%     L(1) = Revolute('d', 0, ...   % link length (Dennavit-Hartenberg notation)
%     'a', 0, ...               % link offset (Dennavit-Hartenberg notation)
%     'alpha', pi/2, ...        % link twist (Dennavit-Hartenberg notation)
%     'I', [0, 0.35, 0, 0, 0, 0], ... % inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
%     'r', [0, 0, 0], ...       % distance of ith origin to center of mass [x,y,z] in link reference frame
%     'm', 0, ...               % mass of link
%     'Jm', 200e-6, ...         % actuator inertia 
%     'G', -62.6111, ...        % gear ratio
%     'B', 1.48e-3, ...         % actuator viscous friction coefficient (measured at the motor)
%     'Tc', [0.395 -0.435], ... % actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
%     'qlim', [-160 160]*deg ); % minimum and maximum joint angle
L1= Revolute('d', 9.4, 'a', 0, 'alpha', pi/2, ...
    'I', [52.331 0         0.607;
          0	     45.806	   0;
          0.607  0         52.446;], ...
    'r', [-3.952 -21.663 0.000], ...
    'm', 2.428, ...
    'Jm', 2.2e-4, ...
    'G', 81, ...
    'B', 1.48e-3, ...
    'Tc', [0.395 -0.435], ...
    'qlim', [-180 180]*deg );
L2 = Revolute('d', 0, 'a', 11, 'alpha', 0, ...
    'I', [14.418 -0.604 0.054;
          -0.604 6.211 -0.550;
          0.054 -0.550 14.429;], ...
    'r', [-4.354 -9.493 -0.365]-[0 0 9.4], ...
    'm', 0.699, ...
    'Jm', 2.2e-4, ...
    'G', 121, ...
    'B', .817e-3, ...
    'Tc', [0.126 -0.071], ...
    'qlim', [-105 105]*deg );
 
L3 = Revolute('d', 0, 'a', 10, 'alpha', 0,  ...
    'I', [12.840	0.729	-0.387;
          0.729	    7.184   0.664;
          -0.387	0.664	12.76;], ...
    'r', [	-4.171 0.917 -0.199]-[11 0 9.4], ...
    'm',  0.691, ...
    'Jm', 2.2e-4, ...
    'G', 81, ...
    'B', 71.2e-6, ...
    'Tc', [11.2e-3, -16.9e-3], ...
    'qlim', [-110 110]*deg);

L4 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,  ...
    'I', [17.932   4.696  5.671;
           4.696  18.501  4.274;
           5.671   4.274 19.002;], ...
    'r', [	0.705 9.603 4.238]-[21 0 9.4], ...
    'm', 1.711, ...
    'Jm', 2.2e-4, ...
    'G', 81, ...
    'B', 82.6e-6, ...
    'Tc', [9.26e-3, -14.5e-3], ...
    'qlim', [-115 115]*deg );
L5 = Revolute('d', 23, 'a', 0, 'alpha', 0, ...
    'I', [38.375 -0.211 10.396;
          -0.211 23.637 -5.014;
          10.396 -5.014 35.718;], ...
    'r', [9.835 17.578 12.551]-[21 0 9.4-23], ...
    'm', 1.402, ...
    'Jm', 2.2e-4, ...
    'G', 51, ...
    'B', 36.7e-6, ...
    'Tc', [3.96e-3, -10.5e-3], ...
    'qlim', [-180 180]*deg );
robot=SerialLink([L1,L2,L3,L4,L5],'name','Ez','comment','LL');  %SerialLink类函数
robot.display();    %Link类函数，显示建立机器人DH参数
%通过手动输入各个连杆转角，模型会自动运动到相应位置
theta1=[0 0  0 0 0];    %机器人伸直且垂直位姿
robot.plot(theta1);  %SerialLink类函数,显示机器人图像
theta2=[0,pi/6,0,pi/2 - pi/6,0];
% % teach(robot)
robot.plot(theta2);
 %% 逆运动学分析
Q = robot.fkine(theta2);
robot.ikine(Q, 'deg','mask',[1 1 1 1 1 0])%运动学逆解
%% 可操作的正方形区域
hold on
x1 = [0 1 1 0 0 0 0 0 1 1 1 1 1 0 0 1].*50 - 25 ;
y1 = [0 0 0 0 0 1 1 0 0 1 1 0 1 1 1 1].*50 - 25;
z1 = [0 0 1 1 0 0 1 1 1 1 0 0 0 0 1 1].*50 - 15 ;
%    1 2 6 5   4 8     7 3        顶点坐标
%    1 2 3 4 5 6 7 8 9 10 11
plot3(x1,y1,z1,'k');
hold on 
% 可达分析 50*50*50
% Point = [1 2 11 6 4 3 10 7];
% for j = 1:1:8
% Tg =  Point(j);
% T3 = transl(x1(Tg),y1(Tg),z1(Tg));	%顶点1起点
% T4 = transl(x1(Tg),y1(Tg),z1(Tg));	%顶点2终点，两点相隔0.5
% T_1 = ctraj(T3,T4,10);% 0.5/2=0.25m/s
% T_j = transl(T_1);
% q_1 = robot.ikine(T_1,'mask',[1 1 1 0 0 0]);
% %view(45,45);
% robot.plot(q_1,'tilesize',200);
% q_s = diff(q_1);
% pause(0.5)
% end
%% 动力学分析  
%% 分析1 ：速度为0.25m/s时候的分析
Point = [1 2 11 6 4 3 10 7];
Tg =  Point(1);
T3 = transl(x1(Tg),y1(Tg),z1(Tg));	%顶点1起点
T4 = transl(x1(Tg)+10,y1(Tg),z1(Tg)+10);	%顶点2终点，两点相隔0.5
T_1 = ctraj(T3,T4,40);% 1cm/0.04s=0.01/0.04=0.25m/s
T_j = transl(T_1);
q_1 = robot.ikine(T_1,'mask',[1 1 1 0 0 0]);
 view(30,30);
robot.plot(q_1);
q_s = diff(q_1);
speed = (q_s(25,:) - q_s(15,:))./(10*0.001)
i=1:5;
% figure(2)
% qplot(q_s(:,i));grid on;title('速度');%绘制每个关节速度
%% 分析2 ：0.1s速度增加至为0.025m/s
Point = [1 2 11 6 4 3 10 7];
Tg =  Point(6);
T1 = transl(x1(Tg), y1(Tg), z1(Tg));	%顶点1起点
T2 = transl(x1(Tg)-2.5,y1(Tg),z1(Tg));	%顶点2终点%位移0.1s内位移0.025m，所以加速度达到0.25m/s^2
T = ctraj(T1,T2,100);
Tj = transl(T);
q_2 = robot.ikine(T,'mask',[1 1 1 0 0 0]);
%view(45,45);
%robot.plot(q,'tilesize',200);
Set = q_2(1,:)
Set2 = q_2(length(T),:)
%robot.plot(Set); pause(2);robot.plot(Set2); pause(2);
t=[0:0.001:0.1];% 时间限制0- 0.1s
g=jtraj(Set,Set2,t);%相当于具有tpoly插值的mtraj，但是对多轴情况进行了优化，还允许使用额外参数设置初始和最终速度
[q,qd,qdd]=jtraj(Set,Set2,t);%通过可选的输出参数，获得随时间变化的关节速度加速度向量--五次样条规划
% %robot.plot(g)%绘制动画
qdd1 = qdd(:,1);
qdd2 = qdd(:,2);
qdd3 = qdd(:,3);
qdd4 = qdd(:,4);
qdd5 = qdd(:,5);
Max_a1 = find(qdd1==max(qdd1))
Max_a2 = find(qdd2==max(qdd2))
Max_a3 = find(qdd3==max(qdd3))
Max_a4 = find(qdd4==max(qdd4))
Max_a5 = find(qdd5==max(qdd5));
Ac1 = (qdd1(Max_a1(1))-0)/2
Ac2 = (qdd2(Max_a2(1))-0)/2
Ac3 = (qdd3(Max_a3(1))-0)/2
Ac4 = (qdd4(Max_a4(1))-0)/2
Ac_output = [Ac1 Ac2 Ac3 Ac4 0]
figure(3)
i=1:5;
subplot(2,2,1);
plot(q(:,i));grid on;title('位置');%绘制每个关节位置
subplot(2,2,2);
plot(qd(:,i));grid on;title('速度');%绘制每个关节速度
subplot(2,2,3);
plot(qdd(:,i));grid on;title('加速度');%绘制每个关节加速度
Q = robot.rne(q,qd,qdd);%获得每个时间点所需要的关节力矩
qdd1 = [];
qdd2 = [];
qdd3 = [];
qdd4 = [];
qdd5 = [];
qdd1 = Q(:,1);
qdd2 = Q(:,2);
qdd3 = Q(:,3);
qdd4 = Q(:,4);
qdd5 = Q(:,5);
Max_j1 = find(qdd1==max(qdd1))
Max_j2 = find(qdd2==max(qdd2))
Max_j3 = find(qdd3==max(qdd3))
Max_j4 = find(qdd4==max(qdd4))
Max_j5 = find(qdd5==max(qdd5));
j1 = (qdd1(Max_j1)-0)/2;
j2 = (qdd2(Max_j2)-0)/2;
j3 = (qdd3(Max_j3)-0)/2;
j4 = (qdd4(Max_j4)-0)/2;
j5 = (qdd5(Max_j5)-0)/2;
J_output = [j1 j2 j3 j4 j5]
% subplot(2,2,4)
% qplot(t,Q);grid on;title('力矩')

%% 分析三 静扭矩
t=[0:0.1:2];
[q,qd,qdd]=jtraj(Set2,Set2,t);
figure(4)
Q2 = robot.rne(q,qd,qdd);%获得每个时间点所需要的关节力矩
plot(t,Q2);grid on;title('力矩')
%% 分析四 抓取物体后扭矩
% 更新关节5参数
L5 = Revolute('d', 23, 'a', 0, 'alpha', 0, ...
    'I', [75.280 11.348 21.852;
          11.348 65.518 4.001;
          21.852 4.001 78.123;], ...%惯量改变
    'r', [12.236 19.494 14.421], ...%质心改变
    'm', 3.778 , ...%重量增加
    'Jm', 2.2e-4, ...
    'G', 51, ...
    'B', 36.7e-6, ...
    'Tc', [3.96e-3, -10.5e-3], ...
    'qlim', [-180 180]*deg );
robot=SerialLink([L1,L2,L3,L4,L5],'name','Ez','comment','LL');  %SerialLink类函数
robot.display();    %Link类函数，显示建立机器人DH参数
%通过手动输入各个连杆转角，模型会自动运动到相应位置
theta1=[0 0  0 pi/2 0];    %机器人伸直且垂直位姿
t=[0:0.01:2];
[q,qd,qdd]=jtraj(Set2,Set2,t);
figure(5)
Q3 = robot.rne(q,qd,qdd);%获得每个时间点所需要的关节力矩
plot(t,Q3);grid on;title('力矩')



% syms   theta1   d1    a1     alpha1;
% syms   theta1   d2    a2     alpha2;
% syms   theta1   d3    a3     alpha3;
% syms   theta1  d4    a4     alpha4;
% syms   theta1   d5    a5     alpha5;
% syms   r11   r12      r13      px    r21   r22      r23      py    r31   r32      r33      pz;
% syms   nx   ny  nz  ox oy oz ax ay az    ;
%连杆偏移

syms theta1 theta2 theta3 theta4 theta5  d1 d4 d5 a2 a3 real

% d1 = 53;
d2 = 0;
d3 = 0;
% d4 = 98;
% d5 = 291.66;
% 连杆长度
a1 =  0;
% a2 = -259 ;
% a3 = -246.5;
a4 =  0;
a5 =  0;

%连杆扭角
alpha1 = pi/2;
alpha2 = pi;
alpha3 = pi;
alpha4 = pi/2;
alpha5 = 0;
%由于我们需要分析各轴θi所对应的机器人末端位置
%因此theta1 theta2 theta3 theta4 theta5 theta6仍设为未知量



L(1)=Link([0    d1       a1       alpha1]);
L(2)=Link([0    d2       a2       alpha2]);
L(3)=Link([0    d3       a3       alpha3]);
L(4)=Link([0    d4       a4       alpha4]);
L(5)=Link([0    d5       a5       alpha5]);
p560L= SerialLink(L,'name','fourarm');
% view(3)
% hold on
% grid on
% axis([-1200, 1200, -1200, 1200, -1200, 1200])
syms th1 th2 th3 th4 th5 real
% hold on
qn = [th1 th2 th3 th4 th5];
J=p560L.jacobn(qn);


j=char(vpa(J));
disp(simplify(J));
disp(j);





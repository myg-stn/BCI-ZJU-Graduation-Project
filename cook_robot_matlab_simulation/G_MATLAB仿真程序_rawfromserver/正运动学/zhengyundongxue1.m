
% syms   theta1   d1    a1     alpha1;
% syms   theta1   d2    a2     alpha2;
% syms   theta1   d3    a3     alpha3;
% syms   theta1  d4    a4     alpha4;
% syms   theta1   d5    a5     alpha5;
% syms   r11   r12      r13      px    r21   r22      r23      py    r31   r32      r33      pz;
% syms   nx   ny  nz  ox oy oz ax ay az    ;
%连杆偏移
d1 = 53;
d2 = 0;
d3 = 0;
d4 = 98;
d5 = 291.66;
% 连杆长度
a1 =  0;
a2 = -259 ;
a3 = -246.5;
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
% syms theta1 theta2 theta3 theta4 theta5 d1 d4 d5 a2 a3 real
theta1 = pi/6;
theta2 = -pi/5;
theta3 = pi/4;
theta4 = -pi/3;
theta5 = pi/2;


% for i = 1:1:8
% theta1 = EE(i,1);
% theta2 = EE(i,2);
% theta3 = EE(i,3);
% theta4 = EE(i,4);
% theta5 = EE(i,5);






% 参数矩阵取名为MDH
SDH = [theta1    d1       a1       alpha1;
       theta2    d2       a2       alpha2;    
       theta3    d3       a3       alpha3;
       theta4    d4       a4       alpha4;
       theta5    d5       a5       alpha5;];


 T01=[cos(SDH(1,1))  -sin(SDH(1,1))*cos(SDH(1,4))   sin(SDH(1,1))*sin(SDH(1,4))    SDH(1,3)*cos(SDH(1,1));
      sin(SDH(1,1))   cos(SDH(1,1))*cos(SDH(1,4))  -cos(SDH(1,1))*sin(SDH(1,4))    SDH(1,3)*sin(SDH(1,1));
      0               sin(SDH(1,4))                 cos(SDH(1,4))                  SDH(1,2);
      0               0                             0                              1];
 T12=[cos(SDH(2,1))  -sin(SDH(2,1))*cos(SDH(2,4))   sin(SDH(2,1))*sin(SDH(2,4))    SDH(2,3)*cos(SDH(2,1));
      sin(SDH(2,1))   cos(SDH(2,1))*cos(SDH(2,4))  -cos(SDH(2,1))*sin(SDH(2,4))    SDH(2,3)*sin(SDH(2,1));
      0               sin(SDH(2,4))                 cos(SDH(2,4))                  SDH(2,2);
      0               0                             0                              1];
 T23=[cos(SDH(3,1))  -sin(SDH(3,1))*cos(SDH(3,4))   sin(SDH(3,1))*sin(SDH(3,4))    SDH(3,3)*cos(SDH(3,1));
      sin(SDH(3,1))   cos(SDH(3,1))*cos(SDH(3,4))  -cos(SDH(3,1))*sin(SDH(3,4))    SDH(3,3)*sin(SDH(3,1));
      0               sin(SDH(3,4))                 cos(SDH(3,4))                  SDH(3,2);
      0               0                             0                              1];
 T34=[cos(SDH(4,1))  -sin(SDH(4,1))*cos(SDH(4,4))   sin(SDH(4,1))*sin(SDH(4,4))    SDH(4,3)*cos(SDH(4,1));
      sin(SDH(4,1))   cos(SDH(4,1))*cos(SDH(4,4))  -cos(SDH(4,1))*sin(SDH(4,4))    SDH(4,3)*sin(SDH(4,1));
      0               sin(SDH(4,4))                 cos(SDH(4,4))                  SDH(4,2);
      0               0                             0                              1];
 T45=[cos(SDH(5,1))  -sin(SDH(5,1))*cos(SDH(5,4))   sin(SDH(5,1))*sin(SDH(5,4))    SDH(5,3)*cos(SDH(5,1));
      sin(SDH(5,1))   cos(SDH(5,1))*cos(SDH(5,4))  -cos(SDH(5,1))*sin(SDH(5,4))    SDH(5,3)*sin(SDH(5,1));
      0               sin(SDH(5,4))                 cos(SDH(5,4))                  SDH(5,2);
      0               0                             0                              1];

% % 总变换代码
T05 = T01* T12*T23*T34 *T45;
T15 = T12*T23*T34 *T45;
T25 = T23*T34 *T45;
T35 = T34 *T45;

% T05 = [nx   ox      ax      px;
%        ny   oy      ay      py;    
%        nz   oz      az      pz;
%        0     0      0       1;];
format long
disp(round(vpa(T05),3));

% disp(T12*T23*T34*T45);
% disp((T01^-1)*T05 );
% disp(inv(T01)*T05);


L(1)=Link([0     53      0        pi/2        ]);
L(2)=Link([0      0      -259       pi         ]);
L(3)=Link([0      0       -246.5       pi         ]);
L(4)=Link([0       98      0        pi/2       ]);
L(5)=Link([0       291.66      0        0          ]);
L= SerialLink(L,'name','fourarmL');

%求正运动学公式
T0_5 = L.fkine([theta1 theta2 theta3 theta4 theta5 ]);

disp(T0_5)
L.display
% end
% L(1)=Link([0       104      0        pi/2         ]);
% L(2)=Link([0       0        300       0              ]);
% L(3)=Link([0       0       250       0          ]);
% L(4)=Link([0       100      0         pi/2           ]);
% L(5)=Link([0       250      0         0           ]);
% L= SerialLink(L,'name','fourarmL');
% 
% %求正运动学公式
% T0_5 = L.fkine([pi/3 pi/4 pi/5 pi/4 0 ]);
% 
% disp(T0_5)
% L.display

syms   theta1   d1    a1     alpha1;
syms   theta2   d2    a2     alpha2;
syms   theta3   d3    a3     alpha3;
syms   theta4   d4    a4     alpha4;
syms   theta5   d5    a5     alpha5;
% syms   r11   r12      r13      px    r21   r22      r23      py    r31   r32      r33      pz;
syms   nx   ny  nz  ox oy oz ax ay az   px py pz ;
%连杆偏移
d1 = 104;
d2 = 0;
d3 = 0;
d4 = 100;
d5 =250;
%连杆长度
a1 = 0;
a2 = 300;
a3 = 250;
a4 = 0;
a5 = 0;

%连杆扭角
alpha1 = pi/2;
alpha2 = 0;
alpha3 = 0;
alpha4 = pi/2;
alpha5 = 0;
%由于我们需要分析各轴θi所对应的机器人末端位置
%因此theta1 theta2 theta3 theta4 theta5 theta6仍设为未知量
syms theta1 theta2 theta3 theta4 theta5 
% 
theta1 = 1;
theta2 = 1;
theta3 = 1;
theta4 = 1;
theta5 = pi/4;
% syms   x1 x2  x3 x4 x5 ;
% theta1 = x1;
% theta2 = x2;
% theta3 = x3;
% theta4 = x4;
% theta5 = x5;


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

% 总变换代码
T05 = T01*T12*T23*T34*T45;
disp(T05);
% T05 = [nx   ox      ax      px;
%        ny   oy      ay      py;    
%        nz   oz      az      pz;
%        0     0      0       1;];
nx = T05(1,1);ox = T05(1,2);ax = T05(1,3);px = T05(1,4);
ny = T05(2,1);oy = T05(2,2);ay = T05(2,3);py = T05(2,4);
nz = T05(3,1);oz = T05(3,2);az = T05(3,3);pz = T05(3,4);



% disp(T05);
% disp(T12*T23*T34);
disp((T01^-1)*T05)


% theta1 两个解
Etheta1_1 = atan2(py, px) + atan2(100,  sqrt(px^2 + py^2-100^2));
Etheta1_2 = atan2(py, px) + atan2(100, -sqrt(px^2 + py^2-100^2));
s1 = sin(Etheta1_1);
c1 = cos(Etheta1_1);

s1_1 = sin(Etheta1_2);
c1_1 = cos(Etheta1_2);

% theta5 一个解
Etheta5   = atan2(s1 * nx-c1*ny, s1*ox-c1*oy);
Etheta5_2 = atan2(s1_1*nx-c1_1*ny, s1_1*ox-c1_1*oy);


% % theta2 theta3 theta4 一个解
Etheta234 = atan2(ax*c1+ay*s1,-az);
Etheta2340 = atan2(nz/cos(Etheta5),(nx*c1+ny*s1)/cos(Etheta5));
Etheta23400 = atan2(-oz/sin(Etheta5),-(ox*c1+oy*s1)/sin(Etheta5));

Etheta234_1 = atan2(ax*c1_1+ay*s1_1,-az);
Etheta234_10 = atan2(nz/cos(Etheta5_2),(nx*c1_1+ny*s1_1)/cos(Etheta5_2));
Etheta234_100 = atan2(-oz/sin(Etheta5_2),-(ox*c1_1+oy*s1_1)/sin(Etheta5_2));

% theta3 两个解
c3 = ((px*c1+py*s1-250*sin(Etheta234))^2+(pz-104+250*cos(Etheta234))^2-(300^2+250^2))/(2*300*250);
s3 = sqrt(1-(c3)^2);

c3_1 = ((px*c1_1+py*s1_1-250*sin(Etheta234_1))^2+(pz-104+250*cos(Etheta234_1))^2-(300^2+250^2))/(2*300*250);
s3_1 = sqrt(1-(c3_1)^2);

Etheta3_1 = atan2(s3,c3);
Etheta3_2 = atan2(-s3,c3);

Etheta3_1_1 = atan2(s3_1,c3_1);
Etheta3_2_1 = atan2(-s3_1,c3_1);

% theta4 两个解
sin_4x = (((px*c1+py*s1)^2+(pz-104)^2-(300^2+250^2+250^2))/(2*250) - 300*cos(Etheta3_1))/sqrt((300*sin(Etheta3_1))^2+(300*cos(Etheta3_1)+250)^2);
cos_4x = sqrt(1-(sin_4x)^2);


Etheta4_1 = atan2(sin_4x,cos_4x) - atan2(300*sin(Etheta3_1),300*cos(Etheta3_1)+250);
Etheta4_2 = atan2(sin_4x,-cos_4x) - atan2(300*sin(Etheta3_1),300*cos(Etheta3_1)+250) ;

sin_4x1 = (((px*c1+py*s1)^2+(pz-104)^2-(300^2+250^2+250^2))/(2*250) - 300*cos(Etheta3_2))/sqrt((300*sin(Etheta3_2))^2+(300*cos(Etheta3_2)+250)^2);
cos_4x1 = sqrt(1-(sin_4x1)^2);


Etheta4_1_1 = atan2(sin_4x1,cos_4x1) - atan2(300*sin(Etheta3_2),300*cos(Etheta3_2)+250);
Etheta4_2_1 = atan2(sin_4x1,-cos_4x1) - atan2(300*sin(Etheta3_2),300*cos(Etheta3_2)+250) ;



sin_4xb = (((px*c1_1+py*s1_1)^2+(pz-104)^2-(300^2+250^2+250^2))/(2*250) - 300*cos(Etheta3_1_1))/sqrt((300*sin(Etheta3_1_1))^2+(300*cos(Etheta3_1_1)+250)^2);
cos_4xb = sqrt(1-(sin_4xb)^2);
Etheta4_1b = atan2(sin_4xb,cos_4xb) - atan2(300*sin(Etheta3_1_1),300*cos(Etheta3_1_1)+250);
Etheta4_2b = atan2(sin_4xb,-cos_4xb) - atan2(300*sin(Etheta3_1_1),300*cos(Etheta3_1_1)+250) ;

sin_4xb1 = (((px*c1_1+py*s1_1)^2+(pz-104)^2-(300^2+250^2+250^2))/(2*250) - 300*cos(Etheta3_2_1))/sqrt((300*sin(Etheta3_2_1))^2+(300*cos(Etheta3_2_1)+250)^2);
cos_4xb1 = sqrt(1-(sin_4xb1)^2);
Etheta4_1b_1 = atan2(sin_4xb1, cos_4xb1) - atan2(300*sin(Etheta3_2_1),300*cos(Etheta3_2_1)+250);
Etheta4_2b_1 = atan2(sin_4xb1,-cos_4xb1) - atan2(300*sin(Etheta3_2_1),300*cos(Etheta3_2_1)+250) ;

% theta2
Etheta2  = Etheta234 - Etheta3_1 - Etheta4_1 ;
Etheta21 = Etheta234 - Etheta3_1 - Etheta4_2 ;
Etheta22 = Etheta234 - Etheta3_2 - Etheta4_1_1 ;
Etheta23 = Etheta234 - Etheta3_2 - Etheta4_2_1 ;
Etheta24 = Etheta234_1 - Etheta3_1_1 - Etheta4_1b ;
Etheta25 = Etheta234_1 - Etheta3_1_1 - Etheta4_2b ;
Etheta26 = Etheta234_1 - Etheta3_2_1 - Etheta4_1b_1 ;
Etheta27 = Etheta234_1 - Etheta3_2_1 - Etheta4_2b_1 ;

 EE =  [Etheta1_1    Etheta2       Etheta3_1       Etheta4_1        Etheta5;
       Etheta1_1    Etheta21       Etheta3_1       Etheta4_2       Etheta5;
       Etheta1_1    Etheta22       Etheta3_2       Etheta4_1_1       Etheta5;
       Etheta1_1    Etheta23       Etheta3_2       Etheta4_2_1       Etheta5;
       Etheta1_2    Etheta24      Etheta3_1_1       Etheta4_1b      Etheta5_2;
       Etheta1_2    Etheta25      Etheta3_1_1       Etheta4_2b      Etheta5_2;
       Etheta1_2    Etheta26      Etheta3_2_1       Etheta4_1b_1      Etheta5_2;
       Etheta1_2    Etheta27      Etheta3_2_1       Etheta4_2b_1      Etheta5_2;];

       
disp(EE)

% for i = 1:1:8
% theta1 = EE(i,1);
% theta2 = EE(i,2);
% theta3 = EE(i,3);
% theta4 = EE(i,4);
% theta5 = EE(i,5);
% 
% L(1)=Link([theta1      104      0        pi/2         ]);
% L(2)=Link([theta2       0        300       0              ]);
% L(3)=Link([theta3      0       250       0          ]);
% L(4)=Link([theta4       100      0         pi/2           ]);
% L(5)=Link([theta5       250      0         0           ]);
% L= SerialLink(L,'name','fourarmL');
% %求正运动学公式
% T0_5 = L.fkine([theta1 theta2 theta3 theta4 theta5 ]);
% 
% disp(T0_5)
% 
% % L.display
% end
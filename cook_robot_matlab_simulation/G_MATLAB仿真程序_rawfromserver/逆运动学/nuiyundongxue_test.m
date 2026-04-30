% L(1)=Link([0       104      0        pi/2         ]);
% L(2)=Link([0       0        -300       0              ]);
% L(3)=Link([0       0       -250       0          ]);
% L(4)=Link([0       100      0         pi/2           ]);
% L(5)=Link([0       250      0         0           ]);
% 
% L= SerialLink(L,'name','fourarmL');

% %求正运动学公式
% T0_5 = L.fkine([pi/3 pi/4 pi/5 pi/4 0 ]);
% 
% disp(T0_5)
% L.display
clear;
clc;
syms   theta1   d1    a1     alpha1;
syms   theta2   d2    a2     alpha2;
syms   theta3   d3    a3     alpha3;
syms   theta4   d4    a4     alpha4;
syms   theta5   d5    a5     alpha5;
% syms   r11   r12      r13      px    r21   r22      r23      py    r31   r32      r33      pz;
syms   nx   ny  nz  ox oy oz ax ay az   px py pz ;
%连杆偏移
d1 = 53;
d2 = 0;
d3 = 0;
d4 = 98;
d5 = 291.66;
%连杆长度
a1 = 0;
a2 = -259;
a3 =  -246.5;
a4 = 0;
a5 = 0;

%连杆扭角
alpha1 = pi/2;
alpha2 = pi;
alpha3 = pi;
alpha4 = pi/2;
alpha5 = 0;
%由于我们需要分析各轴θi所对应的机器人末端位置
%因此theta1 theta2 theta3 theta4 theta5 theta6仍设为未知量
syms theta1 theta2 theta3 theta4 theta5 
% 
theta1 = pi/2;
theta2 = pi/2;
theta3 = pi/2;
theta4 = pi/2;
theta5 = pi/2;
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


% AA = L.ikine(T05,'mask', [1 1 1 1 1 0]);
% disp(AA)
% T05 = [nx   ox      ax      px;
%        ny   oy      ay      py;    
%        nz   oz      az      pz;
%        0     0      0       1;];
nx = T05(1,1);ox = T05(1,2);ax = T05(1,3);px = T05(1,4);
ny = T05(2,1);oy = T05(2,2);ay = T05(2,3);py = T05(2,4);
nz = T05(3,1);oz = T05(3,2);az = T05(3,3);pz = T05(3,4);



% disp(T05);
% disp(T12*T23*T34);
% disp((T01^-1)*T05*(T45^-1) )


% theta1 两个解
Etheta11 = atan2(py, px) + atan2(d4,  sqrt(px^2 + py^2-d4^2));
Etheta12 = atan2(py, px) + atan2(d4, -sqrt(px^2 + py^2-d4^2));
% theta1 第一个解
s11 = sin(Etheta11);
c11 = cos(Etheta11);
% theta1 第二个解
s12 = sin(Etheta12);
c12 = cos(Etheta12);




% theta5 一个解
Etheta51   = atan2(s11 * nx-c11*ny, s11*ox-c11*oy);
Etheta52 = atan2(s12*nx-c12*ny, s12*ox-c12*oy);


% theta2 theta3 theta4 一个解
Etheta2341 = atan2(ax*c11+ay*s11,-az);
% Etheta234_0 = atan2(-oz/sin(Etheta5),-(ox*c1+oy*s1)/sin(Etheta5));

Etheta2342 = atan2(ax*c12+ay*s12,-az);
% Etheta234_100 = atan2(-oz/sin(Etheta5_2),-(ox*c1_1+oy*s1_1)/sin(Etheta5_2));

% theta3 两个解
c31 = ((px*c11+py*s11-d5*sin(Etheta2341))^2+(pz-d1+d5*cos(Etheta2341))^2-(a2^2+a3^2))/(2*a2*a3);
s31 = sqrt(1-(c31)^2);

c32 = ((px*c12+py*s12-d5*sin(Etheta2342))^2+(pz-d1+d5*cos(Etheta2342))^2-(a2^2+a3^2))/(2*a2*a3);
s32 = sqrt(1-(c32)^2);

Etheta31 = atan2(s31,c31);
Etheta311 = atan2(-s31,c31);

Etheta32 = atan2(s32,c32);
Etheta322 = atan2(-s32,c32);

% theta2

m1 = a2+a3*cos(Etheta31);
n1 = a3*sin(Etheta31);
s211 = (pz-az*d5-d1)/ sqrt(m1^2+n1^2);
c211 = sqrt(1-(s211)^2);
Etheta211a = atan2(s211,c211)+ atan2(n1,m1);
Etheta211b = atan2(s211,-c211)+ atan2(n1,m1);


m2 = a2+a3*cos(Etheta311);
n2 = a3*sin(Etheta311);
s212 = (pz-az*d5-d1)/ sqrt(m2^2+n2^2);
c212 = sqrt(1-(s212)^2);
Etheta212a = atan2(s212,c212)+ atan2(n2,m2);
Etheta212b = atan2(s212,-c212)+ atan2(n2,m2);


m3 = a2+a3*cos(Etheta32);
n3= a3*sin(Etheta32);
s221 = (pz-az*d5-d1)/ sqrt(m3^2+n3^2);
c221 = sqrt(1-(s221)^2);
Etheta221a = atan2(s221,c221)+ atan2(n3,m3);
Etheta221b = atan2(s221,-c221)+ atan2(n3,m3);


m4 = a2+a3*cos(Etheta322);
n4 = a3*sin(Etheta322);
s222 = (pz-az*d5-d1)/ sqrt(m4^2+n4^2);
c222 = sqrt(1-(s222)^2);
Etheta222a = atan2(s222,c222)+ atan2(n4,m4);
Etheta222b = atan2(s222,-c222)+ atan2(n4,m4);









Etheta40  = Etheta2341 - Etheta31 - Etheta211a ;
Etheta41 = Etheta2341 - Etheta31 - Etheta211b ;

Etheta42 = Etheta2341 - Etheta311 - Etheta212a ;
Etheta43 = Etheta2341 - Etheta311 - Etheta212b ;

Etheta44 = Etheta2342 - Etheta32 - Etheta221a ;
Etheta45 = Etheta2342 - Etheta32 - Etheta221b ;
Etheta46 = Etheta2342 - Etheta322 - Etheta222a ;
Etheta47 = Etheta2342 - Etheta322 - Etheta222b ;

 EE = [Etheta11    Etheta211a       Etheta31        Etheta40      Etheta51;
       Etheta11     Etheta211b       Etheta31       Etheta41      Etheta51;

       Etheta11     Etheta221a       Etheta311      Etheta42      Etheta51;
       Etheta11     Etheta221b       Etheta311      Etheta43     Etheta51;


       Etheta12     Etheta221a       Etheta32       Etheta44      Etheta52;
       Etheta12     Etheta221b       Etheta32       Etheta45      Etheta52;

       Etheta12     Etheta222a       Etheta322      Etheta46     Etheta52;
       Etheta12     Etheta222b       Etheta322      Etheta47     Etheta52;];

       
disp(EE)

% for i = 1:1:8
% theta1 = EE(i,1);
% theta2 = EE(i,2);
% theta3 = EE(i,3);
% theta4 = EE(i,4);
% theta5 = EE(i,5);
% 
% L(1)=Link([0     53      0        pi/2        ]);
% L(2)=Link([0      0      -259       pi         ]);
% L(3)=Link([0      0       -246.5       pi         ]);
% L(4)=Link([0       98      0        pi/2       ]);
% L(5)=Link([0       291.66      0        0          ]);
% L= SerialLink(L,'name','fourarmL');
% 求正运动学公式
% T0_5 = L.fkine([theta1 theta2 theta3 theta4 theta5 ]);
% 
% disp(T0_5)
% L.display
% end
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


clc;
clear;

% syms   theta1   d1    a1     alpha1;
% syms   theta2   d2    a2     alpha2;
% syms   theta3   d3    a3     alpha3;
% syms   theta4   d4    a4     alpha4;
% syms   theta5   d5    a5     alpha5;
% % syms   r11   r12      r13      px    r21   r22      r23      py    r31   r32      r33      pz;
% syms   nx   ny  nz  ox oy oz ax ay az   px py pz ;
%连杆偏移
d1 = 53;
d2 = 0;
d3 = 0;
d4 = 98;
d5 = 291.66;
%连杆长度
a1 = 0;
a2 = -259;
a3 = -246.5;
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
theta1 = pi/3;
theta2 = -2*pi/3;
theta3 = -2*pi/3;
theta4 = pi/6;
theta5 = pi/4;
% syms   x1 x2  x3 x4 x5 ;
% theta1 = x1;
% theta2 = x2;
% theta3 = x3;
% theta4 = x4;
% theta5 = x5;


% 参数矩阵取名为MDH
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
% Etheta2341= atan2(ax*c11+ay*s11,-az);
% Etheta2342 = atan2(ax*c12+ay*s12,-az);

Etheta2341 = atan2(-oz/sin(Etheta51),-(ox*c11+oy*s11)/sin(Etheta51));
Etheta2342 = atan2(-oz/sin(Etheta52),-(ox*c12+oy*s12)/sin(Etheta52));


% theta3 两个解
c31 = ((px*c11+py*s11-d5*sin(Etheta2341))^2+(pz-d1+d5*cos(Etheta2341))^2-(a2^2+a3^2))/(2*a2*a3);
s31 = sqrt(1-(c31)^2);
Etheta31 = atan2(s31,c31);
Etheta311 = atan2(-s31,c31);



c32 = ((px*c12+py*s12-d5*sin(Etheta2342))^2+(pz-d1+d5*cos(Etheta2342))^2-(a2^2+a3^2))/(2*a2*a3);
s32 = sqrt(1-(c32)^2);
Etheta32 = atan2(s32,c32);
Etheta322 = atan2(-s32,c32);






% theta4 两个解
m1 = 2*a2*d5*cos(Etheta31)+2*a3*d5;
n1 = 2*a2*d5*sin(Etheta31);
s411 = (  (px*c11+py*s11)^2 + (pz-d1)^2 - (a2^2+a3^2+d5^2)- (2*a2*a3*cos(Etheta31)) ) / sqrt(m1^2+n1^2);
c411 = sqrt(1-(s411)^2);
Etheta411a = atan2(s411,c411)+ atan2(n1,m1);
Etheta411b = atan2(s411,-c411)+ atan2(n1,m1);

m2 = 2*a2*d5*cos(Etheta311)+2*a3*d5;
n2 = 2*a2*d5*sin(Etheta311);
s412 = ((px*c11+py*s11)^2+(pz-d1)^2-(a2^2+a3^2+d5^2)-2*a2*a3*cos(Etheta311))/sqrt(m2^2+n2^2);
c412 = sqrt(1-(s412)^2);
Etheta412a = atan2(s412,c412) + atan2(n2,m2);
Etheta412b = atan2(s412,-c412) + atan2(n2,m2);


m3 = 2*a2*d5*cos(Etheta32)+2*a3*d5;
n3 = 2*a2*d5*sin(Etheta32);
s421 = ((px*c12+py*s12)^2+(pz-d1)^2-(a2^2+a3^2+d5^2)-2*a2*a3*cos(Etheta32))/sqrt(m3^2+n3^2);
c421 = sqrt(1-(s421)^2);
Etheta421a = atan2(s421,c421)+ atan2(n3,m3);
Etheta421b = atan2(s421,-c421)+ atan2(n3,m3);

m4 = 2*a2*d5*cos(Etheta322)+2*a3*d5;
n4 = 2*a2*d5*sin(Etheta322);
s422 = ((px*c12+py*s12)^2+(pz-d1)^2-(a2^2+a3^2+d5^2)-2*a2*a3*cos(Etheta322))/sqrt(m4^2+n4^2);
c422 = sqrt(1-(s422)^2);
Etheta422a = atan2(s422,c422) + atan2(n4,m4);
Etheta422b = atan2(s422,-c422)+ atan2(n4,m4);

% theta2
Etheta20  = Etheta2341 + Etheta31 - Etheta411a ;
Etheta21 = Etheta2341 + Etheta31 - Etheta411b ;

Etheta22 = Etheta2341 + Etheta311 - Etheta412a ;
Etheta23 = Etheta2341 + Etheta311 - Etheta412b ;

Etheta24 = Etheta2342 + Etheta32 - Etheta421a ;
Etheta25 = Etheta2342 + Etheta32 - Etheta421b ;
Etheta26 = Etheta2342 + Etheta322 - Etheta422a ;
Etheta27 = Etheta2342 + Etheta322 - Etheta422b ;

 EE = [Etheta11    Etheta20       Etheta31        Etheta411a      Etheta51;
       Etheta11     Etheta21       Etheta31       Etheta411b      Etheta51;

       Etheta11     Etheta22       Etheta311      Etheta412a      Etheta51;
       Etheta11     Etheta23       Etheta311      Etheta412b      Etheta51;


       Etheta12     Etheta24       Etheta32       Etheta421a      Etheta52;
       Etheta12     Etheta25       Etheta32       Etheta421b      Etheta52;

       Etheta12     Etheta26       Etheta322      Etheta422a     Etheta52;
       Etheta12     Etheta27       Etheta322      Etheta422b     Etheta52;];

       
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
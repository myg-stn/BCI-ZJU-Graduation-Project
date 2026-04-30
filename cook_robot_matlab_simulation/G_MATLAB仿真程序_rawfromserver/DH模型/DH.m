clear all
clc
theta1 = 0;
theta2 = 0;
theta3 = 0;


L(1)=Link([0       104       0        pi/2  ]);
L(2)=Link([0         0     -300           pi  ]);
L(3)=Link([0         0     -250           pi  ]);
L(4)=Link([0       100       0        pi/2  ]);
L(5)=Link([0       250       0           0  ]);
baseL = transl(-152,0,1300)*troty(0); %基座高度
L= SerialLink(L,'name','fourarmL','base',baseL);
% L.tool=[0,0,250];

R(1)=Link([0       104       0        -pi/2  ]);
R(2)=Link([0         0     -300          -pi   ]);
R(3)=Link([0         0     -250          -pi   ]);
R(4)=Link([0       100       0       -pi/2   ]);
R(5)=Link([0       250       0          0   ]);
baseR = transl(152,0,1300)*troty(0)*trotz(180); %基座高度

R= SerialLink(R,'name','fourarmR','base',baseR);
% R.tool=[0,0,250]; 
%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%%%%%%%%%%   platform

view(3)
hold on
grid on
axis([-1200, 1200, -1200, 1200, 500, 1500])

L.teach(); 
hold on


R.teach();
hold on
xlabel("X/mm")
ylabel("Y/mm")
zlabel("Z/mm")
title("机械臂模型")

clear all;
clc;




L(1)=Link([0     53      0        pi/2        ]);
L(2)=Link([0      0      -259       pi         ]);
L(3)=Link([0      0       -246.5       pi         ]);
L(4)=Link([0       98      0        pi/2       ]);
L(5)=Link([0       291.66      0        0          ]);
p560L= SerialLink(L,'name','fourarm');
view(3)
hold on
grid on
axis([-1200, 1200, -1200, 1200, -1200, 1200])

hold on

p560L.teach();
hold on
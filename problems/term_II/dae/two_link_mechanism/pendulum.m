%
% Основной исполняемый файл-скрипт 
%
clc;
% Объявляем глобальные переменные с параметрами системы
global m1 m2 L1 L2 J1 J2;

% масса стержня, половина длины стержня и его момент инерции относительно
% оси Oz
m1 = 1; L1 = 1; J1=(m1*L1^2)/12;
m2 = 1; L2 = 1; J2=(m2*L2^2)/12;

%
% Начальные условия движения
%
x10  = 0; % начальное положение ЦМ стержня 1, координата x
y10  = 0.5*L1; % начальное положение ЦМ стержня 1, координата y
f10  = pi/2; % начальное положение стержня 1, угол поворота
vx10 = 0; % начальное положение ЦМ стержня 1, координата x
vy10 = 0; % начальное положение ЦМ стержня 1, координата y
w10  = 0; % начальное положение стержня 1, угол поворота

x20  = 0;   % начальное положение ЦМ стержня 2, координата x
y20  = 0.5*L2; % начальное положение ЦМ стержня 2, координата y
f20  = -pi/2; % начальное положение стержня 2, угол поворота
vx20 = 0; % начальное положение ЦМ стержня 2, координата x
vy20 = 0; % начальное положение ЦМ стержня 2, координата y
w20  = 0; % начальное положение стержня 2, угол поворота
%
% Формируем матрицу начальных условий
%
q0 = [x10;y10;f10;vx10;vy10;w10;x20;y20;f20;vx20;vy20;w20];
clc;
[t,q] = ode113(@dqdt, [0:0.02:5], q0);

%
hold on
axis([-0.5 , 2.5, -1.5, +1.5]);

for i=1:size(t)
    cla;
    
    xA  = q(i,1)-L1*0.5*cos(q(i,3));
    yA  = q(i,2)-L1*0.5*sin(q(i,3));
    
    xB1 = q(i,1)+L1*0.5*cos(q(i,3));
    yB1 = q(i,2)+L1*0.5*sin(q(i,3));    
    
    xB2 = q(i,7)-L2*0.5*cos(q(i,9));
    yB2 = q(i,8)-L2*0.5*sin(q(i,9));    
    
    xC2 = q(i,7)+L2*0.5*cos(q(i,9));
    yC2 = q(i,8)+L2*0.5*sin(q(i,9));    
    
    line([xA xB1],  [yA  yB1] ,'LineWidth',6,'Color','Red');
    line([xB2 xC2], [yB2 yC2],'LineWidth',6,'Color','Blue');
    
    grid on;
    
    getframe;
    
end
hold off;

%%
plot(t,q(:,3)*180/pi,'LineWidth',3)
hold on;
plot(t,q(:,9)*180/pi,'LineWidth',3)
hold off;
%%
plot(t,q(:,6)*180/pi,'LineWidth',3)
hold on;
plot(t,q(:,12)*180/pi,'LineWidth',3)
hold off;




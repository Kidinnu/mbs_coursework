function [value, isterminal, direction] = event(t, q, params)

y   = q(1);
z   = q(2);
phi = q(3);

vy  = q(4);
vz  = q(5);
dphi= q(6);

% Вызываем функцию вычисления правых частей ДУ, которая возвращает ускорения
% и реакции Ra, Rb. Ускорения здесь нам не нужны (они нужны интегратору).
[~, Ra, Rb, zB, yA, zA, yB, Fp] = dqdt(t, q, params);

% Пока направляющая кубсата прижата к верхней и нижней стенке, 
% Ra > 0 и Rb > 0
% Ожидается, что первой подойдёт к нулю реакция Rb
% Таким образом, отслеживается два возможных события:
% 1. прохождение через 0 значения Ra (из положительных значений)
% 2. прохождение через 0 значения Rb (из положительных значений)

% Looking for crossing zero of the reactions Ra and Rb 
% and и выход из спутника из контейнера (когда zB становится больше L) 
value     = [Ra Rb*(params.L-zB)];

% we are looking for decreasing Ra and Rb
direction = [-1 -1];

% Оба "отслеживания" включены (не ноль)
% value     = [+1 +1];
% Теперь, если Ra или Rb пересечёт 0, то процесс интегрирования остановится

% ...но, после того, как реакция Ra, как мы ожидаем, первая достигнет 0, 
% нам уже не нужно отслеживать её значение, т.к. эта связь будет отключена
% и реакции не будет (т.к. не будет точки контакта), следовательно, нам нужна 
% некоторая переменная-индикатор, по значению которой можно будет узнать
% выключена связь или нет. 
% isterminal = 1 when если нужно остановить процесс или 0, если нет.
isterminal = [params.isRa params.isRb];  

% params.isRa = 1 if the contraints is ON, contact point А exists
% params.isRb = 1 if the contraints is ON, contact point B exists
% else = 0 

end


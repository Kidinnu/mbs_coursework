Пример (шаблон) программы для курсовой работы. Моделирование движения системы твердых тел, соединенных цилиндрическими, универсальными или сферическими шарнирами, используя алгоритм формирования уравнений движения Й. Виттенбурга. 

# Files 

## model.m

Файл-скрипт model.m -- это основной модуль программы, который содержит описание модели, код для запуска процесса интегрирования уравнений движения (автор [Ishan Patel](https://github.com/patelishan2235))

## preproc.m

Файл-скрипт preproc.m выполняет подготовку данных: вычисляет векторы $d_{ij}$, $b_{i0}$ перед началом процесса интегрироания. 

## ode_dqdt.m 

Функция правых частей дифференциальных уравнений (не зависит от параметро модели)

## getForces.m 

Функция getForces возвращает 3xn матрицу внешних сил, действующих на каждое тело в системе координат $Ox_0y_0z_0$.

## getTorques.m 

Функция getTorques возвращает 3xn матрицу внешних моментов, действующих на каждое телов системе координат, связанной с телом.

## Пример 

Файл model.m содержит описание модели механической системы, представленной на рисунке.  

![Model](model.png)

Image by [Ishan Patel](https://github.com/patelishan2235)








/* 1. Создайте функцию, которая делает бэкап таблицы customers (копирует все данные в другую таблицу),
стирая таблицу для бэкапа, если такая уже существует
*/

create or replace function backup_customers () returns void as $$
	
	drop table if exists test.backedup_customers;
	create table test.backedup_customers as
	select * from test.customers;	
	--select * into test.backedup_customers
	--from test.customers;

$$ language sql;

select test.backup_customers();

select * from test.backedup_customers;

--2. Создать функцию, которая возвращает средний фрахт (freight) по всем заказам

create or replace function average_freight() returns float4 as $$
	select avg(freight)
	from test.orders;
$$ language sql;

select * from test.average_freight();

/* 3.Написать функцию, которая принимает два целочисленных параметра, используемых
	как нижняя и верхняя границы для генерации случайного числа в пределах этой границы
	(включая сами граничные значения).
	Функция random генерирует вещественное число от 0 до 1
	Необходимо вычислить разницу между границами и прибавить 1
	На полученное число умножить результат функции random и прибавить 
	к результату значение нижней границы.
	Применить функцию floor, чтобы не уехать за границу и получить целое число
 */

create or replace function between_random(low int, high int) returns int as $$
	select floor(random() *((high - low) + 1) + low);
$$ language sql;

select * from test.between_random (1, 15);

--4. Создать функцию, которая возвращает самого молодого и самого старого сотрудника в заданном городе

create or replace function young_old_employees (_city varchar, out _old date, out _young date) as $$
	select min(birth_date), max(birth_date)
	from test.employees
	where city = _city;
$$ language sql;

select * from test.young_old_employees('Redmond');

--4.1 Создать функцию, которая возвращает самые низкую и высокую зарплаты сотрудников в заданном городе

create or replace function min_max_salary (_city varchar, out _min int, out _max int) as $$
	select min(e.salary), max(e.salary)
	from test.employees e
	where _city = e.city;
$$ language sql;

select * from min_max_salary('London'); 

/*5. Создать функцию, которая корректирует зарплату на заданный процент, но не корректирует зарплату
если её уровень превышает заданный уровень, при этом верхний уровень зарплаты, по умолчанию, равен 70,
а процент коррекции равен 15
*/

create or replace function salary_correct(_upper_boundary numeric default 70, _correction_rate numeric default 0.15)
returns void as $$
	update test.employees
	set salary = salary + (salary * _correction_rate)
	where salary <= _upper_boundary;
$$ language sql;

select * from salary_correct(50, 0.1);

--6. Скорректировать предыдущую функцию таким образом, чтобы она также бы выводила измененные записи

drop function if exists salary_correct;

create or replace function salary_correct(_upper_boundary numeric default 70, _correction_rate numeric default 0.15)
returns setof test.employees as $$
	update test.employees 
	set salary = salary + (salary * _correction_rate)
	where salary <= _upper_boundary
	returning *;
$$ language sql;

select * from salary_correct();

/*7. Модифицировать предыдущую функцию так, чтобы она возвращала только колонки
last_name, first_name, title, salary
*/

drop function if exists salary_correct;

create or replace function salary_correct(_upper_boundary numeric default 70, _correction_rate numeric default 0.15)
returns table (last_name text, first_name text, title text, salary numeric) as $$
	update test.employees 
	set salary = salary + (salary * _correction_rate)
	where salary <= _upper_boundary
	returning last_name, first_name, title, salary;
$$ language sql;

select * from salary_correct();

/*8. Написать функцию, которая принимает метод доставки и возвращает записи из
таблицы orders, в которых freight меньше значения, определяемого по следующему алгоритму:

- ищем максимум фрахта (freight) среди заказов по заданному методу доставки
- корректируем найденный максимум на 30% в сторону уменьшения
- вычисляем среднее значение фрахта по заданному методу доставки
- вычисляем среднее значение между средним найденным на предыдущем шаге и скорректированным максимумом
- возвращаем все заказы, в которых значение фрахта меньше найденного на предыдущем шаге среднего
*/ 

create or replace function get_orders_by_shipping(_ship_method int) returns setof test.orders as 
$$
declare 
_average numeric;
_maximum numeric;
_middle numeric;
begin 
	select max(orders.freight) into _maximum
	from test.orders
	where orders.ship_via = _ship_method;

	_maximum = _maximum - (_maximum * 0.3);

	select avg(orders.freight) into _average
	from test.orders
	where orders.ship_via = _ship_method;

	_middle = (_maximum + _average) / 2;

return query 
select *
from test.orders
where orders.freight < _middle;

end
$$ language plpgsql;

select * from get_orders_by_shipping(1);

/* 9. Написать функцию, которая принимает:

уровень зарплаты, максимальную зарплату (по умолчанию 80), минимальную зарплату (по умолчанию 30),
коэффициент роста зарплаты (по умолчанию 20%)

- Если зарплата выше минимальной, то возвращает false,
- Если зарплата ниже минимальной, то увеличивает зарплату на коэффициент роста и проверяет, не станет ли зарплата после повышения превышать максимальную
- Если превысит, то возвращает false, в противном случае true

Проверить реализацию, передавая следующие параметры:
(где с - уровень зп, max - макс. уровень, min - мин. уровень, r - коэффициент)

c = 40,max = 80,min = 30, r = 0.2 - false
c = 79,max = 81,min = 80, r = 0.2 - false
c = 79,max = 95,min = 80, r = 0.2 - true
*/

drop function if exists should_increase_salary;

create or replace function should_increase_salary(
_cur_salary numeric, 
_max_salary numeric default 80,
_min_salary numeric default 30,
_increase_rate numeric default 0.2
) returns bool as 
$$
declare
	_new_salary numeric;
begin
	if _cur_salary >= _max_salary or _cur_salary >= _min_salary then 
		return false;
	end if;

	if _cur_salary < _min_salary then
	_new_salary = _cur_salary + (_cur_salary * _increase_rate);
	end if;

	if _new_salary > _max_salary then
		return false;
	else 
		return true;
	end if;
	
end
$$ language plpgsql;

select * from should_increase_salary (40,80,30,0.2);
select * from should_increase_salary (79,81,80,0.2);
select * from should_increase_salary (79,95,80,0.2);




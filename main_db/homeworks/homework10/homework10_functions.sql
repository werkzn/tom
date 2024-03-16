/*1.Создайте функцию, которая делает бэкап таблицы customers (копирует данные в другую таблицу),
	предварительно стирая таблицу для бэкапа, если такая уже существует, чтобы в случае многократного
	бэкапа таблица перезаписывалась
*/
create or replace function test.customers_backup() returns void as $$
	drop table if exists test.customers_backup_table;
	create table test.customers_backup_table as
	(select * from test.customers);
$$ language sql;
-- Проверим функцию
select test.customers_backup();

--2. Создать функцию, которая возвращает средний фрахт (freight) по всем заказам
create or replace function get_average_freight() returns float8 as $$
	select avg(freight)from test.orders;
$$ language sql;
-- Проверим функцию
select get_average_freight();

/*3.Написать функцию, которая принимает два целочисленных параметра, используемых
	как нижняя и верхняя границы для генерации случайного числа в пределах этой границы
	(включая сами граничные значения).
	Функция random генерирует вещественное число от 0 до 1
	Необходимо вычислить разницу между границами и прибавить 1
	На полученное число умножить результат функции random и прибавить 
	к результату значение нижней границы.
	Применить функцию floor, чтобы не уехать за границу и получить целое число
 */
create or replace function random_between(_low int, _high int) returns int as $$
begin
	return floor((random() * (_high -_low +1) +_low));
end;
$$ language plpgsql;
--Проверим функцию
select random_between(2, 5); 

--4. Создать функцию, которая возвращает самого молодого и самого старого сотрудника в заданном городе
create or replace function young_old_employee(_city varchar, out _min_birth_date date, out _max_birth_date date) as $$
select min(birth_date), max(birth_date)
from test.employees
where city = _city; --аргумент писать в кавычках не нужно, даже, если это варчар
$$ language sql;
--Проверим функцию
select * from young_old_employee('London');

--5. Простая функция для тренировки. Узнать какой сезон.
create or replace function get_season (_month_number int) returns text as $$
	declare 
		_season text;
	begin
		if _month_number in (1, 2, 12) then
			_season = 'Winter';
		elseif _month_number between 3 and 5 then 
			_season = 'Spring';
		elseif _month_number between 6 and 8 then 
			_season = 'Summer';
		else _season = 'Autumn';
		end if;
	return _season;
	end;
$$ language plpgsql;
-- Проверим нашу функцию
select get_season(9);


--1. Выбрать все записи заказов, в которых наименование страны отгрузки начинается с U
select *
from orders
where ship_country like 'U%';

--2. Выбрать записи заказов (включить колонки идентификатора заказа, идентификатора заказчика, веса и страныотгрузки), которые должны быть отгружены в страны, имя которых начинается с N, отсортировать по весу (по убыванию), и вывести только первые 10 записей
select order_id, customer_id, freight, ship_country
from orders
where ship_country like 'N%'
order by freight desc 
limit 10;

--3. Выбрать записи работников (включить колонки имени, фамилии, телефона, региона), в которых регион неизвестен
select first_name, last_name, home_phone, region
from employees
where 
region is null;

--4. Подсчитать количество заказчиков, регион которых известен
select count(customer_id)
from customers
where 
region is not null;

--5. Подсчитать количество поставщиков в каждой из стран и отсортировать результаты групировки по убыванию количества
select country, count(supplier_id)
from suppliers
group by country
order by count(supplier_id) desc;

--6. Подсчитать суммарный вес заказов (в которых известен регион) по странам, затем отфильтровать по суммарному весу (вывести только те записи, где суммарный вес больше 2750) иотсортировать по убыванию суммарного веса
select ship_country, sum (freight)
from orders
where ship_region is not null
group by ship_country
having sum (freight) >= 2750
order by sum (freight) desc;

--7. Выбрать все уникальные страны заказчиков и поставщиков и отсортировать страны по возрастанию
select country
from customers
union
select country
from suppliers
order by country;

--8. Выбрать такие страны, в которых зарегистрированы одновременно и заказчики, и поставщики, и работники
select country 
from customers
intersect
select country 
from suppliers
intersect
select country 
from employees;

--9. Выбрать такие страны, в которых одновременно зарегистрированы заказчики и поставщики, но не зарегистрированы работники
select country
from customers
intersect
select country 
from suppliers
except
select country 
from employees;
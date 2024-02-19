--1. Выбрать все заказы из стран France, Austria, Spain
select *
from
orders
where ship_country in ('France', 'Austria', 'Spain');

--2. Выбрать все заказы, отсортировать по required_date (по убыванию) и отсортировать по дате отгрузки (по возрастанию)
select * 
from
orders
order by required_date desc, shipped_date asc;

--3. Выбрать минимальную цену тех продуктов, которых в продаже более 30 единиц
select min(unit_price)
from 
products 
where 
units_in_stock > 30;

--4. Выбрать максимальное количество единиц товара среди тех продуктов, цена которых больше 30
select max(units_in_stock)
from 
products 
where 
unit_price > 30;

--5. Найти среднее значение дней, уходящих на доставку с даты формирования заказа в USA
select avg(shipped_date - order_date)
from 
orders 
where 
ship_country = 'USA';

--6. Найти сумму, на которую имеется товаров (кол-во * цену), причем таких, которые планируется продавать и в будущем (см. поле discontinued)
select sum(units_in_stock * unit_price)
from 
products
where 
discontinued <> 1;

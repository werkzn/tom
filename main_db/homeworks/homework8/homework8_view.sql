/*1. Создать представление, которое выводит следующие колонки
	order_date, required_date, shipped_date, ship_postal_code, company_name,
	contact_name, phone, last_name, first_name, title из таблиц orders, customers, employees
*/
create or replace view v_orders_customers_employees as
select
order_date,
required_date,
shipped_date,
ship_postal_code,
company_name,
contact_name,
phone,
last_name,
first_name,
title
from orders o 
left join customers c on c.customer_id = o.customer_id
left join employees e on e.employee_id = o.employee_id;

-- Сделать селект с созданному представлению, выведя все таблицы, где order_date больше 1 января 1997 года
select * 
from v_orders_customers_employees
where order_date > '19970101';

/*2. Создать представление, которое выводит следующие колонки
	order_date, required_date, shipped_date, ship_postal_code, company_name,
	contact_name, phone, last_name, first_name, title из таблиц orders, customers, employees
*/
create or replace view v_old_orders_customers_employees as
select
order_date,
required_date,
shipped_date,
ship_postal_code,
company_name,
contact_name,
phone,
last_name,
first_name,
title
from orders o 
left join customers c on c.customer_id = o.customer_id
left join employees e on e.employee_id = o.employee_id;

/*Попробовать добавить к представлению (после его создания) колонки ship_country, postal_code, reports_to
Убедиться, что стреляет ошибка. Переименовать представление и создать новое уже с дополнительными колонкам
*/
alter view v_old_orders_customers_employees
add_column ship_country, postal_code, reports_to;

alter view v_old_orders_customers_employees rename to v_old_oce;

create or replace view v_old_orders_customers_employees as
select
order_date,
required_date,
shipped_date,
ship_postal_code,
company_name,
contact_name,
phone,
last_name,
first_name,
title,
ship_country,
c.postal_code,
reports_to
from orders o 
left join customers c on c.customer_id = o.customer_id
left join employees e on e.employee_id = o.employee_id;

--Сделать к нему запрос, отфильтровав по ship_country
select * from v_old_orders_customers_employees
where ship_country = 'France';

--Удалить переименованное представление
drop view v_old_oce;

--3. Создать представление активных (discontinued = 0) продуктов, содержащее все колонки. Представление должно быть защищено от вставки записей discontinued = 1
create or replace view v_products_active as
select *
from products
where discontinued = 0
with local check option;

--Попробовать сделать вставку записи с полем discontinued = 1, и убедиться, что проверка работает
insert into v_products_active
values
(100, 'test', 1, 2, '15pkgs.', 12, 100, 5, 0, 1);


--1. Найти заказчиков и, обслуживающих их заказы сотрудников таких, что и заказчики и и сотрудники из города Лондон, а доставка идет компанией Speedy Express. Вывести компанию заказчика и фио сотрудника 
select c.company_name, concat(e.first_name,' ', e.last_name)
from orders o 
join customers c on c.customer_id = o.customer_id 
join employees e on e.employee_id = o.employee_id
join shippers s on s.shipper_id = o.ship_via 
where c.city = 'London'
and e.city = 'London'
and s.company_name like 'Speedy%' --лучше использовать AND. Это намного удобнее
order by c.company_name;

--2. Найти активные (см. поле discontinued) продукты из категории beverages и seafood, которых в продаже менее 20 единиц. Вывести наименование продуктов, кол-во единиц в продаже, имя контакта поставщика и его номер телефона
select p.product_name, p.units_in_stock, s.contact_name, s.phone
from products p 
join suppliers s on s.supplier_id = p.supplier_id 
join categories c on c.category_id = p.category_id 
where c.category_id in (1, 8)
and p.discontinued <> 1
and p.units_in_stock < 20;

--3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и order_id
select o.order_id, c.contact_name
from orders o 
right join customers c on c.customer_id = o.customer_id 
where 
o.order_id is null;

--4. Переписать предыдущий запрос, используя симметричный вид джойна (left, right)
select o.order_id, c.contact_name
from customers c 
left join orders o on o.customer_id = c.customer_id 
where 
o.order_id is null
order by contact_name;
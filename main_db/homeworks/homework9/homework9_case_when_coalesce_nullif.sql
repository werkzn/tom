/*1. Выполните следующий код (записи необходимы для тестирования корректности выполнения дз)
insert into customers (customer_id, contact_name, city, country, company_name)
values 
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria', 'fake_company');

После этого выполните задание:

Вывести имя контакта заказчика, его город, страну, отсортировав по возрастанию по имени контакта и городу,
а если город равен null, то по имени контакта и стране. ПРоверить результат, используя заранее вставленные строки.
*/
insert into customers (customer_id, contact_name, city, country, company_name)
values 
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria', 'fake_company');

select contact_name, city, country
from customers 
order by contact_name,
(	
    case when city is null then country 
		 else city 
	end
);

/*2. Вывести наименование продукта, цену продукта и столбец со значениями
 		too expensive если цена >=100
 		average если цена >=50 но <100
 		low price если цена <50
 */
select product_name, unit_price,
	case when unit_price >=100 then 'too expensive'
		 when unit_price >=50 and unit_price  <100 then 'average'
		 else 'low_price'
	end as price_info
from products
order by unit_price desc;

--3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и значение "no orders", если order_id = null
select c.contact_name, coalesce(o.order_id::text, 'no order') as orders_made
from customers c
left join orders o  on o.customer_id = c.customer_id
where o.order_id is null;

--4. Вывести ФИО сотрудников и их должности. В случае, если должность = Sales Representative, вывести вместо нее Sales Stuff
select concat(first_name,' ', last_name),
coalesce(nullif(title, 'Sales Representative'), 'Sales Stuff')
from employees;